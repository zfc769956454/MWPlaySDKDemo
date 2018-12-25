//
//  NSString+BKExtension.h
//  BaiKeLive
//
//  Created by simope on 16/6/13.
//  Copyright © 2016年 simope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BKExtension)

//等级+名字
+ (NSAttributedString *)addAttachmentImage:(NSString *)image Title:(NSString *)title Color:(UIColor *)color;

+ (NSAttributedString *)addAttachmentImageName:(NSString *)image width:(CGFloat)width height:(CGFloat)height;
//普通名字信息合成
+ (NSAttributedString *)setTitleStyle:(NSString *)title color:(UIColor *)color;


/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGRect)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


/**
 将字符转成 1.8w 的显示格式
 */
- (NSString *)stringUpdataShowFormat1w;


/**
 将字符转成 1.8w 的显示格式,主要用于带小数的，并且在超过10000时，小数只显示一位
 */
- (NSString *)floatString10000ToFormat1w;


/**
 *  判断是否含有表情
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;


/**
 *  判定是否为有效的手机号
 */
+ (BOOL)isMobile:(NSString*)mobile;
- (BOOL)isMobile;

/**
 *  简单判定是否为有效的身份证号
 */
+ (BOOL)simpleVerifyIdentityCardNum:(NSString *)IDCard;

/**
 *  精确的身份证号有效性检测
 */
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;


/**
 * 判定邮箱的正确性
 */
- (BOOL)validateEmail;

/**
 *  @brief 检测字符串中是否含有中文，备注：中文代码范围0x4E00~0x9FA5，
 *  @param string 传入检测到中文字符串
 *  @return 是否含有中文，YES：有中文；NO：没有中文
 */
- (BOOL)checkIsChinese;


/**
 判定字符中是不为null或者nil或者空
 */
+ (BOOL)isNullOrNilEmpty:(NSString *)string;

/**
 是否全部为空格
 */
- (BOOL)isEmpty;

/**
 md5加密 16位
 */
- (NSString *)md5String;

/**
 md5加密 32位
 */
- (NSString *)getMd5_32Bit_String;

/**
 *  将rtmp地址  转化为ngb模式IP地址
 */
+ (NSString *)ngbModelWithRtmpUrl:(NSString *)rtmpurl IP:(NSString *)ip;

/**
 *  将http地址  转化为ngb模式IP地址
 */
+ (NSString *)ngbModelWithHttpUrl:(NSString *)httpurl IP:(NSString *)ip;
/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

/**
 将字符串转成带*的手机号号格式
 */
- (NSString *)stringToPhoneNumberEncryptFormat;

/**
 10000转换成1万
 */
- (NSString *)convert;


/**
 将带有中文的url转义，会自动判定原文是否包含特殊字符
 */
- (NSString *)URLEncodedString;

@end
