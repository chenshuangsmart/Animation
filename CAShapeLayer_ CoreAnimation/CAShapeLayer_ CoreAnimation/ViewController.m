//
//  ViewController.m
//  CAShapeLayer_ CoreAnimation
//
//  Created by chenshuang on 2019/8/17.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self drawUI];
    
    // 直接构造
//    [self drawBezierPath];
    
    // 迭代构造
//    [self drawMultiBezierPath];
    
    // 函数图像构造
//    [self drawSinBezierPath1];
    
//    [self drawSinBezierPath2];
    
    // strokeStart
//    [self strokeStart];
    
    // path
    [self drawPath];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self strokeStart];
//    [self strokeEnd];
}

- (void)drawUI {
    // 1.CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 5;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    // 2.UIBezierPath
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(100, 100, 40, 40)];
    
    // 把它的CGPath属性赋值给shapeLayer：
    shapeLayer.path = path.CGPath;
    
    // 最后把shapeLayer加到层级上来显示：
    [self.view.layer addSublayer:shapeLayer];
}

/// 直接构造
- (void)drawBezierPath {
    UIBezierPath *path;
    
    // 构造一个空 曲线
    path = [UIBezierPath bezierPath];
    
    // 构造一个矩形
    path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 40, 40)];
    
    // 构造一个矩形内切圆
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 40, 40)];
    
    // 构造一个圆角矩形
    path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 40, 40) cornerRadius:3];
    
    // 构造一个圆角矩形并指定哪几个角是圆角
    path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 140, 200) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(90, 100)];
    
    // 构造一段圆弧
    // 第一个参数center表示的是圆弧的圆心
    // 第二个参数radius表示圆弧的半径
    // 第三个参数startAngle表示的是圆弧的起始点
    // 第四个参数endAngle表示的是圆弧的终止点
    // 第五个参数clockwise表示是否以顺时针的方向连接起始点和终止点
    // 注意startAngle和endAngle所代表的只是两个点，0则表示圆的最右边那个点，所以如果是π2π2的话就表示圆上最下面那个点。
    // 最终将会从起始点到终止点连一段圆弧出来，最后一个参数决定了这次连接是顺时针的还是逆时针的。具体如图所示
//    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 200) radius:100 startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 200) radius:100 startAngle:M_PI_2 endAngle:M_PI clockwise:NO];
    
    // layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 5;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.path = path.CGPath;
    
    // 最后把shapeLayer加到层级上来显示：
    [self.view.layer addSublayer:shapeLayer];
}

/// 迭代构造
- (void)drawMultiBezierPath {
    // path
    /** 1.一个7
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 将笔放在 10,10的位置
    [path moveToPoint:CGPointMake(10, 10)];
    // 将笔移动到100,10的位置，路过的地方将会留下一条路径
    [path addLineToPoint:CGPointMake(100, 10)];
    // 笔现在已经在100,10的位置了，然后再画一条线到100,100
    [path addLineToPoint:CGPointMake(100, 100)];
     */
    
    /** 2.一个圆形 + 中间一条横线
    // 直接构造一个圆出来
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 200, 200)];
    // 画一条横线
    [path moveToPoint:CGPointMake(100, 200)];
    [path addLineToPoint:CGPointMake(300, 200)];
     */
    
    /** 3.一个圆形 + 中间一条横线 appendPath
     // 直接构造一个圆出来
     UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 200, 200)];
    
    // 构造一个子路径
    UIBezierPath *subPath = [UIBezierPath bezierPath];
    // 画一条横线
    [subPath moveToPoint:CGPointMake(100, 200)];
    [subPath addLineToPoint:CGPointMake(300, 200)];
    
    // 拼接路径
    [path appendPath:subPath];
     */
    
    /** 4.添加一段圆弧
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 添加一段圆弧
    // 注意我们没有调用moveToPoint，这样我们的笔就直接从圆弧的起始点画到结束点
    [path addArcWithCenter:CGPointMake(200, 200) radius:100 startAngle:0 endAngle:M_PI clockwise:YES];
    // 现在我们的笔处在endAngle所代表的点（简单计算一下，圆心200,200，半径100，endAngle是π，那么结束点就是100,200），
    // 如果我们继续添加直线的话，就会直接从结束点开始画
    [path addLineToPoint:CGPointMake(120, 20)];
     */
    
    /** 5.正统的贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 将笔置于40,40
    [path moveToPoint:CGPointMake(40, 40)];
    // 从40,40到300,200画一条贝塞尔曲线，其控制点为120,360，也就是说P0是40,40，P1是120,360，P3是300,200
    [path addQuadCurveToPoint:CGPointMake(300, 200) controlPoint:CGPointMake(120, 360)];
     */
    
    /** 三阶贝塞尔曲线的实现
     */
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(40, 40)];
    [path addCurveToPoint:CGPointMake(350, 600) controlPoint1:CGPointMake(10, 220) controlPoint2:CGPointMake(380, 380)];
    
    
    // layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 5;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.path = path.CGPath;
    
    // 最后把shapeLayer加到层级上来显示：
    [self.view.layer addSublayer:shapeLayer];
}

