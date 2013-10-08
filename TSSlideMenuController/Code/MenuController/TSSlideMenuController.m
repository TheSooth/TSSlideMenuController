//
//  TSSlideMenuController.m
//  SlideMenu
//
//  Created by TheSooth on 9/26/13.
//  Copyright (c) 2013 TheSooth. All rights reserved.
//

#import "TSSlideMenuController.h"

static const NSInteger kAlphaDivideCoefficient = 500;

static const CGFloat kContentViewWidth = 280.f;
static const CGFloat kDimmedViewAlpha = 0.58f;
static const CGFloat kDefaultHiddingThreshold = 1.2f;
static const CGFloat kDefaultAnimationDuration = 0.2f;

@interface TSSlideMenuController ()

@property (nonatomic, assign) BOOL menuIsVisible;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) UIButton *dimmedView;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation TSSlideMenuController

#pragma mark -
#pragma mark - Configuration

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dragable = YES;
    self.animationDuration = kDefaultAnimationDuration;
    
    self.view.frame = CGRectOffset(self.view.frame, -CGRectGetWidth(self.view.frame), 0);
    self.view.alpha = 1;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(-kContentViewWidth,
                                                                0,
                                                                kContentViewWidth,
                                                                CGRectGetHeight(self.view.bounds))];
    
    self.dimmedView = [[UIButton alloc] initWithFrame:self.view.bounds];
    [self.dimmedView addTarget:self action:@selector(dismissSlideMenu) forControlEvents:UIControlEventTouchUpInside];
    
    self.dimmedView.alpha = 0;
    self.dimmedView.backgroundColor = [UIColor blackColor];
    
    self.hiddingTreshold = kDefaultHiddingThreshold;

    [self.view addSubview:self.dimmedView];
    [self.view addSubview:self.contentView];
}

#pragma mark -
#pragma mark - SlideMenu actions

- (void)presentSlideMenu
{
    __weak typeof(self) weakSelf = self;
    
    [self performPresentMenuAnimationWithCompletionBlock:^{
        weakSelf.menuIsVisible = YES;
        [weakSelf setupPanGesture];
    }];
}

- (void)dismissSlideMenu
{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        weakSelf.dimmedView.alpha = 0.f;
        [weakSelf setContentViewOriginByX:-CGRectGetWidth(weakSelf.contentView.frame)];
    } completion:^(BOOL finished) {
        weakSelf.menuIsVisible = NO;
        weakSelf.view.frame = CGRectOffset(weakSelf.view.frame, -CGRectGetWidth(weakSelf.view.frame), 0);
    }];
}

- (void)performPresentMenuAnimationWithCompletionBlock:(void(^)(void))aCompletionBlock
{
    __weak typeof(self) weakSelf = self;
    
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    weakSelf.view.frame = frame;
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        [weakSelf setContentViewOriginByX:0];
            weakSelf.dimmedView.alpha = kDimmedViewAlpha;
    } completion:^(BOOL finished) {
        if (aCompletionBlock) {
            aCompletionBlock();
        }
    }];
}

#pragma mark -
#pragma mark - PanGesture

- (void)setupPanGesture
{
    if (self.dragable) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.panGesture setMaximumNumberOfTouches:2];
    
        [self.view addGestureRecognizer:self.panGesture];
    }
}

- (void)removePanGesture
{
    [self.view removeGestureRecognizer:self.panGesture];
    self.panGesture = nil;
}


- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if (!self.menuIsVisible) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self.contentView.superview];
        CGPoint center = CGPointMake(self.contentView.center.x + translation.x, self.contentView.center.y);
        
        self.contentView.center = center;
        
		if (self.contentView.frame.origin.x > 0) {
            CGRect currentFrame = self.contentView.frame;
            currentFrame.origin.x = 0;
            
            self.contentView.frame = currentFrame;
		}
        
        self.dimmedView.alpha = (CGRectGetMinX(self.contentView.frame) + CGRectGetWidth(self.contentView.frame))  / kAlphaDivideCoefficient;
        
        [gesture setTranslation:CGPointZero inView:self.contentView.superview];
    } else if ([gesture state] == UIGestureRecognizerStateEnded) {
        CGFloat contentViewX = CGRectGetMinX(self.contentView.frame);
        CGFloat hiddingWidth = -(CGRectGetWidth(self.contentView.frame) / (4 + self.hiddingTreshold));
        if (contentViewX <= hiddingWidth) {
            [self dismissSlideMenu];
        } else {
            [self performPresentMenuAnimationWithCompletionBlock:Nil];
        }
	}
}

- (void)setContentViewOriginByX:(CGFloat)aX
{
    CGRect contentFrame = self.contentView.frame;
    contentFrame.origin.x = aX;
    
    self.contentView.frame = contentFrame;
    
}

@end
