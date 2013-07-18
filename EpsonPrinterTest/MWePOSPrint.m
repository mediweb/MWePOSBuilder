//
//  MWePOSPrint.m
//  EpsonPrinterTest
//
//  Created by Matt on 7/17/13.
//  Copyright (c) 2013 Matthew Gillingham. All rights reserved.
//

#import "MWePOSPrint.h"
#import "AFHTTPRequestOperation.h"

@implementation MWePOSPrint

+ (void)sendData:(NSData*)data toURL:(NSURL*)url {
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  urlRequest.HTTPMethod = @"POST";
  urlRequest.HTTPBody = data;
  
  [NSURLConnection
    sendAsynchronousRequest:urlRequest
    queue:[NSOperationQueue mainQueue]
    completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError* error) {
      
  }];
}

@end
