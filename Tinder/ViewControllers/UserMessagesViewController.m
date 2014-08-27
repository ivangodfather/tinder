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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessageAction:) name:receivedMessage object:nil];
}

- (void)receivedMessageAction:(NSDictionary *)userInfo
{
    [self loadMessages];
}

- (IBAction)sendButtonPressed:(id)sender
{
    MessageParse *message = [MessageParse object];
    message.fromUserParse = [PFUser currentUser];
    message.toUserParse = self.toUserParse;
    message.text = self.messageTextField.text;
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadMessages];
    }];

    PFQuery *query = [PFInstallation query];
    [query whereKey:@"user" equalTo:self.toUserParse];


    [PFPush sendPushMessageToQueryInBackground:query
                                   withMessage:self.messageTextField.text];
    self.messageTextField.text = @"";
    [self.tableView reloadData];

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
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
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
    [fromUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        cell.textMessageLabel.text = [[message.fromUserParse.username stringByAppendingString:@": "] stringByAppendingString:message.text];
    }];
  
    return cell;
}

@end
