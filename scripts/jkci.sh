#变量
TARGET_NAME="xxxxx"
APPDISPLAY_NAME="xxxxx"
CODE_SIGN="iPhone Distribution: xxxxxxxxxxxx., Ltd."
BUILD_DIR="${WORKSPACE}/build"
IPA_DIR="${WORKSPACE}/ipa"

#环境变量的更改
if ${host_distribution}; then
BUILD_CONFIG="In_house_out"
else
BUILD_CONFIG="In_house_in"
fi

#首先，清除build记录：
xcodebuild clean -workspace $TARGET_NAME.xcworkspace -scheme $TARGET_NAME -configuration $BUILD_CONFIG
#设置build号
xcrun agvtool new-version -all ${BUILD_NUMBER}
#其次，执行build：
xcodebuild -workspace $TARGET_NAME.xcworkspace -scheme $TARGET_NAME -configuration $BUILD_CONFIG build BUILD_DIR=$BUILD_DIR BUILD_ROOT="${WORKSPACE}/buildRoot" CODE_SIGN_IDENTITY="$CODE_SIGN"

#创建输出目录
mkdir -p $IPA_DIR
cp -f -r $BUILD_DIR/$BUILD_CONFIG-iphoneos/$TARGET_NAME.app.dSYM $IPA_DIR
#最后，将app打包为ipa：
/usr/bin/xcrun -sdk iphoneos PackageApplication -v $BUILD_DIR/$BUILD_CONFIG-iphoneos/$APPDISPLAY_NAME.app -o ${WORKSPACE}/ipa/$APPDISPLAY_NAME${BUILD_NUMBER}.ipa
