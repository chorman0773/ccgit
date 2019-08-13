

ifeq $(target),api
$(src) := api-template.lua.in
else
$(src) := program-template.lua.in
endif

$(bootstrap-cycles) := 2

$(bootstrap-targets) = $(foreach cycle,$(shell echo {1..$(bootstrap-cycles)}),bootstrap$(cycle).lua)

$(foreach cycle,$(shell echo {1..$(bootstrap-cycles)}),
bootstrap$(cycle).lua: $(src)
	gcc -E -undef -DNUM_BOOTSTRAP_CYCLES=$(bootstrap-cyclces) -DCYCLE=$(cycle) $@ $^
)

bootstrap: $(bootstrap-targets)
