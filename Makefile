ZIP_NAME ?= "TrayLinkManager.zip"
PLUGIN_NAME = "tray-link-manager"

# coffescript-files to compile
COFFEE_FILES = tray-link-manager.coffee
	

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: build ## build all

build: clean buildinfojson ## clean, compile, copy files to build folder

				mkdir -p build
				mkdir -p build/$(PLUGIN_NAME)
				mkdir -p build/$(PLUGIN_NAME)/webfrontend
				mkdir -p build/$(PLUGIN_NAME)/l10n

				mkdir -p src/tmp # build code from coffee
				cp src/webfrontend/*.coffee src/tmp
                
				cd src/tmp && coffee -b --compile ${COFFEE_FILES} # bare-parameter is obligatory!
				cat src/tmp/*.js > build/$(PLUGIN_NAME)/webfrontend/TrayLinkManager.js

				rm -rf src/tmp # clean tmp

				cp l10n/tray-link-manager.csv build/$(PLUGIN_NAME)/l10n/TrayLinkManager.csv # copy l10n

				cp src/webfrontend/css/main.css build/$(PLUGIN_NAME)/webfrontend/TrayLinkManager.css # copy css
				cp manifest.master.yml build/$(PLUGIN_NAME)/manifest.yml # copy manifest

				cp build-info.json build/$(PLUGIN_NAME)/build-info.json

buildinfojson:
	repo=`git remote get-url origin | sed -e 's/\.git$$//' -e 's#.*[/\\]##'` ;\
	rev=`git show --no-patch --format=%H` ;\
	lastchanged=`git show --no-patch --format=%ad --date=format:%Y-%m-%dT%T%z` ;\
	builddate=`date +"%Y-%m-%dT%T%z"` ;\
	echo '{' > build-info.json ;\
	echo '  "repository": "'$$repo'",' >> build-info.json ;\
	echo '  "rev": "'$$rev'",' >> build-info.json ;\
	echo '  "lastchanged": "'$$lastchanged'",' >> build-info.json ;\
	echo '  "builddate": "'$$builddate'"' >> build-info.json ;\
	echo '}' >> build-info.json

clean: ## clean
				rm -rf build

zip: build ## build zip file
			cd build && zip ${ZIP_NAME} -r $(PLUGIN_NAME)/
