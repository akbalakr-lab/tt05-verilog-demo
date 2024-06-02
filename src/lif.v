/*
if rising edge of clock, then transfer input to output
value of input of the register is the next state

when clock edge rises, next_state should be passed into state

decay term = beta * present state
Input current injection: Iin 
membrane potential of the next state = beta * present state
U(t+1) = (B * present state) + Iin
theta = threshold
St: spiking term
St = {1, ut >= theta; 0, otherwise}
we use a register for this
*/

`default_nettype none

module lif (
    input wire [7:0]    current,
    input wire          clk,
    input wire          rst_n, 
    output wire         spike,
    output reg [7:0]    state
);
    reg [7:0] threshold;
    wire [7:0] next_state;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 240;
        end else begin
            state <= next_state;
        end
    end

    // next_state logic

    // right shift by 1 position: divide by 2 --> beta = 0.5. doesnt count as a computation
    // assign next_state = current + (spike ? 0 : (state >> 1)); // if spike is high, then the state is reset to 0
    // next state with 0.75 decay rate 
    assign next_state = current + (spike ? 0 : (state >> 1)) - (state >> 2);
    // spiking logic
    assign spike = (state >= threshold);
endmodule
        
        