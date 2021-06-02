# pjsip-multiple-architectures-configuration
 Multiple architecture configuration for iphone and simulator 

# Clone PJSIP project
    Documentation : 
    https://trac.pjsip.org/repos/wiki/Getting-Started/iPhone#SettingminimumsupportediOSversion

    https://github.com/pjsip/pjproject

# Build Pjsip project

a) Multiple architectures for iphone (armv7, armv7s, arm64, x86_64, i386 and so on)
    
    1. export ARCH="-arch arm64" (repeat same process for other architectures)
        a) ./configure-iphone  
        b) make dep && make clean && make
        
    2. Combine the resulting libraries using the lipo command ( navigate to pjlib,pjsip,pjlib-util,pjmedia,pjnath,third_party and pjmedia to execute command)
    
        lipo -arch arm64 lib/libpj-arm64-apple-darwin_ios.a -arch x86_64 lib/libpj-x86_64-apple-darwin_ios.a  -create -output libpjlib.a (name output file accordingly)
        
    NOTE: To compile for multiple architectures you need to run lipo for all 6 modules i.e pjlib,pjsip,pjlib-util,pjmedia,pjnath,third_party and pjmedia. Once all .a files are generated copy them in lib folder then import it into project.

b) Simulator configuration

    export DEVPATH=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer

    # 64-bit simulator
        ARCH="-arch x86_64" CFLAGS="-O2 -m64 -mios-simulator-version-min=5.0" LDFLAGS="-O2 -m64 -mios-simulator-version-min=5.0" ./configure-iphone
        
    # or 32-bit
        ARCH="-arch i386" CFLAGS="-O2 -m32 -mios-simulator-version-min=5.0" LDFLAGS="-O2     -m32 -mios-simulator-version-min=5.0" ./configure-iphone 
    Execute 
    make dep && make clean && make
    
c) Combining IPhone and Simulator configuration.
         
    Navigate to pjlib/lib,pjsip/lib,pjlib-util/lib,pjmedia/lib,pjnath/lib,third_party/lib and pjmedia/lib to execute command

    Combine using lipo

        lipo -arch arm64 lib/libpj-arm64-apple-darwin_ios.a -arch armv7 lib/libpj-armv7-apple-darwin_ios.a -arch x86_64 lib/libpj-x86_64-apple-darwin_ios.a -create -output libpjlib.a (name accordingly)
   
    NOTE: To compile for multiple architectures you need to run lipo for all 6 modules i.e pjlib,pjsip,pjlib-util,pjmedia,pjnath,third_party and pjmedia. Once all .a files are generated copy them in lib folder then import it into project.

d) Configure OpenH264
    
    1) Download openH264 1.0.0
     
     https://github.com/cisco/openh264/archive/v1.0.0.zip

    2) Install nasm  (brew install nasm)
    3) Execute command to generate openh264.a file
           
            i.   make OS=ios ARCH=arm64 SDK_MIN=10
            ii.  make OS=ios ARCH=other architectures( armv7,armv7s,x86_64,i386 ) SDK_MIN=10
            iii. lipo -arch arm64 libopenh264-arm64.a -arch x86_64 libopenh264-x86_64.a -create       -output libopenh264.a
            iv.  Add generated file to xcode project lib

e) Configure Opus
    
    1) Download source code (opus-1.1.2 ) 
       
       https://github.com/xiph/opus
    
    2) Execute commands
        
        i)  ./autogen.sh
        ii) ./configure
        iii) make clean (after every architecture build)
        
        #For Iphone
           
            export CC="xcrun -sdk iphoneos clang -arch arm64"
            export CCAS="xcrun -sdk iphoneos clang -arch arm64 -no-integrated-as"
            sudo ./configure --enable-fixed-point \
                        --disable-doc \
                        --disable-extra-programs  --disable-asm \
                        --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS14.5.sdk --host=arm-apple-darwin
       #For Simulator
            
            export CC="xcrun -sdk iphonesimulator clang -arch x86_64"
            export CCAS="xcrun -sdk iphonesimulator clang -arch x86_64 -no-integrated-as"
            ./configure --enable-fixed-point \
                        --disable-doc \
                        --disable-extra-programs  --disable-asm \
                        --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator14.5.sdk --host=x86_64-apple-darwin

        iv) make; make install
        
        v) Combine using lipo
        
            lipo -arch arm64 libopus-arm64.a -arch i386 libopus-i386.a -arch x86_64 libopus-x86_64.a -create -output libopus.a

f)  Configure OpenSSL

    1. Download project from this link 
    
        https://github.com/x2on/OpenSSL-for-iPhone
    
    2. Execute command in OpenSSL-for-iPhone folder
    
        ./build-libssl.sh 

    3. Copy libssl.a and libcrypto.a to project directory where all libraries are added).

g) Adding required libraries, frameworks and pjsip classes

    1.Create Pjsip group in project directory and add following folders from pjsip sample app (copy from pjproject directory).
        i)   Pjlib
        ii)  Pjlib-util
        iii) Pjmedia
        iv)  Pjnath
        v)   Pjsip
        vi)  Third_party
        
    2. Add combined generated libraries from (STEP A and B)
    3. Add required frameworks

h) Configuring search paths

    1. Header search path
        i)   $(PROJECT_DIR)/pjsip/pjmedia/include
        ii)  $(PROJECT_DIR)/pjsip/pjnath/include
        iii) $(PROJECT_DIR)/pjsip/pjlib/include
        iv)  $(PROJECT_DIR)/pjsip/pjsip/include
        v)   $(PROJECT_DIR)/pjsip/third_party/include
        vi)  $(PROJECT_DIR)/pjsip/pjlib-util/include

    ii.Library search path 
        i)    $(PROJECT_DIR)/lib
        ii)   $(PROJECT_DIR)/pjsip/pjmedia/lib
        iii)  $(PROJECT_DIR)/pjsip/pjnath/lib
        iv)   $(PROJECT_DIR)/pjsip/pjlib/lib
        v)    $(PROJECT_DIR)/pjsip/pjsip/lib
        vi)   $(PROJECT_DIR)/pjsip/third_party/lib
        vii)  $(PROJECT_DIR)/pjsip/pjlib-util/lib

i) Adding Bridging file

    Add following lines in bridging file
    
        #define PJ_AUTOCONF 1
        #import "pjsua.h"


NOTE: Possible scenario for .h file not found: Check into imported directory of pjsip files that actual directory contains all files and folder ( not xcode project directory ).
