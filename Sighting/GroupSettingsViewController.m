//
//  GroupSettingsViewController.m
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "GroupSettingsViewController.h"
#import "Globals.h"
#import <AFNetworking/AFNetworking.h>

@interface GroupSettingsViewController()
{
    CAGradientLayer *gradient;
}


@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation GroupSettingsViewController


- (void)viewDidLoad
{
    [self setupUI];
    self.title = self.group.name;
}

- (void)setupUI
{
    self.slider.backgroundColor = [UIColor clearColor];
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 5.0;
    self.slider.value = 3.0;
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button.layer setCornerRadius:5.0];;
    
    [self.button setBackgroundColor:[Globals getColorForValue:3.0]];
    gradient =[CAGradientLayer layer];
    [self addLayers];
    if (self.group.rating < 6) {
        [self.button setTitle:@"Save" forState:UIControlStateNormal];
    } else {
        [self.button setTitle:@"Join" forState:UIControlStateNormal];
    }
    
}
- (IBAction)join:(id)sender {
    if ([[Globals globals] inGroup:self.group]) {
        NSLog(@"trying to save");
        self.group.rating = self.slider.value;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"user":[Globals globals].user,
                                 @"group":self.group.name,
                                 @"status": [NSString stringWithFormat:@"%d", (int) self.slider.value]};
        [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [manager GET:[Globals urlWithPath:@"join"]
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.delegate didJoin];
                     [Globals showCompletionAlert:@"Successfully Updated!"
                                          message:[NSString stringWithFormat:@"Joined group %@", self.group.name]
                                               vc:self];
                 });
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [Globals showAlertWithTitle:@"Create Group Error"
                                     message:error.localizedDescription
                                          vc:self];
             }];
    } else {
        NSLog(@"trying to join");
        self.group.rating = self.slider.value;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"user":[Globals globals].user,
                                 @"group":self.group.name,
                                 @"status": [NSString stringWithFormat:@"%d", (int) self.slider.value]};
        [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [manager GET:[Globals urlWithPath:@"join"]
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"addedGroup"
                                                                         object:self
                                                                       userInfo:@{@"group": self.group}];
                     [self.delegate didJoin];
                     [Globals showCompletionAlert:@"Successfully Joined Group!"
                                          message:[NSString stringWithFormat:@"Joined group %@", self.group.name]
                                               vc:self];
                 });
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [Globals showAlertWithTitle:@"Create Group Error"
                                     message:error.localizedDescription
                                          vc:self];
             }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)slideValueChanged:(id)sender {
    long sliderValue = lroundf(self.slider.value);
    [self.slider setValue:sliderValue animated:YES];
    [self.button setBackgroundColor:[Globals getColorForValue:self.slider.value]];
}

-(void)addLayers
{
    UIColor *startColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    UIColor *endColor=[UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    
    gradient.frame = self.slider.bounds;
    gradient.frame = CGRectMake(0.0,11.0,self.slider.bounds.size.width,self.slider.bounds.size.height - 22.0);
    [gradient setCornerRadius:5.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
    
    [gradient setStartPoint:CGPointMake(0.0, 0.5)];
    [gradient setEndPoint:CGPointMake(1.0, 0.5)];
    
    [self.slider.layer insertSublayer:gradient atIndex:0];
    [self.slider.layer setCornerRadius:5.0];
    
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
