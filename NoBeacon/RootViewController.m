//
//  RootViewController.m
//  NoBeacon
//
//  Created by barara on 15/10/19.
//  Copyright © 2015年 Jay. All rights reserved.
//

#import "RootViewController.h"
#import "BluetoothModel.h"
#import "BluetoothCell.h"
#import <Foundation/Foundation.h>
#import "CharacterModel.h"
#import "CharacterViewController.h"
#import "NewViewController.h"

//#define UUID1 0xFFF1
//#define UUID2 0xFFD1
//#define UUID3 0xFFF3
//#define UUID4 0xFFF2
//#define UUID5 0xFFE1

@interface RootViewController () <UITextViewDelegate>

{
    CBCentralManager* _manager;
    NSMutableData* _data;
    CBPeripheral* _peripheral;
    NSString *kCharacteristicUUID;
    int _isExist;
    
    NSMutableString *_getUUID;
    CBPeripheral *_getPeripheral;
    
    CBCharacteristic *_character;
    
    UITextField *_tf;
    
    UILabel *_label;
    
    NSThread *_thread;
    
    UITextView *_textView;
    
    int _characterNumber;
    
    int _a;
    int _b;
    
    int _m;
    int _n;
    
    int _isShutDown;
    
    int _record;
    
    int _isFirst;
    
    //int _isConnectAgain;
    
    Byte _dataArr[20];
    
    
    int _isback;
    
}

@end

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"************页面出现************");
    
    if (_getPeripheral) {
        
        [_cbCentralMgr cancelPeripheralConnection:_getPeripheral];
        
        //_getPeripheral = nil;
        [_perArray removeAllObjects];
        [_receiveArray removeAllObjects];
        
        [self.tableView reloadData];
        
        [self.cbCentralMgr scanForPeripheralsWithServices:nil options:_dic];
        
    }
    
    _characterNumber = 0;
    
    _isback = 0;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _characterNumber = 0;
    
    _isback = 0;
    
    UIDevice *curDev = [UIDevice currentDevice];
    kCharacteristicUUID = [NSString stringWithString:curDev.identifierForVendor.UUIDString];
    NSLog(@"uuid = %@",kCharacteristicUUID);
    
    //创建一个中央
    self.cbCentralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.cbCentralMgr.delegate = self;
    self.peripheraArray = [NSMutableArray array];
    
    _perArray = [NSMutableArray array];
    _receiveArray = [NSMutableArray array];
    _characterArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    [self.view addSubview:_tableView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    _textView.font = [UIFont fontWithName:@"Arial" size:18.0];
    _textView.backgroundColor = [UIColor blackColor];
    _textView.textColor = [UIColor whiteColor];
    _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _textView.scrollEnabled = YES;
    //_textView.selectable = YES;//选择复制功能
    //_textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    _textView.delegate = self;
    _textView.editable = NO;//禁止编辑
    [self.view addSubview:_textView];
    
}

//打开蓝牙，寻找服务
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state != CBCentralManagerStatePoweredOn) {
        NSLog(@"蓝牙未打开");
        return;
    }
    //开始寻找所有的服务
    _dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    
    [self.cbCentralMgr scanForPeripheralsWithServices:nil options:_dic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _perArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BluetoothCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qqq"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BluetoothCell" owner:self options:nil] lastObject];
    }
    
    BluetoothModel *bm = self.perArray[indexPath.row];
    cell.nameLabel.text = bm.name;
    cell.UUIDLabel.text = bm.UUID;
    cell.RSSILabel.text = [NSString stringWithFormat:@"%@",bm.RSSI];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_cbCentralMgr stopScan];
    BluetoothModel *bm = _perArray[indexPath.row];
    _getUUID = [[NSMutableString alloc] initWithString:bm.UUID];
    _getPeripheral = bm.peripheral;
    NSLog(@"per = %@",_getPeripheral);
    //开始连接周边
    [_cbCentralMgr connectPeripheral:_getPeripheral options:nil];
    
}

//扫描到服务
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (_peripheral != peripheral) {
        _peripheral = peripheral;
    }
    
    NSString *UUID = [peripheral.identifier UUIDString];
    //NSString *UUID1 = CFBridgingRelease(CFUUIDCreateString(NULL, _peripheral.UUID));
    NSLog(@"name:%@,UUID: %@,RSSI:%@",_peripheral.name,UUID,RSSI);
    
    BluetoothModel *bm = [[BluetoothModel alloc] init];
    bm.peripheral = _peripheral;
    bm.name = _peripheral.name;
    bm.UUID = UUID;
    bm.RSSI = RSSI;
    if (_perArray.count == 0) {
        [_perArray addObject:bm];
    }else{
        for (BluetoothModel *bm in _perArray) {
            if ([bm.UUID isEqualToString:UUID]) {
                bm.RSSI = RSSI;
                _isExist = 1;
            }
        }
        if (_isExist == 0) {
            [_perArray addObject:bm];
        }
        _isExist = 0;
    }
    
    NSLog(@"perArray = %@",_perArray);
    [self.tableView reloadData];
    
}

