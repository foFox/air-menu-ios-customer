//
//  UITableViewController+AMPickerViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 13/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMPickerViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMSearchViewController.h"
#import "AMOrderCreatorViewController.h"
#import "AMReservationViewController.h"
#import "AMLoyaltyViewController.h"
#import "AMVoucherViewController.h"
#import "AMPreviousViewController.h"
#import "AMCreditCardViewController.h"
#import "UILabel+AttributesCopy.h"

@interface AMPickerCell : UITableViewCell
@property (nonatomic, readwrite, weak) UILabel *rowTextLabel;
@property (nonatomic, readwrite, weak) UILabel *rowIconLabel;
@end

@implementation AMPickerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [self setupRowIconLabel];
    [self setupRowTextLabel];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
}

-(void)setupRowTextLabel
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.rowTextLabel = label;
    [self.contentView addSubview:self.rowTextLabel];
    [self.rowTextLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.rowTextLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:60.0f];
    [self.rowTextLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    self.rowTextLabel.attributes = @{ NSFontAttributeName : [UIFont fontWithName:GOTHAM_LIGHT size:20.0f],
                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                      NSKernAttributeName : @1.0};
    self.rowTextLabel.textAlignment = NSTextAlignmentLeft;
}

-(void)setupRowIconLabel
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.rowIconLabel = label;
    [self.contentView addSubview:self.rowIconLabel];
    [self.rowIconLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.rowIconLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    self.rowIconLabel.font = [UIFont fontWithName:ICON_FONT size:25.0f];
    self.rowIconLabel.textColor = [UIColor colorWithRed:30.0/255.0f green:209.0/255.0f blue:241.0/255.0f alpha:1.0];
    [self.rowIconLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

@end

#define ROW_HEIGHT 80.0f

@interface AMPickerViewController()
@property (nonatomic, readwrite, strong) NSArray *rows;
@property (nonatomic, readwrite, strong) NSArray *icons;
@property (nonatomic, readwrite, strong) NSDictionary *managedViewControllersClasses;
@property (nonatomic, readwrite, strong) NSMutableDictionary *managedViewControllers;
@end

@implementation AMPickerViewController

-(id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self)
    {
        self.rows = @[@"SEARCH", @"ORDER", @"RESERVE TABLE", @"LOYALTY POINTS", @"VOUCHERS", @"PREVIOUS ORDERS", @"CREDIT CARDS"];
        self.icons = @[@"", @"", @"", @"", @"", @"", @""];
        [self.tableView registerClass:[AMPickerCell class] forCellReuseIdentifier:@"row_cell"];
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        UILabel *label = [UILabel newAutoLayoutView];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:IDLEWILD_BOOK size:30];
        label.textColor = [UIColor whiteColor];
        label.text = @"Airmenu";
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 100)];
        [container addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [label autoCenterInSuperview];
        self.tableView.tableHeaderView = container;
        self.tableView.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        
        
        self.managedViewControllersClasses = @{self.rows[0] : [AMSearchViewController class],
                                               self.rows[1] : [AMOrderCreatorViewController class],
                                               self.rows[2] : [AMReservationViewController class],
                                               self.rows[3] : [AMLoyaltyViewController class],
                                               self.rows[4] : [AMVoucherViewController class],
                                               self.rows[5] : [AMPreviousViewController class],
                                               self.rows[6] : [AMCreditCardViewController class]};
        self.managedViewControllers = [@{self.rows[0] : [NSNull null],
                                         self.rows[1] : [NSNull null],
                                         self.rows[2] : [NSNull null],
                                         self.rows[3] : [NSNull null],
                                         self.rows[4] : [NSNull null],
                                         self.rows[5] : [NSNull null],
                                         self.rows[6] : [NSNull null]} mutableCopy];
    }
    return self;
}

-(void)setController:(MSDynamicsDrawerViewController *)controller
{
    _controller = controller;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rows.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"row_cell"];
    [cell.rowTextLabel setTextWithExistingAttributes:self.rows[indexPath.row]];
    cell.rowIconLabel.text = self.icons[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.rows[indexPath.row];
    if (self.managedViewControllers[identifier] != [NSNull null])
    {
        UIViewController *viewController = self.managedViewControllers[identifier];
        [self.controller setPaneViewController:viewController animated:YES completion:nil];
    }
    else
    {
        Class viewControllerClass = self.managedViewControllersClasses[identifier];
        UIViewController *viewController = [[viewControllerClass alloc] init];
        self.managedViewControllers[identifier] = viewController;
        if(self.controller.paneState == MSDynamicsDrawerPaneStateOpen)
        {
            [self.controller setPaneViewController:viewController animated:YES completion:nil];
        }
        else
        {
            [self.controller setPaneViewController:viewController animated:NO completion:nil];
        }
    }
}

@end
