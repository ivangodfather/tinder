#import "MessageParse.h"

@implementation MessageParse

@dynamic fromUserParse;
@dynamic toUserParse;
@dynamic text;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"MessageParse";
}

@end
