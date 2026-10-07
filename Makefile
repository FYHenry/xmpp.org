UV=uv
PY=$(UV) run python
HUGO=hugo

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/public

UV_SYSTEM=""

BASEURL=https://xmpp.org/
BUILDFUTURE=""

help:
	@echo 'Makefile for xmpp.org                                                  '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make clean                       remove the generated files         '
	@echo '   make serve                       serve site at http://localhost:1313'
	@echo '   make publish                     generate using production settings '
	@echo '                                                                       '

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

serve:
	$(UV) sync --group dev
	$(UV) run pre-commit install
	$(PY) src/prepare_xep_list.py
	$(PY) src/prepare_rfc_list.py
	$(PY) src/prepare_software_list.py
	$(HUGO) version
	$(HUGO) server --bind=0.0.0.0 --baseURL="http://localhost/" --buildFuture

publish:
	$(UV) sync
	$(PY) src/prepare_xep_list.py
	$(PY) src/prepare_rfc_list.py
	$(PY) src/lint_software_list.py software.json
	$(PY) src/prepare_software_list.py
	$(HUGO) version
	$(HUGO) --baseURL=$(BASEURL) $(BUILDFUTURE)

.PHONY: help clean serve publish
