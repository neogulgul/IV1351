.PHONY: yes no both clean

SOURCE_DIR := source
OUTPUT_DIR := output
FORMAT     := pdf

.DEFAULT_GOAL := yes

yes: inheritence.puml

no: no_inheritence.puml

both: yes no

%.puml:
	plantuml -output ../$(OUTPUT_DIR) -t$(FORMAT) $(SOURCE_DIR)/$@

clean:
	rm -rf $(OUTPUT_DIR)
