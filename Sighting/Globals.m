//
//  GlobalVars.m
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "Globals.h"
#import "Group.h"
#import "Alert.h"
#import <TSMessages/TSMessage.h>
#import "GroupInfoViewController.h"
#import "SingleGroupMapViewController.h"

@implementation Globals

+ (NSString *)urlWithPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@", kBaseUrls, path];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)showCompletionAlert:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [vc dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (NSMutableArray *)getRecentAlertsFromGroups:(NSArray *)groups
{
    NSMutableArray *recentAlerts = [@[] mutableCopy];
    for (Group *group in groups) {
        for (Alert *alert in group.alerts) {
            [recentAlerts addObject:alert];
        }
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    if (recentAlerts.count > 20) {
        return [[[recentAlerts sortedArrayUsingDescriptors:sortDescriptors] subarrayWithRange:NSMakeRange(0, 20)] mutableCopy];
    } else {
        return [[recentAlerts sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    }
}

+ (NSMutableArray *)getRecentAlertsFromGroups:(NSArray *)groups sinceTime:(NSInteger)time
{
    NSMutableArray *recentAlerts = [self getRecentAlertsFromGroups:groups];
    NSMutableArray *moreRecentAlerts = [@[] mutableCopy];
    for (Alert *alert in recentAlerts) {
        if (alert.time > time) {
            [moreRecentAlerts addObject:alert];
        }
    }
    return moreRecentAlerts;
}

+ (UIColor *)getColorForValue:(double)value
{
    float scale = value / 5.0;
    UIColor *color = [UIColor colorWithRed:1 - scale green:scale blue:0.0 alpha:1.0];
    return color;
}

+ (Globals*)globals {
    static Globals* sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [Globals new];
        
    });
    return sharedSingleton;
}

- (BOOL)inGroup:(Group *)group
{
    for (Group *g in [self groups]) {
        if ([g.name isEqualToString:group.name]) {
            return true;
        }
    }
    return false;
}

+ (void)showAttractMessageForGroup:(Group *)group fromTime:(NSInteger)time
{
    UIViewController *vc = [self getTopMostViewController];
    [TSMessage showNotificationInViewController:vc
                                          title:[NSString stringWithFormat:@"Alerts from %@!", group.name]
                                       subtitle:@"Check it out!"
                                          image:nil
                                           type:TSMessageNotificationTypeSuccess
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:@"Open Map"
                                 buttonCallback:^{
                                     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                     UINavigationController *nvc = [sb instantiateViewControllerWithIdentifier:@"nvc"];
                                     SingleGroupMapViewController *svc = nvc.viewControllers[0];
                                     svc.time = time;
                                     svc.group = group;
                                     nvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                                     [vc presentViewController:nvc animated:YES completion:NULL];
                                 }
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}

+ (void)showAvoidMessageForGroup:(Group *)group fromTime:(NSInteger)time
{
    UIViewController *vc = [self getTopMostViewController];
    [TSMessage showNotificationInViewController:vc
                                              title:[NSString stringWithFormat:@"Alerts from %@!", group.name]
                                           subtitle:@"Check it out!"
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:@"Open Map"
                                     buttonCallback:^{
                                         UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                         UINavigationController *nvc = [sb instantiateViewControllerWithIdentifier:@"nvc"];
                                         SingleGroupMapViewController *svc = nvc.viewControllers[0];
                                         svc.time = time;
                                         svc.group = group;
                                         nvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                                         [vc presentViewController:nvc animated:YES completion:NULL];
                                     }
                                         atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
}

+ (UIViewController*) getTopMostViewController
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    for (UIView *subView in [window subviews])
    {
        UIResponder *responder = [subView nextResponder];
        
        //added this block of code for iOS 8 which puts a UITransitionView in between the UIWindow and the UILayoutContainerView
        if ([responder isEqual:window])
        {
            //this is a UITransitionView
            if ([[subView subviews] count])
            {
                UIView *subSubView = [subView subviews][0]; //this should be the UILayoutContainerView
                responder = [subSubView nextResponder];
            }
        }
        
        if([responder isKindOfClass:[UIViewController class]]) {
            return [self topViewController: (UIViewController *) responder];
        }
    }
    
    return nil;
}

+ (UIViewController *) topViewController: (UIViewController *) controller
{
    BOOL isPresenting = NO;
    do {
        // this path is called only on iOS 6+, so -presentedViewController is fine here.
        UIViewController *presented = [controller presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            controller = presented;
        }
        
    } while (isPresenting);
    
    return controller;
}



@end
