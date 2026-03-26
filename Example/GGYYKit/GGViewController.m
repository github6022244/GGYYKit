// GGViewController.m
#import "GGViewController.h"
#import "GGAsyncLayerTestViewController.h"

@interface GGViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *fixItems;
@end

@implementation GGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GGYYKit修复列表";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self loadFixConfigFromJSON];
    [self setupTableView];
}

- (void)loadFixConfigFromJSON {
    // 获取Bundle中的JSON配置文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fix_config" ofType:@"json"];
    if (!path) {
        // 没有找到配置文件
        NSLog(@"没有找到配置文件: fix_config.json");
        return;
    }
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSArray *configArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error || !configArray) {
        NSLog(@"Error loading JSON config: %@", error.localizedDescription);
        self.fixItems = @[];
        return;
    }
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *itemDict in configArray) {
        NSString *vcClassName = itemDict[@"vcClass"];
        NSString *title = itemDict[@"title"];
        NSString *description = itemDict[@"description"];
        
        // 将类名转换为实际的Class对象
        Class vcClass = NSClassFromString(vcClassName);
        if (vcClass) {
            NSMutableDictionary *item = [@{
                @"title": title ?: @"",
                @"description": description ?: @"",
                @"vcClass": vcClass
            } mutableCopy];
            [items addObject:item];
        }
    }
    
    self.fixItems = [items copy];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fixItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *item = self.fixItems[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.textLabel.textColor = UIColor.darkGrayColor;
    cell.detailTextLabel.text = item[@"description"];
    cell.backgroundColor = UIColor.whiteColor;
    cell.contentView.backgroundColor = UIColor.whiteColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 80)];
    headerView.backgroundColor = UIColor.lightGrayColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.frame.size.width - 30, 60)];
    label.text = @"后续有修改，在fix_config.json里添加fix项，且在\"Fix列表\"文件夹中添加测试ViewController。";
    label.textColor = [UIColor yellowColor];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = self.fixItems[indexPath.row];
    Class vcClass = item[@"vcClass"];
    NSString *className = NSStringFromClass(vcClass);
    
    UIViewController *targetVC = [[vcClass alloc] init];
    targetVC.title = [className stringByReplacingOccurrencesOfString:@"GG" withString:@""];
    
    [self.navigationController pushViewController:targetVC animated:YES];
}

@end
