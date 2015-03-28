//
//  UserLocation.m
//  Sighting
//
//  Created by Alex Xiao on 3/27/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "LocationManagerSingleton.h"

@interface LocationManagerSingleton()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation LocationManagerSingleton 


- (instancetype)init
{
    if (self = [super init]) {
        _locationManager = [CLLocationManager new];

        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];

        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [_locationManager startUpdatingLocation];
    }
    
    return self;
}

+ (LocationManagerSingleton*)sharedSingleton {
    static LocationManagerSingleton* sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [LocationManagerSingleton new];

    });
    return sharedSingleton;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = manager.location.coordinate;
}


@end
