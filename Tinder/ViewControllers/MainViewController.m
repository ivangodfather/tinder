//
//  MainViewController.m
//  Tinder
//
//  Created by Ivan Ruiz Monjo on 25/08/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}

@end
