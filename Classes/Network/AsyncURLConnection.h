//
//  AsyncURLConnection.h
//  DevedUp
//
//  Created by David Casserly on 19/01/2012.
//  Copyright (c) 2012 DevedUp Ltd. All rights reserved.
//

/*
    USAGE:
 

  AsyncURLConnection -request:completeBlock:errorBlock: have to be called
  from Main Thread because it is required to use asynchronous API with RunLoop.


[AsyncURLConnection request:url completeBlock:^(NSData *data) {
    
    // success! 
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
       //process downloaded data in Concurrent Queue 
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // update UI on Main Thread 
            
        });
    });
    
 } errorBlock:^(NSError *error) {
    
    // error!
    
}];

 */

#import <Foundation/Foundation.h>

typedef void (^completeBlock_t)(NSData *data);
typedef void (^errorBlock_t)(NSError *error);

@interface AsyncURLConnection : NSObject
{
    NSMutableData *data_;
    completeBlock_t completeBlock_;
    errorBlock_t errorBlock_;
}

+ (id)request:(NSString *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
- (id)initWithRequest:(NSString *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;

@end