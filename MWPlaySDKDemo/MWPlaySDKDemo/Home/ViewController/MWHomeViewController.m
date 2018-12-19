//
//  HomeViewController.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWHomeViewController.h"
#import "MWMontUserCenter.h"
#import "MWHomeListCell.h"
#import "MWPlayViewController.h"
#import "MWLiveListModel.h"
#import "MWLiveDetailModel.h"
#import "MWVideoDetailModel.h"


@interface MWHomeViewController ()


@property (nonatomic, strong) UITableView *liveTableView;


@property (nonatomic, strong) UITableView *videoTableView;

@property (nonatomic, strong) NSMutableArray *liveDataSource;

@property (nonatomic, strong) NSMutableArray *videoDataSource;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic ,strong) UIView *tableFooterView;

@property (nonatomic, copy) UISegmentedControl *segmentedControl;


@end

@implementation MWHomeViewController



- (NSMutableArray *)liveDataSource {
    
    if (_liveDataSource == nil) {
        
        _liveDataSource = [NSMutableArray array];
        
    }
    return _liveDataSource;
}

- (NSMutableArray *)videoDataSource {
    
    if (_videoDataSource == nil) {
        
        _videoDataSource = [NSMutableArray array];
        
    }
    return _videoDataSource;
}



- (UITableView *)liveTableView {
    
    if (_liveTableView == nil) {
        
        _liveTableView = ({
            UITableView *tableView = [UITableView ZFC_TableViewChainedCreater:^(ZFC_TableViewChainedCreater *creater) {
                
                creater.frameAndStyle(CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64), UITableViewStylePlain)
                .backgroundColor([UIColor whiteColor])
                .separatorStyleAndColor(UITableViewCellSeparatorStyleSingleLine, [UIColor lightGrayColor])
                .rowHeight(100)
                .addIntoView(self.view);
                
            }];
            
            kWeakSelf(self)
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                weakself.pageIndex = 1;
                [weakself loadLiveDataSuccessBlock:nil];
                [self.liveTableView.mj_header endRefreshing];
            }];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.automaticallyChangeAlpha = YES;
            header.stateLabel.hidden = YES;
            [tableView setMj_header:header];
            
            tableView;
        });
    }
    return _liveTableView;
    
}


- (UITableView *)videoTableView {
    
    if (_videoTableView == nil) {
        
        _videoTableView = ({
            UITableView *tableView = [UITableView ZFC_TableViewChainedCreater:^(ZFC_TableViewChainedCreater *creater) {
                
                creater.frameAndStyle(CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64), UITableViewStylePlain)
                .backgroundColor([UIColor whiteColor])
                .separatorStyleAndColor(UITableViewCellSeparatorStyleSingleLine, [UIColor lightGrayColor])
                .rowHeight(100)
                .addIntoView(self.view);
                
            }];
            
            
            kWeakSelf(self)
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                weakself.pageIndex = 1;
                [weakself loadVideoDataSuccessBlock:nil];
                [self.videoTableView.mj_header endRefreshing];
            }];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.automaticallyChangeAlpha = YES;
            header.stateLabel.hidden = YES;
            [tableView setMj_header:header];
            
            tableView;
        });
    }
    return _videoTableView;
    
}


- (UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,  49)];
        UILabel *textLb = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 90 / 2.0, 10, 90, 19)];
        textLb.font = kRegularFontIsB4IOS9(13);
        textLb.textColor = [UIColor colorWithHexString:@"#999999" Alpha:1.0];
        textLb.text = @"- 没有更多了 -"; //国际化语言未适配
        textLb.textAlignment = NSTextAlignmentCenter;
        [_tableFooterView addSubview:textLb];
    }
    return _tableFooterView;
}


