`define shift_left_logical_static 3'b000

module alu_logic(reg1_data, reg2_data, immediate_data, shift_ammount, use_immediate, shift_type, result, alu_overflow);

    // [0]: 0 == logical, 1== arithmetic
    // [1]: 0 => left, 1 => right
    // [2]  0 => shamt, 1 => variable
    // if arithemetic left,  no shift 
    input [2:0] shift_type;
    input [4:0] shift_ammount;
    input [31:0] reg1_data, reg2_data, immediate_data;
    input use_immediate;

    output [31:0] result;
    output alu_overflow;

    wire no_shift;
    wire [4:0] selected_shift_ammount;
    wire [31:0] shifter_in, shifter_out, selected_data2;

    assign no_shift = shift_type[0] && !shift_type[1];

    // select between shift ammounts
    mux4x1 #(.data_width(5)) shift_ammount_select(
        .a(shamt),
        .b(reg1_data[4:0]),
        .c(5'b0),
        .d(5'b0),
        .s({no_shift, shift_type[2]}),
        .out(selected_shift_ammount)
    );

    // select between alu input 2
    mux2x1 data_2_select(
        .a(reg2_data),
        .b(immediate_data),
        .s(use_immediate),
        .out(shifter_in)
    );

    // barrel shifter logic
    barrel_shifter shifter(
        .in(shifter_in),
        .out(shifter_out),
        .shift(selected_shift_ammount),
        .left(!shift_type[1]),
        .logical(!shift_type[0])
    );

    ALU alu(
        .a(reg1_data),
        .b(shifter_out),
        .out(result),
        .overflow(alu_overflow),
    );

endmodule