--------------------------------------------------------------------------------
-- Copyright (C) 2013-2023 Efinix Inc. All rights reserved.              
--
-- This   document  contains  proprietary information  which   is        
-- protected by  copyright. All rights  are reserved.  This notice       
-- refers to original work by Efinix, Inc. which may be derivitive       
-- of other work distributed under license of the authors.  In the       
-- case of derivative work, nothing in this notice overrides the         
-- original author's license agreement.  Where applicable, the           
-- original license agreement is included in it's original               
-- unmodified form immediately below this header.                        
--                                                                       
-- WARRANTY DISCLAIMER.                                                  
--     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND        
--     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH               
--     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES,  
--     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF          
--     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR    
--     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED       
--     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.           
--                                                                       
-- LIMITATION OF LIABILITY.                                              
--     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY       
--     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT    
--     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY   
--     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT,      
--     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY    
--     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF      
--     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR   
--     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN    
--     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER    
--     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
--     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
--     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR            
--     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT   
--     APPLY TO LICENSEE.                                                
--
--------------------------------------------------------------------------------
------------- Begin Cut here for COMPONENT Declaration ------
COMPONENT DdrCtrl is
PORT (
clk : in std_logic;
core_clk : in std_logic;
twd_clk : in std_logic;
tdqss_clk : in std_logic;
tac_clk : in std_logic;
reset_n : in std_logic;
reset : out std_logic;
cs : out std_logic;
ras : out std_logic;
cas : out std_logic;
we : out std_logic;
cke : out std_logic;
addr : out std_logic_vector(15 downto 0);
ba : out std_logic_vector(2 downto 0);
odt : out std_logic;
shift : out std_logic_vector(2 downto 0);
shift_sel : out std_logic_vector(4 downto 0);
shift_ena : out std_logic;
cal_ena : in std_logic;
cal_done : out std_logic;
cal_pass : out std_logic;
cal_fail_log : out std_logic_vector(6 downto 0);
cal_shift_val : out std_logic_vector(2 downto 0);
o_dm_hi : out std_logic_vector(1 downto 0);
o_dm_lo : out std_logic_vector(1 downto 0);
i_dqs_hi : in std_logic_vector(1 downto 0);
i_dqs_lo : in std_logic_vector(1 downto 0);
i_dqs_n_hi : in std_logic_vector(1 downto 0);
i_dqs_n_lo : in std_logic_vector(1 downto 0);
o_dqs_hi : out std_logic_vector(1 downto 0);
o_dqs_lo : out std_logic_vector(1 downto 0);
o_dqs_n_hi : out std_logic_vector(1 downto 0);
o_dqs_n_lo : out std_logic_vector(1 downto 0);
o_dqs_oe : out std_logic_vector(1 downto 0);
o_dqs_n_oe : out std_logic_vector(1 downto 0);
i_dq_hi : in std_logic_vector(15 downto 0);
i_dq_lo : in std_logic_vector(15 downto 0);
o_dq_hi : out std_logic_vector(15 downto 0);
o_dq_lo : out std_logic_vector(15 downto 0);
o_dq_oe : out std_logic_vector(15 downto 0);
axi_aid : in std_logic_vector(7 downto 0);
axi_aaddr : in std_logic_vector(31 downto 0);
axi_alen : in std_logic_vector(7 downto 0);
axi_asize : in std_logic_vector(2 downto 0);
axi_aburst : in std_logic_vector(1 downto 0);
axi_alock : in std_logic_vector(1 downto 0);
axi_avalid : in std_logic;
axi_aready : out std_logic;
axi_atype : in std_logic;
axi_wid : in std_logic_vector(7 downto 0);
axi_wdata : in std_logic_vector(127 downto 0);
axi_wstrb : in std_logic_vector(15 downto 0);
axi_wlast : in std_logic;
axi_wvalid : in std_logic;
axi_wready : out std_logic;
axi_rid : out std_logic_vector(7 downto 0);
axi_rdata : out std_logic_vector(127 downto 0);
axi_rlast : out std_logic;
axi_rvalid : out std_logic;
axi_rready : in std_logic;
axi_rresp : out std_logic_vector(1 downto 0);
axi_bid : out std_logic_vector(7 downto 0);
axi_bresp : out std_logic_vector(1 downto 0);
axi_bvalid : out std_logic;
axi_bready : in std_logic);
END COMPONENT;
---------------------- End COMPONENT Declaration ------------

------------- Begin Cut here for INSTANTIATION Template -----
u_DdrCtrl : DdrCtrl
PORT MAP (
clk => clk,
core_clk => core_clk,
twd_clk => twd_clk,
tdqss_clk => tdqss_clk,
tac_clk => tac_clk,
reset_n => reset_n,
reset => reset,
cs => cs,
ras => ras,
cas => cas,
we => we,
cke => cke,
addr => addr,
ba => ba,
odt => odt,
shift => shift,
shift_sel => shift_sel,
shift_ena => shift_ena,
cal_ena => cal_ena,
cal_done => cal_done,
cal_pass => cal_pass,
cal_fail_log => cal_fail_log,
cal_shift_val => cal_shift_val,
o_dm_hi => o_dm_hi,
o_dm_lo => o_dm_lo,
i_dqs_hi => i_dqs_hi,
i_dqs_lo => i_dqs_lo,
i_dqs_n_hi => i_dqs_n_hi,
i_dqs_n_lo => i_dqs_n_lo,
o_dqs_hi => o_dqs_hi,
o_dqs_lo => o_dqs_lo,
o_dqs_n_hi => o_dqs_n_hi,
o_dqs_n_lo => o_dqs_n_lo,
o_dqs_oe => o_dqs_oe,
o_dqs_n_oe => o_dqs_n_oe,
i_dq_hi => i_dq_hi,
i_dq_lo => i_dq_lo,
o_dq_hi => o_dq_hi,
o_dq_lo => o_dq_lo,
o_dq_oe => o_dq_oe,
axi_aid => axi_aid,
axi_aaddr => axi_aaddr,
axi_alen => axi_alen,
axi_asize => axi_asize,
axi_aburst => axi_aburst,
axi_alock => axi_alock,
axi_avalid => axi_avalid,
axi_aready => axi_aready,
axi_atype => axi_atype,
axi_wid => axi_wid,
axi_wdata => axi_wdata,
axi_wstrb => axi_wstrb,
axi_wlast => axi_wlast,
axi_wvalid => axi_wvalid,
axi_wready => axi_wready,
axi_rid => axi_rid,
axi_rdata => axi_rdata,
axi_rlast => axi_rlast,
axi_rvalid => axi_rvalid,
axi_rready => axi_rready,
axi_rresp => axi_rresp,
axi_bid => axi_bid,
axi_bresp => axi_bresp,
axi_bvalid => axi_bvalid,
axi_bready => axi_bready);
------------------------ End INSTANTIATION Template ---------
