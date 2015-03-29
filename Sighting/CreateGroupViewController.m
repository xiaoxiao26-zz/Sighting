//
//  CreateGroupViewController.m
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "Globals.h"
#import <AFNetworking/AFNetworking.h>
#import "Group.h"

@interface CreateGroupViewController() <UITextFieldDelegate, UITextViewDelegate>
{
    CAGradientLayer *gradient;

}

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation CreateGroupViewController

- (void)viewDidLoad
{
    [self setupUI];
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:gr];
}

- (void)setupUI
{
    self.slider.backgroundColor = [UIColor clearColor];
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 5.0;
    self.slider.value = 3.0;
    [self.createButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.createButton.layer setCornerRadius:5.0];
    [[self.descriptionTextView layer] setBorderColor:[[UIColor colorWithWhite:0.85 alpha:1.0] CGColor]];
    [[self.descriptionTextView layer] setBorderWidth:0.6];
    [[self.descriptionTextView layer] setCornerRadius:3.5];
    
    [self.createButton setBackgroundColor:[Globals getColorForValue:3.0]];
    gradient =[CAGradientLayer layer];
    [self addLayers];

}


- (void)handleTap
{
    [self.nameTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)slideValueChanged:(id)sender {
    long sliderValue = lroundf(self.slider.value);
    [self.slider setValue:sliderValue animated:YES];
    [self.createButton setBackgroundColor:[Globals getColorForValue:self.slider.value]];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSDictionary *textAttributes = @{NSFontAttributeName : textView.font};
    
    CGFloat textWidth = CGRectGetWidth(UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset));
    textWidth -= 2.0f * textView.textContainer.lineFragmentPadding;
    CGRect boundingRect = [newText boundingRectWithSize:CGSizeMake(textWidth, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                             attributes:textAttributes
                                                context:nil];
    
    NSUInteger numberOfLines = CGRectGetHeight(boundingRect) / textView.font.lineHeight;
    
    return newText.length <= 500 && numberOfLines <= 4;
}

- (IBAction)create:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user":[Globals globals].user,
                             @"group":self.nameTextField.text,
                             @"status": [NSString stringWithFormat:@"%d", (int) self.slider.value],
                             @"description": self.descriptionTextView.text};
    Group *group = [[Group alloc] initWithName:self.nameTextField.text
                                          desc:self.descriptionTextView.text
                                    alertsInfo:[@[] mutableCopy]];
    group.rating = self.slider.value;
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:[Globals urlWithPath:@"join"]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"%@", responseObject);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"addedGroup"
                                                                     object:self
                                                                   userInfo:@{@"group": group}];
                 [Globals showCompletionAlert:@"Successfully Created Group!"
                                      message:[NSString stringWithFormat:@"Created group %@", group.name]
                                           vc:self];
             });
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [Globals showAlertWithTitle:@"Create Group Error"
                                 message:error.localizedDescription
                                      vc:self];
         }];
                                        
}

@end
