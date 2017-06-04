//
//  ViewController.m
//  WaveWithOpenGL
//
//  Created by wang yang on 2017/6/2.
//  Copyright © 2017年 wang yang. All rights reserved.
//

#import "ViewController.h"
#import "GLWaveView.h"
#import "CAWaveView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float xCount = 1;
    float yCount = 2;
    float width = self.view.bounds.size.width / xCount;
    float height = self.view.bounds.size.height / yCount;
    
    for (int col = 0; col < xCount; ++col) {
        for (int row = 0; row < yCount; ++row) {
            float xLoc = col * width;
            float yLoc = row * height;
            if ((int)row % 2 == 0) {
                GLWaveView *waveView = [[GLWaveView alloc]initWithFrame:CGRectMake(xLoc, yLoc, width, height)];
                [self.view addSubview:waveView];
            } else {
                CAWaveView *waveView = [[CAWaveView alloc]initWithFrame:CGRectMake(xLoc, yLoc, width, height)];
                [self.view addSubview:waveView];
            }
            
            
            
        }
    }
    self.view.backgroundColor = UIColor.whiteColor;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
