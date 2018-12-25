//
//  BKMacroDefineHeader.h
//  BaiKeMiJiaLive
//
//  Created by simope on 16/7/19.
//  Copyright © 2016年 facebac. All rights reserved.
//

/**************************************************************
 *  用于存放工程中常用到的代码：代码宏定义等等
 **************************************************************/

#ifndef BKMacroDefineHeader_h
#define BKMacroDefineHeader_h
//#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000)
//#endif


/*****************************获取通知中心******************************/
#define BKAppendingPathComponent(path,subPath) [NSString stringWithFormat:@"%@/%@",(path),(subPath)];

#define kNotificationCenter   [NSNotificationCenter defaultCenter]
#define kBundleDictionary     [[NSBundle mainBundle] infoDictionary]
//通过xib名称加载cell
#define kLoadNibWithNamed(name) [[NSBundle mainBundle] loadNibNamed:(name) owner:self options:nil].firstObject
//获取main stroyboard
#define kLoadMainStroyboard     [UIStoryboard storyboardWithName:@"Main" bundle:nil]
//通过xib名称加载controller
#define kLoadMainStroyboardWithNibName(name) [kLoadMainStroyboard instantiateViewControllerWithIdentifier:(name)]

#define initCell_h              + (instancetype)loadCellWithTableView:(UITableView *)tableView
#define initCell_m              + (instancetype)loadCellWithTableView:(UITableView *)tableView{\
NSString *className = NSStringFromClass([self class]);\
Class someClass = NSClassFromString(className);\
NSString *identifier = className;\
id obj = [tableView dequeueReusableCellWithIdentifier:identifier];\
\
if (!obj) {\
    obj = [[someClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];\
}\
return obj;\
}

#define LoadViewFromNib         + (instancetype)loadViewFromNib
// app版本
#define kAapp_Version         [kBundleDictionary objectForKey:@"CFBundleShortVersionString"]
// app build版本
#define kApp_build_version    [kBundleDictionary objectForKey:@"CFBundleVersion"]

#define kDefaultLiveCloudTitle NSLocalizedString(@"liveTitlePlaceholder","")

/** CString转换成OC字符串 */
#define kCStringToOcString(cstr) [NSString stringWithCString:[(cstr) UTF8String] ? [(cstr) UTF8String] : @""  encoding:NSUTF8StringEncoding]
/*****************************设置随机颜色******************************/
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

/**
 automaticallyAdjustsScrollViewInsets
 */
NS_INLINE void kAdjustsScrollViewInsetNever(UIViewController *viewController,__kindof UIScrollView *tableView) {
#if __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        viewController.automaticallyAdjustsScrollViewInsets = false;
    }
#else
    viewController.automaticallyAdjustsScrollViewInsets = false;
#endif
}

/*****************************设置RGB颜色/设置RGBA颜色******************************/
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a]
#define kBlackColor      [UIColor blackColor]
#define kDarkGrayColor   [UIColor darkGrayColor]
#define kLightGrayColor  [UIColor lightGrayColor]
#define kWhiteColor      [UIColor whiteColor]
#define kGrayColor       [UIColor grayColor]
#define kRedColor        [UIColor redColor]
#define kGreenColor      [UIColor greenColor]
#define kBlueColor       [UIColor blueColor]
#define kCyanColor       [UIColor cyanColor]
#define kYellowColor     [UIColor yellowColor]
#define kMagentaColor    [UIColor magentaColor]
#define kOrangeColor     [UIColor orangeColor]
#define kPurpleColor     [UIColor purpleColor]
#define kBrownColor      [UIColor brownColor]
#define kClearColor      [UIColor clearColor]
#define kThemeColorStr   @"2b94ff"
#define kSEXColor        @"fdd000"

#define kLoginTextColor  @"#999999"
#define kLoginSplitLine  @"#eaeaea"

#define kBasicAppColor   @"2b94ff"
#define kCreateLiveBgColor   @"f2f2f2"

/*****************************定义字体******************************/
#define kFont(fontSize)      [UIFont systemFontOfSize:(fontSize)]
#define kRANGE(loc,len)      NSMakeRange(loc,len)
#define kFontHelveticaBold   @"Helvetica-Bold" //粗体

//app的主题字体
#define kAppDefaultFont(size)   [UIFont systemFontOfSize:(size)];


