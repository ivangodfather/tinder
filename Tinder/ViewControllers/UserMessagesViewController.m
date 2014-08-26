#import "UserMessagesViewController.h"
#import "MessageParse.h"
#import "MessageTableViewCell.h"

@interface UserMessagesViewController () <UITableViewDataSource, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property NSArray *messages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation UserMessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeActive:)];
    [self.view addGestureRecognizer:tap];
    [self loadMessages];
}


- (IBAction)sendButtonPressed:(id)sender
{
    self.messageTextField.text = @"";
    MessageParse *message = [MessageParse object];
    message.fromUserParse = [PFUser currentUser];
    PFQuery *query = [UserParse query];
    [query whereKey:@"username" equalTo:@"ivan2"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        UserParse *user = objects.firstObject;
        message.toUserParse = user;
        message.text = self.messageTextField.text;
        [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadMessages];
        }];
    }];
}
- (IBAction)reloadButtonPressed:(id)sender
{
    [self loadMessages];
}

- (void)loadMessages
{
    PFQuery *query = [MessageParse query];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.messages = objects;
        [self.tableView reloadData];
    }];
}

- (void)makeActive:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.messageTextField resignFirstResponder];
}

#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    MessageParse *message = [self.messages objectAtIndex:indexPath.row];
    PFUser *fromUser = message.fromUserParse;
    [fromUser fetchIfNeeded];
    cell.textMessageLabel.text = [[message.fromUserParse.username stringByAppendingString:@": "] stringByAppendingString:message.text];

    return cell;
}

@end
