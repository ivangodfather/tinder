#import <Parse/Parse.h>
#import "UserParse.h"

@interface MessageParse : PFObject <PFSubclassing>

@property (nonatomic, strong) UserParse *fromUserParse;
@property (nonatomic, strong) UserParse *toUserParse;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *status;
@end
