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
#import "UserTableViewCell.h"
#import "UserMessagesViewController.h"
#import "SPHViewController.h"

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
    NSLog(@"%@",[PFUser currentUser].objectId);
    [messageQueryFrom whereKey:@"fromUserParse" equalTo:[UserParse currentUser]];
    PFQuery *messageQueryTo = [MessageParse query];
    [messageQueryTo whereKey:@"toUserParse" equalTo:[UserParse currentUser]];
    PFQuery *both = [PFQuery orQueryWithSubqueries:@[messageQueryFrom, messageQueryTo]];

    __block int count = 0;
    [both findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableSet *usersIDs = [NSMutableSet new];
        for (MessageParse *message in objects) {
            [message.fromUserParse fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                [message.toUserParse fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {

                    [usersIDs addObject:message.fromUserParse.objectId];
                    [usersIDs addObject:message.toUserParse.objectId];
                    count++;
                    if (count == objects.count) {
                        [usersIDs removeObject:[PFUser currentUser].objectId];
                        NSLog(@"IDS %d:%@", (int)usersIDs.count, usersIDs);
                        __block int count2 = 0;
                        for (NSString *userID in usersIDs) {
                            PFQuery *userParse = [UserParse query];
                            [userParse getObjectInBackgroundWithId:userID block:^(PFObject *object, NSError *error) {
                                count2++;
                                [self.usersParseArray addObject:object];
                                if (count2 == usersIDs.count) {
                                    [self.tableView reloadData];
                                }
                            }];
                        }
                    }
                }];
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
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UserParse *user = [self.usersParseArray objectAtIndex:indexPath.row];
    cell.nameTextLabel.text = user.username;
    cell.ageTextLabel.text = user.age.description;
    [user.photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.userImageView.image = [UIImage imageWithData:data];
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersParseArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPHViewController *vc = [[SPHViewController alloc] initWithNibName:@"SPHViewController" bundle:nil];
    vc.toUserParse = [self.usersParseArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];

    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)startChat:(id)sender {


}
@end
