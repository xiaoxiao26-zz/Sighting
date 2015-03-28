//
//  MapViewController.m
//  Sighting
//
//  Created by Alex Xiao on 3/27/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "MapViewController.h"
#import "LocationManagerSingleton.h"
#define METERS_PER_MILE 1609.344

@interface MapViewController()


@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D coord = [LocationManagerSingleton sharedSingleton].currentLocation;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, METERS_PER_MILE * 0.3, METERS_PER_MILE * 0.3);
    [self.mapView setRegion:viewRegion];
    self.mapView.showsUserLocation = YES;
}

@end
