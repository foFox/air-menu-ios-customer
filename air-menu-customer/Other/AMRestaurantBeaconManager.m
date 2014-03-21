//
//  AMBeaconController.m
//  Air Menu C
//
//  Created by Robert Lis on 13/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMRestaurantBeaconManager.h"
#import <CoreLocation/CoreLocation.h>

#define AIRMENU_BEACON_UUID @"635E0468-2486-41F7-818B-7930FBBFC4BC"
#define AIRMENU_BEACON_ID @"com.air-menu.restaurant.beacon"

typedef void (^RestaurantBeacomComletion) (AMRestaurant *restaurant, NSError *error);

@interface AMRestaurantBeaconManager() <CLLocationManagerDelegate>
@property CLLocationManager *locationManager;
@property NSMutableSet *restaurantsDetected;
@property NSMutableSet *restaurantIDsBeingLookedUp;
@end

@implementation AMRestaurantBeaconManager
+(id)sharedInstance
{
    static AMRestaurantBeaconManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AMRestaurantBeaconManager alloc] init];
    });
    return manager;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.restaurantsDetected = [NSMutableSet set];
    self.restaurantIDsBeingLookedUp = [NSMutableSet set];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:AIRMENU_BEACON_UUID]
                                                                      identifier:AIRMENU_BEACON_ID];
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager requestStateForRegion:beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside)
    {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if([beaconRegion.identifier isEqualToString:AIRMENU_BEACON_ID])
        {
            [manager startRangingBeaconsInRegion:beaconRegion];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]])
    {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.identifier isEqualToString:AIRMENU_BEACON_ID])
        {
            [manager startRangingBeaconsInRegion:beaconRegion];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]])
    {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.identifier isEqualToString:AIRMENU_BEACON_ID])
        {
            [manager stopRangingBeaconsInRegion:beaconRegion];
            for(AMRestaurant *restaurant in self.restaurantsDetected)
            {
                [self.delegate didLeaveRestaurant:restaurant];
            }
            self.restaurantsDetected = [NSMutableSet set];
            self.restaurantIDsBeingLookedUp = [NSMutableSet set];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSSet *newIDs = [self newIDsGivenCurrentIDs:[self.restaurantsDetected valueForKeyPath:@"identifier"] newlyDetectedIds:[NSSet setWithArray:[beacons valueForKeyPath:@"minor"]]];
    NSSet *missingIDs = [self missingIDsGivenCurrenIDs:[self.restaurantsDetected valueForKeyPath:@"identifier"]  newlyDetectedIDs:[NSSet setWithArray:[beacons valueForKeyPath:@"minor"]]];
    
    for (NSNumber *newID in newIDs)
    {
        if(![self.restaurantIDsBeingLookedUp containsObject:newID])
        {
            [self.restaurantIDsBeingLookedUp addObject:newID];
            [self getRestaurantWithID:newID.description completion:^(AMRestaurant *restaurant, NSError *error) {
                if(!error)
                {
                    [self.restaurantsDetected addObject:restaurant];
                    [self.delegate didEnterRestaurant:restaurant];
                    [self showNotificationWithText:[@"Welcome to " stringByAppendingString:restaurant.name]];
                }
                [self.restaurantIDsBeingLookedUp removeObject:newID];
            }];
        }
    }
    
    
    for(NSNumber *missingID in missingIDs)
    {
        NSString *predicateString = [@"identifier == " stringByAppendingString:missingID.description];
        NSSet *result = [self.restaurantsDetected filteredSetUsingPredicate:[NSPredicate predicateWithFormat:predicateString]];
        AMRestaurant *missingRestaurant = [result anyObject];
        [self.restaurantsDetected removeObject:missingRestaurant];
        [self.delegate didLeaveRestaurant:missingRestaurant];
    }
}

-(NSSet *)newIDsGivenCurrentIDs:(NSSet *)currentIDs newlyDetectedIds:(NSSet *)newlyDetected;
{
    NSMutableSet *currentSet = [NSMutableSet setWithSet:currentIDs];
    NSMutableSet *newSet = [NSMutableSet setWithSet:newlyDetected];
    [newSet minusSet:currentSet];
    return newSet;
}

-(NSSet *)missingIDsGivenCurrenIDs:(NSSet *)currentIDs newlyDetectedIDs:(NSSet *)newlyDetected
{
    NSMutableSet *currentSet = [NSMutableSet setWithSet:currentIDs];
    NSMutableSet *newSet = [NSMutableSet setWithSet:newlyDetected];
    [currentSet minusSet:newSet];
    return currentSet;
}



-(void)getRestaurantWithID:(NSString *)restaurantID completion:(RestaurantBeacomComletion)completion
{
    [[AMClient sharedClient] findRestaurantWithIdentifier:restaurantID completion:^(AMRestaurant *restaurant, NSError *error) {
        if(completion) completion(restaurant, error);
    }];
}

-(void)showNotificationWithText:(NSString *)string
{
    UILocalNotification *notice = [[UILocalNotification alloc] init];
    notice.alertBody = string;
    notice.alertAction = @"Open";
    notice.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
}

@end
