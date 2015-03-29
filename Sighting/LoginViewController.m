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
#import <TSMessages/TSMessage.h>


@interface LoginViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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

- (void)viewWillAppear:(BOOL)animated
{


}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y - 60);
                     }];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.scrollView.contentOffset = CGPointMake(0, 0);

                     }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)login:(id)sender {

    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if (self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager GET:[Globals urlWithPath:@"login"]
          parameters:@{@"user": self.usernameTextField.text,
                       @"pass":self.passwordTextField.text}
             success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                 NSNumber *success = (NSNumber *)responseObject[@"success"];
                 if (!success.boolValue) {
                     [Globals showAlertWithTitle:@"Login Error"
                                         message:@"Please make sure you typed in username and password!"
                                              vc:self];
                 } else {
                     NSLog(@"%@", responseObject);
                     [Globals globals].user = self.usernameTextField.text;
                     [self.delegate didFinishLoggingInWithGroups:responseObject[@"groups"]];
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [Globals showAlertWithTitle:@"Login Error"
                                     message:error.localizedDescription
                                          vc:self];
                 
             }];
    } else {
        [Globals showAlertWithTitle:@"Login Error"
                            message:@"Please enter pass/username!"
                                 vc:self];
    }
    
    
}
- (IBAction)register:(id)sender {
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if (self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];

        [manager GET:[Globals urlWithPath:@"register"]
          parameters:@{@"user": self.usernameTextField.text,
                       @"pass":self.passwordTextField.text}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSNumber *success = (NSNumber *)responseObject[@"success"];
                 if (!success.boolValue) {
                     [Globals showAlertWithTitle:@"Register Error"
                                         message:@"Username taken!"
                                              vc:self];
                 }
                 [Globals globals].user = self.usernameTextField.text;

                 [self.delegate didRegister];
                 [self dismissViewControllerAnimated:YES completion:nil];
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [Globals showAlertWithTitle:@"Register Error"
                                     message:error.localizedDescription
                                          vc:self];
                 
             }];
    } else {
        [Globals showAlertWithTitle:@"Register Error"
                            message:@"Please enter pass/username!"
                                 vc:self];
    }
    
}

@end
