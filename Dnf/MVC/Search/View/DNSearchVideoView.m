//
//  DNSearchVideoView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/8/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNSearchVideoView.h"
#import "DLShareView.h"
@implementation DNSearchVideoView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        
        [self addSubview:self.tableView];
 
    }
    
    return self;
    
}
#pragma mark - TabelView delegate 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 96;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString * cellid = @"DLVideoRecommendTableViewCell";
    
    DLVideoRecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[DLVideoRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.cellDelegate = self;
    cell.videoModel = self.dataArray[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNVideoModel * videoModel = self.dataArray[indexPath.row];
    
    if (self.delegate) {
        [self.delegate selectVideo:videoModel];
    }
}

-(void)colleciton:(DNVideoModel*)videoModel
{
    if (self.delegate) {
        [self.delegate colleciton:videoModel];
    }
    
}
-(void)share:(DNVideoModel*)videoModel;
{
    NSString * relationid = @"";
    
    NSDictionary * shareDict = [NSDictionary dictionaryWithObjectsAndKeys:relationid,@"relationid",nil];
    
    [DLShareView showMyShareViewWothSuperView:self
                                  isShowLaHei:NO
                                       userId:nil
                                      andType:10
                                resourcesType:@""
                                    andRoomID:@"1"
                                 andShareDict:shareDict
                                    backColor:nil];
}



#pragma mark getter

-(UITableView*)tableView
{
    if (!_tableView) {
    
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.separatorColor = [UIColor customColorWithString:@"eeeeee"];
        
    }
    return _tableView;
}



-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.tableView reloadData];
}

@end
