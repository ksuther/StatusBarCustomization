@interface XCDFakeCarrier : NSObject

/* 0 to 5 */
+ (void)setCellStrength:(NSInteger)cellStrength;

/* 0 to 3 */
+ (void)setWiFiStrength:(NSInteger)wifiStrength;

/*
 dataNetworkType:
 0 - GPRS
 1 - E (EDGE)
 2 - 3G
 3 - 4G
 4 - LTE
 5 - Wi-Fi
 6 - Personal Hotspot
 7 - 1x
 8 - Blank
 */
+ (void)setNetworkType:(NSInteger)networkType;

/*
 itemIsEnabled:
 
 1 - do not disturb
 2 - airplane mode
 3 - cell signal strength indicator
 6 - show time on right side
 10 - strange battery symbol
 11 - Bluetooth
 12 - strange telephone symbol
 13 - alarm clock
 13 - slanted plus sign
 16 - location services
 17 - orientation lock
 19 - AirPlay
 20 - microphone
 21 - VPN
 22 - forwarded call?
 23 - spinning activity indicator
 24 - square
 */
+ (void)setEnabled:(BOOL)enabled atIndex:(NSInteger)index;

@end