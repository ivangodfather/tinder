//
//  ProfileViewController.m
//  Tinder
//
//  Created by Ivan Ruiz Monjo on 26/08/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *likersLabel;
@property (weak, nonatomic) IBOutlet UILabel *youLikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualityLabel;

@end

@implementation ProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self populateProfile];
}

-(void) populateProfile
{
    PFUser* theUser = [PFUser currentUser];
    NSNumber* sexuality = theUser[@"sexuality"];
    BOOL isMale = theUser[@"isMale"];
    self.navigationItem.title = theUser[@"username"];
    [theUser[@"photo"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.profilePhoto.image = [UIImage imageWithData:data];
        }
    }];
    self.ageLabel.text = [NSString stringWithFormat:@"Age: %@", theUser[@"age"]];
    if (isMale) {
        if (sexuality == [NSNumber numberWithInt:0]) {
            self.sexualityLabel.text = @"Sexuality: Homosexual";
            self.sexualityLabel.textColor = [UIColor blueColor];
        }
        if (sexuality == [NSNumber numberWithInt:1]) {
            self.sexualityLabel.text = @"Sexuality: Heterosexual";
            self.sexualityLabel.textColor = [UIColor purpleColor];
        }
    }

}


@end
