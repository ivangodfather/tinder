//
//  MySignUpViewController.m
//  Tinder
//
//  Created by John Blanchard on 8/26/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

#import "CustomSignUpViewController.h"
#import "UserParse.h"
#import "URBSegmentedControl.h"

 
#define MAX_AGE 99+1
#define MIN_AGE 18

@interface CustomSignUpViewController () <UIPickerViewDataSource, UIPickerViewDelegate, PFSignUpViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property NSMutableArray* ageArray;
@property URBSegmentedControl* genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton* ageButton;
@property UIImage* photo;
@property PFFile* file;
@property UIActionSheet *actionSheet;
@property NSString* errorMessage;
@property URBSegmentedControl *sexualityControl;
@end

@implementation CustomSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpSegmentedControl];
    [self setTextDelegates];
    [self populateArray];
}

-(void) setUpSegmentedControl
{
    [[URBSegmentedControl appearance] setSegmentBackgroundColor:[UIColor greenColor]];
    NSArray *genders = [NSArray arrayWithObjects:[@"MALE" uppercaseString], [@"FEMALE" uppercaseString],nil];
    NSArray *titles = [NSArray arrayWithObjects:[@"MALES" uppercaseString], [@"FEMALES" uppercaseString], [@"BISEXUAL" uppercaseString], nil];

    //	NSArray *icons = [NSArray arrayWithObjects:[UIImage imageNamed:@"mountains.png"], [UIImage imageNamed:@"snowboarder.png"], [UIImage imageNamed:@"biker.png"], nil];
    
    self.sexualityControl = [[URBSegmentedControl alloc] initWithItems:titles];
	self.sexualityControl.frame = CGRectMake(10.0, 360.0, 295.0, 40.0);
	self.sexualityControl.segmentBackgroundColor = [UIColor blueColor];
    [self.sexualityControl setSegmentBackgroundColor:[UIColor purpleColor] atIndex:1];
	[self.sexualityControl setSegmentBackgroundColor:[UIColor greenColor] atIndex:2];
	[self.view addSubview:self.sexualityControl];

    self.genderSegmentedControl = [[URBSegmentedControl alloc] initWithItems:genders];
	self.genderSegmentedControl.frame = CGRectMake(10.0, 280.0, 295.0, 40.0);
	self.genderSegmentedControl.segmentBackgroundColor = [UIColor blueColor];
	[self.genderSegmentedControl setSegmentBackgroundColor:[UIColor purpleColor] atIndex:1];
	[self.view addSubview:self.genderSegmentedControl];

	[self.sexualityControl addTarget:self action:@selector(handleSelection:) forControlEvents:UIControlEventValueChanged];
	[self.sexualityControl setControlEventBlock:^(NSInteger index, URBSegmentedControl *segmentedControl) {
	}];

    [self.genderSegmentedControl addTarget:self action:@selector(handleSelection:) forControlEvents:UIControlEventValueChanged];
	[self.genderSegmentedControl setControlEventBlock:^(NSInteger index, URBSegmentedControl *segmentedControl) {
		NSLog(@"URBSegmentedControl: control block - index=%i", index);
	}];
}

- (void)handleSelection:(id)sender {
}

#pragma mark - textField delegates
-(void)endTheEditing
{
    [self.nameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)setTextDelegates
{
    self.nameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    [self.nameTextField addTarget:self
                           action:@selector(endTheEditing)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.emailTextField addTarget:self
                            action:@selector(endTheEditing)
                  forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordTextField addTarget:self
                               action:@selector(endTheEditing)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - PickerView delegate methods
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.ageArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSNumber* num = [self.ageArray objectAtIndex:row];
    return [NSString stringWithFormat:@"%@", num];

}

#pragma mark - Button pressed methods
- (IBAction)pickImage:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)signUpHit:(id)sender
{
    if ([self checkForValidSignUp]) {
        [self onValidSignUpCreateUser];
    } else {
        [self presentErrorMessage];
    }
}

- (IBAction)ageHit:(id)sender
{
    self.actionSheet = [[UIActionSheet alloc] init];
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    self.picker.hidden = NO;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    [self.picker reloadAllComponents];
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.backgroundColor = [UIColor redColor];
    [pickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self     action:@selector(doneButtonPressed:)];
    [barItems addObject:doneBtn];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    [barItems addObject:cancelBtn];
    [pickerToolbar setItems:barItems animated:YES];
    [self.actionSheet addSubview:pickerToolbar];
    [self.actionSheet addSubview:self.picker];
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0,0,320, 475)];
    [self.picker reloadAllComponents];
    [self.actionSheet reloadInputViews];
}


