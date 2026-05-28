#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RootViewController : UIViewController

// عناصر اللعبة الأساسية
@property (nonatomic, strong) UIImageView *playerImageView;
@property (nonatomic, strong) UIImageView *ghostImageView;
@property (nonatomic, strong) UIImageView *roomBackground;
@property (nonatomic, strong) UIView *joystickBase;
@property (nonatomic, strong) UIView *joystickKnob;

// متغيرات الحركة والتحكم
@property (nonatomic, assign) CGPoint playerPos;
@property (nonatomic, assign) CGPoint moveVelocity;
@property (nonatomic, assign) BOOL isJoystickTouching;
@property (nonatomic, assign) CGPoint joystickCenter;

// نظام اللعبة والوقت
@property (nonatomic, assign) NSInteger currentState;
@property (nonatomic, strong) CADisplayLink *gameTimer;

// العناصر الصوتية
@property (nonatomic, strong) AVAudioPlayer *jumpscareSound;
@property (nonatomic, strong) AVAudioPlayer *bgmSound;

// دوال التحكم
- (void)createGameControls;
- (void)updateGameLoop:(CADisplayLink *)sender;
- (void)triggerJumpscareAttack;

@end
