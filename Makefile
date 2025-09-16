LUA_PATH := ./lua/?.lua;./lua/?/init.lua;;

fmt:
	echo "===> Formatting"
	stylua lua/ --config-path=.stylua.toml

lint:
	echo "===> Linting"
	luacheck lua/ --globals vim
test:
	@echo "===> Running tests"
	LUA_PATH="$(LUA_PATH)" busted lua/header-guard/tests/

clean:
	echo "===> Cleaning"
	rm /tmp/lua_*

pr-ready: fmt lint test

