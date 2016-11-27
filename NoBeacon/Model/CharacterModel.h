//
//  CharacterModel.h
//  NoBeacon
//
//  Created by barara on 15/10/26.
//  Copyright © 2015年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CharacterModel : NSObject

@property (nonatomic, strong) CBCharacteristic *myCharacter;

@property (nonatomic, assign) Byte *readByte;

@end
