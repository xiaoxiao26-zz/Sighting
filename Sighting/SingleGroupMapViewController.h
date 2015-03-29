//
//  SingleAlertMapViewController.h
//  Sighting
//
//  Created by Alex Xiao on 3/29/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Alert.h"
#import "Group.h"

@interface SingleGroupMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) Group *group;
@property (nonatomic) NSInteger time;

@end
