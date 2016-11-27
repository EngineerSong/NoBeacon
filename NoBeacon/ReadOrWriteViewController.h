//
//  ReadOrWriteViewController.h
//  NoBeacon
//
//  Created by barara on 15/10/27.
//  Copyright © 2015年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ReadOrWriteViewController : UIViewController <CBPeripheralDelegate>

//连接到的周边
@property (nonatomic, strong) CBPeripheral *getPeripheral;
//特征
@property (nonatomic, strong) CBCharacteristic *character;


@end
