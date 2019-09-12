//======================================================================
// Filename    : xb_adr_pack.vh
// Author      : Steve Phillips
// Description : AVR address constants (localparams) for registers 
//               used by Xcelerator Blocks (XBs) 
//
// When allocating register addresses for your XBs, you need to know
// what addresses are available for use by XBs. The reg addresses used
// by XBs should be unused by other functions. The register address
// range is 0x00 thru 0xFF. There are no available addresses in the
// lower half of the range (0x00 - 0x7F), but there are many scattered
// thru the upper half of the address range.
//
// The list below details the allocation of addresses in the upper
// half of the reg address range (0x80 - 0xFF). The addresses listed
// as --UNUSED-- are safe to use for your OpenXLR8 modules. It is
// recommended to use addresses in the big block of --UNUSED-- reg
// address at 0xDE - 0xF3. If that is not enough then other --UNUSED--
// addresses could be used.
//
// Addresses marked as ALLOCATED are actively used by the base AVR
// design. DO NOT USE ALLOCATED Addresses. Use of ALLOCATED addresses
// will cause XLR8 errors.
//
// Addresses marked as --RESERVED (328PB)-- are used in the 328PB
// variant of the AVR architecture. Using these addresses should not
// cause XLR8 errors but should be avoided if possible.
//
// Some addresses that are unused by the XLR8 or the Sno boards are
// used on the Hinj board, which uses many more addresses than the
// first two boards. Those that are used by the Hinj bord are marked
// as such and should not be used if you are targeting the hinj board.
//
// Copyright 2017, Superion Technology Group. All Rights Reserved
//----------------------------------------------------------------------

//======================================================================
//
// Here is the list of addresses used by the OpenXLR8 XBs in 
// XLR8HinjBase on the PMOD connectors.
//
//     XB_SPI_SPCR_ADDR       = 8'hCC;
//     XB_SPI_SPSR_ADDR       = 8'hCD;
//     XB_SPI_SPDR_ADDR       = 8'hCE;
//
//     XB_I2C_TWCR_ADDR       = 8'hD7;
//     XB_I2C_TWDR_ADDR       = 8'hD8;
//     XB_I2C_TWAR_ADDR       = 8'hD9;
//     XB_I2C_TWSR_ADDR       = 8'hDA;
//     XB_I2C_TWBR_ADDR       = 8'hDB;
//     XB_I2C_TWAMR_ADDR      = 8'hDC;
//
//     XB_USART_RXB_TXB_ADR   = 8'hDD;
//     XB_USART_CTRLA_ADR     = 8'hDE;
//     XB_USART_CTRLB_ADR     = 8'hDF;
//     XB_USART_CTRLC_ADR     = 8'hE1;
//     XB_USART_BAUDCTRLA_ADR = 8'hFE;
//     XB_USART_BAUDCTRLB_ADR = 8'hFF;
//
// The actual localparam statements for the above addresses are 
// inline below
//
//----------------------------------------------------------------------

