//
//  UserParse.m
//  Tinder
//
//  Created by Ivan Ruiz Monjo on 26/08/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

#import "UserParse.h"

@implementation UserParse

@dynamic age;
@dynamic photo;
@dynamic isMale;
@dynamic sexuality;

+ (void)load {
    [self registerSubclass];
}



@end
