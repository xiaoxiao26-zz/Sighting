//
//  MapViewController.h
//  Sighting
//
//  Created by Alex Xiao on 3/27/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@protocol MapDelegate <NSObject>

- (void)updateAnnotations;

@end

@interface MapViewController : UIViewController


@property (weak, nonatomic) id <MapDelegate> delegate;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
