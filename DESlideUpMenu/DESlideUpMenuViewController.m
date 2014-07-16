//
//  DESlideUpMenuViewController.m
//  SlideUpMenuTest
//
//  Created by Kim Eui-Gyom on 2014. 7. 10..
//  Copyright (c) 2014년 deStudio. All rights reserved.
//

#import "DESlideUpMenuViewController.h"

@interface DESlideUpMenuViewController ()
{
    UIView *_containerView;
    UIButton *_mainButton;
    UIImageView *_bgImageView;
    
    NSMutableArray *_sideButtonArray;
    NSInteger _glowingSideButtonIndex;
    
    BOOL _isOpened;
    BOOL _isAnimating;
}

@end

CGFloat const BASE_BUTTON_SIDE_SIZE = 30.0f;
CGFloat const BASE_BUTTON_PADDING = 10.0f;

@implementation DESlideUpMenuViewController

@synthesize mainButtonSideSize, sideButtonSideSize;

- (id)initWithFrame:(CGRect)rect
{
    self = [super init];
    
    if (self) {
        self.view.frame = rect;
        self.view.backgroundColor = [UIColor clearColor];
        
        self.buttonCorner = DESlideButtonCornerTopLeft;
        self.buttonSide = DESlideButtonSideVertical;
        
        self.mainButtonSize = (CGSize){BASE_BUTTON_SIDE_SIZE, BASE_BUTTON_SIDE_SIZE};
        self.sideButtonSize = (CGSize){BASE_BUTTON_SIDE_SIZE, BASE_BUTTON_SIDE_SIZE};
        self.buttonPadding = BASE_BUTTON_PADDING;
        self.animationSpeed = 0.5f;
        
        _containerView = [[UIView alloc] init];
        _glowingSideButtonIndex = -1;
        _isOpened = false;
        _isAnimating = false;
        _sideButtonArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _containerView.frame = CGRectMake(_mainButton.center.x, _mainButton.center.y, 0, 0);
    
    if (_bgImageView != nil)
    {
        [_bgImageView setFrame:_containerView.bounds];
        [_containerView addSubview:_bgImageView];
    }
    
    [self.view insertSubview:_containerView atIndex:0];
}

- (void)setBackgroundImage:(UIImage*)backgroundImage
{
    if (_bgImageView == nil)
        _bgImageView = [[UIImageView alloc] init];
    
    [_bgImageView setImage:backgroundImage];
}

- (void)setMainButtonWithButton:(UIButton *)button
{
    if (_mainButton)
    {
        [_mainButton removeFromSuperview];
        _mainButton = nil;
    }
    
    CGPoint mainButtonPoint = [self calculateButtonClosePointWithCGSize:self.mainButtonSize];
    
    [button setFrame:CGRectMake(mainButtonPoint.x, mainButtonPoint.y, self.mainButtonSize.width, self.mainButtonSize.height)];
    [button addTarget:self action:@selector(toggleMenuWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _mainButton = button;
    
    [self.view addSubview:_mainButton];
}

- (void)setMainButtonWithImage:(UIImage *)buttonImage text:(NSString *)buttonText
{
    UIButton *prepareMainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [prepareMainButton setTitle:buttonText forState:UIControlStateNormal];
    [prepareMainButton setImage:buttonImage forState:UIControlStateNormal];
    
    [self setMainButtonWithButton:prepareMainButton];
}

- (void)setMainButtonWithImage:(UIImage *)buttonImage text:(NSString *)buttonText tag:(NSInteger)tag
{
    UIButton *prepareMainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [prepareMainButton setTitle:buttonText forState:UIControlStateNormal];
    [prepareMainButton setImage:buttonImage forState:UIControlStateNormal];
    [prepareMainButton setTag:tag];
    
    [self setMainButtonWithButton:prepareMainButton];
}

- (void)addSideButtonWithButton:(UIButton*)button
{
    CGPoint sideButtonPoint = [self calculateButtonClosePointWithCGSize:self.sideButtonSize];
    
    [button setFrame:CGRectMake(sideButtonPoint.x, sideButtonPoint.y, self.sideButtonSize.width, self.sideButtonSize.height)];
    [button addTarget:self action:@selector(touchSideButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view insertSubview:button belowSubview:_mainButton];
    [_sideButtonArray addObject:button];
}

- (void)addSideButtonWithImage:(UIImage *)buttonImage text:(NSString *)buttonText
{
    UIButton *sideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sideButton setTitle:buttonText forState:UIControlStateNormal];
    [sideButton setImage:buttonImage forState:UIControlStateNormal];
    [sideButton setAlpha:0];
   
    [self addSideButtonWithButton:sideButton];
}

- (void)addSideButtonWithImage:(UIImage *)buttonImage text:(NSString *)buttonText tag:(NSInteger)tag
{
    UIButton *sideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sideButton setTitle:buttonText forState:UIControlStateNormal];
    [sideButton setImage:buttonImage forState:UIControlStateNormal];
    [sideButton setTag:tag];
    [sideButton setAlpha:0];
    
    [self addSideButtonWithButton:sideButton];
}

- (CGFloat)mainButtonSideSize
{
    return self.buttonSide == DESlideButtonSideVertical ? self.mainButtonSize.height : self.mainButtonSize.width;
}

- (CGFloat)sideButtonSideSize
{
    return self.buttonSide == DESlideButtonSideVertical ? self.sideButtonSize.height : self.sideButtonSize.width;
}

#pragma mark - Private Function

- (CGPoint)calculateButtonClosePointWithCGSize:(CGSize)sideSize
{
    CGPoint calcPoint;
    CGSize viewSize = self.view.frame.size;
    
    switch (self.buttonCorner) {
        case DESlideButtonCornerTopLeft:
            calcPoint = (CGPoint){self.buttonPadding, self.buttonPadding};
            break;
        case DESlideButtonCornerTopRight:
            calcPoint = (CGPoint){viewSize.width - sideSize.width - self.buttonPadding, self.buttonPadding};
            break;
        case DESlideButtonCornerBottomLeft:
            calcPoint = (CGPoint){self.buttonPadding, viewSize.height - sideSize.height - self.buttonPadding};
            break;
        case DESlideButtonCornerBottomRight:
            calcPoint = (CGPoint){viewSize.width - sideSize.width - self.buttonPadding, viewSize.height - sideSize.height - self.buttonPadding};
            break;
    }
    
    return calcPoint;
}

- (CGPoint)calculateSideButtonOpenPointWithButtonIndex:(NSInteger)buttonIndex
{
    CGPoint calcPoint;
    CGSize viewSize = self.view.frame.size;
    CGFloat sideButtonPadding;
    
    if ((DESlideButtonSideVertical == self.buttonSide && (DESlideButtonCornerTopLeft == self.buttonCorner || DESlideButtonCornerTopRight == self.buttonCorner))
        || (DESlideButtonSideHorizontal == self.buttonSide && (DESlideButtonCornerTopLeft == self.buttonCorner || DESlideButtonCornerBottomLeft == self.buttonCorner)))
    {
        sideButtonPadding = self.mainButtonSideSize + self.buttonPadding * (buttonIndex + 2) + self.sideButtonSideSize * buttonIndex;
    }
    else
    {
        sideButtonPadding = self.mainButtonSideSize + self.buttonPadding * (buttonIndex + 2) + self.sideButtonSideSize * (buttonIndex + 1);
    }
    
    switch (self.buttonCorner) {
        case DESlideButtonCornerTopLeft:
        {
            if (DESlideButtonSideVertical == self.buttonSide)
                calcPoint = (CGPoint){self.buttonPadding, sideButtonPadding};
            else
                calcPoint = (CGPoint){sideButtonPadding, self.buttonPadding};
        }
            break;
        case DESlideButtonCornerTopRight:
        {
            if (DESlideButtonSideVertical == self.buttonSide)
                calcPoint = (CGPoint){viewSize.width - self.buttonPadding - self.sideButtonSize.width, sideButtonPadding};
            else
                calcPoint = (CGPoint){viewSize.width - sideButtonPadding, self.buttonPadding};
        }
            break;
        case DESlideButtonCornerBottomLeft:
        {
            if (DESlideButtonSideVertical == self.buttonSide)
                calcPoint = (CGPoint){self.buttonPadding, viewSize.height - sideButtonPadding};
            else
                calcPoint = (CGPoint){sideButtonPadding, viewSize.height - self.buttonPadding - self.sideButtonSize.height};
        }
            break;
        case DESlideButtonCornerBottomRight:
        {
            if (DESlideButtonSideVertical == self.buttonSide)
                calcPoint = (CGPoint){viewSize.width - self.buttonPadding - self.sideButtonSize.width, viewSize.height - sideButtonPadding};
            else
                calcPoint = (CGPoint){viewSize.width - sideButtonPadding, viewSize.height - self.buttonPadding - self.sideButtonSize.height};
        }
            break;
    }
    
    return calcPoint;
}

- (CGRect)calculateContainerViewRect
{
    CGFloat containerViewSize = self.mainButtonSideSize + self.sideButtonSideSize * _sideButtonArray.count + self.buttonPadding * _sideButtonArray.count + self.buttonPadding * 2;
    CGFloat mainButtonWithPaddingSize = self.mainButtonSideSize + self.buttonPadding * 2;
    CGRect generatedRect;
    
    switch (self.buttonCorner) {
        case DESlideButtonCornerTopLeft:
        {
            if (DESlideButtonSideVertical == self.buttonSide)
            {
                generatedRect = CGRectMake(0,
                                           0,
                                           mainButtonWithPaddingSize,
                                           containerViewSize);
            }
            
            else
            {
                generatedRect = CGRectMake(0,
                                           0,
                                           containerViewSize,
                                           mainButtonWithPaddingSize);
            }
        }
            break;
        case DESlideButtonCornerTopRight:
        {
            if (DESlideButtonSideVertical == self.buttonSide)
            {
                generatedRect = CGRectMake(CGRectGetWidth(self.view.frame) - mainButtonWithPaddingSize,
                                           0,
                                           mainButtonWithPaddingSize,
                                           containerViewSize);
            }
            else
            {
                generatedRect = CGRectMake(CGRectGetWidth(self.view.frame) - containerViewSize,
                                           0,
                                           containerViewSize,
                                           mainButtonWithPaddingSize);
            }
        }
            break;
        case DESlideButtonCornerBottomLeft:
        {
            if (DESlideButtonSideVertical == self.buttonSide)
            {
                generatedRect = CGRectMake(0,
                                           CGRectGetHeight(self.view.frame) - containerViewSize,
                                           mainButtonWithPaddingSize,
                                           containerViewSize);
            }
            else
            {
                generatedRect = CGRectMake(0,
                                           CGRectGetHeight(self.view.frame) - mainButtonWithPaddingSize,
                                           containerViewSize,
                                           mainButtonWithPaddingSize);
            }
        }
            break;
        case DESlideButtonCornerBottomRight:
        {
            if (DESlideButtonSideVertical == self.buttonSide)
            {
                generatedRect = CGRectMake(CGRectGetWidth(self.view.frame) - mainButtonWithPaddingSize,
                                           CGRectGetHeight(self.view.frame) - containerViewSize,
                                           mainButtonWithPaddingSize,
                                           containerViewSize);
            }
            else
            {
                generatedRect = CGRectMake(CGRectGetWidth(self.view.frame) - containerViewSize,
                                           CGRectGetHeight(self.view.frame) - mainButtonWithPaddingSize,
                                           containerViewSize,
                                           mainButtonWithPaddingSize);
            }
        }
            break;
    }
    
    return generatedRect;
}

- (BOOL)highlightButtonIndex:(NSInteger)buttonIndex
{
    if (_isAnimating) return NO;
    
    UIButton *highlightButton = [_sideButtonArray objectAtIndex:buttonIndex];
    _glowingSideButtonIndex = buttonIndex;
    
    if (highlightButton != nil)
    {
        if (_isOpened)  [highlightButton startGlowing];
        else            [_mainButton startGlowing];
        
        return YES;
    }
    else
        return NO;
}

#pragma mark - Button Actions

- (void)openMenu
{
    //
    // Menu Expand Animations
    // Zooming -> Expand -> Button Slide
    //
    
    void (^containerViewZoomingAnimation)() = ^()
    {
        [_containerView setFrame:CGRectMake(CGRectGetMinX(_mainButton.frame) - self.buttonPadding,
                                            CGRectGetMinY(_mainButton.frame) - self.buttonPadding,
                                            CGRectGetWidth(_mainButton.frame) + self.buttonPadding * 2,
                                            CGRectGetHeight(_mainButton.frame) + self.buttonPadding * 2)];
        [_bgImageView setFrame:_containerView.bounds];
    };
    
    void (^containerViewExpandAnimation)() = ^()
    {
            [_containerView setFrame:[self calculateContainerViewRect]];
            [_bgImageView setFrame:_containerView.bounds];
        
    };
    
    void (^sideButtonShowAnimation)(UIButton*, CGPoint) = ^(UIButton* sideButton, CGPoint sideButtonPoint)
    {
        [sideButton setAlpha:1];
        [sideButton setFrame:CGRectMake(sideButtonPoint.x, sideButtonPoint.y, self.sideButtonSize.width, self.sideButtonSize.height)];
    };
    
    void (^containerViewExpandComplete)(BOOL) = ^(BOOL finished)
    {
        CGPoint sideButtonPoint;
        
        for (NSInteger idx = 0; idx < _sideButtonArray.count; idx++)
        {
            UIButton *sideButton = _sideButtonArray[idx];
            
            sideButtonPoint = [self calculateSideButtonOpenPointWithButtonIndex:idx];
            
            [UIView animateWithDuration:self.animationSpeed
                             animations:^{ sideButtonShowAnimation(sideButton, sideButtonPoint); }
                             completion:^(BOOL finished) {
                                 if (_glowingSideButtonIndex == idx) [sideButton startGlowing];
                                 _isAnimating = NO;
                             }];
        }
        
        _isOpened = YES;
        
        if ([self.delegate respondsToSelector:@selector(openSlideUpMenu)])
            [self.delegate openSlideUpMenu];
    };
    
    void (^containerViewZoomingCompletion)(BOOL) = ^(BOOL finished)
    {
        [UIView animateWithDuration:self.animationSpeed
                         animations:containerViewExpandAnimation
                         completion:containerViewExpandComplete];
    };
    
    [UIView animateWithDuration:self.animationSpeed
                     animations:containerViewZoomingAnimation
                     completion:containerViewZoomingCompletion];
}

- (void)closeMenu
{
    //
    // Menu Shrink Animations
    // Button Slide -> Shrink -> Dezooming
    //
    
    void (^sideButtonHideAnimation)(UIButton*, CGPoint) = ^(UIButton* sideButton, CGPoint sideButtonPoint)
    {
        [sideButton setFrame:CGRectMake(sideButtonPoint.x, sideButtonPoint.y, self.sideButtonSize.width, self.sideButtonSize.height)];
        [sideButton setAlpha:0];
    };
    
    void (^containerViewShrinkAnimation)() = ^()
    {
        [_containerView setFrame:CGRectMake(CGRectGetMinX(_mainButton.frame) - self.buttonPadding,
                                            CGRectGetMinY(_mainButton.frame) - self.buttonPadding,
                                            CGRectGetWidth(_mainButton.frame) + self.buttonPadding * 2,
                                            CGRectGetHeight(_mainButton.frame) + self.buttonPadding * 2)];
        [_bgImageView setFrame:_containerView.bounds];
    };
    
    void (^containerViewDezoomingAnimation)() = ^()
    {
        [_containerView setFrame:CGRectMake(_mainButton.center.x, _mainButton.center.y, 0, 0)];
        [_bgImageView setFrame:_containerView.bounds];
    };
    
    void (^containerViewDezoomingAnimationCompletion)(BOOL) = ^(BOOL finished)
    {
        _isAnimating = NO;
    };
    
    void (^contaierViewShrinkAnimationCompletion)(BOOL) = ^(BOOL finished)
    {
        [UIView animateWithDuration:self.animationSpeed
                         animations:containerViewDezoomingAnimation
                         completion:containerViewDezoomingAnimationCompletion];
    };
    
    void (^sideButtonHideAnimationCompletion)(NSInteger) = ^(NSInteger idx)
    {
        if (idx == _sideButtonArray.count - 1)
        {
            [UIView animateWithDuration:self.animationSpeed
                             animations:containerViewShrinkAnimation
                             completion:contaierViewShrinkAnimationCompletion];
        }
    };
    
    CGPoint sideButtonPoint = [self calculateButtonClosePointWithCGSize:self.sideButtonSize];
    
    for (NSInteger idx = 0; idx < _sideButtonArray.count; idx++)
    {
        UIButton *sideButton = _sideButtonArray[idx];
        
        if (_glowingSideButtonIndex == idx) [sideButton stopGlowing];
        
        [UIView animateWithDuration:self.animationSpeed
                         animations:^{ sideButtonHideAnimation(sideButton, sideButtonPoint); }
                         completion:^(BOOL finished) { sideButtonHideAnimationCompletion(idx); }];
    }
    
    _isOpened = NO;
    
    if ([self.delegate respondsToSelector:@selector(closeSlideUpMenu)])
    {
        [self.delegate closeSlideUpMenu];
    }
}

- (void)toggleMenuWithButton:(id)sender
{
    if (_isAnimating == YES)
        return;
    else
        _isAnimating = YES;
    
    [_mainButton stopGlowing];
    
    if (!_isOpened)     [self openMenu];
    else                [self closeMenu];
}

- (void)touchSideButton:(id)sender
{
    UIButton *sideButton = sender;
    
    NSInteger senderIndex = [_sideButtonArray indexOfObject:sideButton];
    
    if (_glowingSideButtonIndex == senderIndex)
    {
        _glowingSideButtonIndex = -1;
        [sideButton stopGlowing];
    }
    
    [self.delegate touchedSlideUpMenuButton:sideButton index:senderIndex];
}

@end
