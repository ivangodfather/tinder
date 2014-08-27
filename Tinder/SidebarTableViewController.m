//
//  SidebarTableViewController.m
//  WordReminder
//
//  Created by Ivan Ruiz Monjo on 10/08/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "SidebarTableViewController.h"
#import "SWRevealViewController.h"

#define DICTIONARY_SECTION 1
#define QUIZ_SECTION 2
#define SEARCHES_SECTION 3

@interface SidebarTableViewController ()
@end

@implementation SidebarTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    //UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;



    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
    
}

@end
