HELMFILE ?= ./helmfile.yaml
K0SFILE ?= ./k0sctl.yaml
ENVIRONMENTS ?= networking kike.wtf hackr.es



.PHONY: default
default: install

.PHONY: install
install: k0s start

.PHONY: start
start:
	$(foreach environment, $(ENVIRONMENTS), ACTION=sync $(MAKE) $(environment);)

.PHONY: update upgrade
update upgrade: $(ENVIRONMENTS)

.PHONY: stop
stop:
	$(foreach environment, $(ENVIRONMENTS), ACTION=delete $(MAKE) $(environment);)

.PHONY: uninstall
uninstall:
	ACTION=reset $(MAKE) k0s

.PHONY: art
art:
	find ./helm -type f -name 'NOTES.txt' -exec cat {} \;



ACTION ?= apply
.PHONY: k0s
k0s: $(K0SFILE)
ifeq ($(ACTION),reset)
	$(eval FLAGS=--force)
else
	$(eval ACTION=apply)
endif
	k0sctl $(ACTION) --config $< $(FLAGS)
ifeq ($(ACTION),apply)
	k0sctl kubeconfig --config $< > $(KUBECONFIG)
endif

.PHONY: $(ENVIRONMENTS)
$(ENVIRONMENTS): $(HELMFILE)
	{                                                \
		set -a; . ./.env; set +a;                    \
		DOMAIN=$@;                                   \
		DUCKDNS_SUBDOMAINS=$$(echo $@ | tr -d '.');  \
		helmfile --file $< deps update;              \
		helmfile --file $< --selector env=$$(echo $@ | tr -d '.') $(ACTION); \
	}