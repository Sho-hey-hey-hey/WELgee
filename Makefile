CSS_SRCS:=$(wildcard src/css/*.css)
HTML_SRCS:=$(shell find src/html -name "*.html")
CSS_SRCS:=$(shell find src/css -name "*.css")
HTML_PUBS:=$(HTML_SRCS:src/html/%=public/%)
CSS_PUBS:=$(CSS_SRCS:src/%=public/%)

.PHONY: all local
all: $(HTML_PUBS) $(CSS_PUBS)

public/%.html: src/html/header.html.tmpl src/html/footer.html.tmpl src/html/%.html
	mkdir -p $(dir $@)
	HEADER=$$(IMG_URL=$(CDN_URL) envsubst < src/html/header.html.tmpl) \
	FOOTER=$$(IMG_URL=$(CDN_URL) envsubst < src/html/footer.html.tmpl) \
	IMG_URL=$(CDN_URL) \
	envsubst < $(@:public/%=src/html/%) > $@

public/css/%.css: src/css/%.css
	mkdir -p $(dir $@)
	IMG_URL=$(CDN_URL) envsubst < $< > $@

local:
	CDN_URL=/img make all

debug:
	@echo CDN_URL $(CDN_URL)
	@echo HTML_SRCS $(HTML_SRCS)
	@echo HTML_PUBS $(HTML_PUBS)

run:
	docker run --rm -v $(CURDIR)/public:/usr/share/nginx/html -p 8001:80 nginx

clean:
	rm -rf public/*.html public/join-us/*.html public/news/*.html public/css/