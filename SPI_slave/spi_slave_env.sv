
package spi_slave_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_agent_pkg::*;
import spi_slave_scoreboard_pkg::*;
import spi_slave_collector_package::*;
class spi_slave_env extends uvm_env;
  
      `uvm_component_utils(spi_slave_env);
      spi_slave_scoreboard score;
       spi_slave_coverage cover_grp;
     spi_slave_agent agt;
      function new(string name ="spi_slave_env",uvm_component parent =null);
    super.new(name,parent);
    endfunction
   function void build_phase (uvm_phase phase);
   super.build_phase(phase);
   agt = spi_slave_agent :: type_id ::create("agt",this);
   score =   spi_slave_scoreboard :: type_id :: create("score",this);
   cover_grp = spi_slave_coverage  ::type_id ::create("cover_grp",this);
   
   endfunction
   function void connect_phase (uvm_phase phase);
   agt.agt_ap.connect(score.sb_export);
   agt.agt_ap.connect(cover_grp.cov_export);
   endfunction
endclass
endpackage