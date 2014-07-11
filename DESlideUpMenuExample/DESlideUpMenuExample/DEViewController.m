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
    
    slideUpMenu = [[DESlideUpMenuViewController alloc] initWithFrame:CGRectMake(0, 0, self.targetView.frame.size.width, self.targetView.frame.size.height)];
    
    [slideUpMenu setMainButtonSize:CGSizeMake(50.0f, 50.0f)];
    [slideUpMenu setButtonCorner:DESlideButtonCornerBottomRight];
    [slideUpMenu setButtonSide:DESlideButtonSideRow];
    
    [slideUpMenu addSideButtonWithImage:nil text:nil];
    [slideUpMenu addSideButtonWithImage:nil text:nil];
    [slideUpMenu addSideButtonWithImage:nil text:nil];
    
    [slideUpMenu.view addSubview:self.targetView];
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
