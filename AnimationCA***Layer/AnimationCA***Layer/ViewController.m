//
//  ViewController.m
//  AnimationCA***Layer
//
//  Created by chenshuang on 2019/8/30.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CTFont.h>
#import <CoreText/CTStringAttributes.h>
#import "ReflectionView.h"
#import "ScrollView.h"
#import <QuartzCore/CATiledLayer.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/OpenGLESAvailability.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<CALayerDelegate>
/** contentView */
@property(nonatomic, strong)UIView *contentView;
/** scrollView */
@property(nonatomic, strong)UIScrollView *scrollView;

#pragma mark - CAEAGLLayer 相关变量
/** glView */
@property(nonatomic, strong)UIView *glView;
/** glContext */
@property(nonatomic, strong)EAGLContext *glContext;
/** glLayer */
@property(nonatomic, strong)CAEAGLLayer *glLayer;
/** frameBuffer */
@property(nonatomic, assign)GLuint frameBuffer;
/** colorRenderbuffer */
@property(nonatomic, assign)GLuint colorRenderbuffer;
/** framebufferWidth */
@property(nonatomic, assign)GLuint frameBufferWidth;
/** framebufferHeight */
@property(nonatomic, assign)GLuint frameBufferHeight;
/** effect */
@property(nonatomic, strong)GLKBaseEffect *effect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.contentView.center = self.view.center;
    [self.view addSubview:self.contentView];
    
    // CAShapeLayer
//    [self shaperLayer];
    
    // 三个圆角的矩形
//    [self createThreeRadiusRound];
    
    /// CATextLayer
//    [self createCATextLayer];
    
    /// 富文本属性
//    [self mutableAttrbuteString];
    
    /// CATransformLayer
//    [self createTransformLayer];
    
    /// 颜色渐变
//    [self createGradientLayer];
    
    /// 多重颜色渐变
//    [self createMultiGradientLayer];
    
    /// 5.重复图层（Repeating Layers）
//    [self createReplicatorLayer];
    
    /// 5.2反射
//    [self createReplicatorLayer1];
    
    /// 6 scrollLayer
//    [self createScrollLayer];
    
    /// 8 CAEmitterLayer 粒子效果
//    [self createCAEmitterLayer];
    
    /// 9.CAEAGLLayer
//    [self createEAGLayer];
    
    /// 十 AVPlayerLayer
//    [self createAVPlayerLayer];
    
    // 给视频增加变换，边框和圆角
    [self createMultiAVPlayerLayer];
}

/// 1.CAShapeLayer
- (void)shaperLayer {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(175, 100)];
    
    // add path
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    // create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    // add it to our view
    [self.view.layer addSublayer:shapeLayer];
}

/// 三个圆角的矩形
- (void)createThreeRadiusRound {
    // define path parameters
    CGRect rect = CGRectMake(100, 100, 100, 100);
    CGSize radii = CGSizeMake(20, 20);
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    // create path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    
    // create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    // add it to our view
    [self.view.layer addSublayer:shapeLayer];
}

/// 2.CATextLayer
- (void)createCATextLayer {
    // create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:textLayer];
    
    // set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    // set layer font
    UIFont *font = [UIFont systemFontOfSize:16];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontName;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    // choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel \ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \ lobortis";
    
    // set layer text
    textLayer.string = text;
    
    // content scale
    textLayer.contentsScale = [UIScreen mainScreen].scale;
}

/// 富文本属性
- (void)mutableAttrbuteString {
    // create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.contentView.bounds;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.contentView.layer addSublayer:textLayer];
   
    //set text attributes
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel \ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \ lobortis";
    
    // create attrbuted string
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    
    // convert uifont to a cffont
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    
    // set text attrbutes
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                              (__bridge id)kCTFontAttributeName:(__bridge id)fontRef
                              };
    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
    
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
                (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
                (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                };
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    
    // release the CTFont we created earlier
    CFRelease(fontRef);
    
    // set layer text
    textLayer.string = string;
}

/// 3.CATransformLayer
- (void)createTransformLayer {
    // setup the perspective transform
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500.0;
    self.contentView.layer.sublayerTransform = pt;
    
    // setup the transform for cube 1 and add it
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -100, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.contentView.layer addSublayer:cube1];
    
    // setup the transform for cube2 and add it
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.contentView.layer addSublayer:cube2];
}

- (CALayer *)faceWithTransform:(CATransform3D)transform {
    // create cube face layer
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    
    // apply a random color
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    // apply the transform and return
    face.transform = transform;
    
    return face;
}

- (CALayer *)cubeWithTransform:(CATransform3D)transform {
    // create cube layer
    CATransformLayer *cube = [CATransformLayer layer];
    
    // add cube face 1
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 2
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 3
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 4
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 5
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 6
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // center the cube layer within the container
    CGSize containerSize = self.contentView.bounds.size;
    cube.position = CGPointMake(containerSize.width * 0.5, containerSize.height * 0.5);
    
    // apply the transform
    cube.transform = transform;
    return cube;
}

/// 4.颜色渐变
- (void)createGradientLayer {
    // create gradient layer and add it to our container view
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:gradientLayer];
    
    // set gradient colors
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor blueColor].CGColor];
    
    // set gradient start and end points
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
}

/// 多重颜色渐变
- (void)createMultiGradientLayer {
    // create gradient layer and add it to our container view
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:gradientLayer];
    
    // set gradient colors
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor yellowColor].CGColor,
                             (__bridge id)[UIColor greenColor].CGColor];
    
    // set locations
    gradientLayer.locations = @[@0.0, @0.25, @0.5];
    
    // set gradient start and end points
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
}

