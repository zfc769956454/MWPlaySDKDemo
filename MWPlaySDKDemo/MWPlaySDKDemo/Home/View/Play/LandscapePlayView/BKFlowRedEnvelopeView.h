//
//  BKFlowRedEnvelopeView.h
//  MontnetsLiveKing
//
//  Created by chendb on 2017/9/28.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MainScreenRect      [UIScreen mainScreen].bounds
#define RedEnvelopesWidth   270

@interface BKFlowRedEnvelopeView : UIView

@property (nonatomic ,strong) NSString *envelopeUrl;   //红包H5Url

- (id)initWithEnvelopeUrl:(NSString *)envelopeUrl;

- (void)showView;

- (void)dismisView;

@end
