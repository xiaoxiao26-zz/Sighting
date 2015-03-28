//
//  UserLocation.h
//  Sighting
//
//  Created by Alex Xiao on 3/27/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationManagerSingleton : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D currentLocation;

+ (LocationManagerSingleton *)sharedSingleton;

@end
