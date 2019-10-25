//
//  ReportView.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/23.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportView : UIView
@property(nonatomic,strong)UILabel *tradeLabel;
@property(nonatomic,strong)UILabel *districtLabel;
@property(nonatomic,strong)UILabel *budgetLabel;
@property(nonatomic,strong)UIImageView *arrowBudgetImageView;
@property(nonatomic,strong)UILabel *planBeginTimeLabel;
@property(nonatomic,strong)UILabel *StoreLabel;
@property(nonatomic,strong)UILabel *StoreSizeLabel;
//@property(nonatomic,strong)UILabel *RemarkLabel;

@property(nonatomic,strong)UILabel *tradeContent;
@property(nonatomic,strong)UILabel *districtContent;
@property(nonatomic,strong)UILabel *budgetContent;
@property(nonatomic,strong)UILabel *planBeginTimeContent;
@property(nonatomic,strong)UILabel *StoreContent;
@property(nonatomic,strong)UILabel *StoreSizeContent;
//@property(nonatomic,strong)UILabel *RemarkLabel;

@property (strong, nonatomic) NSDictionary *data;//接收数据的字典

@property(nonatomic,strong)UIView *budgeView;
@property(nonatomic,strong)UIView *districtView;
@end
