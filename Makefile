SRC = $(shell pwd)

all: build

.PHONY: build docs

docs:
	cd docs; make html

build:
	python2 setup.py build_ext --inplace

clean:
	python2 setup.py clean
	rm -r -f pyspace/*.cpp

cleanall: clean
	rm -r -f pyspace/*.so

install:
	python2 setup.py install

develop:
	python2 setup.py develop

test:
	python2 `which nosetests` --exe -v pyspace

