
EXE := wmlsi wmlsd

all: $(EXE)

wmlsi: $(wildcard source/*.ooc)
	rock --noclean --sourcepath=source $@

wmlsd: $(wildcard source/*.ooc)
	rock --noclean --sourcepath=source $@

test:
	prove t/*.t

CODING_STD := \
  LineLength \
  HardTabs \
  TrailingSpace \
  CuddledElse \
  CamelCase \
  Parentheses \


export OOC_LINE_LENGTH=80

codingstd: ../ooc-codingstd
	prove --exec="rock -r --sourcepath=../ooc-codingstd/source" $(CODING_STD)

../ooc-codingstd:
	cd .. && git clone git://github.com/fperrad/ooc-codingstd.git

README.html: README.md
	Markdown.pl README.md > README.html

clean:
	rm -rf *_tmp/ .libs/
	rm -f $(CODING_STD) $(EXE)
	rm -f README.html
