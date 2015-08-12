
// To check if a library is compiled with CocoaPods you
// can use the `COCOAPODS` macro definition which is
// defined in the xcconfigs so it is available in
// headers also when they are imported in the client
// project.


// Repro
#define COCOAPODS_POD_AVAILABLE_Repro
#define COCOAPODS_VERSION_MAJOR_Repro 0
#define COCOAPODS_VERSION_MINOR_Repro 10
#define COCOAPODS_VERSION_PATCH_Repro 4

