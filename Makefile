DB_ROOT_PASSWORD	?= xxx
DB_USER			?= 
DB_PASSWROD		?=
DB_NAME			?=

run:
	@cp ./gamemodes/crl2.amx /opt/open.mp/data/gamemodes/crl2.amx
	@docker restart samp-server

build:
	@sampctl build --verbose --relativePaths

push:
	@git push origin master --follow-tags

watch:
	@sampctl build --watch
