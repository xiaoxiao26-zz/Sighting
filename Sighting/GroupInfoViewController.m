//
//  GroupInfoViewController.m
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "GroupInfoViewController.h"
#import <MapKit/MapKit.h>
#import "GroupTableViewCell.h"
#import "Alert.h"
#import "AlertTableViewCell.h"
#import "Globals.h"
#import "GroupSettingsViewController.h"
#import "AddAlertViewController.h"

@interface GroupInfoViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *alertButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapHeightConstraint;
@property (strong, nonatomic) NSMutableArray *recentAlerts;

@end

@implementation GroupInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.title = self.group.name;
    if (self.joinMode) {
        self.barButton.title = @"Join";
        self.alertButton.hidden = YES;
    } else {
        self.barButton.title = @"Settings";
    }
    
    NSLog(@"view appearing");
    
    self.recentAlerts = [Globals getRecentAlertsFromGroups:@[self.group]];
    [self.tableView reloadData];
    [self updateMapViewAnnotations];
    if (self.recentAlerts.count) {
        Alert *alert = self.recentAlerts[0];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(alert.coordinate, METERS_PER_MILE * DEFAULT_RADIUS, METERS_PER_MILE * DEFAULT_RADIUS);
        [self.mapView setRegion:viewRegion animated:YES];
    }
   
}

- (IBAction)join:(id)sender {
    [self performSegueWithIdentifier:@"join" sender:nil];
}

- (void)viewDidLoad
{
    self.descriptionLabel.text = self.group.desc;
    [self setUpMap];
}

- (void)setUpMap
{
    self.mapView.showsUserLocation = YES;
    [self updateMapViewAnnotations];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.group.alerts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alert" forIndexPath:indexPath];
    Alert *alert = self.recentAlerts[indexPath.row];
    cell.titleLabel.text = alert.title;
    cell.titleLabel.adjustsFontSizeToFitWidth = NO;
    cell.backgroundColor = [self.group getColor];
    
    return cell;
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
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Alert *alert = self.recentAlerts[indexPath.row];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(alert.coordinate, METERS_PER_MILE * DEFAULT_RADIUS, METERS_PER_MILE * DEFAULT_RADIUS);
    [self.mapView setRegion:viewRegion animated:YES];
    
}

- (void)didJoin
{
    self.joinMode = NO;
}

- (void)updateMapViewAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.recentAlerts];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"settings"]) {
        UINavigationController *nvc = segue.destinationViewController;
        GroupSettingsViewController *vc = nvc.viewControllers[0];
        vc.group = self.group;
        vc.delegate = self;
        NSLog(@"hi");
    } else if ([segue.identifier isEqualToString:@"alert"]) {
        UINavigationController *nvc = segue.destinationViewController;
        AddAlertViewController *vc = nvc.viewControllers[0];
        vc.groups = [@[self.group] mutableCopy];
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Recent Alerts";
}


@end
