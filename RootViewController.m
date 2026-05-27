#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.currentState = GameStateMenu;
    
    // 1. إنشاء الخلفية الأساسية (الغرفة)
    self.roomBackground = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.roomBackground.image = [UIImage imageNamed:@"room.JPG"];
    self.roomBackground.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.roomBackground];
    
    // 2. بناء كائن اللاعب (تصميم مصباح يدوي دائري متطور)
    self.playerNode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    self.playerNode.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25];
    self.playerNode.layer.cornerRadius = 27.5;
    self.playerNode.layer.borderColor = [UIColor whiteColor].CGColor;
    self.playerNode.layer.borderWidth = 2.5;
    self.playerNode.layer.shadowColor = [UIColor yellowColor].CGColor;
    self.playerNode.layer.shadowRadius = 20;
    self.playerNode.layer.shadowOpacity = 1.0;
    [self.view addSubview:self.playerNode];
    self.playerNode.hidden = YES; // مخفي حتى تبدأ اللعبة
    
    // 3. بناء الجويستيك والأزرار الاحترافية (PUBG Style)
    [self createGameControls];
    
    // 4. بناء كائن الشبح (boss.JPG)
    self.ghostImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.ghostImageView.image = [UIImage imageNamed:@"boss.JPG"];
    self.ghostImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.ghostImageView.hidden = YES;
    [self.view addSubview:self.ghostImageView];
    
    // 5. بناء قائمة البداية الخرافية
    [self createMainMenu];
    
    // 6. تحميل وإعداد النظام الصوتي
    [self initAudioSystem];
    
    // 7. ربط حلقة تكرار اللعبة بالمعالج (تحديث مستمر للإطارات)
    self.gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateGameLoop:)];
    [self.gameTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    // تشغيل أنيميشن رمشة الضوء بالبيت المهجور تلقائياً
    [self applyAtmosphericFlicker];
}

// 🏛️ تصميم قائمة البداية (الحسني في البيت المهجور)
- (void)createMainMenu {
    self.menuView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    
    // عنوان اللعبة المشع
    self.gameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height * 0.25, self.view.bounds.size.width - 40, 80)];
    self.gameTitleLabel.text = @"الحسني في البيت المهجور";
    self.gameTitleLabel.textColor = [UIColor redColor];
    self.gameTitleLabel.font = [UIFont boldSystemFontOfSize:38];
    self.gameTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.gameTitleLabel.layer.shadowColor = [UIColor redColor].CGColor;
    self.gameTitleLabel.layer.shadowOffset = CGSizeZero;
    self.gameTitleLabel.layer.shadowRadius = 15;
    self.gameTitleLabel.layer.shadowOpacity = 1.0;
    [self.menuView addSubview:self.gameTitleLabel];
    
    // زر ابدأ اللعبة بتصميم فخم وشفاف ونظيف (مو إيموجي!)
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startButton.frame = CGRectMake(self.view.bounds.size.width / 2 - 110, self.view.bounds.size.height * 0.55, 220, 60);
    self.startButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    [self.startButton setTitle:@"دخول البيت المهجور" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    self.startButton.layer.cornerRadius = 30;
    self.startButton.layer.borderColor = [UIColor redColor].CGColor;
    self.startButton.layer.borderWidth = 2;
    [self.startButton addTarget:self action:@selector(startGameButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:self.startButton];
    
    [self.view addSubview:self.menuView];
}

// 🕹️ بناء الجويستيك والأزرار بتصميم زجاجي عصري
- (void)createGameControls {
    // قاعدة الجويستيك الدائرية (يسار الشاشة)
    self.joystickBase = [[UIView alloc] initWithFrame:CGRectMake(45, self.view.bounds.size.height - 175, 130, 130)];
    self.joystickBase.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.07];
    self.joystickBase.layer.cornerRadius = 65;
    self.joystickBase.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    self.joystickBase.layer.borderWidth = 2;
    self.joystickBase.hidden = YES;
    
    // عصا التحكم الداخلية الملساء
    self.joystickKnob = [[UIView alloc] initWithFrame:CGRectMake(37.5, 37.5, 55, 55)];
    self.joystickKnob.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.45];
    self.joystickKnob.layer.cornerRadius = 27.5;
    self.joystickKnob.layer.borderColor = [UIColor whiteColor].CGColor;
    self.joystickKnob.layer.borderWidth = 1.5;
    [self.joystickBase addSubview:self.joystickKnob];
    [self.view addSubview:self.joystickBase];
    
    self.joystickCenter = CGPointMake(65, 65);
    self.moveVelocity = CGPointZero;
    
    // زر الأكشن التفاعلي الفخم (يمين الشاشة - للركض السريع أو الإضاءة)
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionButton.frame = CGRectMake(self.view.bounds.size.width - 125, self.view.bounds.size.height - 155, 80, 80);
    self.actionButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.actionButton.layer.cornerRadius = 40;
    self.actionButton.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    self.actionButton.layer.borderWidth = 2;
    [self.actionButton setTitle:@"RUN" forState:UIControlStateNormal];
    self.actionButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.hidden = YES;
    [self.view addSubview:self.actionButton];
}

