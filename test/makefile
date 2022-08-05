CC=g++
TARGET=main
LIB=HighPassFilter
OBJS=$(TARGET).o

all:
	$(CC) $(TARGET).cpp -o $(TARGET) -I. -L. -l$(LIB)

debug:
	$(CC) $(TARGET).cpp -DDEBUG -o $(TARGET) -I. -L. -l$(LIB)

release:
	$(CC) $(TARGET).cpp -DNDEBUG -o $(TARGET) -I. -L. -l$(LIB)