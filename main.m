#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface RootViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // خلفية سوداء حتى ما يبين أي بياض أثناء التحميل
    self.view.backgroundColor = [UIColor blackColor];

    // 1. إعطاء الصلاحيات الكاملة للموقع (جافا سكربت، وتخزين محلي)
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *prefs = [[WKPreferences alloc] init];
    prefs.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = prefs;
    config.websiteDataStore = [WKWebsiteDataStore defaultDataStore];

    // 2. بناء الواجهة
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self; // ضروري جداً لتشغيل أزرار موقعك بشكل صحيح
    
    // إعدادات تجربة المستخدم
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.scrollView.bounces = NO; // منع السحب المطاطي المزعج
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    // جعل الموقع يملأ الشاشة بالكامل (تجاهل النوتش)
    self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    [self.view addSubview:self.webView];

    // 3. مسح الذاكرة المؤقتة لضمان التحديث التلقائي
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // 4. تحميل الرابط مالتك (مع إجبار جلب أحدث نسخة دائماً)
    NSURL *url = [NSURL URLWithString:@"https://husszzzz.github.io/Moon/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url 
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                                       timeoutInterval:30.0];
    
    [self.webView loadRequest:request];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

// --- 5. ربط أوامر جافا سكربت بنظام الآيفون ---

// إذا موقعك طلب Alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Moon" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"موافق" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// إذا موقعك طلب Confirm (موافق/إلغاء)
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Moon" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"موافق" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { completionHandler(YES); }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { completionHandler(NO); }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

// --- إدارة تشغيل التطبيق ---
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)opt {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[RootViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}
@end

int main(int argc, char * argv[]) {
    @autoreleasepool { return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class])); }
}
