// GGViewController.h
#import <UIKit/UIKit.h>

#import "GGAsyncLayerTestViewController.h"
#import <YYAsyncLayer.h>

@interface GGAsyncLayerTestViewController () <YYAsyncLayerDelegate>
@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) YYAsyncLayer *asyncLayer;
@end

@implementation GGAsyncLayerTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupUI];
    [self setupTestView];
}

- (void)setupUI {
    // 状态标签
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 60)];
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.backgroundColor = UIColor.lightGrayColor;
    self.statusLabel.textColor = UIColor.blackColor;
    [self.view addSubview:self.statusLabel];
    
    // 测试按钮
    self.testButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.testButton.frame = CGRectMake(50, 180, self.view.frame.size.width - 100, 50);
    [self.testButton setTitle:@"开始测试修复" forState:UIControlStateNormal];
    [self.testButton addTarget:self action:@selector(testAsyncLayer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.testButton];
}

- (void)setupTestView {
    CGRect frame = CGRectMake(50, 250, 200, 200);
    self.testView = [[UIView alloc] initWithFrame:frame];
    self.testView.backgroundColor = UIColor.blueColor;
    self.testView.layer.cornerRadius = 10;
    
    // 创建 Async Layer
    self.asyncLayer = [YYAsyncLayer layer];
    self.asyncLayer.delegate = self;
    self.asyncLayer.displaysAsynchronously = YES;
    self.asyncLayer.contentsScale = [UIScreen mainScreen].scale;
    self.testView.layer.mask = self.asyncLayer;
    
    [self.view addSubview:self.testView];
}

- (IBAction)testAsyncLayer:(id)sender {
    self.statusLabel.text = @"测试中...";
    
    // 测试不同的边界情况
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performTestWithSize:CGSizeMake(0, 0)]; // 测试 0 尺寸
    });
}

- (void)performTestWithSize:(CGSize)size {
    CGRect originalFrame = self.testView.frame;
    
    // 测试不同尺寸
    if (CGSizeEqualToSize(size, CGSizeMake(0, 0))) {
        self.testView.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, 0, 0);
        self.statusLabel.text = @"正在测试 0x0 尺寸\n(应不崩溃)";
        
        // 强制刷新图层
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.asyncLayer setNeedsDisplay];
        [CATransaction commit];
    }
    
    // 延迟恢复
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.testView.frame = originalFrame;
        self.statusLabel.text = @"测试完成\n修复正常工作";
        
        // 再次强制刷新
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.asyncLayer setNeedsDisplay];
        [CATransaction commit];
    });
}

#pragma mark - YYAsyncLayerDelegate
- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
    YYAsyncLayerDisplayTask *task = [[YYAsyncLayerDisplayTask alloc] init];
    __weak typeof(self) weakSelf = self;
    
    task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
        // 模拟绘制逻辑
        if (isCancelled()) return;
        
        // 测试绘制内容 - 即使 size 为 0 也不会崩溃
        if (size.width > 0 && size.height > 0) {
            // 正确获取CGColor
            UIColor *redColor = [UIColor redColor];
            CGContextSetFillColorWithColor(context, redColor.CGColor);
            CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
            
            // 添加边框
            UIColor *blackColor = [UIColor blackColor];
            CGContextSetStrokeColorWithColor(context, blackColor.CGColor);
            CGContextSetLineWidth(context, 2.0);
            CGContextStrokeRect(context, CGRectMake(0, 0, size.width, size.height));
        }
        
        if (weakSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"绘制完成，尺寸: %.2fx%.2f", size.width, size.height);
            });
        }
    };
    
    task.willDisplay = ^(CALayer *layer) {
        NSLog(@"开始异步绘制");
    };
    
    task.didDisplay = ^(CALayer *layer, BOOL finished) {
        if (finished) {
            NSLog(@"异步绘制完成");
        } else {
            NSLog(@"异步绘制被取消");
        }
    };
    
    return task;
}

@end
