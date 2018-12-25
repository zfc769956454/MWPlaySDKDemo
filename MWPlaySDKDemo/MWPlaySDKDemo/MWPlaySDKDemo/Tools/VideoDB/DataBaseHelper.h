//
//  DateBaseHelper.h
//  SouthChina
//
//  Created by creator_lq on 14/12/3.
//  Copyright (c) 2014年 科创. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"数据库检测失败：Failure on line %d", __LINE__); } }


@interface DataBaseHelper : NSObject

+(FMDatabase*)openDateBase;

@end
