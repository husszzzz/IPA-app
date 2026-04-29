#import "MoonRootViewController.h"

@implementation MoonItem
- (void)encodeWithCoder:(NSCoder *)enc { [enc encodeObject:_name forKey:@"n"]; [enc encodeObject:_content forKey:@"c"]; [enc encodeBool:_isLink forKey:@"l"]; }
- (id)initWithCoder:(NSCoder *)dec { self = [super init]; _name = [dec decodeObjectForKey:@"n"]; _content = [dec decodeObjectForKey:@"c"]; _isLink = [dec decodeBoolForKey:@"l"]; return self; }
@end

@interface MoonRootViewController ()
@property (nonatomic, strong) NSMutableArray<MoonItem *> *items;
@end

@implementation MoonRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Moon Manager";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    [self loadData];
}

- (void)addNewItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"إضافة محتوى" message:@"املأ البيانات واختر النوع" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"اسم الزر"; }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) { tf.placeholder = @"الرابط أو النص"; }];
    
    UIAlertAction *linkAction = [UIAlertAction actionWithTitle:@"حفظ كرابط 🔗" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveWithTitle:alert.textFields[0].text content:alert.textFields[1].text isLink:YES];
    }];
    
    UIAlertAction *textAction = [UIAlertAction actionWithTitle:@"حفظ كنص 📝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveWithTitle:alert.textFields[0].text content:alert.textFields[1].text isLink:NO];
    }];
    
    [alert addAction:linkAction];
    [alert addAction:textAction];
    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveWithTitle:(NSString *)title content:(NSString *)content isLink:(BOOL)isLink {
    if (title.length == 0 || content.length == 0) return;
    MoonItem *item = [[MoonItem alloc] init];
    item.name = title; item.content = content; item.isLink = isLink;
    [self.items addObject:item];
    [self saveData];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    MoonItem *item = self.items[ip.row];
    if (item.isLink) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.content] options:@{} completionHandler:nil];
    } else {
        UIAlertController *showText = [UIAlertController alertControllerWithTitle:item.name message:item.content preferredStyle:UIAlertControllerStyleAlert];
        [showText addAction:[UIAlertAction actionWithTitle:@"إغلاق" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:showText animated:YES completion:nil];
    }
    [tv deselectRowAtIndexPath:ip animated:YES];
}

- (void)saveData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.items requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"MoonStore"];
}

- (void)loadData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"MoonStore"];
    self.items = data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : [NSMutableArray array];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.items.count; }
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"C"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"C"];
    MoonItem *item = self.items[ip.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.isLink ? @"رابط خارجي" : @"ملاحظة نصية";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
@end
