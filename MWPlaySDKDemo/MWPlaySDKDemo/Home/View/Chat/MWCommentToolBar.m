//
//  MWCommentToolBar.m
//  MontnetsLiveKing
//
//  Created by lzp on 2017/8/18.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "MWCommentToolBar.h"
#import "KKTextView.h"

@interface MWCommentToolBar ()
@end

@implementation MWCommentToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)dealloc{
    kNSLog(@"%@ dealloc --- ",NSStringFromClass([self class]));
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textView.layer.cornerRadius = self.height / 2.0 ;
}

#pragma mark -- 设置UI

- (void)setupUI{
    self.userInteractionEnabled = YES ;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shouldShowKeyboard:)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.textView];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark -- 设置输入文本

- (void)setInputText:(NSString *)inputText{
    self.textView.text = inputText;
}

#pragma mark -- 点击输入框显示键盘

- (void)shouldShowKeyboard:(UIGestureRecognizer *)recognizer{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shouldShowKeyboard)]){
        [self.delegate shouldShowKeyboard];//MWLiveInfoDetailView
    }
}

#pragma mark -- @property getter

- (UITextField *)textView{
    if(!_textView){
        _textView = ({
            UITextField *view = [[UITextField alloc]init];
            view.backgroundColor = [UIColor whiteColor];
            view.textColor = [UIColor blackColor];
            view.layer.masksToBounds = YES ;
            view.layer.cornerRadius = 2.0 ;
            view.textAlignment = NSTextAlignmentLeft;
            view.keyboardType = UIKeyboardTypeDefault;
            view.returnKeyType = UIReturnKeySend ;
            view.userInteractionEnabled = NO ;
            
            view.font = kRegularFontIsB4IOS9(13);
            view.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chatroom_ic_pen"]];
            view.leftView = imageView;
            view.leftViewMode = UITextFieldViewModeAlways ;
            
            
            view.placeholder = @"说点什么吧";
            [view setValue:kcallColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
            [view setValue:kRegularFontIsB4IOS9(13) forKeyPath:@"_placeholderLabel.font"];
            
            view ;
        });
    }
    return _textView;
}

@end
