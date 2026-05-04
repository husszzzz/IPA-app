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
    
    // إعداد الواجهة الفخمة
    self.view.backgroundColor = [UIColor blackColor];
    [self setupHassanyLayout];
    
    // إعداد محرك الصوت
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.mixerNode = [[AVAudioMixerNode alloc] init];
}

- (void)setupHassanyLayout {
    CGFloat screenWidth = self.view.frame.size.width;

    // عنوان HASSANY PRO
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, screenWidth, 60)];
    headerLabel.text = @"HASSANY PRO";
    headerLabel.textColor = [UIColor systemCyanColor];
    headerLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightHeavy];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.layer.shadowColor = [UIColor systemCyanColor].CGColor;
    headerLabel.layer.shadowRadius = 10.0;
    headerLabel.layer.shadowOpacity = 0.5;
    [self.view addSubview:headerLabel];

    // لوحة التحكم (Control Card)
    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(20, 180, screenWidth - 40, 450)];
    card.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    card.layer.cornerRadius = 40;
    card.layer.borderWidth = 1;
    card.layer.borderColor = [UIColor colorWithWhite:0.2 alpha:1.0].CGColor;
    [self.view addSubview:card];

    // زر التشغيل الدائري الكبير
    self.powerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.powerButton.frame = CGRectMake((card.frame.size.width - 140)/2, 40, 140, 140);
    self.powerButton.backgroundColor = [UIColor clearColor];
    self.powerButton.layer.cornerRadius = 70;
    self.powerButton.layer.borderWidth = 4;
    self.powerButton.layer.borderColor = [UIColor systemCyanColor].CGColor;
    [self.powerButton setTitle:@"OFF" forState:UIControlStateNormal];
    [self.powerButton setTitleColor:[UIColor systemCyanColor] forState:UIControlStateNormal];
    self.powerButton.titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
    [self.powerButton addTarget:self action:@selector(togglePower) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:self.powerButton];

    // سلايدر التضخيم (1x to 100x)
    self.gainSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 260, card.frame.size.width - 60, 40)];
    self.gainSlider.minimumValue = 1.0;
    self.gainSlider.maximumValue = 100.0; // 100 ضعف!
    self.gainSlider.value = 1.0;
    self.gainSlider.minimumTrackTintColor = [UIColor systemCyanColor];
    self.gainSlider.maximumTrackTintColor = [UIColor darkGrayColor];
    [self.gainSlider addTarget:self action:@selector(gainChanged:) forControlEvents:UIControlEventValueChanged];
    [card addSubview:self.gainSlider];

    // عرض رقم التضخيم
    self.gainValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 310, card.frame.size.width, 40)];
    self.gainValueLabel.text = @"BOOST: 1x";
    self.gainValueLabel.textColor = [UIColor whiteColor];
    self.gainValueLabel.font = [UIFont fontWithName:@"Courier-Bold" size:22];
    self.gainValueLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:self.gainValueLabel];

    // حالة الاتصال
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 380, card.frame.size.width, 30)];
    self.statusLabel.text = @"استخدم السماعة لتجنب الصفير";
    self.statusLabel.textColor = [UIColor systemGrayColor];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:self.statusLabel];
    
    // حقوق التطوير
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, screenWidth, 30)];
    footer.text = @"Dev by @OM_G9";
    footer.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    footer.font = [UIFont systemFontOfSize:12];
    footer.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:footer];
}

- (void)gainChanged:(UISlider *)sender {
    int value = (int)sender.value;
    self.gainValueLabel.text = [NSString stringWithFormat:@"BOOST: %dx", value];
    
    if (self.audioEngine.isRunning) {
        // التحكم في قوة الصوت الخارج (تضخيم هائل)
        self.mixerNode.outputVolume = sender.value;
    }
}

- (void)togglePower {
    if (self.audioEngine.isRunning) {
        [self stopBoosting];
    } else {
        [startBoosting];
    }
}

- (void)startBoosting {
    // إعداد الجلسة للعمل في الخلفية
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord 
             withOptions:AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionDefaultToSpeaker
                   error:nil];
    [session setActive:YES error:nil];

    AVAudioInputNode *input = self.audioEngine.inputNode;
    [self.audioEngine attachNode:self.mixerNode];
    
    // توصيل المايك بالميكسر، والميكسر بالمخرج
    [self.audioEngine connect:input to:self.mixerNode format:[input inputFormatForBus:0]];
    [self.audioEngine connect:self.mixerNode to:self.audioEngine.mainMixerNode format:[input inputFormatForBus:0]];

    self.mixerNode.outputVolume = self.gainSlider.value;

    NSError *error;
    [self.audioEngine startAndReturnError:&error];
    
    if (!error) {
        [self.powerButton setTitle:@"ON" forState:UIControlStateNormal];
        self.powerButton.backgroundColor = [UIColor systemCyanColor];
        [self.powerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.powerButton.layer.shadowColor = [UIColor systemCyanColor].CGColor;
        self.powerButton.layer.shadowOpacity = 0.9;
        self.powerButton.layer.shadowRadius = 20;
    }
}

- (void)stopBoosting {
    [self.audioEngine stop];
    [self.powerButton setTitle:@"OFF" forState:UIControlStateNormal];
    self.powerButton.backgroundColor = [UIColor clearColor];
    [self.powerButton setTitleColor:[UIColor systemCyanColor] forState:UIControlStateNormal];
    self.powerButton.layer.shadowOpacity = 0;
}

@end

// --- AppDelegate ---
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
