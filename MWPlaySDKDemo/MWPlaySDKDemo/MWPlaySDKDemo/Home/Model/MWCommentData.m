//
//  MWCommentData.m
//  MontnetsLiveKing
//
//  Created by lzp on 2017/9/14.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "MWCommentData.h"


#define MsgTipText1 @"系统消息 "
#define MsgTipText2 @"直播消息 "

@interface MWCommentData ()
@property(nonatomic,readwrite)NSAttributedString *commentText;
@property(nonatomic,readwrite)CGSize commemtTextSize;//文本的Size
/**富文本*/
@property (strong, nonatomic)  NSTextAttachment *attchment;


@end

@implementation MWCommentData

- (instancetype)init{
    self = [super init];
    if(self){
        self.textFont = [UIFont systemFontOfSize:15];
        self.lineSpace = 2 ;
        self.maxCommemtTextWidth = kScreenWidth;
        self.textColor = kRGBAColor(122, 122, 122, 1.0) ;
    }
    return self;
}

- (void)setSockData:(MWLiveSocketData *)sockData {
    
    _sockData = sockData;
    
}


- (NSAttributedString *)commentText{
    if(!_commentText){
        
        NSString *nickName = @"";
        if(!ObjIsEqualNullOrNil(self.sockData.nickName)) {
            nickName = self.sockData.nickName.copy ;
        }
        
        if(kScreenWidth == 320 && nickName.length > 9) {
            nickName = [NSString stringWithFormat:@"%@...",[nickName substringToIndex:9]];
        }
        NSString *comment = [NSString stringWithFormat:@"%@:%@",nickName,self.sockData.liveinfo.msgbody];
        
        if(self.sockData.code == MWLiveSocket_presentGift){//送礼
            //comment = [NSString stringWithFormat:@"%@ 送  %@ X1",self.sockData.nickName,self.sockData.liveinfo.giftName];
            comment = [NSString stringWithFormat:@"%@ 送%@ ",nickName,self.sockData.liveinfo.giftName];
        }else if(self.sockData.code == MWLiveSocket_shutupUser){
            comment = [NSString stringWithFormat:@"%@ %@ 已被禁言",MsgTipText2,self.sockData.liveinfo.nickname];
        }else if(self.sockData.code == MWLiveSocket_removeShutupToList){
            comment = [NSString stringWithFormat:@"%@ %@ 已解除禁言",MsgTipText2,self.sockData.liveinfo.nickname];
        }else if(self.sockData.isSystemMessage){
            comment = [NSString stringWithFormat:@"%@%@",MsgTipText1,self.sockData.liveinfo.msgbody];
        }else if(self.sockData.code == MWLiveSocket_joinRoom /**加入房间*/){
            comment = [NSString stringWithFormat:@"%@ 进入直播间",nickName];
        }else if (self.sockData.code == MWliveSocket_shutupUserAll) {//全体禁言
            if(self.sockData.liveinfo.silence_all) {//全体禁言开启
                 comment = [NSString stringWithFormat:@"%@ 全体禁言",MsgTipText2];
            }else {//全体禁言解除
                comment = [NSString stringWithFormat:@"%@ 已解除全体禁言",MsgTipText2];
            }
        }else if (self.sockData.code == MWLiveSocket_praise) {
             comment = [NSString stringWithFormat:@"%@ 点赞+1",nickName];
        }
        
        if(!comment.length){
            comment = @"";
        }
        

        UIColor *clr = BKColor(43, 148, 255, 1);
        NSRange range = NSMakeRange(0, comment.length) ;
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:comment];
        [attriStr setAttributedString:[[NSAttributedString alloc]initWithString:comment attributes:nil]];
        [attriStr addAttribute:NSForegroundColorAttributeName value:self.textColor range:range];
        [attriStr addAttribute:NSFontAttributeName value:self.textFont range:range];
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = self.lineSpace;
        paraStyle.alignment = NSTextAlignmentLeft;
        [attriStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:range];
        
        range = NSMakeRange(0, comment.length) ;
        if(self.sockData.code == MWLiveSocket_shutupUser ||
           self.sockData.code == MWLiveSocket_removeShutupToList ||
           self.sockData.code == MWliveSocket_shutupUserAll){
            range = [comment rangeOfString:MsgTipText2];
            clr = BKColor(255,163,0,1);
        }else if(self.sockData.isSystemMessage){
            range = [comment rangeOfString:MsgTipText1];
            clr = BKColor(255,163,0,1);
        }else{
            range = [comment rangeOfString:[NSString stringWithFormat:@"%@",nickName]];
            clr = BKColor(43, 148, 255, 1);
        }
        
        
        [attriStr removeAttribute:NSForegroundColorAttributeName range:range];
        [attriStr addAttribute:NSForegroundColorAttributeName value:clr range:range];
        
        
        if (self.sockData.code == MWLiveSocket_joinRoom){
            range = [comment rangeOfString:@"进入直播间"];
            clr = kcallColor(@"999999");
            [attriStr addAttribute:NSForegroundColorAttributeName value:clr range:range];
            [attriStr addAttribute:NSBaselineOffsetAttributeName value:@(2 * 0.33) range:range];
        }
        
        
        if(self.sockData.code == MWLiveSocket_presentGift){//送礼
            NSArray *gifImageArray = @[@"ic_applause_small",@"ic_lollipop_small",@"ic_rose_small",@"ic_rockets_small"];
            NSString *gifType = [self returnTypeFromGifId:self.sockData.liveinfo.giftID];
            self.attchment.image = [UIImage imageNamed:@"ic_lollipop_small"];
            if(gifType) {
                self.attchment.image = [UIImage imageNamed:gifImageArray[[gifType integerValue]]];
            }else {
                [[[UIImageView alloc]init] sd_setImageWithURL:[NSURL URLWithString:self.sockData.liveinfo.giftImg] placeholderImage:[UIImage imageNamed:@"livecoverdefault"]completed:^(UIImage *image,NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
                    if(!error) {
                        self.attchment.image = image;
                    }
                }];
            }
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(self.attchment)];
            [attriStr appendAttributedString:string];
        }
        _commentText = attriStr;
    }
    return _commentText;
}


- (NSString *)returnTypeFromGifId:(NSInteger)gifId {
    //鼓掌
    //棒棒糖
    //鲜花
    //火箭
    if(gifId > 0 && gifId < 5){
        
        return [NSString stringWithFormat:@"%ld",gifId - 1];
    }
    return nil;
}

- (CGSize)commemtTextSize{
    if(CGSizeEqualToSize(_commemtTextSize, CGSizeZero)){
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = self.lineSpace;
        paraStyle.alignment = NSTextAlignmentLeft;
        NSDictionary *dic = @{NSFontAttributeName:self.textFont,NSParagraphStyleAttributeName:paraStyle};
        CGSize size = [self.commentText.string boundingRectWithSize:CGSizeMake(self.maxCommemtTextWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        CGFloat addWid = self.sockData.code == MWLiveSocket_presentGift ? 21:0;
        _commemtTextSize = CGSizeMake(size.width + addWid, size.height+ 5 ) ;
    }
    return _commemtTextSize;
}

- (NSTextAttachment *)attchment {
    
    if(_attchment == nil) {
        
        _attchment = [[NSTextAttachment alloc]init];
        _attchment.bounds = CGRectMake(0, -9, 24, 24);
    }
    return _attchment;
}


@end
