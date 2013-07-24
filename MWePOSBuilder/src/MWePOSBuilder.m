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

#import "MWePOSBuilder.h"
#import "GDataXMLNode.h"
#import "MF_Base64Additions.h"
#import "UIImage+Conversion.h"

NSString * const EPOSBUILDER_FONT_A = @"font_a";
NSString * const EPOSBUILDER_FONT_B = @"font_b";
NSString * const EPOSBUILDER_FONT_C = @"font_c";
NSString * const EPOSBUILDER_FONT_SPECIAL_A = @"special_a";
NSString * const EPOSBUILDER_FONT_SPECIAL_B = @"special_b";
NSString * const EPOSBUILDER_ALIGN_LEFT = @"left";
NSString * const EPOSBUILDER_ALIGN_CENTER = @"center";
NSString * const EPOSBUILDER_ALIGN_RIGHT = @"right";
NSString * const EPOSBUILDER_COLOR_NONE = @"none";
NSString * const EPOSBUILDER_COLOR_1 = @"color_1";
NSString * const EPOSBUILDER_COLOR_2 = @"color_2";
NSString * const EPOSBUILDER_COLOR_3 = @"color_3";
NSString * const EPOSBUILDER_COLOR_4 = @"color_4";
NSString * const EPOSBUILDER_BARCODE_UPC_A = @"upc_a";
NSString * const EPOSBUILDER_BARCODE_UPC_E = @"upc_e";
NSString * const EPOSBUILDER_BARCODE_EAN13 = @"ean13";
NSString * const EPOSBUILDER_BARCODE_JAN13 = @"jan13";
NSString * const EPOSBUILDER_BARCODE_EAN8 = @"ean8";
NSString * const EPOSBUILDER_BARCODE_JAN8 = @"jan8";
NSString * const EPOSBUILDER_BARCODE_CODE39 = @"code39";
NSString * const EPOSBUILDER_BARCODE_ITF = @"itf";
NSString * const EPOSBUILDER_BARCODE_CODABAR = @"codabar";
NSString * const EPOSBUILDER_BARCODE_CODE93 = @"code93";
NSString * const EPOSBUILDER_BARCODE_CODE128 = @"code128";
NSString * const EPOSBUILDER_BARCODE_GS1_128 = @"gs1_128";
NSString * const EPOSBUILDER_BARCODE_GS1_DATABAR_OMNIDIRECTIONAL = @"gs1_databar_omnidirectional";
NSString * const EPOSBUILDER_BARCODE_GS1_DATABAR_TRUNCATED = @"gs1_databar_truncated";
NSString * const EPOSBUILDER_BARCODE_GS1_DATABAR_LIMITED = @"gs1_databar_limited";
NSString * const EPOSBUILDER_BARCODE_GS1_DATABAR_EXPANDED = @"gs1_databar_expanded";
NSString * const EPOSBUILDER_HRI_NONE = @"none";
NSString * const EPOSBUILDER_HRI_ABOVE = @"above";
NSString * const EPOSBUILDER_HRI_BELOW = @"below";
NSString * const EPOSBUILDER_HRI_BOTH = @"both";
NSString * const EPOSBUILDER_SYMBOL_PDF417_STANDARD = @"pdf417_standard";
NSString * const EPOSBUILDER_SYMBOL_PDF417_TRUNCATED = @"pdf417_truncated";
NSString * const EPOSBUILDER_SYMBOL_QRCODE_MODEL_1 = @"qrcode_model_1";
NSString * const EPOSBUILDER_SYMBOL_QRCODE_MODEL_2 = @"qrcode_model_2";
NSString * const EPOSBUILDER_SYMBOL_MAXICODE_MODE_2 = @"maxicode_mode_2";
NSString * const EPOSBUILDER_SYMBOL_MAXICODE_MODE_3 = @"maxicode_mode_3";
NSString * const EPOSBUILDER_SYMBOL_MAXICODE_MODE_4 = @"maxicode_mode_4";
NSString * const EPOSBUILDER_SYMBOL_MAXICODE_MODE_5 = @"maxicode_mode_5";
NSString * const EPOSBUILDER_SYMBOL_MAXICODE_MODE_6 = @"maxicode_mode_6";
NSString * const EPOSBUILDER_SYMBOL_GS1_DATABAR_STACKED = @"gs1_databar_stacked";
NSString * const EPOSBUILDER_SYMBOL_GS1_DATABAR_STACKED_OMNIDIRECTIONAL = @"gs1_databar_stacked_omnidirectional";
NSString * const EPOSBUILDER_SYMBOL_GS1_DATABAR_EXPANDED_STACKED = @"gs1_databar_expanded_stacked";
NSString * const EPOSBUILDER_LEVEL_0 = @"level_0";
NSString * const EPOSBUILDER_LEVEL_1 = @"level_1";
NSString * const EPOSBUILDER_LEVEL_2 = @"level_2";
NSString * const EPOSBUILDER_LEVEL_3 = @"level_3";
NSString * const EPOSBUILDER_LEVEL_4 = @"level_4";
NSString * const EPOSBUILDER_LEVEL_5 = @"level_5";
NSString * const EPOSBUILDER_LEVEL_6 = @"level_6";
NSString * const EPOSBUILDER_LEVEL_7 = @"level_7";
NSString * const EPOSBUILDER_LEVEL_8 = @"level_8";
NSString * const EPOSBUILDER_LEVEL_L = @"level_l";
NSString * const EPOSBUILDER_LEVEL_M = @"level_m";
NSString * const EPOSBUILDER_LEVEL_Q = @"level_q";
NSString * const EPOSBUILDER_LEVEL_H = @"level_h";
NSString * const EPOSBUILDER_LEVEL_DEFAULT = @"default";
NSString * const EPOSBUILDER_LINE_THIN = @"thin";
NSString * const EPOSBUILDER_LINE_MEDIUM = @"medium";
NSString * const EPOSBUILDER_LINE_THICK = @"thick";
NSString * const EPOSBUILDER_LINE_THIN_DOUBLE = @"thin_double";
NSString * const EPOSBUILDER_LINE_MEDIUM_DOUBLE = @"medium_double";
NSString * const EPOSBUILDER_LINE_THICK_DOUBLE = @"thick_double";
NSString * const EPOSBUILDER_DIRECTION_LEFT_TO_RIGHT = @"left_to_right";
NSString * const EPOSBUILDER_DIRECTION_BOTTOM_TO_TOP = @"bottom_to_top";
NSString * const EPOSBUILDER_DIRECTION_RIGHT_TO_LEFT = @"right_to_left";
NSString * const EPOSBUILDER_DIRECTION_TOP_TO_BOTTOM = @"top_to_bottom";
NSString * const EPOSBUILDER_CUT_NO_FEED = @"no_feed";
NSString * const EPOSBUILDER_CUT_FEED = @"feed";
NSString * const EPOSBUILDER_CUT_RESERVE = @"reserve";
NSString * const EPOSBUILDER_DRAWER_1 = @"drawer_1";
NSString * const EPOSBUILDER_DRAWER_2 = @"drawer_2";
NSString * const EPOSBUILDER_PULSE_100 = @"pulse_100";
NSString * const EPOSBUILDER_PULSE_200 = @"pulse_200";
NSString * const EPOSBUILDER_PULSE_300 = @"pulse_300";
NSString * const EPOSBUILDER_PULSE_400 = @"pulse_400";
NSString * const EPOSBUILDER_PULSE_500 = @"pulse_500";
NSString * const EPOSBUILDER_PATTERN_NONE = @"none";
NSString * const EPOSBUILDER_PATTERN_A = @"pattern_a";
NSString * const EPOSBUILDER_PATTERN_B = @"pattern_b";
NSString * const EPOSBUILDER_PATTERN_C = @"pattern_c";
NSString * const EPOSBUILDER_PATTERN_D = @"pattern_d";
NSString * const EPOSBUILDER_PATTERN_E = @"pattern_e";
NSString * const EPOSBUILDER_PATTERN_ERROR = @"error";
NSString * const EPOSBUILDER_PATTERN_PAPER_END = @"paper_end";

