#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RootViewController : UIViewController
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) UISlider *gainSlider;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.title = @"Moon Hear Boost";
    [self setupUI];
    self.audioEngine = [[AVAudioEngine alloc] init];
}

- (void)setupUI {
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, self.view.frame.size.width - 40, 30)];
    self.statusLabel.text = @"جاهز للتشغيل";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.statusLabel];

    self.gainSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 250, self.view.frame.size.width - 100, 50)];
    self.gainSlider.minimumValue = 0.0;
    self.gainSlider.maximumValue = 1.0; 
    self.gainSlider.value = 0.5;
    [self.view addSubview:self.gainSlider];

    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn.frame = CGRectMake(100, 350, self.view.frame.size.width - 200, 60);
    [startBtn setTitle:@"بدء / إيقاف" forState:UIControlStateNormal];
    startBtn.backgroundColor = [UIColor systemBlueColor];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startBtn.layer.cornerRadius = 15;
    [startBtn addTarget:self action:@selector(toggleAudio) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}

- (void)toggleAudio {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        self.statusLabel.text = @"توقف التضخيم";
    } else {
        [self startBoosting];
    }
}

- (void)startBoosting {
    AVAudioInputNode *input = self.audioEngine.inputNode;
    self.audioEngine.mainMixerNode.outputVolume = self.gainSlider.value;
    [self.audioEngine connect:input to:self.audioEngine.mainMixerNode format:[input inputFormatForBus:0]];
    
    NSError *error;
    [self.audioEngine startAndReturnError:&error];
    self.statusLabel.text = error ? @"خطأ" : @"جاري التضخيم...";
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
