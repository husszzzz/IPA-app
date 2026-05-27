#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HassanyGameVC : UIViewController
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *storyLabel;
@property (nonatomic, strong) UIButton *choice1Button;
@property (nonatomic, strong) UIButton *choice2Button;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *sfxPlayer;
@property (nonatomic, assign) NSInteger currentScene;
@end

@implementation HassanyGameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 1. إعداد صورة الخلفية
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    [self.view addSubview:self.bgImageView];
    
    // 2. إعداد نص القصة
    self.storyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, self.view.bounds.size.width - 40, 180)];
    self.storyLabel.numberOfLines = 0;
    self.storyLabel.textColor = [UIColor whiteColor];
    self.storyLabel.font = [UIFont boldSystemFontOfSize:20];
    self.storyLabel.textAlignment = NSTextAlignmentCenter;
    self.storyLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    self.storyLabel.layer.cornerRadius = 12;
    self.storyLabel.clipsToBounds = YES;
    [self.view addSubview:self.storyLabel];
    
    // 3. إعداد أزرار الخيارات
    self.choice1Button = [self createGameButtonWithFrame:CGRectMake(20, self.view.bounds.size.height - 220, self.view.bounds.size.width - 40, 55) color:[UIColor systemRedColor]];
    [self.choice1Button addTarget:self action:@selector(choice1Tapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.choice1Button];
    
    self.choice2Button = [self createGameButtonWithFrame:CGRectMake(20, self.view.bounds.size.height - 140, self.view.bounds.size.width - 40, 55) color:[UIColor systemGrayColor]];
    [self.choice2Button addTarget:self action:@selector(choice2Tapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.choice2Button];
    
    // تشغيل موسيقى الخلفية وبدء المشهد الأول
    [self playBackgroundMusic:@"bgm"];
    [self loadScene1];
}

- (UIButton *)createGameButtonWithFrame:(CGRect)frame color:(UIColor *)borderColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    btn.layer.cornerRadius = 10;
    btn.layer.borderWidth = 2;
    btn.layer.borderColor = borderColor.CGColor;
    return btn;
}

- (void)setGameImage:(NSString *)name {
    // يقرأ الصورة مباشرة من المجلد الرئيسي للـ Tweak
    UIImage *img = [UIImage imageNamed:name];
    if (!img) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]];
        if (path) img = [UIImage imageWithContentsOfFile:path];
    }
    self.bgImageView.image = img;
}

- (void)playBackgroundMusic:(NSString *)filename {
    // يقرأ ملف الصوت مباشرة من المجلد الرئيسي للـ Tweak
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:@"mp3"];
    if (url) {
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.audioPlayer.numberOfLoops = -1; 
        [self.audioPlayer setVolume:0.5];
        [self.audioPlayer play];
    }
}

- (void)playSoundEffect:(NSString *)filename {
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:@"mp3"];
    if (url) {
        NSError *error;
        self.sfxPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [self.sfxPlayer setVolume:1.0];
        [self.sfxPlayer play];
    }
}

// 🎬 المشاهد والسيناريو
- (void)loadScene1 {
    self.currentScene = 1;
    self.choice1Button.hidden = NO;
    self.choice2Button.hidden = NO;
    [self setGameImage:@"intro.jpg"];
    self.storyLabel.text = @"أنا الحسني... الجو بارد ومظلم. لا أتذكر كيف وصلت إلى هذا البيت المهجور، لكنني أسمع خطوات ثقيلة بالداخل والسكون مخيف...";
    [self.choice1Button setTitle:@"ادخل البيت بهدوء واستكشف" forState:UIControlStateNormal];
    [self.choice2Button setTitle:@"اكسر الباب واقتحم بقوة" forState:UIControlStateNormal];
}

- (void)loadScene2 {
    self.currentScene = 2;
    [self setGameImage:@"room.jpg"];
    self.storyLabel.text = @"دخلت الصالة الرئيسية. رائحة الغموض في كل مكان. لمحيت خزانة قديمة مغلقة، وباب القبو مفتوح ويصدر منه صوت أنفاس غريبة!";
    [self.choice1Button setTitle:@"افتح الخزانة وابحث عن سلاح" forState:UIControlStateNormal];
    [self.choice2Button setTitle:@"انزل فوراً للقبو المظلم" forState:UIControlStateNormal];
}

- (void)loadBossScene {
    self.currentScene = 3;
    [self playSoundEffect:@"jumpscare"];
    [self setGameImage:@"boss.jpg"];
    self.storyLabel.text = @"فجأة وبدون سابق إنذار!! قفز الوحش المرعب أمامك! عيونه تشع باللون الأحمر وجسمه ضخم جداً! ماذا ستفعل يا الحسني؟!";
    [btn1 setTitle:@"أطلق النار مباشرة على رأسه!" forState:UIControlStateNormal];
    [self.choice1Button setTitle:@"أطلق النار مباشرة على رأسه!" forState:UIControlStateNormal];
    [self.choice2Button setTitle:@"حاول الهروب بسرعة من النافذة!" forState:UIControlStateNormal];
}

- (void)loadGameOverSceneWithWin:(BOOL)win message:(NSString *)msg {
    self.currentScene = 4;
    self.storyLabel.text = msg;
    self.choice1Button.hidden = YES;
    [self.choice2Button setTitle:@"العب من جديد 🔄" forState:UIControlStateNormal];
}

// 🕹️ التفاعل والتحكم بالخيارات
- (void)choice1Tapped {
    if (self.currentScene == 1) {
        [self loadScene2];
    } else if (self.currentScene == 2) {
        [self loadBossScene];
    } else if (self.currentScene == 3) {
        [self loadGameOverSceneWithWin:YES message:@"كفووو! أطلقت النار بدقة على رأس الوحش وسقط أرضاً صريعاً... لقد نجوت وغلبت اللعبة يا بطل! 😎💪"];
    }
}

- (void)choice2Tapped {
    if (self.currentScene == 1) {
        [self loadScene2];
    } else if (self.currentScene == 2) {
        [self loadGameOverSceneWithWin:NO message:@"للأسف! نزلت للقبو المظلم بدون سلاح... الوحش كان ينتظرك في الظلام وافترسك! 💀 (نهاية سيئة)"];
    } else if (self.currentScene == 3) {
        [self loadGameOverSceneWithWin:NO message:@"حاولت الهرب من النافذة، لكن الوحش كان أسرع منك وأمسك بك قبل الهروب! 💔 (نهاية سيئة)"];
    } else if (self.currentScene == 4) {
        [self loadScene1]; 
    }
}

@end

__attribute__((constructor))
static void initialize_game() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        HassanyGameVC *gameVC = [[HassanyGameVC alloc] init];
        gameVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [window.rootViewController presentViewController:gameVC animated:YES completion:nil];
    });
}
