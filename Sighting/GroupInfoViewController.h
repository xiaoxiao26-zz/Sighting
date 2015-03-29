//
//  GroupInfoViewController.h
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "GroupSettingsViewController.h"



@interface GroupInfoViewController : UIViewController <GroupSettingsProtocol>

@property (nonatomic, strong) Group *group;
@property (nonatomic) BOOL joinMode;

@end
