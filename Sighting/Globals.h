//
//  GlobalVars.h
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString* const kBaseUrls = @"http://sighting-env.elasticbeanstalk.com/";

@interface Globals : NSObject

+ (NSString *)urlWithPath:(NSString *)path;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc;

@end

