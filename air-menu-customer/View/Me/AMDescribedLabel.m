//
//  AMDescribedLabel.m
//  Air Menu C
//
//  Created by Robert Lis on 19/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMDescribedLabel.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMDescribedLabel()
@property (nonatomic, readwrite, weak) UILabel *titleLabel;
@property (nonatomic, readwrite, weak) UILabel *textLabel;
@end


@implementation AMDescribedLabel

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

#pragma mark - Setup

-(void)setup
{
    [self setupTitleLabel];
    [self setupTextLabel];
}

-(void)setupTitleLabel
{
    UILabel *titleLabel = [UILabel newAutoLayoutView];
    self.titleLabel = titleLabel;
    [self addSubview:self.titleLabel];
    [self.titleLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self];
    [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:15];
}

-(void)setupTextLabel
{
    UILabel *textLabel = [UILabel newAutoLayoutView];
    self.textLabel = textLabel;
    [self addSubview:self.textLabel];
    [self.textLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self];
    [self.textLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:10];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:20];
    
}

@end
