//
//  DEViewController.m
//  DESlideUpMenuExample
//
//  Created by Kim Eui-Gyom on 2014. 7. 11..
//  Copyright (c) 2014년 deStudio. All rights reserved.
//

#import "DEViewController.h"

@interface DEViewController ()
{
    DESlideUpMenuViewController *slideUpMenu;
}

@property (weak, nonatomic) IBOutlet UIView *targetView;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@end

@implementation DEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    slideUpMenu = [[DESlideUpMenuViewController alloc] initWithFrame:self.targetView.bounds];
    
    [slideUpMenu setDelegate:self];
    [slideUpMenu setMainButtonSize:CGSizeMake(30.0f, 30.0f)];
    [slideUpMenu setButtonCorner:DESlideButtonCornerBottomLeft];
    [slideUpMenu setButtonSide:DESlideButtonSideColumn];
    
    UIImage *cappedBgImage = [[UIImage imageNamed:@"button_bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(24.0f, 24.0f, 24.0f, 24.0f)];
    
    [slideUpMenu setBackgroundImage:cappedBgImage];
    
    [slideUpMenu setMainButtonWithImage:[UIImage imageNamed:@"menu"] text:nil];
    [slideUpMenu addSideButtonWithImage:[UIImage imageNamed:@"walk"] text:nil];
    [slideUpMenu addSideButtonWithImage:[UIImage imageNamed:@"run"] text:nil];
    [slideUpMenu addSideButtonWithImage:[UIImage imageNamed:@"situp"] text:nil];
    [slideUpMenu addSideButtonWithImage:[UIImage imageNamed:@"stair"] text:nil];
    [slideUpMenu addSideButtonWithImage:[UIImage imageNamed:@"jumprope"] text:nil];
    
    [self.targetView addSubview:slideUpMenu.view];
}

- (IBAction)touchHighlightButton:(id)sender
{
    [slideUpMenu highlightButtonIndex:0];
}

#pragma mark - DESlideUpMenu Delegate

- (void)touchedSlideUpMenuButton:(UIButton*)button index:(NSInteger)buttonIndex
{
    [self.indexLabel setText:[NSString stringWithFormat:@"Selected Index : %tu", buttonIndex]];
}

@end
