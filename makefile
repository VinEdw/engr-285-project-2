SCRIPT_DIR := ./scripts
OUTPUT_DIR := ./output

SCRIPTS := $(shell find $(SCRIPT_DIR) -type f -name '*.py')
OUTPUTS := $(SCRIPTS:$(SCRIPT_DIR)/%.py=$(OUTPUT_DIR)/%.output)

project-2.pdf: project-2.typ engr-conf.typ $(OUTPUTS)
	typst compile $<

$(OUTPUT_DIR)/%.output: $(SCRIPT_DIR)/%.py
	@mkdir -p $(dir $@)
	@mkdir -p media
	python $< > $@

$(OUTPUT_DIR)/projectile.py: $(SCRIPT_DIR)/rk4.py
$(OUTPUT_DIR)/motion_interdependence.py: $(SCRIPT_DIR)/projectile.py
$(OUTPUT_DIR)/trajectory_shapes.py: $(SCRIPT_DIR)/projectile.py
$(OUTPUT_DIR)/firing_range.py: $(SCRIPT_DIR)/projectile.py
$(OUTPUT_DIR)/hitting_fixed_target.py: $(SCRIPT_DIR)/projectile.py

.PHONY: clean
clean: 
	rm -r $(OUTPUT_DIR)
