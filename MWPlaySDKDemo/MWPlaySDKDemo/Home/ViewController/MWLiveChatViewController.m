//
//  MWPlayChatViewController.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWLiveChatViewController.h"
#import "MWCommentData.h"
#import "MWChatMsgCell.h"
#import "MWCommentToolBar.h"
#import "KKInputView.h"
#import "BKDefinitionChooseView.h"



@interface MWLiveChatViewController ()
<MWChatMsgCellDelegate,
MWCommentToolBarDelegate,
KKInputViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *dataSource;

@property (nonatomic ,strong) dispatch_queue_t fetchDataQueue ;

/** 存取消息的消息id和cell的row */
@property (nonatomic ,strong) NSMutableDictionary *messageKeyMap;

/**信号*/
@property (nonatomic ,strong) dispatch_semaphore_t dsema;

/** 底部的工具栏 */
@property (nonatomic ,strong) MWCommentToolBar *toolbar ;

/** 输入视图(键盘弹出视图) */
@property (nonatomic ,strong) KKInputView *inputView;

/** 礼物按钮 */
@property (nonatomic,strong) UIButton *gifButton;

/** 点赞按钮 */
@property (nonatomic,strong) UIButton *parasButton;

/** 清晰度选择按钮 */
@property (nonatomic,strong) UIButton *definitionChooseButton;

/** 短视频用于来回播放不同url的视频 */
@property (nonatomic,strong) UIButton *changeShortVideoButton;

/** 清晰度选择试图 */
@property (nonatomic,strong) BKDefinitionChooseView *chooseView;


@end

@implementation MWLiveChatViewController

- (UIButton *)gifButton {
    
    if (_gifButton == nil) {
        
        kWeakSelf(self)
        _gifButton = [UIButton ZFC_ButtonChainedCreater:^(ZFC_ButtonChainedCreater *creater) {
            creater.frame(CGRectMake(kScreenWidth - 80, kScreenHeight  - kScreenWidth*9/16  - 44 - 35 - 52, 80, 35))
            .title(@"送礼", UIControlStateNormal)
            .titleLabelFont([UIFont systemFontOfSize:15])
            .titleColor([UIColor redColor], UIControlStateNormal)
            .backgroundColor([UIColor lightGrayColor])
            .actionBlock(^(UIButton *button) {
                
                if ([weakself.delegate respondsToSelector:@selector(sendGif)]) {
                    [weakself.delegate sendGif];
                }
            });
        }];
        
    }
    return _gifButton;
}


- (UIButton *)parasButton {
    
    if (_parasButton == nil) {
        
        kWeakSelf(self)
        _parasButton = [UIButton ZFC_ButtonChainedCreater:^(ZFC_ButtonChainedCreater *creater) {
            creater.frame(CGRectMake(kScreenWidth - 80, kScreenHeight  - kScreenWidth*9/16  - 44 - 35 - 104, 80, 35))
            .title(@"点赞", UIControlStateNormal)
            .titleLabelFont([UIFont systemFontOfSize:15])
            .titleColor([UIColor redColor], UIControlStateNormal)
            .backgroundColor([UIColor lightGrayColor])
            .actionBlock(^(UIButton *button) {
                
                if ([weakself.delegate respondsToSelector:@selector(sendParas)]) {
                    [weakself.delegate sendParas];
                }
            });
        }];
        
    }
    return _parasButton;
}

- (UIButton *)definitionChooseButton {
    
    if (_definitionChooseButton == nil) {
        
        kWeakSelf(self)
        _definitionChooseButton = [UIButton ZFC_ButtonChainedCreater:^(ZFC_ButtonChainedCreater *creater) {
            creater.frame(CGRectMake(kScreenWidth - 80, kScreenHeight  - kScreenWidth*9/16  - 44 - 35 - 156, 80, 35))
            .title(@"切换清晰度", UIControlStateNormal)
            .titleLabelFont([UIFont systemFontOfSize:10])
            .titleColor([UIColor redColor], UIControlStateNormal)
            .backgroundColor([UIColor lightGrayColor])
            .actionBlock(^(UIButton *button) {
                
                [weakself definitionChooseAction];
                
            });
        }];
        
    }
    return _definitionChooseButton;
}


- (UIButton *)changeShortVideoButton {
    
    if (_changeShortVideoButton == nil) {
        
        kWeakSelf(self)
        _changeShortVideoButton = [UIButton ZFC_ButtonChainedCreater:^(ZFC_ButtonChainedCreater *creater) {
            creater.frame(CGRectMake(kScreenWidth - 80, kScreenHeight  - kScreenWidth*9/16  - 44 - 35 - 208, 80, 35))
            .title(@"切换小视频", UIControlStateNormal)
            .titleLabelFont([UIFont systemFontOfSize:10])
            .titleColor([UIColor redColor], UIControlStateNormal)
            .backgroundColor([UIColor lightGrayColor])
            .actionBlock(^(UIButton *button) {
                
                if ([weakself.delegate respondsToSelector:@selector(changeShortVideo)]) {
                    [weakself.delegate changeShortVideo];
                }
                
            });
        }];
        
    }
    return _changeShortVideoButton;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dsema = dispatch_semaphore_create(1);
    }
    return self;
}


