#import <UIKit/UIKit.h>

// نموذج البيانات للزر
@interface SmartButton : NSObject <NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type; // "link" أو "text"
@property (nonatomic, strong) NSString *content;
@end

@implementation SmartButton
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.content forKey:@"content"];
}
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.content = [decoder decodeObjectForKey:@"content"];
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
    
    // تحميل البيانات المحفوظة
    [self loadButtons];
    
    // أزرار الشريط العلوي
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButton)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

// --- حفظ وتحميل البيانات باستخدام UserDefaults ---
- (void)saveButtons {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.buttons requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HassanyButtons"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadButtons {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HassanyButtons"];
    if (data) {
        self.buttons = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        self.buttons = [[NSMutableArray alloc] init];
    }
}

// --- إضافة زر جديد (Alert مع حقول إدخال) ---
- (void)addNewButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"إضافة زر جديد" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) { textField.placeholder = @"اسم الزر"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) { textField.placeholder = @"الرابط أو النص"; }];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"حفظ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        SmartButton *newBtn = [[SmartButton alloc] init];
        newBtn.name = alert.textFields[0].text;
        newBtn.content = alert.textFields[1].text;
        newBtn.type = [newBtn.content containsString:@"http"] ? @"link" : @"text";
        
        [self.buttons addObject:newBtn];
        [self saveButtons];
        [self.tableView reloadData];
    }];
    
    [alert addAction:save];
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

// --- إعدادات الجدول (List) ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buttons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    SmartButton *btn = self.buttons[indexPath.row];
    
    cell.textLabel.text = btn.name;
    cell.detailTextLabel.text = btn.content;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage systemImageNamed:[btn.type isEqualToString:@"link"] ? @"link.circle.fill" : @"text.bubble.fill"];
    cell.imageView.tintColor = [btn.type isEqualToString:@"link"] ? [UIColor systemBlueColor] : [UIColor systemGreenColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SmartButton *btn = self.buttons[indexPath.row];
    if ([btn.type isEqualToString:@"link"]) {
        [[UIApplication sharedApplication] openURL:https://developer.apple.com/documentation/foundation/nsurl/urlwithstring:?language=objc options:@{} completionHandler:nil];
    } else {
        UIAlertController *note = [UIAlertController alertControllerWithTitle:btn.name message:btn.content preferredStyle:UIAlertControllerStyleAlert];
        [note addAction:[UIAlertAction actionWithTitle:@"إغلاق" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:note animated:YES completion:nil];
    }
}

// حذف وترتيب
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.buttons removeObjectAtIndex:indexPath.row];
        [self saveButtons];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end

// --- تشغيل التطبيق ---
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}
@end

int main(int argc, char * argv[]) {
    @autoreleasepool { return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class])); }
}
