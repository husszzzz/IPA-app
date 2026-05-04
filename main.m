#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RootViewController : UIViewController <AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) UISlider *gainSlider;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *sideMenu;
@property (nonatomic, assign) BOOL isMenuOpen;
@property (nonatomic, assign) BOOL isRecording;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
    self.title = @"HASSANY PRO";
    
    [self setupProfessionalUI];
    [self setupSideMenu];
    
    self.audioEngine = [[AVAudioEngine alloc] init];
}

- (void)setupProfessionalUI {
    // شعار Hassany - تم تغيير اللون للأصفر الرسمي لحل الخطأ
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    logoLabel.text = @"HASSANY";
    logoLabel.textColor = [UIColor systemYellowColor]; 
    logoLabel.font = [UIFont systemFontOfSize:35 weight:UIFontWeightHeavy];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:logoLabel];

    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    menuBtn.frame = CGRectMake(20, 50, 40, 40);
    [menuBtn setTitle:@"☰" forState:UIControlStateNormal];
    [menuBtn setTintColor:[UIColor whiteColor]];
    [menuBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuBtn];

    UIButton *powerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    powerBtn.frame = CGRectMake((self.view.frame.size.width-150)/2, 250, 150, 150);
    powerBtn.backgroundColor = [UIColor systemBlueColor];
    powerBtn.layer.cornerRadius = 75;
    [powerBtn setTitle:@"START" forState:UIControlStateNormal];
    powerBtn.layer.shadowColor = [UIColor systemBlueColor].CGColor;
    powerBtn.layer.shadowOpacity = 0.5;
    powerBtn.layer.shadowRadius = 20;
    [powerBtn addTarget:self action:@selector(toggleBoost) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:powerBtn];

    UIButton *recBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    recBtn.frame = CGRectMake((self.view.frame.size.width-100)/2, 450, 100, 50);
    [recBtn setTitle:@"⏺ RECORD" forState:UIControlStateNormal];
    [recBtn setTitleColor:[UIColor systemRedColor] forState:UIControlStateNormal];
    [recBtn addTarget:self action:@selector(toggleRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recBtn];
}

- (void)setupSideMenu {
    self.sideMenu = [[UIView alloc] initWithFrame:CGRectMake(-250, 0, 250, self.view.frame.size.height)];
    self.sideMenu.backgroundColor = [UIColor colorWithWhite:0.12 alpha:1.0];
    [self.view addSubview:self.sideMenu];

    UILabel *teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-100, 230, 60)];
    teamLabel.numberOfLines = 2;
    teamLabel.text = @"فريق التطوير: الحسني\n@OM_G9";
    teamLabel.textColor = [UIColor lightGrayColor];
    teamLabel.textAlignment = NSTextAlignmentCenter;
    [self.sideMenu addSubview:teamLabel];
}

- (void)toggleMenu {
    self.isMenuOpen = !self.isMenuOpen;
    [UIView animateWithDuration:0.3 animations:^{
        self.sideMenu.frame = CGRectMake(self.isMenuOpen ? 0 : -250, 0, 250, self.view.frame.size.height);
    }];
}

- (void)toggleBoost {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
    } else {
        [self startAudioEngine];
    }
}

- (void)startAudioEngine {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord 
             withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetooth
                   error:nil];
    [session setActive:YES error:nil];

    AVAudioInputNode *input = self.audioEngine.inputNode;
    [self.audioEngine connect:input to:self.audioEngine.mainMixerNode format:[input inputFormatForBus:0]];
    [self.audioEngine startAndReturnError:nil];
}

- (void)toggleRecording {
    if (self.isRecording) {
        [self.recorder stop];
        self.isRecording = NO;
    } else {
        [self startRecording];
        self.isRecording = YES;
    }
}

- (void)startRecording {
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hassany_rec.m4a"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSDictionary *settings = @{AVFormatIDKey: @(kAudioFormatMPEG4AAC), AVSampleRateKey: @44100.0, AVNumberOfChannelsKey: @2};
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
    [self.recorder record];
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