#pragma mark - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.file = [PFFile fileWithData:UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage])];
    [self.file save];
}

#pragma mark - create user
-(BOOL)checkForValidSignUp
{
    if ([self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [self.nameTextField.text isEqualToString:@""] || self.file == nil || [self.ageButton.titleLabel.text isEqualToString:@"age"])
    {
        [self populateErrorMessage];
        return NO;
    } else {
        return YES;
    }
}

-(void) populateErrorMessage
{
    self.errorMessage = [[NSMutableString alloc] initWithString:@""];
    if ([self.emailTextField.text isEqualToString:@""]) {
        self.errorMessage = [self.errorMessage stringByAppendingString:@"Missing an email\n"];
    }
    if ([self.nameTextField.text isEqualToString:@""]) {
        self.errorMessage = [self.errorMessage stringByAppendingString:@"Missing a username\n"];
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        self.errorMessage = [self.errorMessage stringByAppendingString:@"Missing a password\n"];
    }
    if ([self.ageButton.titleLabel.text isEqualToString:@"age"] ) {
        self.errorMessage = [self.errorMessage stringByAppendingString:@"Tap the age button to enter an age\n"];
    }
    if (self.file == nil) {
        self.errorMessage = [self.errorMessage stringByAppendingString:@"Tap the photo button to pick a profile picture\n"];
    }
}

-(void) onValidSignUpCreateUser
{
    NSInteger row = [self.picker selectedRowInComponent:0];
    UserParse* aUser = [UserParse object];
    aUser.username = self.nameTextField.text;
    aUser.email = self.emailTextField.text;
    aUser.age = [self.ageArray objectAtIndex:row];
    aUser.password = self.passwordTextField.text;
    aUser.photo = self.file;
    if (self.genderSegmentedControl.selectedSegmentIndex == 0) {
        aUser.isMale = YES;
    } else {
        aUser.isMale = NO;
    }
    aUser.sexuality = [NSNumber numberWithInteger:self.sexualityControl.selectedSegmentIndex];
    [aUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"age %@\n name %@\n email %@\n password %@\n photo %@\n sexuality %@\n isMale %hhd", aUser.age, aUser.username, aUser.email, aUser.password, aUser.photo, aUser.sexuality, aUser.isMale);
            [self performSegueWithIdentifier:@"signup" sender:self];
        } else {
            if (error.code == 202) {
                self.errorMessage = [NSString stringWithFormat:@"username: %@ already taken", self.nameTextField.text];
            }
            if (error.code == 203) {
                self.errorMessage = [NSString stringWithFormat:@"email: %@ already taken", self.emailTextField.text];
            }
            [self presentErrorMessage];
        }
    }];
}

-(void)presentErrorMessage
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:self.errorMessage delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - Class Methods
-(void)populateArray
{
    self.ageArray = [NSMutableArray new];
    for (int i = MIN_AGE; i <= MAX_AGE; i++) {
        [self.ageArray addObject:[NSNumber numberWithInt:i]];
    }
    [self.picker reloadAllComponents];
}

- (void)cancelButtonPressed:(id)sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)doneButtonPressed:(id)sender
{
    int row = [self.picker selectedRowInComponent:0];
    [self.ageButton setTitle:[NSString stringWithFormat:@"%@",[self.ageArray objectAtIndex:row]] forState:UIControlStateNormal];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - ActionSheet delegate
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];
    self.picker.backgroundColor = [UIColor grayColor];
    //Add picker to action sheet
    [actionSheet addSubview:self.picker];
    //Gets an array af all of the subviews of our actionSheet
    NSArray *subviews = [actionSheet subviews];
    [[subviews objectAtIndex:0] setFrame:CGRectMake(20, 366, 280, 46)];
    [[subviews objectAtIndex:2] setFrame:CGRectMake(20, 317, 280, 46)];
}

@end
