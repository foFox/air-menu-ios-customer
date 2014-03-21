//
//  AMMenuSectionCell.m
//  Air Menu C
//
//  Created by Robert Lis on 19/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuSectionCell.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMLineSpacer.h"

@interface AMMenuSectionCell()
@property (nonatomic, readwrite, weak) UILabel *textLabel;
@property (nonatomic, readwrite, weak) FRDLivelyButton *button;
@property (nonatomic, readwrite, weak) AMLineSpacer *lineSpacer;
@end

@implementation AMMenuSectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}


-(void)setup
{
    [self setupSpacer];
    [self setupLabel];
    [self setupButton];
}

-(void)setupLabel
{
    UILabel *textLabel = [UILabel newAutoLayoutView];
    self.textLabel = textLabel;
    [self.contentView addSubview:self.textLabel];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    self.textLabel.font = [UIFont fontWithName:GOTHAM_MEDIUM size:20.0f];
    self.textLabel.textColor = [UIColor whiteColor];
}

-(void)setupButton
{
    FRDLivelyButton *button = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.button = button;
    [self.contentView addSubview:self.button];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button autoSetDimension:ALDimensionHeight toSize:40.0];
    [self.button autoSetDimension:ALDimensionWidth toSize:40.0];
    [self.button autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    [self.button autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.textLabel];
    [self.button setStyle:kFRDLivelyButtonStyleCaretDown animated:NO];
    [self.button addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupSpacer
{
    AMLineSpacer *lineSpacer = [AMLineSpacer newAutoLayoutView];
    self.lineSpacer = lineSpacer;
    self.lineSpacer.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.contentView addSubview:self.lineSpacer];
    [self.lineSpacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView];
    [self.lineSpacer autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
    [self.lineSpacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [self.lineSpacer autoSetDimension:ALDimensionHeight toSize:0.5f];
    self.lineSpacer.shouldFade = NO;
}

-(void)didTap:(FRDLivelyButton *)button
{
    [self.delegate didTapCell:self atIndexPath:self.indexPath];
}
@end
