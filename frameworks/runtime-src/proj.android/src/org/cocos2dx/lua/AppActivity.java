/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import android.util.Log;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.os.Bundle;

import org.myextend.MyExtendHelper;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.common.Scopes;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.games.Games;
import com.google.android.gms.games.GamesActivityResultCodes;
import com.google.android.gms.games.multiplayer.Invitation;
import com.google.android.gms.games.multiplayer.Multiplayer;
import com.google.android.gms.games.request.GameRequest;
import com.google.android.gms.plus.Plus;

import java.io.File;
import java.io.FileWriter;
import android.content.pm.ApplicationInfo;

public class AppActivity extends Cocos2dxActivity implements GoogleApiClient.ConnectionCallbacks,
GoogleApiClient.OnConnectionFailedListener
{
    final String EXTERNAL_DOCUMENT_PATH = "/sdcard" + File.separator + "Android" + File.separator + "data";
    final String INTERNAL_DOCUMENT_PATH = "/data" + File.separator + "data";
    
	private GoogleApiClient 		mPlusClient;
	private String					mDocumentDirectory;
		
    public static boolean isSdPresent() {
    	return android.os.Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED);
    }
    
    public String getDocumentDirectory() {
    	return mDocumentDirectory;
    }
    
    private native void nativeSetPaths(String documents_path);
    
	@Override
	protected void onCreate(final Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		Log.e("SQC", "onCreate");
		
		String strCacheDirectory = getExternalCacheDir().getAbsolutePath();
		
		ApplicationInfo applicationInfo = getApplicationInfo();
		String packageName = applicationInfo.packageName;
		String fileDirectory = getFilesDir().getAbsolutePath();
        String nativeSetApkPath = applicationInfo.sourceDir;
		
        if(!isSdPresent())
        	mDocumentDirectory = INTERNAL_DOCUMENT_PATH + File.separator + packageName;
        else
        	mDocumentDirectory = EXTERNAL_DOCUMENT_PATH + File.separator + packageName;
        
        nativeSetPaths(mDocumentDirectory);
        
        File fileName = new File(mDocumentDirectory, "temp2.txt");
        if (!fileName.exists())
        	//fileName.mkdirs();
        	try {
        	FileWriter f = new FileWriter(fileName);
        	f.write("hello world");
        	f.flush();
        	f.close();
        	} catch (Exception e) {}
		
		//mPlusClient =  new GoogleApiClient.Builder(this)
	    //	.addApi(Plus.API)
	    //	.addScope(Plus.SCOPE_PLUS_LOGIN)
	    //	.build();
        /*int result = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
        if((result != ConnectionResult.SERVICE_MISSING &&
        		result != ConnectionResult.SERVICE_VERSION_UPDATE_REQUIRED &&
        		result != ConnectionResult.SERVICE_DISABLED)) {
        	
        	GoogleApiClient.Builder builder = new GoogleApiClient.Builder(this, this, this);
            builder.addApi(Games.API);
            builder.addScope(Games.SCOPE_GAMES);
			//builder.addApi(Plus.API);
        	//builder.addScope(Plus.SCOPE_PLUS_LOGIN);
        	//builder.addScope(Plus.SCOPE_PLUS_PROFILE);
        	mPlusClient = builder.build();
        }*/
		
		//mPlusClient = new GoogleApiClient.Builder(this)
        //.addApi(Plus.API)
        //.addScope(Plus.SCOPE_PLUS_LOGIN)
        //.build();

		MyExtendHelper.init(this);
	}
	
    @Override
    public void onConnected(Bundle connectionHint){
    	
    }
    
    @Override
    public void onConnectionSuspended(int cause) {
    	
    }
	
    @Override
    public void onConnectionFailed(ConnectionResult result){
    	
    }
    
	protected void onStart() {
        super.onStart();
        //if(!mPlusClient.isConnected())
        //	mPlusClient.connect();
    }
	
    @Override
    protected void onStop() {
        super.onStop();
        //mPlusClient.disconnect();
    }

}
