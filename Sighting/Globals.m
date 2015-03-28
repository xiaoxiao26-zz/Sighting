//
//  GlobalVars.m
//  Sighting
//
//  Created by Alex Xiao on 3/28/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "Globals.h"

@implementation Globals

+ (NSString *)urlWithPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@/%@", kBaseUrls, path];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)showCompletionAlert:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [vc dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (Globals*)globals {
    static Globals* sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [Globals new];
        
    });
    return sharedSingleton;
}

@end
