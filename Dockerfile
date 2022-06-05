FROM fuzzers/libfuzzer:12.0

RUN apt-get update
RUN apt install -y build-essential wget git clang  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libjpeg-dev libssl-dev cmake 
#RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.1/cmake-3.20.1.tar.gz
#RUN tar xvfz cmake-3.20.1.tar.gz
#WORKDIR /cmake-3.20.1
#RUN ./bootstrap
#RUN make
#RUN make install
WORKDIR /
RUN git clone --recursive https://github.com/troldal/OpenXLSX.git
WORKDIR /OpenXLSX
RUN cmake -DBUILD_SHARED_LIBS=true .
RUN make
RUN make install
COPY fuzzers/fuzz_sheetValue.cpp .
RUN clang++  -I/usr/local/include/OpenXLSX/ -fsanitize=fuzzer,address fuzz_sheetValue.cpp -o /fuzzSheetValue /usr/local/lib/libOpenXLSX.a -std=c++17
RUN mkdir /corpus
RUN echo "helloW0x0rld" > /corpus/sample1
RUN echo "A B C D C X" > /corpus/sample2

ENTRYPOINT []
CMD /fuzzSheetValue /corpus
