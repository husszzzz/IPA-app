#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RootViewController : UIViewController
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioMixerNode *boosterNode;
@property (nonatomic, strong) UISlider *gainSlider;
@property (nonatomic, strong) UILabel *gainLabel;
@property (nonatomic, strong) UIButton *actionButton;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // واجهة Hassany الاحترافية
    [self setupProfessionalUI];
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.boosterNode = [[AVAudioMixerNode alloc] init];
}

- (void)setupProfessionalUI {
    CGFloat w = self.view.frame.size.width;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, w, 50)];
    title.text = @"HASSANY PURE BOOST";
    title.textColor = [UIColor systemYellowColor];
    title.font = [UIFont boldSystemFontOfSize:28];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];

    // زر التشغيل
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionButton.frame = CGRectMake((w-140)/2, 180, 140, 140);
    self.actionButton.layer.cornerRadius = 70;
    self.actionButton.layer.borderWidth = 5;
    self.actionButton.layer.borderColor = [UIColor systemBlueColor].CGColor;
    [self.actionButton setTitle:@"START" forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.actionButton];

    // سلايدر القوة
    self.gainSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, 380, w-80, 40)];
    self.gainSlider.minimumValue = 1.0;
    self.gainSlider.maximumValue = 40.0; // 40 ضعف كافية جداً للنقاء
    self.gainSlider.value = 5.0;
    [self.gainSlider addTarget:self action:@selector(volumeChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.gainSlider];

    self.gainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 430, w, 30)];
    self.gainLabel.text = @"قوة التضخيم: 5x";
    self.gainLabel.textColor = [UIColor whiteColor];
    self.gainLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.gainLabel];
}

- (void)volumeChanged {
    self.gainLabel.text = [NSString stringWithFormat:@"قوة التضخيم: %dx", (int)self.gainSlider.value];
    if (self.audioEngine.isRunning) {
        self.boosterNode.outputVolume = self.gainSlider.value;
    }
}

- (void)handleAction {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        [self.actionButton setTitle:@"START" forState:UIControlStateNormal];
        self.actionButton.backgroundColor = [UIColor clearColor];
    } else {
        [self startPureEngine];
    }
}

- (void)startPureEngine {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // سر النقاء: استخدام ModeMeasurement أو VoiceChat لتقليل المعالجة الخارجية والضجيج
    [session setCategory:AVAudioSessionCategoryPlayAndRecord 
             withOptions:AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionDefaultToSpeaker 
                   error:nil];
    [session setMode:AVAudioSessionModeVoiceChat error:nil];
    [session setActive:YES error:nil];

    [self.audioEngine attachNode:self.boosterNode];
    
    AVAudioInputNode *input = self.audioEngine.inputNode;
    AVAudioFormat *format = [input inputFormatForBus:0];

    // توصيل المايك بالمضخم ثم للمخرج
    [self.audioEngine connect:input to:self.boosterNode format:format];
    [self.audioEngine connect:self.boosterNode to:self.audioEngine.mainMixerNode format:format];

    self.boosterNode.outputVolume = self.gainSlider.value;
    
    NSError *error;
    [self.audioEngine startAndReturnError:&error];
    
    if(!error) {
        [self.actionButton setTitle:@"STOP" forState:UIControlStateNormal];
        self.actionButton.backgroundColor = [UIColor systemBlueColor];
        [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
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
