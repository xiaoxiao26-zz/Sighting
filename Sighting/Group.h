//
//  Group.h
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class Alert;

@interface Group : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSMutableArray *alerts;
@property (nonatomic) NSInteger rating;

- (instancetype)initWithName:(NSString *)name desc:(NSString *)desc alertsInfo:(NSMutableArray *)alerts;
- (UIColor *)getColor;
- (void)addAlert:(Alert *)alert;

@end
