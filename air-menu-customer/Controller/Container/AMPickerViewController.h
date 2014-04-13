//
//  UITableViewController+AMPickerViewController.h
//  Air Menu C
//
//  Created by Robert Lis on 13/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MSDynamicsDrawerViewController/MSDynamicsDrawerStyler.h>

@interface AMPickerViewController : UITableViewController
@property (nonatomic, readwrite, weak) MSDynamicsDrawerViewController *controller;
@end
