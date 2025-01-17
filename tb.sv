`timescale 1ns / 1ps

class transaction;
  randc bit [3:0] a,b;
  bit [7:0] mul;
  
  function void display();
    $display("a: %0d   b: %0d    mul: %0d", a,b,mul);
  endfunction
  
  function transaction copy();
    copy = new();
    copy.a = this.a;
    copy.b = this.b;
    copy.mul = this.mul;
  endfunction 
endclass 

class generator;
  transaction trans; 
  mailbox #(transaction) mbx; 
  event done;
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    trans = new();
  endfunction 
  task main();
    for (int i = 0; i<10; i++) begin 
      trans.randomize();
      mbx.put(trans.copy);
      $display("Data sent from GEN");
      trans.display();
      #20;
    end 
    -> done;
  endtask 
endclass 

interface mul_if;
  logic [3:0] a,b;
  logic [7:0] mul;
  logic clk;
endinterface 

class driver;
  virtual mul_if mif;
  mailbox #(transaction) mbx;
  transaction c_data; //container 
  event next; //for sync 
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction 
  
  task main();
    forever begin 
      mbx.get(c_data);
      @(posedge mif.clk);  //wait for clk edge
      mif.a <= c_data.a;
      mif.b <= c_data.b;
      $display("Driver interface trigger");
      c_data.display();
    end 
  endtask 
endclass 

module tb;
  mul_if mif();
  driver drv;
  generator gen;
  event done;
  mailbox #(transaction) mbx; 
  top dut (.a(mif.a), .b(mif.b), .mul(mif.mul), .clk(mif.clk) ); //name mapping 
  initial begin 
    mif.clk <= 0; 
  end 
  always #10 mif.clk <= ~mif.clk; 
  initial begin 
    mbx = new();
    gen = new(mbx);
    drv = new(mbx);
    drv.mif = mif;
    done = gen.done; 
  end 
  
  initial begin 
    fork 
      gen.main();
      drv.main();
    join_none 
    wait(done.triggered);
    $finish();
  end 
  
  //waveform files 
  initial begin 
  $dumpfile("dump.vcd");
  $dumpvars;
  end 
endmodule 
