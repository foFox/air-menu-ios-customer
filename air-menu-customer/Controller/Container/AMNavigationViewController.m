//
//  AMNavigationViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 17/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMNavigationViewController.h"
#import "AMMeViewController.h"
#import "AMOrderViewController.h"
#import "AMLoyaltyViewController.h"
#import "AMVoucherViewController.h"
#import "AMSearchViewController.h"
#import "AMReservationViewController.h"
#import "AMPreviousViewController.h"
#import "AMCreditCardViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#define CELL_HEIGHT 60.0

@implementation UIGestureRecognizer (Cancel)

- (void)cancel {
    self.enabled = NO;
    self.enabled = YES;
}

@end

@interface AMNavigationViewController () <UITableViewDataSource, UITableViewDelegate>
//display
@property (nonatomic, readwrite, weak) UITableView *tableView;
@property (nonatomic, readwrite, weak) UIView *container;
@property (nonatomic, readwrite, weak) UIView *marker;
//containment
@property (nonatomic, readwrite, strong) NSArray *viewControllers;
@property (nonatomic, readwrite, weak) UIViewController *currentViewController;
@property (nonatomic, readwrite, strong) NSArray *rows;
@property (nonatomic, readwrite) NSUInteger selectedIndex;
//animation
@property (nonatomic, readwrite) BOOL isUIVisible;
@property (nonatomic, readwrite) BOOL isAnimating;
@end

@implementation AMNavigationViewController

#pragma mark - Lifecycle

-(id)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGFloat inset = self.view.bounds.size.height - (self.rows.count * CELL_HEIGHT);
    self.tableView.contentInset = UIEdgeInsetsMake(inset / 2, 0, inset / 2, 0);
    self.marker.alpha = 0.0;
    self.tableView.userInteractionEnabled = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self makeCellsDisappear];
    [self animateMarkerToIndex:1];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.container.layer.anchorPoint = CGPointMake(1.0, 0.5);
    self.container.layer.position = CGPointApplyAffineTransform(self.container.layer.position, CGAffineTransformMakeTranslation(self.view.bounds.size.width / 2, 0.0));
    self.marker.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 1);
}

#pragma mark - Setup

-(void)setup
{
    [self setupContainer];
    [self setupTableView];
    [self setupControllers];
    [self setupMarker];
    self.rows = @[@"ME", @"ORDER", @"LOYALTY POINTS", @"VOUCHERS", @"SEARCH", @"RESERVE TABLE", @"PREVIOUS ORDERS", @"CREDIT CARDS"];
    srand48(time(0));
    srand(time(0));
    UIScreenEdgePanGestureRecognizer *recogniserLeft = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanLeft:)];
    recogniserLeft.edges = UIRectEdgeLeft;
    UIScreenEdgePanGestureRecognizer *recogniserRight = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanRight:)];
    recogniserRight.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:recogniserLeft];
    [self.view addGestureRecognizer:recogniserRight];
    [self displayViewControllerAtIndex:1];
    self.isUIVisible = NO;
}

-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"row_cell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
}

-(void)setupContainer
{
    UIView *container = [UIView newAutoLayoutView];
    self.container = container;
    [self.view addSubview:self.container];
    [container autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

-(void)setupControllers
{
    self.viewControllers = @[[AMMeViewController new],
                             [AMOrderViewController new],
                             [AMLoyaltyViewController new],
                             [AMVoucherViewController new],
                             [AMSearchViewController new],
                             [AMReservationViewController new],
                             [AMPreviousViewController new],
                             [AMCreditCardViewController new]];
}

-(void)setupMarker
{
    UIView *marker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    self.marker = marker;
    [self.view insertSubview:marker atIndex:0];
    self.marker.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
}
#pragma mark - Table View Data Souce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"row_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.rows[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:MENSCH_THIN size:30.0];
    cell.textLabel.textColor = [UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:83.0f/255.0f alpha:1.0];
    cell.indentationLevel = 2.0;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    cell.textLabel.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    cell.textLabel.layer.shadowOpacity = 1.0;
    cell.textLabel.layer.shadowRadius = 1.5;
    cell.textLabel.layer.shadowOffset = CGSizeMake(0.0f,2.0f);
    cell.textLabel.layer.shouldRasterize = YES;
    [cell.textLabel sizeToFit];
    return cell;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self animateMarkerToIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self displayViewControllerAtIndex:indexPath.row];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self animateCellApperiance:cell];
}


