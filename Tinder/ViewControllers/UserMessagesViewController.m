#import "UserMessagesViewController.h"
#import "MessageParse.h"
#import "MessageTableViewCell.h"
#import "DAKeyboardControl.h"

@interface UserMessagesViewController () <UITableViewDataSource, UITableViewDataSource>
@property NSArray *messages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UITextField *messageTextField;
@property UIToolbar *toolBar;
@property CGRect keyboardFrameInView;
@end

@implementation UserMessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeActive:)];
    [self.view addGestureRecognizer:tap];
    [self loadMessages];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessageAction:) name:receivedMessage object:nil];
    [self loadKeyboard];
}

-(void)loadKeyboard
{
    self.view.backgroundColor = [UIColor lightGrayColor];


    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     self.view.bounds.size.height - 40.0f,
                                                                     self.view.bounds.size.width,
                                                                     40.0f)];
    self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.toolBar];

    self.messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f,
                                                                           6.0f,
                                                                           self.toolBar.bounds.size.width - 20.0f - 68.0f,
                                                                           30.0f)];
    self.messageTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.messageTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.toolBar addSubview:self.messageTextField];

    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    sendButton.frame = CGRectMake(self.toolBar.bounds.size.width - 68.0f,
                                  6.0f,
                                  58.0f,
                                  29.0f);
    [sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:sendButton];


    self.view.keyboardTriggerOffset = self.toolBar.bounds.size.height;
    __weak typeof(self) weakSelf = self;

    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */

        CGRect toolBarFrame = weakSelf.toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        weakSelf.toolBar.frame = toolBarFrame;

        CGRect tableViewFrame = weakSelf.tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        weakSelf.tableView.frame = tableViewFrame;
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:weakSelf.messages.count-1 inSection:0];
        [weakSelf.tableView scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];

    }];

}

- (void)receivedMessageAction:(NSDictionary *)userInfo
{
    [self loadMessages];
}

- (void)sendButtonPressed:(UIButton *)button
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

}

//- (IBAction)reloadButtonPressed:(id)sender
//{
//    [self loadMessages];
//}

- (void)loadMessages
{
    PFQuery *query1 = [MessageParse query];
    [query1 whereKey:@"fromUserParse" equalTo:[PFUser currentUser]];
    [query1 whereKey:@"toUserParse" equalTo:self.toUserParse];

    PFQuery *query2 = [MessageParse query];
    [query2 whereKey:@"fromUserParse" equalTo:self.toUserParse];
    [query2 whereKey:@"toUserParse" equalTo:[PFUser currentUser]];

    PFQuery *orQUery = [PFQuery orQueryWithSubqueries:@[query1, query2]];

    [orQUery orderByAscending:@"createdAt"];
    [orQUery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.messages = objects;
        [self.tableView reloadData];
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }];
}

- (void)makeActive:(UITapGestureRecognizer *)tapGestureRecognizer
{
    //[self.messageTextField resignFirstResponder];
}

#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];

    MessageParse *message = [self.messages objectAtIndex:indexPath.row];
    NSLog(@"message %@", message.text);
    PFUser *fromUser = message.fromUserParse;
    [fromUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        cell.textMessageLabel.text = [[message.fromUserParse.username stringByAppendingString:@": "] stringByAppendingString:message.text];
        if ([message.fromUserParse.username isEqual:[PFUser currentUser].username]) {
            cell.backgroundColor = [UIColor greenColor];
            cell.textMessageLabel.textAlignment = NSTextAlignmentRight;
        } else {
            cell.backgroundColor = [UIColor redColor];
            cell.textMessageLabel.textAlignment = NSTextAlignmentLeft;

        }
    }];
    return cell;
}

@end