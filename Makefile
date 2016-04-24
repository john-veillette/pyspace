SRC = $(shell pwd)

all: build

.PHONY: build docs

docs:
	cd docs; make html

build:
	python setup.py build_ext

clean:
	rm -r -f pyspace/*.cpp

cleanall:
	rm -r -f pyspace/*.cpp
	rm -r -f pyspace/*.so

install:
	python setup.py install

develop:
	python setup.py develop


