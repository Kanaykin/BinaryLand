package org.myextend;

import org.myextend.IADSListener;

interface IADS
{
	//----------------------------------
	public boolean Show();

	//----------------------------------
	public void Cancel();

	//----------------------------------
	public int GetStatus();

	//----------------------------------
	public void SetListener(IADSListener listener);
}