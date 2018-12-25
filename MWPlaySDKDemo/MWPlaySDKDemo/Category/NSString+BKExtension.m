//
//  NSString+BKExtension.m
//  BaiKeLive
//
//  Created by simope on 16/6/13.
//  Copyright © 2016年 simope. All rights reserved.
//

#import "NSString+BKExtension.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSObject+BKExtension.h"


@implementation NSString (BKExtension)

//等级+名字
+ (NSAttributedString *)addAttachmentImage:(NSString *)image Title:(NSString *)title Color:(UIColor *)color{
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[self addAttachmentImageName:image width:12 height:12]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[self setTitleStyle:title color:color]];
    
    return attributedString;
}

+ (NSAttributedString *)addAttachmentImageName:(NSString *)image width:(CGFloat)width height:(CGFloat)height{
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:image];
    attch.bounds = CGRectMake(0.f, 0.f, width, height);
    return [NSAttributedString attributedStringWithAttachment:attch];
}

//普通名字信息合成
+ (NSAttributedString *)setTitleStyle:(NSString *)title color:(UIColor *)color{
    NSString *tempStr = [NSString stringWithFormat:@"%@",title];
    NSAttributedString *AttributedString = [NSObject setTextColorWithStr:tempStr Color:color Range:kRANGE(0, tempStr.length)];
    return AttributedString;
}



- (CGRect)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
}

- (NSString *)floatString10000ToFormat1w {
    
    NSString *num = self;
    
    if ([num doubleValue] == 0) {
        return @"0";
    }
    
    //按数点分割
    NSArray *dNum = [num componentsSeparatedByString:@"."];
    
    //取个位之后的数
    NSString *firObj = dNum.firstObject;
    
    if ([num doubleValue] < 10000 && [num doubleValue] >= 100) {
        return firObj;
        
    } else if ([num doubleValue] >= 10000) {
        //取万位之后的数
        NSString *fir = [firObj substringToIndex:firObj.length - 4];
        
        if (dNum.count > 1) {
            NSString *las = dNum.lastObject;
            
            if ([las isEqualToString:@"00"]) {
                //小数都为0
                num = [NSString stringWithFormat:@"%@w",fir];
                
            } else if ([las isEqualToString:@"0"]) {
                //第一位小数位为零
                num = [NSString stringWithFormat:@"%@w",fir];
                
            } else {
                NSString *las2 = [firObj substringWithRange:NSMakeRange(firObj.length - 4, 1)];
                if (las.length > 1 && [las2 isEqualToString:@"0"]) {
                    num = [NSString stringWithFormat:@"%@w",fir];
                } else {
                    num = [NSString stringWithFormat:@"%@.%@w",fir,las2];
                }
            }
            return num;
            
        } else {
            NSString *decimal = [num substringWithRange:NSMakeRange(num.length - 4, 1)];
            if ([decimal isEqualToString:@"0"]) {
                num = [NSString stringWithFormat:@"%@w",fir];
            } else {
                num = [NSString stringWithFormat:@"%@.%@w",fir,decimal];
            }
        }
        return num;
        
    }else{
        if (num.length > 1) {
            
            if (dNum.count>1) {
                
                NSString *decimal = [num substringWithRange:NSMakeRange(num.length - 1, 1)];
                if ([decimal isEqualToString:@"0"] && [dNum.lastObject length]>1) {
                    decimal = [num substringWithRange:NSMakeRange(0, num.length - 1)];
                    return decimal;
                }
            }
        }
        return num;
    }
}

-(NSString *)stringUpdataShowFormat1w {
    
    if ([self integerValue] > 9999.0) {
        NSMutableString *concerStr = [[NSMutableString alloc] initWithString:self];
        NSString *newStr = [concerStr substringWithRange:NSMakeRange(0, concerStr.length - 3)];
        concerStr = [newStr mutableCopy];
        
        unichar laststr = [newStr characterAtIndex:newStr.length-1];
        NSLog(@"%c",laststr);
        if ([[NSString stringWithFormat:@"%c",laststr] intValue] == 0) {
            newStr  = [concerStr substringWithRange:NSMakeRange(0, concerStr.length -1)];
            concerStr = [newStr mutableCopy];
        }else{
            [concerStr insertString:@"." atIndex:concerStr.length - 1];
        }
        
        [concerStr insertString:@"w" atIndex:concerStr.length];
        return [concerStr copy];
        
    }else{
        return self;
    }
}