#pragma mark - Animations

-(void)makeCellsAppear
{
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        [self animateCellApperiance:cell];
    }
}

-(void)makeCellsDisappear
{
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        [self animateCellDisappeariance:cell];
    }
}


-(void)animateCellApperiance:(UITableViewCell *)cell
{
    cell.contentView.transform = CGAffineTransformIdentity;
    cell.contentView.transform = CGAffineTransformMakeTranslation(-cell.bounds.size.width, 0.0);
    [UIView animateWithDuration:0.5
                          delay:randomFloat(0.1, 0.3)
         usingSpringWithDamping:randomFloat(0.5, 0.8)
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         cell.contentView.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}


-(void)animateCellDisappeariance:(UITableViewCell *)cell
{
    cell.contentView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:2.0
                          delay:0.0//randomFloat(0.0, 0.3)
         usingSpringWithDamping:randomFloat(0.5, 0.8)
          initialSpringVelocity:-6//randomFloat(-1.0, -3.0)
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         cell.contentView.transform = CGAffineTransformMakeTranslation(-cell.bounds.size.width, 0.0);
                     }
                     completion:nil];
}

float randomFloat(float a, float b) {
    float random = ((float) rand()) / (float) RAND_MAX;
    float diff = b - a;
    float r = random * diff;
    return a + r;
}

-(void)animateMarkerToIndex:(NSUInteger)index
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if(cell)
    {
        CGSize textSize = [[cell.textLabel text] sizeWithAttributes:@{NSFontAttributeName:cell.textLabel.font}];
        [UIView animateWithDuration:0.25
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.marker.frame = CGRectMake(0,
                                                            cell.frame.origin.y + cell.frame.size.height * 1.5,
                                                            35 + textSize.width,
                                                            1);
                         }
                         completion:nil];
    }
}

-(void)didPanLeft:(UIScreenEdgePanGestureRecognizer *)recogniser
{
    static CGPoint initialPoint;
    static CGPoint lastPoint;
    
    CGPoint currentPoint = [recogniser locationInView:self.view];
    CGFloat xDistance = currentPoint.x - initialPoint.x;
    CGFloat xDistanceNormalised = xDistance / recogniser.view.bounds.size.width;
    
    if (recogniser.state == UIGestureRecognizerStateBegan)
    {
        if(self.isUIVisible)
        {
            [recogniser cancel];
        }
        initialPoint = [recogniser locationInView:self.view];
        lastPoint = initialPoint;
        self.tableView.userInteractionEnabled = YES;
    }
    else if (recogniser.state == UIGestureRecognizerStateChanged)
    {
        if (xDistanceNormalised > 0.1)
        {
            [self showUI];
        }
        else if(xDistanceNormalised < 0.1)
        {
            [self hideUI];
        }
        
        [self rotateContainerToPecentage:xDistanceNormalised animated:NO acceration:YES];
        self.marker.alpha = xDistanceNormalised;
        self.container.alpha = 1 - xDistanceNormalised + 1.5;
    }
    else if (recogniser.state == UIGestureRecognizerStateEnded)
    {
        if(xDistanceNormalised > 0.1)
        {
            [self rotateContainerToPecentage:1 animated:YES acceration:NO];
            [self showUI];
            self.tableView.userInteractionEnabled = YES;
        }
        else if(xDistanceNormalised < 0.1)
        {
            [self rotateContainerToPecentage:0 animated:YES acceration:NO];
            [self hideUI];
            self.tableView.userInteractionEnabled = NO;
        }
    }
    
    lastPoint = currentPoint;
}

-(void)showUI
{
    if(!self.isUIVisible)
    {
        self.isAnimating = YES;
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            self.isAnimating = NO;
            self.isUIVisible = YES;
        }];
        [self makeCellsAppear];
        [CATransaction commit];
    }
}

-(void)hideUI
{
    if (self.isUIVisible)
    {
        self.isAnimating = YES;
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            self.isAnimating = NO;
            self.isUIVisible = NO;
        }];
        [self makeCellsDisappear];
        [CATransaction commit];
    }
}

