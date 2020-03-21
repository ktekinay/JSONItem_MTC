# JSONItem\_MTC

This is a drop-in replacements for the native JSONItem. It emulates all its features but should perform certain functions faster.

To use it, search for "JSONItem" within your project and replace it with "JSONItem\_MTC". Then drag the JSONItem\_MTC class into your project.

## Differences

This class implements all the features and functions of its native twin and should be indistinguishable except for the following:

- You can add any object to JSONItem and it will raise an exception when you try to use ToString. This class will raise that exception when you try to add the bad object.

- This class has an extra enum property, EncodeUnicode. By default, it is EncodeType.JavascriptCompatible to emulate the native class. If set to EncodeType.All, it will encode all characters whose codepoints are greater than or equal to 127. In all cases (EncodeType.All, .JavascriptCompatible, .None), code points 0 - 31 will be encoded.

- Some error messages will be different within this class than the native class.

- The native class will raise an exception when loading a string that has an escaped character other than one of the "approved" characters. This class will accept any escaped character as long as Strict = False (see below).

- This class is more tolerant when loading values that aren't valid according to the specs. For example, the value `TRUE` is considered invalid according to the RFC as is the value `+1`, but both will be accepted by this class. As such, it should not be used as a validator unless Strict = True (see below). JSON string generation will meet always meet specs except as noted below.

- This class will accept `inf` and `nan` as doubles, and will output the same. This is the only case where the output will not strictly meet JSON guidelines when using ToString, unless Strict = True (see below).

- This class has a Strict property. When set to `True`, it will strictly interpret JSON string according to JSON specs (values like `TRUE` and `+1` will be rejected), and will raise an exception rather than outputting `inf` or `nan`.

- This class will properly handle characters with code points > &uFFFF when both encoding and decoding. The native class does not.

- This class will properly reject invalid hex in a "\\uNNNN" structure.

- The native class will load some badly formed JSON strings, e.g., "[true]]". This class will not.

- When loading a JSON string, this class will figure out its encoding and even strip any BOM that might prefix it.

- As of Xojo 2018r2, ToString and Load are significantly faster in this class than the native version.

# M\_JSON Module

## What It Does

The M\_JSON module includes two functions, `ParseJSON_MTC` and `GenerateJSON_MTC` that emulate the functions found in the `Xojo.Data` module, but produces and uses String, Dictionary and Variant().

**Note**: `GenerateJSON_MTC` has an extra, optional parameter to generate formatted ("pretty") JSON.

While it can generate JSON from any Dictionary subclass, it will produce a M\_JSON.JSONDictionary, a case-sensitive subclass. You can convert that to a regular (case-insensitive) Dictionary with the `ToDictionary` function but keys that are only differentiated by case will be merged. For example, if the JSONDictionary has the keys "a" and "A", the Dictionary created by `ToDictionary` will have just one of those.

## To Install

Open the Harness project and copy and paste the module into your own project. _Do not drag the module file directly into your project._

# License

This class was created by Kem Tekinay, MacTechnologies Consulting (ktekinay@mactechnologies dot com). It is copyright ©2019 by Kem Tekinay, all rights reserved.

This project is distributed AS-IS and no warranty of fitness for any particular purpose is expressed or implied. The author disavows any responsibility for bad design, poor execution, or any other faults.

You may freely use or modify this project or any part within. You may distribute a modified version as long as this notice or any other legal notice is left undisturbed and all modifications are clearly documented and accredited. The author does not actively support this class, although comments and recommendations are welcome.

# Comments and Contributions

All contributions to this project will be gratefully considered. Fork this repo to your own, then submit your changes via a Pull Request.

All comments are also welcome.

# Who Did This?!?

This project was created by and is maintained by Kem Tekinay (ktekinay@mactechnologies dot com).

# Release Notes

**4.2** (Mar. 21, 2020)

- ParseJSON will take an optional parameter to make the result case-INsensitive (regular Dictionary).
- JSONItem\_MTC will properly deal with assignments of arrays.
- JSONItem\_MTC will auto-convert to Dictionary and Variant().
- JSONItem\_MTC implements compare against other JSONItem\_MTC.
- JSONWebToken\_MTC no longer depends on JSONItem\_MTC.
- JSONWebToken\_MTC has various fixes and no longer depends on JSONItem\_MTC.

**4.1.1** (Aug. 7, 2019)

- Added more tests.
- M_JSON was not encoding embedded quotes or backslashes.
- kVersion constants are now strings.
- Added FormatCodePreferences module for the Format Code script.

**4.1** (Jan. 23, 2019)

- JSON objects in both JSONItem\_MTC and the JSONDictionary will store keys internally as key-HEX instead of just hex for easier debugging.

**4.0** (Sept. 12, 2018)

- Added M\_JSON module.
- Updated version to reflect inclusion of M\_JSON.
