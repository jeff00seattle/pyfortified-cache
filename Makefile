#   Makefile
#
# license   http://opensource.org/licenses/MIT The MIT License (MIT)
#

.PHONY: clean version build dist local-dev yapf pyflakes pylint

PACKAGE := pyfortified-cache
PACKAGE_PREFIX := pyfortified_cache

PYTHON3 := $(shell which python3)

PY_MODULES := pip setuptools pylint flake8 pprintpp pep8 requests six sphinx wheel python-dateutil

PACKAGE_SUFFIX := py3-none-any.whl
PACKAGE_WILDCARD := $(PACKAGE)-*
PACKAGE_PREFIX_WILDCARD := $(PACKAGE_PREFIX)-*
PACKAGE_PATTERN := $(PACKAGE_PREFIX)-*-$(PACKAGE_SUFFIX)

VERSION := $(shell $(PYTHON3) setup.py version)
WHEEL_ARCHIVE := dist/$(PACKAGE_PREFIX)-$(VERSION)-$(PACKAGE_SUFFIX)

PACKAGE_FILES := $(shell find $(PACKAGE_PREFIX) examples ! -name '__init__.py' -type f -name "*.py")
PACKAGE_ALL_FILES := $(shell find $(PACKAGE_PREFIX) examples -type f -name "*.py")
PACKAGE_EXAMPLE_FILES := $(shell find examples ! -name '__init__.py' -type f -name "*.py")
PYFLAKES_ALL_FILES := $(shell find $(PACKAGE_PREFIX) examples -type f  -name '*.py' ! '(' -name '__init__.py' ')')

TOOLS_REQ_FILE := requirements-tools.txt
REQ_FILE      := requirements.txt
SETUP_FILE    := setup.py
ALL_FILES     := $(PACKAGE_FILES) $(REQ_FILE) $(SETUP_FILE)

# Report the current package version.
version:
	@echo "======================================================"
	@echo version $(PACKAGE)
	@echo "======================================================"
	@echo $(REQUESTS_MV_INTGS_PKG) $(VERSION)

config:
	@echo "======================================================"
	@echo config
	@echo "======================================================"
	@echo PYTHON3 $(PYTHON3)

install-memcached:
	@echo "======================================================"
	@echo install-memcached
	@echo "======================================================"
	@brew update
	@brew install memcached

upgrade-memcached:
	@echo "======================================================"
	@echo upgrade-memcached
	@echo "======================================================"
	@brew upgrade memcached

flush-memcached:
	@echo "======================================================"
	@echo flush-memcached
	@echo "======================================================"
	@echo 'flush_all' | nc localhost 11211

# Install Python 3 via Homebrew.
install-python:
	@echo "======================================================"
	@echo brew-python
	@echo "======================================================"
	@echo $(shell which python3)
	brew uninstall -f python3
	@echo $(shell which python3)
	brew update
	brew install python3
	@echo $(shell which python3)
	$(PYTHON3) -m pip install --upgrade $(PY_MODULES)

