//
//  BlurImageView.m
//  Birdsnap
//
//  Created by Michelle Alexander on 10/20/13.
//  Copyright (c) 2013 Michelle Alexander. All rights reserved.
//

#import "BlurImageView.h"
#import <StackBluriOS/UIImage+StackBlur.h>
#import <QuartzCore/QuartzCore.h>

/** default radius for the portholeLayer */
static CGFloat defaultRadius = 75.0f;

@interface BlurImageView()

@property (nonatomic, retain) UIImageView *maskImageView;
@property (nonatomic, retain) CAShapeLayer *portholeLayer;

@end

@implementation BlurImageView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
    // incase the origional image was already set in the storyboard/nib reassign it to get the blur
    [self setImage:self.image];
}

/** handle initialization from nib or via code */
- (void)setup
{
    self.maskImageView.layer.mask = self.portholeLayer;
    [self addSubview:self.maskImageView];
}

#pragma mark - UIElements

/**
 *  Define a round CAShapeLayer that will act as a mask over the non-blurred version of the image
 */
- (CAShapeLayer *)portholeLayer
{
    if (!_portholeLayer) {
        _portholeLayer = [CAShapeLayer layer];
        _portholeLayer.fillRule = kCAFillRuleEvenOdd;
    
        // Set the anchor point and position to (0,0) so the coordinate system will by the same as a UIView
        _portholeLayer.anchorPoint = CGPointMake(0, 0);
        _portholeLayer.position = CGPointMake(0, 0);
    
        _portholeLayer.frame = self.maskImageView.bounds;
        _portholeLayer.path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0 , 2*defaultRadius, 2*defaultRadius), nil);
    }
    return _portholeLayer;
}

/**
 *  Define a second UIImageView that holds the origional un-blurred verision of the photo to be masked by portholeLayer
 */
- (UIImageView *)maskImageView
{
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _maskImageView.contentMode = self.contentMode;
    }
    return _maskImageView;
}

#pragma mark - UIImageView override

/** override setContentMode so all internal uiimageviews have the same contentMode */
- (void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    [self.maskImageView setContentMode:contentMode];
}

/** Override setImage so all internal UIImageViews are based on the same image */
- (void)setImage:(UIImage *)image
{
    // take the image and create a blurred image to use as the background
    [super setImage:[image stackBlur:30]];
    
    // take a non-blurred version of the image and use it in the maskView
    self.maskImageView.image = image;
}

#pragma mark - blur animation

/** Apply a curved path porthole animation between point two points */
- (void) pathAnimationBetweenStart:(CGPoint)start andEnd:(CGPoint)end
{
    // Calculate the start and end points taking into account the offset to top left
    CGPoint radialStart = CGPointMake(start.x-defaultRadius, start.y-defaultRadius);
    CGPoint radialEnd = CGPointMake(end.x-defaultRadius, end.y-defaultRadius);
    
    // Assign the mask layer to the starting point
    self.maskImageView.layer.mask.position = radialStart;
    
    // Create a position animation
    CAKeyframeAnimation *animationPath = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animationPath.duration = 5.0f;
    animationPath.repeatCount = HUGE_VAL;
    
    // Create a curved path to follow
    CGMutablePathRef pathRef = CGPathCreateMutable();
    [self curvePath:pathRef fromPoint:radialStart toPoint:radialEnd];
    animationPath.path = pathRef;
    CGPathRelease(pathRef);
    
    // Assign the position animation to the new mask layer
    [self.maskImageView.layer.mask addAnimation:animationPath forKey:@"animationPath"];
}

/** Takes a CGMutablePathRef and adds a curve path from pointA to pointB and back */
- (void) curvePath:(CGMutablePathRef)pathRef fromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB
{
    CGPoint midPoint = CGPointMake(pointA.x + (pointB.x - pointA.x), pointA.y + (pointB.y - pointA.y));
    
    CGPathMoveToPoint(pathRef, nil, pointA.x, pointA.y);
    CGPathAddCurveToPoint(pathRef, nil, pointA.x, midPoint.y, midPoint.x, pointA.y, pointB.x, pointB.y);
    CGPathAddCurveToPoint(pathRef, nil, pointA.x, pointB.y, midPoint.x, pointA.y, pointA.x, pointA.y);
}


#pragma mark - animation delegate callbacks

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.delegate respondsToSelector:@selector(animationDidStop:)]) {
        [self.delegate animationDidStop:self];
    }
}

- (void) stopAnimating
{
    [super stopAnimating];
    [self.maskImageView.layer.mask removeAllAnimations];
}

@end