static NSString * const regexFont = @"(font_[abc]|special_[ab])$";
static NSString * const regexAlign = @"(left|center|right)$";
static NSString * const regexColor = @"(none|color_[1-4])$";
static NSString * const regexBarcode = @"(upc_[ae]|[ej]an13|[ej]an8|code(39|93|128)|itf|codabar|gs1_128|gs1_databar_(omnidirectional|truncated|limited|expanded))$";
static NSString * const regexHri = @"(none|above|below|both)$";
static NSString * const regexSymbol = @"(pdf417_(standard|truncated)|qrcode_model_[12]|maxicode_mode_[2-6]|gs1_databar_(stacked(_omnidirectional)?|expanded_stacked))$";
static NSString * const regexLevel = @"(level_[0-8lmqh]|default)$";
static NSString * const regexLine = @"(thin|medium|thick)(_double)?$";
static NSString * const regexDirection = @"(left_to_right|bottom_to_top|right_to_left|top_to_bottom)$";
static NSString * const regexCut = @"(no_feed|feed|reserve)$";
static NSString * const regexDrawer = @"(drawer_1|drawer_2)$";
static NSString * const regexPulse = @"pulse_[1-5]00$";
static NSString * const regexPattern = @"(none|pattern_[a-e]|error|paper_end)$";

