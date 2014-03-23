//
//  AMMenuViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 13/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuViewController.h"
#import "AMMenuSectionCell.h"
#import "AMMenuItemCell.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMMenuViewController ()
@end

@implementation AMMenuViewController

#pragma mark - Lifecycle

-(id)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    return self;
}

#pragma mark - Setup

-(void)setup
{
    [self setupCollectionView];
    [self setupStates];
    self.title = @"Menu";
}

-(void)setupCollectionView
{
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.collectionView registerClass:[AMMenuSectionCell class] forCellWithReuseIdentifier:@"menu_section_cell"];
    [self.collectionView registerClass:[AMMenuItemCell class] forCellWithReuseIdentifier:@"menu_item_cell"];
    self.collectionView.delegate = (id <UICollectionViewDelegate>) self;
    self.collectionView.dataSource = (id <UICollectionViewDataSource>) self;
}

-(void)setupStates
{
    self.sectionsState = [[AMMenuViewStateSections alloc] initWithController:self restaurant:self.restaurant collectionView:self.collectionView];
    self.itemsState = [[AMMenuViewStateItems alloc] initWithController:self restaurant:self.restaurant collectionView:self.collectionView];
    self.itemState = [[AMMenuViewStateItem alloc] initWithController:self restaurant:self.restaurant collectionView:self.collectionView];
    self.currentState = self.sectionsState;
}

-(void)setRestaurant:(AMRestaurant *)restaurant
{
    _restaurant = restaurant;
    if(restaurant.menu)
    {
        self.itemState.restaurant = restaurant;
        self.itemsState.restaurant = restaurant;
        self.sectionsState.restaurant = restaurant;
        
        [[AMClient sharedClient] findMenuWithIdentifier:[self.restaurant.menu.identifier description] completion:^(AMMenu *menu, NSError *error) {
            if(!error)
            {
                self.menu = menu;
                [self updateView];
            }
        }];
    }
}

#pragma mark - Private API

-(void)updateView
{
    [self.collectionView reloadData];
}

-(void)setCurrentState:(AMMenuViewState *)currentState
{
    _currentState = currentState;
}

-(void)setMenu:(AMMenu *)menu
{
    _menu = menu;
    self.itemsState.menu = menu;
    self.sectionsState.menu = menu;
    self.itemState.menu = menu;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if([self.currentState respondsToSelector:aSelector])
    {
        return self.currentState;
    }
    else
    {
        return nil;
    }
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector] || [self.currentState respondsToSelector:aSelector];
}

@end
