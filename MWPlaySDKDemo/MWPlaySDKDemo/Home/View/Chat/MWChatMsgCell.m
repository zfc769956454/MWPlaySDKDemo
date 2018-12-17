//
//  MWCommentMsgCell.m
//  MontnetsLiveKing
//
//  Created by lzp on 2017/8/31.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "MWChatMsgCell.h"
#import "UILabel+MWAttributeTextTapAction.h"

#define CommentLabelFont [UIFont systemFontOfSize:14]
#define LRPadding 10
#define TBPadding 5
#define LineSpace 5//行之间的间隔
#define cellVInterval 10 //cell之间的上下间距

#define  kCellWidth  MIN(kScreenWidth, kScreenHeight)


#define MsgTipT NSLocalizedString(@"liveNews","")

@interface MWChatMsgCell ()
@property(nonatomic)UIView *bgView;
@property(nonatomic)UILabel *msgLabel;
@property(nonatomic)CAShapeLayer *maskLayer;
/**管理员标识*/
@property (strong, nonatomic)UIImageView  *administratorRemarkImageView;
/**管理员显示label*/
@property (strong, nonatomic)UILabel  *administratorRemarkLabel;
@property(nonatomic,weak)MWLiveSocketData *socketData;
@end

@implementation MWChatMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



#pragma mark -- 获取cell的高度

+ (CGFloat)fetchCellHeightWithInfo:(MWCommentData *)info{
    return info.commemtTextSize.height + 2 * TBPadding + cellVInterval;
}

+ (CGFloat)fetchCommentTextWidth{
    return kCellWidth - 4 * LRPadding ;
}

+ (UIFont *)fetchFont{
    return CommentLabelFont;
}

+ (CGFloat)fetchLineSpace{
    return LineSpace;
}

#pragma mark -- 设置UI

- (void)setupUI{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.msgLabel];
    
    [self.contentView addSubview:self.administratorRemarkImageView];
    
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(LRPadding);
        make.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(kCellWidth - 2 * LRPadding);
    }];
    
    [self.msgLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).mas_offset(LRPadding);
        make.top.mas_equalTo(self.bgView).mas_offset(TBPadding);
        make.width.mas_equalTo(kCellWidth - 4 * LRPadding);
    }];
    
    [self.administratorRemarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.msgLabel.mas_top).offset(2);
        make.left.equalTo(self.contentView).offset(2 * LRPadding);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(0);
    }];
    
}

#pragma mark -- 刷新界面

- (void)refreshCellWithInfo:(MWCommentData *)info{
    self.socketData = info.sockData ;
    
    CGFloat textHeight = info.commemtTextSize.height;
    CGFloat textWidth = info.commemtTextSize.width + 5;
    if(textWidth > kCellWidth - 4 * LRPadding){
        textWidth = kCellWidth - 4 * LRPadding;
    }
    NSInteger lineNumber = textHeight / self.msgLabel.font.lineHeight ;
    CGFloat bgViewHeight = textHeight + 2 * TBPadding ;
    CGFloat bgViewWidth = textWidth + 2 * LRPadding ;
    
    [self.msgLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textHeight);
        make.width.mas_equalTo(textWidth);
        make.top.mas_equalTo(self.bgView).mas_offset(TBPadding+(lineNumber == 1 ? LineSpace/2 : 0));
    }];
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bgViewHeight);
        make.width.mas_equalTo(bgViewWidth);
    }];
    
    
    [self.administratorRemarkImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    
    self.msgLabel.attributedText = info.commentText;
    self.msgLabel.textAlignment = NSTextAlignmentLeft;
    self.msgLabel.lineBreakMode = NSLineBreakByCharWrapping;
    if(lineNumber > 1){
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, bgViewWidth, bgViewHeight) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
        self.maskLayer.frame = CGRectMake(0, 0, bgViewWidth, bgViewHeight);
        self.maskLayer.path = maskPath.CGPath;
        self.bgView.layer.mask = self.maskLayer;
    }else{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, bgViewWidth, bgViewHeight) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(bgViewHeight / 2.0, bgViewHeight / 2.0)];
        self.maskLayer.frame = CGRectMake(0, 0, bgViewWidth, bgViewHeight);
        self.maskLayer.path = maskPath.CGPath;
        self.bgView.layer.mask = self.maskLayer;
    }
    
    
    if(info.sockData.code == MWLiveSocket_chatMessage ||
       info.sockData.code == MWLiveSocket_joinRoom ||
       info.sockData.code == MWLiveSocket_presentGift){
        NSString *nickName = @"";
        if(!ObjIsEqualNullOrNil(info.sockData.nickName)) {
            nickName = info.sockData.nickName.copy ;
        }
        
        if(kScreenWidth == 320 && nickName.length > 9) {
            nickName = [NSString stringWithFormat:@"%@...",[nickName substringToIndex:9]];
        }
        kWeakSelf(self)
        [self.msgLabel yb_addAttributeTapActionWithStrings:@[[NSString stringWithFormat:@"%@",nickName]] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            kStrongSelf(weakself)
            if(strong_weakself.delegate && [strong_weakself.delegate respondsToSelector:@selector(tapHeadImageWithInfo:)]){
                [strong_weakself.delegate tapHeadImageWithInfo:strong_weakself.socketData];
            }
        }];
    }
}



#pragma mark -- @property

- (UIView *)bgView{
    if(!_bgView){
        _bgView = ({
            UIView *view = [UIView new];
            view.backgroundColor = kcallColor(@"ECECEC");
            view;
        });
    }
    return _bgView;
}

- (UILabel *)msgLabel{
    if(!_msgLabel){
        _msgLabel = ({
            UILabel *view = [[UILabel alloc]init];
            view.textColor = kRGBAColor(122, 122, 122, 1.0);
            view.textAlignment = NSTextAlignmentLeft;
            view.font = CommentLabelFont;
            view.numberOfLines = 0 ;
            view.backgroundColor = [UIColor clearColor];
            view.lineBreakMode = NSLineBreakByWordWrapping;
            view ;
        });
    }
    return _msgLabel;
}

- (CAShapeLayer *)maskLayer{
    if(!_maskLayer){
        _maskLayer = [[CAShapeLayer alloc]init];
    }
    return _maskLayer;
}

- (UIImageView *)administratorRemarkImageView {
    
    if(_administratorRemarkImageView == nil) {
        
        _administratorRemarkImageView = ({
            

            UIImageView *imageView = [UIImageView ZFC_ImageViewChainedCreater:^(ZFC_ImageViewChainedCreater *creater) {
                creater.image([[UIImage imageNamed:@"details_ic_bg_identity"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8) resizingMode:UIImageResizingModeStretch]);
            }];
            imageView.clipsToBounds = YES;
            
            self.administratorRemarkLabel = [UILabel ZFC_LabelChainedCreater:^(ZFC_LabelChainedCreater *creater) {
                creater.textColor([UIColor whiteColor])
                .textAlignment(NSTextAlignmentCenter)
                .font(kFont(10))
                .text(@"")
                .addIntoView(imageView);
            }];
            
            [self.administratorRemarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(imageView);
                make.left.equalTo(imageView).offset(3);
                make.top.equalTo(imageView).offset(1);
            }];
            
            imageView;
        });
    }
    
    return _administratorRemarkImageView;
    
}


@end
