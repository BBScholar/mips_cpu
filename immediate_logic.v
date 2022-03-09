
module immediate_logic(raw_immediate, alu_signed, load_upper, sign_extended_shifted, to_alu);

    input load_upper, alu_signed;
    input [15:0] raw_immediate;

    output [31:0] sign_extended_shifted, to_alu;

    wire [31:0] zero_extended, sign_extended, sign_select_out, load_upper_value;

    assign zero_extended = {16'b0, raw_immediate};
    assign sign_extended_shifted = sign_extended_shifted << 2;
    assign load_upper_value = {sign_select_out[15:0], 16'b0};
    
    sign_extend #(.in_width(16), .out_width(32)) extender(
        .in(raw_immediate),
        .out(sign_extended)
    );

    mux2x1 alu_sign_selector(
        .a(zero_extended),
        .b(sign_extended),
        .s(alu_signed),
        .out(sign_select_out)
    );

    mux2x1 upper_selector(
        .a(sign_select_out),
        .b(load_upper_value),
        .s(load_upper),
        .out(to_alu)
    );

endmodule