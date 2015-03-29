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
    return [[recentAlerts sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
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
    return [self.groups containsObject:group];
}

@end
