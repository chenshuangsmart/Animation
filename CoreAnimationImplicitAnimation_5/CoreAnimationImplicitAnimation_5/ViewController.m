//
//  ViewController.m
//  CoreAnimationImplicitAnimation_5
//
//  Created by chenshuang on 2019/9/7.
//  Copyright © 2019 chenshuang. All rights reserved.
//  隐式动画

#import "ViewController.h"

@interface ViewController ()
/** contentView */
@property(nonatomic, strong)UIView *contentView;
/** color layer */
@property(nonatomic, strong)CALayer *colorLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createContentView];
    
    // change color
//    [self createColorLayer];
    
    /// 3.图层行为 - 直接设置图层的属性
//    self.contentView.layer.backgroundColor = [UIColor blueColor].CGColor;
    
    /// 3.图层行为 - 测试UIView的actionForLayer:forKey:实现
//    [self testViewActionForLayer];
    
    /// 3.图层行为 - 实现自定义行为
//    [self createCustomAction];
    
    /// 4.呈现图层
    [self createPresentationLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // change color
//    [self changeColor];
    
    // 提交事务改变背景色
//    [self changeColor2];
    
    /// 颜色改变后旋转
//    [self changeColor3];
    
    /// 3.图层行为 - 直接设置图层的属性
//    [self changeColor4];
    
    /// 3.图层行为 - 实现自定义行为
//    [self changeColor5];
    
    /// 4.呈现与模型 - 响应图层
    [self actionForPresentationLayer:touches withEvent:event];
}

- (void)createContentView {
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.contentView.center = self.view.center;
    [self.view addSubview:self.contentView];
}

/// 1.事务
- (void)createColorLayer {
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    // add it to our view
    [self.contentView.layer addSublayer:self.colorLayer];
}

- (void)changeColor {
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
}

/// 添加事务
- (void)changeColor2 {
    // begin a new transaction
    [CATransaction begin];
    
    // set the animation duration to 1 second
    [CATransaction setAnimationDuration:1.0];
    
    // randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;

    // commit the transaction
    [CATransaction commit];
}

/// 2 颜色改变后旋转 - 完成块
- (void)changeColor3 {
    // begin a new transaction
    [CATransaction begin];
    // set the animation duration to 1 second
    [CATransaction setAnimationDuration:1.0];
    
    // add the spin animation on completion
    [CATransaction setCompletionBlock:^{
        // rotate the layer 90 degrees
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.colorLayer.affineTransform = transform;
    }];
    
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    //commit the transaction
    [CATransaction commit];
}

/// 3.图层行为 - 直接设置图层的属性
- (void)changeColor4 {
    // begin a new transaction
    [CATransaction begin];
    // set the animation duration to 1 second
    [CATransaction setAnimationDuration:1.0];
    // randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.contentView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    // commit the transaction
    [CATransaction commit];
}

/// 3.图层行为 - 测试UIView的actionForLayer:forKey:实现
- (void)testViewActionForLayer {
    // test layer action when outside of animation block
    NSLog(@"Outside: %@",[self.contentView actionForLayer:self.contentView.layer forKey:@"backgroundColor"]);
    
    // begin animation block
    [UIView beginAnimations:nil context:nil];
    // test layer action when inside of animation block
    NSLog(@"Inside: %@",[self.contentView actionForLayer:self.contentView.layer forKey:@"backgroundColor"]);
    // end animation block
    [UIView commitAnimations];
}

/// 3.图层行为 - 实现自定义行为
- (void)createCustomAction {
    // create subLayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    // add a custom action
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor": transition};
    
    // add it to our view
    [self.contentView.layer addSublayer:self.colorLayer];
}

- (void)changeColor5 {
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
}

/// 4.呈现图层
- (void)createPresentationLayer {
    //create a red layer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
}

/// 响应图层
- (void)actionForPresentationLayer:(NSSet *)touches withEvent:(UIEvent *)event {
    // get the touch point
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    // check if we have tapped the moving layer
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        // randomize the layer background color
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    } else {
        // otherwise slowly move the layer to new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
}

@end
