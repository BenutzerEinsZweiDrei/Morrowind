DDS Converter version 1.0 by Vasiliy
------------------------------------

This is utility for batch convert image files to DDS format and back. It is wrapper around
NVidia command line tools nvdxt.exe and readdxt.exe. (The readdxt.exe was rewritten to accept
second parameter - destination filename).

Select source and destination directories, adjust convert options and press button "DDS -> TGA"
or "IMG -> DDS". Source directory will be scanned for input files, then for each of them, will
be executed NV convertor with additional parameters. 

For converting to .dds format you can use images in one of these formats - BMP,TGA,GIF,JPG,TIF,
PPM and CEL. From DDS you can get only TGA images.

You can add additional comand line parameters for nvdxt.exe - look at NV manual for details.
 
Know bags:
----------
1. nvdxt.exe sometimes is crashes when trying convert .dds to .dds, so i block this opportunity.
2. If src files has same names (and different extensions), The resulting file will be rewritten
   by last processed file. For example, src files is test.bmp, test.tga and test.jpg, in result 
   you get only one file test.dds (from test.tga)

With best regards, Vasiliy.
vasiliy73@mail.ru
http://letalka.sourceforge.net/morr/

