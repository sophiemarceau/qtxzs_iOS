//
//  alreadychecklistTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/27.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "alreadychecklistTableViewCell.h"

@implementation alreadychecklistTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

-(void)_initView{
    self.backgroundColor = BGColorGray;
    [self.contentView addSubview:self.bgView];
    
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.desLabel];
    [self.bgView addSubview:self.lineImageView];
    [self.bgView addSubview:self.followView];
    [self.followView addSubview:self.followImageView];
    [self.followView addSubview:self.followrecordLabel];
    [self.bgView addSubview:self.PhoneView];
    [self.PhoneView addSubview:self.PhoneImageView];
    [self.PhoneView addSubview:self.phoneLabel];
    [self.bgView addSubview:self.verticallineImageView];
  
}

-(CGFloat)setCellHeight:(NSString *)strInfo{
    self.nameLabel.text  = [NSString stringWithFormat:@"客户姓名：%@",[self.celldata objectForKey:@"report_customer_name"]];
    self.timeLabel.text = [self.celldata objectForKey:@"report_createdtime"];
    CGFloat descheight =self.desLabel.frame.size.height;
    [self.desLabel setNumberOfLines:0];  //0行，则表示根据文本长度，自动增加行数
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    self.desLabel.text =[[self.celldata objectForKey:@"latestCustomerReportLogDto"] objectForKey:@"crl_note"];
    [self.desLabel sizeToFit];
    CGSize size  = CGSizeMake(self.desLabel.frame.size.width, self.desLabel.frame.size.height);
    
    descheight = descheight > size.height ? descheight : size.height;
    self.desLabel.size = CGSizeMake(self.desLabel.frame.size.width, descheight);
    
    self.lineImageView.frame = CGRectMake(0, self.desLabel.frame.origin.y+self.desLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 0.5*AUTO_SIZE_SCALE_X);
    self.PhoneView.frame = CGRectMake(kScreenWidth/2, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, kScreenWidth/2, 49*AUTO_SIZE_SCALE_X);
    self.followView.frame = CGRectMake(0, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, kScreenWidth/2, 49*AUTO_SIZE_SCALE_X);
    self.bgView.frame = CGRectMake(0, 0, kScreenWidth, self.followView.frame.origin.y+self.followView.frame.size.height);
    return self.followView.frame.origin.y+self.followView.frame.size.height+10*AUTO_SIZE_SCALE_X;
}

-(void)TradeTaped:(UITapGestureRecognizer *)sender{
    [[sender view] setUserInteractionEnabled:NO];
    
    
    [self.delegate alreadybuttononclick:[[sender view] tag] WithID:[self.celldata objectForKey:@"report_id"] WithReportString:[self.celldata objectForKey:@"report_id_str"]];
    [[sender view] setUserInteractionEnabled:YES];
}

-(void)PhoneTaped:(UITapGestureRecognizer *)sender{
    [MobClick event:kChectListPhoneonClickEvent];
    NSDictionary *dic = @{
                          @"report_id_str":[self.celldata objectForKey:@"report_id_str"],
                          };
    NSLog(@"dic======%@",dic);
    
    [[RequestManager shareRequestManager] GetCustomerTelByReportIdStrResult:dic viewController:nil successData:^(NSDictionary *result){
        //        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            NSLog(@"result======%@",result);
            if (result != nil) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[result objectForKey:@"data"] objectForKey:@"result"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{}
                 
                                         completionHandler:^(BOOL success) {
                                         }];
                //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                //                    [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:0.2f];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:nil];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:nil];
    }];
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        self.nameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.nameLabel.textColor = RedUIColorC1;
        self.nameLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X, (kScreenWidth-(30)*AUTO_SIZE_SCALE_X), 21*AUTO_SIZE_SCALE_X);
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        self.timeLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.timeLabel.textColor = UIColorFromRGB(0x999999);
        self.timeLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+3*AUTO_SIZE_SCALE_X, (kScreenWidth-(30)*AUTO_SIZE_SCALE_X), 16.5*AUTO_SIZE_SCALE_X);
    }
    return _timeLabel;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        self.desLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.desLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, self.timeLabel.frame.origin.y+self.timeLabel.frame.size.height+5*AUTO_SIZE_SCALE_X, kScreenWidth-(30)*AUTO_SIZE_SCALE_X, 21*AUTO_SIZE_SCALE_X);
        self.desLabel.textColor = FontUIColorBlack;
    }
    return _desLabel;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        self.lineImageView = [UIImageView new];
        self.lineImageView.backgroundColor = lineImageColor;
        self.lineImageView.frame = CGRectMake(0,
                                                self.desLabel.frame.origin.y+self.desLabel.frame.size.height,
                                                kScreenWidth,
                                                0.5*AUTO_SIZE_SCALE_X);
    }
    return  _lineImageView;
}

