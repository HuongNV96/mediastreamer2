/*
 * Copyright (c) 2010-2022 Belledonne Communications SARL.
 *
 * This file is part of mediastreamer2 
 * (see https://gitlab.linphone.org/BC/public/mediastreamer2).
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */


#import "ioshardware.h"

#include <sys/types.h>
#include <sys/sysctl.h>


@implementation IOSHardware

+ (NSString *) platform {
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithUTF8String:machine];
	free(machine);
	return platform;
}

// see http://theiphonewiki.com/wiki/Models , these come from our experience
NSString* notHDCapableFamilies[] = {
	@"iPod1,", @"iPod2,", @"iPod3,", @"iPod4,",
	@"iPhone1,", @"iPhone2,", @"iPhone3,", @"iPhone4,",
	@"iPad1,", @"iPad2," };


+ (BOOL) isHDVideoCapableDevice:(NSString*)device {
	for (int i = 0; i<sizeof(notHDCapableFamilies)/sizeof(NSString*); i++) {
		if ( [device hasPrefix:notHDCapableFamilies[i]] )
			return FALSE;
	}
	return YES;
}


+ (BOOL) isHDVideoCapable {
    NSString* platform = [IOSHardware platform];
    return [IOSHardware isHDVideoCapableDevice:platform];
}


+ (MSVideoSize) HDVideoSize:(const char *) deviceId {
	if ([IOSHardware isHDVideoCapable]) {
		return MS_VIDEO_SIZE_720P;
	}
	return MS_VIDEO_SIZE_VGA;
}

+ (BOOL) isFrontCamera:(const char *) deviceId {
	if ([[NSString stringWithCString:deviceId encoding:[NSString defaultCStringEncoding]] hasSuffix:@"1"])
		return TRUE;
	return FALSE;
}

+ (BOOL) isBackCamera:(const char *) deviceId {
	if ([[NSString stringWithCString:deviceId encoding:[NSString defaultCStringEncoding]] hasSuffix:@"0"])
		return TRUE;
	return FALSE;
}

@end
