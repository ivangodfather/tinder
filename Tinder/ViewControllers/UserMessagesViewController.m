//
//  UserMessagesViewController.m
//  Tinder
//
//  Created by Ivan Ruiz Monjo on 26/08/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

#import "UserMessagesViewController.h"
#import "MessageParse.h"

@interface UserMessagesViewController ()
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

@end

@implementation UserMessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)sendButtonPressed:(id)sender
{
    MessageParse *message = [MessageParse object];
    message.fromUserParse = [PFUser currentUser];

    
}

@end