// 🎵 تشغيل وإعداد الصوت المحيطي للعبة
- (void)initAudioSystem {
    NSString *scarePath = [[NSBundle mainBundle] pathForResource:@"jumpscare" ofType:@"mp3"];
    if (scarePath) {
        self.jumpscareSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:scarePath] error:nil];
        [self.jumpscareSound prepareToPlay];
    }
    NSString *bgmPath = [[NSBundle mainBundle] pathForResource:@"bgm" ofType:@"mp3"];
    if (bgmPath) {
        self.bgmSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:bgmPath] error:nil];
        self.bgmSound.numberOfLoops = -1;
        self.bgmSound.volume = 0.3;
    }
}

// 🎬 عند الضغط على زر بدء اللعبة وأنيميشن الدخول
- (void)startGameButtonPressed {
    [UIView animateWithDuration:0.8 animations:^{
        self.menuView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.menuView.hidden = YES;
        self.playerNode.hidden = NO;
        self.joystickBase.hidden = NO;
        self.actionButton.hidden = NO;
        
        // استدعاء نظام الترسب البدائي للاعب (Respawn Location)
        [self respawnPlayerCharacter];
        
        self.currentState = GameStatePlaying;
        if (self.bgmSound) [self.bgmSound play];
    }];
}

// 🔄 نظام الترسب (Respawn / Spawn System)
- (void)respawnPlayerCharacter {
    // ترسب اللاعب بالجهة اليسرى الآمنة من البيت المهجور
    self.playerPos = CGPointMake(self.view.bounds.size.width * 0.15, self.view.bounds.size.height * 0.5);
    self.playerNode.center = self.playerPos;
    self.playerNode.alpha = 1.0;
    self.playerNode.transform = CGAffineTransformIdentity;
}

// 🕹️ تتبع اللمس للجويستيك بـ 360 درجة حرّة (نظام حركة ببجي)
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.currentState != GameStatePlaying) return;
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.joystickBase];
    
    if (CGRectContainsPoint(self.joystickBase.bounds, touchPoint)) {
        self.isJoystickTouching = YES;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isJoystickTouching || self.currentState != GameStatePlaying) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.joystickBase];
    
    CGFloat dx = touchPoint.x - self.joystickCenter.x;
    CGFloat dy = touchPoint.y - self.joystickCenter.y;
    CGFloat distance = sqrt(dx*dx + dy*dy);
    CGFloat maxLimit = 50.0; // أقصى سحب لعصا التحكم
    
    if (distance > maxLimit) {
        dx = (dx / distance) * maxLimit;
        dy = (dy / distance) * maxLimit;
        distance = maxLimit;
    }
    
    // حركة ناعمة للعصا تحت الإبهام
    self.joystickKnob.center = CGPointMake(self.joystickCenter.x + dx, self.joystickCenter.y + dy);
    
    // حساب قوة السحب لتغيير السرعة ديناميكياً (سحب خفيف مشي، سحب قوي ركض سريع)
    CGFloat currentMaxSpeed = 5.0; 
    self.moveVelocity = CGPointMake((dx / maxLimit) * currentMaxSpeed, (dy / maxLimit) * currentMaxSpeed);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stopJoystickMovement];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stopJoystickMovement];
}

