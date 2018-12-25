//
//  BKPersonlLiveCell.m
//  MontnetsLiveKing
//
//  Created by lzp on 2017/10/17.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "MWPersonlLiveCell.h"

static CGFloat headViewWH = 30 ;
static CGFloat lrPadding = 10.f ;

@interface MWPersonlLiveCell()
@property(nonatomic)UIView *contentBgView;
@property(nonatomic)UIImageView *corverView;
@property(nonatomic)UIView *smallCircleView;
@property(nonatomic)UILabel *stateLabel;
@property(nonatomic)UIButton *moreBtn;
@property(nonatomic)UILabel *dateLabel;
@property(nonatomic)UILabel *limitLabel;
@property(nonatomic)UILabel *userNameLabel;
@property(nonatomic)UIImageView *headView;
@property(nonatomic)UIImageView *verifyImageView;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UIView *longSplitView;
@property(nonatomic)UILabel *visitNumberLabel;
@property(nonatomic)UILabel *liveEndTip;//直播已结束

@property(nonatomic)MWPersonalLiveInfo *liveInfo;
/**下线的imageview*/
@property (strong, nonatomic)  UIImageView *offlineImageView;

/**下线的label*/
@property (strong, nonatomic)  UILabel     *offlineLabel;

/**时间label*/
@property (strong, nonatomic)  UILabel     *timeLabel;


@end

@implementation MWPersonlLiveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
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

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)dealloc{
    kNSLog(@"%@ dealloc --- ",NSStringFromClass([self class]));
}

#pragma mark -- 设置UI

- (void)setupUI{
    [self.contentView addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.corverView];
    //[self.corverView addSubview:self.liveEndTip];
    [self.contentBgView addSubview:self.stateLabel];
    [self.contentBgView addSubview:self.visitNumberLabel];
    [self.contentBgView addSubview:self.smallCircleView];
    [self.contentBgView addSubview:self.limitLabel];
    [self.contentBgView addSubview:self.headView];
    [self.contentBgView addSubview:self.userNameLabel];
    [self.contentBgView addSubview:self.verifyImageView];
    [self.contentBgView addSubview:self.titleLabel];
    [self.contentBgView addSubview:self.moreBtn];
    [self.contentBgView addSubview:self.dateLabel];
    [self.contentBgView addSubview:self.longSplitView];
    [self.contentBgView addSubview:self.offlineImageView];
    [self.contentBgView addSubview:self.timeLabel];
    
    
    [self.contentBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
    }];
    
    [self.offlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentBgView).offset(-10);
        make.top.equalTo(self.contentBgView);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(18);
    }];
    
    [self.corverView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentBgView).mas_offset(10);
        make.left.mas_equalTo(self.contentBgView).mas_offset(lrPadding);
        make.size.mas_equalTo(CGSizeMake(150, 84));
    }];
    
    //    [self.liveEndTip mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.edges.mas_equalTo(self.corverView);
    //    }];
    
    [self.stateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.corverView).mas_offset(6);
        make.right.mas_equalTo(self.corverView).mas_offset(-6);
        make.height.mas_equalTo(17);
    }];
    
    [self.smallCircleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stateLabel);
        make.left.mas_equalTo(self.stateLabel).mas_offset(4);
        make.size.mas_equalTo(CGSizeMake(5, 5));
    }];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.corverView).mas_offset(5);
        make.left.mas_equalTo(self.corverView.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.contentBgView).mas_offset(-lrPadding);
    }];
    
    [self.limitLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(5);
    }];
    
    [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.limitLabel.mas_bottom).mas_offset(5);
    }];
    
    [self.visitNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.dateLabel.mas_bottom).mas_offset(5);
    }];
    
    [self.longSplitView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.corverView.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.longSplitView.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(self.corverView);
        make.size.mas_equalTo(CGSizeMake(headViewWH, headViewWH));
    }];
    
    [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView);
        make.left.mas_equalTo(self.headView.mas_right).mas_offset(5);
        make.right.mas_lessThanOrEqualTo(self.moreBtn.mas_left).mas_offset(-5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headView);
        make.left.width.equalTo(self.userNameLabel);
        make.height.mas_equalTo(14);
    }];
    
    [self.verifyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.right.mas_equalTo(self.headView);
        make.bottom.mas_equalTo(self.headView);
    }];
    
    [self.moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentBgView);
        make.centerY.mas_equalTo(self.headView);
        make.size.mas_equalTo(CGSizeMake(44, 30));
    }];
    
}

