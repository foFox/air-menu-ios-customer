//
//  DirectionPanGestureRecognizer.m
//  air-menu-customer
//
//  Created by Robert Lis on 02/12/2013.
//  Copyright (c) 2013 Air-menu. All rights reserved.
//

#import "DirectionPanGestureRecognizer.h"

int const static kDirectionPanThreshold = 5;

@implementation DirectionPanGestureRecognizer

@synthesize direction = _direction;
@synthesize area = _area;
@synthesize panStartAreaHeight = _panStartAreaHeight;
@synthesize percentOfViewHeightToSwitchArea = _percentOfViewHeightToSwitchArea;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[touches anyObject] locationInView:self.view];
    [self invalidateGestureIfNecessaryForStartPoint:location];
}

- (void)invalidateGestureIfNecessaryForStartPoint:(CGPoint)location
{
    if(_area == DirectionPangestureRecognizerAreaTop)
    {
        if(!(location.y <= _panStartAreaHeight))
        {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    else if(_area == DirectionPangestureRecognizerAreaBottom)
    {
        if(!(location.y > (self.view.bounds.size.height - _panStartAreaHeight)))
        {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (!_drag) {
        if (abs(_moveX) > kDirectionPanThreshold) {
            if (_direction == DirectionPangestureRecognizerVertical) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
            }
        }else if (abs(_moveY) > kDirectionPanThreshold) {
            if (_direction == DirectionPanGestureRecognizerHorizontal) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if([event touchesForGestureRecognizer:self].count == 1)
    {
        if([self percentPanned] > _percentOfViewHeightToSwitchArea)
        {
            self.area = self.area == DirectionPangestureRecognizerAreaBottom ?
                DirectionPangestureRecognizerAreaTop : DirectionPangestureRecognizerAreaBottom;
            _panStartAreaHeight = DirectionPangestureRecognizerAreaTop ? 80 : 60;
        }
    }
}

-(CGFloat)percentPanned
{
    return fabs([self translationInView:self.view].y / self.view.bounds.size.height);
}

- (void)reset {
    [super reset];
    _drag = NO;
    _moveX = 0;
    _moveY = 0;
}

@end