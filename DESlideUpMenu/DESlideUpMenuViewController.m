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
    UIButton *_mainButton;
    NSMutableArray *_sideButtonArray;
    
    NSInteger _glowingSideButtonIndex;
    
    BOOL _isOpened;
    BOOL _isAnimating;
}

@end

CGFloat const BASE_BUTTON_SIDE_SIZE = 30.0f;
CGFloat const BASE_BUTTON_PADDING = 10.0f;

@implementation DESlideUpMenuViewController

- (id)initWithFrame:(CGRect)rect
{
    self = [super init];
    
    if (self) {
        self.view.frame = rect;
        self.view.backgroundColor = [UIColor clearColor];
        
        
        self.buttonCorner = DESlideButtonCornerTopLeft;
        self.buttonSide = DESlideButtonSideRow;
        
        self.mainButtonSize = (CGSize){BASE_BUTTON_SIDE_SIZE, BASE_BUTTON_SIDE_SIZE};
        self.sideButtonSize = (CGSize){BASE_BUTTON_SIDE_SIZE, BASE_BUTTON_SIDE_SIZE};
        self.buttonPadding = BASE_BUTTON_PADDING;
        self.animationSpeed = 0.5f;
        
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

- (void)setMainButtonWithImage:(UIImage *)buttonImage text:(NSString *)buttonText
{
    CGPoint mainButtonPoint = [self calculateButtonClosePointWithCGSize:self.mainButtonSize];
    
    _mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mainButton.frame = CGRectMake(mainButtonPoint.x, mainButtonPoint.y, self.mainButtonSize.width, self.mainButtonSize.height);
    _mainButton.imageView.image = buttonImage;
    _mainButton.titleLabel.text = buttonText;
    _mainButton.backgroundColor = [UIColor whiteColor];
    
    [_mainButton addTarget:self action:@selector(toggleMenuWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_mainButton];
}

- (void)addSideButtonWithImage:(UIImage *)buttonImage text:(NSString *)buttonText
{
    CGPoint sideButtonPoint = [self calculateButtonClosePointWithCGSize:self.sideButtonSize];
    
    UIButton *sideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sideButton.frame = CGRectMake(sideButtonPoint.x, sideButtonPoint.y, self.sideButtonSize.width, self.sideButtonSize.height);
    sideButton.imageView.image = buttonImage;
    sideButton.titleLabel.text = buttonText;
    sideButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    sideButton.alpha = 0;
    
    [sideButton addTarget:self action:@selector(touchSideButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view insertSubview:sideButton belowSubview:_mainButton];
    [_sideButtonArray addObject:sideButton];
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
    
    CGFloat mainButtonSideSize = DESlideButtonSideRow == self.buttonSide ? self.mainButtonSize.height : self.mainButtonSize.width;
    CGFloat sideButtonSideSize = DESlideButtonSideRow == self.buttonSide ? self.sideButtonSize.height : self.sideButtonSize.width;
    
    CGFloat sideButtonPadding;
    
    if ((DESlideButtonSideRow == self.buttonSide && (DESlideButtonCornerTopLeft == self.buttonCorner || DESlideButtonCornerTopRight == self.buttonCorner))
        || (DESlideButtonSideColumn == self.buttonSide && (DESlideButtonCornerTopLeft == self.buttonCorner || DESlideButtonCornerBottomLeft == self.buttonCorner)))
    {
        sideButtonPadding = mainButtonSideSize + self.buttonPadding * (buttonIndex + 2) + sideButtonSideSize * buttonIndex;
    }
    else
    {
        sideButtonPadding = mainButtonSideSize + self.buttonPadding * (buttonIndex + 2) + sideButtonSideSize * (buttonIndex + 1);
    }
    
    switch (self.buttonCorner) {
        case DESlideButtonCornerTopLeft:
        {
            if (DESlideButtonSideRow == self.buttonSide)
                calcPoint = (CGPoint){self.buttonPadding, sideButtonPadding};
            else
                calcPoint = (CGPoint){sideButtonPadding, self.buttonPadding};
        }
            break;
        case DESlideButtonCornerTopRight:
        {
            if (DESlideButtonSideRow == self.buttonSide)
                calcPoint = (CGPoint){viewSize.width - self.buttonPadding - self.sideButtonSize.width, sideButtonPadding};
            else
                calcPoint = (CGPoint){viewSize.width - sideButtonPadding, self.buttonPadding};
        }
            break;
        case DESlideButtonCornerBottomLeft:
        {
            if (DESlideButtonSideRow == self.buttonSide)
                calcPoint = (CGPoint){self.buttonPadding, viewSize.height - sideButtonPadding};
            else
                calcPoint = (CGPoint){sideButtonPadding, viewSize.height - self.buttonPadding - self.sideButtonSize.height};
        }
            break;
        case DESlideButtonCornerBottomRight:
        {
            if (DESlideButtonSideRow == self.buttonSide)
                calcPoint = (CGPoint){viewSize.width - self.buttonPadding - self.sideButtonSize.width, viewSize.height - sideButtonPadding};
            else
                calcPoint = (CGPoint){viewSize.width - sideButtonPadding, viewSize.height - self.buttonPadding - self.sideButtonSize.height};
        }
            break;
    }
    
    return calcPoint;
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

- (void)toggleMenuWithButton:(id)sender
{
    CGPoint sideButtonPoint;
    
    if (_isAnimating == YES) return;
    
    [_mainButton stopGlowing];
    
    if (!_isOpened)
    {
        for (NSInteger idx = 0; idx < _sideButtonArray.count; idx++)
        {
            UIButton *sideButton = _sideButtonArray[idx];
            
            sideButtonPoint = [self calculateSideButtonOpenPointWithButtonIndex:idx];
            
            [UIView animateWithDuration:self.animationSpeed
                             animations:^{
                                 [sideButton setAlpha:1];
                                 [sideButton setFrame:CGRectMake(sideButtonPoint.x, sideButtonPoint.y, self.sideButtonSize.width, self.sideButtonSize.height)];
                             }
                             completion:^(BOOL finished) {
                                 if (_glowingSideButtonIndex == idx) [sideButton startGlowing];
                                 _isAnimating = NO;
                             }];
        }
        
        _isOpened = YES;
        
        if ([self.delegate respondsToSelector:@selector(openSlideUpMenu)])
            [self.delegate openSlideUpMenu];
    }
    else
    {
        sideButtonPoint = [self calculateButtonClosePointWithCGSize:self.sideButtonSize];
        
        for (NSInteger idx = 0; idx < _sideButtonArray.count; idx++)
        {
            UIButton *sideButton = _sideButtonArray[idx];
            
            if (_glowingSideButtonIndex == idx) [sideButton stopGlowing];
            
            [UIView animateWithDuration:self.animationSpeed
                             animations:^{
                                 [sideButton setFrame:CGRectMake(sideButtonPoint.x, sideButtonPoint.y, self.sideButtonSize.width, self.sideButtonSize.height)];
                                 [sideButton setAlpha:0];
                             }
                             completion:^(BOOL finished) {
                                 _isAnimating = NO;
                             }];
        }
        
        _isOpened = NO;
        
        if ([self.delegate respondsToSelector:@selector(closeSlideUpMenu)])
            [self.delegate closeSlideUpMenu];
    }
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
