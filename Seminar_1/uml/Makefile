.PHONY: all clean

PUML_FILES := main.puml

SOURCE_DIR := source
OUTPUT_DIR := output
FORMAT     := pdf

PUML_FILES := $(patsubst %, $(SOURCE_DIR)/%, $(PUML_FILES))

all:
	plantuml -output ../$(OUTPUT_DIR) -t$(FORMAT) $(PUML_FILES)

clean:
	rm -rf $(OUTPUT_DIR)
