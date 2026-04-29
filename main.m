#import <UIKit/UIKit.h>

// --- واجهة التطبيق الرئيسية ---
@interface MoonRootViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation MoonRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Moon Manager";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    // تحميل البيانات بطريقة متوافقة مع iOS 12 وما فوق
    NSArray *saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"MoonDataV2"];
    self.items = saved ? [saved mutableCopy] : [NSMutableArray array];
}

- (void)addItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"إضافة" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"الاسم"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"الرابط أو النص"; }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"رابط 🔗" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { 
        [self saveItem:alert.textFields[0].text content:alert.textFields[1].text type:@"link"]; 
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"نص 📝" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { 
        [self saveItem:alert.textFields[0].text content:alert.textFields[1].text type:@"text"]; 
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveItem:(NSString *)n content:(NSString *)c type:(NSString *)t {
    if (n.length == 0 || c.length == 0) return;
    NSDictionary *item = @{@"n": n, @"c": c, @"t": t};
    [self.items addObject:item];
    [[NSUserDefaults standardUserDefaults] setObject:self.items forKey:@"MoonDataV2"];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.items.count; }

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"C"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"C"];
    NSDictionary *item = self.items[ip.row];
    cell.textLabel.text = item[@"n"];
    cell.detailTextLabel.text = [item[@"t"] isEqualToString:@"link"] ? @"رابط 🔗" : @"نص 📝";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    NSDictionary *item = self.items[ip.row];
    if ([item[@"t"] isEqualToString:@"link"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item[@"c"]] options:@{} completionHandler:nil];
    } else {
        UIAlertController *s = [UIAlertController alertControllerWithTitle:item[@"n"] message:item[@"c"] preferredStyle:UIAlertControllerStyleAlert];
        [s addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:s animated:YES completion:nil];
    }
    [tv deselectRowAtIndexPath:ip animated:YES];
}

// ميزة حذف العناصر بالسحب
- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)style forRowAtIndexPath:(NSIndexPath *)ip {
    if (style == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:ip.row];
        [[NSUserDefaults standardUserDefaults] setObject:self.items forKey:@"MoonDataV2"];
        [tv deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end

// --- الـ AppDelegate والتشغيل ---
@interface MoonAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation MoonAppDelegate
- (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)opt {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[MoonRootViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}
@end

int main(int argc, char * argv[]) {
    @autoreleasepool { return UIApplicationMain(argc, argv, nil, NSStringFromClass([MoonAppDelegate class])); }
}
