#import <UIKit/UIKit.h>

// --- 1. قسم واجهة المستخدم (ViewController) ---
@interface RootViewController : UIViewController
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // لون خلفية التطبيق
    self.view.backgroundColor = [UIColor whiteColor];

    // تصميم الزر
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeSystem];
    myButton.frame = CGRectMake(0, 0, 200, 50);
    myButton.center = self.view.center; // يخلي الزر بنص الشاشة
    
    [myButton setTitle:@"اضغط هنا يا حسين" forState:UIControlStateNormal];
    myButton.backgroundColor = [UIColor blackColor];
    [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    myButton.layer.cornerRadius = 12; // يخلي حواف الزر دائرية مرتبة
    myButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    // ربط الزر بأمر معين (لما تضغط عليه)
    [myButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    // إضافة الزر للشاشة
    [self.view addSubview:myButton];
}

// الأمر اللي يتنفذ لما تضغط على الزر
- (void)buttonTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"مرحباً بك!" 
                                                                   message:@"عاشت إيدك، التطبيق شغال 100% وتقدر هسة تضيف أزرار أكثر." 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"تمام" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end

// --- 2. قسم المحرك الأساسي (AppDelegate) ---
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[RootViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

// --- 3. نقطة انطلاق التطبيق (Main Function) ---
int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
