//
//  MWHomeListCell.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWLiveListModel.h"
#import "MWVideoListModel.h"


@interface MWHomeListCell : UITableViewCell


@property (nonatomic,strong)MWLiveListModel *liveListModel;


@property (nonatomic,strong)MWVideoListModel *videoListModel;

@end


