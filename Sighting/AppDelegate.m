//
//  AppDelegate.m
//  Sighting
//
//  Created by Alex Xiao on 3/27/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <AFNetworking/AFNetworking.h>
#import "Globals.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIView *loadingView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    UILocalNotification *localNotification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        [self application:application didReceiveLocalNotification:localNotification];
    }
    

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    return YES;
}

- (void)startGettingUpdates
{
    [NSTimer scheduledTimerWithTimeInterval:15.0
                                     target:self
                                   selector:@selector(fetchGroupsAndUsers)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)fetchGroupsAndUsers
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user": [Globals globals].user};
    
    [manager GET:[Globals urlWithPath:@"user_data"]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"%@", responseObject);
             [[NSNotificationCenter defaultCenter] postNotificationName:@"groups"
                                                                 object:nil
                                                               userInfo:@{@"groups": responseObject[@"groups"]}];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%@", error);
         }];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"background refresh!");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user": [Globals globals].user};
                             
    [manager GET:[Globals urlWithPath:@"user_data"]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"%@", responseObject);
             completionHandler(UIBackgroundFetchResultNewData);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%@", error);
             completionHandler(UIBackgroundFetchResultFailed);
         }];
}



- (void)showLoadingScreenForVC:(UIViewController *)vc
{
    
    [self.loadingView removeFromSuperview];
    
    self.loadingView = [[UIView alloc] init];
    self.loadingView.frame = vc.view.frame;
    self.loadingView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = self.loadingView.center;
    
    [self.loadingView addSubview:spinner];
    [vc.view addSubview:self.loadingView];
    [spinner startAnimating];
    
}

- (void)stopLoadingScreen
{
    [self.loadingView removeFromSuperview];
}


@end