- (UISegmentedControl *)segmentedControl {
    
    if (!_segmentedControl) {
        CGFloat controlWidth = 120.0;
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"直播",@"短视频"]];
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.frame = CGRectMake((kScreenWidth - controlWidth) / 2, 100, controlWidth, 30);
        _segmentedControl.centerX=self.view.centerX;
        _segmentedControl.tintColor = [UIColor redColor];
        [_segmentedControl addTarget:self action:@selector(segmentControlClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pageIndex = 1;
    
    self.navigationItem.titleView = self.segmentedControl;
    
    [self layoutUI];
    
    [self loadLiveDataSuccessBlock:nil];
    
    [self loadVideoDataSuccessBlock:nil];

}


- (void)segmentControlClick:(UISegmentedControl *)segmentControl {
    if (segmentControl.selectedSegmentIndex == 0) {
        
        self.liveTableView.hidden = NO;
        self.videoTableView.hidden = YES;
    }else {
        self.liveTableView.hidden = YES;
        self.videoTableView.hidden = NO;
    }
}


- (void)layoutUI {
    
    //直播列表
    ZFC_TableViewChainedInvokeConfig *tableViewConfig = [ZFC_TableViewChainedInvokeConfig new];
    tableViewConfig.tableView = self.liveTableView;
    tableViewConfig.isCellXib = NO;
    tableViewConfig.cellClass = [MWHomeListCell class];
    tableViewConfig.canDelete = NO;
    
    __weak typeof(self)weakSelf = self;
    [self.liveTableView configure:^(ZFC_TableViewChainedInvokeCreater *creater) {
        
        creater.zfc_tableViewConfigure(tableViewConfig)
        
        .zfc_numberOfSectionsInTableView(^NSInteger(UITableView *tableView){
            return 1;
        })
        .zfc_numberOfRowsInSection(^NSInteger(UITableView *tableView,NSInteger section) {
            return weakSelf.liveDataSource.count;
            
        })
        .zfc_heightForRowAtIndexPath(^CGFloat(UITableView *tableView,NSIndexPath *indexPath) {
            
            return 80;
        })
        .zfc_cellForRowAtIndexPath(^(UITableView *tableView,__kindof MWHomeListCell *cell, NSIndexPath *indexPath) {
            
            MWLiveListModel *liveListModel = [weakSelf.liveDataSource safeObjectAtIndex:indexPath.row];
            cell.liveListModel = liveListModel;
            
        })
        .zfc_didSelectRowAtIndexPath(^(UITableView *tableView,NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            MWLiveListModel *listModel = [self.liveDataSource safeObjectAtIndex:indexPath.row];
            [weakSelf jumpToLiveDetailWithLiveInfo:listModel];
            
        });
    }];
    
    
    //录像列表
    ZFC_TableViewChainedInvokeConfig *tableViewConfig_video = [ZFC_TableViewChainedInvokeConfig new];
    tableViewConfig_video.tableView = self.videoTableView;
    tableViewConfig_video.isCellXib = NO;
    tableViewConfig_video.cellClass = [MWHomeListCell class];
    tableViewConfig_video.canDelete = NO;
    

    [self.videoTableView configure:^(ZFC_TableViewChainedInvokeCreater *creater) {
        
        creater.zfc_tableViewConfigure(tableViewConfig_video)
        
        .zfc_numberOfSectionsInTableView(^NSInteger(UITableView *tableView){
            return 1;
        })
        .zfc_numberOfRowsInSection(^NSInteger(UITableView *tableView,NSInteger section) {
            return weakSelf.videoDataSource.count;
            
        })
        .zfc_heightForRowAtIndexPath(^CGFloat(UITableView *tableView,NSIndexPath *indexPath) {
            
            return 80;
        })
        .zfc_cellForRowAtIndexPath(^(UITableView *tableView,__kindof MWHomeListCell *cell, NSIndexPath *indexPath) {
            
            MWVideoListModel *videoListModel = [weakSelf.videoDataSource safeObjectAtIndex:indexPath.row];
            cell.videoListModel = videoListModel;
            
        })
        .zfc_didSelectRowAtIndexPath(^(UITableView *tableView,NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            MWVideoListModel *videoListModel = [self.videoDataSource safeObjectAtIndex:indexPath.row];
            [weakSelf jumpToVideoDetailWithVideoInfo:videoListModel];
            
        });
    }];
    
    
    self.videoTableView.hidden = YES;
}


- (void)checkSDKState:(void(^)(BOOL success))response {
    
    if (![MWSDKConfigHelper sharedInstance].sdkState) {
        [[MWSDKConfigHelper sharedInstance] initWithSDKVersion:SDKVersion sdkVersionKey:SDKKey response:^(BOOL success, NSString *msg) {
            if (response) {
                response(success);
            }
        }];
    }else {
        response(YES);
    }
}

//播放直播
- (void)jumpToLiveDetailWithLiveInfo:(MWLiveListModel *)listModel{
    
    [self checkSDKState:^(BOOL success) {
        
        if (success) {
            
            [MWMontUserCenter queryLiveDetailInfoWithLiveId:listModel.liveId userId:@"" complete:^(id responseObject, NSError *error) {
                
                if ([responseObject[@"code"] integerValue]== 200) {
                    
                    MWLiveDetailModel *detailModel = [MWLiveDetailModel mj_objectWithKeyValues:responseObject[@"obj"]];
                    MWPlayViewController *playToolControl = [[MWPlayViewController alloc]init];
                    
                    if (detailModel.liveStatus == 0) { //预约
                        
                        playToolControl.isOrder = YES;
                    }else if (detailModel.liveStatus == 1) { //直播中
                        
                        MWDefinitionModel *mainDefModel = [MWDefinitionModel new];
                        mainDefModel.playUrl = detailModel.playUrl;
                        mainDefModel.playUrl720 = detailModel.playUrl720;
                        mainDefModel.playUrl480 = detailModel.playUrl480;
                        playToolControl.mainDefinitionModel = mainDefModel;
                        
                        if (detailModel.playUrl.length == 0) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该清晰度返回的url为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                            [alert show];
                            return ;
                        }
                        
                        
                        if (detailModel.slaveLiveInfo) {
                            MWDefinitionModel *secondaryDefModel = [MWDefinitionModel new];
                            secondaryDefModel.playUrl = detailModel.slaveLiveInfo[@"playUrl"];
                            secondaryDefModel.playUrl720 = detailModel.slaveLiveInfo[@"playUrl720"];
                            secondaryDefModel.playUrl480 = detailModel.slaveLiveInfo[@"playUrl480"];
                            playToolControl.secondaryDefinitionModel = secondaryDefModel;
                        }
                        
                        playToolControl.isLive  = YES;
                        
                    }else if(detailModel.liveStatus == 2){ //直播结束,取liveAfterUrl作为播放地址，而且此时是回放状态(这种情况暂时没有清晰度切换)
                        
                        MWDefinitionModel *mainDefModel = [MWDefinitionModel new];
                        mainDefModel.playUrl = detailModel.liveAfterUrl;
                        mainDefModel.playUrl720 = nil;
                        mainDefModel.playUrl480 = nil;
                        playToolControl.mainDefinitionModel = mainDefModel;
                        
                        
                        if (detailModel.slaveLiveInfo) {
                            MWDefinitionModel *secondaryDefModel = [MWDefinitionModel new];
                            secondaryDefModel.playUrl = detailModel.slaveLiveInfo[@"liveAfterUrl"];
                            secondaryDefModel.playUrl720 = nil;
                            secondaryDefModel.playUrl480 = nil;
                            playToolControl.secondaryDefinitionModel = secondaryDefModel;
                        }
                        
                        playToolControl.isLive  = NO;
                        
                    }else if (detailModel.liveStatus == 3) { //直播异常
                        
                        //FIXME:
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"直播异常" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                        [alert show];
                        return ;
                        
                    }else if (detailModel.liveStatus == 4){ //过期
                        //FIXME:
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"直播间过期" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                        [alert show];
                        return ;
                    }
                    
                    playToolControl.liveId  = detailModel.liveId;
                    playToolControl.liveCover = detailModel.liveCover;
                    
                    playToolControl.preventRecordScreen = detailModel.preventRecordScreen;
                    MWNavigationController *nav = [[MWNavigationController alloc] initWithRootViewController:playToolControl];
                    [self presentViewController:nav animated:YES completion:nil];
                }
            }];
            
        }
    }];
    
}