/**
 *  判断是否含有表情
 */
+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    if (!string) {
        return NO;
    }
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if ((0x1d000 <= uc && uc <= 0x1f77f) || (0x1F900 <= uc && uc <=0x1f9ff)) { //修改(0x1F900 <= uc && uc <=0x1f9ff)
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }else if (hs == 0x200d){  //增加判断
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}

/**
 *  判定是否为有效的手机号
 */
+ (BOOL)isMobile:(NSString*)mobile{
    
    if (mobile.length != 11)
    {
        return NO;
    }
    
    return YES;//只判断11位
    
    //    NSString *regex = @"^1+[34578]+\\d{9}";
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //    return [pred evaluateWithObject:mobile];
}


- (BOOL)isMobile{
    
    NSString *regex = @"[1][3456789]\\d{9}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextestmobile evaluateWithObject:self] == YES){
        return YES;
    }else{
        return NO;
    }
}

/**
 *  简单判定是否为有效的身份证号
 */
+ (BOOL)simpleVerifyIdentityCardNum:(NSString *)IDCard
{
    NSString *regex = @"^(\\\\d{14}|\\\\d{17})(\\\\d|[xX])$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:IDCard];
}


/**
 *  精确的身份证号有效性检测
 */
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *M2 =@"F";
                NSString *JYM =@"10X98765432";
                NSString *JYM2 =@"10x98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                M2 = [JYM2 substringWithRange:NSMakeRange(Y,1)];
                
                NSString *LM = [value substringWithRange:NSMakeRange(17,1)];
                if ([M isEqualToString:LM] || [LM isEqualToString:M2]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
                /**
                 //计算出校验码所在数组的位置
                 NSInteger idCardMod = S % 11;
                 //得到最后一位身份证号码
                 NSString *idCardLast= [value substringWithRange:NSMakeRange(17, 1)];
                 //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
                 if(idCardMod==2) {
                 if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
                 return NO;
                 }
                 }
                 */
            }else {
                return NO;
            }
        default:
            return NO;
    }
}


- (BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
    
}

/**
 *  @brief 检测字符串中是否含有中文，备注：中文代码范围0x4E00~0x9FA5，
 *  @param string 传入检测到中文字符串
 *  @return 是否含有中文，YES：有中文；NO：没有中文
 */
