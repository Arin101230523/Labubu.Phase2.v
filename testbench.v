module testbench();
    reg clk, rst;
    reg [31:0] A;
    reg [3:0] opcode;
    wire [31:0] C;
    wire error;
    wire [3:0] status;

    // Unit Under Test
    breadboard dut(clk, rst, A, opcode, C, error, status);

    // Clock Generation
    initial begin 
        clk = 0; 
        forever #5 clk = ~clk; 
    end

    // Task to run ops
    task run_op;
        input [3:0] op;
        input [31:0] val;
        reg [127:0] cmd_name;
        reg [79:0]  sname;
        reg [15:0]  fb;
        reg [31:0]  fb32;
        begin
            // Capture feedback BEFORE clock edge
            fb = C[15:0];
            fb32 = {16'b0, fb};

            opcode = op;
            A = val;
            @(posedge clk); #2;

            // Map binary to Labubu Opcode names
            case(op)
                4'b0000: cmd_name = "STARE (NOP)";
                4'b0001: cmd_name = "SLEEP (RST)";
                4'b0010: cmd_name = "SNACK (ADD)";
                4'b0011: cmd_name = "DRAIN (SUB)";
                4'b0100: cmd_name = "FART (DIV)";
                4'b0101: cmd_name = "POOP (MOD)";
                4'b0110: cmd_name = "SUGAR (MUL)";
                4'b0111: cmd_name = "ZOOM (SHL)";
                4'b1000: cmd_name = "NAP (SHR)";
                4'b1001: cmd_name = "GIGGLE (XOR)";
                4'b1010: cmd_name = "PARTY (OR)";
                4'b1011: cmd_name = "GRUMPY (AND)";
                4'b1100: cmd_name = "GHOST (NOT)";
                4'b1101: cmd_name = "DANCE (SWAP)";
                4'b1110: cmd_name = "MAXOUT (MAX)";
                4'b1111: cmd_name = "MINOUT (MIN)";
                default: cmd_name = "UNKNOWN";
            endcase

            // Status Decoding
            if (status == 4'b0000) sname = "OK";
            else if (status == 4'b0001) sname = "ADD_OVF";
            else if (status == 4'b0010) sname = "SUB_UNF";
            else if (status == 4'b0011) sname = "DIV_BY0";
            else if (status == 4'b0100) sname = "MOD_BY0";
            else if (status == 4'b0101) sname = "MUL_OVF";
            else sname = "UNKNOWN";
            
            $display("Time:%5t | CMD:%-15s | Op:%b | FB Loop:0x%h | Input:0x%h | Res:0x%h | Stat:%b [%0s]", 
                      $time, cmd_name, op, fb32, val, C, status, sname);
        end
    endtask

    initial begin
        $display("Test Results:");
        
        // Reset
        rst = 1; A = 0; opcode = 4'b0001; // SLEEP (RST)
        @(posedge clk); #2;
        rst = 0;
        $display("Reset Complete. ACC1: 0x%h", C);

        // Basic Math
        run_op(4'b0010, 32'h00001000); // SNACK (ADD)
        run_op(4'b0010, 32'h00001000); // SNACK (ADD)
        run_op(4'b0010, 32'h00001000); // SNACK (ADD)
        run_op(4'b0011, 32'h00000500); // DRAIN (SUB)
        run_op(4'b0110, 32'h00000002); // SUGAR (MUL)
        run_op(4'b0100, 32'h00000002); // FART (DIV)
        run_op(4'b0101, 32'h00000100); // POOP (MOD)

        // Logic & Bitwise
        run_op(4'b1011, 32'h00000007); // GRUMPY (AND)
        run_op(4'b1010, 32'h00000010); // PARTY (OR)
        run_op(4'b1001, 32'h00000017); // GIGGLE (XOR)
        run_op(4'b1100, 32'h00000000); // GHOST (NOT)
        
        // Shifting & Swapping
        run_op(4'b0001, 32'h00000000); // SLEEP (RST)
        run_op(4'b0010, 32'h00000001); // SNACK (ADD)
        run_op(4'b0111, 32'h00000000); // ZOOM (SHL)
        run_op(4'b1000, 32'h00000000); // NAP (SHR)
        run_op(4'b1101, 32'h00000000); // DANCE (SWAP)

        // Constants & State
        run_op(4'b0000, 32'hFFFFFFFF); // STARE (NOP)
        run_op(4'b1110, 32'h00000000); // MAXOUT (MAX)
        run_op(4'b1111, 32'h00000000); // MINOUT (MIN)

        // Errors & Feedback Proof
        run_op(4'b0100, 32'h00000000); // FART (DIV)
        run_op(4'b0101, 32'h00000000); // POOP (MOD)
        
        run_op(4'b1110, 32'h00000000); // MAXOUT (MAX)
        run_op(4'b0010, 32'h00000001); // SNACK (ADD), 16-bit Proof

        $display("Done");
        #10 $finish;
    end
endmodule