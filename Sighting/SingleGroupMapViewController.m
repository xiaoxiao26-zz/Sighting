//
//  SingleAlertMapViewController.m
//  Sighting
//
//  Created by Alex Xiao on 3/29/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "SingleGroupMapViewController.h"
#import "Globals.h"

@interface SingleGroupMapViewController()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SingleGroupMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.group.name;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateMapViewAnnotations];
    
    NSArray *recentAlerts = [Globals getRecentAlertsFromGroups:@[self.group] sinceTime:self.time];
    Alert *alert = recentAlerts[0];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(alert.coordinate, METERS_PER_MILE * 1.5, METERS_PER_MILE * 1.5);
    [self.mapView setRegion:viewRegion];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return  nil;
    }
    
    static NSString *identifier = @"annotation";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    Alert *alert = (Alert *)annotation;
    annotationView.annotation = annotation;
    annotationView.pinColor = alert.group.rating <= 2 ? MKPinAnnotationColorRed : MKPinAnnotationColorGreen;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)updateMapViewAnnotations
{
    NSArray *recentAlerts = [Globals getRecentAlertsFromGroups:@[self.group] sinceTime:self.time];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:recentAlerts];
    
}


@end
