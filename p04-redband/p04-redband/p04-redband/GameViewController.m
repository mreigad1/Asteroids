//
//  GameViewController.m
//  p04-redband
//
//  Created by Timothy Redband on 2/16/16.
//  Copyright (c) 2016 Timothy Redband. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewWillLayoutSubviews

{
    
    [super viewWillLayoutSubviews];
    
    
    
    // Configure the view.
    
    SKView * skView = (SKView *)self.view;
    
    if(!skView.scene){
        
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        skView.ignoresSiblingOrder = YES;
        // Create and configure the scene.
        GameScene *scene = [GameScene sceneWithSize:skView.bounds.size];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
       // NSLog(@"%f,%f",scene.anchorPoint.x, scene.anchorPoint.y);
        // Present the scene.
        [skView presentScene:scene];
    }
    
    
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