clean:
	@echo "======================================================"
	@echo clean $(PACKAGE)
	@echo "======================================================"
	rm -fR tmp/*.json
	rm -fR __pycache__ venv "*.pyc" build/*    \
		$(PACKAGE_PREFIX)/__pycache__/         \
		$(PACKAGE_PREFIX)/helpers/__pycache__/ \
		$(PACKAGE_PREFIX).egg-info/*
	find ./* -maxdepth 0 -name "*.pyc" -type f -delete
	find $(PACKAGE_PREFIX) -name "*.pyc" -type f -delete
	@echo "======================================================"
	@echo delete distributions: $(PACKAGE)
	@echo "======================================================"
	mkdir -p ./dist/
	find ./dist/ -name $(PACKAGE_WILDCARD) -exec rm -vf {} \;
	find ./dist/ -name $(PACKAGE_PREFIX_WILDCARD) -exec rm -vf {} \;

uninstall-package: clean
	@echo "======================================================"
	@echo uninstall-package $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade list
	@if $(PYTHON3) -m pip list | grep -F $(PACKAGE) > /dev/null; then \
		echo "python package $(PACKAGE) Found"; \
		$(PYTHON3) -m pip uninstall --yes $(PACKAGE); \
		echo "uninstall package $(PACKAGE)"; \
	else \
		echo "python package $(PACKAGE) Not Found"; \
	fi

site-packages:
	@echo "======================================================"
	@echo site-packages
	@echo "======================================================"
	$(eval PYTHON3_SITE_PACKAGES := $(shell python3 -c "import site; print(site.getsitepackages()[0])"))
	@echo $(PYTHON3_SITE_PACKAGES)

remove-package: uninstall-package site-packages
	@echo "======================================================"
	@echo remove-package $(PACKAGE_PREFIX)
	@echo "======================================================"
	rm -fR $(PYTHON3_SITE_PACKAGES)/$(PACKAGE_PREFIX)*

install-requirements:
	@echo "======================================================"
	@echo install-requirements $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade pip
	$(PYTHON3) -m pip install -r $(REQ_FILE)
	$(PYTHON3) -m pip uninstall --yes --no-input -r $(REQ_FILE)
	$(PYTHON3) -m pip install --upgrade -r $(REQ_FILE)
	@echo "======================================================"

install-package: remove-package
	@echo "======================================================"
	@echo install-package $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade pip
	@if [ -a $(WHEEL_ARCHIVE) ] ; then \
		echo "python package $(WHEEL_ARCHIVE) Found"; \
		$(PYTHON3) -m pip install --upgrade $(WHEEL_ARCHIVE) ; \
	else \
		echo "python package $(WHEEL_ARCHIVE) Not Found"; \
	fi
	@echo "======================================================"

install: install-requirements install-package
	@echo "======================================================"
	@echo install $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m pip freeze | grep $(PACKAGE)

freeze:
	@echo "======================================================"
	@echo freeze $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade freeze
	$(PYTHON3) -m pip freeze | grep $(PACKAGE)

fresh: dist dist-update install
	@echo "======================================================"
	@echo fresh completed $(PACKAGE)
	@echo "======================================================"

# Register the module with PyPi.
register:
	$(PYTHON3) $(SETUP_FILE) register

local-build: remove-package
	@echo "======================================================"
	@echo local-dev $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade freeze
	$(PYTHON3) -m pip install --upgrade .
	@echo "======================================================"
	$(PYTHON3) -m pip freeze | grep $(PACKAGE)
	@echo "======================================================"

build: clean
	@echo "======================================================"
	@echo remove $(PACKAGE_PREFIX_WILDCARD) and $(PACKAGE_WILDCARD)
	@echo "======================================================"
	mkdir -p ./dist/
	find ./dist/ -name $(PACKAGE_WILDCARD) -exec rm -vf {} \;
	find ./dist/ -name $(PACKAGE_PREFIX_WILDCARD) -exec rm -vf {} \;
	@echo "======================================================"
	@echo build $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade -r $(REQ_FILE)
	$(PYTHON3) $(SETUP_FILE) clean
	$(PYTHON3) $(SETUP_FILE) bdist_wheel
	$(PYTHON3) $(SETUP_FILE) bdist_egg
	$(PYTHON3) $(SETUP_FILE) sdist --format=zip,gztar
	$(PYTHON3) $(SETUP_FILE) build
	$(PYTHON3) $(SETUP_FILE) install
	@echo "======================================================"
	ls -al ./dist/$(PACKAGE_PREFIX_WILDCARD)
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade freeze
	$(PYTHON3) -m pip install --upgrade .
	@echo "======================================================"
	$(PYTHON3) -m pip freeze | grep $(PACKAGE)
	@echo "======================================================"

tools-requirements: $(TOOLS_REQ_FILE)
	@echo "======================================================"
	@echo tools-requirements
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade -r $(TOOLS_REQ_FILE)

pep8: tools-requirements
	@echo "======================================================"
	@echo pep8 $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m pep8 --config .pep8 $(PACKAGE_ALL_FILES)

pyflakes: tools-requirements
	@echo "======================================================"
	@echo pyflakes $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade pyflakes
	$(PYTHON3) -m pyflakes $(PYFLAKES_ALL_FILES)

pylint: tools-requirements
	@echo "======================================================"
	@echo pylint $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade pylint
	$(PYTHON3) -m pylint --rcfile .pylintrc $(PACKAGE_ALL_FILES) --disable=C0330,F0401,E0611,E0602,R0903,C0103,E1121,R0913,R0902,R0914,R0912,W1202,R0915,C0302 | more -30

yapf: tools-requirements
	@echo "======================================================"
	@echo yapf $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m yapf --style .style.yapf --in-place $(PACKAGE_ALL_FILES)

lint: tools-requirements
	@echo "======================================================"
	@echo lint $(PACKAGE)
	@echo "======================================================"
	pylint --rcfile .pylintrc $(PACKAGE_FILES) | more

flake8:
	@echo "======================================================"
	@echo flake8 $(PACKAGE)
	@echo "======================================================"
	flake8 --ignore=F401,E265,E129 $(PACKAGE_PREFIX)

list-package: site-packages
	@echo "======================================================"
	@echo list-packages $(PACKAGE)
	@echo "======================================================"
	ls -al $(PYTHON3_SITE_PACKAGES)/$(PACKAGE_PREFIX)*

run-examples:
	@echo "======================================================"
	@echo run-examples $(PACKAGE)
	@echo "======================================================"
	@echo example_pymemcache_basic
	@echo "======================================================"
	$(PYTHON3) examples/example_pymemcache_basic.py
	@echo "======================================================"
	@echo example_pymemcache_hash
	@echo "======================================================"
	$(PYTHON3) examples/example_pymemcache_hash.py
	@echo "======================================================"
	@echo example_pymemcache_client
	@echo "======================================================"
	$(PYTHON3) examples/example_pymemcache_client.py
	@echo "======================================================"
	$(PYTHON3) examples/example_cache_client.py
	@echo "======================================================"

pypitest-register:
	@echo "======================================================"
	@echo pypitest-register $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) $(SETUP_FILE) register -r pypitest

pypitest-upload:
	@echo "======================================================"
	@echo pypitest-upload $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) $(SETUP_FILE) sdist upload -r pypitest

pypi-register:
	@echo "======================================================"
	@echo pypi-register $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) $(SETUP_FILE) register -r pypi

pypi-upload:
	@echo "======================================================"
	@echo pypi-upload $(PACKAGE)
	@echo "======================================================"
	$(PYTHON3) -m pip install --upgrade -r requirements.txt
	$(PYTHON3) $(SETUP_FILE) sdist bdist_wheel upload -r pypi
	ls -al ./dist/$(PACKAGE_PREFIX_WILDCARD)

list:
	@echo "======================================================"
	@echo Makefile target list
	@echo "======================================================"
	cat Makefile | grep "^[a-z]" | awk '{print $$1}' | sed "s/://g" | sort
