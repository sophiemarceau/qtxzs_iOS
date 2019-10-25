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

@property(nonatomic,strong)UITextField *tradeContent;
@property(nonatomic,strong)UITextField *districtContent;
@property(nonatomic,strong)UITextField *budgetContent;
@property(nonatomic,strong)UITextField *planBeginTimeContent;

@property(nonatomic,strong)UITextField *StoreContent;
@property(nonatomic,strong)UITextField *StoreSizeContent;
//@property(nonatomic,strong)UILabel *RemarkLabel;

@property (strong, nonatomic) NSDictionary *data;//接收数据的字典
@property(nonatomic,strong)UIView *tradeView;
@property(nonatomic,strong)UIView *districtView;
@property(nonatomic,strong)UIView *budgeView;
@property(nonatomic,strong)UIView *planView;
@end
