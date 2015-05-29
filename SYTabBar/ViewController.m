//
//  ViewController.m
//  SYTabBar
//
//  Created by sun on 15/5/11.
//  Copyright (c) 2015年 sun. All rights reserved.
//

#import "ViewController.h"
#import "SYTabBar.h"
#import "SYTabBarItem.h"

//font
#define kFontNormal0 [UIFont systemFontOfSize:14]

//color
#define kColorGray30 [UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1]
#define kColorGray40 [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1]
#define kColorBlue0 [UIColor colorWithRed:0/255.0 green:110/255.0 blue:191/255.0 alpha:1]
#define kLine10 [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1]
#define kLine20 [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1]

//line
#define kLinePixel  0.5

#define kTagA 100
#define kTagB 200
#define kTagC 300

@interface ViewController () <SYTabBarDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *itemsA = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *itemsB = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *itemsC = [[NSMutableArray alloc] initWithCapacity:5];
    
    NSString *arrTitles[5] = {@"别克",@"大众",@"福特",@"标志",@"丰田"};
    NSString *arrTitlesB[5] = {@"别克B",@"大众B",@"福特B",@"标志B",@"丰田B"};
    NSString *arrImagesNormal[5] = {@"BUICK",@"DASAUTO",@"FORD",@"PEUGEOT",@"TOYOTA"};
    NSString *arrImageSelected[5] = {@"BUICK",@"DASAUTO",@"FORD",@"PEUGEOT",@"TOYOTA"};
    
    CGFloat itemBW = (CGRectGetWidth(self.view.frame) - 60) / 4.0;
    
    for (int i = 0; i < 5; i ++)
    {
        SYTabBarItem *itemTempA = [[SYTabBarItem alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) / 5.0, 49) title:arrTitles[i] selectedImage:[UIImage imageNamed:arrImageSelected[i]] unselectedImage:[UIImage imageNamed:arrImagesNormal[i]]];
        itemTempA.selectedTitleColor = kColorBlue0;
        itemTempA.unselectedTitleColor = kColorGray30;
        [itemsA addObject:itemTempA];
        
        if (i < 4)
        {
            SYTabBarItem *itemTempB = [[SYTabBarItem alloc] initWithFrame:CGRectMake(0, 0, itemBW, 49) title:arrTitlesB[i] selectedImage:nil unselectedImage:nil];
            itemTempB.selectedTitleColor = kColorBlue0;
            itemTempB.unselectedTitleColor = kColorGray30;
            itemTempB.titleFont = kFontNormal0;
            itemTempB.badgeColor = kColorGray40;
            itemTempB.badgeBackgroundColor = [UIColor clearColor];
            itemTempB.badgeBorderWidth = kLinePixel;
            itemTempB.badgeBorderColor = kColorGray40.CGColor;
            [itemsB addObject:itemTempB];
        }
        
        SYTabBarItem *itemTempC = [[SYTabBarItem alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) / 5.0, 49) title:nil selectedImage:[UIImage imageNamed:arrImageSelected[i]] unselectedImage:[UIImage imageNamed:arrImagesNormal[i]]];
        itemTempC.selectedTitleColor = kColorBlue0;
        itemTempC.unselectedTitleColor = kColorGray30;
        [itemsC addObject:itemTempC];
    }
    
    //initalize the tab barA
    SYTabBar *_tabBarA = [[SYTabBar alloc] initWithSYTabBarItems:itemsA];
    _tabBarA.tag = kTagA;
    _tabBarA.tabBarDelegate = self;
    _tabBarA.showDividingLine = NO;
    //_tabBarA.enableBlurStyle = YES;
    
    CGRect fame = _tabBarA.frame;
    fame.origin.y = self.view.frame.size.height - fame.size.height;
    _tabBarA.frame = fame;
    [self.view addSubview:_tabBarA];
    
    //分割线
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, kLinePixel, _tabBarA.frame.size.width, kLinePixel)];
    vLine.backgroundColor = kLine20;
    [_tabBarA addSubview:vLine];

    //initalize the top barB
    SYTabBar *_tabBarB = [[SYTabBar alloc] initWithSYTabBarItems:itemsB];
    _tabBarB.tag = kTagB;
    _tabBarB.bounces = NO;
    _tabBarB.tabBarDelegate = self;
    _tabBarB.showDividingLine = YES;
    //_tabBarB.enableBlurStyle = YES;
    
    fame = _tabBarB.frame;
    fame.origin.y = 20;
    fame.size.width = CGRectGetMaxX(self.view.frame) - 60;
    _tabBarB.frame = fame;
    [self.view addSubview:_tabBarB];
    //_tabBarB.blurWidth = fame.size.width + 60;
    
    //分割线
    vLine = [[UIView alloc] initWithFrame:CGRectMake(0, _tabBarB.frame.origin.y, self.view.frame.size.width, kLinePixel)];
    vLine.backgroundColor = kLine20;
    [self.view addSubview:vLine];

    //分割线
    vLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tabBarB.frame) - kLinePixel, self.view.frame.size.width, kLinePixel)];
    vLine.backgroundColor = kLine20;
    [self.view addSubview:vLine];

    UIButton *_btnFilter = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnFilter setFrame: CGRectMake(CGRectGetMaxX(self.view.frame) - 60, _tabBarB.frame.origin.y, 60, _tabBarB.frame.size.height)];
    [_btnFilter setTitle:@"吖吖" forState:UIControlStateNormal];
    [_btnFilter setBackgroundColor:[UIColor clearColor]];
    [_btnFilter setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[_btnFilter setTitleColor:kColorBlue forState:UIControlStateSelected];
    //[_btnFilter setTitleColor:kColorBlue forState:UIControlStateHighlighted];
    [_btnFilter.titleLabel setFont:kFontNormal0];
    [_btnFilter addTarget:self action:@selector(onClickBtnFilter:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnFilter];
    
    //分割线
    vLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_btnFilter.frame) - kLinePixel, _btnFilter.frame.origin.y, kLinePixel, _btnFilter.frame.size.height)];
    vLine.backgroundColor = kLine10;
    [self.view addSubview:vLine];
    
    //initalize the top barC
    SYTabBar *_tabBarC = [[SYTabBar alloc] initWithSYTabBarItems:itemsC];
    _tabBarC.tag = kTagC;
    _tabBarC.tabBarDelegate = self;
    _tabBarC.showDividingLine = YES;
    //_tabBarB.enableBlurStyle = YES;
    
    fame = _tabBarC.frame;
    fame.origin.y = 80;
    _tabBarC.frame = fame;
    [self.view addSubview:_tabBarC];
    
    //分割线
    vLine = [[UIView alloc] initWithFrame:CGRectMake(0, kLinePixel, _tabBarC.frame.size.width, kLinePixel)];
    vLine.backgroundColor = kLine20;
    [_tabBarC addSubview:vLine];
    
    //分割线
    vLine = [[UIView alloc] initWithFrame:CGRectMake(0, _tabBarC.frame.size.height - kLinePixel, _tabBarC.frame.size.width, kLinePixel)];
    vLine.backgroundColor = kLine20;
    [_tabBarC addSubview:vLine];
}

