//
//  AMMenuViewController.h
//  Air Menu C
//
//  Created by Robert Lis on 13/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AirMenuKit/AirMenuKit.h>
#import "AMMenuViewStateSections.h"
#import "AMMenuViewStateItems.h"
#import "AMMenuViewStateItem.h"

@interface AMMenuViewController : UIViewController
@property (nonatomic, readwrite, weak) UICollectionView *collectionView;
@property (nonatomic, readwrite, strong) AMRestaurant *restaurant;
@property (nonatomic, readwrite, strong) AMMenu *menu;
@property (nonatomic, readwrite, strong) AMMenuViewState *currentState;
@property (nonatomic, readwrite, strong) AMMenuViewStateSections *sectionsState;
@property (nonatomic, readwrite, strong) AMMenuViewStateItems *itemsState;
@property (nonatomic, readwrite, strong) AMMenuViewStateItem *itemState;
@end
