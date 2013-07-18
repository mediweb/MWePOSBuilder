//
//  MWePOSPrint.m
//  EpsonPrinterTest
//
//  Created by Matt on 7/17/13.
//  Copyright (c) 2013 Matthew Gillingham. All rights reserved.
//

#import "MWePOSPrint.h"

static NSString * const kDevidDefault = @"local_printer";

@implementation MWePOSPrint

- (id)initWithPrinterURL:(NSURL*)printerURL {
  return [self initWithPrinterURL:printerURL devid:kDevidDefault timeout:10000];
}

- (id)initWithPrinterURL:(NSURL*)printerURL
 devid:(NSString*)devid
 timeout:(NSTimeInterval)timeout {
  if (self = [super init]) {
    _devid = nil != devid ? devid : kDevidDefault;
    _timeout = timeout;
    _printerURL = [NSURL
      URLWithString:[NSString stringWithFormat:@"?devid=%@&timeout=%f", self.devid, self.timeout]
      relativeToURL:printerURL];
  }
  return self;
}

- (void)sendData:(NSData*)data
 completion:(void(^)(NSData *data, NSError *error))completion {
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.printerURL];
  urlRequest.HTTPMethod = @"POST";
  urlRequest.HTTPBody = data;
  
  [NSURLConnection
    sendAsynchronousRequest:urlRequest
    queue:[NSOperationQueue mainQueue]
    completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError* error) {
      if (completion) {
        completion(data, error);
      }
  }];
}

@end