- (MWCommentToolBar *)toolbar{
    if(!_toolbar){
        _toolbar = ({
            MWCommentToolBar *view = [[MWCommentToolBar alloc] initWithFrame:CGRectMake(13, kScreenHeight  - kScreenWidth*9/16  - 44 - 40, 200, 34)];
            view.delegate = self;
            view ;
        });
    }
    return _toolbar;
}

- (KKInputView *)inputView{
    if(!_inputView){
        _inputView = ({
            KKInputView *view = [[KKInputView alloc]init];
            view.delegate = self;
            view ;
        });
    }
    return _inputView;
}


- (dispatch_queue_t)fetchDataQueue{
    if(!_fetchDataQueue){
        _fetchDataQueue = dispatch_queue_create("fetchDataQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _fetchDataQueue;
}

- (NSMutableArray *)dataSource {
    
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (NSMutableDictionary *)messageKeyMap{
    if(!_messageKeyMap){
        _messageKeyMap = [NSMutableDictionary new];
    }
    return _messageKeyMap;
}

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = ({
            UITableView *tableView = [UITableView ZFC_TableViewChainedCreater:^(ZFC_TableViewChainedCreater *creater) {
                
                creater.frameAndStyle(CGRectMake(0, 0, kScreenWidth, kScreenHeight  - kScreenWidth*9/16  - 44 - 40 - 10), UITableViewStylePlain)
                .backgroundColor(kcallColor(@"F6F6F6"))
                .separatorStyleAndColor(UITableViewCellSeparatorStyleNone, nil)
                .addIntoView(self.view);
            }];
            
            
            kWeakSelf(self)
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                kStrongSelf(weakself)
                
                MWCommentData *firstData = nil;
                for(MWCommentData *data in strong_weakself.dataSource) {
                    if(!ObjIsEqualNSNull(data.sockData.msg_id)) {
                        
                        if(data.sockData.msg_id.length > 10) {
                            
                            firstData = data;
                            break;
                        }
                    }
                }
                
                if([strong_weakself.delegate respondsToSelector:@selector(getChatRoomHistoryMessage:)]) {
                    
                    [strong_weakself.delegate getChatRoomHistoryMessage:firstData.sockData.msg_id];
                }
                [strong_weakself.tableView.mj_header endRefreshing];
            }];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.automaticallyChangeAlpha = YES;
            header.stateLabel.hidden = YES;
            [tableView setMj_header:header];
            
            tableView;
        });
    }
    return _tableView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kcallColor(@"F6F6F6");
    [self layoutUI];
    
}


- (void)layoutUI {
    
    ZFC_TableViewChainedInvokeConfig *tableViewConfig = [ZFC_TableViewChainedInvokeConfig new];
    tableViewConfig.tableView = self.tableView;
    tableViewConfig.isCellXib = NO;
    tableViewConfig.cellClass = [MWChatMsgCell class];
    tableViewConfig.canDelete = NO;
    
    kWeakSelf(self)
    [self.tableView configure:^(ZFC_TableViewChainedInvokeCreater *creater) {
        
        creater.zfc_tableViewConfigure(tableViewConfig)
        
        .zfc_numberOfSectionsInTableView(^NSInteger(UITableView *tableView){
            return 1;
        })
        .zfc_numberOfRowsInSection(^NSInteger(UITableView *tableView,NSInteger section) {
            return weakself.dataSource.count;
            
        })
        .zfc_heightForRowAtIndexPath(^CGFloat(UITableView *tableView,NSIndexPath *indexPath) {
            MWCommentData *info = [self.dataSource safeObjectAtIndex:indexPath.row];
            return [MWChatMsgCell fetchCellHeightWithInfo:info];
        })
        .zfc_cellForRowAtIndexPath(^(UITableView *tableView,__kindof MWChatMsgCell *cell, NSIndexPath *indexPath) {
            
            MWCommentData *info = [self.dataSource safeObjectAtIndex:indexPath.row];
            
            NSString *key = info.sockData.msg_id;
            if(!key.length){
                key = @"";
            }
            [self.messageKeyMap setObject:[NSNumber numberWithInteger:indexPath.row] forKey:key];
            
            [(MWChatMsgCell *)cell setDelegate:self];
            [(MWChatMsgCell *)cell refreshCellWithInfo:info];
            
        })
        .zfc_didSelectRowAtIndexPath(^(UITableView *tableView,NSIndexPath *indexPath) {
            
    
        });
    }];

    
    [self.view addSubview:self.toolbar];
    
    [self.view addSubview:self.gifButton];
    [self.view addSubview:self.parasButton];
    [self.view addSubview:self.definitionChooseButton];
    [self.view addSubview:self.changeShortVideoButton];
    
}

