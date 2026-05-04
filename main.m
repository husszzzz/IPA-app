#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RootViewController : UIViewController
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioMixerNode *mixerNode;
@property (nonatomic, strong) UISlider *gainSlider;
@property (nonatomic, strong) UILabel *gainValueLabel;
@property (nonatomic, strong) UIButton *powerButton;
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

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, screenWidth, 60)];
    headerLabel.text = @"HASSANY CLEAR"; // تحديث الاسم ليعبر عن النقاء
    headerLabel.textColor = [UIColor yellowColor];
    headerLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightHeavy];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:headerLabel];

    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(20, 180, screenWidth - 40, 400)];
    card.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    card.layer.cornerRadius = 40;
    [self.view addSubview:card];

    self.powerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.powerButton.frame = CGRectMake((card.frame.size.width - 120)/2, 40, 120, 120);
    self.powerButton.layer.cornerRadius = 60;
    self.powerButton.layer.borderWidth = 3;
    self.powerButton.layer.borderColor = [UIColor systemBlueColor].CGColor;
    [self.powerButton setTitle:@"تشغيل" forState:UIControlStateNormal];
    [self.powerButton addTarget:self action:@selector(togglePower) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:self.powerButton];

    self.gainSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 220, card.frame.size.width - 60, 40)];
    self.gainSlider.minimumValue = 1.0;
    self.gainSlider.maximumValue = 50.0; // قللتها لـ 50 للحفاظ على النقاء، الـ 100 تسبب تشويش عالي
    self.gainSlider.value = 5.0;
    [self.gainSlider addTarget:self action:@selector(gainChanged:) forControlEvents:UIControlEventValueChanged];
    [card addSubview:self.gainSlider];

    self.gainValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 270, card.frame.size.width, 40)];
    self.gainValueLabel.text = @"قوة التصفية: 5x";
    self.gainValueLabel.textColor = [UIColor whiteColor];
    self.gainValueLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:self.gainValueLabel];
}

- (void)gainChanged:(UISlider *)sender {
    self.gainValueLabel.text = [NSString stringWithFormat:@"قوة التصفية: %dx", (int)sender.value];
    if (self.audioEngine.isRunning) {
        self.mixerNode.outputVolume = sender.value;
    }
}

- (void)togglePower {
    if (self.audioEngine.isRunning) { [self stopBoosting]; } else { [self startBoosting]; }
}

- (void)startBoosting {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // الحل السحري: استخدام ModeVoiceChat لعزل الصدى والضجيج تلقائياً
    [session setCategory:AVAudioSessionCategoryPlayAndRecord 
             withOptions:AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionDefaultToSpeaker
                   error:nil];
    [session setMode:AVAudioSessionModeVoiceChat error:nil]; // تفعيل فلاتر تنقية الصوت
    [session setActive:YES error:nil];

    [self.audioEngine attachNode:self.mixerNode];
    
    AVAudioInputNode *input = self.audioEngine.inputNode;
    AVAudioFormat *format = [input inputFormatForBus:0];

    [self.audioEngine connect:input to:self.mixerNode format:format];
    [self.audioEngine connect:self.mixerNode to:self.audioEngine.mainMixerNode format:format];

    self.mixerNode.outputVolume = self.gainSlider.value;
    [self.audioEngine startAndReturnError:nil];
    
    self.powerButton.backgroundColor = [UIColor systemBlueColor];
    [self.powerButton setTitle:@"إيقاف" forState:UIControlStateNormal];
}

- (void)stopBoosting {
    [self.audioEngine stop];
    self.powerButton.backgroundColor = [UIColor clearColor];
    [self.powerButton setTitle:@"تشغيل" forState:UIControlStateNormal];
}
@end

// كود AppDelegate و main يبقى كما هو
