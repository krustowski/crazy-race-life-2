DB_ROOT_PASSWORD	?= xxx
DB_USER			?= 
DB_PASSWROD		?=
DB_NAME			?=

run: migrate
	@cp ./gamemodes/crl2.amx /opt/open.mp/data/gamemodes/crl2.amx
	@docker restart samp-server

build:
	@sampctl build --verbose --relativePaths

push:
	@git push origin master --follow-tags

watch:
	@sampctl build --watch

schema:
	@sqlite3 crl2_data.db '.schema' > sql/base.sql

migrate:
	@./utils/goose -dir ./sql/migrations sqlite3 crl2_data.db up

.PHONY: tests

tests:
	@LD_LIBRARY_PATH=${HOME}/.config/sampctl/pawn/openmultiplayer/compiler/v3.10.11 DYLD_LIBRARY_PATH=${HOME}/.config/sampctl/pawn/openmultiplayer/compiler/v3.10.11 \
		${HOME}/.config/sampctl/pawn/openmultiplayer/compiler/v3.10.11/pawncc \
		${PWD}/tests/run_tests.pwn \
		-D${PWD}/src \
		-D${PWD}/tests \
		-o${PWD}/gamemodes/crl2_tests.amx \
		-d3 \
		-Z+ \
		-i${PWD} \
		-i${PWD}/src \
		-i${PWD}/dependencies/omp-stdlib
	@./samp03svr -c configs/test_server.cfg

