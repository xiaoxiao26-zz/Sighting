//
//  GlobalVars.h
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Group.h"

static NSString* const kBaseUrls = @"http://sighting-env.elasticbeanstalk.com/";
#define METERS_PER_MILE 1609.344
#define DEFAULT_RADIUS 0.3


@interface Globals : NSObject

@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSMutableArray *groups;

+ (NSString *)urlWithPath:(NSString *)path;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc;
+ (void)showCompletionAlert:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc;
+ (Globals*)globals;
+ (NSMutableArray *)getRecentAlertsFromGroups:(NSArray *)groups;
+ (UIColor *)getColorForValue:(double)value;
- (BOOL)inGroup:(Group *)group;

@end

