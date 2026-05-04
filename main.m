#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RootViewController : UIViewController
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioMixerNode *mixerNode;
@property (nonatomic, strong) UISlider *gainSlider;
@property (nonatomic, strong) UILabel *gainValueLabel;
@property (nonatomic, strong) UIButton *powerButton;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupHassanyLayout];
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.mixerNode = [[AVAudioMixerNode alloc] init];
}

- (void)setupHassanyLayout {
    CGFloat screenWidth = self.view.frame.size.width;

    // عنوان HASSANY PRO - استخدمنا اللون الأصفر (Gold البديل)
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, screenWidth, 60)];
    headerLabel.text = @"HASSANY PRO";
    headerLabel.textColor = [UIColor yellowColor];
    headerLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightHeavy];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:headerLabel];

    // لوحة التحكم
    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(20, 180, screenWidth - 40, 450)];
    card.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    card.layer.cornerRadius = 40;
    [self.view addSubview:card];

    // زر التشغيل - استخدمنا اللون الأزرق الأساسي
    self.powerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.powerButton.frame = CGRectMake((card.frame.size.width - 140)/2, 40, 140, 140);
    self.powerButton.layer.cornerRadius = 70;
    self.powerButton.layer.borderWidth = 4;
    self.powerButton.layer.borderColor = [UIColor systemBlueColor].CGColor;
    [self.powerButton setTitle:@"OFF" forState:UIControlStateNormal];
    [self.powerButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    self.powerButton.titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
    [self.powerButton addTarget:self action:@selector(togglePower) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:self.powerButton];

    // سلايدر التضخيم (1x to 100x)
    self.gainSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 260, card.frame.size.width - 60, 40)];
    self.gainSlider.minimumValue = 1.0;
    self.gainSlider.maximumValue = 100.0;
    self.gainSlider.value = 1.0;
    self.gainSlider.minimumTrackTintColor = [UIColor systemBlueColor];
    [self.gainSlider addTarget:self action:@selector(gainChanged:) forControlEvents:UIControlEventValueChanged];
    [card addSubview:self.gainSlider];

    // عرض رقم التضخيم
    self.gainValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 310, card.frame.size.width, 40)];
    self.gainValueLabel.text = @"BOOST: 1x";
    self.gainValueLabel.textColor = [UIColor whiteColor];
    self.gainValueLabel.font = [UIFont boldSystemFontOfSize:22];
    self.gainValueLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:self.gainValueLabel];

    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 380, card.frame.size.width, 30)];
    self.statusLabel.text = @"استخدم السماعة لتجنب الصفير";
    self.statusLabel.textColor = [UIColor lightGrayColor];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:self.statusLabel];
    
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, screenWidth, 30)];
    footer.text = @"Dev by @OM_G9";
    footer.textColor = [UIColor darkGrayColor];
    footer.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:footer];
}

- (void)gainChanged:(UISlider *)sender {
    int value = (int)sender.value;
    self.gainValueLabel.text = [NSString stringWithFormat:@"BOOST: %dx", value];
    if (self.audioEngine.isRunning) {
        self.mixerNode.outputVolume = sender.value;
    }
}

- (void)togglePower {
    if (self.audioEngine.isRunning) {
        [self stopBoosting];
    } else {
        [self startBoosting];
    }
}

- (void)startBoosting {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord 
             withOptions:AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionDefaultToSpeaker
                   error:nil];
    [session setActive:YES error:nil];

    AVAudioInputNode *input = self.audioEngine.inputNode;
    [self.audioEngine attachNode:self.mixerNode];
    
    [self.audioEngine connect:input to:self.mixerNode format:[input inputFormatForBus:0]];
    [self.audioEngine connect:self.mixerNode to:self.audioEngine.mainMixerNode format:[input inputFormatForBus:0]];

    self.mixerNode.outputVolume = self.gainSlider.value;
    [self.audioEngine startAndReturnError:nil];
    
    [self.powerButton setTitle:@"ON" forState:UIControlStateNormal];
    self.powerButton.backgroundColor = [UIColor systemBlueColor];
    [self.powerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)stopBoosting {
    [self.audioEngine stop];
    [self.powerButton setTitle:@"OFF" forState:UIControlStateNormal];
    self.powerButton.backgroundColor = [UIColor clearColor];
    [self.powerButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
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
