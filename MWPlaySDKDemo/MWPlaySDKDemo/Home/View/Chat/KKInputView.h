//
//  KKInputView.h
//  KKInputView
//
//  Created by finger on 2017/8/17.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKInputViewDelegate <NSObject>
- (void)sendBtnClicked:(NSString *)inputText;
- (void)danmuBtnClicked:(BOOL)isOn;
@end

@interface KKInputView : UIView
@property(nonatomic,weak)id<KKInputViewDelegate>delegate;
@property(nonatomic,assign)CGFloat inputViewHeight ;
@property(nonatomic,copy)NSString *inputText;
- (void)showKeyBoard;
- (void)hideKeyBoard;
@end
