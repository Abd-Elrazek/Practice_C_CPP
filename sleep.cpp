#include <tchar.h>
#include <stdio.h>
#include "Windows.h"

int _tmain(int argc, _TCHAR* argv[])
{
    if (argc == 2)
    {
        _tprintf(_T("Sleeping for %s ms\n"), argv[1]);
        Sleep(_tstoi(argv[1]));
    }
    else
    {
        _tprintf(_T("Wrong number of arguments.\n"));
    }
    return 0;
}
share