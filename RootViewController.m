#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.currentState = 1; // 1 يعني Playing
    
    // إعداد اللاعب
    self.playerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - 30, self.view.center.y - 30, 60, 60)];
    self.playerImageView.image = [UIImage imageNamed:@"player_back.png"];
    [self.view addSubview:self.playerImageView];
    
    // إعداد الوحش (ghostImageView)
    self.ghostImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 70, 70)];
    self.ghostImageView.image = [UIImage imageNamed:@"ghost.png"];
    [self.view addSubview:self.ghostImageView];
    
    self.gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateGameLoop:)];
    [self.gameTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)updateGameLoop:(CADisplayLink *)sender {
    if (self.currentState != 1) return;

    // حركة بسيطة للاعب
    if (self.moveVelocity.x != 0 || self.moveVelocity.y != 0) {
        CGFloat angle = atan2(self.moveVelocity.y, self.moveVelocity.x);
        self.playerImageView.transform = CGAffineTransformMakeRotation(angle);
    }
    
    // حركة الوحش (تطارد اللاعب)
    CGFloat dx = self.playerImageView.center.x - self.ghostImageView.center.x;
    CGFloat dy = self.playerImageView.center.y - self.ghostImageView.center.y;
    self.ghostImageView.center = CGPointMake(self.ghostImageView.center.x + (dx * 0.02), 
                                             self.ghostImageView.center.y + (dy * 0.02));
}

@end
