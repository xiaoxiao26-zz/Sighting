//
//  DashBoardViewController.m
//  Sighting
//
//  Created by Alex Xiao on 3/27/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "DashBoardViewController.h"
#import "LocationManagerSingleton.h"
#import "MapViewController.h"
#import "AddAlertViewController.h"
#import "Group.h"

#define METERS_PER_MILE 1609.344


@interface DashBoardViewController() <CLLocationManagerDelegate, MapDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) MapViewController *mapVc;
@property (nonatomic) BOOL loggedIn;
@property (strong, nonatomic) CLLocationManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *groups;
@property (strong, nonatomic) NSMutableArray *recentAlerts;

@end


@implementation DashBoardViewController

- (void)viewDidLoad
{
    self.mapView.hidden = YES;
    self.groups = [@[] mutableCopy];
//    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    gr.numberOfTapsRequired = 2;
//    [self.view addGestureRecognizer:gr];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}



- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(self.mapView.frame, p)) {
        [self performSegueWithIdentifier:@"bigMap" sender:nil];
        NSLog(@"got a tap in the region i care about");
    } else {
        NSLog(@"got a tap, but not where i need it");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.mapVc = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.loggedIn) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NavLoginViewController *vc = [sb instantiateViewControllerWithIdentifier:@"NavLoginViewController"];
        LoginViewController *lvc = vc.viewControllers[0];
        lvc.delegate = self;
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
    }
}

- (void)didFinishLoggingInWithGroups:(NSArray *)groups
{
    for (NSDictionary* groupInfo in groups) {
        Group *group = [[Group alloc] initWithName:groupInfo[@"name"]
                                              desc:groupInfo[@"description"]
                                        alertsInfo:groupInfo[@"alerts"]];
        [self.groups addObject:group];
    }
    self.loggedIn = true;
    [self setUpMap];
}

- (void)didRegister
{
    self.loggedIn = true;
    [self setUpMap];
}

- (void)setUpMap
{
    LocationManagerSingleton *singleton = [LocationManagerSingleton sharedSingleton];
    [singleton addObserver:self
                forKeyPath:@"currentLocation"
                   options:NSKeyValueObservingOptionNew
                   context:NULL];

    self.mapView.hidden = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSValue *value = [change objectForKey:NSKeyValueChangeNewKey];

    CLLocationCoordinate2D coord = value.MKCoordinateValue;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, METERS_PER_MILE * 0.3, METERS_PER_MILE * 0.3);
    [self.mapView setRegion:viewRegion];
    [[LocationManagerSingleton sharedSingleton] removeObserver:self forKeyPath:@"currentLocation"];
    
}

- (void)updateMapViewAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
//    [self.mapView addAnnotations:self.photos];
//    [self.mapView showAnnotations:self.photos animated:YES];
}

- (void)updateAnnotations
{
    [self.mapVc.mapView removeAnnotations:self.mapVc.mapView.annotations];
    [self updateMapViewAnnotations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"map"]) {
        MapViewController *vc = segue.destinationViewController;
        vc.mapView.delegate = self;
        self.mapVc = vc;
        self.mapVc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"addAlert"]) {
        UINavigationController *nvc = segue.destinationViewController;
        AddAlertViewController *vc = nvc.viewControllers[0];
        vc.groups = self.groups;
    }
}




@end
