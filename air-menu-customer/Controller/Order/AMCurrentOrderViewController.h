//
//  AMOrderViewController.h
//  Air Menu C
//
//  Created by Robert Lis on 13/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMClient+Restaurant.h>

@interface AMCurrentOrderViewController : UIViewController
@property (nonatomic, readwrite, strong) AMRestaurant *restaurant;
@end
