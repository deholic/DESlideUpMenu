//
//  DESlideUpMenuViewController.h
//  SlideUpMenuTest
//
//  Created by Kim Eui-Gyom on 2014. 7. 10..
//  Copyright (c) 2014년 deStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Glow.h"

@protocol DESlideUpMenuDelegate <NSObject>

@required
- (void)touchedSlideUpMenuButton:(UIButton*)button index:(NSInteger)buttonIndex;

@optional
- (void)openSlideUpMenu;
- (void)closeSlideUpMenu;

@end

typedef enum DESlideButtonCorner : NSInteger {
    DESlideButtonCornerTopLeft = 101,
    DESlideButtonCornerTopRight,
    DESlideButtonCornerBottomLeft,
    DESlideButtonCornerBottomRight
} DESlideButtonCorner;

typedef enum DESlideButtonSide : NSInteger {
    DESlideButtonSideRow = 201,
    DESlideButtonSideColumn
} DESlideButtonSide;

@interface DESlideUpMenuViewController : UIViewController

@property (nonatomic, strong) id<DESlideUpMenuDelegate> delegate;

@property (nonatomic, assign) DESlideButtonCorner buttonCorner;
@property (nonatomic, assign) DESlideButtonSide buttonSide;

@property (nonatomic, assign) CGSize mainButtonSize;
@property (nonatomic, assign) CGSize sideButtonSize;
@property (nonatomic, assign) CGFloat buttonPadding;
@property (nonatomic, assign) CGFloat animationSpeed;

@property (nonatomic, strong) UIImage *mainButtonBgImage;
@property (nonatomic, strong) UIImage *sideButtonBgImage;

- (id)initWithFrame:(CGRect)rect;

- (void)setMainButtonWithImage:(UIImage*)buttonImage text:(NSString*)buttonText;
- (void)addSideButtonWithImage:(UIImage*)buttonImage text:(NSString*)buttonText;

- (BOOL)highlightButtonIndex:(NSInteger)buttonIndex;

@end
