//
//  AMOrderViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 13/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMCurrentOrderViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMCurrentOrderViewController ()

@end

@implementation AMCurrentOrderViewController
-(id)init
{
    self = [super init];
    if(self)
    {
        self.title = @"Order";
        UILabel *label = [UILabel newAutoLayoutView];
        [self.view addSubview:label];
        label.text = @"Order";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:GOTHAM_XLIGHT size:25];
        [label autoCenterInSuperview];
    }
    return self;
}
@end
