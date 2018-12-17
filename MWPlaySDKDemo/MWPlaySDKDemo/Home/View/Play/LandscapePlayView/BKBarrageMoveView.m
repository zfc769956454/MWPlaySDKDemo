//
//  BKBarrageMoveView.m
//  BaiKeMiJiaLive
//
//  Created by NegHao on 2016/12/27.
//  Copyright © 2016年 facebac.com. All rights reserved.
//

#import "BKBarrageMoveView.h"
#import "BKBarrageModel.h"
#import "NSString+BKExtension.h"


#define barrageNameColor  kcallColor(@"00deff")
#define barrageBodyColor  @[kcallColor(@"fff000"), kcallColor(@"ffffff"), kcallColor(@"ff5f81")]
@interface BKBarrageMoveView ()
{
    UILabel * titleLabel;
    UIImageView * headImage;
    UILabel * nameLabel;
    float viewWidth;
}
@end
@implementation BKBarrageMoveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];

        titleLabel = [[UILabel alloc] init];
        int r = (arc4random() % 3);
        titleLabel.textColor = barrageBodyColor[1];
        titleLabel.font = kMediumFontIsB4IOS9(16);
        titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        titleLabel.layer.shadowOffset = CGSizeMake(1,1);
        [self addSubview:titleLabel];
        
    }
    return self;
}


- (void)setContentModel:(BKBarrageModel *)model{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    NSDictionary *attrDict01 = @{
                                 NSBaselineOffsetAttributeName: @(2),//设置基线偏移值,正值上偏，负值下偏
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 NSForegroundColorAttributeName: kWhiteColor,
                                 NSFontAttributeName: kMediumFontIsB4IOS9(16)
                                 };
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:model.nickName attributes:attrDict01];
    NSMutableAttributedString *mTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[NSString addAttachmentImageName:@"headfoot" width:12 height:12]];
    [mTitle appendAttributedString:title];
    
    nameLabel.attributedText = mTitle;
    nameLabel.frame = CGRectMake(5, 2, [BKBarrageMoveView calculateMsgWidth:model.nickName andWithLabelFont:[UIFont systemFontOfSize:10] andWithHeight:10] + 15, 12);
    

    titleLabel.text = [NSString stringWithFormat:@"%@ ",model.messageBody];
    titleLabel.frame = CGRectMake(5, nameLabel.bottom, [BKBarrageMoveView calculateMsgWidth:titleLabel.text andWithLabelFont:kRegularFontIsB4IOS9(16) andWithHeight:18], BarrageViewHeight);

    
    viewWidth = titleLabel.frame.size.width + 10;

    self.frame = CGRectMake(kScreenWidth + 10, self.selfYposition, viewWidth, BarrageViewHeight);
}

- (void)grounderAnimation:(id)model{
    float second = 0.0;
    if (titleLabel.text.length < 30){
        second = 10.0f;
    }else{
        second = titleLabel.text.length/2.5;
    }
    kWeakSelf(self);
    [UIView animateWithDuration:second animations:^{
        weakself.frame = CGRectMake( -viewWidth, self.frame.origin.y, viewWidth, BarrageViewHeight);
    }completion:^(BOOL finished) {
        weakself.isShow = NO;
        kWeakSelf(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextView" object:nil userInfo:@{@"obj":weakself}];
    }];
}

+ (CGFloat)calculateMsgWidth:(NSString *)msg andWithLabelFont:(UIFont*)font andWithHeight:(NSInteger)height {
    if ([msg isEqualToString:@""]) {
        return 0;
    }
    CGFloat messageLableWidth = [msg boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:font}
                                                  context:nil].size.width;
    return messageLableWidth + 5;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    headImage.frame = CGRectMake(0, 0, BarrageViewHeight, BarrageViewHeight);
    headImage.layer.cornerRadius = BarrageViewHeight / 2;
    headImage.layer.borderWidth = 0.5;
    headImage.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)dealloc{
    kNSLog(@"");
}

@end