#pragma mark -- 数据刷新

- (void)refreshWith:(MWPersonalLiveInfo *)data{
    self.liveInfo = data ;
    self.titleLabel.text = self.liveInfo.liveName;
    
    //0 预约 1 正在直播 2回放
    NSInteger liveState = data.liveStatus;
    
    if(liveState == 0 || liveState == 4){
        self.visitNumberLabel.text = [NSString stringWithFormat:@"预约：%@人",[[NSNumber numberWithLongLong:self.liveInfo.appointCount.longLongValue]convert]];
    }else{
        self.visitNumberLabel.text = [NSString stringWithFormat:@"热度：%@",[[NSNumber numberWithLongLong:self.liveInfo.totalViewers.longLongValue]convert]];
    }

    
    [self setStateText:liveState];
    
    if(self.liveInfo.picUrl ==nil){
        self.liveInfo.picUrl = @"";
    }
    
    __weak typeof(self)weakSelf = self ;
    [self.corverView sd_setImageWithURL:[NSURL URLWithString:self.liveInfo.picUrl] placeholderImage:[UIImage imageNamed:@"livecoverdefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.liveInfo.liveCorver = image ;
    }];
    
    //加密    0:免费,1:私密,2付费
    NSInteger limitType = [self.liveInfo.livePermit integerValue];
    if(limitType == BKLivePermitTypePublic){
        self.limitLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"authority",""),NSLocalizedString(@"publicString","")];
    }else if(limitType == BKLivePermitTypePrivate){
        self.limitLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"authority",""),NSLocalizedString(@"encryption","")];
    }else if(limitType == BKLivePermitTypePay){
        self.limitLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"authority",""),NSLocalizedString(@"payment","")];
    }else if(limitType == BKLivePermitTypeTicketCode){
        self.limitLabel.text = self.limitLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"authority",""),NSLocalizedString(@"tickets","")];;
    }else if(limitType == BKLivePermitTypeWhileList){
        self.limitLabel.text = self.limitLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"authority",""),NSLocalizedString(@"limitWhiteList","")];;
    }else{
        self.limitLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"authority",""),NSLocalizedString(@"publicString","")]; ;
    }
    
    
    //预设时间
    if([self.liveInfo.begin_time integerValue] <= 0){
        
        self.dateLabel.text = @"时间：-";
    }else {
        self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"footprint_time", nil),[NSDate timeIntervalConvertYearMonthDayStyleString:self.liveInfo.begin_time bkDateFormat:BKDateFormat_YYYY_MM_dd_HH_mm format:@"-"]];
    }
    
    if(liveState == 0 || liveState == 4) {
        //创建预告时间
        self.timeLabel.text = self.liveInfo.create_time;
    }else if (liveState == 1) {
        
        //开始时间
        self.timeLabel.text = self.liveInfo.notify_begin_time;
    }else {
        
        //直播结束时间
        self.timeLabel.text = self.liveInfo.notify_end_time;
    }
    

    if(self.liveInfo.liveSwitch == BKLiveSwitchOffline){//下线
        self.offlineImageView.hidden = NO;
        self.offlineImageView.image  = [[UIImage imageNamed:@"offline_video"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) resizingMode:UIImageResizingModeStretch];
        self.offlineLabel.text       = @"已下线";
    }else{
        if(liveState == 4) {//过期
            self.offlineImageView.image = [[UIImage imageNamed:@"live_expired"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) resizingMode:UIImageResizingModeStretch];
            self.offlineLabel.text      = @"已过期";
            self.offlineImageView.hidden = NO;
        }else {
            self.offlineImageView.hidden = YES;
        }
    }
    
    
    
}

