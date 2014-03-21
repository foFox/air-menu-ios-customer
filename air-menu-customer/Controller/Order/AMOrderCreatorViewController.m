//
//  AMOrderCreatorViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 14/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMOrderCreatorViewController.h"
#import "AMInstructionsViewController.h"
#import "AMMenuViewController.h"
#import "AMCurrentOrderViewController.h"
#import "AMPaymentViewController.h"

@interface AMOrderCreatorViewController ()

@end

@implementation AMOrderCreatorViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setViewControllers:@[[[AMInstructionsViewController alloc] init],
                                   [[AMMenuViewController alloc] init],
                                   [[AMCurrentOrderViewController alloc] init],
                                   [[AMPaymentViewController alloc] init]]];
    }
    return self;
}

-(void)setCurrentRestaurant:(AMRestaurant *)currentRestaurant
{
    _currentRestaurant = currentRestaurant;
    [self.viewControllers makeObjectsPerformSelector:@selector(setRestaurant:) withObject:_currentRestaurant];
}

@end
