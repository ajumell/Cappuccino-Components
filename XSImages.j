@import <Foundation/CPObject.j>
@import <Foundation/CPDictionary.j>
@import <Foundation/CPBundle.j>

@import <AppKit/CPImage.j>

var XSImageDict;
var XSColorDict;

var DefaultXSImages;
var DefaultXSMimeImages;
var DefaultXSToolbarImages;
var DefaultXSDialogImages;
var DefaultXSWallpaperImages;
var DefaultXSDesktopIconImages;
var DefaultXSButtonImages;
var DefaultXSFormatImages;
var DefaultXSBackgroundImages;


/*!	
	XSImages is a helper class which is used to 
	create images and color with images. This 
	class can be used to images and colors with 
	simple function call. The images and colors 
	once used will be cached and can be collected
	with out creating new objects. It helps in 
	saving memory and execution time.
*/
@implementation XSImages : CPObject
{
	CPString	path	@accessors;
	CPString	ext	@accessors;
	CGSize		size	@accessors;
}

/*!
	Initializes a new Object of XSImages Class
*/
- (id)init
{
	self = [super init];

	path = @"";
	ext  = @".png";
	
	return self;
}

/*!
	Initializes a new Object and set its path
*/
- (id)initWithPath:(CPString)aPath
{
	self = [super init];
	path = aPath;
	ext  = @".png";
	return self;
}

/*!
	returns a shared Object of XSImages class
*/
+ (id)shared
{
	if(!DefaultXSImages)
		DefaultXSImages = [[XSImages alloc] init];
	return DefaultXSImages
}

/*!
	returns the shared Object and sets the path
	variable to given string.
*/
+ (id)sharedWithPath:(CPString)aPath
{
	var x = [self shared];
	[x setPath:aPath];
	return x;
}

@end

@implementation XSImages (Image)
{
}

/*!
	Returns a CPImage object with given name from the current folder.
	The returned object will be cahced so it can be accessed easily.
*/
- (CPImage)img:(CPString)name
{
	return [self img:name size:size ext:ext];
}

/*!
	Returns a CPImage object with given name, size from the current folder.
	The returned object will be cahced so it can be accessed easily.
*/
- (CPImage)img:(CPString)name size:(CGSize)s
{
	return [self img:name size:s ext:ext];
}

/*!
	Returns a CPImage object with given name, extention from the current folder.
	The returned object will be cahced so it can be accessed easily.
*/
- (CPImage)img:(CPString)name ext:(CPString)e
{
	return [self img:name size:nil ext:e];
}


/*!
	Returns a CPImage object with given name, size, extention from the current folder.
	The returned object will be cahced so it can be accessed easily.
*/
- (CPImage)img:(CPString)name size:(CGSize)s ext:(CPString)e
{
	if(!XSImageDict)
		XSImageDict = [[CPDictionary alloc] init];

	var bndle = [CPBundle mainBundle];
	var filepath = [bndle pathForResource:path + name + e];
		
	var item = [XSImageDict valueForKey:filepath];
	if(item != null)
		return item;

	var img;
	if(s == nil)
		img = [[CPImage alloc] initWithContentsOfFile:filepath]
	else
		img = [[CPImage alloc] initWithContentsOfFile:filepath size:s]
	[XSImageDict setObject:img forKey:filepath]
	return img;
}


- (id)cimg:(CPString)aName
{
	return [self cimg:aName size:nil ext:ext];
}

- (id)cimg:(CPString)aName ext:(CPString)e
{
	return [self cimg:aName size:nil ext:e];
}

- (id)cimg:(CPString)aName size:(CGSize)aSize
{
	return [self cimg:aName size:aSize ext:ext];
}

- (id)cimg:(CPString)aName size:(CGSize)aSize ext:(CPString)e
{
	var x = [self hasColor:aName + e];
	if(x) return x;
	
	x = [CPColor colorWithPatternImage:[self img:aName size:aSize ext:e]];
	[XSColorDict setObject:x forKey:path + aName + e];
	return x;
}

