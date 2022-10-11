#include "base.h"

int main()
{
	InitVariables();
	GetInput(); // get input information
	CalcInfo();
	CreateCache();
	CreateMemory();
	FileTest();
	PrintOutput(); // output the result

	return 0;
}
