//
//  BlurViewController.m
//  BlurAnimation
//
//  Created by Michelle Alexander on 5/7/14.
//  Copyright (c) 2014 Michelle Alexander. All rights reserved.
//

#import "BlurViewController.h"
#import "BlurImageView.h"

@interface BlurViewController ()
@property (weak, nonatomic) IBOutlet BlurImageView *bluredView;
@end

@implementation BlurViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // start the pathAnimation on the bluredImageView
    [self.bluredView pathAnimationBetweenStart:CGPointMake(100, 100)
                                        andEnd:CGPointMake(350, 400)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
