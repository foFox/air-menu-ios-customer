//
//  AMUserView.h
//  Air Menu C
//
//  Created by Robert Lis on 19/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMUserView : UIView
@property (nonatomic, readonly, weak) UIImageView *userPicture;
@property (nonatomic, readonly, weak) UILabel *nameLabel;
@property (nonatomic, readonly, weak) UILabel *typeLabel;
@end
