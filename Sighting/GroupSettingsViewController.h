//
//  GroupSettingsViewController.h
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

@protocol GroupSettingsProtocol <NSObject>

- (void)didJoin;

@end

@interface GroupSettingsViewController : UIViewController

@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) id <GroupSettingsProtocol> delegate;

@end
