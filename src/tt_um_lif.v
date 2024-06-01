`default_nettype none

module tt_um_lif (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;

    // Default value for the 7 lower bits of uio_out
    assign uio_out[5:0] = 6'd0;

    wire spike1, spike2;
    wire [7:0] state1, state2;

    // Driving uo_out with state1 and state2 (example usage, modify as needed)
    assign uo_out = state1;

    // Instantiate the first LIF neuron
    lif lif1(
        .current(ui_in),
        .clk(clk),
        .rst_n(rst_n),
        .spike(spike1),
        .state(state1)
    );

    // Instantiate the second LIF neuron
    lif lif2(
        .current(uio_in),
        .clk(clk),
        .rst_n(rst_n),
        .spike(spike2),
        .state(state2)
    );

    // Assign spikes to the highest bits of uio_out
    assign uio_out[7] = spike1;
    assign uio_out[6] = spike2;

endmodule
