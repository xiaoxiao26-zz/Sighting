//
//  Group.m
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "Group.h"
#import "Alert.h"

@implementation Group

- (instancetype)initWithName:(NSString *)name desc:(NSString *)desc alertsInfo:(NSMutableArray *)alerts
{
    if (self = [super init]) {
        _name = name;
        _desc = desc;
        _alerts = [@[] mutableCopy];
        for (NSDictionary *alertInfo in alerts) {
            Alert *alert = [[Alert alloc] initWithUser:alertInfo[@"user"]
                                                 title:alertInfo[@"title"]
                                                   lat:((NSNumber *)alertInfo[@"lat"]).doubleValue
                                                   lng:((NSNumber *)alertInfo[@"lng"]).doubleValue
                                               seconds:((NSNumber *)alertInfo[@"time"]).integerValue
                                                  group:self];
            NSLog(@"%@", alert.description);
            [_alerts addObject:alert];
                    
                    
        }
    }
    return self;
}

@end
