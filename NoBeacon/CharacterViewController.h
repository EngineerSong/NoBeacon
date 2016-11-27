//
//  CharacterViewController.h
//  NoBeacon
//
//  Created by barara on 15/10/26.
//  Copyright © 2015年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CharacterViewController : UIViewController <CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate>

//中央
@property (nonatomic, strong) CBCentralManager *cbCentralMgr;
//连接到的周边
@property (nonatomic, strong) CBPeripheral *getPeripheral;

//特征数组
@property (nonatomic, strong) NSMutableArray *characterArray;

@property (nonatomic, strong) UITableView *tableView;


@end
