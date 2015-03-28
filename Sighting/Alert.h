//
//  Alert.h
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Group.h"

@interface Alert : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *user;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (nonatomic, strong) Group *group;
@property (nonatomic) NSInteger time;
@property (nonatomic) NSDate *date;

- (instancetype)initWithUser:(NSString *)user
                       title:(NSString *)title
                         lat:(double)lat
                         lng:(double)lng
                     seconds:(NSInteger)seconds
                       group:(Group *)group;


- (NSString *)dateAsString;

@end
