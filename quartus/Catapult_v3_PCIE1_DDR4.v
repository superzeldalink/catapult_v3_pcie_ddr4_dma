
module Catapult_v3_PCIE1_DDR4 ( 

		// ----------- CLOCKS --------------
		input         clk_u59,
		input 	     clk_y3,
		input 	     clk_y4,
		input 	     clk_y5,
		input 	     clk_y6,
		input			  clk_pcie1,
		input			  clk_pcie2,	
		 
		// PCIe Interface#1
		input           pcie1_perstn,
		input  [ 7:0]   pcie1_rx,
		output [ 7:0]   pcie1_tx,

		// ------------ LEDS ---------------
		output [8:0]	leds,		 

		// ---------- DDR4 Top Interface -----------
		input         emif_top_oct_oct_rzqin,   
		output [0:0]  emif_top_mem_mem_ck,      
		output [0:0]  emif_top_mem_mem_ck_n,    
		output [16:0] emif_top_mem_mem_a,       
		output [0:0]  emif_top_mem_mem_act_n,   
		output [1:0]  emif_top_mem_mem_ba,      
		output [0:0]  emif_top_mem_mem_bg,      
		output [0:0]  emif_top_mem_mem_cke,     
		output [0:0]  emif_top_mem_mem_cs_n,    
		output [0:0]  emif_top_mem_mem_odt,     
		output [0:0]  emif_top_mem_mem_reset_n, 
		output [0:0]  emif_top_mem_mem_par,     
		input  [0:0]  emif_top_mem_mem_alert_n, 
		//inout  [8:0]  emif_top_mem_mem_dqs,     
		//inout  [8:0]  emif_top_mem_mem_dqs_n,   
		//inout  [71:0] emif_top_mem_mem_dq,      
		//inout  [8:0]  emif_top_mem_mem_dbi_n,   
		inout  [7:0]  emif_top_mem_mem_dqs,     
		inout  [7:0]  emif_top_mem_mem_dqs_n,   
		inout  [63:0] emif_top_mem_mem_dq,      
		inout  [7:0]  emif_top_mem_mem_dbi_n,   
		
		// ---------- DDR4 Bottom Interface -----------
		input         emif_bot_oct_oct_rzqin,   
		output [0:0]  emif_bot_mem_mem_ck,      
		output [0:0]  emif_bot_mem_mem_ck_n,    
		output [16:0] emif_bot_mem_mem_a,       
		output [0:0]  emif_bot_mem_mem_act_n,   
		output [1:0]  emif_bot_mem_mem_ba,      
		output [0:0]  emif_bot_mem_mem_bg,      
		output [0:0]  emif_bot_mem_mem_cke,     
		output [0:0]  emif_bot_mem_mem_cs_n,    
		output [0:0]  emif_bot_mem_mem_odt,     
		output [0:0]  emif_bot_mem_mem_reset_n, 
		output [0:0]  emif_bot_mem_mem_par,     
		input  [0:0]  emif_bot_mem_mem_alert_n, 
		//inout  [8:0]  emif_bot_mem_mem_dqs,     
		//inout  [8:0]  emif_bot_mem_mem_dqs_n,   
		//inout  [71:0] emif_bot_mem_mem_dq,      
		//inout  [8:0]  emif_bot_mem_mem_dbi_n    
		inout  [7:0]  emif_bot_mem_mem_dqs,     
		inout  [7:0]  emif_bot_mem_mem_dqs_n,   
		inout  [63:0] emif_bot_mem_mem_dq,      
		inout  [7:0]  emif_bot_mem_mem_dbi_n   
		
); 


reg [31:0] alive_count; 

wire ddr4_a_status_local_cal_success;
wire ddr4_a_status_local_cal_fail;

wire ddr4_b_status_local_cal_success;
wire ddr4_b_status_local_cal_fail;

assign leds[8] = ddr4_a_status_local_cal_success;
assign leds[7] = ddr4_b_status_local_cal_success;

// What assignments do I need for a PCIe Gen3 design that targets an Arria 10 ES2 or Production devices?
// https://www.altera.com/support/support-resources/knowledge-base/solutions/rd04242015_385.html

wire [31:0] pcie_a10_hip_0_hip_ctrl_test_in;

assign pcie_a10_hip_0_hip_ctrl_test_in = 32'h188;;
//assign PCIE_WAKE_n = 1'b1;


assign leds[6] = alive_count[25];

always @ (posedge clk_u59)
begin
alive_count <= alive_count + 1'b1;
end


	//////////////////////
// PCIE RESET
wire             any_rstn;
reg              any_rstn_r /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R102"  */;
reg              any_rstn_rr /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R102"  */;

assign any_rstn = pcie1_perstn;


//reset Synchronizer
always @(posedge clk_u59 or negedge any_rstn)
begin
    if (any_rstn == 0)
    begin
        any_rstn_r <= 0;
        any_rstn_rr <= 0;
    end
    else
    begin
        any_rstn_r <= 1;
        any_rstn_rr <= any_rstn_r;
    end
