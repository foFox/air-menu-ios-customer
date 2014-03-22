//
//  AMPaymentViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 13/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMPaymentViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMPaymentViewController ()

@end

@implementation AMPaymentViewController

-(id)init
{
    self = [super init];
    if(self)
    {
        self.title = @"Pay";
        UILabel *label = [UILabel newAutoLayoutView];
        [self.view addSubview:label];
        label.text = @"Payment";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:GOTHAM_XLIGHT size:25];
        [label autoCenterInSuperview];
    }
    return self;
}

@end
