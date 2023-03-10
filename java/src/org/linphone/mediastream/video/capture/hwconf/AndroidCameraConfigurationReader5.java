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
package org.linphone.mediastream.video.capture.hwconf;

import java.util.ArrayList;
import java.util.List;

import org.linphone.mediastream.Log;
import org.linphone.mediastream.video.capture.hwconf.AndroidCameraConfiguration.AndroidCamera;

import android.hardware.Camera;
import android.hardware.Camera.Size;

/**
 * Android cameras detection, using SDK < 9
 *
 */
class AndroidCameraConfigurationReader5  {
	static public AndroidCamera[] probeCameras() {
		List<AndroidCamera> cam = new ArrayList<AndroidCamera>(1);
		
		Camera camera = Camera.open();
		List<Size> r = camera.getParameters().getSupportedPreviewSizes();
		camera.release();
		
		// Defaults
		if (Hacks.isGalaxySOrTab()) {
			Log.d( "Hack Galaxy S : has one or more cameras");
			if (Hacks.isGalaxySOrTabWithFrontCamera()) {
				Log.d("Hack Galaxy S : HAS a front camera with id=2");
				cam.add(new AndroidCamera(2, true, 90, r));
			} else {
				Log.d("Hack Galaxy S : NO front camera");
			}
			Log.d("Hack Galaxy S : HAS a rear camera with id=1");
			cam.add(new AndroidCamera(1, false, 90, r));
		} else {
			cam.add(new AndroidCamera(0, false, 90, r));

			if (Hacks.hasTwoCamerasRear0Front1()) {
				Log.d("Hack SPHD700 has 2 cameras a rear with id=0 and a front with id=1");
				cam.add(new AndroidCamera(1, true, 90, r));
			}
		}
		
		AndroidCamera[] result = new AndroidCamera[cam.size()];
		result = cam.toArray(result);
		return result;
		
	}
}
