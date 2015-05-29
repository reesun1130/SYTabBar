/**
 * This file is part of the SYTabBar.
 * (c) Ree Sun <ree.sun.cn@hotmail.com || 1507602555@qq.com>
 *
 * For more information, please view SYTabBar (https://github.com/reesun1130/SYTabBar)
 *
 */

#import "SYTabBar.h"
#import "SYTabBarItem.h"

#define kToolBarTag 2015
#define kUnselectTag 19881

@interface SYTabBar ()
{
    UITapGestureRecognizer *_singleTapGesture;
    UIView *_vTabContainer;
    
    NSUInteger _previousSelectedIndex;
    NSUInteger _selectedIndex;

    NSMutableArray *_arrItems;
}

@end

@implementation SYTabBar

- (id)initWithSYTabBarItems:(NSArray *)items
{
    //管理所有item
    _arrItems = [[NSMutableArray alloc] initWithArray:items];
    
    SYTabBarItem *barItem = items[0];
    
    _vTabContainer = [[UIView alloc] initWithFrame:CGRectZero];
    
    CGFloat tabContentW = 0;
    CGFloat tabH = barItem.frame.size.height;
    NSUInteger tag = 0;

    for (SYTabBarItem *item in items)
    {
        item.frame = CGRectMake(0.0, 0.0, item.frame.size.width, item.frame.size.height);
        item.tag = tag;
        
        CGRect frame = [item frame];
        frame.origin.x = tabContentW;
        frame.origin.y = 0;
        [item setFrame:frame];
        [_vTabContainer addSubview:item];
        
        tabContentW += item.frame.size.width;
        tabH = item.frame.size.height > tabH ? item.frame.size.height : tabH;
        tag += 1;
        
        item.blockBadgeValueDidChange = ^(SYTabBarItem *aitem){
            [self adjustTabItems];
        };
        item.blockTitleDidChange = ^(SYTabBarItem *aitem){
            [self adjustTabItems];
        };
    }
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, tabH);

    if (self = [super initWithFrame:frame])
    {
        //Initialization code
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.userInteractionEnabled = YES;
        self.contentSize = CGSizeMake(tabContentW, tabH);

        //主视图,添加item
        _vTabContainer.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        _vTabContainer.backgroundColor = [UIColor clearColor];
        _vTabContainer.userInteractionEnabled = NO;
        [self addSubview:_vTabContainer];

        //点击事件
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        _singleTapGesture.cancelsTouchesInView = NO;
        _singleTapGesture.delegate = self;
        _singleTapGesture.delaysTouchesBegan = NO;
        [self addGestureRecognizer:_singleTapGesture];
        
        //记录上次选中的index，默认选中第一个item
        _previousSelectedIndex = kUnselectTag;
    }
    return self;
}

- (void)dealloc
{
    self.selectedItem = nil;
    self.tabBarDelegate = nil;
    
    [self removeGestureRecognizer:_singleTapGesture];
}

