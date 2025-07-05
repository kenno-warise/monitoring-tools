PROJECT_NAME := monitoring-tools

VERSION := $(shell git describe --tags --abbrev=0)

.PHONY: setup

setup:
	@echo "🚀 最新バージョンのチェックと更新"
	./setup.sh

release:
	@echo "GitHubにリリース"
	git commit -m "$(BRANCH)"
	git tag -a v$(VERSION) -m "v$(VERSION) リリース"
	git push origin $(BRANCH)
	git push origin $(VERSION)
