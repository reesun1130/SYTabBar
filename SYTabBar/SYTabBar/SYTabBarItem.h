/**
 * This file is part of the SYTabBar.
 * (c) Ree Sun <ree.sun.cn@hotmail.com || 1507602555@qq.com>
 *
 * For more information, please view SYTabBar (https://github.com/reesun1130/SYTabBar)
 *
 */

#import <UIKit/UIKit.h>
@class SYTabBarItem;

typedef NS_ENUM(NSInteger, SYTabBarItemStyle) {
    SYTabBarItemStyleNormal = 0,//上图片、下文字
    SYTabBarItemStyleTextOnly,//只显示文字
    SYTabBarItemStyleImageOnly//只显示图片
};

/**
 *  item标题改变的回调
 *
 *  @param item 当前的item
 */
typedef void(^ItemTitleDidChangeBlock)(SYTabBarItem *item);

/**
 *  item badge提示改变的回调
 *
 *  @param item 当前item
 */
typedef void(^ItemBadgeValueDidChangeBlock)(SYTabBarItem *item);

@interface SYTabBarItem : UIView

/**
 *  初始化item
 *
 *  @param frame           位置、大小
 *  @param title           显示的内容
 *
 *  @return UCTabBarItem
 */
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

/**
*  初始化item
*
*  @param frame           位置、大小
*  @param title           显示的内容
*  @param selectedImage   高亮图片
*  @param unselectedImage 未选中图片
*
*  @return SYTabBarItem
*/
- (id)initWithFrame:(CGRect)frame title:(NSString *)title selectedImage:(UIImage *)selectedImage unselectedImage:(UIImage *)unselectedImage;

@property (nonatomic, copy) ItemTitleDidChangeBlock blockTitleDidChange;
@property (nonatomic, copy) ItemBadgeValueDidChangeBlock blockBadgeValueDidChange;

/**
 *  选中背景
 */
@property (nonatomic, strong) UIImage *backgroundImage;

/**
 *  选中的字体颜色
 */
@property (nonatomic, strong) UIColor *selectedTitleColor;

/**
 *  未选中时的字体颜色
 */
@property (nonatomic, strong) UIColor *unselectedTitleColor;

/**
 *  消息数字提醒颜色 默认white
 */
@property (nonatomic, strong) UIColor *badgeColor;

/**
 *  消息数字提醒背景颜色 默认red
 */
@property (nonatomic, strong) UIColor *badgeBackgroundColor;

/**
 *  消息数字提醒边线宽
 */
@property (nonatomic) CGFloat badgeBorderWidth;

/**
 *  消息数字提醒边线颜色
 */
@property (nonatomic) CGColorRef badgeBorderColor;

/**
 *  消息数字提醒
 */
@property (nonatomic, copy) NSString *badgeValue;// > 99则只显示99

/**
 *  消息数字提醒是否显示，默认显示
 */
@property (nonatomic) BOOL badgeValueShow;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  标题字体样式
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  tabbar类型，默认UCTabBarItemStyleNormal
 */
@property (nonatomic, readonly) SYTabBarItemStyle style;

/**
 *  是否显示分隔条
 */
@property (nonatomic) BOOL showDividingLine;

/**
 *  文字距离分割线间距，默认10
 */
@property (nonatomic) CGFloat hPadding;

/**
 *  item最小宽度，默认初始化宽度
 */
@property (nonatomic) CGFloat minWidth;

/**
 *  是否选中
 *
 *  @param selected yes/no
 */
- (void)setSelected:(BOOL)selected;

@end
