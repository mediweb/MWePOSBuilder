//
//  MWePOSPrint.h
//  EpsonPrinterTest
//
//  Created by Matt on 7/17/13.
//  Copyright (c) 2013 Matthew Gillingham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWePOSPrint : NSObject

@property (readonly, strong, nonatomic) NSURL *printerURL;
@property (readonly, strong, nonatomic) NSString *devid;
@property (readonly, nonatomic) NSTimeInterval timeout;

- (id)initWithPrinterURL:(NSURL*)printerURL;
- (id)initWithPrinterURL:(NSURL*)printerURL devid:(NSString*)devid timeout:(NSTimeInterval)timeout;
- (void)sendData:(NSData*)data completion:(void(^)(NSData *data, NSError *error))completion;

@end
