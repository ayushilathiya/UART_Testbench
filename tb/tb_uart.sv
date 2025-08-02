// tb_uart.sv – UART Testbench
module tb_uart;

  logic clk = 0;
  logic rst;
  logic start;
  logic [7:0] data_in;
  wire tx;
  wire busy;

  uart #(.CLK_PER_BIT(4)) dut (  // Faster simulation
    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in(data_in),
    .tx(tx),
    .busy(busy)
  );

  // Clock generation: 10ns period (100 MHz)
  always #5 clk = ~clk;

  // Dump waveform
  initial begin
    $dumpfile("uart_wave.vcd");
    $dumpvars(0, tb_uart);
  end

  // Main test sequence
  initial begin
    rst = 1; start = 0; data_in = 8'h00;
    #20 rst = 0;

    // Send 0xA5 (10100101)
    @(negedge clk);
    data_in = 8'hA5;
    start = 1;
    @(negedge clk);
    start = 0;

    // Wait for transmission to complete
    wait (!busy);

    // Send 0x3C (00111100)
    repeat (10) @(negedge clk);
    data_in = 8'h3C;
    start = 1;
    @(negedge clk);
    start = 0;

    wait (!busy);
    #100 $finish;
  end

endmodule
