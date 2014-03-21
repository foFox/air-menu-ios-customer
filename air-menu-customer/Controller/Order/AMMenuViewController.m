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

typedef enum {AMMenuViewControllerStateSections, AMMenuViewControllerStateItems, AMMenuViewControllerStateItem } AMMenuViewControllerState;

@interface AMMenuViewController () <UICollectionViewDataSource, UICollectionViewDelegate, AMMenuSectionCellDelegate>
@property (nonatomic, readwrite, weak) UICollectionView *collectionView;
@property (nonatomic, readwrite) AMMenuViewControllerState currentState;

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
    self.currentState = AMMenuViewControllerStateSections;
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
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.collectionView registerClass:[AMMenuSectionCell class] forCellWithReuseIdentifier:@"menu_section_cell"];
    [self.collectionView registerClass:[AMMenuItemCell class] forCellWithReuseIdentifier:@"menu_item_cell"];
}

-(void)setRestaurant:(AMRestaurant *)restaurant
{
    _restaurant = restaurant;
    if(restaurant.menu)
    {
        [[AMClient sharedClient] findMenuWithIdentifier:[self.restaurant.menu.identifier description] completion:^(AMMenu *menu, NSError *error) {
            if(!error)
            {
                self.restaurantMenu = menu;
                [self updateView];
            }
        }];
    }
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.restaurantMenu.menuSections.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMMenuSectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menu_section_cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.restaurantMenu.menuSections[indexPath.row] name];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark - Collection View Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark - Menu Section Cell Delegate

-(void)didTapCell:(AMMenuSectionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if(self.currentState == AMMenuViewControllerStateSections)
    {
        [cell.button setStyle:kFRDLivelyButtonStyleCaretUp animated:YES];
        [self displayItemsInSection:self.restaurant.menu.menuSections[indexPath.row]];
    }
    else if (self.currentState == AMMenuViewControllerStateItems)
    {
        [cell.button setStyle:kFRDLivelyButtonStyleCaretUp animated:YES];
        [self displaySectionsOfMenu:self.restaurant.menu];
    }
}

-(void)displaySectionsOfMenu:(AMMenu *)menu
{
    self.currentState = AMMenuViewControllerStateSections;
}

-(void)displayItemsInSection:(AMMenuSection *)section
{
    self.currentState = AMMenuViewControllerStateItems;
}

#pragma mark - Private API

-(void)updateView
{
    [self.collectionView reloadData];
}
@end