@interface MWePOSBuilder ()
@property (nonatomic, strong) GDataXMLElement *rootElement;
@end

@implementation MWePOSBuilder

NSData * encodeRasterData(UIImage *context, NSUInteger width, NSUInteger height) {
  NSUInteger d8[][8] = {
    {0, 32, 8, 40, 2, 34, 10, 42},
    {48, 16, 56, 24, 50, 18, 58, 26},
    {12, 44, 4, 36, 14, 46, 6, 38},
    {60, 28, 52, 20, 62, 30, 54, 22},
    {3, 35, 11, 43, 1, 33, 9, 41},
    {51, 19, 59, 27, 49, 17, 57, 25},
    {15, 47, 7, 39, 13, 45, 5, 37},
    {63, 31, 55, 23, 61, 29, 53, 21}
  };

  NSMutableData *s = [[NSMutableData alloc] init];
  
  unsigned char * data = [context bitmapRGBA8Representation];
  unichar n = 0;
  NSUInteger p = 0;
  
  for (NSUInteger y = 0; y < height; y++) {
    for (NSUInteger x = 0; x < width; x++) {
      unsigned char r = data[p++];
      unsigned char g = data[p++];
      unsigned char b = data[p++];
      unsigned char a = data[p++];
      
      double v = 255.0 - a + ((r * 29891.0 + g * 58661.0 + b * 11448.0) * a + 12750000.0) / 25500000.0;
      long d = (d8[y & 7][x & 7] << 2) + 2;

      if (v < d) {
        n |= 0x80 >> (x & 7);
      }
      
      if ((x & 7) == 7 || x == width - 1) {
        unichar bytes = n == 16 ? 32 : n;
        [s appendBytes:&bytes length:1];
        n = 0;
      }
    }
  }
  
  return s;
}

static GDataXMLNode * getEnumAttr(NSString *name, NSString *value, NSString *pattern) {
  NSError *error = nil;

  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:&error];
  NSCAssert1([regex
    numberOfMatchesInString:value
    options:0
    range:NSMakeRange(0, value.length)], @"Parameter %@ is invalid", value);
  return [GDataXMLNode attributeWithName:name stringValue:value];
}

static GDataXMLNode * getBoolAttr(NSString *name, BOOL value) {
  return [GDataXMLNode attributeWithName:name stringValue:[@(value) stringValue]];
}

static GDataXMLNode * getIntAttr(NSString *name, NSInteger value, NSInteger min, NSInteger max) {
  NSCAssert1(value >= min && value <= max, @"Parameter %d is invalid", value);
  return [GDataXMLNode attributeWithName:name stringValue:[@(value) stringValue]];
}

static GDataXMLNode * getUByteAttr(NSString *name, NSInteger value) {
  return getIntAttr(name, value, 0, 255);
}

static GDataXMLNode * getUShortAttr(NSString *name, NSInteger value) {
  return getIntAttr(name, value, 0, 65535);
}

- (id)init {
  if (self = [super init]) {
    self.rootElement = [GDataXMLElement elementWithName:@"epos-print"];
    [self.rootElement addAttribute:[GDataXMLNode
      attributeWithName:@"xmlns"
      stringValue:@"http://www.epson-pos.com/schemas/2011/03/epos-print"]];
  }
  return self;
}

