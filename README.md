DESlideUpMenu
=============

## What is this?
Iconic menu with animations.

## Install
Download and include in your project :)

## Usage
```obj-c
slideUpMenu = [[DESlideUpMenuViewController alloc] initWithFrame:self.targetView.bounds];

[slideUpMenu setDelegate:self];
[slideUpMenu setButtonCorner:DESlideButtonCornerBottomLeft];
[slideUpMenu setButtonSide:DESlideButtonSideColumn];

[slideUpMenu setMainButtonWithImage:[UIImage imageNamed:@"menu"] text:nil];
[slideUpMenu addSideButtonWithImage:[UIImage imageNamed:@"side_img_1"] text:nil];
[slideUpMenu addSideButtonWithImage:[UIImage imageNamed:@"side_img_2"] text:nil];

[targetView addSubview:slideUpMenu.view];
```

## License

DESlideUpMenu is licensed under the MIT license.

The MIT License (MIT)

Copyright (c) 2014 Kim Eui-Gyom

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
