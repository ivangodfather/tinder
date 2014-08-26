#import "StarterViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"

@interface StarterViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation StarterViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) {
        [self showLogin];
    } else {
        [self performSegueWithIdentifier:@"mainVC" sender:nil];
    }
}

- (void) showLogin
{
    LoginViewController *logInViewController = [[LoginViewController alloc] init];

    logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsFacebook | PFLogInFieldsTwitter | PFLogInFieldsSignUpButton |PFLogInFieldsPasswordForgotten;

    logInViewController.delegate = self;

    SignupViewController *signUpViewController = [[SignupViewController alloc] init];

    signUpViewController.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsEmail | PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton | PFSignUpFieldsAdditional | PFSignUpFieldsDefault;

    [signUpViewController setDelegate:self];

    [logInViewController setSignUpController:signUpViewController];

    [self presentViewController:logInViewController animated:YES completion:NULL];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user

{
    [signUpController dismissViewControllerAnimated:YES completion:nil];
}



- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user

{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
