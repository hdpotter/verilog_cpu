#include <iostream>
#include <svdpi.h>

using namespace std;

typedef struct {
    bool a;
} test_input;

typedef struct {
    bool a;
} test_output;

int stepcount = 0;

extern "C" void quit();

extern "C" void run_test(test_output* a) {
    cout << "got " << a->a << endl;
}

extern "C" void get_input(test_input* a) {
    bool val = stepcount % 2 == 0;

    cout << "sending " << val << endl;

    if(stepcount++ > 4) {
        quit();
    }

    a->a = val;
}

