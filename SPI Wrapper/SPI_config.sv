package SPI_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class SPI_config extends uvm_object;
        `uvm_object_utils(SPI_config)

        virtual SPI_if SPI_vif;
        virtual SPI_SLAVE_if SPI_SLAVE_vif;
        virtual RAM_if RAM_vif;
        uvm_active_passive_enum is_active;

        function new(string name = "SPI_config");
            super.new(name);
        endfunction
    endclass
    
endpackage