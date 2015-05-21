/**
 * This file is part of the SYTabBar.
 * (c) Ree Sun <ree.sun.cn@hotmail.com || 1507602555@qq.com>
 *
 * For more information, please view SYCore (https://github.com/reesun1130/SYTabBar)
 *
 */

#import <UIKit/UIKit.h>

@class SYTabBar;
@class SYTabBarItem;

@protocol SYTabBarDelegate <NSObject>

@optional

/**
 *  选中某一个item后的回调
 *
 *  @param tabBar SYTabBar
 *  @param item   选中的item
 */
- (void)tabBar:(SYTabBar *)tabBar didSelectItem:(SYTabBarItem *)item;

@end

@interface SYTabBar : UIScrollView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

/**
 *  初始化tabbar
 *
 *  @param items SYTabBarItem的集合
 *
 *  @return 初始化后的SYTabBar
 */
- (id)initWithSYTabBarItems:(NSArray *)items;

/**
 * Tabbar的delegate.
 */
@property (nonatomic, assign) id <SYTabBarDelegate> tabBarDelegate;

/**
 *  是否显示分隔条
 */
@property (nonatomic) BOOL showDividingLine;

/**
 *  是否启用模糊效果
 */
//@property (nonatomic) BOOL enableBlurStyle;

/**
 *  当前选中的item
 */
@property (nonatomic, strong) SYTabBarItem *selectedItem;

/**
 *  动态在最后插入item
 *
 *  @param item  要插入的item
 */
- (void)addItem:(SYTabBarItem *)item;

/**
 *  动态再最后插入items
 *
 *  @param items  要插入的items集合
 */
- (void)addItems:(NSArray *)items;

/**
 *  动态插入item,可选择位置
 *
 *  @param item  要插入的item
 *  @param index 插入的下标
 */
- (void)insertItem:(SYTabBarItem *)item atIndex:(NSUInteger)index;

/**
 *  动态删除item
 *
 *  @param item  要删除的item
 */
- (void)removeItem:(SYTabBarItem *)item;

/**
 *  删除下标为index的item
 */
- (void)removeItemAtIndex:(NSUInteger)index;

/**
 *  设置选中哪一个item
 *
 *  @param index item下标
 */
- (void)selectItemAtIndex:(NSUInteger)index;

/**
 *  动态设置item 标题
 *
 *  @param title 要设置的标题
 *  @param index item下标
 */
- (void)setTitle:(NSString *)title atIndex:(NSUInteger)index;

/**
 *  设置index的消息提示数字
 *
 *  @param badgeValue 提示
 *  @param index      item下标
 */
- (void)setBadgeValue:(NSString *)badgeValue atIndex:(NSUInteger)index;

@end
