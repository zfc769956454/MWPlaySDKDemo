//
//  MWDLNADeviceShowAlertView.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/12/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWDLNADeviceShowAlertView.h"


#define kWindow     [UIApplication sharedApplication].delegate.window
#define CellHeight 50

@interface MWDLNADeviceShowAlertView() <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *dlnaTableView;

@property (nonatomic,strong) NSMutableArray *deviceDataSource;


@end

@implementation MWDLNADeviceShowAlertView


- (NSMutableArray *)deviceDataSource {
    
    if (_deviceDataSource ==  nil) {
        
        _deviceDataSource = [NSMutableArray array];
    }
    return _deviceDataSource;
    
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        [kNotificationCenter addObserver:self selector:@selector(deviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        
        [self configTableView];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.dlnaTableView.center = self.center;
    
}


- (void)configTableView {
    
    ZFC_TableViewChainedInvokeConfig *tableViewConfig = [ZFC_TableViewChainedInvokeConfig new];
    tableViewConfig.tableView = self.dlnaTableView;
    tableViewConfig.isCellXib = NO;
    tableViewConfig.cellClass = [UITableViewCell class];
    tableViewConfig.canDelete = NO;
    
    
    __weak typeof(self)weakSelf = self;
    [self.dlnaTableView configure:^(ZFC_TableViewChainedInvokeCreater *creater) {
        
        creater.zfc_tableViewConfigure(tableViewConfig)
        
        .zfc_numberOfSectionsInTableView(^NSInteger(UITableView *tableView){
            return 1;
        })
        .zfc_numberOfRowsInSection(^NSInteger(UITableView *tableView,NSInteger section) {
            return weakSelf.deviceDataSource.count;
            
        })
        .zfc_heightForRowAtIndexPath(^CGFloat(UITableView *tableView,NSIndexPath *indexPath) {
            
            return CellHeight;
        })
        .zfc_cellForRowAtIndexPath(^(UITableView *tableView,__kindof UITableViewCell *cell, NSIndexPath *indexPath) {
            
            CLUPnPDevice *device = weakSelf.deviceDataSource[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = device.friendlyName;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        })
        .zfc_didSelectRowAtIndexPath(^(UITableView *tableView,NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            CLUPnPDevice *device = weakSelf.deviceDataSource[indexPath.row];
            if ([weakSelf.delegate respondsToSelector:@selector(DLNAStartPlay:)]) {
                [weakSelf.delegate DLNAStartPlay:device];
            }
            
        });
    }];
    
}



- (void)deviceOrientationChange {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.center = kWindow.center;
    self.dlnaTableView.center = self.center;
}


//显示
- (void)showWithDevices:(NSArray *)array;{
    

    [kWindow addSubview:self];
    self.dlnaTableView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.dlnaTableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    
    self.dlnaTableView.mj_h = MIN(300, array.count * CellHeight + 45);
    self.deviceDataSource = [NSMutableArray arrayWithArray:array];
    [self.dlnaTableView reloadData];
    
}

//移除
- (void)removeSelf {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.dlnaTableView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}



- (UITableView *)dlnaTableView {
    
    if (_dlnaTableView == nil) {
        
        _dlnaTableView = ({
            UITableView *tableView = [UITableView ZFC_TableViewChainedCreater:^(ZFC_TableViewChainedCreater *creater) {
                
                creater.frameAndStyle(CGRectMake(0, 0, kScreenWidth - 20, 95), UITableViewStylePlain)
                .backgroundColor([UIColor clearColor])
                .separatorStyleAndColor(UITableViewCellSeparatorStyleSingleLine, [UIColor lightGrayColor])
                .addIntoView(self);
                
            }];
            
            tableView.layer.cornerRadius = 5;
            tableView.clipsToBounds = YES;
            
            UIView *headerView = [UIView ZFC_ViewChainedCreater:^(ZFC_ViewChainedCreater *creater) {
                creater.frame((CGRectMake(0, 0, kScreenWidth - 20, 45)))
                .backgroundColor([UIColor whiteColor]);
            }];
            
            [UILabel ZFC_LabelChainedCreater:^(ZFC_LabelChainedCreater *creater) {
                
                creater.font([UIFont systemFontOfSize:17])
                .backgroundColor([UIColor whiteColor])
                .frame(CGRectMake(0, 0, CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame) - 0.5))
                .textAlignment(NSTextAlignmentCenter)
                .text(@"搜索到的设备")
                .textColor([UIColor colorWithHexString:@"#333333"])
                .addIntoView(headerView);
                
            }];
            
            [UIView ZFC_ViewChainedCreater:^(ZFC_ViewChainedCreater *creater) {
                creater.backgroundColor([UIColor colorWithHexString:@"#999999"])
                .frame(CGRectMake(0, CGRectGetHeight(headerView.frame), CGRectGetWidth(headerView.frame), 0.5))
                .addIntoView(headerView);
            }];
            
            tableView.tableHeaderView = headerView;
        
            tableView;
        });
    }
    
    return _dlnaTableView;
}

@end
