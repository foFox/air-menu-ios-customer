//
//  AMMenuViewState.h
//  Air Menu C
//
//  Created by Robert Lis on 21/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AirMenuKit/AirMenuKit.h>

@class AMMenuViewController;
@interface AMMenuViewState : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, readwrite, weak) AMMenuViewController *viewController;
@property (nonatomic, readwrite, strong) AMRestaurant *restaurant;
@property (nonatomic, readwrite, strong) AMMenu *menu;
-(id)initWithController:(AMMenuViewController *)controller restaurant:(AMRestaurant *)restaurant;
@end
