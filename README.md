#JSONItem_MTC

This is a drop-in replacements for the native JSONItem. It emulates all its features but should perform certain functions faster.

To use it, search for "JSONItem" within your project and replace it with "JSONItem_MTC". Then drag the JSONItem_MTC class into your project.

##Differences

This class implements all the features and functions of its native twin and should be indistinguishable except for the following:

- You can add any object to JSONItem and it will raise an exception when you try to use ToString. This class will raise that exception when you try to add the bad object.

- This class has an extra property, EncodeUnicode. By default, it is False to emulate the native class. If set to True, it will encode all characters whose codepoints are greater than 127.

- Some error messages will be different within this class than the native class.

- The native class will raise an exception when loading a string that has an escaped character other than one of the "approved" characters. This class will accept any escaped character.

- When loading a JSON string, this class will figure out its encoding and even strip any BOM that might prefix it.

- As of Xojo 2014r21, ToString is significantly faster in this class than the native version.

##License

This class was created by Kem Tekinay, MacTechnologies Consulting (ktekinay@mactechnologies dot com). It is copyright ©2014 by Kem Tekinay, all rights reserved.

This project is distributed AS-IS and no warranty of fitness for any particular purpose is expressed or implied. The author disavows any responsibility for bad design, poor execution, or any other faults.

You may freely use or modify this project or any part within. You may distribute a modified version as long as this notice or any other legal notice is left undisturbed and all modifications are clearly documented and accredited. The author does not actively support this class, although comments and recommendations are welcome.

##Comments and Contributions

All contributions to this project will be gratefully considered. Fork this repo to your own, then submit your changes via a Pull Request.

All comments are also welcome.

##Who Did This?!?

This project was created by and is maintained by Kem Tekinay (ktekinay@mactechnologies dot com).