end


	ep_g3x8_avmm256_integrated u0 (
    .pcie_a10_hip_0_hip_ctrl_test_in          (pcie_a10_hip_0_hip_ctrl_test_in),    //        pcie_a10_hip_0_hip_ctrl.test_in
 //   .pcie_a10_hip_0_hip_ctrl_simu_mode_pipe   (1'b0),                               //                               .simu_mode_pipe
 //   .pcie_a10_hip_0_hip_pipe_sim_pipe_pclk_in (1'b0),                               //        pcie_a10_hip_0_hip_pipe.sim_pipe_pclk_in
    .pcie_a10_hip_0_hip_serial_rx_in0         (pcie1_rx[0]),                       //      pcie_a10_hip_0_hip_serial.rx_in0
    .pcie_a10_hip_0_hip_serial_rx_in1         (pcie1_rx[1]),                       //                               .rx_in1
    .pcie_a10_hip_0_hip_serial_rx_in2         (pcie1_rx[2]),                       //                               .rx_in2
    .pcie_a10_hip_0_hip_serial_rx_in3         (pcie1_rx[3]),                       //                               .rx_in3
	 .pcie_a10_hip_0_hip_serial_rx_in4         (pcie1_rx[4]),                       //      pcie_a10_hip_0_hip_serial.rx_in4
    .pcie_a10_hip_0_hip_serial_rx_in5         (pcie1_rx[5]),                       //                               .rx_in5
    .pcie_a10_hip_0_hip_serial_rx_in6         (pcie1_rx[6]),                       //                               .rx_in6
    .pcie_a10_hip_0_hip_serial_rx_in7         (pcie1_rx[7]),                       //                               .rx_in7
    .pcie_a10_hip_0_hip_serial_tx_out0        (pcie1_tx[0]),                       //                               .tx_out0
    .pcie_a10_hip_0_hip_serial_tx_out1        (pcie1_tx[1]),                       //                               .tx_out1
    .pcie_a10_hip_0_hip_serial_tx_out2        (pcie1_tx[2]),                       //                               .tx_out2
    .pcie_a10_hip_0_hip_serial_tx_out3        (pcie1_tx[3]),                       //                               .tx_out3
    .pcie_a10_hip_0_hip_serial_tx_out4        (pcie1_tx[4]),                       //                               .tx_out4
    .pcie_a10_hip_0_hip_serial_tx_out5        (pcie1_tx[5]),                       //                               .tx_out5
    .pcie_a10_hip_0_hip_serial_tx_out6        (pcie1_tx[6]),                       //                               .tx_out6
    .pcie_a10_hip_0_hip_serial_tx_out7        (pcie1_tx[7]),                       //                               .tx_out7
	 
    .pcie_a10_hip_0_npor_npor                 (pcie1_perstn),                        //            pcie_a10_hip_0_npor.npor
    .pcie_a10_hip_0_npor_pin_perst            (pcie1_perstn),                       //                               .pin_perst
    .refclk_clk                               (clk_pcie1),                      //                         refclk.clk
	
	
	 .reconfig_xcvr_clk_clk                    (clk_u59),                      //              reconfig_xcvr_clk.clk
    .reconfig_xcvr_reset_reset_n              (any_rstn_r),
                                                                                    //            reconfig_xcvr_reset.reset_n
    .pio_led_external_connection_export       (pio_led),                            //    pio_led_external_connection.export

    .emif_ddr4_a_pll_ref_clk_clk              (clk_y4),                     //           emif_ddr4_a_pll_ref_clk.clk
    .emif_ddr4_a_oct_oct_rzqin                (emif_top_oct_oct_rzqin),                          //                   emif_ddr4_a_oct.oct_rzqin
    .emif_ddr4_a_mem_mem_ck                   (emif_top_mem_mem_ck),                           //                   emif_ddr4_a_mem.mem_ck
    .emif_ddr4_a_mem_mem_ck_n                 (emif_top_mem_mem_ck_n),                         //                                  .mem_ck_n
    .emif_ddr4_a_mem_mem_a                    (emif_top_mem_mem_a),                            //                                  .mem_a
    .emif_ddr4_a_mem_mem_act_n                (emif_top_mem_mem_act_n),                        //                                  .mem_act_n
    .emif_ddr4_a_mem_mem_ba                   (emif_top_mem_mem_ba),                           //                                  .mem_ba
    .emif_ddr4_a_mem_mem_bg                   (emif_top_mem_mem_bg),                           //                                  .mem_bg
    .emif_ddr4_a_mem_mem_cke                  (emif_top_mem_mem_cke),                          //                                  .mem_cke
    .emif_ddr4_a_mem_mem_cs_n                 (emif_top_mem_mem_cs_n),                         //                                  .mem_cs_n
    .emif_ddr4_a_mem_mem_odt                  (emif_top_mem_mem_odt),                          //                                  .mem_odt
    .emif_ddr4_a_mem_mem_reset_n              (emif_top_mem_mem_reset_n),                      //                                  .mem_reset_n
    .emif_ddr4_a_mem_mem_par                  (emif_top_mem_mem_par),                          //                                  .mem_par
    .emif_ddr4_a_mem_mem_alert_n              (emif_top_mem_mem_alert_n),                      //                                  .mem_alert_n
    .emif_ddr4_a_mem_mem_dqs                  (emif_top_mem_mem_dqs),                          //                                  .mem_dqs
    .emif_ddr4_a_mem_mem_dqs_n                (emif_top_mem_mem_dqs_n),                        //                                  .mem_dqs_n
    .emif_ddr4_a_mem_mem_dq                   (emif_top_mem_mem_dq),                           //                                  .mem_dq
    .emif_ddr4_a_mem_mem_dbi_n                (emif_top_mem_mem_dbi_n),                        //                                  .mem_dbi_n
    .emif_ddr4_a_status_local_cal_success     (ddr4_a_status_local_cal_success),    //                emif_ddr4_a_status.local_cal_success
    .emif_ddr4_a_status_local_cal_fail        (ddr4_a_status_local_cal_fail),       //                                  .local_cal_fail
    .ddr4_a_status_external_connection_export ({ddr4_a_status_local_cal_fail,ddr4_a_status_local_cal_success}),
                                                                                    // ddr4_a_status_external_connection.export
    .emif_ddr4_b_pll_ref_clk_clk              (clk_y3),                     //           emif_ddr4_b_pll_ref_clk.clk
    .emif_ddr4_b_oct_oct_rzqin                (emif_bot_oct_oct_rzqin),                         //                   emif_ddr4_b_oct.oct_rzqin
    .emif_ddr4_b_mem_mem_ck                   (emif_bot_mem_mem_ck),                           //                   emif_ddr4_b_mem.mem_ck
    .emif_ddr4_b_mem_mem_ck_n                 (emif_bot_mem_mem_ck_n),                         //                                  .mem_ck_n
    .emif_ddr4_b_mem_mem_a                    (emif_bot_mem_mem_a),                            //                                  .mem_a
    .emif_ddr4_b_mem_mem_act_n                (emif_bot_mem_mem_act_n),                        //                                  .mem_act_n
    .emif_ddr4_b_mem_mem_ba                   (emif_bot_mem_mem_ba),                           //                                  .mem_ba
    .emif_ddr4_b_mem_mem_bg                   (emif_bot_mem_mem_bg),                           //                                  .mem_bg
    .emif_ddr4_b_mem_mem_cke                  (emif_bot_mem_mem_cke),                          //                                  .mem_cke
    .emif_ddr4_b_mem_mem_cs_n                 (emif_bot_mem_mem_cs_n),                         //                                  .mem_cs_n
    .emif_ddr4_b_mem_mem_odt                  (emif_bot_mem_mem_odt),                          //                                  .mem_odt
    .emif_ddr4_b_mem_mem_reset_n              (emif_bot_mem_mem_reset_n),                      //                                  .mem_reset_n
    .emif_ddr4_b_mem_mem_par                  (emif_bot_mem_mem_par),                          //                                  .mem_par
    .emif_ddr4_b_mem_mem_alert_n              (emif_bot_mem_mem_alert_n),                      //                                  .mem_alert_n
    .emif_ddr4_b_mem_mem_dqs                  (emif_bot_mem_mem_dqs),                          //                                  .mem_dqs
    .emif_ddr4_b_mem_mem_dqs_n                (emif_bot_mem_mem_dqs_n),                        //                                  .mem_dqs_n
    .emif_ddr4_b_mem_mem_dq                   (emif_bot_mem_mem_dq),                           //                                  .mem_dq
    .emif_ddr4_b_mem_mem_dbi_n                (emif_bot_mem_mem_dbi_n),                        //                                  .mem_dbi_n
    .emif_ddr4_b_status_local_cal_success     (ddr4_b_status_local_cal_success),    //                emif_ddr4_b_status.local_cal_success
    .emif_ddr4_b_status_local_cal_fail        (ddr4_b_status_local_cal_fail),       //                                  .local_cal_fail
    .ddr4_b_status_external_connection_export ({ddr4_b_status_local_cal_fail,ddr4_b_status_local_cal_success})
                                                                                    // ddr4_b_status_external_connection.export

);

wire [3: 0] pio_led;

reg [31: 0] por_count = 32'b0;
reg [31: 0] cpu_reset_count = 32'b0;
reg [31: 0] pcie_perst_count = 32'b0;

always @(posedge clk_u59) begin
    if (por_count[25] == 1'b0) begin
        por_count = por_count + 32'b1;
    end
end


always @(posedge clk_u59) begin
    if (pcie1_perstn == 1'b0) begin
        pcie_perst_count = 32'b0;
    end
    if (pcie_perst_count[25] == 1'b0) begin
        pcie_perst_count = pcie_perst_count + 32'b1;
    end
end

wire [3: 0] led_o;
assign led_o[0] = (~por_count[25]) ? 1'b1 : pio_led[0];
assign led_o[1] = (~cpu_reset_count[25]) ? 1'b1 : pio_led[1];
assign led_o[2] = (~pcie_perst_count[25]) ? 1'b1 : pio_led[2];
assign led_o[3] = (~por_count[25]) ? 1'b1 : pio_led[3];

assign leds[3:0] = led_o;

endmodule 