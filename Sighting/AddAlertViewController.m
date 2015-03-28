//
//  AddAlertViewController.m
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "AddAlertViewController.h"
#import "Group.h"
#import "Globals.h"
#import "LocationManagerSingleton.h"
#import <AFNetworking/AFNetworking.h>
#import "Alert.h"

@interface AddAlertViewController() <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;


@end

@implementation AddAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleTextField.delegate = self;
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:gr];
}

- (IBAction)cancel:(id)sender {
    [self.titleTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTap
{
    [self.titleTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.groups.count == 0 ? 1 : self.groups.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.groups.count == 0) {
        return @"Join a group first!";
    } else {
        Group *group = self.groups[row];
        NSLog(@"%@", group.name);
        return group.name;
    }
}

- (IBAction)addAlert:(id)sender {
    NSInteger row = [self.picker selectedRowInComponent:0];

    Group *group = self.groups[row];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *lat = [NSString stringWithFormat:@"%f", [LocationManagerSingleton sharedSingleton].currentLocation.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f", [LocationManagerSingleton sharedSingleton].currentLocation.longitude];

    NSString *user = [Globals globals].user;
    
    NSDictionary *params = @{@"user":user,
                             @"group":group.name,
                             @"title":self.titleTextField.text,
                             @"lat":lat,
                             @"lng":lng};
    [manager GET:[Globals urlWithPath:@"add_alert"]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {


             NSLog(@"%@", responseObject);
            NSNumber *success = (NSNumber *)responseObject[@"success"];
             if (success.integerValue == 0) {
                 [Globals showAlertWithTitle:@"Add Alert Error"
                                     message:@"There was a biggg problem"
                                          vc:self];
             } else {
                 NSLog(@"%@", responseObject);
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"newAlert"
//                                                                     object:nil
//                                                                   userInfo:@{@"alert": alert];
                 [Globals showCompletionAlert:@"Success!"
                                      message:@"You have added an alert"
                                           vc:self];
                 
            
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [Globals showAlertWithTitle:@"Add Alert Error"
                                 message:error.localizedDescription
                                      vc:self];
         }];
    
    
    
}
@end
