#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RootViewController : UIViewController
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioUnitVariableSpeed *speedControl; // للتحكم بالسرعة إذا أردت
@property (nonatomic, strong) UISlider *gainSlider;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"Moon Hear Boost";

    // 1. واجهة المستخدم (السلايدر والزر)
    [self setupUI];
    
    // 2. إعداد محرك الصوت
    self.audioEngine = [[AVAudioEngine alloc] init];
}

- (void)setupUI {
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, self.view.frame.size.width - 40, 30)];
    self.statusLabel.text = @"جاهز للتشغيل";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.statusLabel];

    self.gainSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 250, self.view.frame.size.width - 100, 50)];
    self.gainSlider.minimumValue = 1.0;
    self.gainSlider.maximumValue = 5.0; // قوة التضخيم (5 أضعاف)
    [self.view addSubview:self.gainSlider];

    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn.frame = CGRectMake(100, 350, self.view.frame.size.width - 200, 60);
    [startBtn setTitle:@"بدء التضخيم" forState:UIControlStateNormal];
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
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    AVAudioOutputNode *outputNode = self.audioEngine.outputNode;
    
    // إعدادات المايكروفون
    AVAudioFormat *format = [inputNode inputFormatForBus:0];

    // توصيل المايكروفون مباشرة بالمخرج (السماعة) مع التضخيم
    [self.audioEngine connect:inputNode to:outputNode format:format];

    NSError *error;
    [self.audioEngine startAndReturnError:&error];
    
    if (error) {
        self.statusLabel.text = @"خطأ في الوصول للمايكروفون";
    } else {
        self.statusLabel.text = @"جاري التضخيم الآن...";
        // ضبط مستوى الصوت (Gain) بناءً على السلايدر
        outputNode.volume = self.gainSlider.value;
    }
}

@end

// كود AppDelegate و main يبقى كما هو في مشروعك السابق
