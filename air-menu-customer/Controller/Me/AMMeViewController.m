//
//  AMMeViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 17/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMeViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import <AirMenuKit/AMClient+User.h>
#import "AMDescribedLabel.h"
#import "AMUserView.h"
#import "AMDotSpacer.h"

@interface AMMeViewController ()
@property (nonatomic, readwrite, weak) AMUserView *userView;
@property (nonatomic, readwrite, weak) AMDescribedLabel *usernameLabel;
@property (nonatomic, readwrite, weak) AMDescribedLabel *emailLabel;
@property (nonatomic, readwrite, weak) AMDescribedLabel *phoneLabel;
@property (nonatomic, readwrite, weak) AMDotSpacer *topSpacer;
@property (nonatomic, readwrite, weak) AMDotSpacer *bottomSpacer;
@property (nonatomic, readwrite, weak) UIButton *logoutButton;
@property (nonatomic, readwrite, strong) AMUser *currentUser;
@end

@implementation AMMeViewController

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

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self getCurrentUser];
}

#pragma mark - Setup
-(void)setup
{
    [self createUserView];
    [self createTopSpacer];
    [self createUsernameLabel];
    [self createEmailLabel];
    [self createPhoneLabel];
    [self createLogoutButton];
    [self createBottomSpacer];
}

-(void)createUserView
{
    AMUserView *userView = [AMUserView newAutoLayoutView];
    self.userView = userView;
    [self.view addSubview:self.userView];
    [self.userView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:40.0f];
    [self.userView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:0.0];
    [self.userView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:0.0];
    [self.userView autoSetDimension:ALDimensionHeight toSize:95.0f];
    self.userView.nameLabel.text = @"Robert Lis";
    self.userView.typeLabel.text = @"USER";
    self.userView.userPicture.image = [UIImage imageNamed:@"sample_image.jpeg"];
    self.userView.userPicture.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)createTopSpacer
{
    AMDotSpacer *spacer = [AMDotSpacer newAutoLayoutView];
    self.topSpacer = spacer;
    self.topSpacer.alpha = 0.7;
    [self.view addSubview:self.topSpacer];
    [self.topSpacer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userView withOffset:50.0f];
    [self.topSpacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:20.0f];
    [self.topSpacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:-20.0f];
    [self.topSpacer autoSetDimension:ALDimensionHeight toSize:2.0f];
}

-(void)createUsernameLabel
{
    AMDescribedLabel *usernameLabel = [AMDescribedLabel newAutoLayoutView];
    self.usernameLabel = usernameLabel;
    [self.view addSubview:self.usernameLabel];
    [self.usernameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topSpacer withOffset:30.0f];
    [self.usernameLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:20];
    [self.usernameLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    [self.usernameLabel autoSetDimension:ALDimensionHeight toSize:60];
    self.usernameLabel.titleLabel.text = @"username :";
}

-(void)createEmailLabel
{
    AMDescribedLabel *emailLabel = [AMDescribedLabel newAutoLayoutView];
    self.emailLabel = emailLabel;
    [self.view addSubview:self.emailLabel];
    [self.emailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.usernameLabel withOffset:20.0];
    [self.emailLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:20.0];
    [self.emailLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:20.0];
    [self.emailLabel autoSetDimension:ALDimensionHeight toSize:60];
    self.emailLabel.titleLabel.text = @"email address :";
}

-(void)createPhoneLabel
{
    AMDescribedLabel *phoneLabel = [AMDescribedLabel newAutoLayoutView];
    self.phoneLabel = phoneLabel;
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.emailLabel withOffset:20];
    [self.phoneLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:20];
    [self.phoneLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:20];
    [self.phoneLabel autoSetDimension:ALDimensionHeight toSize:60];
    self.phoneLabel.titleLabel.text = @"phone number :";
    self.phoneLabel.textLabel.text = @"00353 879363860";
}

-(void)createBottomSpacer
{
    AMDotSpacer *spacer = [AMDotSpacer newAutoLayoutView];
    self.bottomSpacer = spacer;
    self.bottomSpacer.alpha = 0.7;
    [self.view addSubview:self.bottomSpacer];
    [self.bottomSpacer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.phoneLabel withOffset:20.0f];
    [self.bottomSpacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:20.0f];
    [self.bottomSpacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:-20.0f];
    [self.bottomSpacer autoSetDimension:ALDimensionHeight toSize:2.0f];
}

-(void)createLogoutButton
{
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.logoutButton = logoutButton;
    [self.view addSubview:self.logoutButton];
    self.logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.logoutButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-20.0f];
    [self.logoutButton setTitle:@"LOGOUT" forState:UIControlStateNormal];
    self.logoutButton.titleLabel.font = [UIFont fontWithName:MENSCH_THIN size:30];
    [self.logoutButton setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:83.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.logoutButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.logoutButton.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    self.logoutButton.layer.shadowOpacity = 1.0;
    self.logoutButton.layer.shadowRadius = 1.5;
    self.logoutButton.layer.shadowOffset = CGSizeMake(0.0f,2.0f);
}

-(void)getCurrentUser
{
    [[AMClient sharedClient] findCurrentUser:^(AMUser *user, NSError *error) {
        if(!error)
        {
            self.currentUser = user;
            [self updateView];
        }
    }];
}

-(void)updateView
{
    self.userView.nameLabel.text = self.currentUser.name;
    self.userView.typeLabel.text = self.currentUser.type;
    self.emailLabel.textLabel.text = self.currentUser.email;
    self.usernameLabel.textLabel.text = self.currentUser.username;
}
@end
