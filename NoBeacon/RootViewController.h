//
//  RootViewController.h
//  NoBeacon
//
//  Created by barara on 15/10/19.
//  Copyright © 2015年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface RootViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate>

//中央
@property (nonatomic, strong) CBCentralManager *cbCentralMgr;
@property (nonatomic, strong) NSMutableArray *peripheraArray;
//dic在扫描周边时使用
@property (nonatomic, strong) NSDictionary *dic;

//存储特征数组
@property (nonatomic, strong) NSMutableArray *characterArray;
//存储已读取了value值的特征的数组
@property (nonatomic, strong) NSMutableArray *receiveArray;
//tableview要加载的数据
@property (nonatomic, strong) NSMutableArray *perArray;
@property (nonatomic, strong) UITableView *tableView;


@end
