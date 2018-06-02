package org.myextend;

public enum AdsStatus
{
	NONE(1),
	LOADING(2),
	LOADED(3),
	FAILED(4);

	private final int value;
	private AdsStatus(int value)
	{
		this.value = value;
	}

	public int GetValue()
	{
		return value;
	}

}