@end

@implementation XSImages (ThreePartImage)
{
}

- (id)timg:(CPString)folder size:(CGSize)s
{
	if(folder)
		folder = folder + "/";
	
	var img1 = [self img:folder + "1" size:s];
	var img2 = [self img:folder + "2" size:nil];
	var img3 = [self img:folder + "3" size:s];
	
	return [[CPThreePartImage alloc] initWithImageSlices:[img1, img2, img3] isVertical:NO];
}

- (id)timg:(CPString)folder sizes:(CPArray)sizes
{
	if(folder)
		folder = folder + "/";
	
	var img1 = [self img:folder + "1" size:sizes[0]];
	var img2 = [self img:folder + "2" size:sizes[1]];
	var img3 = [self img:folder + "3" size:sizes[2]];
	
	return [[CPThreePartImage alloc] initWithImageSlices:[img1, img2, img3] isVertical:NO];
}

- (id)ctimg:(CPString)folder size:(CGSize)s
{
	var x = [self hasColor:folder];
	if(x) return x;
	
	x = [CPColor colorWithPatternImage:[self timg:folder size:s]];
	[XSColorDict setObject:x forKey:path + folder];
	return x;
}

- (id)ctimg:(CPString)folder sizes:(CPArray)sizes
{
	var x = [self hasColor:folder];
	if(x) return x;
	
	x = [CPColor colorWithPatternImage:[self timg:folder sizes:sizes]];
	[XSColorDict setObject:x forKey:path + folder];
	return x;
}

@end

@implementation XSImages (NinePartImage)
{
}

- (id)nimg:(CPString)folder size:(CGSize)s
{
	if(folder)
		folder = folder + "/";
	
	var img1 = [self img:folder + "1" size:s];
	var img2 = [self img:folder + "2" size:s];
	var img3 = [self img:folder + "3" size:s];
	var img4 = [self img:folder + "4" size:s];
	var img5 = [self img:folder + "5" size:nil];
	var img6 = [self img:folder + "6" size:s];
	var img7 = [self img:folder + "7" size:s];
	var img8 = [self img:folder + "8" size:s];
	var img9 = [self img:folder + "9" size:s];
	
	return [[CPNinePartImage alloc] initWithImageSlices:[img1, img2, img3, img4, img5, img6, img7, img8, img9]];
}

- (id)nimg:(CPString)folder sizes:(CPArray)s
{
	if(folder)
		folder = folder + "/";
	
	var img1 = [self img:folder + "1" size:s[0]];
	var img2 = [self img:folder + "2" size:s[1]];
	var img3 = [self img:folder + "3" size:s[2]];
	var img4 = [self img:folder + "4" size:s[3]];
	var img5 = [self img:folder + "5" size:s[4]];
	var img6 = [self img:folder + "6" size:s[5]];
	var img7 = [self img:folder + "7" size:s[6]];
	var img8 = [self img:folder + "8" size:s[7]];
	var img9 = [self img:folder + "9" size:s[8]];
	
	return [[CPNinePartImage alloc] initWithImageSlices:[img1, img2, img3, img4, img5, img6, img7, img8, img9]];
}


- (id)cnimg:(CPString)folder size:(CGSize)s
{
	var x = [self hasColor:folder];
	if(x) return x;
	
	x = [CPColor colorWithPatternImage:[self nimg:folder size:s]];
	[XSColorDict setObject:x forKey:path + folder];
	return x;
}

- (id)cnimg:(CPString)folder sizes:(CPArray)s
{
	var x = [self hasColor:folder];
	if(x) return x;
	
	x = [CPColor colorWithPatternImage:[self nimg:folder sizes:s]];
	[XSColorDict setObject:x forKey:path + folder];
	return x;
}


@end

@implementation XSImages (Color)
{
}

- (CPColor)hasColor:(CPString)aString
{
	if(!XSColorDict)
		XSColorDict = [[CPDictionary alloc] init];
	return [XSColorDict valueForKey:path + aString];
}

@end

