/**
 * This file is part of the SYTabBar.
 * (c) Ree Sun <ree.sun.cn@hotmail.com || 1507602555@qq.com>
 *
 * For more information, please view SYCore (https://github.com/reesun1130/SYTabBar)
 *
 */

#import "SYTabBarItem.h"
#import <QuartzCore/QuartzCore.h>

//用来标示分割线
#define kLineTag 10201

@interface SYTabBarItem ()
{
    UIImageView *_ivIcon;
    UIImageView *_ivBackground;

    UIImage *_icon;
    UIImage *_iconSelected;
    UIImage *_iconUnselected;
    
    UIView *_vContent;
    
    UILabel *_labTitle;
    UILabel *_labBadge;
    
    BOOL _selected;
    BOOL _isFirstLoad;//第一次加载不用调节frame
}

@end

@implementation SYTabBarItem

- (id)initWithFrame:(CGRect)frame title:(NSString *)title selectedImage:(UIImage *)selectedImage unselectedImage:(UIImage *)unselectedImage
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        _isFirstLoad = YES;
        _badgeColor = [UIColor whiteColor];
        _badgeBackgroundColor = [UIColor redColor];
        
        _vContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _vContent.backgroundColor = [UIColor clearColor];
        
        _iconSelected = selectedImage;
        _iconUnselected = unselectedImage;
        _icon = _iconUnselected;
                
        if (title && selectedImage)
        {
            _style = SYTabBarItemStyleNormal;
            
            _ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 30) / 2.0, 3, 30, 30)];
            _ivIcon.userInteractionEnabled = YES;
            _ivIcon.contentMode = UIViewContentModeScaleAspectFit;
            [self setSelected:NO];
            [_vContent addSubview:_ivIcon];
            
            _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_ivIcon.frame) + 3 , _vContent.frame.size.width - 10, 10)];
            _labTitle.userInteractionEnabled = YES;
            _labTitle.textColor = _unselectedTitleColor;
            _labTitle.backgroundColor = [UIColor clearColor];
            _labTitle.textAlignment = NSTextAlignmentCenter;
            _labTitle.font = [UIFont boldSystemFontOfSize:10.0];
            [_vContent addSubview:_labTitle];
        }
        else if (selectedImage && !title)
        {
            _style = SYTabBarItemStyleImageOnly;

            CGFloat ivH = self.frame.size.height >= 30 ? 30 : self.frame.size.height;
            
            _ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - ivH) / 2.0, (self.frame.size.height - ivH) / 2.0, ivH, ivH)];
            _ivIcon.userInteractionEnabled = YES;
            _ivIcon.contentMode = UIViewContentModeScaleAspectFit;
            [self setSelected:NO];
            [_vContent addSubview:_ivIcon];
        }
        else if (title && !selectedImage)
        {
            _style = SYTabBarItemStyleTextOnly;

            CGFloat labH = _vContent.frame.size.height;

            _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 0 , self.frame.size.width - 10, labH)];
            _labTitle.userInteractionEnabled = YES;
            _labTitle.textColor = _unselectedTitleColor;
            _labTitle.backgroundColor = [UIColor clearColor];
            _labTitle.textAlignment = NSTextAlignmentCenter;
            _labTitle.font = [UIFont boldSystemFontOfSize:14.0];
            [_vContent addSubview:_labTitle];
        }

        //数字提示
        _labBadge = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 15, 5.0, 10, 10)];
        _labBadge.hidden = YES;
        _labBadge.layer.masksToBounds = YES;
        _labBadge.layer.cornerRadius = 5;
        _labBadge.textColor = _badgeColor;
        _labBadge.backgroundColor = _badgeBackgroundColor;
        _labBadge.textAlignment = NSTextAlignmentCenter;
        _labBadge.font = [UIFont boldSystemFontOfSize:10];
        [_vContent addSubview:_labBadge];
        [self addSubview:_vContent];
        
        //分割线
        UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 1, 5, 1, self.frame.size.height - 10)];
        vLine.tag = kLineTag;
        vLine.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:223 / 255.0 blue:228 / 255.0 alpha:1.0];
        [self addSubview:vLine];
        [self setTitle:title];
    }
    return self;
}

//是否显示分割线
- (void)setShowDividingLine:(BOOL)showDividingLine
{
    _showDividingLine = showDividingLine;
    [[self viewWithTag:kLineTag] setHidden:!_showDividingLine];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    _labTitle.font = titleFont;
    
    //[self adjustItemWithTitle:_title badge:nil];
    /*if (self.blockTitleDidChange) {
        self.blockTitleDidChange(self);
    }*/
}

