.PHONY: clean

SOURCE_DIR := source
OUTPUT_DIR := output
FORMAT     := pdf

all: main.puml

%.puml:
	plantuml -output ../$(OUTPUT_DIR) -t$(FORMAT) $(SOURCE_DIR)/$@

clean:
	rm -rf $(OUTPUT_DIR)
