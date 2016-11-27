//
//  NewViewController.m
//  NoBeacon
//
//  Created by barara on 15/11/18.
//  Copyright © 2015年 Jay. All rights reserved.
//

#import "NewViewController.h"

#define UUID1 @"FFF1"
#define UUID2 @"FFD1"
#define UUID3 @"FFF3"
#define UUID4 @"FFF2"
#define UUID5 @"FFE1"

@interface NewViewController ()

{
    UITapGestureRecognizer *_tap;
}

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    //_characterArray = [NSMutableArray array];
    
    _tap = [[UITapGestureRecognizer alloc] init];
    [_tap addTarget:self action:@selector(tapp)];
    [self.view addGestureRecognizer:_tap];
    
    [self setUI];
    
}

- (void)setUI
{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    iv.image = [UIImage imageNamed:@"image1.png"];
    [self.view addSubview:iv];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 180+10, 40, 20)];
    name.text = @"店名:";
    [self.view addSubview:name];
    UILabel *wifi = [[UILabel alloc] initWithFrame:CGRectMake(10, 180+10+50, 40, 20)];
    wifi.text = @"wifi:";
    [self.view addSubview:wifi];
    UILabel *tel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180+10+100, 40, 20)];
    tel.text = @"电话:";
    [self.view addSubview:tel];
    UILabel *addr = [[UILabel alloc] initWithFrame:CGRectMake(10, 180+10+150, 40, 20)];
    addr.text = @"地址:";
    [self.view addSubview:addr];
    UILabel *table = [[UILabel alloc] initWithFrame:CGRectMake(10, 180+10+210, 40, 20)];
    table.text = @"桌号:";
    [self.view addSubview:table];
    
    _tf1 = [[UITextField alloc] initWithFrame:CGRectMake(50, 165+10+10, self.view.frame.size.width-60, 30)];
    //_tf1.layer.cornerRadius=8.0f;
    _tf1.layer.masksToBounds=YES;
    _tf1.layer.borderColor = [[UIColor grayColor]CGColor];
    _tf1.layer.borderWidth= 1.0f;
    //_tf1.placeholder = @"山姆大叔";
    
    _tf2 = [[UITextField alloc] initWithFrame:CGRectMake(50, 165+10+10+50, self.view.frame.size.width-60, 30)];
    _tf2.layer.masksToBounds=YES;
    _tf2.layer.borderColor = [[UIColor grayColor]CGColor];
    _tf2.layer.borderWidth= 1.0f;
    //_tf2.placeholder = @"010-1234567";
    
    _tf3 = [[UITextField alloc] initWithFrame:CGRectMake(50, 165+10+10+100, self.view.frame.size.width-60, 30)];
    _tf3.layer.masksToBounds=YES;
    _tf3.layer.borderColor = [[UIColor grayColor]CGColor];
    _tf3.layer.borderWidth= 1.0f;
    //_tf3.placeholder = @"010-1234567";
    
    _tf4 = [[UITextField alloc] initWithFrame:CGRectMake(50, 165+10+10+150, self.view.frame.size.width-60, 30)];
    _tf4.layer.masksToBounds=YES;
    _tf4.layer.borderColor = [[UIColor grayColor]CGColor];
    _tf4.layer.borderWidth= 1.0f;
    //_tf4.placeholder = @"北京";
    
    _tf5 = [[UITextField alloc] initWithFrame:CGRectMake(50, 165+10+10+210, self.view.frame.size.width-60, 30)];
    _tf5.layer.masksToBounds=YES;
    _tf5.layer.borderColor = [[UIColor grayColor]CGColor];
    _tf5.layer.borderWidth= 1.0f;
    //_tf5.placeholder = @"2";
    
    NSLog(@"111");
    
    for (CBCharacteristic *character in _characterArray) {
//        NSLog(@"222");
//        NSLog(@"character.uuid = %@",character.UUID);
//        NSLog(@"my uuid = %@",[CBUUID UUIDWithString:[NSString stringWithFormat:@"%d",UUID1]]);
        if ([[NSString stringWithFormat:@"%@",character.UUID] isEqual:UUID1]) {
            _tf1.placeholder = [NSString stringWithFormat:@"%@",character.value];
            NSLog(@"333");
            
            _character1 = character;
        }
        if ([[NSString stringWithFormat:@"%@",character.UUID] isEqual:UUID2]) {
            _tf2.placeholder = [NSString stringWithFormat:@"%@",character.value];
            
            _character2 = character;
        }
        if ([[NSString stringWithFormat:@"%@",character.UUID] isEqual:UUID3]) {
            _tf3.placeholder = [NSString stringWithFormat:@"%@",character.value];
            
            _character3 = character;
        }
        if ([[NSString stringWithFormat:@"%@",character.UUID] isEqual:UUID4]) {
            _tf4.placeholder = [NSString stringWithFormat:@"%@",character.value];
            
            _character4 = character;
        }
        if ([[NSString stringWithFormat:@"%@",character.UUID] isEqual:UUID5]) {
            _tf5.placeholder = [NSString stringWithFormat:@"%@",character.value];
            
            _character5 = character;
        }
    }
    
    [self.view addSubview:_tf1];
    [self.view addSubview:_tf2];
    [self.view addSubview:_tf3];
    [self.view addSubview:_tf4];
    [self.view addSubview:_tf5];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.layer setMasksToBounds:YES];
    //[testBtn.layer setCornerRadius:8.0]; //设置矩圆角半径
    [btn.layer setBorderWidth:1.0];   //边框宽度
    btn.frame = CGRectMake(60, 165+10+10+210+50, self.view.frame.size.width-120, 30);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

- (void)btnClick
{
    if (![_tf1.text  isEqual: @""]) {
        NSData *myData = [_tf1.text dataUsingEncoding:NSUTF8StringEncoding];
        [_getPeripheral writeValue:myData forCharacteristic:_character1 type:CBCharacteristicWriteWithResponse];
    }
    if (![_tf2.text  isEqual: @""]) {
        NSData *myData = [_tf2.text dataUsingEncoding:NSUTF8StringEncoding];
        [_getPeripheral writeValue:myData forCharacteristic:_character2 type:CBCharacteristicWriteWithResponse];
    }
    if (![_tf3.text  isEqual: @""]) {
        NSData *myData = [_tf3.text dataUsingEncoding:NSUTF8StringEncoding];
        [_getPeripheral writeValue:myData forCharacteristic:_character3 type:CBCharacteristicWriteWithResponse];
    }
    if (![_tf4.text  isEqual: @""]) {
        NSData *myData = [_tf4.text dataUsingEncoding:NSUTF8StringEncoding];
        [_getPeripheral writeValue:myData forCharacteristic:_character4 type:CBCharacteristicWriteWithResponse];
    }
    if (![_tf5.text  isEqual: @""]) {
        NSData *myData = [[NSString stringWithFormat:@"No.%@",_tf5.text] dataUsingEncoding:NSUTF8StringEncoding];
        [_getPeripheral writeValue:myData forCharacteristic:_character5 type:CBCharacteristicWriteWithResponse];
    }
    
    
}

- (void)tapp
{
    [self.view endEditing:YES];
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
