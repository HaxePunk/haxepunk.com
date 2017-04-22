HAXEPUNK_PATH=$(shell haxelib path HaxePunk | head -1)
SITE_PATH=$(shell pwd)
COMMAND=openfl

define DEMO_HEADER
layout: demo
directory: TITLE
thumb: TITLE.jpg
source: https://github.com/HaxePunk/HaxePunk-examples/tree/dev/TITLE
endef

export DEMO_HEADER

.PHONY: all docs demos site serve

all: clean docs demos site

clean:
	rm -rf demos/*.md demos/html5/* demos/thumb/*.jpg documentation/api
	touch demos/html5/.gitignore

site:
	jekyll build

serve:
	jekyll serve --watch --baseurl "/"

docs:
	cd $(HAXEPUNK_PATH) && make docs && rm -rf $(SITE_PATH)/documentation/api && cp -r doc/pages $(SITE_PATH)/documentation/api

demos:
	cd $(HAXEPUNK_PATH) && make examples COMMAND=$(COMMAND) TARGET=html5 && \
	for i in `find examples -mindepth 1 -maxdepth 1 -type d`; do \
		TITLE=`basename $$i`; \
		cp -r $$i/bin/html5/release/bin $(SITE_PATH)/demos/html5/$$TITLE; \
		cp $$i/thumb.jpg $(SITE_PATH)/demos/thumb/$$TITLE.jpg; \
		echo "---" > $(SITE_PATH)/demos/$$TITLE.md; \
		echo "$$DEMO_HEADER" | sed "s/TITLE/$$TITLE/g" >> $(SITE_PATH)/demos/$$TITLE.md; \
		cat $$i/data.md >> $(SITE_PATH)/demos/$$TITLE.md; \
		echo "---" >> $(SITE_PATH)/demos/$$TITLE.md; \
		cat $$i/README.md >> $(SITE_PATH)/demos/$$TITLE.md; \
		rm -f $(SITE_PATH)/demos/$$TITLE.html; \
	done
