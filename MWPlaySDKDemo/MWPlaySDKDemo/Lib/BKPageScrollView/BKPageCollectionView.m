//
//  ZJScrollView.m
//  ZJScrollPageView
//
//  Created by ZeroJ on 16/10/24.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "BKPageCollectionView.h"


@interface BKPageCollectionView ()
@property (copy, nonatomic) ZJScrollViewShouldBeginPanGestureHandler gestureBeginHandler;
@end
@implementation BKPageCollectionView


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_gestureBeginHandler && gestureRecognizer == self.panGestureRecognizer) {
        return _gestureBeginHandler(self, (UIPanGestureRecognizer *)gestureRecognizer);
    }
    else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}

- (void)setupScrollViewShouldBeginPanGestureHandler:(ZJScrollViewShouldBeginPanGestureHandler)gestureBeginHandler {
    _gestureBeginHandler = [gestureBeginHandler copy];
}

//- (void)setupScrollViewShouldBeginPanGestureHandler:(ZJScrollViewShouldBeginPanGestureHandler)gestureBeginHandler {
//    _gestureBeginHandler = [gestureBeginHandler copy];
//}
//
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([self panResponse:gestureRecognizer]) {
//        return YES;//响应其它的
//    }
//    return NO;//响应自己的
//}
//
//- (BOOL)panResponse:(UIGestureRecognizer *)gestureRecognizer {
//    CGFloat location_x =0.15*kScreenWidth;//有效长度
//    CGPoint location = [gestureRecognizer locationInView:self];
//    NSLog(@"location:%f",location.x);
//    if (gestureRecognizer ==self.panGestureRecognizer) {
//        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
//        CGPoint transPoint = [pan translationInView:self];
//        UIGestureRecognizerState state = gestureRecognizer.state;
//        if (state == UIGestureRecognizerStateBegan||state==UIGestureRecognizerStatePossible) {
//            //在第一张返回
//            if ((transPoint.x > 0 && location.x < location_x && self.contentOffset.x <= 0)) {
//                return YES;
//            }else if (transPoint.x<0){
//                return YES;
//            }
//        }
//    }
//    NSLog(@"%@",gestureRecognizer);
//    return NO;
//}




@end
