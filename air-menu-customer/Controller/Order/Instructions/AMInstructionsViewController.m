//
//  AMInstructionsViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 13/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMInstructionsViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
@interface AMInstructionsViewController ()

@end

@implementation AMInstructionsViewController
-(id)init
{
    self = [super init];
    if(self)
    {
        self.title = @"Place";
        UILabel *label = [UILabel newAutoLayoutView];
        [self.view addSubview:label];
        label.text = @"Welcome";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:GOTHAM_XLIGHT size:25];
        [label autoCenterInSuperview];
    }
    return self;
}

@end
