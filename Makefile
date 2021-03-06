VERSION = 0.0.1

FLAGS = --release --split-debug-info=debug_symbols --obfuscate
WEB_FLAGS = --release
IOS_FLAGS = $(FLAGS)
APK_FLAGS = $(FLAGS) --shrink

all: web ios android

android: apk cleanartifacts

ios: app ipa deb cleanartifacts

web:
	flutter build web $(WEB_FLAGS)

app:
	mkdir -p debug_symbols
	flutter build ios $(IOS_FLAGS)
	xcrun bitcode_strip build/ios/Release-iphoneos/Runner.app/Frameworks/Flutter.framework/Flutter -r -o tmpfltr
	mv -f tmpfltr build/ios/Release-iphoneos/Runner.app/Frameworks/Flutter.framework/Flutter

ipa:
	mkdir Payload
	cp -r build/ios/Release-iphoneos/Runner.app Payload
	zip -r -9 $(VERSION).ipa Payload

deb:
	./build_deb.bash $(VERSION)

apk:
	mkdir -p debug_symbols
	flutter build apk $(APK_FLAGS)
	mv build/app/outputs/apk/release/app-release.apk $(VERSION).apk

cleanartifacts:
	mkdir -p bin
	mv -f $(VERSION).* bin
	flutter clean
	rm -rf Payload debug_symbols

.PHONY: cleanartifacts web ios ipa apk
