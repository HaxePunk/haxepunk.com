HAXEPUNK_PATH=$(shell haxelib path HaxePunk | head -1)
SITE_PATH=$(shell pwd)

define DEMO_HEADER
layout: demo
swf: TITLE
thumb: TITLE.jpg
source: https://github.com/HaxePunk/HaxePunk-examples/tree/dev/TITLE
endef

export DEMO_HEADER

.PHONY: all site serve demos

all: docs demos site clean

clean:
	rm -rf demos/*.md demos/swf/*.swf demos/thumb/*.jpg documentation/api

site:
	jekyll build

serve:
	jekyll serve --watch --baseurl "/"

docs:
	cd $(HAXEPUNK_PATH) && make docs && rm -rf $(SITE_PATH)/documentation/api && cp -r doc/pages $(SITE_PATH)/documentation/api

demos:
	cd $(HAXEPUNK_PATH) && make examples COMMAND=openfl TARGET=flash && \
	for i in `find examples -mindepth 1 -maxdepth 1 -type d`; do \
		TITLE=`basename $$i`; \
		cp `find $$i/bin -name "*.swf" | head -1` $(SITE_PATH)/demos/swf/$$TITLE.swf; \
		cp $$i/thumb.jpg $(SITE_PATH)/demos/thumb/$$TITLE.jpg; \
		echo "---" > $(SITE_PATH)/demos/$$TITLE.md; \
		echo "$$DEMO_HEADER" | sed "s/TITLE/$$TITLE/g" >> $(SITE_PATH)/demos/$$TITLE.md; \
		cat $$i/data.md >> $(SITE_PATH)/demos/$$TITLE.md; \
		echo "---" >> $(SITE_PATH)/demos/$$TITLE.md; \
		cat $$i/README.md >> $(SITE_PATH)/demos/$$TITLE.md; \
	done
