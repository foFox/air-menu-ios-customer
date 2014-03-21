//
//  AMOrderCreatorViewController.h
//  Air Menu C
//
//  Created by Robert Lis on 14/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMTabBarViewController.h"
#import <AirMenuKit/AMClient+Restaurant.h>
@interface AMOrderCreatorViewController : AMTabBarViewController
@property (nonatomic, readwrite, strong) AMRestaurant *currentRestaurant;
@end
