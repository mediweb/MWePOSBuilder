// Copyright (C) 2013 MediWeb, Inc.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