- (void)setTitle:(NSString *)title
{
    _title = title;
 
    if (!_isFirstLoad)
    {
        if (_title)
        {
            [self adjustItemWithTitle:_title badge:nil];
            if (self.blockTitleDidChange) {
                self.blockTitleDidChange(self);
            }
        }
    }
    _labTitle.text = _title;

    _isFirstLoad = NO;
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    _labTitle.textColor = _selectedTitleColor;
}

- (void)setUnselectedTitleColor:(UIColor *)unselectedTitleColor
{
    _unselectedTitleColor = unselectedTitleColor;
    _labTitle.textColor = _unselectedTitleColor;
}

- (void)setBadgeColor:(UIColor *)badgeColor
{
    _labBadge.textColor = badgeColor;
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    _labBadge.backgroundColor = badgeBackgroundColor;
}

- (void)setBadgeBorderColor:(CGColorRef)badgeBorderColor
{
    _badgeBorderColor = badgeBorderColor;
    _labBadge.layer.borderColor = badgeBorderColor;
}

- (void)setBadgeBorderWidth:(CGFloat)badgeBorderWidth
{
    _badgeBorderWidth = badgeBorderWidth;
    _labBadge.layer.borderWidth = badgeBorderWidth;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;

    if (_badgeValue && _badgeValue.doubleValue > 0)
    {
        _labBadge.hidden = NO;

        if (_badgeValue.doubleValue > 99)
        {
            _badgeValue = @"99";
        }
    }
    _labBadge.text = _badgeValue;

    [self adjustItemWithTitle:_title badge:_badgeValue];
    
    if (self.blockBadgeValueDidChange) {
        self.blockBadgeValueDidChange(self);
    }
}

- (void)setBadgeValueShow:(BOOL)badgeValueShow
{
    _badgeValueShow = badgeValueShow;
    _labBadge.hidden = !_badgeValueShow;
}

- (void)adjustItemWithTitle:(NSString *)title badge:(NSString *)badge
{
    CGSize labSize = CGSizeZero;
    CGFloat badgeW = 0;

    if (badge)
    {
        if (badge.doubleValue > 9)
        {
            badgeW = 15;
        }
        else
        {
            badgeW = 10;
        }
    }
    
    if (_style == SYTabBarItemStyleTextOnly)
    {
        if (title)
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
            labSize = [title sizeWithFont:_labTitle.font];
#else
            labSize = [title sizeWithAttributes:@{NSFontAttributeName:_labTitle.font}];
#endif
        }
        
        CGRect frame = self.frame;
        frame.size.width = labSize.width + 15 + badgeW;
        self.frame = frame;
        
        frame = _labTitle.frame;
        frame.size.width = labSize.width;
                
        if (badgeW)
        {
            frame.origin.x = 5;

            _labBadge.frame = CGRectMake(self.frame.size.width - badgeW - 5, (self.frame.size.height - 10) / 2.0, badgeW, 10);
        }
        else
        {
            frame.origin.x = (self.frame.size.width - labSize.width) / 2.0;
            _labBadge.frame = CGRectMake(self.frame.size.width - 15, 5.0, 10, 10);
        }
        _labTitle.frame = frame;

        //分割线
        UIView *vLine = [self viewWithTag:kLineTag];
        frame = vLine.frame;
        frame.origin.x = self.frame.size.width - 1;
        vLine.frame = frame;
    }
    else
    {
        if (badgeW)
        {
            _labBadge.frame = CGRectMake(self.frame.size.width - badgeW - 2, (self.frame.size.height - 10) / 2.0, badgeW, 10);
        }
        else
        {
            _labBadge.frame = CGRectMake(self.frame.size.width - 15, 5.0, 10, 10);
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if (_selected)
    {
        _labTitle.textColor = _selectedTitleColor;
        _icon = _iconSelected;
    }
    else
    {
        _labTitle.textColor = _unselectedTitleColor;
        _icon = _iconUnselected;
    }

    [_ivIcon setImage:_icon];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (backgroundImage != nil)
    {
        _ivBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self insertSubview:_ivBackground belowSubview:_vContent];
        _backgroundImage = backgroundImage;
        _ivBackground.contentMode = UIViewContentModeScaleAspectFill;
        [_ivBackground setImage:_backgroundImage];
    }
    else
    {
        _backgroundImage = nil;
        [_ivBackground removeFromSuperview];
        _ivBackground = nil;
    }
}

@end
