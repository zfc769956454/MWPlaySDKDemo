//
//  BKFlowRedEnvelopeView.m
//  MontnetsLiveKing
//
//  Created by chendb on 2017/9/28.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKFlowRedEnvelopeView.h"
#import "BKFlowRedEnvelopeModel.h"

@interface BKFlowRedEnvelopeView ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWindow *redEnvelopeWindow;

@property (nonatomic,strong)UIView *redEnvelopeView;

@property (nonatomic,strong) UIWebView  *redWebView;

@end

@implementation BKFlowRedEnvelopeView

- (void)layoutSubviews{
    CGRect bounds = [UIApplication sharedApplication].delegate.window.bounds;
    
    self.frame = bounds;
    
    _redEnvelopeView.center = self.center;
}

- (id)initWithEnvelopeUrl:(NSString *)envelopeUrl{
    self = [super init];
    if (self) {
        
        _envelopeUrl = envelopeUrl;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:[UIDevice currentDevice]];
        self.frame=MainScreenRect;
        self.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
        
        _redEnvelopeView=[[UIView alloc] init];
        _redEnvelopeView.backgroundColor=[UIColor clearColor];
        _redEnvelopeView.layer.cornerRadius=10.0;
        _redEnvelopeView.layer.masksToBounds=YES;
        _redEnvelopeView.userInteractionEnabled=YES;
        
        [_redEnvelopeView setFrame:CGRectMake(0, 0, RedEnvelopesWidth, 315)];
        
        [_redEnvelopeView addSubview:self.redWebView];
        [_redWebView setFrame:CGRectMake(0, 0, RedEnvelopesWidth, 315)];
        _redEnvelopeView.center = self.center;
        [self addSubview:_redEnvelopeView];
        
    }
    return self;
}

- (UIWebView *)redWebView{
    if (!_redWebView) {
        _redWebView = [[UIWebView alloc]init];
        _redWebView.delegate = self;
        [_redWebView setBackgroundColor:kClearColor];
        [_redWebView setOpaque:NO];
        [_redWebView.scrollView setBackgroundColor:kClearColor];
//        [_redWebView.scrollView setScrollEnabled:NO];
        [_redWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_envelopeUrl]]];
    }
    return _redWebView;
}

- (void)showView{
    _redEnvelopeWindow = [UIApplication sharedApplication].delegate.window;
    [_redEnvelopeWindow addSubview:self];
    
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_redEnvelopeView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_redEnvelopeView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)dismisView{
    [self removeFromSuperview];
    [_redEnvelopeWindow resignKeyWindow];
    [kNotificationCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint coverPoint = [touch locationInView:_redEnvelopeView];
    if (![_redEnvelopeView pointInside:coverPoint withEvent:event]) {
        [self dismisView];
    }
}

#pragma mark  UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([request.URL.absoluteString isEqualToString:BKFlowCloseUrl]) {
        [self dismisView];
        return NO;
    }
    return YES;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [self showView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [self showView];
}


- (void)orientationDidChange:(NSNotification *)notification{
    
    CGRect bounds = [UIApplication sharedApplication].delegate.window.bounds;
    self.frame = bounds;
}

@end
