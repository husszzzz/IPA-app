#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.currentState = GameStateMenu;
    
    // 1. خلفية السرداب
    self.roomBackground = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.roomBackground.image = [UIImage imageNamed:@"dungeon.JPG"];
    self.roomBackground.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.roomBackground];
    
    // 2. اللاعب (منظور الشخص الثالث)
    self.playerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - 30, self.view.center.y - 30, 60, 60)];
    self.playerImageView.image = [UIImage imageNamed:@"player_back.png"];
    self.playerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.playerImageView.hidden = YES;
    [self.view addSubview:self.playerImageView];
    
    // 3. الوحش
    self.monsterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 70, 70)];
    self.monsterImageView.image = [UIImage imageNamed:@"ghost.png"];
    self.monsterImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.monsterImageView.hidden = YES;
    [self.view addSubview:self.monsterImageView];
    
    [self createGameControls];
    [self createMainMenu];
    [self initAudioSystem];
    
    self.gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateGameLoop:)];
    [self.gameTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)updateGameLoop:(CADisplayLink *)sender {
    if (self.currentState != GameStatePlaying) return;

    // حركة الخلفية (محاكاة المشي)
    if (self.moveVelocity.x != 0 || self.moveVelocity.y != 0) {
        CGPoint bgPos = self.roomBackground.center;
        bgPos.x -= self.moveVelocity.x * 2;
        bgPos.y -= self.moveVelocity.y * 2;
        self.roomBackground.center = bgPos;
        
        CGFloat angle = atan2(self.moveVelocity.y, self.moveVelocity.x);
        self.playerImageView.transform = CGAffineTransformMakeRotation(angle);
    }

    // الوحش يلحق باللاعب
    CGFloat dx = self.playerImageView.center.x - self.monsterImageView.center.x;
    CGFloat dy = self.playerImageView.center.y - self.monsterImageView.center.y;
    CGFloat distance = sqrt(dx*dx + dy*dy);
    
    if (distance > 50) {
        CGFloat monsterSpeed = 1.5;
        self.monsterImageView.center = CGPointMake(self.monsterImageView.center.x + (dx/distance)*monsterSpeed, 
                                                  self.monsterImageView.center.y + (dy/distance)*monsterSpeed);
        self.monsterImageView.transform = CGAffineTransformMakeRotation(atan2(dy, dx));
    } else {
        [self triggerJumpscareAttack];
    }
}

// دالة البدء
- (void)startGameButtonPressed {
    self.menuView.hidden = YES;
    self.playerImageView.hidden = NO;
    self.monsterImageView.hidden = NO;
    self.joystickBase.hidden = NO;
    self.currentState = GameStatePlaying;
}

// بناء الجويستيك (مبسط)
- (void)createGameControls {
    self.joystickBase = [[UIView alloc] initWithFrame:CGRectMake(45, self.view.bounds.size.height - 175, 130, 130)];
    self.joystickBase.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.joystickBase.layer.cornerRadius = 65;
    self.joystickBase.hidden = YES;
    [self.view addSubview:self.joystickBase];
}

// دالة الفزة
- (void)triggerJumpscareAttack {
    self.currentState = GameStateJumpscare;
    // هنا أضف كود إظهار صورة الشبح boss.JPG
}

- (void)createMainMenu { /* كود القائمة */ }
- (void)initAudioSystem { /* كود الصوت */ }

@end