- (BOOL)checkIsChinese{
    for (int i=0; i<self.length; i++) {
        unichar ch = [self characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isNullOrNilEmpty:(NSString *)string {
    
    if (!string) {
        return YES;
    }
    
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([string isEmpty]) {
        return YES;
    }
    
    if ([string containsString:@"null"] && string) {
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isEmpty {
    if(!self) {
        return true;
    }else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        if([trimedString length] == 0) {
            return true;
        }else {
            return false;
        }
    }
}

#pragma mark - 散列函数
- (NSString *)md5String {
    const char *str = self.UTF8String;
    unsigned char buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}


- (NSString *)getMd5_32Bit_String {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}


- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    
    return [strM copy];
}

#pragma mark  -NGB模式rtmpurl
+ (NSString *)ngbModelWithRtmpUrl:(NSString *)rtmpurl IP:(NSString *)ip{
    
    NSString *statFlag = @"rtmp://";
    NSRange statRange = [rtmpurl rangeOfString:statFlag];
    NSString *newString = [rtmpurl substringWithRange:kRANGE(statRange.length, rtmpurl.length - statRange.length)];
    NSArray  *strArr = [newString componentsSeparatedByString:@"/"];
    NSString *domain = [strArr objectAtIndex:0];
    NSString *ipStr = [newString stringByReplacingOccurrencesOfString:domain withString:ip];
    NSString *ngbUrl = [NSString stringWithFormat:@"%@%@&wsiphost=ipdb&wsHost=%@",statFlag,ipStr,domain];
    return ngbUrl;
}

+ (NSString *)ngbModelWithHttpUrl:(NSString *)httpurl IP:(NSString *)ip{
    NSString *statFlag = @"http://";
    NSRange statRange = [httpurl rangeOfString:statFlag];
    NSString *newString = [httpurl substringWithRange:kRANGE(statRange.length, httpurl.length - statRange.length)];
    NSArray  *strArr = [newString componentsSeparatedByString:@"/"];
    NSString *domain = [strArr objectAtIndex:0];
    NSString *ipStr = [newString stringByReplacingOccurrencesOfString:domain withString:ip];
    NSString *ngbUrl = [NSString stringWithFormat:@"%@%@&wsiphost=ipdb&wsHost=%@",statFlag,ipStr,domain];
    return ngbUrl;
}

/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    // 获取该段attributedString的属性字典
    NSDictionary *dic =  @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}


/**
 将字符串转成带*的手机号号格式
 */
- (NSString *)stringToPhoneNumberEncryptFormat {
    NSRange rang = NSMakeRange(3, 4);
    if (self.length > rang.location + rang.length) {
        return [self stringByReplacingCharactersInRange:rang withString:@"****"];
    }
    return self;
}

- (NSString *)convert {
    NSNumber *compareNumber0 = @(1);
    NSNumber *compareNumber1 = @(10000);
    NSNumber *compareNumber2 = @(100000);
    NSNumber *compareNumber3 = @(1000000);
    NSDecimalNumber *compareDNumber0 = [NSDecimalNumber decimalNumberWithString:compareNumber0.description];
    NSDecimalNumber *compareDNumber1 = [NSDecimalNumber decimalNumberWithString:compareNumber1.description];
    
    
    NSDecimalNumberHandler *roundingBehavior1 = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                       scale:1
                                                                                            raiseOnExactness:NO
                                                                                             raiseOnOverflow:NO
                                                                                            raiseOnUnderflow:NO
                                                                                         raiseOnDivideByZero:NO];
    NSDecimalNumberHandler *roundingBehavior2 = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                       scale:1
                                                                                            raiseOnExactness:NO
                                                                                             raiseOnOverflow:NO
                                                                                            raiseOnUnderflow:NO
                                                                                         raiseOnDivideByZero:NO];
    NSDecimalNumberHandler *roundingBehavior3 = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                       scale:0
                                                                                            raiseOnExactness:NO
                                                                                             raiseOnOverflow:NO
                                                                                            raiseOnUnderflow:NO
                                                                                         raiseOnDivideByZero:NO];
    
    NSDecimalNumber *originNumber = [NSDecimalNumber decimalNumberWithString:self.description];
    NSComparisonResult result1 = [originNumber compare:compareNumber1];
    
    NSDecimalNumber *decimalNumber = nil;
    if (result1 == NSOrderedAscending || result1 == NSOrderedSame) {
        decimalNumber = [originNumber decimalNumberByDividingBy:compareDNumber0 withBehavior:roundingBehavior1];
        return decimalNumber.stringValue;
    } else {
        NSComparisonResult result2 = [originNumber compare:compareNumber2];
        if (result2 == NSOrderedAscending || result2 == NSOrderedSame) {
            decimalNumber = [originNumber decimalNumberByDividingBy:compareDNumber1 withBehavior:roundingBehavior1];
        } else {
            NSComparisonResult result3 = [originNumber compare:compareNumber3];
            if (result3 == NSOrderedAscending || result3 == NSOrderedSame) {
                decimalNumber = [originNumber decimalNumberByDividingBy:compareDNumber1 withBehavior:roundingBehavior2];
            } else {
                decimalNumber = [originNumber decimalNumberByDividingBy:compareDNumber1 withBehavior:roundingBehavior3];
            }
        }
        return [NSString stringWithFormat:@"%@万", decimalNumber.stringValue];
    }
}


- (NSString *)URLEncodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                 NULL,
                                                                                 kCFStringEncodingUTF8));
}

@end