//#define kFontPingFangSC  @"PingFangSC-Light"
//#define kFontPingFangSCRegular  @"PingFangSC-Regular"
//#define kFontPingFangSCMedium  @"PingFangSC-Medium"

//PingFangSC系列字体在iOS9后才有。所以需要判断，如果是iOS9之前的系统就使用系统字体
#define kLightFontIsB4IOS9(fontSize) ((IOS_VERSION_9_OR_LATER) ? ([UIFont fontWithName:@"PingFangSC-Light" size:(fontSize)]):([UIFont systemFontOfSize:(fontSize)]))
#define kRegularFontIsB4IOS9(fontSize) ((IOS_VERSION_9_OR_LATER) ? ([UIFont fontWithName:@"PingFangSC-Regular" size:(fontSize)]):([UIFont systemFontOfSize:(fontSize)]))
#define kMediumFontIsB4IOS9(fontSize) ((IOS_VERSION_9_OR_LATER) ? ([UIFont fontWithName:@"PingFangSC-Medium" size:(fontSize)]):([UIFont boldSystemFontOfSize:(fontSize)]))

#define kLocalNotiInfo @"localNotiInfo"
#define kLocalNotiUserID @"localNotiUserID"
#define kLocalNotiLiveID @"localNotiLiveID"
#define kLocalUserPasswordKey @"kLocalUserPasswordKey"//用户密码
//本地化字符串
#define kNSLocalizedString(key,comment) NSLocalizedString((@#key),(@#comment))

///*****************************自定义的 NSLog******************************/
#ifdef DEBUG
#define kNSLog(fmt, ...) NSLog((@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
#define kNSLog(...)
//#define kNSLog(fmt, ...) NSLog((@"%s -- " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#endif

/*****************************不需要打印时间戳等信息，使用如下宏定义******************************/
#ifdef DEBUG
#define kCNSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define kCNSLog(...)
//#define kCNSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#endif


/*****************************打印日志,当前行 并弹出一个警告******************************/
#ifdef DEBUG
#   define kALERTLog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define kALERTLog(...)
#endif

#ifndef __OPTIMIZE__
#define OPEN_MEMORY_WARNING_TEST YES //打开内存警告测试开关
#endif
#define SimulateMemoryWarning  [[UIApplication sharedApplication] performSelector:@selector(_performMemoryWarning)];

/*****************************弱引用/强引用******************************/
#define kWeakSelf(type)   __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) strong_##type = type;

//主要用于字典，某个值为空时，防止崩溃
#define kStringToString(str) [NSString stringWithFormat:@"%@",(str)] ? [NSString stringWithFormat:@"%@",(str)] : @""
#define kStringToString2(str) [[NSString stringWithFormat:@"%@",(str)] isEqual:[NSNull null]] ? @"" : (str)


#define kBasicDataToBasicData
//判定服务返回的某个值是否为 "<null>"
#define ObjIsEqualNSNull(obj)                [(obj) isEqual:[NSNull null]]
#define ObjIsOfKindClass(obj)                [(obj) isKindOfClass:[NSNull class]]
#define If_ObjIsEqualNSNull_ThenReturn(obj)  if (ObjIsEqualNSNull(obj)) return;
#define kStrignToUTF8String(obj)             [(obj) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//等于nil或者空
#define ObjIsEqualNil(obj)                   ([(obj) isEqualToString:@""] || ((obj) == nil))
#define ObjIsEqualNullOrNil(obj)             (ObjIsOfKindClass(obj) || [(obj) isEqualToString:@""] || ((obj) == nil))

//用于客户端的返回值为<null> 或者 "nil" 返回nil
#define VerifyValue(value)\
({id tmp;\
if ([value isKindOfClass:[NSNull class]])\
tmp = nil;\
else\
tmp = value;\
tmp;\
})


/*****************************设置 view 圆角和边框******************************/
#define kViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


/*****************************由角度转换弧度 由弧度转换角度******************************/
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)
#define ARC4RANDOM_MAX      0x100000000 

