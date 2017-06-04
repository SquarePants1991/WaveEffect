//
//  WaveView.m
//  WaveWithOpenGL
//
//  Created by wang yang on 2017/6/2.
//  Copyright © 2017年 wang yang. All rights reserved.
//

#import "GLWaveView.h"
#import <OpenGLES/ES2/glext.h>
#import "GLContext.h"

@interface GLWaveView () <GLKViewDelegate> {
    NSTimeInterval currentTime, lastTime;
}

@property (nonatomic, strong) GLContext *glContext;
@property (nonatomic, strong) GLKTextureInfo * diffuseMap;
@end

@implementation GLWaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        static EAGLContext *eaglContext;
        if (eaglContext == nil) {
            eaglContext = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
            [EAGLContext setCurrentContext:eaglContext];
        }
        self.context = eaglContext;
        self.drawableMultisample = GLKViewDrawableMultisample4X;
        self.delegate = self;
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.layer.opaque = NO;
        
        NSString *vertexShader = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@"glsl"];
        NSString *fragmentShader = [[NSBundle mainBundle] pathForResource:@"fragment" ofType:@"glsl"];
        NSString *vertexShaderContent = [NSString stringWithContentsOfFile:vertexShader encoding:NSUTF8StringEncoding error:nil];
        NSString *fragmentShaderContent = [NSString stringWithContentsOfFile:fragmentShader encoding:NSUTF8StringEncoding error:nil];
        self.glContext = [[GLContext alloc] initWithVertexShader:vertexShaderContent fragmentShader:fragmentShaderContent];

        self.diffuseMap = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"mask.png"].CGImage options:nil error:nil];
        
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(ticked)];
        displayLink.preferredFramesPerSecond = 60;
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        lastTime = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    [self.glContext active];
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    static GLfloat triangleData[] = {
        -1,   1,  0.5,   0,  0,  1, 0, 0,
        -1,  -1,  0.5,  0,  0,  1, 0, 1,
        1,   -1,  0.5,  0,  0,  1, 1, 1,
        1,    -1, 0.5,   0,  0,  1, 1, 1,
        1,  1,  0.5,    0,  0,  1, 1, 0,
        -1,   1,  0.5,  0,  0,  1, 0, 0,
    };
    [self.glContext setUniform1f:@"time" value:currentTime];
    [self.glContext bindTexture:self.diffuseMap to:GL_TEXTURE0 uniformName:@"diffuseMap"];
    [self.glContext drawTriangles:triangleData vertexCount:6];
}

- (void)ticked {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    currentTime += now - lastTime;
    lastTime = now;
    [self display];
}


@end
