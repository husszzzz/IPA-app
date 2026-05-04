#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RootViewController : UIViewController
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioMixerNode *mainBooster;
@property (nonatomic, strong) UISlider *powerSlider;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *toggleButton;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupPureUI];
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.mainBooster = [[AVAudioMixerNode alloc] init];
}

- (void)setupPureUI {
    CGFloat screenW = self.view.frame.size.width;
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, screenW, 50)];
    header.text = @"HASSANY PURE SOUND";
    header.textColor = [UIColor whiteColor];
    header.font = [UIFont boldSystemFontOfSize:26];
    header.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:header];

    // زر التشغيل - تم استبدال الألوان المسببة للمشاكل بألوان نظام أساسية
    self.toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toggleButton.frame = CGRectMake((screenW-150)/2, 180, 150, 150);
    self.toggleButton.layer.cornerRadius = 75;
    self.toggleButton.layer.borderWidth = 4;
    self.toggleButton.layer.borderColor = [UIColor blueColor].CGColor;
    [self.toggleButton setTitle:@"تشغيل" forState:UIControlStateNormal];
    [self.toggleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.toggleButton addTarget:self action:@selector(togglePower) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toggleButton];

    // سلايدر القوة
    self.powerSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, 400, screenW-80, 40)];
    self.powerSlider.minimumValue = 1.0;
    self.powerSlider.maximumValue = 35.0; // قوة 35 ضعف تعتبر الحد الأقصى للنقاء
    self.powerSlider.value = 5.0;
    [self.powerSlider addTarget:self action:@selector(updateVolume) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.powerSlider];

    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 450, screenW, 30)];
    self.statusLabel.text = @"مستوى القوة: 5x";
    self.statusLabel.textColor = [UIColor grayColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.statusLabel];
}

- (void)updateVolume {
    self.statusLabel.text = [NSString stringWithFormat:@"مستوى القوة: %dx", (int)self.powerSlider.value];
    if (self.audioEngine.isRunning) {
        self.mainBooster.outputVolume = self.powerSlider.value;
    }
}

- (void)togglePower {
    if (self.audioEngine.isRunning) {
        [self stopEngine];
    } else {
        [self startPureEngine];
    }
}

- (void)startPureEngine {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // ضبط الجلسة لوضع المحادثة الصوتية لتفعيل ميزات عزل الصدى والضجيج برمجياً
    [session setCategory:AVAudioSessionCategoryPlayAndRecord 
             withOptions:AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionDefaultToSpeaker 
                   error:nil];
    [session setMode:AVAudioSessionModeVoiceChat error:nil];
    [session setActive:YES error:nil];

    [self.audioEngine attachNode:self.mainBooster];
    
    AVAudioInputNode *input = self.audioEngine.inputNode;
    AVAudioFormat *format = [input inputFormatForBus:0];

    [self.audioEngine connect:input to:self.mainBooster format:format];
    [self.audioEngine connect:self.mainBooster to:self.audioEngine.mainMixerNode format:format];

    self.mainBooster.outputVolume = self.powerSlider.value;
    
    NSError *error;
    [self.audioEngine startAndReturnError:&error];
    
    if (!error) {
        [self.toggleButton setTitle:@"إيقاف" forState:UIControlStateNormal];
        self.toggleButton.backgroundColor = [UIColor blueColor];
        [self.toggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)stopEngine {
    [self.audioEngine stop];
    [self.toggleButton setTitle:@"تشغيل" forState:UIControlStateNormal];
    self.toggleButton.backgroundColor = [UIColor clearColor];
    [self.toggleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}
@end

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
