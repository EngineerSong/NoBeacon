//
//  ReadOrWriteViewController.m
//  NoBeacon
//
//  Created by barara on 15/10/27.
//  Copyright © 2015年 Jay. All rights reserved.
//

#import "ReadOrWriteViewController.h"

@interface ReadOrWriteViewController () <UITextFieldDelegate>

{
    UILabel *_label;
    UITextField *_tf;
}

@end

@implementation ReadOrWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.title isEqualToString:@"读写"]) {
        [self read];
        [self write];
    }
    if ([self.title isEqualToString:@"只写"]) {
        [self write];
    }
    if ([self.title isEqualToString:@"只读"]) {
        [self read];
    }
    
}

- (void)read
{
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(10, 100+60+64, self.view.frame.size.width-100, 40);
    _label.backgroundColor = [UIColor blackColor];
    _label.textColor = [UIColor whiteColor];
    [self.view addSubview:_label];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(self.view.frame.size.width-80, 100+60+64, 70, 40);
    [btn2 setTitle:@"Read" forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor blueColor]];
    [btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)write
{
    _tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 100+10+64, self.view.frame.size.width-100, 40)];
    _tf.backgroundColor = [UIColor grayColor];
    _tf.delegate = self;
    [self.view addSubview:_tf];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.frame.size.width-80, 100+10+64, 70, 40);
    [btn setTitle:@"Write" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

//读
- (void)btn2Click
{
    [_getPeripheral readValueForCharacteristic:_character];
}

//写
- (void)btnClick
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //        NSString* str = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF16StringEncoding];
    //        NSLog(@"new = %@,characteristic = %@",str,characteristic.UUID);
    
    //    _label.text = str;
    
    Byte *testByte = (Byte *)[characteristic.value bytes];
    
    NSMutableString *muStr = [[NSMutableString alloc] initWithString:@"0x"];
    
    for (int i = 0; i < [characteristic.value length]; i++) {
    
        NSString *str = [NSString stringWithFormat:@"%x",testByte[i]&0xff];
    
        [muStr appendString:str];
    
    }
    
    _label.text = muStr;
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
