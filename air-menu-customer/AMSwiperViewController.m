//
//  AMSwiperViewController.m
//  air-menu-customer
//
//  Created by Robert Lis on 02/12/2013.
//  Copyright (c) 2013 Air-menu. All rights reserved.
//

#import "AMSwiperViewController.h"
#import "DirectionPanGestureRecognizer.h"

@interface AMSwiperViewController ()
@property (nonatomic, weak, readwrite) UIViewController *displayedController;
@property (nonatomic, weak, readwrite) UIViewController *hiddenController;
@property (nonatomic, readwrite) NSUInteger indexOfDisplayedController;
@end

@implementation AMSwiperViewController

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
    [self setup];
}

-(void)setIndexOfDisplayedController:(NSUInteger)indexOfDisplayedController
{
    _indexOfDisplayedController = indexOfDisplayedController;
    self.displayedController = self.childViewControllers[indexOfDisplayedController];
    if(indexOfDisplayedController == 0)
    {
        self.hiddenController = self.viewConrollers[1];
    }
    else
    {
        self.hiddenController = self.viewConrollers[0];
    }
}

-(void)setup
{
    DirectionPanGestureRecognizer *pan = [[DirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    pan.direction = DirectionPangestureRecognizerVertical;
    pan.area = DirectionPangestureRecognizerAreaBottom;
    pan.panStartAreaHeight = 60.0;
    pan.percentOfViewHeightToSwitchArea = 0.3;
    [self.view addGestureRecognizer:pan];
    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeLeft;
}

#pragma mark - Public API

-(NSArray *)viewConrollers
{
    return self.childViewControllers;
}

-(void)setViewControllers:(NSArray *)viewControllers
{
    [self validateViewControllersArray:viewControllers];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:vc forIndex:idx];
    }];
    self.indexOfDisplayedController = 0;
}

#pragma mark - Private API


-(void)didPan:(DirectionPanGestureRecognizer *)recogniser
{
    static CGPoint startLocation;
    static CGPoint lastLocation;
    if(recogniser.state == UIGestureRecognizerStateBegan)
    {
        lastLocation = [recogniser locationInView:recogniser.view];
        startLocation = lastLocation;
    }
    else if(recogniser.state == UIGestureRecognizerStateChanged)
    {
        CGPoint curentLocation = [recogniser locationInView:recogniser.view];
        [self updateControllersPositionsWithTouchLocation:lastLocation curentLocation:curentLocation];
        lastLocation = curentLocation;
    }
    else if(recogniser.state == UIGestureRecognizerStateEnded)
    {
        if([recogniser percentPanned] >= recogniser.percentOfViewHeightToSwitchArea)
        {
            if(recogniser.area == DirectionPangestureRecognizerAreaBottom)
            {
                
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     self.hiddenController.view.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
                                     self.displayedController.view.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) +
                                                                                        self.view.bounds.size.height);
                                 }];
                self.indexOfDisplayedController = 0;
            }
            else if(recogniser.area == DirectionPangestureRecognizerAreaTop)
            {
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     self.hiddenController.view.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
                                     self.displayedController.view.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) -
                                                                                        self.view.bounds.size.height);
                }];
                
                self.indexOfDisplayedController = 1;
            }
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.displayedController.view.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
                if(self.indexOfDisplayedController == 0)
                {
                    self.hiddenController.view.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) +
                                                                       self.view.bounds.size.height);
                }
                else
                {
                    self.hiddenController.view.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) -
                                                                       self.view.bounds.size.height);
                }
            }];
        }
    }
}

- (void)updateControllersPositionsWithTouchLocation:(CGPoint)lastLocation curentLocation:(CGPoint)curentLocation
{
    CGFloat difference = curentLocation.y - lastLocation.y;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, difference);
    self.displayedController.view.frame = CGRectApplyAffineTransform(self.displayedController.view.frame, transform);
    self.hiddenController.view.frame = CGRectApplyAffineTransform(self.hiddenController.view.frame, transform);
}

- (void)addChildViewController:(UIViewController *)vc forIndex:(NSUInteger)idx
{
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [self positionViewControllerView:vc forIndex:idx];
    [vc didMoveToParentViewController:self];
}

- (void)positionViewControllerView:(UIViewController *)vc forIndex:(NSUInteger)idx
{
    if(idx == 0)
    {
        vc.view.frame = self.view.bounds;
    }
    else
    {
        vc.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)validateViewControllersArray:(NSArray *)viewControllers
{
    if (viewControllers.count > 2 || viewControllers.count < 2)
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Swiper must have exactly two view controllers"
                                     userInfo:@{@"viewControllers" : viewControllers}];
    }
}

@end
