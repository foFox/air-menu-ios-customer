//
//  AMTabBarViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 13/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMTabBarViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMTabBarViewController ()
//Containment
@property (nonatomic, readwrite, weak) UIViewController *currentViewController;
@property (nonatomic, readwrite) NSUInteger seletedIndex;
@property (nonatomic, readwrite, weak) UIView *container;

//UI
@property (nonatomic, readwrite, weak) UIScrollView *tabBar;
@property (nonatomic, readwrite, weak) UIView *spacer;
@property (nonatomic, readwrite, weak) UIView *marker;

//animation
@property (nonatomic, readwrite) BOOL isAnimating;
@end

@implementation AMTabBarViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self presentViewControllerAtIndex:0];
}
#pragma mark - Setup

-(void)setup
{
    [self createTabBar];
    [self createSpacer];
    [self createContainer];
}

-(void)createTabBar
{
    UIScrollView *tabBar = [UIScrollView newAutoLayoutView];
    self.tabBar = tabBar;
    [self.view addSubview:self.tabBar];
    [self.tabBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [self.tabBar autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
    [self.tabBar autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    [self.tabBar autoSetDimension:ALDimensionHeight toSize:60];
    self.tabBar.showsHorizontalScrollIndicator = NO;
}

-(void)createSpacer
{
    UIView *spacer = [UIView newAutoLayoutView];
    self.spacer = spacer;
    [self.view addSubview:self.spacer];
    [self.spacer autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.tabBar];
    [self.spacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.tabBar withOffset:20.0];
    [self.spacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.tabBar withOffset:-20.0];
    [self.spacer autoSetDimension:ALDimensionHeight toSize:0.5];
    self.spacer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
}

-(void)createContainer
{
    UIView *container = [UIView newAutoLayoutView];
    self.container = container;
    [self.view addSubview:self.container];
    self.container.translatesAutoresizingMaskIntoConstraints = NO;
    [self.container autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
    [self.container autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    [self.container autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [self.container autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.tabBar];
}

-(void)createMarker
{
    UIView *marker = [[UIView alloc] initWithFrame:CGRectZero];
    self.marker = marker;
    [self.tabBar addSubview:self.marker];
    self.marker.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:83.0f/255.0f alpha:1.0];
}
#pragma mark - Public API

-(void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    
    for (UIViewController *viewController in viewControllers)
    {
        viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [self.tabBar addSubview:button];
        [button setTitle:viewController.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:MENSCH_THIN size:30];
        [button setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:83.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        [button autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.tabBar];
        button.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
        button.layer.shadowOpacity = 1.0;
        button.layer.shadowRadius = 1.0;
        button.layer.shadowOffset = CGSizeMake(0.0f,1.0f);
        button.tag = [viewControllers indexOfObject:viewController];
        [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.tabBar.subviews autoDistributeViewsAlongAxis:ALAxisHorizontal withFixedSpacing:30 alignment:NSLayoutFormatAlignAllBottom];
    [self createMarker];
}

-(void)didTapButton:(UIButton *)button
{
    [self presentViewControllerAtIndex:button.tag];
    [self alignMarkerToView:button];
}

-(void)presentViewControllerAtIndex:(NSUInteger)index
{
    UIViewController *newViewController = self.viewControllers[index];
    UIViewController *currentViewController = self.currentViewController;
    
    if(self.currentViewController && newViewController != currentViewController && !self.isAnimating)
    {
        [currentViewController willMoveToParentViewController:nil];
        [self addChildViewController:newViewController];
        [self.container addSubview:newViewController.view];
        [newViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        if(index > self.seletedIndex)
        {
            newViewController.view.layer.transform = CATransform3DMakeTranslation(newViewController.view.layer.bounds.size.width, 0.0, 0.0);
        }
        else if(index < self.seletedIndex)
        {
            newViewController.view.layer.transform = CATransform3DMakeTranslation(-newViewController.view.layer.bounds.size.width, 0.0, 0.0);
        }
        
        self.isAnimating = YES;
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             newViewController.view.layer.transform = CATransform3DIdentity;
                             if(index > self.seletedIndex)
                             {
                                 currentViewController.view.layer.transform = CATransform3DMakeTranslation(-self.currentViewController.view.layer.bounds.size.width, 0.0, 0.0);
                             }
                             else if (index < self.seletedIndex)
                             {
                                 currentViewController.view.layer.transform = CATransform3DMakeTranslation(self.currentViewController.view.layer.bounds.size.width, 0.0, 0.0);
                             }
                         }
                         completion:^(BOOL finished) {
                             currentViewController.view.layer.transform = CATransform3DIdentity;
                             [currentViewController.view removeFromSuperview];
                             [currentViewController removeFromParentViewController];
                             [newViewController didMoveToParentViewController:self];
                             self.currentViewController = newViewController;
                             self.seletedIndex = index;
                             self.isAnimating = NO;
                         }];
    }
    else if(!self.currentViewController)
    {
        [self addChildViewController:newViewController];
        [self.container addSubview:newViewController.view];
        [newViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [newViewController didMoveToParentViewController:self];
        self.currentViewController = newViewController;
        self.seletedIndex = index;
    }
}

-(void)alignMarkerToView:(UIButton *)button
{
    if (button.tag!= self.seletedIndex)
    {
        CGSize textSize = [button.titleLabel.text sizeWithAttributes:@{ NSFontAttributeName:button.titleLabel.font }];
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGPoint newCenter = button.center;
                             newCenter.y = newCenter.y + (button.frame.size.height / 2) - 5;
                             self.marker.center = newCenter;
                             self.marker.bounds = CGRectMake(0, 0, textSize.width, 0.5);
                             
                         }
                         completion:nil];
        
    }
}
@end