- (void)onClickBtnFilter:(id)sender
{
    NSLog(@"onClickBtnFilter");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//SYTab bar delegate
- (void)tabBar:(SYTabBar *)tabBar didSelectItem:(SYTabBarItem *)item
{
    if (tabBar.tag == kTagA)
    {
        item.badgeValue = item.tag % 2 == 0 ? @"89" : @"";
        self.labText.text = [NSString stringWithFormat:@"select tabA %ld",(long)item.tag];
    }
    else if (tabBar.tag == kTagB)
    {
        if (item.tag % 2 == 0)
        {
            [tabBar setTitle:[NSString stringWithFormat:@"test%ld",(long)arc4random() % 1000000 + 10000] atIndex:item.tag];
            item.badgeValue = [NSString stringWithFormat:@"%ld",(long)arc4random() % 100 + 100];
            //[tabBar setBadgeValue:[NSString stringWithFormat:@"%ld",(long)arc4random() % 100 + 100] atIndex:item.tag];
        }
        else
        {
            [tabBar setTitle:[NSString stringWithFormat:@"testtesttesttestsssssssss%ld",(long)arc4random() % 1000000 + 10000] atIndex:item.tag];
            item.badgeValue = [NSString stringWithFormat:@"%ld",(long)item.tag + 9];
            //[tabBar setBadgeValue:[NSString stringWithFormat:@"%ld",(long)item.tag + 9] atIndex:item.tag];
        }
        
        self.labText.text = [NSString stringWithFormat:@"select tabB %ld",(long)item.tag];
    }
    else
    {
        item.badgeValue = [NSString stringWithFormat:@"%ld",(long)item.tag + 9];
        self.labText.text = [NSString stringWithFormat:@"select tabC %ld",(long)item.tag];
    }
    //[tabBar addItem:[[SYTabBarItem alloc] initWithFrame:CGRectMake(0, 0, 100, 49) title:nil selectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%dSelected",3]] unselectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%dNormal",3]]]];
    //[tabBar insertItem:[[SYTabBarItem alloc] initWithFrame:CGRectMake(0, 0, 100, 49) title:nil selectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%dSelected",3]] unselectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%dNormal",3]]] atIndex:3];
}

@end