- (void)addFeedUnit:(NSInteger)unit {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"feed"];
  [node addAttribute:getUByteAttr(@"unit", unit)];
  [self.rootElement addChild:node];
}

- (void)addFeedLine:(NSInteger)line {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"feed"];
  [node addAttribute:getUByteAttr(@"line", line)];
  [self.rootElement addChild:node];
}

- (void)addText:(NSString*)data {
  //TODO: XML Encoding
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"text"];
  [node setStringValue:data];
  [self.rootElement addChild:node];
}

- (void)addTextLang:(NSString*)lang {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"text"];
  [node addAttribute:[GDataXMLNode attributeWithName:@"lang" stringValue:lang]];
  [self.rootElement addChild:node];
}

- (void)addTextAlign:(NSString *)align {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"text"];
  [node addAttribute:getEnumAttr(@"align", align, regexAlign)];
  [self.rootElement addChild:node];
}

- (void)addTextRotate:(BOOL)rotate {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"text"];
  [node addAttribute:getBoolAttr(@"rotate", rotate)];
  [self.rootElement addChild:node];
}

- (void)addTextLineSpace:(NSInteger)linespc {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"text"];
  [node addAttribute:getUByteAttr(@"linespc", linespc)];
  [self.rootElement addChild:node];
}

- (void)addTextFont:(NSString *)font {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"text"];
  [node addAttribute:getEnumAttr(@"font", font, regexFont)];
  [self.rootElement addChild:node];
}

- (void)addTextSmooth:(BOOL)smooth {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"text"];
  [node addAttribute:getBoolAttr(@"smooth", smooth)];
  [self.rootElement addChild:node];
}

- (void)addTextDoubleWidth:(BOOL)doubleWidth doubleHeight:(BOOL)doubleHeight {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"text"];
  
  if (doubleWidth) {
    [node addAttribute:getBoolAttr(@"dw", doubleWidth)];
  }
  
  if (doubleHeight) {
    [node addAttribute:getBoolAttr(@"dh", doubleHeight)];
  }
  
  [self.rootElement addChild:node];
}

- (void)addTextSizeWithWidth:(NSInteger)width height:(NSInteger)height {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"text"];
  
  [node addAttribute:getIntAttr(@"width", width, 1, 8)];
  [node addAttribute:getIntAttr(@"height", height, 1, 8)];
  
  [self.rootElement addChild:node];
}

- (void)addTextStyleWitReverse:(BOOL)reverse underline:(BOOL)underline emphasis:(BOOL)emphasis color:(NSString*)color {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"text"];
  
  if (reverse) {
    [node addAttribute:getBoolAttr(@"reverse", reverse)];
  }
  
  if (underline) {
    [node addAttribute:getBoolAttr(@"ul", underline)];
  }
  
  if (emphasis) {
    [node addAttribute:getBoolAttr(@"em", emphasis)];
  }
  
  if (color) {
    [node addAttribute:getEnumAttr(@"color", color, regexColor)];
  }
  
  [self.rootElement addChild:node];
}

- (void)addLogoWithKey1:(NSInteger)key1 key2:(NSInteger)key2 {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"logo"];
  
  [node addAttribute:getUByteAttr(@"key1", key1)];
  [node addAttribute:getUByteAttr(@"key2", key2)];
  
  [self.rootElement addChild:node];
}

- (void)addBarcodeWithData:(NSString *)data
 type:(NSString*)type
 hri:(NSString*)hri
 font:(NSString*)font
 width:(NSInteger)width
 height:(NSInteger)height {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"barcode"];

  [node addAttribute:getEnumAttr(@"type", type, regexBarcode)];
  
  if (hri) {
    [node addAttribute:getEnumAttr(@"hri", hri, regexHri)];
  }

  if (font) {
    [node addAttribute:getEnumAttr(@"font", font, regexFont)];
  }

  if (width > 0) {
    [node addAttribute:getUByteAttr(@"width", width)];
  }

  if (height > 0) {
    [node addAttribute:getUByteAttr(@"height", height)];
  }
  
  //TODO: Encode and escape data
  [node setStringValue:data];
  
  [self.rootElement addChild:node];
}