-(UIView *)followView{
    if (_followView == nil) {
        self.followView = [UIView new];
        self.followView.frame = CGRectMake(0, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, kScreenWidth/2, 49*AUTO_SIZE_SCALE_X);
        self.followView.tag = 1;
        UITapGestureRecognizer *phonetap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
        self.followView.userInteractionEnabled = YES;
        [self.followView addGestureRecognizer:phonetap1];
        
    }
    return  _followView;
}

-(UIImageView *)followImageView{
    if (_followImageView == nil) {
        self.followImageView = [UIImageView new];
        self.followImageView.image = [UIImage imageNamed:@"icon_enterprise_review_chat_log"];
        self.followImageView.frame = CGRectMake(57*AUTO_SIZE_SCALE_X,
                                               14.5*AUTO_SIZE_SCALE_X,
                                               20*AUTO_SIZE_SCALE_X,
                                               20*AUTO_SIZE_SCALE_X);
    }
    return  _followImageView;
}

- (UILabel *)followrecordLabel {
    if (_followrecordLabel == nil) {
        self.followrecordLabel = [CommentMethod initLabelWithText:@"跟进记录" textAlignment:NSTextAlignmentLeft font:11*AUTO_SIZE_SCALE_X];
        self.followrecordLabel.frame = CGRectMake(87*AUTO_SIZE_SCALE_X, 17.5*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
        self.followrecordLabel.textColor = FontUIColorBlack;
    }
    return _followrecordLabel;
}

-(UIView *)PhoneView{
    if (_PhoneView == nil) {
        self.PhoneView = [UIView new];
        self.PhoneView.frame = CGRectMake(kScreenWidth/2, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, kScreenWidth/2, 49*AUTO_SIZE_SCALE_X);
        UITapGestureRecognizer *phonetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PhoneTaped:)];
        self.PhoneView.tag = 2;
        self.PhoneView.userInteractionEnabled = YES;
        [self.PhoneView addGestureRecognizer:phonetap];
    }
    return  _PhoneView;
}

- (UIImageView *)PhoneImageView {
    if (_PhoneImageView == nil) {
        self.PhoneImageView = [UIImageView new];
        self.PhoneImageView.image = [UIImage imageNamed:@"icon_enterprise_review_phone"];
        
        self.PhoneImageView.frame = CGRectMake(57*AUTO_SIZE_SCALE_X,
                                                14.5*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X);
    }
    return _PhoneImageView;
}



- (UILabel *)phoneLabel {
    if (_phoneLabel == nil) {
        self.phoneLabel = [CommentMethod initLabelWithText:@"拨打电话" textAlignment:NSTextAlignmentLeft font:11*AUTO_SIZE_SCALE_X];
        self.phoneLabel.frame = CGRectMake(87*AUTO_SIZE_SCALE_X, 17.5*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
        self.phoneLabel.textColor = FontUIColorBlack;
    }
    return _phoneLabel;
}




-(UIImageView *)verticallineImageView{
    if (_verticallineImageView == nil) {
        self.verticallineImageView = [UIImageView new];
        self.verticallineImageView.backgroundColor = lineImageColor;
        self.verticallineImageView.frame = CGRectMake(kScreenWidth/2,self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height+
                                              23*AUTO_SIZE_SCALE_X,
                                              0.5,
                                              20*AUTO_SIZE_SCALE_X);
    }
    return  _verticallineImageView;
}

-(UIView *)bgView{
    if (_bgView == nil) {
        self.bgView = [UIView new];
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    return  _bgView;
}

@end
