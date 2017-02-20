//
//  RHWebServiceManager.h
//  MCP
//
//  Created by Rafay Hasan on 9/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


#ifdef DEBUG
#define BASE_URL_API @"http://stage-smy-wp.mcp.com:82"
#else
#define BASE_URL_API @"http://smy-wp.mcp.com:82"
#endif

 
enum {    
    HTTPRequestTypAllAnnouncementInfo,
    HTTPRequestTypAnnouncementInsert,
    HTTPRequestTypAnnouncementDelete
};
typedef NSUInteger HTTPRequestType;


@protocol RHWebServiceDelegate <NSObject>

@optional

-(void) dataFromWebReceivedSuccessfully:(id) responseObj;
-(void) dataFromWebReceiptionFailed:(NSError*) error;
-(void) dataFromWebDidnotReceiveSuccessMessage:( NSInteger )statusCode;


@end


@interface RHWebServiceManager : NSObject

@property (nonatomic, retain) id <RHWebServiceDelegate> delegate;


@property (readwrite, assign) HTTPRequestType requestType;

-(id) initWebserviceWithRequestType: (HTTPRequestType )reqType Delegate:(id) del;
-(void) getDataFromWebURL:(NSString *)requestURL;
-(void) sendBulletinWithData:(NSDictionary *)postData withUrlStr:(NSString *)urlStr withImageData:(NSData *)imageData forAPI:(NSString *)apiName;
-(void) updateBulletinWithData:(NSDictionary *)postData withUrlStr:(NSString *)urlStr withImageData:(NSData *)imageData;
-(void) deleteBulletinwithId:(NSString *)bulletinId UrlStr:(NSString *)urlStr;

@end