/*****************************获取view的frame/图片资源******************************/
#define kInterfaceOrientation  [[UIApplication sharedApplication] statusBarOrientation]
#define kStatusBarHeight  [[UIApplication sharedApplication] statusBarFrame].size.height
#define kScale            [UIScreen mainScreen].scale
#define kScreenBounds     [UIScreen mainScreen].bounds
#define kScreenSize           [[UIScreen mainScreen] bounds].size
#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kWindow           [UIApplication sharedApplication].delegate.window
#define kRANGE(loc,len)   NSMakeRange(loc,len)
/** iphone x*/
#define kiPhone_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kTabbarHeight    ((kiPhone_X) ? 83 : 49)
#define kNavgationYOffect   64
#define kBarItemYOffect     35
#define kNavgationSubHeight 0
#define kNabBarHeight       44
#define kNavgationHeight    (kStatusBarHeight +  kNabBarHeight)
#define kScreenScale      ([UIScreen mainScreen].bounds.size.width/375)
////中间按钮超出TabBar的距离，根据实际情况来定
#define kTabBarCenterButtonDelta 0.f

#define k375             (kScreenWidth / 375)
#define kScale4_7inch       (k375 <= 1.0 ? (1.0) : k375) //比例


//水平、垂直等比例间隙计算
#define kLevelScaleSpace(referenceValue,spaceValue)     ((spaceValue / referenceValue) * (kScreenWidth))
#define kVerticalScaleSpace(referenceValue,spaceValue)  ((spaceValue / referenceValue) * (kScreenHeight))


//获取view的frame
#define kGetViewWidth(view)  view.frame.size.width
#define kGetViewHeight(view) view.frame.size.height
#define kGetViewX(view)      view.frame.origin.x
#define kGetViewY(view)      view.frame.origin.y
//获取图片资源
#define kGetImage(imageName) [UIImage imageNamed:imageName]
#define kGetDataWithUrl(url) [NSData dataWithContentsOfURL:(url)]
#define kGetInteger(integer) [NSString stringWithFormat:@"%ld",integer]
#define kGetIntValue(intValue) [NSString stringWithFormat:@"%d",intValue]
#define kGetNumber(number)   [NSString stringWithFormat:@"%@",number]
#define kGetString(string)   [NSString stringWithFormat:@"%@",string]

#define kGetUrlWithString(str) [NSURL URLWithString:(str)]

/*****************************获取当前语言******************************/
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define kVersionInfo        [[BKLiveVersionInfo shareVersion] currentVersionInfo]
//当前用户自定义名称
#define kCurrentDeviceName  [[UIDevice currentDevice] name]


/*****************************判断当前的iPhone设备/系统版本******************************/
//判断是否为iPhone
#define IS_IPHONE [[UIDevice currentDevice].model isEqualToString:@"iPhone"]
//判断是否为iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPAD ([[UIDevice currentDevice].model isEqualToString:@"iPad"] || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

// 判断是否为 iPhone 4S
#define iPhone4S ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 480.0f) || ([[UIScreen mainScreen] bounds].size.height == 320.0f && [[UIScreen mainScreen] bounds].size.width == 480.0f)

// 判断是否为 iPhone 5SE
#define iPhone5SE ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f) || ([[UIScreen mainScreen] bounds].size.height == 320.0f && [[UIScreen mainScreen] bounds].size.width == 568.0f)

// 判断是否为iPhone 6/6s
#define iPhone6_6s ([[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f) || ([[UIScreen mainScreen] bounds].size.height == 375.0f && [[UIScreen mainScreen] bounds].size.width == 667.0f)

// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus ([[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f) || ([[UIScreen mainScreen] bounds].size.height == 414.0f && [[UIScreen mainScreen] bounds].size.width == 736.0f)



//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))

#define IOS_VERSION_9_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)? (YES):(NO))
#define IOS_VERSION_9_OR_BEORE (([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)? (YES):(NO))

//判断 iOS 8 更低的系统版本
#define IOS_VERSION_8_OR_BEFORE (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)? (YES):(NO))
//判断 iOS 10 或更高的系统版本
#define IOS_VERSION_10_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)? (YES):(NO))
//判断 iOS 11 或更高的系统版本
#define IOS_VERSION_11_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)? (YES):(NO))


#define KKAdjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

//iOS11相关
#define kTabBarBottomOffset (kiPhone_X == YES ? 34.0 : 0.0)
#define kNavBarTopOffset (kiPhone_X == YES ? 44.0 : 0.0)
#define kStatusTopOffset (kiPhone_X == YES ? 24.0 : 0.0)
#define kScrollViewTopOnIOS_11 ((IOS_VERSION_11_OR_LATER) ? kNavgationHeight : 0.0)
#define kLandscapeBottomOffset (kiPhone_X == YES ? 21.0 : 0.0)
#define kIphoneXFullScreenLeftOffset (kiPhone_X == YES ? 72.5 : 0.0)


