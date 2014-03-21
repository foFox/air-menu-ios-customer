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
    
}

-(void)createItemPriceLabel
{
    
}

-(void)createItemDescriptionLabel
{
    
}

-(void)createItemRatingView
{
    
}

@end