- (void)setStateText:(NSInteger)statue{
    self.stateLabel.hidden = NO ;
    self.smallCircleView.hidden = NO ;
    if(statue == 0 || statue == 4){
        self.stateLabel.text = @"预约";
        self.smallCircleView.backgroundColor = BKColor(245,166,35,1);
    }else if(statue == 1 || statue == 3){
        self.stateLabel.text = @"直播";
        self.smallCircleView.backgroundColor = BKColor(255,70,127,1);
    }else if(statue == 2 || statue == 5){
        self.stateLabel.text = @"回放";
        self.smallCircleView.backgroundColor = BKColor(43,148,255,1);
    }
    self.stateLabel.textColor = [UIColor whiteColor];
    self.stateLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    NSDictionary *dic = @{NSFontAttributeName:self.stateLabel.font};
    CGSize size = [self.stateLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    [self.stateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width + 15);
    }];
}

#pragma mark -- 更多按钮点击

- (void)moreBtnClicked{
    if(self.delegate && [self.delegate respondsToSelector:@selector(showMoreWithLiveInfo:)]){
        [self.delegate showMoreWithLiveInfo:self.liveInfo];
    }
}

#pragma mark -- @property setter

- (void)setHeadUrl:(NSString *)headUrl{
    if(headUrl == nil){
        headUrl = @"";
    }
    [self.headView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"placeholder_h"]];
}

- (void)setUserName:(NSString *)userName{
    _userName = userName;
    self.userNameLabel.text = userName;
}

- (void)setIsVerify:(BOOL)isVerify isDefaultFollow:(BOOL)isDefaultFollow{
    if(isDefaultFollow){
        self.verifyImageView.hidden = NO;
        self.verifyImageView.image = [UIImage imageNamed:@"icCertificationStar_nc"];
    }else{
        self.verifyImageView.hidden = !isVerify;
        self.verifyImageView.image = [UIImage imageNamed:@"icCertificationVip_nc"];
    }
}

#pragma mark -- @property getter

- (UIView *)contentBgView{
    if(!_contentBgView){
        _contentBgView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view ;
        });
    }
    return _contentBgView;
}

- (UIImageView *)headView{
    if(!_headView){
        _headView = ({
            UIImageView *view = [UIImageView new];
            view.image = [UIImage imageNamed:@"placeholder_h"];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.layer.masksToBounds = YES;
            view.userInteractionEnabled = YES ;
            view.layer.cornerRadius = headViewWH / 2.0 ;
            view ;
        });
    }
    return _headView;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = ({
            UILabel *view = [UILabel new];
            view.font = [UIFont systemFontOfSize:15];
            view.textColor = [UIColor blackColor];
            view.textAlignment = NSTextAlignmentLeft;
            view.lineBreakMode = NSLineBreakByTruncatingTail;
            view;
        });
    }
    return _titleLabel;
}