//#define kLandscapeOffset (kiPhone_X == 812 ? 24.f : 0.0)

/**
 用于scrollView及子视图的起始的y坐标值
 解决在11系统上自动依稀问题；
 */
NS_INLINE CGFloat kScrollConstOffsetY() {
#if  __IPHONE_11_0
    if (IOS_VERSION_11_OR_LATER) {
        if (kiPhone_X) {
            return 84.f;
        }
        return 64.f;
    }
    return 0;
#endif
    return 0;
}



#pragma mark --关联方法宏定义

//对象类型
#define SYNTHESIZE_CATEGORY_OBJ_PROPERTY(propertyGetter, propertySetter)\
- (id) propertyGetter {\
return objc_getAssociatedObject(self, @selector( propertyGetter ));\
}\
- (void) propertySetter (id)obj{\
objc_setAssociatedObject(self, @selector( propertyGetter ), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

//基本类型
#define SYNTHESIZE_CATEGORY_VALUE_PROPERTY(valueType, propertyGetter, propertySetter)\
- (valueType) propertyGetter {\
valueType ret = {0};\
[objc_getAssociatedObject(self, @selector( propertyGetter )) getValue:&ret];\
return ret;\
}\
- (void) propertySetter (valueType)value{\
NSValue *valueObj = [NSValue valueWithBytes:&value objCType:@encode(valueType)];\
objc_setAssociatedObject(self, @selector( propertyGetter ), valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

/*****************************沙盒目录文件******************************/
//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Library
#define kPathLibrary  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
//本地缓存
#define kLocalUserinfo               [NSUserDefaults standardUserDefaults]
#define kLocalSynchronize            [[NSUserDefaults standardUserDefaults] synchronize]
#define kGetLocalUserinfo(key)       [[NSUserDefaults standardUserDefaults] objectForKey:(key)]
#define kSetLocalUserinfos(obj,key)\
do {\
id obj_id = obj;\
if (![obj_id isKindOfClass:[NSNull class]]){\
[[NSUserDefaults standardUserDefaults] setObject:(obj_id) forKey:(key)];\
}\
} while (0)

#define kRemoveLocalUserinfos(key)   [[NSUserDefaults standardUserDefaults] removeObjectForKey:(key)]

/*****************************GCD 的宏定义******************************/
//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);


/*****************************设置加载提示框******************************/
// 加载
#define kShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
// 收起加载
#define kHideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
// 设置加载
#define kNetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x

#define kBackView         for (UIView *item in kWindow.subviews) { \
if(item.tag == 10000) \
{ \
[item removeFromSuperview]; \
UIView * aView = [[UIView alloc] init]; \
aView.frame = [UIScreen mainScreen].bounds; \
aView.tag = 10000; \
aView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3]; \
[kWindow addSubview:aView]; \
} \
}

//错误 
#define ERROR_INFO(Description,FailureReason,RecoverySuggestion)  [NSDictionary dictionaryWithObjectsAndKeys:(Description),NSLocalizedDescriptionKey,\
(FailureReason),NSLocalizedFailureReasonErrorKey,\
(RecoverySuggestion),NSLocalizedRecoverySuggestionErrorKey, nil]
#define ERROR_INIT(statusCode,info)  [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:(statusCode) userInfo:(info)]

// 过期提醒
#define BKDeprecated(instead) NS_DEPRECATED_IOS(2_0, 2_0, instead)

//自定提醒窗口
NS_INLINE void tipWithMessage(NSString *message){
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alerView show];
        [alerView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:@[@0, @1] afterDelay:2.0];
    });
}


//自定提醒窗口:自定标题
NS_INLINE UIAlertView* tipWithTitleMessages(NSString *title, NSString *message, id delegate, NSString *cancelTitle, NSString *otherTitle){
    __block UIAlertView *alerView;
    dispatch_async(dispatch_get_main_queue(), ^{
        alerView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
        [alerView show];
        //        [alerView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:@[@0, @1] afterDelay:0.9];
    });
    return alerView;
}


NS_INLINE void bk_safe_dispatch_main_q(dispatch_block_t block) {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), block);
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}


#endif /* BKMacroDefineHeader_h */
