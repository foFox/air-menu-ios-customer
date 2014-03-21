//
//  AMAppDelegate.m
//  air-menu-customer
//
//  Created by Robert Lis on 17/11/2013.
//  Copyright (c) 2013 Air-menu. All rights reserved.
//

#import "AMAppDelegate.h"
#import "AMSwiperViewController.h"
#import <AirMenuKit/AMClient.h>
#import "AMRestaurantBeaconViewController.h"
#import "AMNavigationViewController.h"

@implementation AMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[AMClient sharedClient] isLoggedIn];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[AMNavigationViewController alloc] init];
    [self.window makeKeyAndVisible];
    [[AMClient sharedClient] authenticateWithClientID:@"1ea6342ac153d74ac305e04f949da93bad3eab7401d9160206e65288bfabee64"
                                         clientSecret:@"541b2f36d19a717077195286212aa1e1cea63faea4cfa22963475512704a2684"
                                             username:@"rob"
                                             password:@"password123"
                                               scopes:AMOAuthScopeUser | AMOAuthScopeGetMenus | AMOAuthScopeBasic
                                           completion:^(AMOAuthToken *token, NSError *error) {
                                               if (error)
                                               {
                                                   NSLog(@"ERROR LOGGING IN !! %@", error);
                                               }
                                           }
     ];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[self backgroundImage]];
    self.window.backgroundColor = background;    
    return YES;
}

-(UIImage *)backgroundImage
{
    CGSize size = self.window.bounds.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBackgroundImageInContext:context withSize:size];
    UIImage *background =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return background;
}

-(void)drawBackgroundImageInContext:(CGContextRef)context withSize:(CGSize)size
{
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[2] = { 0.0, 1.0 };
    NSArray *colors = @[(id)[UIColor colorWithRed:18/255.0f green:115/255.0f blue:160/255.0f alpha:1.0].CGColor,
                        (id)[UIColor colorWithRed:203/255.0f green:177/255.0f blue:153/255.0f alpha:1.0].CGColor];
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    CGPoint startPoint, endPoint;
    startPoint.x = 0.0;
    startPoint.y = 0.0;
    endPoint.x = size.width;
    endPoint.y = size.height;
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
