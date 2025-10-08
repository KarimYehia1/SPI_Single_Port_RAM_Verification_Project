package ram_env_pkg;
import uvm_pkg::*;
import ram_scoreboard_pkg::*;
import ram_coverage_pkg::*;
import ram_agent_pkg::*;
`include "uvm_macros.svh"

class ram_env extends uvm_env;
    `uvm_component_utils(ram_env)
    ram_scoreboard sb;
    ram_coverage cov;
    ram_agent agt;

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb = ram_scoreboard::type_id::create("sb", this);
        cov = ram_coverage::type_id::create("cov", this);
        agt = ram_agent::type_id::create("agt", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.agt_ap.connect(sb.sb_export);
        agt.agt_ap.connect(cov.cov_export);
    endfunction
endclass
endpackage