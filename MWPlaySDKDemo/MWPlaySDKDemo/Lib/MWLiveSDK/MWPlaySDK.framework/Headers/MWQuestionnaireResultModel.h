//
//  MWQuestionnaireResultModel.h
//  MWPlaySDK
//
//  Created by mac on 2018/12/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWQuestionnaireResultModel : NSObject

/** 问题内容 */
@property (nonatomic,copy)  NSString *question;

/** key:答案 value:人数 */
@property (nonatomic,copy)  NSDictionary *countSelect;

@end