- (void)stopJoystickMovement {
    self.isJoystickTouching = NO;
    self.moveVelocity = CGPointZero;
    [UIView animateWithDuration:0.15 animations:^{
        self.joystickKnob.center = self.joystickCenter; // العودة التلقائية للمركز
    }];
}

// 🔄 حلقة تحديث إطارات اللعبة المستمرة (Game Loop)
- (void)updateGameLoop:(CADisplayLink *)sender {
    if (self.currentState != GameStatePlaying) return;
    
    if (self.moveVelocity.x != 0 || self.moveVelocity.y != 0) {
        self.playerPos.x += self.moveVelocity.x;
        self.playerPos.y += self.moveVelocity.y;
        
        // جدار الحماية الحركي: يمنع اللاعب من الخروج من شاشة الآيفون
        self.playerPos.x = MAX(28, MIN(self.view.bounds.size.width - 28, self.playerPos.x));
        self.playerPos.y = MAX(28, MIN(self.view.bounds.size.height - 28, self.playerPos.y));
        
        self.playerNode.center = self.playerPos;
        
        // 🚨 منطقة الخطر: إذا دخل اللاعب لعمق البيت المهجور (عبر 65% من عرض الشاشة يمنة)
        if (self.playerPos.x > self.view.bounds.size.width * 0.65) {
            [self triggerJumpscareAttack];
        }
    }
}

// 👻 أنيميشن هجوم الشبح المفاجئ ونظام إعادة الترسب (Respawn)
- (void)triggerJumpscareAttack {
    self.currentState = GameStateJumpscare;
    [self stopJoystickMovement];
    
    // 1. صرخة صوت الفزة الكارثية
    if (self.jumpscareSound) [self.jumpscareSound play];
    
    // 2. أنيميشن دخول الشخصية المرعبة (زوم وتكبير مفاجئ وصاعق بوجه اللاعب)
    self.ghostImageView.hidden = NO;
    self.ghostImageView.alpha = 0.0;
    self.ghostImageView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
    [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.ghostImageView.alpha = 1.0;
        self.ghostImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:nil];
    
    // 3. تأثير زلزال واهتزاز الشاشة الكلي (Screen Shake)
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation"];
    shake.duration = 0.12;
    shake.repeatCount = HUGE_VALF;
    shake.values = @[
        [NSValue valueWithCGPoint:CGPointMake(-12, -6)],
        [NSValue valueWithCGPoint:CGPointMake(12, 6)],
        [NSValue valueWithCGPoint:CGPointMake(-6, 12)],
        [NSValue valueWithCGPoint:CGPointMake(6, -12)]
    ];
    [self.view.layer addAnimation:shake forKey:@"horrorShake"];
    
    // 4. المؤقت الزمني للـ Respawn (ورا 3 ثواني من الرعب يرجع يترسب بالبداية)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.2 * NSEC_PER_SEC)), dispatch_get_main_loop(), ^{
        
        // إخفاء الشبح وإيقاف الاهتزاز الكارثي
        self.ghostImageView.hidden = YES;
        [self.view.layer removeAnimationForKey:@"horrorShake"];
        
        // تفعيل نظام إعادة الترسب الفوري للاعب
        [self respawnPlayerCharacter];
        
        // إرجاع حالة اللعبة للعب الطبيعي من جديد
        self.currentState = GameStatePlaying;
    });
}

// 🎨 أنيميشن الأجواء المرعبة (رمشة وإطفاء الضوء التلقائي للغرفة)
- (void)applyAtmosphericFlicker {
    CABasicAnimation *flickerAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    flickerAnim.duration = 0.2;
    flickerAnim.fromValue = @(1.0);
    flickerAnim.toValue = @(0.55);
    flickerAnim.autoreverses = YES;
    flickerAnim.repeatCount = HUGE_VALF;
    [self.roomBackground.layer addAnimation:flickerAnim forKey:@"roomFlicker"];
}

@end
