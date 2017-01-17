//
//  AnnounceObject.h
//  Dashboard
//
//  Created by Rafay Hasan on 8/26/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnounceObject : NSObject

@property (strong,nonatomic) NSString *announceId;
@property(strong,nonatomic) NSString *announceTitle;
@property(strong,nonatomic) NSString *announceDescription;
@property(strong,nonatomic) NSString *announceImageUrlStr;
@property(strong,nonatomic) NSString *announceCategory;
@property(strong,nonatomic) NSMutableArray *scheduleArray;
@property (strong,nonatomic) NSString *scheduleTime;

@end
