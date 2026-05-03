#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
@end

@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"Moon Manager";

    // زر الأول: إدارة الملفات
    UIButton *btn1 = [self createButtonWithTitle:@"إدارة الملفات" yPostion:200 color:[UIColor systemBlueColor]];
    [self.view addSubview:btn1];

    // زر الثاني: الإعدادات
    UIButton *btn2 = [self createButtonWithTitle:@"الإعدادات" yPostion:270 color:[UIColor systemIndigoColor]];
    [self.view addSubview:btn2];
}

- (UIButton *)createButtonWithTitle:(NSString *)title yPostion:(CGFloat)y color:(UIColor *)color {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(50, y, self.view.frame.size.width - 100, 50);
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = color;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 12;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    return btn;
}
@end

// بقية الكود الأساسي (AppDelegate و Main) يفضل بقاؤه كما هو لضمان التشغيل
