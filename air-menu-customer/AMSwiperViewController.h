//
//  AMSwiperViewController.h
//  air-menu-customer
//
//  Created by Robert Lis on 02/12/2013.
//  Copyright (c) 2013 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMSwiperViewController : UIViewController
@property (nonatomic, readonly) NSArray *viewConrollers;
@property (nonatomic, weak, readonly) UIViewController *displayedController;
@property (nonatomic, readonly) NSUInteger indexOfDisplayedController;
-(void)setViewControllers:(NSArray *)viewControllers;
@end