//连接周边成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _getPeripheral.delegate = self;
    //连接周边服务
    
    _textView.text = @"连接周边成功\n";
    if (_textView.text.length > 100) {
        _textView.text = @"";
    }
    
    NSLog(@"getUUID = %@",_getUUID);
    
    //[peripheral discoverServices:@[[CBUUID UUIDWithString:_getUUID]]];
    
    [_getPeripheral discoverServices:nil];
    
}

//连接周边失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接失败");
    
    _textView.text = @"连接周边失败\n";
    if (_textView.text.length > 100) {
        _textView.text = @"";
    }
    
}

//连接周边服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"错误的服务");
        
        _textView.text = @"服务错误\n";
        if (_textView.text.length > 100) {
            _textView.text = @"";
        }
        
        return;
    }
    
    //遍历服务
    for (CBService* service in peripheral.services) {
        NSLog(@"遍历中：serviceUUID为%@",service.UUID);
        //if ([service.UUID isEqual:[CBUUID UUIDWithString:serviceUUID]]) {
            
            _textView.text = @"找到目标服务\n";
            if (_textView.text.length > 100) {
                _textView.text = @"";
            }
    
            //连接特征
            //[peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:kCharacteristicUUID]] forService:service];
            
            [peripheral discoverCharacteristics:nil forService:service];
            
        //}
        //[service.peripheral discoverCharacteristics:nil forService:service];
        
    }
    
}

//发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"连接特征失败");
        
        _textView.text = @"连接特征失败\n";
        if (_textView.text.length > 100) {
            _textView.text = @"";
        }
        
        return;
    }
    
    _characterNumber = _characterNumber + (int)service.characteristics.count;
    
    //遍历特征
    for (CBCharacteristic* characteristic in service.characteristics) {

        
        
        
        [peripheral readValueForCharacteristic:characteristic];
        
        
        [_characterArray addObject:characteristic];
        
        
        
        //NSLog(@"readValue = %@",characteristic.value);
        
        
    }
    
    
}

//数据发送成功回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"发送成功");
    
    sleep(0.1);
    
    //NSLog(@"");
    
}

////监听到特征值更新
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    if (error) {
//        NSLog(@"特征值出错");
//        return;
//    }
//    
//    NSLog(@"character2 = %@",characteristic);
//    
//    //如果有新值，读取新的值
//    if (characteristic.isNotifying) {
//        [peripheral readValueForCharacteristic:characteristic];
//    }
//}

//收到新值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
//        NSString* str = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF16StringEncoding];
//        NSLog(@"new = %@,characteristic = %@",str,characteristic.UUID);
    
    //    _label.text = str;
    
    if (_isback == 1) {
        return;
    }
    
    Byte *testByte = (Byte *)[characteristic.value bytes];
    
//    NSMutableString *muStr = [[NSMutableString alloc] init];
//    
//    for (int i = 0; i < [characteristic.value length]; i++) {
//        
//        NSString *str = [NSString stringWithFormat:@" %x",testByte[i]&0xff];
//        
//        [muStr appendString:str];
//        
//    }
    
    //NSLog(@"str = %@,characteristic = %@",muStr,characteristic);
    
    CharacterModel *cm = [[CharacterModel alloc] init];
    cm.myCharacter = characteristic;
    cm.readByte = testByte;
    
    NSMutableString *muStr = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [characteristic.value length]; i++) {
        
        NSString *str = [NSString stringWithFormat:@" %x",cm.readByte[i]&0xff];
        
        [muStr appendString:str];
        
    }
    
    NSLog(@"read = %@,character = %@",muStr,cm.myCharacter);
    
    [_receiveArray addObject:cm];
    
    if (_characterNumber == _receiveArray.count) {
        NewViewController *cvc = [[NewViewController alloc] init];
        //cvc.title = @"特征";
        cvc.getPeripheral = _getPeripheral;
        cvc.characterArray = _characterArray;
        
        _isback = 1;
        
        [self.navigationController pushViewController:cvc animated:YES];
    }
    
}

//蓝牙断开回调
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    //_isConnectAgain = 1;
    
    _textView.text = @"蓝牙断开\n";
    if (_textView.text.length > 100) {
        _textView.text = @"";
    }
    
    _isback = 0;
    
    NSLog(@"error = %@,%ld",error,(long)error.code);
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"**********页面消失**********");
    
//    if (_getPeripheral) {
//        [_cbCentralMgr cancelPeripheralConnection:_getPeripheral];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