-(void)didPanRight:(UIScreenEdgePanGestureRecognizer *)recogniser
{
    static CGPoint initialPoint;
    static CGPoint lastPoint;
    
    CGPoint currentPoint = [recogniser locationInView:self.view];
    CGFloat xDistance = initialPoint.x - currentPoint.x;
    CGFloat xDistanceNormalised = xDistance / recogniser.view.bounds.size.width;
    
    if (recogniser.state == UIGestureRecognizerStateBegan)
    {
        if (!self.isUIVisible)
        {
            [recogniser cancel];
        }
        
        initialPoint = [recogniser locationInView:self.view];
        lastPoint = initialPoint;
        self.tableView.userInteractionEnabled = NO;
    }
    else if(recogniser.state == UIGestureRecognizerStateChanged)
    {
        if (xDistanceNormalised < 0.1)
        {
            [self showUI];
        }
        else if(xDistanceNormalised > 0.1)
        {
            [self hideUI];
        }
        
        [self rotateContainerToPecentage:1 - xDistanceNormalised * 2.0 animated:NO acceration:NO];
        self.marker.alpha = 1 - xDistanceNormalised;
        self.container.alpha = 1 - xDistanceNormalised + 1.5;
    }
    else if(recogniser.state == UIGestureRecognizerStateEnded)
    {
        if(xDistanceNormalised < 0.1)
        {
            [self rotateContainerToPecentage:1 animated:YES acceration:NO];
            [self showUI];
            self.tableView.userInteractionEnabled = YES;
        }
        else if(xDistanceNormalised > 0.1)
        {
            [self rotateContainerToPecentage:0 animated:YES acceration:NO];
            [self hideUI];
            self.tableView.userInteractionEnabled = NO;
        }
    }
}

-(void)rotateContainerToPecentage:(CGFloat)percent animated:(BOOL)animated acceration:(BOOL)acceleration
{
    CGFloat percentExpanded;
    if(acceleration)
    {
        percentExpanded = MIN(1.0, percent * 2);
    }
    else
    {
        percentExpanded = MAX(0.0, percent);
    }
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -1500;
    transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(-45 * percentExpanded) , 0.0, 1.0, 0.0);
    
    if(animated)
    {
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.container.layer.transform = transform;
                             self.marker.alpha = 1.0 * percent;
                             self.container.alpha = 1 - percent + 1.0;
                             
                         }
                         completion:nil];
    }
    else
    {
        self.container.layer.transform = transform;
        self.marker.alpha = 1.0 * percent;
        self.container.alpha = 1 - percent + 1.0;

    }
}

#pragma mark - Other

-(void)displayViewControllerAtIndex:(NSUInteger)index
{
    UIViewController *currentViewController = self.viewControllers[self.selectedIndex];
    UIViewController *newViewController = self.viewControllers[index];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (currentViewController != newViewController && self.currentViewController != nil)
    {
        [currentViewController willMoveToParentViewController:nil];
        [self addChildViewController:newViewController];
        [self.container insertSubview:newViewController.view atIndex:0];
        [newViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        if (index > self.selectedIndex)
        {
            newViewController.view.layer.transform = CATransform3DMakeTranslation(self.container.bounds.size.width, 0, 0);
        }
        else if(index < self.selectedIndex)
        {
            newViewController.view.layer.transform = CATransform3DMakeTranslation(-self.container.bounds.size.width, 0, 0);
        }
        
        newViewController.view.alpha = 0.0;
        self.container.clipsToBounds = NO;
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             if (index > self.selectedIndex)
                             {
                                 currentViewController.view.layer.transform = CATransform3DMakeTranslation(-self.container.bounds.size.width, 0, 0);
                             }
                             else if(index < self.selectedIndex)
                             {
                                 currentViewController.view.layer.transform = CATransform3DMakeTranslation(self.container.bounds.size.width, 0, 0);
                             }
                             
                             newViewController.view.layer.transform = CATransform3DIdentity;
                             newViewController.view.alpha = 1.0;
                             currentViewController.view.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             currentViewController.view.transform = CGAffineTransformIdentity;
                             [newViewController didMoveToParentViewController:self];
                             [currentViewController.view removeFromSuperview];
                             [currentViewController removeFromParentViewController];
                         }];
    }
    else if (self.currentViewController == nil)
    {
        [self addChildViewController:newViewController];
        [self.container addSubview:newViewController.view];
        [newViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [newViewController didMoveToParentViewController:self];
    }
    
    self.currentViewController = newViewController;
    self.selectedIndex = index;
    [self animateMarkerToIndex:self.selectedIndex];
}

@end
