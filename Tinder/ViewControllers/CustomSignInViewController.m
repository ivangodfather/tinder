//
//  CustomSignInViewController.m
//  Tinder
//
//  Created by John Blanchard on 8/27/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

#define emailIdentifier @"@"

#import "CustomSignInViewController.h"

@interface CustomSignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation CustomSignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Resign the textField's keyboard
- (IBAction)resignTheKeyboard:(UITextField*)sender
{
    [sender resignFirstResponder];
}

#pragma mark - login button pressed
- (IBAction)enterTinderWorld:(id)sender
{
    [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (error) {
            [self showAlertForInvalidLogin];
        } else {
            [self performSegueWithIdentifier:@"login" sender:self];
        }
    }];
}

#pragma mark - alert message
-(void) showAlertForInvalidLogin
{
    NSString* message = @"";
    if ([self.emailTextField.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Blank login field\n"];
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Blank password field\n"];
    }
    message = [message stringByAppendingString:@"Enter valid login credentials"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error with login" message:message delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
    [alert show];
}

@end