- (UIButton *)moreBtn{
    if(!_moreBtn){
        _moreBtn = ({
            UIButton *view = [UIButton new];
            [view setImage:[UIImage imageNamed:@"personal_ic_more_cell"] forState:UIControlStateNormal];
            [view addTarget:self action:@selector(moreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            view ;
        });
    }
    return _moreBtn;
}

- (UILabel *)dateLabel{
    if(!_dateLabel){
        _dateLabel = ({
            UILabel *view = [UILabel new];
            view.font = [UIFont systemFontOfSize:11];
            view.textColor = BKColor(153, 153, 153, 1);
            view.textAlignment = NSTextAlignmentLeft;
            view.lineBreakMode = NSLineBreakByWordWrapping;
            view ;
        });
    }
    return _dateLabel;
}

- (UILabel *)stateLabel{
    if(!_stateLabel){
        _stateLabel = ({
            UILabel *view = [UILabel new];
            view.font = [UIFont systemFontOfSize:10];
            view.textAlignment = NSTextAlignmentCenter;
            view.lineBreakMode = NSLineBreakByCharWrapping;
            view.layer.cornerRadius = 2;
            view.layer.masksToBounds = YES ;
            view ;
        });
    }
    return _stateLabel;
}

- (UILabel *)visitNumberLabel{
    if(!_visitNumberLabel){
        _visitNumberLabel = ({
            UILabel *view = [UILabel new];
            view.lineBreakMode = NSLineBreakByCharWrapping;
            view.textAlignment = NSTextAlignmentLeft;
            view.textColor = BKColor(153, 153, 153, 1);
            view.font = [UIFont systemFontOfSize:11];
            view ;
        });
    }
    return _visitNumberLabel;
}

- (UIImageView *)corverView{
    if(!_corverView){
        _corverView = ({
            UIImageView *view = [UIImageView new];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 2.5 ;
            view.image = [UIImage imageNamed:@"livecoverdefault"];
            view ;
        });
    }
    return _corverView;
}

- (UILabel *)limitLabel{
    if(!_limitLabel){
        _limitLabel = ({
            UILabel *view = [UILabel new];
            view.lineBreakMode = NSLineBreakByCharWrapping;
            view.textAlignment = NSTextAlignmentLeft;
            view.textColor = BKColor(153, 153, 153, 1);
            view.font = [UIFont systemFontOfSize:11];
            view ;
        });
    }
    return _limitLabel;
}

- (UILabel *)userNameLabel{
    if(!_userNameLabel){
        _userNameLabel = ({
            UILabel *view = [UILabel new];
            view.lineBreakMode = NSLineBreakByCharWrapping;
            view.textAlignment = NSTextAlignmentLeft;
            view.textColor = [UIColor colorWithHexString:@"#333333"];
            view.font = [UIFont systemFontOfSize:12];
            view ;
        });
    }
    return _userNameLabel;
}

- (UIImage *)corverImage{
    return self.corverView.image;
}

- (UIView *)longSplitView{
    if(!_longSplitView){
        _longSplitView = ({
            UIView *view = [UIView new];
            view.backgroundColor = BKColor(242, 242, 242, 1.0);
            view ;
        });
    }
    return _longSplitView;
}

- (UIImageView *)verifyImageView{
    if(!_verifyImageView){
        _verifyImageView = ({
            UIImageView *view = [UIImageView new];
            view.image = [UIImage imageNamed:@"icCertificationVip_nc"];
            view ;
        });
    }
    return _verifyImageView;
}

- (UIView *)smallCircleView{
    if(!_smallCircleView){
        _smallCircleView = ({
            UIView *view = [UIView new];
            view.layer.cornerRadius = 5.0/2.0;
            view ;
        });
    }
    return _smallCircleView;
}

- (UILabel *)liveEndTip{
    if(!_liveEndTip){
        _liveEndTip = ({
            UILabel *view = [UILabel new];
            view.text = NSLocalizedString(@"liveWasEnded","");
            view.textAlignment = NSTextAlignmentCenter;
            view.font = [UIFont systemFontOfSize:14];
            view.textColor = [UIColor whiteColor];
            view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            view.hidden = YES ;
            view ;
        });
    }
    return _liveEndTip;
}


- (UIImageView *)offlineImageView{
    if(_offlineImageView == nil){
        _offlineImageView = ({
            UIImageView *view = [UIImageView new];
            view.image = [[UIImage imageNamed:@"offline_video"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) resizingMode:UIImageResizingModeStretch];
            view.clipsToBounds=YES;
            [view addSubview:self.offlineLabel];
            [self.offlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.centerX.centerY.equalTo(view);
                make.width.mas_equalTo(32);
                make.height.mas_equalTo(14);
            }];
            view ;
        });
    }
    return _offlineImageView;
}

- (UILabel *)offlineLabel{
    if(_offlineLabel == nil){
        _offlineLabel = [UILabel new];
        _offlineLabel.textColor = [UIColor whiteColor];
        _offlineLabel.textAlignment = NSTextAlignmentCenter;
        _offlineLabel.font = kFont(10);
        _offlineLabel.text = @"已下线";
    }
    return _offlineLabel;
}


- (UILabel *)timeLabel {
    
    if(_timeLabel == nil) {
        
        _timeLabel = [UILabel ZFC_LabelChainedCreater:^(ZFC_LabelChainedCreater *creater) {
            creater.textColor([UIColor colorWithHexString:@"#9B9B9B"])
            .font(kFont(10))
            .textAlignment(NSTextAlignmentLeft);
        }];
    }
    return _timeLabel;
}


@end
