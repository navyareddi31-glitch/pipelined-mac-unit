`timescale 1ns/1ps
module mac_tb;
    reg clk = 1'b0;
    always #5 clk = ~clk;

    reg rst, in_valid;
    reg [15:0] a, b, c;
    wire [31:0] y_comb, y_pipe;
    wire out_valid;

    integer errors = 0;
    integer checks = 0;
    integer i;
    reg [15:0] ra, rb, rc;
    reg [31:0] expected_pipe_stage1;
    reg valid_pipe_stage1;

    mac_comb u_comb(.a(a), .b(b), .c(c), .y(y_comb));
    mac_pipeline u_pipe(
        .clk(clk), .rst(rst), .in_valid(in_valid),
        .a(a), .b(b), .c(c), .out_valid(out_valid), .y(y_pipe)
    );

    task check_comb;
        input [15:0] ta, tb, tc;
        reg [31:0] exp;
        begin
            a = ta; b = tb; c = tc;
            #1;
            exp = (ta * tb) + tc;
            checks = checks + 1;
            if (y_comb !== exp) begin
                errors = errors + 1;
                $display("COMB FAIL: a=%0d b=%0d c=%0d expected=%0d actual=%0d", ta,tb,tc,exp,y_comb);
            end
        end
    endtask

    task send_pipe;
        input [15:0] ta, tb, tc;
        input tvalid;
        reg [31:0] current_expected;
        reg current_valid;
        begin
            @(negedge clk);
            a = ta; b = tb; c = tc; in_valid = tvalid;
            current_expected = (ta * tb) + tc;
            current_valid = tvalid;
            @(posedge clk);
            #1;
            // Output at this edge corresponds to the previous stage-1 transaction.
            checks = checks + 1;
            if (out_valid !== valid_pipe_stage1) begin
                errors = errors + 1;
                $display("PIPE VALID FAIL: expected=%b actual=%b", valid_pipe_stage1, out_valid);
            end
            if (valid_pipe_stage1 && y_pipe !== expected_pipe_stage1) begin
                errors = errors + 1;
                $display("PIPE DATA FAIL: expected=%0d actual=%0d", expected_pipe_stage1, y_pipe);
            end
            expected_pipe_stage1 = current_expected;
            valid_pipe_stage1 = current_valid;
        end
    endtask

    initial begin
        $dumpfile("mac_tb.vcd");
        $dumpvars(0, mac_tb);
        rst = 1'b1; in_valid = 1'b0; a = 0; b = 0; c = 0;
        expected_pipe_stage1 = 0; valid_pipe_stage1 = 0;
        repeat (2) @(posedge clk);
        @(negedge clk); rst = 1'b0;

        check_comb(0, 0, 0);
        check_comb(10, 5, 7);
        check_comb(65535, 65535, 65535);
        check_comb(1, 65535, 0);
        check_comb(1234, 56, 789);

        send_pipe(0, 0, 0, 1);
        send_pipe(10, 5, 7, 1);
        send_pipe(65535, 65535, 65535, 1);
        send_pipe(1, 65535, 0, 1);
        send_pipe(1234, 56, 789, 1);

        for (i = 0; i < 20; i = i + 1) begin
            ra = $random; rb = $random; rc = $random;
            check_comb(ra, rb, rc);
            send_pipe(ra, rb, rc, 1);
        end

        send_pipe(0, 0, 0, 0);
        send_pipe(0, 0, 0, 0);

        if (errors == 0)
            $display("ALL TESTS PASSED. Checks performed: %0d", checks);
        else
            $display("TESTS FAILED. Checks performed: %0d, errors: %0d", checks, errors);
        $finish;
    end
endmodule