#pragma mark - 清晰度选择
- (void)definitionChooseAction {
    
    BKDefinitionChooseView *chooseView = [[BKDefinitionChooseView alloc]initWithFrame:[UIScreen mainScreen].bounds buttons:@[@"原画",@"高清",@"标清"] currentChooseIndex:self.isMainPlay ? self.definitionChooseCurrentIndex_mvp : self.definitionChooseCurrentIndex_svp playDirection:PlayDirectionVertical];
    [chooseView setDefinitionButtonActionBlock:^(NSString *definition,NSInteger currentIndex) {
        if ([self.delegate respondsToSelector:@selector(definitionChoose:)]) {
           [self.delegate definitionChoose:currentIndex];
        }
    }];
    [chooseView show:kWindow];
    
}


#pragma mark - KKInputViewDelegate
- (void)sendBtnClicked:(NSString *)inputText {
    
    [self.toolbar setInputText:@""];
    if ([self.delegate respondsToSelector:@selector(sendMsg:)]) {
        [self.delegate sendMsg:inputText];
    }
}

#pragma mark - MWCommentToolBarDelegate
- (void)shouldShowKeyboard {
    [self.inputView showKeyBoard];
}


#pragma mark - MWChatMsgCellDelegate
- (void)tapHeadImageWithInfo:(MWLiveSocketData *)info {
    
    NSLog(@"点击了");
}




#pragma mark - 收到socket消息
- (void)reviceMsgWithSocketData:(MWLiveSocketData *)data {
    if(data.code == MWLiveSocket_obtainChatRecord) {
        
        NSMutableArray *muArray = [NSMutableArray array];
        if([data.data isKindOfClass:[NSDictionary class]]) {
            
            NSArray *historyMessArray = data.data[@"allsms"];
            for(id obj in historyMessArray) {
                if([obj isKindOfClass:[NSDictionary class]]) {
                    MWLiveSocketData  *liveSocket = [MWLiveSocketData mj_objectWithKeyValues:obj];
                    if(liveSocket)  [muArray addObject:liveSocket];
                }
            }
        }
        if(muArray.count == 0) {
            return;
        }
        [self insertHistoryCommentInfoArray:muArray];
        
    }else {
        [self addCommentInfo:data];
    }
    
}


#pragma mark - 插入一条消息
- (void)addCommentInfo:(MWLiveSocketData *)info{
    
    dispatch_async(self.fetchDataQueue, ^{
        
        MWCommentData *data = [[MWCommentData alloc]init];
        data.sockData = info ;//socket的消息体
        data.maxCommemtTextWidth = [MWChatMsgCell fetchCommentTextWidth];
        data.textColor = kRGBAColor(51, 51, 51, 1.0);
        data.textFont = [MWChatMsgCell fetchFont];
        data.lineSpace = [MWChatMsgCell fetchLineSpace];
        
        if(info.code == MWliveSocket_deletSingleChatRecord){
            NSInteger index = [[self.messageKeyMap objectForKey:info.liveinfo.msg_id]integerValue];
            if(index > 0 && index < self.dataSource.count){
                [self.dataSource safeRemoveObjectAtIndex:index];
            }
            
            [self.messageKeyMap removeAllObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            
            [self.dataSource safeAddObject:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scrollToLast];
            });
        }
    });
}


#pragma mark - 下拉加载更多
- (void)insertHistoryCommentInfoArray:(NSArray <MWLiveSocketData *>*)infoArray;{
    
    dispatch_semaphore_wait(self.dsema, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for(NSInteger i = infoArray.count - 1; i >= 0; i--){
            MWLiveSocketData *info = infoArray[i];
            MWCommentData *data = [[MWCommentData alloc]init];
            data.sockData = info ;//socket的消息体
            data.maxCommemtTextWidth = [MWChatMsgCell fetchCommentTextWidth];
            data.textColor = kRGBAColor(51, 51, 51, 1.0);
            data.textFont = [MWChatMsgCell fetchFont];
            data.lineSpace = [MWChatMsgCell fetchLineSpace];
            [self.dataSource insertObject:data atIndex:0];
        }
        [self.tableView reloadData];
    });
    
    dispatch_semaphore_signal(self.dsema);
    
}


- (void)scrollToLast{
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.tableView.contentSize.height < self.tableView.height) return;
        self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.height);
    });
}





@end
