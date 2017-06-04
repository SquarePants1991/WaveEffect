//
//  CAWaveView.m
//  WaveWithOpenGL
//
//  Created by wang yang on 2017/6/3.
//  Copyright © 2017年 wang yang. All rights reserved.
//

#import "CAWaveView.h"

@interface CAWaveView() {
    CAShapeLayer *wave1;
    CAShapeLayer *wave2;
    CFTimeInterval lastTime;
    CFTimeInterval currentTime;
    CADisplayLink *displayLink;
}
@end

@implementation CAWaveView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initWaves];
        [self initLoop];
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        CALayer *maskLayer = [CALayer layer];
        UIImage *maskImage = [UIImage imageNamed:@"mask.png"];
        maskLayer.contents = (__bridge id)maskImage.CGImage;
        maskLayer.frame = self.bounds;
        self.layer.mask = maskLayer;
    }
    return self;
}

- (void)initWaves {
    wave1 = [CAShapeLayer new];
    wave2 = [CAShapeLayer new];
    wave1.frame = self.bounds;
    wave2.frame = self.bounds;
    
    [self.layer addSublayer:wave1];
    [self.layer addSublayer:wave2];
}

- (void)initLoop {
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(loop)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    lastTime = displayLink.timestamp;
}

- (void)loop {
    CFTimeInterval now = displayLink.timestamp;
    currentTime += now - lastTime;
    lastTime = now;
    float height = self.bounds.size.height * (sin(currentTime / 4.5) + 1.0) / 2.0;
    wave1.fillColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0].CGColor;
    wave2.fillColor = [UIColor colorWithRed:1.0 green:0.1 blue:0.1 alpha:0.6].CGColor;
    wave1.path = createPath(20, height + 5, currentTime * 4.5, M_PI * 1.5, self.bounds.size).CGPath;
    wave2.path = createPath(18, height, currentTime * 4.5 + 0.3, M_PI * 1.5, self.bounds.size).CGPath;
}

UIBezierPath * createPath(float waveAmplitude, float waveHeight, float phase, float period, CGSize size) {
    UIBezierPath *wavePath = [UIBezierPath new];
    for (int i = 0; i < 360; i++) {
        CGFloat factor = i / 360.0;
        CGFloat x = factor * size.width;
        CGFloat y = size.height - waveAmplitude * (sin(phase + factor * period) + 1.0) / 2.0 + waveAmplitude / 2.0 - waveHeight;
        if (i == 0) {
            [wavePath moveToPoint:CGPointMake(x, y)];
        } else {
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    [wavePath addLineToPoint:CGPointMake(size.width, size.height)];
    [wavePath addLineToPoint:CGPointMake(0, size.height)];
    [wavePath closePath];
    return wavePath;
}

@end
