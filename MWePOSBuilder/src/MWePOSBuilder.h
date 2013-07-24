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

#import <Foundation/Foundation.h>

extern NSString * const EPOSBUILDER_FONT_A;
extern NSString * const EPOSBUILDER_FONT_B;
extern NSString * const EPOSBUILDER_FONT_C;
extern NSString * const EPOSBUILDER_FONT_SPECIAL_A;
extern NSString * const EPOSBUILDER_FONT_SPECIAL_B;
extern NSString * const EPOSBUILDER_ALIGN_LEFT;
extern NSString * const EPOSBUILDER_ALIGN_CENTER;
extern NSString * const EPOSBUILDER_ALIGN_RIGHT;
extern NSString * const EPOSBUILDER_COLOR_NONE;
extern NSString * const EPOSBUILDER_COLOR_1;
extern NSString * const EPOSBUILDER_COLOR_2;
extern NSString * const EPOSBUILDER_COLOR_3;
extern NSString * const EPOSBUILDER_COLOR_4;
extern NSString * const EPOSBUILDER_BARCODE_UPC_A;
extern NSString * const EPOSBUILDER_BARCODE_UPC_E;
extern NSString * const EPOSBUILDER_BARCODE_EAN13;
extern NSString * const EPOSBUILDER_BARCODE_JAN13;
extern NSString * const EPOSBUILDER_BARCODE_EAN8;
extern NSString * const EPOSBUILDER_BARCODE_JAN8;
extern NSString * const EPOSBUILDER_BARCODE_CODE39;
extern NSString * const EPOSBUILDER_BARCODE_ITF;
extern NSString * const EPOSBUILDER_BARCODE_CODABAR;
extern NSString * const EPOSBUILDER_BARCODE_CODE93;
extern NSString * const EPOSBUILDER_BARCODE_CODE128;
extern NSString * const EPOSBUILDER_BARCODE_GS1_128;
extern NSString * const EPOSBUILDER_BARCODE_GS1_DATABAR_OMNIDIRECTIONAL;
extern NSString * const EPOSBUILDER_BARCODE_GS1_DATABAR_TRUNCATED;
extern NSString * const EPOSBUILDER_BARCODE_GS1_DATABAR_LIMITED;
extern NSString * const EPOSBUILDER_BARCODE_GS1_DATABAR_EXPANDED;
extern NSString * const EPOSBUILDER_HRI_NONE;
extern NSString * const EPOSBUILDER_HRI_ABOVE;
extern NSString * const EPOSBUILDER_HRI_BELOW;
extern NSString * const EPOSBUILDER_HRI_BOTH;
extern NSString * const EPOSBUILDER_SYMBOL_PDF417_STANDARD;
extern NSString * const EPOSBUILDER_SYMBOL_PDF417_TRUNCATED;
extern NSString * const EPOSBUILDER_SYMBOL_QRCODE_MODEL_1;
extern NSString * const EPOSBUILDER_SYMBOL_QRCODE_MODEL_2;
extern NSString * const EPOSBUILDER_SYMBOL_MAXICODE_MODE_2;
extern NSString * const EPOSBUILDER_SYMBOL_MAXICODE_MODE_3;
extern NSString * const EPOSBUILDER_SYMBOL_MAXICODE_MODE_4;
extern NSString * const EPOSBUILDER_SYMBOL_MAXICODE_MODE_5;
extern NSString * const EPOSBUILDER_SYMBOL_MAXICODE_MODE_6;
extern NSString * const EPOSBUILDER_SYMBOL_GS1_DATABAR_STACKED;
extern NSString * const EPOSBUILDER_SYMBOL_GS1_DATABAR_STACKED_OMNIDIRECTIONAL;
extern NSString * const EPOSBUILDER_SYMBOL_GS1_DATABAR_EXPANDED_STACKED;
extern NSString * const EPOSBUILDER_LEVEL_0;
extern NSString * const EPOSBUILDER_LEVEL_1;
extern NSString * const EPOSBUILDER_LEVEL_2;
extern NSString * const EPOSBUILDER_LEVEL_3;
extern NSString * const EPOSBUILDER_LEVEL_4;
extern NSString * const EPOSBUILDER_LEVEL_5;
extern NSString * const EPOSBUILDER_LEVEL_6;
extern NSString * const EPOSBUILDER_LEVEL_7;
extern NSString * const EPOSBUILDER_LEVEL_8;
extern NSString * const EPOSBUILDER_LEVEL_L;
extern NSString * const EPOSBUILDER_LEVEL_M;
extern NSString * const EPOSBUILDER_LEVEL_Q;
extern NSString * const EPOSBUILDER_LEVEL_H;
extern NSString * const EPOSBUILDER_LEVEL_DEFAULT;
extern NSString * const EPOSBUILDER_LINE_THIN;
extern NSString * const EPOSBUILDER_LINE_MEDIUM;
extern NSString * const EPOSBUILDER_LINE_THICK;
extern NSString * const EPOSBUILDER_LINE_THIN_DOUBLE;
extern NSString * const EPOSBUILDER_LINE_MEDIUM_DOUBLE;
extern NSString * const EPOSBUILDER_LINE_THICK_DOUBLE;
extern NSString * const EPOSBUILDER_DIRECTION_LEFT_TO_RIGHT;
extern NSString * const EPOSBUILDER_DIRECTION_BOTTOM_TO_TOP;
extern NSString * const EPOSBUILDER_DIRECTION_RIGHT_TO_LEFT;
extern NSString * const EPOSBUILDER_DIRECTION_TOP_TO_BOTTOM;
extern NSString * const EPOSBUILDER_CUT_NO_FEED;
extern NSString * const EPOSBUILDER_CUT_FEED;
extern NSString * const EPOSBUILDER_CUT_RESERVE;
extern NSString * const EPOSBUILDER_DRAWER_1;
extern NSString * const EPOSBUILDER_DRAWER_2;
extern NSString * const EPOSBUILDER_PULSE_100;
extern NSString * const EPOSBUILDER_PULSE_200;
extern NSString * const EPOSBUILDER_PULSE_300;
extern NSString * const EPOSBUILDER_PULSE_400;
extern NSString * const EPOSBUILDER_PULSE_500;
extern NSString * const EPOSBUILDER_PATTERN_NONE;
extern NSString * const EPOSBUILDER_PATTERN_A;
extern NSString * const EPOSBUILDER_PATTERN_B;
extern NSString * const EPOSBUILDER_PATTERN_C;
extern NSString * const EPOSBUILDER_PATTERN_D;
extern NSString * const EPOSBUILDER_PATTERN_E;
extern NSString * const EPOSBUILDER_PATTERN_ERROR;
extern NSString * const EPOSBUILDER_PATTERN_PAPER_EN;

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
- (void)addImage:(UIImage *)context x:(NSInteger)x y:(NSInteger)y width:(NSInteger)width height:(NSInteger)height color:(NSString*)color;

//TODO: Add addCommand

- (void)addHLineWithStartPosition:(NSInteger)x1 endPosition:(NSInteger)x2 style:(NSString*)style;
- (void)addVLineBeginWithStartPosition:(NSInteger)x style:(NSString*)style;
- (void)addVLineEndWithPosition:(NSInteger)x style:(NSString*)style;

// TODO: Add support for page functions

- (void)addCut:(NSString *)type;
- (void)addPulseWithDrawer:(NSString *)drawer time:(NSString *)time;
- (void)addSoundWithPattern:(NSString *)pattern repeat:(NSInteger)repeat;

- (NSData *)printerData;

@end
