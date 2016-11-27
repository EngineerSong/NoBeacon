//
//  CharacterViewController.m
//  NoBeacon
//
//  Created by barara on 15/10/26.
//  Copyright © 2015年 Jay. All rights reserved.
//

#import "CharacterViewController.h"
#import "ReadOrWriteViewController.h"

@interface CharacterViewController ()

@end

@implementation CharacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _characterArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //如果复用队列里找不到cell，就创建新的
    }
    
    //indexPath里面放的是cell的位置信息，indexPath.row代表第几行
    
    CBCharacteristic *character = [_characterArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [character.UUID UUIDString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBCharacteristic *character = _characterArray[indexPath.row];
    NSLog(@"读写性 = %lu",(unsigned long)character.properties);
    
    ReadOrWriteViewController *rvc = [[ReadOrWriteViewController alloc] init];
    if (character.properties == 10) {
        rvc.title = @"读写";
    }
    if (character.properties == 2) {
        rvc.title = @"只写";
    }
    if (character.properties == 8) {
        rvc.title = @"只读";
    }
    
    rvc.character = character;
    rvc.getPeripheral = _getPeripheral;
    
    [self.navigationController pushViewController:rvc animated:YES];
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
