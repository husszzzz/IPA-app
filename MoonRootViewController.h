#import <UIKit/UIKit.h>

@interface MoonItem : NSObject <NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL isLink;
@end

@interface MoonRootViewController : UITableViewController
@end
