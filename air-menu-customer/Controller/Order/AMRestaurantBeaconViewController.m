//
//  AMBeaconViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 13/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMRestaurantBeaconViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMRestaurantBeaconManager.h"

@interface AMRestaurantBeaconViewController () <AMRestaurantBeaconManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property AMRestaurantBeaconManager *manager;
@property (nonatomic, readwrite, weak) UILabel *noRestaurantsLabel;
@property (nonatomic, readwrite, weak) UILabel *manyRestaurantsLabel;
@property (nonatomic, readwrite, weak) UITableView *tableView;
@property (nonatomic, readwrite, strong) NSMutableArray *restaurants;
@end

@implementation AMRestaurantBeaconViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [AMRestaurantBeaconManager sharedInstance];
    self.manager.delegate = self;
    self.restaurants = [NSMutableArray array];
}

#pragma mark - Private

-(void)setup
{
    [self createNoRestaurantsLabel];
    [self createManyRestaurantsLabel];
    [self createTableView];
}

-(void)createNoRestaurantsLabel
{
    UILabel *noRestaurantsLabel = [UILabel newAutoLayoutView];
    self.noRestaurantsLabel = noRestaurantsLabel;
    [self.view addSubview:self.noRestaurantsLabel];
    self.noRestaurantsLabel.text = @"no restaurants around";
    self.noRestaurantsLabel.textColor = [UIColor whiteColor];
    self.noRestaurantsLabel.font = [UIFont fontWithName:GOTHAM_XLIGHT size:25];
    [self.noRestaurantsLabel autoCenterInSuperview];
}

-(void)createManyRestaurantsLabel
{
    UILabel *manyRestaurantsLabel = [UILabel newAutoLayoutView];
    self.manyRestaurantsLabel = manyRestaurantsLabel;
    [self.view addSubview:self.manyRestaurantsLabel];
    self.manyRestaurantsLabel.text = @"there are few restaurants around, which one are you in?";
    self.manyRestaurantsLabel.numberOfLines = 0;
    self.manyRestaurantsLabel.textColor = [UIColor whiteColor];
    self.manyRestaurantsLabel.font = [UIFont fontWithName:GOTHAM_XLIGHT size:25];
    [self.manyRestaurantsLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:22];
    [self.manyRestaurantsLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:-20];
    [self.manyRestaurantsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:40];
    self.manyRestaurantsLabel.alpha = 0.0;
}

-(void)createTableView
{
    UITableView *tableView = [UITableView newAutoLayoutView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25];
    [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.manyRestaurantsLabel withOffset:30];
    [self.tableView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
    [self.tableView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    [self.tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.alpha = 0.0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Restaurant Beacon Manager

-(void)didEnterRestaurant:(AMRestaurant *)restaurant
{
    NSLog(@"ENTERED : %@", restaurant);
    [self.restaurants addObject:restaurant];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.restaurants.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    if(self.restaurants.count == 1)
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.noRestaurantsLabel.alpha = 0.0;
                             self.tableView.alpha = 1.0;
                             self.manyRestaurantsLabel.alpha = 1.0;
                         }];
    }
}

-(void)didLeaveRestaurant:(AMRestaurant *)restaurant
{
    NSLog(@"LEFT : %@", restaurant);
    NSInteger indexOfRestaurant = [self.restaurants indexOfObject:restaurant];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexOfRestaurant inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.restaurants removeObject:restaurant];
    [self.tableView endUpdates];
    
    if (self.restaurants.count == 0)
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.noRestaurantsLabel.alpha = 1.0;
                             self.tableView.alpha = 0.0f;
                             self.manyRestaurantsLabel.alpha = 0.0;
                         }];
    }
    
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.restaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LOL"];
    AMRestaurant *restaurant = self.restaurants[indexPath.row];
    cell.textLabel.text = restaurant.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@.",restaurant.address.addressLine1, restaurant.address.addressLine2];
    cell.textLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:25];
    cell.detailTextLabel.font = [UIFont fontWithName:GOTHAM_MEDIUM size:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    cell.separatorInset = UIEdgeInsetsMake(0, 22, 0, 0);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate controller:self didSelectRestaurant:self.restaurants[indexPath.row]];
}
@end
