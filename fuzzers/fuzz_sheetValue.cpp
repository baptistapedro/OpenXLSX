#include <OpenXLSX.hpp>
#include <string>
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <vector>
#include <string.h>

using namespace OpenXLSX;

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    if (!data) return 1;
    char *buf = (char*)malloc(size+1);
    if (!buf) return 1;
    memcpy(buf, data, size);
    buf[size] = '\0';
    if (buf[0] == 0) return 1;

    XLDocument doc;
    doc.create("./Spreadsheet1.xlsx");
    auto wks = doc.workbook().worksheet("Sheet1");
    
    wks.cell("A1").value() = buf;

    doc.save();
    free(buf);
    return 0;
}
