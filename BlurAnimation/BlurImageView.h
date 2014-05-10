//
//  BlurImageView.h
//  Birdsnap
//
//  Created by Michelle Alexander on 10/20/13.
//  Copyright (c) 2013 Michelle Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlurImageView;

/** BlurImageViewDelegate to listen for animation start/stop */
@protocol BlurImageViewDelegate <NSObject>

@optional
- (void)animationDidStart:(BlurImageView *)blurView;
- (void)animationDidStop:(BlurImageView *)blurView;
@end


@interface BlurImageView : UIImageView

@property (nonatomic, weak) id <BlurImageViewDelegate> delegate;

- (void) pathAnimationBetweenStart:(CGPoint)start andEnd:(CGPoint)end;

@end
