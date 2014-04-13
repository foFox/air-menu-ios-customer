//
//  AMSearchViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 17/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMSearchViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import <MapKit/MapKit.h>

@interface AMSearchViewController () <MKMapViewDelegate>
@property (nonatomic, readwrite, weak) MKMapView *mapView;
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
        self.view.layer.contents = (id) [self backgroundImage].CGImage;
        MKMapView *mapView = [[MKMapView alloc] initForAutoLayout];
        self.mapView = mapView;
        self.mapView.delegate = self;
        [self.view addSubview:self.mapView];
        self.mapView.showsUserLocation = YES;
        mapView.camera = [MKMapCamera camera];
        [self.mapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    return self;
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

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.001;
    mapRegion.span.longitudeDelta = 0.001;
    [mapView setRegion:mapRegion animated: NO];
}
@end
