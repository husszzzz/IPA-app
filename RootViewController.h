#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// تعريف حالات اللعبة
typedef NS_ENUM(NSInteger, GameState) {
    GameStateMenu,
    GameStatePlaying,
    GameStateJumpscare
};

@interface RootViewController : UIViewController

// واجهات القوائم والأزرار
@property (nonatomic, strong) UIView *menuView;          // قائمة البداية
@property (nonatomic, strong) UILabel *gameTitleLabel;   // عنوان اللعبة المشع
@property (nonatomic, strong) UIButton *startButton;     // زر ابدأ اللعبة الفخم
@property (nonatomic, strong) UIView *joystickBase;      // قاعدة الجويستيك
@property (nonatomic, strong) UIView *joystickKnob;      // عصا التحكم
@property (nonatomic, strong) UIButton *actionButton;    // زر تفاعلي مطور (فلاش/ركض)

// كائنات اللعبة والميديا
@property (nonatomic, strong) UIImageView *roomBackground;
@property (nonatomic, strong) UIImageView *ghostImageView;
@property (nonatomic, strong) UIView *playerNode;        // كائن اللاعب المضيء
@property (nonatomic, strong) AVAudioPlayer *jumpscareSound;
@property (nonatomic, strong) AVAudioPlayer *bgmSound;

// منطق الـ Engine والحركة
@property (nonatomic, strong) CADisplayLink *gameTimer;  // حلقة اللعبة فائقة السلاسة
@property (nonatomic, assign) GameState currentState;
@property (nonatomic, assign) CGPoint playerPos;
@property (nonatomic, assign) CGPoint moveVelocity;
@property (nonatomic, assign) CGPoint joystickCenter;
@property (nonatomic, assign) BOOL isJoystickTouching;

@end
