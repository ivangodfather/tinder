//
//  UserTableViewCell.h
//  Tinder
//
//  Created by Ivan Ruiz Monjo on 27/08/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *ageTextLabel;
@end
