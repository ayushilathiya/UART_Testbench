// uart.v – UART Transmitter Module
module uart (
  input wire clk,         // System clock
  input wire rst,         // Reset
  input wire start,       // Start signal to begin transmission
  input wire [7:0] data_in, // 8-bit parallel data input
  output reg tx,          // Serial output
  output reg busy         // Indicates transmission in progress
);

  parameter CLK_PER_BIT = 16; // Clock cycles per bit (baud rate control)

  reg [3:0] bit_index = 0;     // Bit position counter
  reg [7:0] shift_reg = 0;     // Data shift register
  reg [4:0] clk_count = 0;     // Clock counter
  reg [2:0] state = 0;

  localparam IDLE  = 3'b000;
  localparam START = 3'b001;
  localparam DATA  = 3'b010;
  localparam STOP  = 3'b011;
  localparam DONE  = 3'b100;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      tx <= 1'b1;
      busy <= 1'b0;
      bit_index <= 0;
      clk_count <= 0;
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          tx <= 1'b1;
          busy <= 1'b0;
          if (start) begin
            busy <= 1'b1;
            shift_reg <= data_in;
            state <= START;
          end
        end

        START: begin
          tx <= 1'b0; // Start bit
          if (clk_count < CLK_PER_BIT - 1)
            clk_count <= clk_count + 1;
          else begin
            clk_count <= 0;
            state <= DATA;
          end
        end

        DATA: begin
          tx <= shift_reg[bit_index];
          if (clk_count < CLK_PER_BIT - 1)
            clk_count <= clk_count + 1;
          else begin
            clk_count <= 0;
            if (bit_index < 7)
              bit_index <= bit_index + 1;
            else begin
              bit_index <= 0;
              state <= STOP;
            end
          end
        end

        STOP: begin
          tx <= 1'b1; // Stop bit
          if (clk_count < CLK_PER_BIT - 1)
            clk_count <= clk_count + 1;
          else begin
            clk_count <= 0;
            state <= DONE;
          end
        end

        DONE: begin
          busy <= 1'b0;
          state <= IDLE;
        end
      endcase
    end
  end

endmodule
