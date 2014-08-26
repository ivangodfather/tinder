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
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuItems = @[@"enes",@"esen"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return self.menuItems.count;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *identifier = [self.menuItems objectAtIndex:indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) { return 70; }
    return 45;
}




- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //SearchViewController *svc = segue.destinationViewController;

    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    
    if (indexPath.section == QUIZ_SECTION) {
        destViewController.title = @"Quiz Game!";
    }
    if (indexPath.section == DICTIONARY_SECTION) {
        destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
        //svc.dictionary = [self.menuItems objectAtIndex:indexPath.row];
    }
    if (indexPath.section == SEARCHES_SECTION) {
        destViewController.title = @"Searches!";
    }


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
