//
//  GLViewController.m
//  AnimationIO_12
//
//  Created by chenshuang on 2019/11/9.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "GLViewController.h"
#import <GLKit/GLKit.h>

/// 加载和显示PVRTC图片
@interface GLViewController ()

@property (nonatomic, strong) UIView *glView;
@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, strong) CAEAGLLayer *glLayer;
@property (nonatomic, assign) GLuint framebuffer;
@property (nonatomic, assign) GLuint colorRenderbuffer;
@property (nonatomic, assign) GLint framebufferWidth;
@property (nonatomic, assign) GLint framebufferHeight;
@property (nonatomic, strong) GLKBaseEffect *effect;
@property (nonatomic, strong) GLKTextureInfo *textureInfo;

@end

@implementation GLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawUI];
}

- (void)viewDidUnload {
    [self tearDownBuffers];
    [super viewDidUnload];
}

- (void)dealloc {
    [self tearDownBuffers];
    [EAGLContext setCurrentContext:nil];
}

- (void)setupBuffers {
    // setup frame buffer
    glGenFramebuffers(1, &_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    
    // setup color render buffer
    glGenRenderbuffers(1, &_colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
    [self.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_framebufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_framebufferHeight);
    
    // check success
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object: %i", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

- (void)tearDownBuffers {
    if (_framebuffer) {
        // delete framebuffer
        glDeleteFramebuffers(1, &_framebuffer);
        _framebuffer = 0;
    }
    if (_colorRenderbuffer) {
        // delete color render buffer
        glDeleteBuffers(1, &_colorRenderbuffer);
        _colorRenderbuffer = 0;
    }
}

- (void)drawFrame {
    // bind framebuffer & set viewport
    glBindBuffer(GL_FRAMEBUFFER, _framebuffer);
    glViewport(0, 0, _framebufferWidth, _framebufferHeight);
    
    // bind shader program
    [self.effect prepareToDraw];
    
    // clear the screen
    glClear(GL_COLOR_BUFFER_BIT);
    glClearColor(0, 0, 0, 0);
    
    // setup vertices
    GLfloat vertices[] = {
        -1.0f, -1.0f, -1.0f, 1.0f, 1.0f, 1.0f, 1.0f, -1.0f
    };
    // setup colors
    GLfloat texCoords[] = {
        0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f, 1.0f, 1.0f
    };
    // draw triangle
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    // persent render buffer
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawUI {
    self.glView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.glView.center = self.view.center;
    [self.view addSubview:self.glView];
    
    // setup context
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:self.glContext];
    
    // setup layer
    self.glLayer = [CAEAGLLayer layer];
    self.glLayer.frame = self.glView.bounds;
    self.glLayer.opaque = NO;
    [self.glView.layer addSublayer:self.glLayer];
    self.glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @NO, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
    
    //load texture
    glActiveTexture(GL_TEXTURE0);
    NSString *imgFile = [[NSBundle mainBundle] pathForResource:@"Snowman" ofType:@"pvr"];
    self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:imgFile options:nil error:NULL];
    
    //create texture
    GLKEffectPropertyTexture *texture = [[GLKEffectPropertyTexture alloc] init];
    texture.enabled = YES;
    texture.envMode = GLKTextureEnvModeDecal;
    texture.name = self.textureInfo.name;
    
    // setup base effect
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.texture2d0.name = texture.name;
    
    // setup buffers
    [self setupBuffers];
    
    // draw frame
    [self drawFrame];
}

@end
