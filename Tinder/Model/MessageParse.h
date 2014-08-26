#import <Parse/Parse.h>
#import "UserParse.h"

@interface MessageParse : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *fromUserParse;
@property (nonatomic, strong) PFUser *toUserParse;
@property (nonatomic, strong) NSString *text;
@end
