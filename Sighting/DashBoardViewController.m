//
//  DashBoardViewController.m
//  Sighting
//
//  Created by Alex Xiao on 3/27/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "DashBoardViewController.h"
#import "LocationManagerSingleton.h"
#import "AddAlertViewController.h"
#import "Group.h"
#import "Globals.h"
#import "AlertTableViewCell.h"
#import "Alert.h"
#import "GroupsViewController.h"
#import "AppDelegate.h"


@interface DashBoardViewController() <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger latestAlertTime;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapHeightConstraint;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL loggedIn;
@property (strong, nonatomic) CLLocationManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *groups;
@property (strong, nonatomic) NSMutableArray *recentAlerts;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;

@property (strong, nonatomic) UIBarButtonItem *listBarButton;
@property (strong, nonatomic) UIBarButtonItem *minimizeMapBarButton;


@property (nonatomic) BOOL mapFullScreen;

@end


@implementation DashBoardViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh:)
                                                 name:@"groups"
                                               object:nil];
}

- (void)refresh:(NSNotification *)note
{
    [self processGroups:note.userInfo[@"groups"]];
}

- (void)viewDidLoad
{
    self.mapView.hidden = YES;
    self.tableView.hidden = YES;
    self.groups = [@[] mutableCopy];
    self.recentAlerts = [@[] mutableCopy];
    
    self.listBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu-44"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(listGroups)];
    self.minimizeMapBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Minimize Map"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(minimizeMap)];
    
    [self.navigationItem setRightBarButtonItem:self.listBarButton];
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.mapContainerView addGestureRecognizer:gr];
    
    UIPanGestureRecognizer *gr2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.mapContainerView addGestureRecognizer:gr2];
    [self.view bringSubviewToFront:self.mapView];
}

- (void)listGroups
{
    [self performSegueWithIdentifier:@"groups" sender:nil];
}

- (void)minimizeMap
{
    NSLog(@"minimizaing map!");
    [self.view layoutIfNeeded];
    self.mapHeightConstraint.constant = 196;

    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                           self.mapView.userInteractionEnabled = NO;
                           self.mapFullScreen = NO;
                           [self.navigationItem setRightBarButtonItem:self.listBarButton];
//                         if (self.recentAlerts.count) {
//                             Alert *alert = self.recentAlerts[[self.tableView indexPathForSelectedRow].row];
//                             
//                             MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(alert.coordinate, METERS_PER_MILE * DEFAULT_RADIUS, METERS_PER_MILE * DEFAULT_RADIUS);
//                             
//                             
//                             [UIView animateWithDuration:1.0
//                                                   delay:0.0
//                                                 options:UIViewAnimationOptionCurveEaseInOut
//                                              animations:^{
//                                                  [self.mapView setRegion:viewRegion animated:YES];
//                                                  
//                                              } completion:^(BOOL finished) {
//                                                  self.mapView.userInteractionEnabled = NO;
//                                                  self.mapFullScreen = NO;
//                                                  [self.navigationItem setRightBarButtonItem:self.listBarButton];
//                                              }];
//
//                         } else {
//                             self.mapView.userInteractionEnabled = NO;
//                             self.mapFullScreen = NO;
//                             [self.navigationItem setRightBarButtonItem:self.listBarButton];
//                         }

                     }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recentAlerts.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Recent Alerts";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alert" forIndexPath:indexPath];
    Alert *alert = [self.recentAlerts objectAtIndex:indexPath.row];
    cell.titleLabel.text = alert.title;
    cell.titleLabel.adjustsFontSizeToFitWidth = NO;
    cell.groupLabel.text = alert.group.name;
    cell.groupLabel.textColor = [alert.group getColor];
    
    return cell;
}



- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    if (!self.mapFullScreen && self.loggedIn) {
        self.mapFullScreen = YES;
        [self.view layoutIfNeeded];
        self.mapHeightConstraint.constant = self.view.frame.size.height;

        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.view layoutIfNeeded];

                         } completion:^(BOOL finished) {
//                             if (finished) {
//                                 if (self.recentAlerts.count) {
//                                     Alert *alert = self.recentAlerts[[self.tableView indexPathForSelectedRow].row];
//                                     
//                                     MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(alert.coordinate, METERS_PER_MILE * DEFAULT_RADIUS, METERS_PER_MILE * DEFAULT_RADIUS);
//                                     
//                                     [UIView animateWithDuration:1.0
//                                                           delay:0.0
//                                                         options:UIViewAnimationOptionCurveEaseInOut
//                                                      animations:^{
//                                                          [self.mapView setRegion:viewRegion animated:YES];
//                                                          
//                                                      } completion:^(BOOL finished) {
//                                                          [self updateMapViewAnnotations];
//                                                          self.mapView.userInteractionEnabled = YES;
//                                                          [self.navigationItem setRightBarButtonItem:self.minimizeMapBarButton];
//                                                      }];
//                                 } else {
//
//                                     MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([LocationManagerSingleton sharedSingleton].currentLocation, METERS_PER_MILE * DEFAULT_RADIUS, METERS_PER_MILE * DEFAULT_RADIUS);
//                                     
//                                     [UIView animateWithDuration:1.0
//                                                           delay:0.0
//                                                         options:UIViewAnimationOptionCurveEaseInOut
//                                                      animations:^{
//                                                          [self.mapView setRegion:viewRegion animated:YES];
//                                                          
//                                                      } completion:^(BOOL finished) {
//                                                          [self updateMapViewAnnotations];
//                                                          self.mapView.userInteractionEnabled = YES;
//                                                          [self.navigationItem setRightBarButtonItem:self.minimizeMapBarButton];
//                                                      }];
//                                 }
                               [self updateMapViewAnnotations];
                               self.mapView.userInteractionEnabled = YES;
                               [self.navigationItem setRightBarButtonItem:self.minimizeMapBarButton];
//                             } else {
//                                 NSLog(@"NOT FINISHED!");
//                                 self.mapView.userInteractionEnabled = NO;
//                                 [self.navigationItem setRightBarButtonItem:self.listBarButton];
//                                 self.mapFullScreen = NO;
//
//                             }
                             
                             
                         }];
    }

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;
{
    NSLog(@"selected annotation");
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row selected");
    NSLog(@"%d", self.mapFullScreen);
    Alert *alert = self.recentAlerts[indexPath.row];
    if (!self.mapFullScreen) {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(alert.coordinate, METERS_PER_MILE * DEFAULT_RADIUS, METERS_PER_MILE * DEFAULT_RADIUS);
        [self.mapView setRegion:viewRegion animated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.recentAlerts = [Globals getRecentAlertsFromGroups:self.groups];

    [self.tableView reloadData];
    [self updateMapViewAnnotations];
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
    
    [self setUpMap];

    [self processGroups:groups];
    
    self.tableView.hidden = NO;
    self.loggedIn = true;

    Alert *latestAlert = self.recentAlerts[0];
    latestAlertTime = latestAlert.time;
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate startGettingUpdates];

}

- (void)processGroups:(NSArray *)groups
{
    self.groups = [@[] mutableCopy];
    for (NSDictionary* groupInfo in groups) {
        Group *group = [[Group alloc] initWithName:groupInfo[@"name"]
                                              desc:groupInfo[@"description"]
                                        alertsInfo:groupInfo[@"alerts"]];
        group.rating = ((NSNumber *) groupInfo[@"status"]).integerValue;
        [self.groups addObject:group];
    }
    [Globals globals].groups = self.groups;
    self.recentAlerts = [Globals getRecentAlertsFromGroups:self.groups];
    
    Alert *latestAlert = self.recentAlerts[0];
    NSInteger candidateLatestAlertTime = latestAlert.time;
    if (latestAlertTime < candidateLatestAlertTime && self.loggedIn && ![latestAlert.user isEqualToString:[Globals globals].user]) {
        if (latestAlert.group.rating > 2) {
            [Globals showAttractMessageForGroup:latestAlert.group fromTime:latestAlertTime];
        } else {
            [Globals showAvoidMessageForGroup:latestAlert.group fromTime:latestAlertTime];
        }
        latestAlertTime = candidateLatestAlertTime;

    }
    [self.tableView reloadData];
    [self updateMapViewAnnotations];
}

- (void)didRegister
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate startGettingUpdates];
    self.loggedIn = true;
    self.tableView.hidden = NO;
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
    [self updateMapViewAnnotations];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSValue *value = [change objectForKey:NSKeyValueChangeNewKey];

    CLLocationCoordinate2D coord = value.MKCoordinateValue;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, METERS_PER_MILE * DEFAULT_RADIUS, METERS_PER_MILE * DEFAULT_RADIUS);
    [self.mapView setRegion:viewRegion];
    [[LocationManagerSingleton sharedSingleton] removeObserver:self forKeyPath:@"currentLocation"];
    
}

- (void)updateMapViewAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.recentAlerts];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addAlert"]) {
        UINavigationController *nvc = segue.destinationViewController;
        AddAlertViewController *vc = nvc.viewControllers[0];
        vc.groups = self.groups;
    } else if ([segue.identifier isEqualToString:@"groups"]){
        GroupsViewController *vc = segue.destinationViewController;
        vc.groups = self.groups;
    }
}




@end
