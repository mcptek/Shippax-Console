//
//  RHWebServiceManager.m
//  MCP
//
//  Created by Rafay Hasan on 9/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "RHWebServiceManager.h"
#import "AnnounceObject.h"
@implementation RHWebServiceManager


-(id) initWebserviceWithRequestType: (HTTPRequestType )reqType Delegate:(id) del
{
    if (self=[super init])
    {
        self.delegate = del;
        self.requestType = reqType;
    }
    
    return self;
}


-(void)getDataFromWebURL:(NSString *)requestURL
{
    
    requestURL = [requestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"text/plain", nil];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSInteger statusCode = operation.response.statusCode;
         
         if(statusCode == 200)
         {
             if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
             {
                 if(self.requestType == HTTPRequestTypAllAnnouncementInfo)
                 {
                     if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                     {
                        [self.delegate dataFromWebReceivedSuccessfully:[self parseAllAnnouncements:responseObject]];
                     }
                 }
             }

         }
         else
         {
             if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
             {
                 if(self.requestType == HTTPRequestTypAllAnnouncementInfo)
                 {
                     if([self.delegate respondsToSelector:@selector(dataFromWebDidnotReceiveSuccessMessage:)])
                     {
                         [self.delegate dataFromWebDidnotReceiveSuccessMessage:statusCode];
                     }
                 }
             }
         }
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"error is %@",error.debugDescription);
         
         
         if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
         {
             //DebugLog(@"Object conforms this protocol.");
             if([self.delegate respondsToSelector:@selector(dataFromWebReceiptionFailed:)])
             {
                 // DebugLog(@"Object responds to this selector.");
                 [self.delegate dataFromWebReceiptionFailed:error];
             }
             else
             {
                 //DebugLog(@"Object Doesn't respond to this selector.");
             }
         }
         else
         {
             //DebugLog(@"Object Doesn't conform this protocol.");
         }
         
     }
     ];
    
}


-(void) updateBulletinWithData:(NSDictionary *)postData withUrlStr:(NSString *)urlStr withImageData:(NSData *)imageData
{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSError *error;
    NSURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:urlStr parameters:postData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(imageData.length > 0)
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];

    } error:&error];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSInteger statusCode = operation.response.statusCode;
        
        if(statusCode == 200)
        {
            if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
            {
                if(self.requestType == HTTPRequestTypAnnouncementInsert)
                {
                    if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                    {
                        [self.delegate dataFromWebReceivedSuccessfully:responseObject];
                    }
                }
            }
            
        }
        else
        {
            if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
            {
                if(self.requestType == HTTPRequestTypAllAnnouncementInfo)
                {
                    if([self.delegate respondsToSelector:@selector(dataFromWebDidnotReceiveSuccessMessage:)])
                    {
                        [self.delegate dataFromWebDidnotReceiveSuccessMessage:statusCode];
                    }
                }
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
        {
            
            NSLog(@"error is %@",error.description);
            
            //DebugLog(@"Object conforms this protocol.");
            if([self.delegate respondsToSelector:@selector(dataFromWebReceiptionFailed:)])
            {
                // DebugLog(@"Object responds to this selector.");
                [self.delegate dataFromWebReceiptionFailed:error];
            }
            else
            {
                //DebugLog(@"Object Doesn't respond to this selector.");
            }
        }

    }];
    
    [manager.operationQueue addOperation:operation];
    
    
}


-(void) sendBulletinWithData:(NSDictionary *)postData withUrlStr:(NSString *)urlStr withImageData:(NSData *)imageData forAPI:(NSString *)apiName
{
        
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    
    AFHTTPRequestOperation *op = [manager POST:apiName parameters:postData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        if(imageData.length > 0)
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSInteger statusCode = operation.response.statusCode;
        
        if(statusCode == 200)
        {
            if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
            {
                if(self.requestType == HTTPRequestTypAnnouncementInsert)
                {
                    if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                    {
                        [self.delegate dataFromWebReceivedSuccessfully:responseObject];
                    }
                }
            }
            
        }
        else
        {
            if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
            {
                if(self.requestType == HTTPRequestTypAllAnnouncementInfo)
                {
                    if([self.delegate respondsToSelector:@selector(dataFromWebDidnotReceiveSuccessMessage:)])
                    {
                        [self.delegate dataFromWebDidnotReceiveSuccessMessage:statusCode];
                    }
                }
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
        {
            
            NSLog(@"error is %@",error.description);
            
            //DebugLog(@"Object conforms this protocol.");
            if([self.delegate respondsToSelector:@selector(dataFromWebReceiptionFailed:)])
            {
                // DebugLog(@"Object responds to this selector.");
                [self.delegate dataFromWebReceiptionFailed:error];
            }
            else
            {
                //DebugLog(@"Object Doesn't respond to this selector.");
            }
        }

    }];
    
    [op start];
    
    
}

-(void) deleteBulletinwithId:(NSString *)bulletinId UrlStr:(NSString *)urlStr
{
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"text/plain",@"text/xml", nil];
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:bulletinId,@"bulletinID",nil];
    [manager DELETE:urlStr parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSInteger statusCode = operation.response.statusCode;
         
         if(statusCode == 200)
         {
             if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
             {
                 if(self.requestType == HTTPRequestTypAnnouncementDelete)
                 {
                     if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                     {
                         [self.delegate dataFromWebReceivedSuccessfully:responseObject];
                     }
                 }
             }
             
         }
         else
         {
             if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
             {
                 if(self.requestType == HTTPRequestTypAllAnnouncementInfo)
                 {
                     if([self.delegate respondsToSelector:@selector(dataFromWebDidnotReceiveSuccessMessage:)])
                     {
                         [self.delegate dataFromWebDidnotReceiveSuccessMessage:statusCode];
                     }
                 }
             }
         }
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
         {
             
             NSLog(@"error is %@",error.description);
             
             //DebugLog(@"Object conforms this protocol.");
             if([self.delegate respondsToSelector:@selector(dataFromWebReceiptionFailed:)])
             {
                 // DebugLog(@"Object responds to this selector.");
                 [self.delegate dataFromWebReceiptionFailed:error];
             }
             else
             {
                 //DebugLog(@"Object Doesn't respond to this selector.");
             }
         }
         else
         {
             //DebugLog(@"Object Doesn't conform this protocol.");
         }
         
     }
     ];
    

}

