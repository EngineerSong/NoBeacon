//
//  NewViewController.h
//  NoBeacon
//
//  Created by barara on 15/11/18.
//  Copyright © 2015年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface NewViewController : UIViewController <CBPeripheralDelegate>

//连接到的周边
@property (nonatomic, strong) CBPeripheral *getPeripheral;
//特征店名
@property (nonatomic, strong) CBCharacteristic *character1;
//特征wifi
@property (nonatomic, strong) CBCharacteristic *character2;
//特征电话
@property (nonatomic, strong) CBCharacteristic *character3;
//特征地址
@property (nonatomic, strong) CBCharacteristic *character4;
//特征桌号
@property (nonatomic, strong) CBCharacteristic *character5;

//特征数组
@property (nonatomic, strong) NSMutableArray *characterArray;

@property (nonatomic, strong) UITextField *tf1;
@property (nonatomic, strong) UITextField *tf2;
@property (nonatomic, strong) UITextField *tf3;
@property (nonatomic, strong) UITextField *tf4;
@property (nonatomic, strong) UITextField *tf5;


@end
