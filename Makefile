run:
	@cp ./gamemodes/crl2.amx /opt/open.mp/data/gamemodes/crl2.amx
	@docker restart samp-server

build:
	@sampctl build

push:
	@git push origin master --follow-tags
