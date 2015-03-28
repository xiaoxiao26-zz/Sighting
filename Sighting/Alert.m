//
//  Alert.m
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "Alert.h"

@implementation Alert

- (instancetype)initWithUser:(NSString *)user title:(NSString *)title lat:(double)lat lng:(double)lng seconds:(NSInteger)seconds group:(Group *)group
{
    if (self = [super init]) {
        _user = user;
        _title = title;
        _lat = lat;
        _lng = lng;
        _group = group;
        _time = seconds;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = self.lat;
    coordinate.longitude = self.lng;
    
    return coordinate;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"User: %@, Title: %@, lat: %f, lng: %f",self.user, self.title, self.lat, self.lng];
}


@end
