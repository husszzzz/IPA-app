#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RootViewController : UIViewController
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) UISlider *gainSlider;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *powerButton;
@property (nonatomic, strong) UIView *cardView;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. الثيم المظلم الاحترافي (Dark Theme)
    self.title = @"Moon Boost 🎧";
    self.view.backgroundColor = [UIColor colorWithWhite:0.08 alpha:1.0]; 
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    [self setupProUI];
    self.audioEngine = [[AVAudioEngine alloc] init];
}

- (void)setupProUI {
    CGFloat screenWidth = self.view.frame.size.width;
    
    // تصميم البطاقة المركزية (Card)
    self.cardView = [[UIView alloc] initWithFrame:CGRectMake(20, 150, screenWidth - 40, 380)];
    self.cardView.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    self.cardView.layer.cornerRadius = 30;
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOpacity = 0.6;
    self.cardView.layer.shadowRadius = 15;
    [self.view addSubview:self.cardView];

    // عنوان الحالة
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.cardView.frame.size.width, 40)];
    self.statusLabel.text = @"النظام جاهز";
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:self.statusLabel];

    // زر التشغيل الدائري (المتوهج)
    self.powerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.powerButton.frame = CGRectMake((self.cardView.frame.size.width - 130) / 2, 100, 130, 130);
    self.powerButton.backgroundColor = [UIColor systemBlueColor];
    self.powerButton.layer.cornerRadius = 65; // يجعله دائرياً
    [self.powerButton setTitle:@"تشغيل" forState:UIControlStateNormal];
    self.powerButton.titleLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightHeavy];
    
    // إضافة تأثير التوهج للزر
    self.powerButton.layer.shadowColor = [UIColor systemBlueColor].CGColor;
    self.powerButton.layer.shadowOpacity = 0.8;
    self.powerButton.layer.shadowRadius = 20;
    
    [self.powerButton addTarget:self action:@selector(toggleAudio) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.powerButton];

    // نص السلايدر
    UILabel *sliderTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, self.cardView.frame.size.width, 30)];
    sliderTitle.text = @"قوة التضخيم (Gain)";
    sliderTitle.textColor = [UIColor lightGrayColor];
    sliderTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    sliderTitle.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:sliderTitle];

    // سلايدر التضخيم (من 1 إلى 15 ضعف)
    self.gainSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 300, self.cardView.frame.size.width - 60, 40)];
    self.gainSlider.minimumValue = 1.0;
    self.gainSlider.maximumValue = 15.0; // قوة مضاعفة 15 مرة!
    self.gainSlider.value = 3.0;
    self.gainSlider.minimumTrackTintColor = [UIColor systemOrangeColor];
    self.gainSlider.maximumTrackTintColor = [UIColor darkGrayColor];
    
    // ربط السلايدر لتغيير الصوت باللحظة (بدون إيقاف)
    [self.gainSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.cardView addSubview:self.gainSlider];
}

// دالة تحديث الصوت باللحظة
- (void)sliderValueChanged {
    if (self.audioEngine.isRunning) {
        self.audioEngine.mainMixerNode.outputVolume = self.gainSlider.value;
    }
}

- (void)toggleAudio {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        
        // تغيير شكل الزر لحالة الإيقاف
        self.statusLabel.text = @"تم الإيقاف";
        self.statusLabel.textColor = [UIColor whiteColor];
        [self.powerButton setTitle:@"تشغيل" forState:UIControlStateNormal];
        self.powerButton.backgroundColor = [UIColor systemBlueColor];
        self.powerButton.layer.shadowColor = [UIColor systemBlueColor].CGColor;
        
    } else {
        [self startBoosting];
    }
}

- (void)startBoosting {
    // 1. تفعيل جلسة الصوت الاحترافية (تسمح بالبلوتوث والسماعات السلكية)
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord 
             withOptions:AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionDefaultToSpeaker 
                   error:nil];
    [session setActive:YES error:nil];

    AVAudioInputNode *input = self.audioEngine.inputNode;
    AVAudioMixerNode *mixer = self.audioEngine.mainMixerNode;

    // 2. ضبط مستوى التضخيم المبدئي
    mixer.outputVolume = self.gainSlider.value;

    // 3. التوصيل
    [self.audioEngine connect:input to:mixer format:[input inputFormatForBus:0]];

    // 4. التشغيل
    NSError *error;
    [self.audioEngine startAndReturnError:&error];
    
    if (error) {
        self.statusLabel.text = @"خطأ بالتشغيل!";
        self.statusLabel.textColor = [UIColor systemRedColor];
    } else {
        // تغيير شكل الزر لحالة التضخيم (أحمر خطر 🔥)
        self.statusLabel.text = @"جاري التضخيم ⚡️";
        self.statusLabel.textColor = [UIColor systemOrangeColor];
        [self.powerButton setTitle:@"إيقاف" forState:UIControlStateNormal];
        self.powerButton.backgroundColor = [UIColor systemRedColor];
        self.powerButton.layer.shadowColor = [UIColor systemRedColor].CGColor;
    }
}

@end

// --- إعدادات بدء التطبيق ---
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
