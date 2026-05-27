// داخل دالة updateGameLoop، استبدل حركة اللاعب بهذا المنطق:

- (void)updateGameLoop:(CADisplayLink *)sender {
    if (self.currentState != GameStatePlaying) return;

    // 1. حركة الخلفية (بدال ما يتحرك اللاعب، نحرك الخلفية حتى يبين هو يمشي بالسرداب)
    if (self.moveVelocity.x != 0 || self.moveVelocity.y != 0) {
        
        // تحريك الخلفية بشكل معاكس لجهة المشي
        CGPoint bgPos = self.roomBackground.center;
        bgPos.x -= self.moveVelocity.x * 2;
        bgPos.y -= self.moveVelocity.y * 2;
        self.roomBackground.center = bgPos;
        
        // تدوير شخصية اللاعب حسب جهة الجويستيك (منظور شخص ثالث)
        CGFloat angle = atan2(self.moveVelocity.y, self.moveVelocity.x);
        self.playerImageView.transform = CGAffineTransformMakeRotation(angle);
    }

    // 2. الوحش يلحگك من وراك (يطلع من زوايا السرداب)
    CGFloat dx = self.playerImageView.center.x - self.monsterImageView.center.x;
    CGFloat dy = self.playerImageView.center.y - self.monsterImageView.center.y;
    CGFloat distance = sqrt(dx*dx + dy*dy);
    
    if (distance > 50) {
        CGFloat monsterSpeed = 1.5;
        self.monsterImageView.center = CGPointMake(self.monsterImageView.center.x + (dx/distance)*monsterSpeed, 
                                                  self.monsterImageView.center.y + (dy/distance)*monsterSpeed);
    } else {
        [self triggerJumpscareAttack];
    }
}
