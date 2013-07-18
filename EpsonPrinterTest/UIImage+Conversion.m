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
 * Modified into a UIImage category by Matt Gillingham (2013)
 */


#import "UIImage+Conversion.h"

@implementation UIImage (Conversion)

- (unsigned char *)bitmapRGBA8Representation {
	CGImageRef imageRef = self.CGImage;

	// Create a bitmap context to draw the uiimage into
	CGContextRef context = [[self class] newBitmapRGBA8ContextFromImage:imageRef];

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

@end
