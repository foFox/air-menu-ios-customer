//
//  DirectionPanGestureRecognizer.h
//  air-menu-customer
//
//  Created by Robert Lis on 02/12/2013.
//  Copyright (c) 2013 Air-menu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum {
    DirectionPangestureRecognizerVertical,
    DirectionPanGestureRecognizerHorizontal
} DirectionPangestureRecognizerDirection;

typedef enum {
    DirectionPangestureRecognizerAreaTop,
    DirectionPangestureRecognizerAreaBottom
} DirectionPangestureRecognizerArea;

@interface DirectionPanGestureRecognizer : UIPanGestureRecognizer {
    BOOL _drag;
    int _moveX;
    int _moveY;
    DirectionPangestureRecognizerDirection _direction;
    DirectionPangestureRecognizerArea _area;
    CGFloat _panStartAreaHeight;
    CGFloat _percentOfViewHeightToSwitchArea;
}

@property (nonatomic, assign) DirectionPangestureRecognizerDirection direction;
@property (nonatomic, assign) DirectionPangestureRecognizerArea area;
@property (nonatomic, assign) CGFloat panStartAreaHeight;
@property (nonatomic, assign) CGFloat percentOfViewHeightToSwitchArea;
-(CGFloat)percentPanned;
@end