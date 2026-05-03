#import <UIKit/UIKit.h>

// --- واجهة التحكم الرئيسية ---
@interface RootViewController : UIViewController
@end

@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // خلفية بيضاء نظيفة تدعم الوضع الليلي تلقائياً
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"Moon Manager";

    // تصميم زر احترافي
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    actionButton.frame = CGRectMake(40, 250, self.view.frame.size.width - 80, 60);
    [actionButton setTitle:@"إدارة ملفات Moon" forState:UIControlStateNormal];
    
    // ستايل الزر
    actionButton.backgroundColor = [UIColor systemBlueColor];
    [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    actionButton.layer.cornerRadius = 15;
    actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    // إضافة ظل خفيف للجمالية
    actionButton.layer.shadowColor = [UIColor blackColor].CGColor;
    actionButton.layer.shadowOffset = CGSizeMake(0, 4);
    actionButton.layer.shadowOpacity = 0.2;
    actionButton.layer.shadowRadius = 5;

    [self.view addSubview:actionButton];
}
@end

// --- إدارة تشغيل التطبيق ---
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // وضع التطبيق داخل Navigation Controller لإضافة شريط علوي
    RootViewController *rootVC = [[RootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}
@end

// --- نقطة الانطلاق ---
int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
