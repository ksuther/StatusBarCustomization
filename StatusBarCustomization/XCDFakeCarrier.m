//
// Copyright (c) 2012-2013 Cédric Luthi / @0xced. All rights reserved.
//

// Adapted from https://gist.github.com/0xced/3035167 to allow modifying signal strength and other symbols

static const char *fakeCarrier;
static const char *fakeTime;
static int fakeCellSignalStrength = -1;
static int fakeWifiStrength = 3; // default to full strength
static int fakeDataNetwork = 5; // default to Wi-Fi

static NSMutableDictionary *fakeItemIsEnabled;

#import "XCDFakeCarrier.h"
#import <objc/runtime.h>

typedef struct {
	char itemIsEnabled[25];
	char timeString[64];
	int gsmSignalStrengthRaw;
	int gsmSignalStrengthBars;
	char serviceString[100];
	BOOL serviceCrossfadeString[100];
	BOOL serviceImages[2][100];
	BOOL operatorDirectory[1024];
	unsigned int serviceContentType;
	int wifiSignalStrengthRaw;
	int wifiSignalStrengthBars;
	unsigned int dataNetworkType;
    int batteryCapacity;
    unsigned int batteryState;
    BOOL batteryDetailString[150];
	// ...
} StatusBarData;

@implementation XCDFakeCarrier

+ (void)setCellStrength:(NSInteger)cellStrength
{
    fakeCellSignalStrength = cellStrength;
}

+ (void)setWiFiStrength:(NSInteger)wifiStrength
{
    fakeWifiStrength = wifiStrength;
}

+ (void)setNetworkType:(NSInteger)networkType
{
    fakeDataNetwork = networkType;
}

+ (void)setEnabled:(BOOL)enabled atIndex:(NSInteger)index
{
    [fakeItemIsEnabled setObject:@(enabled) forKey:@(index)];
}

+ (void)load
{
	fakeCarrier = "Cocoaheads";
	fakeTime = "10:21 AM";
	
    fakeItemIsEnabled = [[NSMutableDictionary alloc] init];
    
	BOOL __block success = NO;
	Class UIStatusBarComposedData = objc_getClass("UIStatusBarComposedData");
	SEL selector = NSSelectorFromString(@"rawData");
	Method method = class_getInstanceMethod(UIStatusBarComposedData, selector);
	NSDictionary *statusBarDataInfo = @{ @"^{?=[25c][64c]ii[100c]": @"fake_rawData",
										 // use B instead of c for 64-bit
                                         @"^{?=[25B][64c]ii[100c]": @"fake_rawData" };
	[statusBarDataInfo enumerateKeysAndObjectsUsingBlock:^(NSString *statusBarDataTypeEncoding, NSString *fakeSelectorString, BOOL *stop) {
		if (method && [@(method_getTypeEncoding(method)) hasPrefix:statusBarDataTypeEncoding])
		{
			SEL fakeSelector = NSSelectorFromString(fakeSelectorString);
			Method fakeMethod = class_getInstanceMethod(self, fakeSelector);
			success = class_addMethod(UIStatusBarComposedData, fakeSelector, method_getImplementation(fakeMethod), method_getTypeEncoding(fakeMethod));
			fakeMethod = class_getInstanceMethod(UIStatusBarComposedData, fakeSelector);
			method_exchangeImplementations(method, fakeMethod);
		}
	}];
	
	if (success)
		NSLog(@"Using \"%s\" fake carrier", fakeCarrier);
	else
		NSLog(@"XCDFakeCarrier failed to initialize");
}

- (StatusBarData *)fake_rawData
{
	StatusBarData *rawData = [self fake_rawData];
	
	if (fakeCarrier) {
		strlcpy(rawData->serviceString, fakeCarrier, sizeof(rawData->serviceString));
	}
	
	if (fakeTime) {
		strlcpy(rawData->timeString, fakeTime, sizeof(rawData->timeString));
	}
	
	if (fakeCellSignalStrength > -1) {
		rawData->itemIsEnabled[3] = 1;
		rawData->gsmSignalStrengthBars = fakeCellSignalStrength;
	} else {
        rawData->itemIsEnabled[3] = 0;
    }
    
    for (NSNumber *key in fakeItemIsEnabled) {
        NSNumber *value = [fakeItemIsEnabled objectForKey:key];
        
        rawData->itemIsEnabled[[key integerValue]] = [value boolValue];
    }
    
    rawData->dataNetworkType = fakeDataNetwork;
    
    rawData->wifiSignalStrengthBars = fakeWifiStrength;
    rawData->batteryCapacity = 100; // Full battery
    
    memset(rawData->batteryDetailString, 0, sizeof(rawData->batteryDetailString)); // Hide battery state strings such as "Not Charging"
	
	return rawData;
}

@end
