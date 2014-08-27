//
//  MessagesViewController.m
//  Tinder
//
//  Created by Ivan Ruiz Monjo on 26/08/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

#import "MessagesViewController.h"
#import "UserParse.h"
#import "MessageParse.h"
#import "UserMessagesViewController.h"

@interface MessagesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *usersParseArray;

@end

@implementation MessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadChatPersons];
    self.usersParseArray = [NSMutableArray new];
    // Do any additional setup after loading the view.
#warning Move to signin delegate
    if ([PFUser currentUser]) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        }];
    }
}


- (void)loadChatPersons
{
    PFQuery *messageQueryFrom = [MessageParse query];
    [messageQueryFrom whereKey:@"fromUserParse" equalTo:[UserParse currentUser]];
    PFQuery *messageQueryTo = [MessageParse query];
    [messageQueryTo whereKey:@"toUserParse" equalTo:[UserParse currentUser]];
    PFQuery *both = [PFQuery orQueryWithSubqueries:@[messageQueryFrom, messageQueryTo]];
    [both findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableSet *usersIDs = [NSMutableSet new];
        for (MessageParse *message in objects) {
            [usersIDs addObject:message.fromUserParse.objectId];
            [usersIDs addObject:message.toUserParse.objectId];
        }
        [usersIDs removeObject:[UserParse currentUser].objectId];
        PFQuery *userParse = [UserParse query];
        for (NSString *userID in usersIDs) {
            [userParse getObjectInBackgroundWithId:userID block:^(PFObject *object, NSError *error) {
                [self.usersParseArray addObject:object];
                [self.tableView reloadData];
            }];
        }

    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UserMessages"]) {
        UserMessagesViewController *vc = segue.destinationViewController;
        vc.toUserParse = [self.usersParseArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

#pragma mark UItableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UserParse *user = [self.usersParseArray objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersParseArray.count;
}

@end
