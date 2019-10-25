//
//  SearchViewController.h
//  wecoo
//
//  Created by 屈小波 on 2017/5/19.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
@protocol  mysearchSuccessDelegate<NSObject>
- (void)addSuccessReturnClientPage:(NSDictionary*)returnTypeDic;;
@end
@interface SearchViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray *searchMenuArray;
@property(nonatomic , strong)UISearchBar * searchBar;
@property(nonatomic , strong)NSMutableArray *ListArray;
@property(nonatomic , strong)NSMutableArray *menuArray;
@property(nonatomic , strong)UITableView * tableView;
@property(nonatomic, weak)id <mysearchSuccessDelegate>delegate;
@end