- (void)addSymbolWithData:(NSString*)data type:(NSString*)type level:(NSString*)level width:(NSInteger)width height:(NSInteger)height size:(NSInteger)size {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"symbol"];
  
  [node addAttribute:getEnumAttr(@"type", type, regexSymbol)];
  
  if (level) {
    [node addAttribute:getEnumAttr(@"level", level, regexLevel)];
  }
  
  if (width > 0) {
    [node addAttribute:getUByteAttr(@"width", width)];
  }

  if (height > 0) {
    [node addAttribute:getUByteAttr(@"height", height)];
  }
  
  if (size > 0) {
    [node addAttribute:getUShortAttr(@"size", size)];
  }
  
  //TODO: Encode and escape data
  [node setStringValue:data];
  
  [self.rootElement addChild:node];
}

- (void)addImage:(UIImage *)context x:(NSInteger)x y:(NSInteger)y width:(NSInteger)width height:(NSInteger)height color:(NSString*)color {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"image"];
  
  getUShortAttr(@"x", x);
  getUShortAttr(@"y", y);
  
  [node addAttribute:getUShortAttr(@"width", width)];
  [node addAttribute:getUShortAttr(@"height", height)];
  
  if (color) {
    [node addAttribute:getEnumAttr(@"color", color, regexColor)];
  }
  
  CGRect rect = CGRectMake(x, y, width, height);
  CGImageRef imageRef = CGImageCreateWithImageInRect(context.CGImage, rect);
  UIImage *result = [UIImage imageWithCGImage:imageRef];
  
  NSData *rasterData = encodeRasterData(result, width, height);
    
  [node setStringValue:[rasterData base64String]];

  [self.rootElement addChild:node];
}

- (void)addHLineWithStartPosition:(NSInteger)x1 endPosition:(NSInteger)x2 style:(NSString*)style {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"hline"];
  
  [node addAttribute:getUShortAttr(@"x1", x1)];
  [node addAttribute:getUShortAttr(@"x2", x2)];
  
  if (style) {
    [node addAttribute:getEnumAttr(@"style", style, regexLevel)];
  }
  
  [self.rootElement addChild:node];
}

- (void)addVLineBeginWithStartPosition:(NSInteger)x style:(NSString*)style {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"vline-begin"];
  
  [node addAttribute:getUShortAttr(@"x", x)];
  
  if (style) {
    [node addAttribute:getEnumAttr(@"style", style, regexLevel)];
  }
  
  [self.rootElement addChild:node];
}

- (void)addVLineEndWithPosition:(NSInteger)x style:(NSString*)style {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"vline-end"];
  
  [node addAttribute:getUShortAttr(@"x", x)];
  
  if (style) {
    [node addAttribute:getEnumAttr(@"style", style, regexLevel)];
  }
  
  [self.rootElement addChild:node];
}

// TODO: Add support for page functions

- (void)addCut:(NSString *)type {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"cut"];
  
  [node addAttribute:getEnumAttr(@"type", type, regexCut)];
  
  [self.rootElement addChild:node];
}

- (void)addPulseWithDrawer:(NSString *)drawer time:(NSString *)time {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"pulse"];
  
  if (drawer) {
    [node addAttribute:getEnumAttr(@"drawer", drawer, regexDrawer)];
  }
  
  if (time) {
    [node addAttribute:getEnumAttr(@"time", time, regexPulse)];
  }
  
  [self.rootElement addChild:node];
}

- (void)addSoundWithPattern:(NSString *)pattern repeat:(NSInteger)repeat {
  GDataXMLElement *node = [GDataXMLElement elementWithName:@"sound"];
  
  if (pattern) {
    [node addAttribute:getEnumAttr(@"pattern", pattern, regexPattern)];
  }
  
  if (repeat) {
    [node addAttribute:getUByteAttr(@"repeat", repeat)];
  }
  
  [self.rootElement addChild:node];
}

- (NSData *)printerData {
  GDataXMLElement *envelopeNode = [GDataXMLElement elementWithName:@"s:Envelope"];
  [envelopeNode addAttribute:[GDataXMLNode
    attributeWithName:@"xmlns:s"
    stringValue:@"http://schemas.xmlsoap.org/soap/envelope/"]];
  
  GDataXMLElement *bodyNode = [GDataXMLElement elementWithName:@"s:Body"];
  [bodyNode addChild:self.rootElement];
  
  [envelopeNode addChild:bodyNode];

  GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:envelopeNode];
  
  return [document XMLData];
}

@end
