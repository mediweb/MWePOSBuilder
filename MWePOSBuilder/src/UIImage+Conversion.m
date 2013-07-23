/*
 * The MIT License
 *
 * Copyright (c) 2011 Paul Solt, PaulSolt@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * Modified into a UIImage category by MediWeb, Inc. (2013)
 */


#import "UIImage+Conversion.h"

@implementation UIImage (Conversion)

- (unsigned char *)bitmapRGBA8Representation {
	CGImageRef imageRef = self.CGImage;

	CGContextRef context = [[self class] newBitmapRGBA8ContextFromImage:imageRef];

	if (!context) {
		return NULL;
	}

	size_t width = CGImageGetWidth(imageRef);
	size_t height = CGImageGetHeight(imageRef);

	CGRect rect = CGRectMake(0, 0, width, height);

	CGContextDrawImage(context, rect, imageRef);

	unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);

	size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
	size_t bufferLength = bytesPerRow * height;

	unsigned char *newBitmap = NULL;

	if (bitmapData) {
		newBitmap = (unsigned char *)malloc(sizeof(unsigned char) * bytesPerRow * height);

		if (newBitmap) {
			for (int i = 0; i < bufferLength; ++i) {
				newBitmap[i] = bitmapData[i];
			}
		}

		free(bitmapData);

	}

	CGContextRelease(context);

	return newBitmap;	
}

+ (CGContextRef)newBitmapRGBA8ContextFromImage:(CGImageRef)image {
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

	if (!colorSpace) {
		return NULL;
	}

	bitmapData = (uint32_t *)malloc(bufferLength);

	if (!bitmapData) {
		CGColorSpaceRelease(colorSpace);
		return NULL;
	}

	context = CGBitmapContextCreate(
    bitmapData,
    width,
    height,
    bitsPerComponent,
    bytesPerRow,
    colorSpace,
    kCGImageAlphaPremultipliedLast
  );

	if (!context) {
		free(bitmapData);
  }

	CGColorSpaceRelease(colorSpace);

	return context;	
}

@end
