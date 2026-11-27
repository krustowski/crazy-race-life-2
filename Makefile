DB_ROOT_PASSWORD	?= xxx
DB_USER				?= 
DB_PASSWROD			?=
DB_NAME				?=

#run: migrate
#	@cp ./gamemodes/crl2.amx /opt/open.mp/data/gamemodes/crl2.amx
#	@docker restart samp-server

# DEBUG=1 builds with the debug output on (the "debug" build in pawn.json,
# which passes DEBUG_ENABLED=1 to pawncc); the default "main" build has it off.
build:
	@sampctl build $(if $(DEBUG),debug) --verbose --relativePaths

push:
	@git push origin master --follow-tags

watch:
	@sampctl build --watch

schema:
	@sqlite3 crl2_data.db '.schema' > sql/base.sql

migrate:
	@./utils/goose -dir ./sql/migrations sqlite3 crl2_data.db up

airline:
	@python3 utils/airline/gen_recordings.py npcmodes/recordings
	@LD_LIBRARY_PATH=${HOME}/.config/sampctl/pawn/openmultiplayer/compiler/v3.10.11 DYLD_LIBRARY_PATH=${HOME}/.config/sampctl/pawn/openmultiplayer/compiler/v3.10.11 \
		${HOME}/.config/sampctl/pawn/openmultiplayer/compiler/v3.10.11/pawncc \
		${PWD}/filterscripts/airline.pwn \
		-o${PWD}/filterscripts/airline.amx \
		-d3 \
		-Z+ \
		-i${PWD}/dependencies/omp-stdlib

.PHONY: tests docs docs-check

# The tests run on ./omp-server against the real natives (NPCs as players) and
# on a DB built fresh from the migrations. Results land in log.txt; the target
# prints them and fails unless every test passed. omp-server ignores both
# SendRconCommand("exit") and (this early in its life) SIGINT, so once the
# summary, or a run time error that aborted the suite, is logged, "exit" is
# typed into its console instead. DEBUG=1 compiles the tests with the debug
# output on, as `make build DEBUG=1` does for the gamemode. No -Z+ here: like
# `make build`, a file is read again at every #include and only its include
# guard stops it, so a file without one fails here as it would there.
TEST_DB			?= scriptfiles/crl2_test.db
TEST_TIMEOUT	?= 60
TEST_DONE		= Success Rate:|Run time error

tests:
	@LD_LIBRARY_PATH=${HOME}/.config/sampctl/pawn/openmultiplayer/compiler/v3.10.11 DYLD_LIBRARY_PATH=${HOME}/.config/sampctl/pawn/openmultiplayer/compiler/v3.10.11 \
		${HOME}/.config/sampctl/pawn/openmultiplayer/compiler/v3.10.11/pawncc \
		${PWD}/tests/run_tests.pwn \
		-D${PWD}/src \
		-D${PWD}/tests \
		-o${PWD}/gamemodes/crl2test.amx \
		-d3 \
		-i${PWD} \
		-i${PWD}/src \
		-i${PWD}/dependencies/omp-stdlib \
		$(if $(DEBUG),DEBUG_ENABLED=1)
	@rm -f $(TEST_DB)
	@out=$$(./utils/goose -dir ./sql/migrations sqlite3 $(TEST_DB) up 2>&1) || { echo "$$out"; exit 1; }
	@start=$$(wc -l < log.txt 2>/dev/null || echo 0); \
	ulimit -c 0; \
	{ \
		for i in $$(seq $$(( $(TEST_TIMEOUT) * 5 ))); do \
			tail -n +$$((start + 1)) log.txt 2>/dev/null | grep -qE '$(TEST_DONE)' && break; \
			sleep 0.2; \
		done; \
		echo exit; \
	} | timeout -s INT -k 10 $(TEST_TIMEOUT) ./omp-server crl2test > /dev/null 2>&1; \
	tail -n +$$((start + 1)) log.txt | sed 's/^\[[^]]*\] \[[A-Za-z]*\] //' \
		| grep -E '^\[(TEST [0-9]+|FAIL)\]|^(Total Tests|Passed|Failed|Success Rate):|Run time error'; \
	tail -n +$$((start + 1)) log.txt | grep -qE 'Failed: 0$$'

plot:
	@gnuplot < configs/gnuplot.cfg > gnuplot.html

docs:
	@mkdocs build

# Checks that the `file.pwn:N` references in docs/ still point at the code they
# name, and fails when one has drifted. FIX=1 rewrites the ones it can follow to
# their new line (through git history, or to a function's definition);
# VERBOSE=1 also lists the references it cannot check.
docs-check:
	@python3 -I utils/docscheck/check_line_refs.py $(if $(FIX),--fix) $(if $(VERBOSE),--verbose)

# The portal (portal, stats, images, stack-*) is in Makefile.local, kept out of
# git for now with its sources; its targets exist only where that file does.
-include Makefile.local
