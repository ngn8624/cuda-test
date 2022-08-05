CC=nvcc
TARGET=HighPassFilter
OBJS=$(TARGET).o

all:
	$(CC) -Xcompiler -fPIC -c $(TARGET).cu
	$(CC) -shared -o lib$(TARGET).so $(OBJS)
	rm *.o

debug:
	$(CC) -Xcompiler -fPIC -c $(TARGET).cu
	$(CC) -shared -DDEBUG -o lib$(TARGET).so $(OBJS)
	rm *.o
	cp libHighPassFilter.so test

release:
	$(CC) -Xcompiler -fPIC -c $(TARGET).cu
	$(CC) -shared -DNDEBUG -o lib$(TARGET).so $(OBJS)
	rm *.o
	cp libHighPassFilter.so test