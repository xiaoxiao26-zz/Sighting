//
//  LoginViewController.m
//  Sighting
//
//  Created by Alex Xiao on 3/27/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "LoginViewController.h"
#import "Globals.h"
#import <AFNetworking/AFNetworking.h>


@interface LoginViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:gr];
}

- (void)handleTap
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)login:(id)sender {

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[Globals urlWithPath:@"login"]
      parameters:@{@"user": self.usernameTextField.text,
                   @"pass":self.passwordTextField.text}
         success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
             if ([responseObject[@"success"] isEqualToString:@"false"]) {
                 [Globals showAlertWithTitle:@"Login Error"
                                     message:@"Stupid error"
                                          vc:self];
             }
             NSLog(@"%@", responseObject);
             [self.delegate didFinishLoggingIn];
             [self dismissViewControllerAnimated:YES completion:nil];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [Globals showAlertWithTitle:@"Login Error"
                                 message:error.localizedDescription
                                      vc:self];
             
         }];
    
}
- (IBAction)register:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager GET:[Globals urlWithPath:@"register"]
      parameters:@{@"user": self.usernameTextField.text,
                   @"pass":self.passwordTextField.text}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"%@", responseObject);
             if ([responseObject[@"success"] isEqualToString:@"false"]) {
                 [Globals showAlertWithTitle:@"Register Error"
                                     message:@"Username taken!"
                                          vc:self];
             }
             [self.delegate didFinishLoggingIn];
             [self dismissViewControllerAnimated:YES completion:nil];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [Globals showAlertWithTitle:@"Register Error"
                                 message:error.localizedDescription
                                      vc:self];
             
         }];
    
}

@end