/// 5.重复图层（Repeating Layers）
- (void)createReplicatorLayer {
    // create a replicator layer and add it to our view
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:replicator];
    
    // configure the replicator
    replicator.instanceCount = 10;
    
    // apply a transform for each instance
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -200, 0);
    replicator.instanceTransform = transform;
    
    // apply a color shift for each instance
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    
    // create a sublayer and place it inside the replicator
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicator addSublayer:layer];
}

/// 反射
- (void)createReplicatorLayer1 {
    ReflectionView *view = [[ReflectionView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];;
    view.center = self.view.center;
    [self.view addSubview:view];
}

/// 6 scrollLayer
- (void)createScrollLayer {
    ScrollView *scrollView = [[ScrollView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    scrollView.layer.borderWidth = 1;
    scrollView.layer.borderColor = [UIColor redColor].CGColor;
    scrollView.center = self.view.center;
    [self.view addSubview:scrollView];
}

/// 7 CATiledLayer
- (void)createTiledLayer {
    // create scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.scrollView.center = self.view.center;
    [self.view addSubview:self.scrollView];
    
    //add the tiled layer
    CATiledLayer *tileLayer = [CATiledLayer layer];
    tileLayer.frame = CGRectMake(0, 0, 2048, 2048);
    tileLayer.delegate = self;
    [self.scrollView.layer addSublayer:tileLayer];
    
    //configure the scroll view
    self.scrollView.contentSize = tileLayer.frame.size;
    
    //draw layer
    [tileLayer setNeedsDisplay];
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx {
    // determine tile coordinate
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    NSInteger x = floor(bounds.origin.x / layer.tileSize.width);
    NSInteger y = floor(bounds.origin.y / layer.tileSize.height);
    
    // load tile image
    NSString *imageName = [NSString stringWithFormat: @"Snowman_%02li_%02li", (long)x, (long)y];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:imagePath];
    
    //draw tile
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}

/// 8 CAEmitterLayer 粒子效果
- (void)createCAEmitterLayer {
    // create particle emitter layer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:emitter];
    
    // configure emitter
//    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.renderMode = kCAEmitterLayerUnordered;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width * 0.5, emitter.frame.size.height * 0.5);
    
    // create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"red"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI * 2.0;
    
    // add particle template to emitter
    emitter.emitterCells = @[cell];
}

/// 9.CAEAGLLayer
- (void)createEAGLayer {
    // setup context
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:self.glContext];
    
    self.glView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.glView.center = self.view.center;
    [self.view addSubview:self.glView];
    
    // setup layer
    self.glLayer = [CAEAGLLayer layer];
    self.glLayer.frame = self.glView.bounds;
    [self.glView.layer addSublayer:self.glLayer];
    self.glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:@NO, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};

    // setup base effect
    self.effect = [[GLKBaseEffect alloc] init];
    
    // setup buffers
    [self setUpBuffers];
    
    // draw frame
    [self drawFrame];
}

- (void)viewDidUnload {
    [self tearDownBuffers];
    [super viewDidLoad];
}

- (void)dealloc {
    [self tearDownBuffers];
    [EAGLContext setCurrentContext:nil];
}

- (void)setUpBuffers {
    // setup frame buffer
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    // setup color render buffer
    glGenRenderbuffers(1, &_colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
    [self.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_frameBufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_frameBufferHeight);
    
    // check success
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object: %i", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

- (void)tearDownBuffers {
    if (_frameBuffer) {
        // delete frameBuffer
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    
    if (_colorRenderbuffer) {
        // delete color render buffer
        glDeleteRenderbuffers(1, &_colorRenderbuffer);
        _colorRenderbuffer = 0;
    }
}

- (void)drawFrame {
    // bind framebuffer & set viewPort
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, _frameBufferWidth, _frameBufferHeight);
    
    // bind shader program
    [self.effect prepareToDraw];
    
    // clear the screen
    glClear(GL_COLOR_BUFFER_BIT);
    glClearColor(0, 0, 0, 1.0);
    
    // setup vertices
    GLfloat vertices[] = {
        -0.5f, -0.5f, -1.0f, 0.0f, 0.5f, -1.0f, 0.5f, -0.5f, -1.0f,
    };
    
    // setup colors
    GLfloat colors[] = {
        0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f,
    };
    
    //draw triangle
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FLOAT, 0, vertices);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FLOAT, 0, colors);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    // present render buffer
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
}

/// 十 AVPlayerLayer
- (void)createAVPlayerLayer {
    // get video url
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];
    
    // create player and player layer
    AVPlayer *player = [AVPlayer playerWithURL:url];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    // set player layer frame and attach it to our view
    playerLayer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:playerLayer];
    
    // play the video
    [player play];
}

// 给视频增加变换，边框和圆角
- (void)createMultiAVPlayerLayer {
    // get video url
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];
    
    // create player and player layer
    AVPlayer *player = [AVPlayer playerWithURL:url];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    // set player layer frame and attach it to our view
    playerLayer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:playerLayer];
    
    // add transform layer
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500.0;
    transform = CATransform3DRotate(transform, M_PI_4, 1, 1, 0);
    playerLayer.transform = transform;
    
    // add rounded corners and border
    playerLayer.masksToBounds = YES;
    playerLayer.cornerRadius = 20.0;
    playerLayer.borderColor = [UIColor redColor].CGColor;
    playerLayer.borderWidth = 5.0;
    
    // play the video
    [player play];
}

@end
