//
//  LoginViewController.h
//  Sighting
//
//  Created by Alex Xiao on 3/27/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LoginDelegate <NSObject>

- (void)didFinishLoggingInWithGroups:(NSArray *)groups;
- (void)didRegister;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, strong) id<LoginDelegate> delegate;

@end