/// 函数图像构造
- (void)drawSinBezierPath1 {
    // 构造函数图像
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    
    // path
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 第一个点需要moveToPoint，所以放到for循环之前来
    [path moveToPoint:CGPointMake(0, 100)];
    
    // 循环画点
    for (int i = 1; i < width; i++) {
        CGPoint point = CGPointMake(i, 100 + sin(i));
        [path addLineToPoint:point];
    }
    
    // layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 5;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.path = path.CGPath;
    
    // 最后把shapeLayer加到层级上来显示：
    [self.view.layer addSublayer:shapeLayer];
}

/// 函数图像构造
- (void)drawSinBezierPath2 {
    // 构造函数图像
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    
    // path
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 第一个点需要moveToPoint，所以放到for循环之前来
    [path moveToPoint:CGPointMake(0, height * 0.5)];
    
    // 循环画点
    for (int i = 1; i < width; i++) {
        // 对sinx图像进行变形
        CGFloat y = height * 0.5 * sin(2 * M_PI * i / 100) + height * 0.5;
        CGPoint point = CGPointMake(i, height - y);
        [path addLineToPoint:point];
    }
    
    // layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 5;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.path = path.CGPath;
    
    // 最后把shapeLayer加到层级上来显示：
    [self.view.layer addSublayer:shapeLayer];
}

#pragma mark - CAShapeLayer的可动画属性

- (void)strokeStart {
    // 构造一个圆弧路径，从圆的底部顺时针画到圆的右部（3/4圆）
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 200) radius:100 startAngle:M_PI_2 endAngle:0 clockwise:YES];
    
    // 为strokeStart添加动画
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"strokeStart";
    animation.duration = 3.0;
    animation.fromValue = @0;
    
    // layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 5;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.path = path.CGPath;
    
    // 最后把shapeLayer加到层级上来显示：
    [self.view.layer addSublayer:shapeLayer];
    
    // 直接修改modelLayer的属性来代替toValue，见原理篇第四篇
    // 这样shapeLayer的strokeStart属性就会在3秒内从0变到1，可以观察动画的过程和你自己想象的是否一致
    
    // 添加一个延迟这样看得更明白些
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        shapeLayer.strokeStart = 1;
        [shapeLayer addAnimation:animation forKey:nil];
    });
}

- (void)strokeEnd {
    // 构造一个圆弧路径，从圆的底部顺时针画到圆的右部（3/4圆）
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 200) radius:100 startAngle:M_PI_2 endAngle:0 clockwise:YES];
    
    // 为strokeStart添加动画
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"strokeEnd";
    animation.duration = 3.0;
    animation.fromValue = @0;
    
    // layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 5;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.path = path.CGPath;
    
    // 最后把shapeLayer加到层级上来显示：
    [self.view.layer addSublayer:shapeLayer];
    
    // 直接修改modelLayer的属性来代替toValue，见原理篇第四篇
    // 这样shapeLayer的strokeStart属性就会在3秒内从0变到1，可以观察动画的过程和你自己想象的是否一致
    
    // 添加一个延迟这样看得更明白些
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shapeLayer addAnimation:animation forKey:nil];
    });
}

- (void)drawPath {
    // CAShapeLayer
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor orangeColor].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    
    // 1.构造fromPath，并且从左上角开始画
    UIBezierPath *fromPath = [UIBezierPath bezierPath];
    [fromPath moveToPoint:CGPointZero];
    
    // 向下拉一条直线
    [fromPath addLineToPoint:CGPointMake(0, 400)];
    // 向右拉一条线，因为是向下弯的并且是从中间开始弯的，所以控制点的x是宽度的一半，y比起始点和结束点的y要大
    [fromPath addQuadCurveToPoint:CGPointMake(414, 400) controlPoint:CGPointMake(207, 600)];
    
    // 向上拉一条线
    [fromPath addLineToPoint:CGPointMake(414, 0)];
    // 封闭路径，会从当前点向整个路径的起始点连一条线
    [fromPath closePath];
    
    shapeLayer.path = fromPath.CGPath;
    
    // 2.构造toPath
    UIBezierPath * toPath = [UIBezierPath bezierPath];
    
    // 同样从左上角开始画
    [toPath moveToPoint:CGPointZero];
    // 向下拉一条线，要拉到屏幕外
    [toPath addLineToPoint:CGPointMake(0, 836)];
    // 向右拉一条曲线，同样因为弯的地方在正中间并且是向上弯，所以控制点的x是宽的一半，y比起始点和结束点的y要小
    [toPath addQuadCurveToPoint:CGPointMake(414, 836) controlPoint:CGPointMake(207, 736)];
    // 再向上拉一条线
    [toPath addLineToPoint:CGPointMake(414, 0)];
    // 封闭路径
    [toPath closePath];
    
    // 构造动画
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"path";
    animation.duration = 5;
    
    // fromValue应该是一个CGPathRef（因为path属性就是一个CGPathRef），它是一个结构体指针，使用桥接把结构体指针转换成OC的对象类型
    animation.fromValue = (__bridge id)fromPath.CGPath;
    
    // 同样添加一个延迟来方便我们查看效果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 直接修改modelLayer的值来代替toValue
        shapeLayer.path = toPath.CGPath;
        [shapeLayer addAnimation:animation forKey:nil];
    });
}

@end
