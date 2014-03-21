//
//  AMBeaconController.h
//  Air Menu C
//
//  Created by Robert Lis on 13/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AirMenuKit/AMClient+Restaurant.h>

@protocol AMRestaurantBeaconManagerDelegate;
@interface AMRestaurantBeaconManager : NSObject
@property (nonatomic, readwrite, weak) id <AMRestaurantBeaconManagerDelegate> delegate;
+(id)sharedInstance;
@end

@protocol AMRestaurantBeaconManagerDelegate <NSObject>
-(void)didEnterRestaurant:(AMRestaurant *)restaurant;
-(void)didLeaveRestaurant:(AMRestaurant *)restaurant;
@end
