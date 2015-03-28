//
//  GroupsViewController.m
//  Sighting
//
//  Created by Alex Xiao on 3/27/15.
//  Copyright (c) 2015 Stever2Startup. All rights reserved.
//

#import "GroupsViewController.h"
#import "GroupTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "Group.h"
#import "Globals.h"

@interface GroupsViewController() <UITableViewDelegate, UITableViewDataSource>
{
    BOOL explore;
}

@property (strong, nonatomic) NSMutableArray *groupsToExplore;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GroupsViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addedGroup:)
                                                 name:@"addedGroup"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(groupUpdates:)
                                                 name:@"groupUpdates"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.groupsToExplore = [@[] mutableCopy];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{};
    [manager GET:[Globals urlWithPath:@"recommend"]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
             for (NSDictionary *groupInfo in responseObject) {
                 NSString *name = groupInfo[@"name"];
                 NSString *description = groupInfo[@"description"];
                 NSArray *alerts = groupInfo[@"alerts"];
                 Group *group = [[Group alloc] initWithName:name
                                                       desc:description
                                                 alertsInfo:[alerts mutableCopy]];
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];
}


- (void)addedGroup:(NSDictionary *)userInfo
{
    [self.groups addObject:userInfo[@"group"]];
    [self.tableView reloadData];
}

- (void)groupUpdates:(NSDictionary *)userInfo
{
    self.groups = userInfo[@"groups"];
    [self.tableView reloadData];
}

- (IBAction)changeTableViewType:(id)sender {
    explore = !explore;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!explore) {
        return self.groups.count;
    } else {
        return self.groupsToExplore.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"group" forIndexPath:indexPath];
    
   
    
    if (!explore) {
        Group *group = self.groups[indexPath.row];
        cell.textLabel.text = group.name;
        cell.detailTextLabel.text = group.description;
        cell.backgroundColor = [group getColor];
        return cell;
    } else {
        Group *group = self.groupsToExplore[indexPath.row];
        cell.textLabel.text = group.name;
        cell.detailTextLabel.text = group.description;
        return cell;
    }
}

@end
