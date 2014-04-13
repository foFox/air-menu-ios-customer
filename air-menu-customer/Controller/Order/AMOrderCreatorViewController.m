//
//  AMOrderCreatorViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 14/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMOrderCreatorViewController.h"
#import "AMInstructionsViewController.h"
#import "AMMenuViewController.h"
#import "AMCurrentOrderViewController.h"
#import "AMPaymentViewController.h"

@interface AMOrderCreatorViewController ()

@end

@implementation AMOrderCreatorViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setViewControllers:@[[[AMInstructionsViewController alloc] init],
                                   [[AMMenuViewController alloc] init],
                                   [[AMCurrentOrderViewController alloc] init],
                                   [[AMPaymentViewController alloc] init]]];
        self.view.layer.contents = (id) [self backgroundImage].CGImage;
    }
    return self;
}

-(void)setCurrentRestaurant:(AMRestaurant *)currentRestaurant
{
    _currentRestaurant = currentRestaurant;
    [self.viewControllers makeObjectsPerformSelector:@selector(setRestaurant:) withObject:_currentRestaurant];
}

-(UIImage *)backgroundImage
{
    id delegate = [UIApplication sharedApplication].delegate;
    CGSize size = [delegate window].bounds.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBackgroundImageInContext:context withSize:size];
    UIImage *background =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return background;
}

-(void)drawBackgroundImageInContext:(CGContextRef)context withSize:(CGSize)size
{
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[2] = { 0.0, 1.0 };
    NSArray *colors = @[(id)[UIColor colorWithRed:18/255.0f green:115/255.0f blue:160/255.0f alpha:1.0].CGColor,
                        (id)[UIColor colorWithRed:203/255.0f green:177/255.0f blue:153/255.0f alpha:1.0].CGColor];
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    CGPoint startPoint, endPoint;
    startPoint.x = 0.0;
    startPoint.y = 0.0;
    endPoint.x = size.width;
    endPoint.y = size.height;
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}


@end
