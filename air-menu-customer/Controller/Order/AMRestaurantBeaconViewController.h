//
//  AMBeaconViewController.h
//  Air Menu C
//
//  Created by Robert Lis on 13/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMRestaurantBeaconViewControllerDelegate;
@class AMRestaurant;

@interface AMRestaurantBeaconViewController : UIViewController
@property (nonatomic, readwrite, weak) id <AMRestaurantBeaconViewControllerDelegate> delegate;
@end

@protocol AMRestaurantBeaconViewControllerDelegate <NSObject>
-(void)controller:(AMRestaurantBeaconViewController *)viewController didSelectRestaurant:(AMRestaurant *)restaurant;
@end