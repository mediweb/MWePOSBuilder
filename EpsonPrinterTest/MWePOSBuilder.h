//
//  MWePOSBuilder.h
//  EpsonPrinterTest
//
//  Created by Matt on 7/16/13.
//  Copyright (c) 2013 Matthew Gillingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface MWePOSBuilder : NSObject

- (void)addFeedUnit:(NSInteger)unit;
- (void)addFeedLine:(NSInteger)line;
- (void)addText:(NSString*)data;
- (void)addTextLang:(NSString*)lang;
- (void)addTextAlign:(NSString *)align;
- (void)addTextRotate:(BOOL)rotate;
- (void)addTextLineSpace:(NSInteger)linespc;
- (void)addTextFont:(NSString *)font;
- (void)addTextSmooth:(BOOL)smooth;
- (void)addTextDoubleWidth:(BOOL)doubleWidth doubleHeight:(BOOL)doubleHeight;
- (void)addTextSizeWithWidth:(NSInteger)width height:(NSInteger)height;
- (void)addTextStyleWitReverse:(BOOL)reverse underline:(BOOL)underline emphasis:(BOOL)emphasis color:(NSString*)color;
- (void)addLogoWithKey1:(NSInteger)key1 key2:(NSInteger)key2;
- (void)addBarcodeWithData:(NSString *)data type:(NSString*)type hri:(NSString*)hri font:(NSString*)font width:(NSInteger)width height:(NSInteger)height;
- (void)addSymbolWithData:(NSString*)data type:(NSString*)type level:(NSString*)level width:(NSInteger)width height:(NSInteger)height size:(NSInteger)size;

//TODO: Add addCommand

- (void)addHLineWithStartPosition:(NSInteger)x1 endPosition:(NSInteger)x2 style:(NSString*)style;
- (void)addVLineBeginWithStartPosition:(NSInteger)x style:(NSString*)style;
- (void)addVLineEndWithPosition:(NSInteger)x style:(NSString*)style;

// TODO: Add support for page functions

- (void)addCut:(NSString *)type;
- (void)addPulseWithDrawer:(NSString *)drawer time:(NSString *)time;
- (void)addSoundWithPattern:(NSString *)pattern repeat:(NSInteger)repeat;

- (NSData *)XMLData;

@end