//是否显示分割线
- (void)setShowDividingLine:(BOOL)showDividingLine
{
    _showDividingLine = showDividingLine;
    
    if (_showDividingLine)
    {
        [_arrItems enumerateObjectsUsingBlock:^(SYTabBarItem *obj, NSUInteger idx, BOOL *stop){
            
            if (idx < _arrItems.count - 1)
            {
                obj.showDividingLine = _showDividingLine;
            }
            else
            {
                obj.showDividingLine = !_showDividingLine;
            }
        }];
    }
    else
    {
        [_arrItems enumerateObjectsUsingBlock:^(SYTabBarItem *obj, NSUInteger idx, BOOL *stop){
            obj.showDividingLine = _showDividingLine;
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //防止scrollview手势冲突
    if ((gestureRecognizer == self.panGestureRecognizer || otherGestureRecognizer == self.panGestureRecognizer) || (gestureRecognizer == _singleTapGesture || otherGestureRecognizer == _singleTapGesture)){
        
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *  item单击事件
 *
 *  @param gesture tapgesture
 */
- (void)singleTapGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:_vTabContainer];
    
    SYTabBarItem *item = (SYTabBarItem *)[self itemAtTapLocation:location];
    
    if (item != nil)
    {
        [self selectItem:item];
    }
}

/**
 *  返回在触摸区域内的item
 *
 *  @param location 触摸区域
 *
 *  @return SYTabBarItem
 */
- (SYTabBarItem *)itemAtTapLocation:(CGPoint)location
{
    //先查找区域内是否有item
    for (SYTabBarItem *subView in _arrItems)
    {
        if (CGRectContainsPoint(subView.frame, location))
        {
            return subView;
        }
    }
    
    return nil;
}

- (void)setSelectedItem:(SYTabBarItem *)selectedItem
{
    [self selectItem:selectedItem];
}

- (void)selectItem:(SYTabBarItem *)item
{
    if (!item)
        return;
    
    BOOL shouldSelect = _previousSelectedIndex != item.tag;
    
    if (shouldSelect)
    {
        [item setSelected:YES];
        
        //取消选中其他的item
        for (SYTabBarItem *temp in _arrItems)
        {
            if (temp.tag != item.tag)
            {
                [temp setSelected:NO];
            }
        }
        
        //记录选中的index及item
        _previousSelectedIndex = item.tag;
        _selectedItem = item;
        
        [self didSelectItem];
    }
}

- (void)didSelectItem
{
    NSLog(@"didSelectItem %ld",(long)_previousSelectedIndex);
    
    if ([_tabBarDelegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
        [_tabBarDelegate tabBar:self didSelectItem:_selectedItem];
    }
}

- (void)selectItemAtIndex:(NSUInteger)index
{
    if (index < _arrItems.count)
    {
        [self selectItem:_arrItems[index]];
    }
}

- (NSUInteger)selectedIndex
{
    return _previousSelectedIndex;
}

- (void)unSelectItemAtIndex:(NSUInteger)index
{
    if (index < _arrItems.count)
    {
        SYTabBarItem *item = _arrItems[index];
        [item setSelected:NO];
        
        //记录选中的index及item
        _previousSelectedIndex = kUnselectTag;
        
        if (_selectedItem.tag == item.tag)
        {
            _selectedItem = nil;
        }
    }
}

- (void)unSelectItem:(SYTabBarItem *)item
{
    if (!item) {
        return;
    }
    
    [self unSelectItemAtIndex:item.tag];
}

- (NSUInteger)itemCount
{
    return _arrItems ? _arrItems.count : 0;
}

- (void)setTitle:(NSString *)title atIndex:(NSUInteger)index
{
    if (index < _arrItems.count)
    {
        SYTabBarItem *itemTemp = _arrItems[index];
        [itemTemp setTitle:title];
        
        [self adjustTabItems];
    }
}

- (void)setBadgeValue:(NSString *)badgeValue atIndex:(NSUInteger)index
{
    if (index < _arrItems.count)
    {
        SYTabBarItem *barItem = _arrItems[index];
        barItem.badgeValue = badgeValue;
        
        [self adjustTabItems];
    }
}

- (void)addItem:(SYTabBarItem *)item
{
    if (item)
    {
        SYTabBarItem *itemTmp = [_arrItems lastObject];
        itemTmp.showDividingLine = YES;

        item.tag = _arrItems.count;
        
        CGRect frame = [item frame];
        frame = CGRectMake(0.0, 0.0, item.frame.size.width, item.frame.size.height);
        frame.origin.x = CGRectGetMaxX(itemTmp.frame);
        frame.origin.y = 0;
        [item setFrame:frame];
        [_arrItems addObject:item];
        [_vTabContainer addSubview:item];
        
        itemTmp = [_arrItems lastObject];
        itemTmp.showDividingLine = NO;

        self.contentSize = CGSizeMake(CGRectGetMaxX(item.frame), self.frame.size.height);
    }
}

- (void)addItems:(NSArray *)items
{
    if (items && items.count)
    {
        for (SYTabBarItem *item in items)
        {
            [self addItem:item];
        }
    }
}

- (void)insertItem:(SYTabBarItem *)item atIndex:(NSUInteger)index
{
    if (index <= _arrItems.count)
    {
        [_arrItems insertObject:item atIndex:index];
        [_vTabContainer addSubview:item];
        [self adjustTabItems];
    }
}

- (void)removeItem:(SYTabBarItem *)item
{
    [self removeItemAtIndex:item.tag];
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    if (index < _arrItems.count)
    {
        [_arrItems[index] removeFromSuperview];
        [_arrItems removeObjectAtIndex:index];
        
        [self adjustTabItems];
    }
}

- (void)removeAllItems
{
    if (_arrItems.count)
    {
        [_arrItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_arrItems removeAllObjects];
        [self adjustTabItems];
    }
}

- (void)updateItems:(NSArray *)items
{
    if (items && items.count)
    {
        [self removeAllItems];
        [self addItems:items];
    }
}

- (void)adjustTabItems
{
    NSUInteger count = _arrItems.count;
    
    //调整位置
    CGFloat itemX = 0;
    
    if (count)
    {
        for (NSUInteger i = 0; i < count; i++)
        {
            SYTabBarItem *item = _arrItems[i];
            item.tag = i;
            [item setFrame:CGRectMake(itemX, 0, item.frame.size.width, item.frame.size.height)];
            
            itemX += item.frame.size.width;
        }
        
        ((SYTabBarItem *)[_arrItems lastObject]).showDividingLine = NO;
    }
    
    self.contentSize = CGSizeMake(itemX, self.frame.size.height);
}

@end
