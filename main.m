#import <UIKit/UIKit.h>

// نموذج البيانات للزر
@interface SmartButton : NSObject <NSSecureCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@end

@implementation SmartButton
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.content forKey:@"content"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectOfClass:[NSString class] forKey:@"name"];
        self.type = [decoder decodeObjectOfClass:[NSString class] forKey:@"type"];
        self.content = [decoder decodeObjectOfClass:[NSString class] forKey:@"content"];
    }
    return self;
}
@end

// الواجهة الرئيسية
@interface RootViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray<SmartButton *> *buttons;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"أزراري الذكية";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    
    [self loadButtons];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButton)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)saveButtons {
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.buttons requiringSecureCoding:NO error:&error];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HassanyButtons"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadButtons {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyButtons"];
    if (data) {
        NSSet *set = [NSSet setWithArray:@[[NSMutableArray class], [SmartButton class]]];
        self.buttons = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:nil];
    }
    if (!self.buttons) {
        self.buttons = [[NSMutableArray alloc] init];
    }
}

- (void)addNewButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"إضافة زر جديد" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"اسم الزر"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *t) { t.placeholder = @"الرابط أو النص"; }];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"حفظ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        SmartButton *nb = [[SmartButton alloc] init];
        nb.name = alert.textFields[0].text;
        nb.content = alert.textFields[1].text;
        nb.type = [nb.content hasPrefix:@"http"] ? @"link" : @"text";
        [self.buttons addObject:nb];
        [self saveButtons];
        [self.tableView reloadData];
    }];
    [alert addAction:save];
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.buttons.count; }

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *c = [tv dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"c"];
    SmartButton *b = self.buttons[ip.row];
    c.textLabel.text = b.name;
    c.detailTextLabel.text = b.content;
    c.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    c.imageView.image = [UIImage systemImageNamed:[b.type isEqualToString:@"link"] ? @"link.circle.fill" : @"text.bubble.fill"];
    return c;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    SmartButton *b = self.buttons[ip.row];
    if ([b.type isEqualToString:@"link"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:b.content] options:@{} completionHandler:nil];
    } else {
        UIAlertController *n = [UIAlertController alertControllerWithTitle:b.name message:b.content preferredStyle:UIAlertControllerStyleAlert];
        [n addAction:[UIAlertAction actionWithTitle:@"إغلاق" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:n animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)s forRowAtIndexPath:(NSIndexPath *)ip {
    if (s == UITableViewCellEditingStyleDelete) {
        [self.buttons removeObjectAtIndex:ip.row];
        [self saveButtons];
        [tv deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)opt {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}
@end

int main(int argc, char * argv[]) {
    @autoreleasepool { return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class])); }
}
