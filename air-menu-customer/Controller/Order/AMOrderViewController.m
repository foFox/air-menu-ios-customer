//
//  AMOrderViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 17/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMOrderViewController.h"
#import "AMRestaurantBeaconViewController.h"
#import "AMOrderCreatorViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMOrderViewController () <AMRestaurantBeaconViewControllerDelegate>
@property (nonatomic, readwrite, strong) AMRestaurantBeaconViewController *beaconsController;
@property (nonatomic, readwrite, strong) AMOrderCreatorViewController *orderCreatorController;
@property (nonatomic, readwrite, strong) AMRestaurant *currentRestaurant;
@end

@implementation AMOrderViewController

-(id)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.beaconsController.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
    self.beaconsController.view.layer.position = CGPointApplyAffineTransform(self.beaconsController.view.layer.position,
                                                                             CGAffineTransformMakeTranslation(0, -self.beaconsController.view.layer.bounds.size.height / 2));
    self.orderCreatorController.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
    self.orderCreatorController.view.layer.position = CGPointApplyAffineTransform(self.orderCreatorController.view.layer.position,
                                                                             CGAffineTransformMakeTranslation(0, -self.orderCreatorController.view.layer.bounds.size.height / 2));
    
}

-(void)setup
{
    [self presentBeaconsViewController];
}

-(AMRestaurantBeaconViewController*)beaconsController
{
    if(!_beaconsController)
    {
        _beaconsController = [AMRestaurantBeaconViewController new];
        _beaconsController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _beaconsController.delegate = self;
    }
    
    return _beaconsController;
}

-(AMOrderCreatorViewController *)orderCreatorController
{
    if(!_orderCreatorController)
    {
        _orderCreatorController = [AMOrderCreatorViewController new];
        _orderCreatorController.view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _orderCreatorController;
}

-(void)presentBeaconsViewController
{
    [self addChildViewController:self.beaconsController];
    [self.view addSubview:self.beaconsController.view];
    self.beaconsController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.beaconsController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.beaconsController didMoveToParentViewController:self];
}

-(void)dismissBeaconsViewController
{
    [self.beaconsController willMoveToParentViewController:nil];
    [self addChildViewController:self.orderCreatorController];
    [self.view addSubview:self.orderCreatorController.view];
    
    [self.orderCreatorController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.orderCreatorController.view.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180), 0, 0, 1.0);
    self.orderCreatorController.currentRestaurant = self.currentRestaurant;
    
    [UIView animateWithDuration:1.5
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.beaconsController.view.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(179), 0, 0, 1.0);
                         self.orderCreatorController.view.layer.transform = CATransform3DIdentity;
                     }
                     completion:^(BOOL finished) {
                         [self.orderCreatorController didMoveToParentViewController:self];
                         [self.beaconsController.view removeFromSuperview];
                         [self.beaconsController removeFromParentViewController];
                     }];
}

-(void)dismissOrderCreatorViewController
{
    [self.orderCreatorController willMoveToParentViewController:nil];
    
    [self.orderCreatorController removeFromParentViewController];
}

-(void)controller:(AMRestaurantBeaconViewController *)viewController didSelectRestaurant:(AMRestaurant *)restaurant
{
    self.currentRestaurant = restaurant;
    [self dismissBeaconsViewController];
}

@end
