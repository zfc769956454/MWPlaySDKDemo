//
//  NSDate+BKExtension.h
//  BaiKeMiJiaLive
//
//  Created by simope on 16/7/19.
//  Copyright © 2016年 facebac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BKExtension)

UIKIT_EXTERN NSString *const BKDateFormat_YYYY_MM_dd;
UIKIT_EXTERN NSString *const BKDateFormat_YYYY_MM_dd_HH;
UIKIT_EXTERN NSString *const BKDateFormat_YYYY_MM_dd_HH_mm;
UIKIT_EXTERN NSString *const BKDateFormat_YYYY_MM_dd_HH_mm_ss;


+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)startTimeWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)timeWithTimeIntervalMinuteAndSecond:(NSTimeInterval)timeInterval;

+ (NSString *)judgeTimerWithHourMinuteAndSecond:(NSTimeInterval)timeInterval;

//判定当前的时间段
+ (NSString *)compareDate:(NSDate *)date;

+ (NSString *)convertStrToTime:(long long)time;

+ (NSString *)convertStrToTime:(long long)time dateFormat:(NSString *)dateFormat;

+ (NSString *)format:(NSString *)string;

+ (NSString *)dateFormat:(NSString *)string; //2017-09-26T07:37:29.000Z 时间格式转换  UTC

/**
 *  把当前时间转换成20161110104101
 *
 *  @param data 传入要转换的date，不传默认为当前时间
 */
+ (NSString *)getCurrentDateBaseStyleWithData:(NSData *)data;


/**
 

 @param timeInterval
 @param format
 */


/**
 timeInterval转换成年\月\日格式字符串

 @param timeInterval 时间戳
 @param bkDateFormat BKDateFormat_...
 @param format 分隔的格式符：nil: 年月日  @"\" 年\月\日  @"-" 年-月-日  @"." 年.月.日
 */
+ (NSString *)timeIntervalConvertYearMonthDayStyleString:(NSString *)timeInterval bkDateFormat:(NSString *const)bkDateFormat format:(NSString *)format;


/**
 *  时间戳转换成具体时间
 *
 *  @param timeInterval 需要转换的时间戳
 *
 *  @return 返回格式:2016-09-28 09:20:35
 */
+ (NSString *)timeIntervalConvertDetailDateTimeWith:(NSTimeInterval)timeInterval;


/**
 *  传入格式：2016-09-28 09:20:35 计算两时间间隔时间
 *
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 *
 *  @return 消耗总用时
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;


/**
 *  从某个时间戳到现在的时间间隔
 *
 *  @param starTimeInterval 开始时间戳
 *
 *  @return 消耗总用时
 */
+ (NSString *)dateTimeDifferenceEverSinceWithStarTimeInterval:(NSTimeInterval)starTimeInterval;


/**
 *  计算两时间戳的时间间隔
 *
 *  @param starTimeInterval 开始时间戳
 *  @param endTimeInterval  结束时间戳
 *  @return 消耗总用时
 */
+ (NSString *)dateTimeDifferenceWithStarTimeInterval:(NSTimeInterval)starTimeInterval endTimeInterval:(NSTimeInterval)endTimeInterval;


/**
 *  获取当前日期、时间，格式: YYYY-MM-dd hh:mm:ss
 *
 *  @return 返回时间字符串
 */
+ (NSString *)getCurrentDateStr;

/**
 *  获取当前日期、时间，格式: YYYY-MM-dd hh:mm:ss
 *
 *  @return 返回时间字符串
 */
+ (NSString *)getCurrentDateStrWithFormat:(NSString *)format;

+ (NSString *)getDateStrWithDate:(NSDate *)date;

+ (NSString *)getDateStrWithDateWithoutSeconds:(NSDate *)date;

+ (NSString *)getDateStrWithDateWithoutSeconds:(NSDate *)date format:(NSString *)format;

///根据YYYY-MM-dd hh:mm:ss格式字符串 返回date
+ (NSDate *)getDateWithDateString:(NSString *)dateString;

+ (NSDate *)getDateWithDateStringWithNoSec:(NSString *)dateString;

//*************************************************************************************
//                           以下是2017.09.07整理后的方法
//*************************************************************************************

/** 当前时间转换成时间戳不计算毫秒 */
+ (NSString*)getCurrentTimestamp;

/** 将NSDate转换为时间戳,从1970/1/1开始, 传nil默认为当前时间*/
+ (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime;

/** 带毫秒时间戳转换成NSDate */
+ (NSDate *)getMilliDateTimeFromMilliSeconds:(long long) miliSeconds;

/**
 *  时间格式转换 Format:@"yyyy-MM-dd HH:mm:ss"
 */
+ (NSTimeInterval)timeFormatterWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;


/**
 *  与当前时间做比较
 */
+ (NSInteger)compareCurrentTime:(NSString *)dateStr;
@end
