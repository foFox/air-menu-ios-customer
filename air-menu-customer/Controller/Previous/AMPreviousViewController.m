//
//  AMPreviousViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 17/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMPreviousViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMPreviousViewController ()

@end

@implementation AMPreviousViewController

-(id)init
{
    self = [super init];
    if(self)
    {
        UILabel *label = [UILabel newAutoLayoutView];
        [self.view addSubview:label];
        label.text = @"previous";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:GOTHAM_XLIGHT size:25];
        [label autoCenterInSuperview];
    }
    return self;
}


@end
