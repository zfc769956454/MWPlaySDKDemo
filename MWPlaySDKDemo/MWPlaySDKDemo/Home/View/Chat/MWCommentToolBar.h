//
//  MWCommentToolBar.h
//  MontnetsLiveKing
//
//  Created by lzp on 2017/8/18.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKTextView;
@protocol MWCommentToolBarDelegate <NSObject>
- (void)shouldShowKeyboard;
@end


@interface MWCommentToolBar : UIView
@property(nonatomic,weak)id<MWCommentToolBarDelegate>delegate;
@property(nonatomic)UITextField *textView ;
- (void)setInputText:(NSString *)inputText;
@end


