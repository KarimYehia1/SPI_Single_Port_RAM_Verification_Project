package ram_cfg_obj_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_cfg_obj extends uvm_object;
    `uvm_object_utils(ram_cfg_obj)
    virtual ram_if ram_vif;

    function new(string name = "cfg_obj");
        super.new(name);
    endfunction
endclass
endpackage