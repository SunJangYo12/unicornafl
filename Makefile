.PHONY: all debug debug release run test

all: build/libunicornafl
termux: termux-build/libunicornafl

build:
	mkdir build


termux-unicorn/build/libunicorn-common.a:
	git submodule update --init --recursive
	cmake \
          -DANDROID_PLATFORM=31 \
          -DCMAKE_TOOLCHAIN_FILE=/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/LabTes/fuzzing-firmware/termux/android-ndk-r25c/build/cmake/android.toolchain.cmake \
          -DANDROID_ABI=arm64-v8a \
          -S unicorn/ -B build/unicorn -D BUILD_SHARED_LIBS=no

	$(MAKE) -C ./build/unicorn


termux-build/libunicornafl: build termux-unicorn/build/libunicorn-common.a
	cd ./build && cmake \
          -DANDROID_PLATFORM=31 \
          -DCMAKE_TOOLCHAIN_FILE=/media/jin/4abb279b-6d65-4663-97c2-26987f64673a/home/yuna/LabTes/fuzzing-firmware/termux/android-ndk-r25c/build/cmake/android.toolchain.cmake \
          -DANDROID_ABI=arm64-v8a \
	-D BUILD_SHARED_LIBS=no ..

	$(MAKE) -C ./build



unicorn/build/libunicorn-common.a:
	git submodule update --init --recursive
	cmake -S unicorn/ -B build/unicorn -D BUILD_SHARED_LIBS=no
	$(MAKE) -C ./build/unicorn -j8

build/libunicornafl: build unicorn/build/libunicorn-common.a
	cd ./build && cmake .. -D BUILD_SHARED_LIBS=no
	$(MAKE) -C ./build -j8

format:
	format.sh

clean:
	rm -rf build
	rm -rf ./unicorn/build
