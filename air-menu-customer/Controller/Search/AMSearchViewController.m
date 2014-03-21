//
//  AMSearchViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 17/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMSearchViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMSearchViewController ()

@end

@implementation AMSearchViewController
-(id)init
{
    self = [super init];
    if(self)
    {
        UILabel *label = [UILabel newAutoLayoutView];
        [self.view addSubview:label];
        label.text = @"search";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:GOTHAM_XLIGHT size:25];
        [label autoCenterInSuperview];
    }
    return self;
}

@end
