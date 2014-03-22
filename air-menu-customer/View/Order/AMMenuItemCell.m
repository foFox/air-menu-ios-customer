//
//  AMMenuItemView.m
//  Air Menu C
//
//  Created by Robert Lis on 21/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuItemCell.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMMenuItemCell()
@property (nonatomic, readwrite, weak) UILabel *itemNameLabel;
@property (nonatomic, readwrite, weak) UILabel *itemDescriptionLabel;
@property (nonatomic, readwrite, weak) UILabel *itemPriceLabel;
@property (nonatomic, readwrite, weak) AXRatingView *ratingView;
@end

@implementation AMMenuItemCell

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
    [self createItemNameLabel];
    [self createItemPriceLabel];
    [self createItemDescriptionLabel];
    [self createItemRatingView];
}

-(void)createItemNameLabel
{
    UILabel *itemNameLabel = [UILabel newAutoLayoutView];
    self.itemNameLabel = itemNameLabel;
    [self.contentView addSubview:self.itemNameLabel];
    [self.itemNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0f];
    [self.itemNameLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
}

-(void)createItemPriceLabel
{
    UILabel *itemPriceLabel = [UILabel newAutoLayoutView];
    self.itemPriceLabel = itemPriceLabel;
    [self.contentView addSubview:self.itemPriceLabel];
    [self.itemPriceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0f];
    [self.itemPriceLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    itemPriceLabel.numberOfLines = 0;
}

-(void)createItemDescriptionLabel
{
    UILabel *itemDescriptionLabel = [UILabel newAutoLayoutView];
    self.itemDescriptionLabel = itemDescriptionLabel;
    [self.contentView addSubview:self.itemDescriptionLabel];
    [self.itemDescriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.itemNameLabel];
    [self.itemDescriptionLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [self.itemDescriptionLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    [self.itemDescriptionLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-20.0];
}

-(void)createItemRatingView
{
    
}

@end