/*
-(void)sendBulletinWithURL:(NSString *)requestURL postData:(NSDictionary *)bulletinData
{
    
    requestURL = [requestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"text/plain",@"text/xml", nil];
    
    
   // NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"method",bookingNo,@"params[0]",lastName,@"params[1]",nil];
    
    
    [manager POST:requestURL parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
         {
             if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
             {
                 [self.delegate dataFromWebReceivedSuccessfully:[self parseBookingInfoObject:responseObject]];
             }
         }
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
         {
             
             NSLog(@"error is %@",error.description);
             
             //DebugLog(@"Object conforms this protocol.");
             if([self.delegate respondsToSelector:@selector(dataFromWebReceiptionFailed:)])
             {
                 // DebugLog(@"Object responds to this selector.");
                 [self.delegate dataFromWebReceiptionFailed:error];
             }
             else
             {
                 //DebugLog(@"Object Doesn't respond to this selector.");
             }
         }
         else
         {
             //DebugLog(@"Object Doesn't conform this protocol.");
         }
         
     }
     ];
    
    
}

*/



-(NSMutableArray *) parseAllAnnouncements :(id) response
{
    NSLog(@"Response is %@",response);
    
    NSMutableArray *Announcements = [NSMutableArray new];
    NSArray *tempArray = (NSArray *)response;
    NSDateFormatter* formatterUtc = [[NSDateFormatter alloc] init];
    NSDateFormatter* formatterLocal = [[NSDateFormatter alloc] init];
    for(NSInteger i= 0; i < tempArray.count; i++)
    {
        AnnounceObject *object = [AnnounceObject new];
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"id"]isKindOfClass:[NSNumber class]])
        {
            object.announceId = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] valueForKey:@"id"]];
        }
        else
        {
            object.announceId = @"";
        }
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"title"]isKindOfClass:[NSString class]])
        {
            object.announceTitle = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] valueForKey:@"title"]];
        }
        else
        {
            object.announceTitle = @"";
        }
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"categoryName"]isKindOfClass:[NSString class]])
        {
            if([[[tempArray objectAtIndex:i] valueForKey:@"categoryName"] isEqualToString:@"Announcements"])
            {
                object.announceCategory = @"Announcements";
            }
            else if ([[[tempArray objectAtIndex:i] valueForKey:@"categoryName"] isEqualToString:@"Offers"])
            {
                object.announceCategory = @"Offers";
            }
            
        }
        else
        {
            object.announceCategory = @"";
        }
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"descriptions"]isKindOfClass:[NSArray class]])
        {
            object.announceDescription = [NSString stringWithFormat:@"%@",[[[tempArray objectAtIndex:i] valueForKey:@"descriptions"] objectAtIndex:0]];
        }
        else
        {
            object.announceDescription = @"";
        }
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"sendTimes"]isKindOfClass:[NSArray class]])
        {
            NSArray *scheduleTimes = [[tempArray objectAtIndex:i] valueForKey:@"sendTimes"];
            object.scheduleArray = [NSMutableArray new];
            
            for(NSInteger j = 0; j < scheduleTimes.count; j++)
            {
                NSString *input = [scheduleTimes objectAtIndex:j];
                input = [input stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                [formatterUtc setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                // Cast the input string to NSDate
                NSDate* utcDate = [formatterUtc dateFromString:input];
                [formatterLocal setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [formatterLocal setTimeZone:[NSTimeZone localTimeZone]];
                NSDate* localDate = [formatterUtc dateFromString:[formatterLocal stringFromDate:utcDate]];
                
                NSLog(@"local: %@", [NSString stringWithFormat:@"%@",localDate]);
                
                [object.scheduleArray addObject:localDate];
                //[object.scheduleArray addObject:[NSString stringWithFormat:@"%@",localDate]];
                
                
        
                //[object.scheduleArray addObject:[formatter dateFromString:date]];
                
                //if(j == 0)
                {
                    NSString *parseString = [NSString stringWithFormat:@"%@",localDate];
                    object.scheduleTime = [parseString substringWithRange:NSMakeRange(11, 5)];
                }
            }
        }
        else
        {
            object.scheduleArray = [NSMutableArray new];
        }
        
        object.announceImageUrlStr = @"";
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"images"]isKindOfClass:[NSArray class]])
        {
            for(NSInteger j=0; j < [[[tempArray objectAtIndex:i] valueForKey:@"images"] count]; j++)
                 object.announceImageUrlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"baseUrl"],[[[tempArray objectAtIndex:i] valueForKey:@"images"]objectAtIndex:0]];
        }

       // http://192.168.1.223/uploads/123_ba97b093-7c29-4c34-9aca-930e28915720_photo.jpg
        //NSLog(@"Id %@ title %@ time %@",object.announceId,object.announceTitle,object.scheduleArray);
        
        [Announcements addObject:object];
    }
    
    return Announcements;
}




@end