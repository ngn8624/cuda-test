#include "HighPassFilter.h"

#include <iostream>
#include <fstream>

using namespace std;

#define TEST_FILE_NAME_1 "0.bin"
#define DATA_SIZE 25011200

int main(int argc, char* argv[])
{

	// ifstream in;
	// in.open(TEST_FILE_NAME_1, ios::binary);

	uint8_t* src = new uint8_t;
    int cnt = 0;
    uint8_t* dest_1 = new uint8_t;
    uint8_t* dest_2 = new uint8_t;
    uint8_t* filter_1 = new uint8_t;
    uint8_t* filter_2 = new uint8_t;
    float* max_1 = new float;
    float* max_2 = new float;
    // in.read(reinterpret_cast<char *>(&src[0]), DATA_SIZE);
    // in.close();

    int ret = cudaHighPassFilter(src, cnt, dest_1, dest_2, filter_1, filter_2, max_1, max_2);
    cout << ret << endl;

	// ofstream out("result_0.bin", ios::out);
	// out.write(reinterpret_cast<char *>(&dest[0]), DATA_SIZE);
	// out.close();

	delete[] src;
    delete[] dest_1;
    delete[] dest_2;
    delete[] filter_1;
    delete[] filter_2;
    delete[] max_1;
    delete[] max_2;

	return 0;
}