//播放小视频
- (void)jumpToVideoDetailWithVideoInfo:(MWVideoListModel *)listModel {
    
    
    [self checkSDKState:^(BOOL success) {
        
        if (success) {
            
            [MWMontUserCenter queryVideoDetailInfoWithVideoId:listModel.liveId complete:^(id responseObject, NSError *error) {
                if ([responseObject[@"code"] integerValue]== 200) {
                    
                    MWVideoDetailModel *detailModel = [MWVideoDetailModel mj_objectWithKeyValues:responseObject[@"obj"]];
                    MWPlayViewController *playToolControl = [[MWPlayViewController alloc]init];
                    
                    MWDefinitionModel *mainDefModel = [MWDefinitionModel new];
                    mainDefModel.playUrl = detailModel.videoSource.playUrl;
                    mainDefModel.playUrl720 = detailModel.videoSource.playUrl720;
                    mainDefModel.playUrl480 = detailModel.videoSource.playUrl480;
                    playToolControl.mainDefinitionModel = mainDefModel;
                    
                    
                    //FIXME:测试双屏使用，实际不存在
                    MWDefinitionModel *secondaryDefModel = [MWDefinitionModel new];
                    secondaryDefModel.playUrl = detailModel.videoSource.playUrl;
                    secondaryDefModel.playUrl720 = detailModel.videoSource.playUrl720;
                    secondaryDefModel.playUrl480 = detailModel.videoSource.playUrl480;
                    playToolControl.secondaryDefinitionModel = secondaryDefModel;
                    
                    
                    if (detailModel.videoSource.playUrl.length == 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该清晰度返回的url为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                        [alert show];
                        return ;
                    }
                    
                    MWVideoDetailModel *dbModel = [MWVideoDBManger queryVideoInfoWithVideoID:detailModel.liveId];
                    if (dbModel) {
                        detailModel.lastWatchTime = dbModel.lastWatchTime;
                    }
                    playToolControl.videoModel = detailModel;
                    playToolControl.liveCover = detailModel.videoCover;
                    
                    
                    playToolControl.liveId  = detailModel.liveId;
                    playToolControl.isLive  = NO;
                    MWNavigationController *nav = [[MWNavigationController alloc] initWithRootViewController:playToolControl];
                    [self presentViewController:nav animated:YES completion:nil];
                }
            }];
            
        }
        
    }];
}


- (void)loadLiveDataSuccessBlock:(void(^)(void))successBlock{
    
    [MWMontUserCenter queryLiveListComplete:^(id responseObject, NSError *error) {

        if ([responseObject[@"code"] integerValue]== 200) {

            [self.liveDataSource removeAllObjects];
            NSArray *dataList = responseObject[@"obj"];

            if(!ObjIsEqualNSNull(dataList)){
                if (dataList.count > 0) {
                    self.liveDataSource = [NSMutableArray arrayWithArray:[MWLiveListModel mj_objectArrayWithKeyValuesArray:dataList]];
                }
                [self.liveTableView reloadData];
            }
        }
    }];
}


- (void)loadVideoDataSuccessBlock:(void(^)(void))successBlock{
    [MWMontUserCenter queryVideoListComplete:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] integerValue]== 200) {
            
            [self.videoDataSource removeAllObjects];
            
            NSArray *dataList = responseObject[@"obj"];
            if(!ObjIsEqualNSNull(dataList)){
                if (dataList.count > 0) {
                    self.videoDataSource = [NSMutableArray arrayWithArray:[MWVideoListModel mj_objectArrayWithKeyValuesArray:dataList]];
                }
                [self.videoTableView reloadData];
            }
        }
    }];
    
}





@end
