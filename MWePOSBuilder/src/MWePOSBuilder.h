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
