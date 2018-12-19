//
//  MWQuestionnaireReveiveModel.h
//  MWPlaySDK
//
//  Created by mac on 2018/12/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MWQuestionnaireReceiveQuestionModel;
//问卷外层问卷对象model
@interface MWQuestionnaireReveiveModel : NSObject

/** 问卷id */
@property (nonatomic,copy) NSString *questionnaireId;
/** 该问卷创建时间 */
@property (nonatomic,copy) NSString *date;
/** 该问卷所属房间号 */
@property (nonatomic,copy) NSString *roomId;
/** 该问卷是否有效 */
@property (nonatomic,copy) NSString *status;
/** 问卷名 */
@property (nonatomic,copy) NSString *title;
/** 问卷题型  single-单选  multiple-多选 */
@property (nonatomic,copy) NSString *type;
/** 题目对象数组 */
@property (nonatomic,copy) NSArray <MWQuestionnaireReceiveQuestionModel *>*topic;

@end


@class MWQuestionnaireReceivePQAnswerModel;

//每个问题model
@interface MWQuestionnaireReceiveQuestionModel : NSObject
/** 问题ID */
@property (nonatomic,copy)   NSString *questionId;
/** 是否必填 */
@property (nonatomic,assign) BOOL must;
/** 题号 */
@property (nonatomic,copy)   NSString *number;
/** 当前问题 */
@property (nonatomic,copy)   NSString *question;
/** 选项对象数组 */
@property (nonatomic,copy)   NSArray <MWQuestionnaireReceivePQAnswerModel *>*options;


@end


//每个问题答案model
@interface MWQuestionnaireReceivePQAnswerModel : NSObject

/** 选项ID */
@property (nonatomic,copy)   NSString *optionId;
/** 选项名 */
@property (nonatomic,copy)   NSString *name;
/** 选项内容 */
@property (nonatomic,copy)   NSString *content;
/** 是否可以用户选择后添加文字说明 */
@property (nonatomic,assign) BOOL allowAddReasonStatus;


@end
