//
//  MWePOSBuilder.m
//  EpsonPrinterTest
//
//  Created by Matt on 7/16/13.
//  Copyright (c) 2013 Matthew Gillingham. All rights reserved.
//

#import "MWePOSBuilder.h"
#import "GDataXMLNode.h"
#import "MF_Base64Additions.h"

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

NSData * encodeRasterData(UIImage *context, NSInteger width, NSInteger height) {
  long d8[][8] = {
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
  
  unsigned char * data = [MWePOSBuilder convertUIImageToBitmapRGBA8:context];
  unichar n = 0;
  int p = 0;
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
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

+ (unsigned char *) convertUIImageToBitmapRGBA8:(UIImage *) image {

	CGImageRef imageRef = image.CGImage;

	// Create a bitmap context to draw the uiimage into
	CGContextRef context = [self newBitmapRGBA8ContextFromImage:imageRef];

	if(!context) {
		return NULL;
	}

	size_t width = CGImageGetWidth(imageRef);
	size_t height = CGImageGetHeight(imageRef);

	CGRect rect = CGRectMake(0, 0, width, height);

	// Draw image into the context to get the raw image data
	CGContextDrawImage(context, rect, imageRef);

	// Get a pointer to the data	
	unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);

	// Copy the data and release the memory (return memory allocated with new)
	size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
	size_t bufferLength = bytesPerRow * height;

	unsigned char *newBitmap = NULL;

	if(bitmapData) {
		newBitmap = (unsigned char *)malloc(sizeof(unsigned char) * bytesPerRow * height);

		if(newBitmap) {	// Copy the data
			for(int i = 0; i < bufferLength; ++i) {
				newBitmap[i] = bitmapData[i];
			}
		}

		free(bitmapData);

	} else {
		NSLog(@"Error getting bitmap pixel data\n");
	}

	CGContextRelease(context);

	return newBitmap;	
}

+ (CGContextRef) newBitmapRGBA8ContextFromImage:(CGImageRef) image {
	CGContextRef context = NULL;
	CGColorSpaceRef colorSpace;
	uint32_t *bitmapData;

	size_t bitsPerPixel = 32;
	size_t bitsPerComponent = 8;
	size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;

	size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);

	size_t bytesPerRow = width * bytesPerPixel;
	size_t bufferLength = bytesPerRow * height;

	colorSpace = CGColorSpaceCreateDeviceRGB();

	if(!colorSpace) {
		NSLog(@"Error allocating color space RGB\n");
		return NULL;
	}

	// Allocate memory for image data
	bitmapData = (uint32_t *)malloc(bufferLength);

	if(!bitmapData) {
		NSLog(@"Error allocating memory for bitmap\n");
		CGColorSpaceRelease(colorSpace);
		return NULL;
	}

	//Create bitmap context
	context = CGBitmapContextCreate(bitmapData, 
									width, 
									height, 
									bitsPerComponent, 
									bytesPerRow, 
									colorSpace, 
                                    kCGImageAlphaPremultipliedLast);	// RGBA

	if(!context) {
		free(bitmapData);
		NSLog(@"Bitmap context not created");
	}

	CGColorSpaceRelease(colorSpace);

	return context;	
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

- (void)addBarcodeWithData:(NSString *)data type:(NSString*)type hri:(NSString*)hri font:(NSString*)font width:(NSInteger)width height:(NSInteger)height {
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
  
//  CGRect rect = CGRectMake(x, y, width, height);
//  CGImageRef imageRef = CGImageCreateWithImageInRect(context.CGImage, rect);
//  UIImage *result = [UIImage imageWithCGImage:imageRef];
  
  NSData *rasterData = encodeRasterData(context, width, height);
  
//  NSLog(@"%@", [rasterData base64String]);
  
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
