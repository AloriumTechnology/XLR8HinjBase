///////////////////////////////////////////////////////////////////
//=================================================================
//  Copyright (c) Alorium Technology 2016
//  ALL RIGHTS RESERVED
//  $Id:  $
//=================================================================
//
// File name:  : openxlr8.v
// Author      : Steve Phillips
// Description : Wrapper module to hold instantiations of 
//               OpenXLR8 XB modules.
//
// This module is edited by the OpenXLR8 user to instantiate their
// XB(s) into the design. This module provides the input, output and
// control signals needed to connect the XB(s) into the logic in the
// top verilog module. Some wiring is required beyond simply
// instantiating the XB, especially in the case of multiple XBs, but
// the comments included here should explain what is needed.
//
// This file is organized in to several sections with helpful 
// comments in each. The sections are:
//
// 1.) Parameters
//     NUM_PINS should not be edited, but NUM_OXBS should be set 
//     to the number of XBs being instantiated in this file.
// 2.) Inputs and Outputs
//     No changes should be needed here. The inputs and outputs 
//     are defined.
// 3.) Regs and Wires
//     This section starts with some required wire definitions 
//     and then provides hints for addition regs and wires that 
//     may be needed, You'll going to need to add at least a 
//     few lines here.
// 4.) Instantiate XBs
//     This is where all the XBs should be specified by instantiating
//     the XB module and setting the xbs_* signals for that XB. The
//     basic template should be repeated for each XB being used. Don't
//     forget to set the NUM_OXBS value back in section 1 to match the
//     number of XBs!
// 5.) Combining logic
//     This section begins with some logic to cobine the xbs_* signals
//     into the xb_* signals needed for the outputs. Then there are
//     some hints and examples for how to write the logic to combine
//     the dbusout and out_en signals from the XBs.
// 6.) Interrupt logic 
//     This section instantiates the xlr8_pcint.v module if there are
//     interrupts needed for the OpenXLR8 implementation. The OpenXLR8
//     module has a single IRQ output that ties into the AVR interrupt
//     handler.
//
//=================================================================
///////////////////////////////////////////////////////////////////
`include "xb_adr_pack.vh"

module openxlr8
  //======================================================================
  // Normally the instantiation parameters and module I/O would be
  // listed inline here. To make the module more easily updated, that
  // code has been moved to an include file located in the XLR8Core. It
  // is inserted here at compile time.
`include "../../../XLR8Core/extras/rtl/openxlr8_module_io.vh"

  // Listed below is the instantiation parameters and module I/O of
  // the current version. It is listed only to provide an example of
  // what they should be. To see the actual code, see the file
  // included above.

  /* === Beginning of Sample Instantiation Parameters and Module I/O ===
  // ----------------------------------------------------------------------
  // 1.) Parameters

  #(
    parameter DESIGN_CONFIG = 8,
    //    {
    //     25'd0, // [31:14] - reserved
    //     8'h8,  // [13:6]  - MAX10 Size,  ex: 0x8 = M08, 0x32 = M50
    //     1'b0,  //   [5]   - ADC_SWIZZLE, 0 = XLR8,            1 = Sno
    //     1'b0,  //   [4]   - PLL Speed,   0 = 16MHz PLL,       1 = 50Mhz PLL
    //     1'b1,  //   [3]   - PMEM Size,   0 = 8K (Sim Kludge), 1 = 16K
    //     2'd0,  //  [2:1]  - Clock Speed, 0 = 16MHZ,           1 = 32MHz, 2 = 64MHz, 3=na
    //     1'b0   //   [0]   - FPGA Image,  0 = CFM Application, 1 = CFM Factory
    //     },
    
    parameter NUM_PINS = 20,// Default is Arduino Uno Digital 0-13 + Analog 0-5
    // NUM_PINS should be 20 for the XLR8 board, ?? for the Sno board
    
    parameter OX8ICR_Address = 8'h31,
    parameter OX8IFR_Address = 8'h32,
    parameter OX8MSK_Address = 8'h33
    // The OX8*_Address parameters are used to control the interrupt module
    
    )
   //----------------------------------------------------------------------
   
   //----------------------------------------------------------------------
   // 2.) Inputs and Outputs
   (
    // Clock and Reset
    // The clk input is the CPU core frequency, which could be 16, 32 or 64MHZ 
    // depending on how the image was built
    input                       clk, //       Clock
    input                       rstn, //      Reset 
    // These three clocks are always the stated frequency, regardless of the CPU 
    // core frequency
    input                       clk_64mhz, // 64MHz clock
    input                       clk_32mhz, // 32MHz clock
    input                       clk_16mhz, // 16MHz clock
    input                       clk_option2, // Default: 64MHz, 45 degrees phase
    input                       clk_option4, // Default: 32MHz, 22.5 degrees phase
    // These enables have one shot pulses at the stated intrevals 
    input                       en16mhz, //   Enable for  16MHz timer
    input                       en1mhz, //    Enable for   1MHz timer
    input                       en128khz, //  Enable for 128KHz timer
    // I/O 
    input [5:0]                 adr, //       Reg Address
    input [7:0]                 dbus_in, //   Data Bus Input
    output [7:0]                dbus_out, //  Data Bus Output
    output                      io_out_en, // IO Output Enable
    input                       iore, //      IO Reade Enable
    input                       iowe, //      IO Write Enable
    // DM
    input [7:0]                 ramadr, //    RAM Address
    input                       ramre, //     RAM Read Enable
    input                       ramwe, //     RAM Write Enable
    input                       dm_sel, //    DM Select
    input [7:0]                 dm_dout_rg,// dout held during cpuwait, for UART

    // Other
    input [255:0]               gprf, //      Direct RO access to Reg File
    input [NUM_PINS-1:0]        xb_pinx, //   pin inputs
    inout                       JT9, //       JTAG pin
    inout                       JT7, //       JTAG pin
    inout                       JT6, //       JTAG pin
    inout                       JT5, //       JTAG pin
    inout                       JT3, //       JTAG pin
    inout                       JT1, //       JTAG pin
    // For iomux
    output logic [NUM_PINS-1:0] xb_ddoe, //   override data direction
    output logic [NUM_PINS-1:0] xb_ddov, //   data direction value if 
                                         //     overridden (1=output)
    output logic [NUM_PINS-1:0] xb_pvoe, //   override output value
    output logic [NUM_PINS-1:0] xb_pvov, //    output value if overridden
    // Interrupts
    output logic                xb_irq //    To core
    );
   //----------------------------------------------------------------------
      === End of Sample Instantiation Parameters and Module I/O === */

   
   //----------------------------------------------------------------------
   // 3.) Params, Regs and Wires declarations
   //

  parameter NUM_OXBS  = 4; // !! EDIT THIS LINE !!
   // NUM_OXBS should equal the number of XBs being instantiated within
   // this module. However, in the case where no XB is being
   // instantiated, the value should be set to 1 rather than zero, so
   // that the logic compiles correctly and we can still provide the
   // correct output values. Called it NUM_OXBS for OpenXLR8 XBs, to 
   // differentiate is from the NUM_XBS parameter used in the top.
   
   
   // These are required:
   
   logic [NUM_OXBS-1:0][NUM_PINS-1:0] xbs_ddoe;
   logic [NUM_OXBS-1:0][NUM_PINS-1:0] xbs_ddov;
   logic [NUM_OXBS-1:0][NUM_PINS-1:0] xbs_pvoe;
   logic [NUM_OXBS-1:0][NUM_PINS-1:0] xbs_pvov;
   
   // Add additional wires and regs here as needed to connect your XBs
   // to the combining logic and to each other if needed. At minimum,
   // with a single XB, you'll need at least something like this:

   // SPI signals
   logic [7:0]     spi_dbusout;
   logic           spi_io_out_en;
   logic           misoo, mosio;
   logic           scko;
   logic           spe;
   logic           spimaster;
   logic           ss_b;
   logic           scki;

   // I2C signals
   logic [7:0]     i2c_dbusout;
   logic           i2c_io_out_en;
   logic           i2c_irq;
   logic           twen;
   logic           sdain, sdaout;
   logic           sclin, sclout;

   // UART Signals
   logic [7:0]     uart_dbusout;
   logic           uart_out_en;
   logic           uart_rx_en;
   logic           rxd;                
   logic           txd;
   logic           uart_tx_en;

   // PCINT Signals
   logic [7:0]     pcint_dbusout;
   logic           pcint_io_out_en;
   
   //----------------------------------------------------------------------
   
   
   //----------------------------------------------------------------------
   // 4.) Instantiate XBs

   // Hinj Pin definitions

   // Connector Logical    Physical       Pinx    Ports
   // --------- ------- -------------  ---------  -------------------
   //   B        [1:0]          [2:1]  [121:120]  PORTBT[1:0]  
   //   XBEE    [15:0]  [11:13,15:19]  [119:112]  PORTX1[7:0],
   //                      [20,9,7:2]  [111:104]  PORTX0[7:0]
   //   SW       [7:0]          [1:8]   [103:96]  PORTSW[7:0]  
   //   LED      [7:0]          [7:0]    [95:88]  PORTLD[7:0]  
   //   GPIO    [35:0]        [38:35]    [87:84]  PORTG4[35:32],
   //                         [34:27]    [83:76]  PORTG3[31:24],
   //                         [26:19]    [75:68]  PORTG2[23:16],
   //                         [18:11]    [67:60]  PORTG1[15:8],
   //                          [10:3]    [59:52]  PORTG0[7:0]
   //   PD(p8)   [3:0]         [10:7]    [51:48]  PORTPD[7:4]
   //   PD(p7)   [3:0]          [4:1]    [47:44]  PORTPD[3:0]    
   //   PC(p6)   [3:0]         [10:7]    [43:40]  PORTPC[7:4]
   //   PC(p5)   [3:0]          [4:1]    [39:36]  PORTPC[3:0]    
   //   PB(p4)   [3:0]         [10:7]    [35:32]  PORTPB[7:4]
   //   PB(p3)   [3:0]          [4:1]    [31:28]  PORTPB[3:0]    
   //   PA(p2)   [3:0]         [10:7]    [27:24]  PORTPA[7:4]
   //   PA(p1)   [3:0]          [4:1]    [23:20]  PORTPA[3:0]    
   //   PortC    [5:0]          [5:0]    [19:14]  PORTC[5:0]     
   //   PortB    [5:0]         [13:8]     [13:8]  PORTB[5:0]    
   //   PortD    [7:0]          [7:0]      [7:0]  PORTD[7:0]       
   
   //----------------------------------------------------------------------
   // SPI XB
   
   // Assign this SPI to Pmod-A, p1[4:1]
   assign scki   = xb_pinx[23]; // p1[4]
   assign misoi  = xb_pinx[22]; // p1[3]
   assign mosii  = xb_pinx[21]; // p1[2]
   assign ss_b   = xb_pinx[20]; // p1[1]
   
   avr_spi
     xlr8_pa_spi_inst
       (
        // AVR Control
        .adr        (adr),
        .dbus_in    (dbus_in),
        .dbus_out   (spi_dbusout),
        .iore       (iore),
        .iowe       (iowe),
        .out_en     (spi_io_out_en),
        // IRQ
        .spiirq      (/* removing IRQ for extra SPI */),
        .spiack      (/* removing IRQ for extra SPI */),
        // Slave Programming Mode
        .por         (1'b0),
        .spiextload  (1'b0),
        .spidwrite   (/*Not used*/),
        .spiload     (/*Not used*/),
        
        // Outputs
        .misoo       (misoo),
        .mosio       (mosio),
        .scko        (scko),
        .spe         (spe),
        .spimaster   (spimaster),
        // Inputs
        .rst_n       (rstn),             // Templated
        .clk         (clk),
        // Former parameters converted to inputs
        .param_design_config   (DESIGN_CONFIG),
        .param_spcr_address    (XB_SPI_SPCR_ADDR),
        .param_spsr_address    (XB_SPI_SPSR_ADDR),
        .param_spdr_address    (XB_SPI_SPDR_ADDR),
        .clken       (1'b1),             // Templated
        .clk_scki    (clk_scki),
        .misoi       (misoi),       // miso is assigned to D5
        .mosii       (mosii),
        .scki        (scki),
        .ss_b        (ss_b),
        .ramadr      (ramadr[7:0]),      // Templated
        .ramre       (ramre),            // Templated
        .ramwe       (ramwe),            // Templated
        .dm_sel      (dm_sel));          // Templated
   
      
   // On XLR8/UNO, bus is [19:0]={portc[5:0],portb[5:0],portd[7:0]}
   assign sck_ddoe  = spe && ~spimaster;
   assign sck_ddov  = 1'b0;
   assign sck_pvoe  = spe && spimaster;
   assign sck_pvov  = scko;
 
   assign miso_ddoe = spe;
   assign miso_ddov = ~spimaster && ~ss_b;
   assign miso_pvoe = spe && ~spimaster;
   assign miso_pvov = misoo;

   assign mosi_ddoe = spe && ~spimaster;
   assign mosi_ddov = 1'b0;
   assign mosi_pvoe = spe && spimaster;
   assign mosi_pvov = spe && mosio;

   assign ss_b_ddoe = spe && ~spimaster;
   assign ss_b_ddov = 1'b0;
   assign ss_b_pvoe = 1'b0;
   assign ss_b_pvov = 1'b0;


   // Assigning to PA (p1[4:1]) {sck,     miso,     mosi,     ss_b     }
   assign xbs_ddoe[0] = {98'h0, {sck_ddoe,miso_ddoe,mosi_ddoe,ss_b_ddoe}, 20'h0}; 
   assign xbs_ddov[0] = {98'h0, {sck_ddov,miso_ddov,mosi_ddov,ss_b_ddov}, 20'h0};
   assign xbs_pvoe[0] = {98'h0, {sck_pvoe,miso_pvoe,mosi_pvoe,ss_b_pvoe}, 20'h0};
   assign xbs_pvov[0] = {98'h0, {sck_pvov,miso_pvov,mosi_pvov,ss_b_pvov}, 20'h0};

   // End of SPI XB instantiation
   //----------------------------------------------------------------------


   //----------------------------------------------------------------------
   // I2C XB instantiation
   //
   // The I2C is on PMOD Port B 
   //   INT   = PMOD Pin 1 = xb_pinx[28]
   //   RESET = PMOD Pin 2 = xb_pinx[29]
   //   SCL   = PMOD Pin 3 = xb_pinx[30]
   //   SDA   = PMOD Pin 4 = xb_pinx[31]

   
   assign sdain   = xb_pinx[31];
   assign sclin   = xb_pinx[30];
   
   // instantiate the I2C module
   avr_i2c 
     xb_i2c_inst(
                 // AVR Control
                 .ireset       (rstn),
                 .cp2          (clk),
                 .param_twcr_addr  (XB_I2C_TWCR_ADDR), 
                 .param_twdr_addr  (XB_I2C_TWDR_ADDR), 
                 .param_twar_addr  (XB_I2C_TWAR_ADDR), 
                 .param_twsr_addr  (XB_I2C_TWSR_ADDR), 
                 .param_twbr_addr  (XB_I2C_TWBR_ADDR), 
                 .param_twamr_addr (XB_I2C_TWAMR_ADDR), 
                 .en16mhz      (en16mhz),
                 .adr          (adr),
                 .dbus_in      (dbus_in),
                 .dbus_out     (i2c_dbusout),
                 .iore         (iore),
                 .iowe         (iowe),
                 .ramadr       (ramadr[7:0]),
                 .ramre        (ramre),
                 .ramwe        (ramwe),
                 .dm_sel       (dm_sel),
                 .out_en       (i2c_io_out_en),
                 // Slave IRQ
                 .twiirq       (i2c_irq), //Interrupt
                 // Master IRQ
                 //SB: not in 328
                 .msmbirq      (),
                 // "Off state" timer IRQ
                 .offstirq     (),
                 .offstirq_ack (1'b0),
                 // TRI control and data for the slave channel
                 .twen         (twen   ),
                 .sdain        (sdain  ), // 
                 .sdaout       (  ),// 
                 .sdaen        (  ), // 
                 .sclin        (sclin  ), // 
                 .sclout       (  ),// 
                 .sclen        (  ), // 
                 // TRI control and data for the master channel
                 .msdain       (sdain ), // 
                 .msdaout      (sdaout),// 
                 .msdaen       ( ), // 
                 .msclin       (sclin ), //
                 .msclout      (sclout),//
                 .msclen       ( )  // 
                 );

   // Lets put the I2C pins PMOD PB in the [121:0] buss
   //                    [121:36]    [35:28] = PB                                 PA   UNO
   assign xbs_ddoe[1] = {86'h0,     {4'h0,twen,           twen,            2'h0}, 8'h0,20'h0}; 
   assign xbs_ddov[1] = {86'h0,     {4'h0,!sdaout,        !sclout,         2'h0}, 8'h0,20'h0};
   assign xbs_pvoe[1] = {86'h0,     {4'h0,(twen&&!sdaout),(twen&&!sclout), 2'h0}, 8'h0,20'h0};
   assign xbs_pvov[1] = {86'h0,     {4'h0,1'b0,           1'b0,            2'h0}, 8'h0,20'h0};

   
   //----------------------------------------------------------------------
   // UART XB instantiation
   // The UART is on PMOD Port C 
   //   CTS   = PMOD Pin 1 = xb_pinx[36]
   //   RTS   = PMOD Pin 2 = xb_pinx[37]
   //   RXD   = PMOD Pin 3 = xb_pinx[38]
   //   TXD   = PMOD Pin 4 = xb_pinx[39]

   localparam XB_USART_SYNC_RST         = 0;
   localparam XB_USART_RX_FIFO_DEPTH    = 2;
   localparam XB_USART_TX_FIFO_DEPTH    = 2;
   localparam XB_USART_MEGA_COMPAT_MODE = 1;
   localparam XB_USART_COMPAT_MODE      = 0;
   localparam XB_USART_IMPL_DFT         = 0;

   assign rxd = xb_pinx[38]; // Assign PMOD PC[3] to RXD

   
   avr_usart 
     #(
       .SYNC_RST         (XB_USART_SYNC_RST),
       .RX_FIFO_DEPTH    (XB_USART_RX_FIFO_DEPTH),
       .TX_FIFO_DEPTH    (XB_USART_TX_FIFO_DEPTH),
       .MEGA_COMPAT_MODE (XB_USART_MEGA_COMPAT_MODE),
       .COMPAT_MODE      (XB_USART_COMPAT_MODE),
       .IMPL_DFT         (XB_USART_IMPL_DFT)
       )
   usart_inst
     (
      // Clock and Reset
      .ireset              (rstn),
      .cp2                 (clk),
      .param_rxb_txb_adr   (XB_USART_RXB_TXB_ADR),
      .param_ctrla_adr     (XB_USART_CTRLA_ADR),
      .param_ctrlb_adr     (XB_USART_CTRLB_ADR),
      .param_ctrlc_adr     (XB_USART_CTRLC_ADR),
      .param_baudctrla_adr (XB_USART_BAUDCTRLA_ADR),
      .param_baudctrlb_adr (XB_USART_BAUDCTRLB_ADR),
      .adr                 (adr),
      .dbus_in             (dbus_in),
      .dbus_out            (uart_dbusout),
      .iore                (iore),
      .iowe                (iowe),
      .io_out_en           (uart_io_out_en),
      .ramadr              (ramadr[7:0]),
      .dm_dbus_in          (dm_dout_rg),
      .dm_dbus_out         (/* not used*/),
      .ramre               (ramre),
      .ramwe               (ramwe),
      .dm_sel              (dm_sel),
      .cpuwait             (/* not used*/),
      .dm_out_en           (/* not used*/),
      .rxd                 (rxd),
      .rx_en               (uart_rx_en),
      .txd                 (txd),
      .tx_en               (uart_tx_en),
      .txcirq              (txcirq),
      .txc_irqack          (1'b0), // txcirq will have to be cleared by software
      .udreirq             (udreirq),
      .rxcirq              (rxcirq),
      .rtsn                (/* not used*/), // Not used in AVR core
      .ctsn                (/* not used*/)  // Not used in AVR core
      );

   //                   |[121:44] | [43:36] = PMOD PC            | Pmod PB/PA| UNO
   assign xbs_ddoe[2] = {6'h0,    4'h0,uart_tx_en,uart_rx_en,2'h0, 16'h0,      20'h0}; 
   assign xbs_ddov[2] = {6'h0,    4'h0,1'b1,      1'b0,      2'h0, 16'h0,      20'h0};
   assign xbs_pvoe[2] = {6'h0,    4'h0,uart_tx_en,1'b0,      2'h0, 16'h0,      20'h0};
   assign xbs_pvov[2] = {6'h0,    4'h0,txd,       1'b0,      2'h0, 16'h0,      20'h0};
   
   //----------------------------------------------------------------------
   
   
   //----------------------------------------------------------------------
   // 5.) Combine control and busses from multiple XB instantiations
   //
   // Combine the pin control signals from each of the XB
   // instantiations by wire ORing then to form a single set of busses


   //     -- \/ -- Do not edit the below lines -- \/ --
   always_comb begin
      // Initialize to zero
      xb_ddoe = {NUM_PINS{1'b0}};
      xb_ddov = {NUM_PINS{1'b0}};
      xb_pvoe = {NUM_PINS{1'b0}};
      xb_pvov = {NUM_PINS{1'b0}};
      // Wire OR the pin control signals together
      for (int i=0;i<NUM_OXBS;i++) begin
	 xb_ddoe = xb_ddoe | xbs_ddoe[i];
	 xb_ddov = xb_ddov | (xbs_ddoe[i] & xbs_ddov[i]);
	 xb_pvoe = xb_pvoe | xbs_pvoe[i];
	 xb_pvov = xb_pvov | (xbs_pvoe[i] & xbs_pvov[i]);
      end
   end
   //     -- /\ -- Do not edit the above lines -- /\ --

   // Combine the dbusout and io_out_en signals from the instantiated
   // XBs here and then pass them up to the xlr8_top.
   //
   // Here is an example for a single XB:  
   //   assign dbus_out  = xb1_out_en ? xb1_dbusout : 8'h00;
   //   assign io_out_en = xb1_out_en;
   //      
   // Here is an example for three XBs (xb1, xb2 and xb3):
   //   assign dbus_out  = xb1_out_en ? xb1_dbusout :
   //                      xb2_out_en ? xb2_dbusout :
   //                      xb3_out_en ? xb3_dbusout :
   //                                   8'h00;
   //   assign io_out_en = xb1_out_en || 
   //                      xb2_out_en ||
   //                      xb3_out_en;
   //
   // If no XBs are being instantiated then set values to zero like 
   // this:
   assign dbus_out  = spi_io_out_en   ? spi_dbusout :
                      i2c_io_out_en   ? i2c_dbusout :
                      uart_io_out_en  ? uart_dbusout :
                      pcint_io_out_en ? pcint_dbusout :
                      8'h00;
   assign io_out_en = spi_io_out_en  || 
                      i2c_io_out_en  ||
                      uart_io_out_en ||
                      pcint_io_out_en;
   
   // End of combining logic
   //----------------------------------------------------------------------

   
   //----------------------------------------------------------------------
   // 6.) Interrupts
   //
   // If you need to have interrupts for you XBs, then delete the
   // following line that ties off the xb_irq output and instead
   // uncomment the following instantiation of the xlr8_pcint module

   //   assign xb_irq = 1'b0; // DELETE THIS LINE IF YOU UNCOMMENT THE XLR8_PCINT
   
   localparam NUM_INTS = 4; // EDIT to be equal to the number of interrupts

   xlr8_pcint
     #(
       .XICR_Address (OX8ICR_Address),
       .XIFR_Address (OX8IFR_Address),
       .XMSK_Address (OX8MSK_Address),
       .WIDTH        (NUM_INTS)
       )
   xb_pcint_inst
     (
      // Clock and Reset
      .rstn         (rstn),
      .clk          (clk),
      // I/O
      .adr          (adr),
      .dbus_in      (dbus_in),
      .dbus_out     (pcint_dbusout),
      .iore         (iore),
      .iowe         (iowe),
      .out_en       (pcint_io_out_en),
      // DM
      .ramadr       (ramadr),
      .ramre        (ramre),
      .ramwe        (ramwe),
      .dm_sel       (dm_sel),
      // 
      .x_int_in     ({i2c_irq,txcirq,udreirq,rxcirq}), // INSERT YOUR XB INTERRUPTS HERE 
      .x_irq        (xb_irq),
      .x_irq_ack    () // Don't use acks here
      );
   
   assign xbs_ddoe[3] = {122'h0}; 
   assign xbs_ddov[3] = {122'h0}; 
   assign xbs_pvoe[3] = {122'h0}; 
   assign xbs_pvov[3] = {122'h0}; 

   
endmodule // openxlr8

