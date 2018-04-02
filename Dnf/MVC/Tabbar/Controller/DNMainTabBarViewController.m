//
//  DNMainTabBarViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNMainTabBarViewController.h"

@interface DNMainTabBarViewController ()

@end

static NSInteger number =0;

@implementation DNMainTabBarViewController

static DNMainTabBarViewController* _myTabBarVC = nil;

#pragma mark - Init
+(DNMainTabBarViewController*)shareTabBarController{
    @synchronized(self){
        if (!_myTabBarVC) {
            
            _myTabBarVC = [[DNMainTabBarViewController alloc]init];
        }
    }
    return _myTabBarVC;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self creatUserInterface];
    
  
}

#pragma mark - Interface

-(void)creatUserInterface
{

    number = 0;
    
    self.tabBar.hidden = YES;
    
    [self initSubView];

    [self.view addSubview:self.tabBariew];
    

}

-(void)initSubView
{
    _viewControllerCount = ([DNConfig sharedConfig].audit==NO)?4:5;
    
    //首页
    DNHomePageViewController * homePageViewController= [DNHomePageViewController viewController];
    [self setupItemWithViewController:homePageViewController ItemData:@{@"title":@"首页",@"imageStr":@"tabbar_home_normal",@"imageStr_s":@"tabbar_home_hover"}];
    
    //视频
    DNVideoViewController * videoViewController = [DNVideoViewController viewController];
    [self setupItemWithViewController:videoViewController ItemData:@{@"title":@"视频",@"imageStr":@"tabbar_video_normal",@"imageStr_s":@"tabbar_video_hover"}];
    
    //派对
    DNPartyViewController * partyViewController = [DNPartyViewController viewController];
    [self setupItemWithViewController:partyViewController ItemData:@{@"title":@"派对",@"imageStr":@"tabbar_party_normal",@"imageStr_s":@"tabbar_party_hover"}];
    
    
    //写真
    DNPhotoViewController * photoViewController = [DNPhotoViewController viewController];
    [self setupItemWithViewController:photoViewController ItemData:@{@"title":@"写真",@"imageStr":@"tabbar_photo_normal",@"imageStr_s":@"tabbar_photo_hover"}];
    
    if ([DNConfig sharedConfig].audit==YES)
    {
        //Vr
        DNVRViewController  * vrViewController = [DNVRViewController viewController];
        [self setupItemWithViewController:vrViewController ItemData:@{@"title":@"VR专区",@"imageStr":@"tabbar_vr_normal",@"imageStr_s":@"tabbar_vr_hover"}];
        
    }
    

}

#pragma mark - Event response

//点击方法
-(void)SelectSubItemIndex:(UIGestureRecognizer *)gesture
{
    
    NSInteger selectindex = gesture.view.tag;

    [self setTabBarSelectedIndex:selectindex];
    
    [self jitterView:self.tabBariew.subviews[selectindex]];

}

#pragma mark - Private method
-(void)setupItemWithViewController:(DNBaseViewController *)vc ItemData:(NSDictionary *)data
{
    //封装item数据
    Item *item = [[Item alloc]initItemWithDictionary:data];
 
    [self addChildViewController:vc];
    
    CGFloat SubItemWidth = self.tabBariew.frame.size.width/_viewControllerCount;
    DNTabBarItem *subitem = [[DNTabBarItem alloc]initWithFrame:CGRectMake(SubItemWidth*number, 0,SubItemWidth, 54)];
    subitem.item = item;
    subitem.userInteractionEnabled = YES;
    subitem.tag =number;

    [self.tabBariew addSubview:subitem];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SelectSubItemIndex:)];
    [subitem addGestureRecognizer:tap];
    

    number++;
    
    [self initDefaultItem:0];
    
    
}


//默认选中item0
-(void)initDefaultItem:(NSInteger)index
{
    DNTabBarItem *subitem  = self.tabBariew.subviews[index];
    tempSelectItem = subitem;
    [subitem setItemSlected:^{
    }];
}

-(void)setTabBarSelectedIndex:(NSUInteger)selectedIndex
{
    self.selectedIndex = selectedIndex;
    
    DNTabBarItem *selectSubitem  = (DNTabBarItem*)self.tabBariew.subviews[selectedIndex];
    if(selectedIndex != tempSelectItem.tag){
        [selectSubitem setItemSlected:^{
            [tempSelectItem setItemNomal];
        }];
        tempSelectItem = selectSubitem;
    }
    
    
    
    
}

-(void)hiddenTabBar:(BOOL)hidden
{
    [UIView beginAnimations:@"hiddenTabbar" context:nil];
    [UIView setAnimationDuration:0.3];
    
    if(hidden){
        
        self.tabBariew.frame = CGRectMake(0,KScreenHeight+6,KScreenWidth,54);
   
        self.lineView.hidden = YES;
        
    }else{
        
        self.tabBariew.frame = CGRectMake(0,KScreenHeight-54 ,KScreenWidth, 54);
    
        self.lineView.hidden = NO;
    }
    [UIView commitAnimations];
}

// 抖动动画
-(void)jitterView:(DNTabBarItem*)subitem
{
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.15;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.85];
    pulse.toValue= [NSNumber numberWithFloat:1.15];
    [[subitem.iconImageView layer]addAnimation:pulse forKey:nil];
}



#pragma mark - Getters and Setters
-(UIView*)tabBariew
{
    if (!_tabBariew) {
        
        _tabBariew = [[UIView alloc] init];
        _tabBariew.frame = CGRectMake(0,KScreenHeight-54, KScreenWidth,54);
        _tabBariew.userInteractionEnabled = YES;
        _tabBariew.backgroundColor = [[UIColor customColorWithString:@"#FAFAFA"] colorWithAlphaComponent:0.96];
        
        
        
        _tabBariew.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
        _tabBariew.layer.shadowOffset = CGSizeMake(0,-6);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _tabBariew.layer.shadowOpacity = 0.1;//阴影透明度，默认0
        _tabBariew.layer.shadowRadius = 6;//阴影半径，默认3
 
    }
    return _tabBariew;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
