//
//  MWePOSPrint.h
//  EpsonPrinterTest
//
//  Created by Matt on 7/17/13.
//  Copyright (c) 2013 Matthew Gillingham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWePOSPrint : NSObject

+ (void)sendData:(NSData*)data toURL:(NSURL*)url;

@end