//======================================================================
// Reference list for upper half of register address range
//
// Select --UNUSED-- addresses from below to use in your allocations 
// above
//----------------------------------------------------------------------
// localparam TCCR1A_Address     = 8'h80; // Timer/Counter 1 Control Register A
// localparam TCCR1B_Address     = 8'h81; // Timer/Counter 1 Control Register B
// localparam TCCR1C_Address     = 8'h82; // Timer/Counter 1 Control Register C
// localparam DDRG2_Address         = 8'h83; // HINJ: Port G2 GPIO DDR Address----------------------------HINJ
// localparam TCNT1L_Address     = 8'h84; // Timer/Counter 1 Register(Low)
// localparam TCNT1H_Address     = 8'h85; // Timer/Counter 1 Register(High)
// localparam ICR1L_Address      = 8'h86; // Timer/Counter 1 Input Capture Register(Low)
// localparam ICR1H_Address      = 8'h87; // Timer/Counter 1 Input Capture Register(High)
// localparam OCR1AL_Address     = 8'h88; // Timer/Counter 1 Output Compare Register A(Low)
// localparam OCR1AH_Address     = 8'h89; // Timer/Counter 1 Output Compare Register A(High)
// localparam OCR1BL_Address     = 8'h8A; // Timer/Counter 1 Output Compare Register B(Low)
// localparam OCR1BH_Address     = 8'h8B; // Timer/Counter 1 Output Compare Register B(High)
// localparam PING2_Address         = 8'h8C; // HINJ: Port G2 GPIO Pin Address----------------------------HINJ
// localparam PORTG1_Address        = 8'h8D; // HINJ: Port G1 GPIO Port Address---------------------------HINJ
// localparam DDRG1_Address         = 8'h8E; // HINJ: Port G1 GPIO DDR Address----------------------------HINJ
// localparam PING1_Address         = 8'h8F; // HINJ: Port G1 GPIO Pin Address----------------------------HINJ
// localparam PORTG0_Address        = 8'h90; // HINJ: Port G0 GPIO Port Address---------------------------HINJ
// localparam DDRG0_Address         = 8'h91; // HINJ: Port G0 GPIO DDR Address----------------------------HINJ
// localparam PING0_Address         = 8'h92; // HINJ: Port G0 GPIO Pin Address----------------------------HINJ
// localparam PORTPD_Address        = 8'h93; // HINJ: Port PD GPIO Port Address---------------------------HINJ
// localparam DDRPD_Address         = 8'h94; // HINJ: Port PD GPIO DDR Address----------------------------HINJ
// localparam PINPD_Address         = 8'h95; // HINJ: Port PD GPIO Pin Address----------------------------HINJ
// localparam PORTPC_Address        = 8'h96; // HINJ: Port PC GPIO Port Address---------------------------HINJ
// localparam DDRPC_Address         = 8'h97; // HINJ: Port PC GPIO DDR Address----------------------------HINJ
// localparam PINPC_Address         = 8'h98; // HINJ: Port PC GPIO Pin Address----------------------------HINJ
// localparam PORTPB_Address        = 8'h99; // HINJ: Port PB GPIO Port Address---------------------------HINJ
// localparam DDRPB_Address         = 8'h9A; // HINJ: Port PB GPIO DDR Address----------------------------HINJ
// localparam PINPB_Address         = 8'h9B; // HINJ: Port PB GPIO Pin Address----------------------------HINJ
// localparam PORTPA_Address        = 8'h9C; // HINJ: Port PA GPIO Port Address---------------------------HINJ
// localparam DDRPA_Address         = 8'h9D; // HINJ: Port PA GPIO DDR Address----------------------------HINJ
// localparam PINPA_Address         = 8'h9E; // HINJ: Port PA GPIO Pin Address----------------------------HINJ
// localparam PORTBI_Address        = 8'h9F; // HINJ: Port BI GPIO Port Address --------------------------HINJ 
// localparam DDRBI_Address         = 8'hA0; // HINJ: Port BI GPIO DDR Address ---------------------------HINJ 
// localparam PINBI_Address         = 8'hA1; // HINJ: Port BI GPIO Pin Address ---------------------------HINJ 
// localparam WIFI_SPCR_ADDR        = 8'hA2; // HINJ: WIFI SPI Control REG -------------------------------HINJ 
// localparam WIFI_SPSR_ADDR        = 8'hA3; // HINJ: WIFI SPI Source REG -==-----------------------------HINJ 
// localparam WIFI_SPDR_ADDR        = 8'hA4; // HINJ: WIFI SPI DATA REG ----------------------------------HINJ 
// localparam ETH_SPCR_ADDR         = 8'hA5; // HINJ: Ethernet SPI Control REG ---------------------------HINJ 
// localparam ETH_SPSR_ADDR         = 8'hA6; // HINJ: Ethernet SPI Status REG ----------------------------HINJ 
// localparam ETH_SPDR_ADDR         = 8'hA7; // HINJ: Ethernet SPI Data REG ------------------------------HINJ 
// localparam SD_SPCR_ADDR          = 8'hA8; // HINJ: SD Card SPI Control REG ----------------------------HINJ 
// localparam SD_SPSR_ADDR          = 8'hA9; // HINJ: SD Card SPI Status REG -----------------------------HINJ 
// localparam SD_SPDR_ADDR          = 8'hAA; // HINJ: SD Card SPI Data REG -------------------------------HINJ 
// localparam HPCICR_Address        = 8'hAB; // Hinj Pin Change Interrupt Control reg --------------------HINJ
// localparam HPCIFR_Address        = 8'hAC; // Hinj Pin Change Interrupt Flag reg -----------------------HINJ
// localparam HPCIMSK_Address       = 8'hAD; // Hinj Pin Change Interrupt Mask reg -----------------------HINJ
// localparam MSKX1_Address         = 8'hAE; // HINJ: Port X1 Interrupt Mask------------------------------HINJ
// localparam MSKX0_Address         = 8'hAF; // HINJ: Port X0 Interrupt Mask------------------------------HINJ
// localparam TCCR2A_Address     = 8'hB0; // Timer/Counter 2 Control Register
// localparam TCCR2B_Address     = 8'hB1; // Timer/Counter 2 Control Register
// localparam TCNT2_Address      = 8'hB2; // Timer/Counter 2
// localparam OCR2A_Address      = 8'hB3; // Timer/Counter 2 Output Compare Register
// localparam OCR2B_Address      = 8'hB4; // Timer/Counter 2 Output Compare Register
// localparam MSKG4_Address         = 8'hB5; // HINJ: Port G4 Interrupt Mask------------------------------HINJ
// localparam ASSR_Address       = 8'hB6; // Asynchronous mode Status Register
// localparam MSKG3_Address         = 8'hB7; // HINJ: Port G3 Interrupt Mask------------------------------HINJ
// localparam TWBR_ADDR          = 8'hB8; // TWI Bit Rate Register
// localparam TWSR_ADDR          = 8'hB9; // TWI Status Register  
// localparam TWAR_ADDR          = 8'hBA; // TWI Address Register 
// localparam TWDR_ADDR          = 8'hBB; // TWI Data Register    
// localparam TWCR_ADDR          = 8'hBC; // TWI Control Register 
// localparam TWAMR_ADDR         = 8'hBD;
// localparam MSKG2_Address         = 8'hBE; // HINJ: Port G2 Interrupt Mask------------------------------HINJ
// localparam MSKG1_Address         = 8'hBF; // HINJ: Port G1 Interrupt Mask------------------------------HINJ
// localparam UCSR0A_Address     = 8'hC0; // USART0 Control and Status Register A
// localparam UCSR0B_Address     = 8'hC1; // USART0 Control and Status Register B
// localparam UCSR0C_Address     = 8'hC2; // USART0 Control and Status Register C
// localparam MSKG0_Address         = 8'hC3; // HINJ: Port G0 Interrupt Mask------------------------------HINJ
// localparam UBRR0L_Address     = 8'hC4; // USART0 Baud Rate Register Low
// localparam UBRR0H_Address     = 8'hC5; // USART0 Baud Rate Register HIGH
// localparam UDR0_Address       = 8'hC6; // USART0 I/O Data Register
// localparam MSKPD_Address         = 8'hC7; // HINJ: Port PD Interrupt Mask------------------------------HINJ
// localparam MSKPC_Address         = 8'hC8; // HINJ: Port PC Interrupt Mask------------------------------HINJ
// localparam MSKPB_Address         = 8'hC9; // HINJ: Port PB Interrupt Mask------------------------------HINJ
// localparam MSKPA_Address         = 8'hCA; // HINJ: Port PA Interrupt Mask------------------------------HINJ
// localparam MSKBI_Address         = 8'hCB; // HINJ: Port BI Interrupt Mask------------------------------HINJ
localparam XB_SPI_SPCR_ADDR       = 8'hCC;
localparam XB_SPI_SPSR_ADDR       = 8'hCD;
localparam XB_SPI_SPDR_ADDR       = 8'hCE;
// localparam FCFG_CID_ADDR      = 8'hCF; // XLR8 flash config: chip id (64b FIFO) --------------------XLR8
// localparam FCFG_CTL_ADDR      = 8'hD0; // XLR8 flash config: flash programming ---------------------XLR8
// localparam FCFG_STS_ADDR      = 8'hD1; // XLR8 flash config: status --------------------------------XLR8
// localparam FCFG_DAT_ADDR      = 8'hD2; // XLR8 flash config: flash programming  data.  Write only --XLR8
// localparam UNUSED             = 8'hD3; // --UNUSED--
// localparam XLR8VERL_ADDR      = 8'hD4; // XLR8 hardware version (Low) ------------------------------XLR8
// localparam XLR8VERH_ADDR      = 8'hD5; // XLR8 hardware version (High) -----------------------------XLR8
// localparam XLR8VERT_ADDR      = 8'hD6; // XLR8 hardware version (Type) -----------------------------XLR8
localparam XB_I2C_TWCR_ADDR       = 8'hD7;
localparam XB_I2C_TWDR_ADDR       = 8'hD8;
localparam XB_I2C_TWAR_ADDR       = 8'hD9;
localparam XB_I2C_TWSR_ADDR       = 8'hDA;
localparam XB_I2C_TWBR_ADDR       = 8'hDB;
localparam XB_I2C_TWAMR_ADDR      = 8'hDC;
localparam XB_USART_RXB_TXB_ADR   = 8'hDD;
localparam XB_USART_CTRLA_ADR     = 8'hDE;
localparam XB_USART_CTRLB_ADR     = 8'hDF;
// localparam QECR_ADDR          = 8'hE0; // XLR8 Quadrature XB Control Reg ---------------------------XLR8  
localparam XB_USART_CTRLC_ADR     = 8'hE1;
// localparam QECNT0_ADDR        = 8'hE2; // XLR8 Quadrature XB Count 0 Reg ---------------------------XLR8
// localparam QECNT1_ADDR        = 8'hE3; // XLR8 Quadrature XB Count 1 Reg ---------------------------XLR8
// localparam QECNT2_ADDR        = 8'hE4; // XLR8 Quadrature XB Count 2 Reg ---------------------------XLR8
// localparam QECNT3_ADDR        = 8'hE5; // XLR8 Quadrature XB Count 3 Reg ---------------------------XLR8
// localparam QERAT0_ADDR        = 8'hE6; // XLR8 Quadrature XB Rate 0 Reg ----------------------------XLR8
// localparam QERAT1_ADDR        = 8'hE7; // XLR8 Quadrature XB Rate 1 Reg ----------------------------XLR8
// localparam QERAT2_ADDR        = 8'hE8; // XLR8 Quadrature XB Rate 2 Reg ----------------------------XLR8
// localparam QERAT3_ADDR        = 8'hE9; // XLR8 Quadrature XB Rate 3 Reg ----------------------------XLR8
// localparam PIDCR_ADDR         = 8'hEA; // XLR8 PID XB Control Reg ----------------------------------XLR8
// localparam PID_KD_H_ADDR      = 8'hEB; // XLR8 PID XB KD H Reg -------------------------------------XLR8
// localparam PID_KD_L_ADDR      = 8'hEC; // XLR8 PID XB KD L Reg  ------------------------------------XLR8
// localparam PID_KI_H_ADDR      = 8'hED; // XLR8 PID XB KI H Reg -------------------------------------XLR8
// localparam PID_KI_L_ADDR      = 8'hEE; // XLR8 PID XB KI L Reg -------------------------------------XLR8
// localparam PID_KP_H_ADDR      = 8'hEF; // XLR8 PID XB KP H Reg -------------------------------------XLR8
// localparam PID_KP_L_ADDR      = 8'hF0; // XLR8 PID XB KP L Reg -------------------------------------XLR8
// localparam PID_SP_H_ADDR      = 8'hF1; // XLR8 PID XB SP H Reg -------------------------------------XLR8
// localparam PID_SP_L_ADDR      = 8'hF2; // XLR8 PID XB SP L Reg -------------------------------------XLR8
// localparam PID_PV_H_ADDR      = 8'hF3; // XLR8 PID XB PV H Reg -------------------------------------XLR8
// localparam PID_PV_L_ADDR      = 8'hF4; // XLR8 PID XB PV L Reg -------------------------------------XLR8
// localparam PID_OP_H_ADDR      = 8'hF5; // XLR8 PID XB OP H Reg -------------------------------------XLR8
// localparam PID_OP_L_ADDR      = 8'hF6; // XLR8 PID XB OP L Reg -------------------------------------XLR8
// localparam NEOCR_ADDR         = 8'hF7; // XLR8 NeoPixel XB Control Reg -----------------------------XLR8
// localparam NEOD0_ADDR         = 8'hF8; // XLR8 NeoPixel XB Data 0 Reg ------------------------------XLR8
// localparam NEOD1_ADDR         = 8'hF9; // XLR8 NeoPixel XB Data 1 Reg ------------------------------XLR8
// localparam NEOD2_ADDR         = 8'hFA; // XLR8 NeoPixel XB Data 2 Reg ------------------------------XLR8
// localparam SVCR_ADDR          = 8'hFB; // XLR8 Servo XB Control Reg --------------------------------XLR8
// localparam SVPWL_ADDR         = 8'hFC; // XLR8 Servo XB Pulse Width Low  Reg - ---------------------XLR8
// localparam SVPWH_ADDR         = 8'hFD; // XLR8 Servo XB Pulse Width High Reg -----------------------XLR8
localparam XB_USART_BAUDCTRLA_ADR = 8'hFE;
localparam XB_USART_BAUDCTRLB_ADR = 8'hFF;




