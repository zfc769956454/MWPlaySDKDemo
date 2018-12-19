//
//  MWQuestionnaireAnswerModel.h
//  MWPlaySDK
//
//  Created by mac on 2018/12/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//回答问卷的模型(单选、多选)

@interface MWQuestionnaireAnswerModel : NSObject

/** 问题ID */
@property (nonatomic,copy) NSString *topicId;
/** 题号*/
@property (nonatomic,copy) NSString *number;
/** 问题内容 */
@property (nonatomic,copy) NSString *question;
/**  当前题目所有选项内容数组，便于统计问卷时使用 */
@property (nonatomic,copy) NSArray <NSString *> *optionSort;


//单选所用字段
/** 用户选中的选项内容   selectContent字段针对于单选（single)题型    */
@property (nonatomic,copy) NSString *selectContent;
/** 用户选中的选项ID  selectId字段针对于单选（single）题型   */
@property (nonatomic,copy) NSString *selectId;


//多选选所用字段
/** 用户选中的选项内容数组   selectMultipleContent字段针对于多选（multiple)题型    */
@property (nonatomic,copy) NSArray <NSString *>*selectMultipleContent;
/** 用户选中的选项ID数组  selectMultipleId字段针对于多选（multiple）题型   */
@property (nonatomic,copy) NSArray <NSString *>*selectMultipleId;

@end


