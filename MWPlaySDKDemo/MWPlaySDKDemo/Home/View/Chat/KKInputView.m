//
//  KKInputView.m
//  KKInputView
//
//  Created by finger on 2017/8/17.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKInputView.h"
#import "KKTextView.h"

@interface KKInputView ()<UITextViewDelegate>
@property(nonatomic)UIButton *bgView;
@property(nonatomic)UIView *inputMaskView;

@property(nonatomic)KKTextView *textView;

@property(nonatomic)CGFloat keyboardHeight;
@property(nonatomic)CGFloat inputMaskViewHeight ;
@property(nonatomic)CGFloat lrPadding;
@property(nonatomic)CGFloat textViewHeight;
@end

@implementation KKInputView

- (instancetype)init{
    self = [super init];
    if(self){
        // 添加对键盘的监控
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [self setupUI];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    kNSLog(@"%@ dealloc --- ",NSStringFromClass([self class]));
}

#pragma mark -- 设置UI

- (void)setupUI{
    [self addSubview:self.bgView];
    [self addSubview:self.inputMaskView];
    [self.inputMaskView addSubview:self.textView];

    
    self.inputMaskViewHeight = 50 ;
    self.lrPadding = 10 ;
    self.textViewHeight = 33;
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    //进入横屏直播间后再退出，此时屏幕的宽高可能不正确
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(width > height){
        CGFloat temp = width ;
        width = height ;
        height = temp ;
    }
    [self.inputMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(height-self.inputMaskViewHeight);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(self.inputMaskViewHeight);
    }];
    
    self.textView.layer.cornerRadius = self.textViewHeight / 2.0 ;
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.inputMaskView.mas_centerY);
        make.left.mas_equalTo(self.inputMaskView).mas_offset(self.lrPadding);
        make.right.mas_equalTo(self).mas_offset(-self.lrPadding);
        make.height.mas_equalTo(self.textViewHeight);
    }];
    
}

#pragma mark -- 显示和隐藏

- (void)showKeyBoard{
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //进入横屏直播间后再退出，此时屏幕的宽高可能不正确
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(width > height){
        CGFloat temp = width ;
        width = height ;
        height = temp ;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    [self layoutIfNeeded];
    [self.textView becomeFirstResponder];
}

- (void)hideKeyBoard{
    [self.textView resignFirstResponder];
    [self removeFromSuperview];
}

#pragma mark -- 点击发送按钮

- (void)sendBtnClicked{
    NSString *inputText = self.textView.text;
    if(!inputText.length){
        return;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(sendBtnClicked:)]){
        [self.delegate sendBtnClicked:inputText];
    }
    
    self.textView.text = @"";
    
    [self adjustTextView];
    [self hideKeyBoard];
}

#pragma mark -- 弹幕开关

- (void)switchClicked:(UIButton *)switchBtn{
    switchBtn.selected = !switchBtn.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(danmuBtnClicked:)]){
        [self.delegate danmuBtnClicked:switchBtn.selected];
    }
}

#pragma mark -- UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
//    self.sendBtn.enabled = textView.text.length;
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 80) {
                textView.text = [toBeString substringToIndex:80];
            }
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 80) {
            textView.text = [toBeString substringToIndex:80];
        }
    }
    [self adjustTextView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        NSString *inputText = self.textView.text;
        if(inputText.length){
            if(self.delegate && [self.delegate respondsToSelector:@selector(sendBtnClicked:)]){
                [self.delegate sendBtnClicked:inputText];
            }
        }
        
        self.textView.text = @"";
        
        [self adjustTextView];
        [self hideKeyBoard];
        
        return NO;
    }
    return YES;
}

#pragma mark -- 调整输入视图的高度和Y坐标

- (void)adjustTextView{
    CGSize size = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width,MAXFLOAT)];
    CGFloat height = fmax(self.textViewHeight, size.height);
    
    self.textView.scrollEnabled = NO ;
    if(height > 3 * self.textView.font.lineHeight){
        height = 3 * self.textView.font.lineHeight;
        self.textView.scrollEnabled = YES ;
    }
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    
    height = height + self.inputMaskViewHeight - self.textViewHeight ;
    [self.inputMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.keyboardHeight + [UIScreen mainScreen].bounds.size.height - self.keyboardHeight - height);
        make.height.mas_equalTo(height);
    }];
    
    [self.inputMaskView layoutIfNeeded];
}

#pragma mark -- 键盘的显示和隐藏

- (void)keyBoardWillShow:(NSNotification *) note {
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void (^animation)(void) = ^void(void) {
        self.inputMaskView.transform = CGAffineTransformMakeTranslation(0, - self.keyboardHeight);
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
    NSMutableDictionary *infoDic = [NSMutableDictionary new];
    infoDic[@"keyboardIsShow"] = [NSNumber numberWithBool:YES];
    infoDic[@"keyboardHeight"] = [NSNumber numberWithFloat:self.keyboardHeight];
    infoDic[@"keyboardAnimateTime"] = [NSNumber numberWithDouble:animationTime];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ShouldAdjustViewWithKeyboard" object:infoDic];
}

- (void)keyBoardWillHide:(NSNotification *) note {
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    
    void (^animation)(void) = ^void(void) {
        self.inputMaskView.transform = CGAffineTransformMakeTranslation(0, keyBoardHeight + self.inputMaskView.frame.size.height);
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        animation();
    }
    
    NSMutableDictionary *infoDic = [NSMutableDictionary new];
    infoDic[@"keyboardIsShow"] = [NSNumber numberWithBool:NO];
    infoDic[@"keyboardHeight"] = [NSNumber numberWithFloat:self.keyboardHeight];
    infoDic[@"keyboardAnimateTime"] = [NSNumber numberWithDouble:animationTime];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ShouldAdjustViewWithKeyboard" object:infoDic];
}

#pragma mark --  @property getter

- (UIButton *)bgView{
    if(!_bgView){
        _bgView = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
            btn ;
        });
    }
    return _bgView;
}

- (UIView *)inputMaskView{
    if(!_inputMaskView){
        _inputMaskView = ({
            UIView *view = [UIView new];
            view.backgroundColor = BKColor(242, 242, 242, 1);;
            view.layer.borderColor = [[UIColor blackColor]colorWithAlphaComponent:0.3].CGColor;
            view.layer.borderWidth = 0.3;
            view ;
        });
    }
    return _inputMaskView;
}

- (KKTextView *)textView{
    if(!_textView){
        _textView = ({
            KKTextView *view = [[KKTextView alloc]init];
            view.backgroundColor = [UIColor whiteColor];
            view.returnKeyType = UIReturnKeySend;
            view.layer.masksToBounds = YES ;
            view.textColor = BKColor(51, 51, 51, 1.0);;
            view.keyboardType = UIKeyboardTypeDefault;
            view.textAlignment = NSTextAlignmentLeft;
            view.font = [UIFont systemFontOfSize:14];
            view.placeholderColor = kRGBAColor(204, 204, 204, 1.0);
            view.placeholder = @"说点什么吧";
            view.placeholderFont = [UIFont systemFontOfSize:14];
            view.delegate = self ;
            view.scrollEnabled = NO ;
            view;
        });
    }
    return _textView;
}



@end
