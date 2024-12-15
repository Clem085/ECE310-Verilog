# File saved with Nlview 7.7.1 2023-07-26 3bc4126617 VDI=43 GEI=38 GUI=JA:21.0 TLS
# 
# non-default properties - (restore without -noprops)
property -colorscheme classic
property attrcolor #000000
property attrfontsize 8
property autobundle 1
property backgroundcolor #ffffff
property boxcolor0 #000000
property boxcolor1 #000000
property boxcolor2 #000000
property boxinstcolor #000000
property boxpincolor #000000
property buscolor #008000
property closeenough 5
property createnetattrdsp 2048
property decorate 1
property elidetext 40
property fillcolor1 #ffffcc
property fillcolor2 #dfebf8
property fillcolor3 #f0f0f0
property gatecellname 2
property instattrmax 30
property instdrag 15
property instorder 1
property marksize 12
property maxfontsize 18
property maxzoom 7.5
property netcolor #19b400
property objecthighlight0 #ff00ff
property objecthighlight1 #ffff00
property objecthighlight2 #00ff00
property objecthighlight3 #0095ff
property objecthighlight4 #8000ff
property objecthighlight5 #ffc800
property objecthighlight7 #00ffff
property objecthighlight8 #ff00ff
property objecthighlight9 #ccccff
property objecthighlight10 #0ead00
property objecthighlight11 #cefc00
property objecthighlight12 #9e2dbe
property objecthighlight13 #ba6a29
property objecthighlight14 #fc0188
property objecthighlight15 #02f990
property objecthighlight16 #f1b0fb
property objecthighlight17 #fec004
property objecthighlight18 #149bff
property objecthighlight19 #eb591b
property overlaycolor #19b400
property pbuscolor #000000
property pbusnamecolor #000000
property pinattrmax 20
property pinorder 2
property pinpermute 0
property portcolor #000000
property portnamecolor #000000
property ripindexfontsize 4
property rippercolor #000000
property rubberbandcolor #000000
property rubberbandfontsize 18
property selectattr 0
property selectionappearance 2
property selectioncolor #0000ff
property sheetheight 44
property sheetwidth 68
property showmarks 1
property shownetname 0
property showpagenumbers 1
property showripindex 1
property timelimit 1
#
module new PSIO_8bit work:PSIO_8bit:NOFILE -nosplit
load symbol BUFG hdi_primitives BUF pin O output pin I input fillcolor 1
load symbol IBUF hdi_primitives BUF pin O output pin I input fillcolor 1
load symbol OBUF hdi_primitives BUF pin O output pin I input fillcolor 1
load symbol FDRE hdi_primitives GEN pin Q output.right pin C input.clk.left pin CE input.left pin D input.left pin R input.left fillcolor 1
load symbol LUT3 hdi_primitives BOX pin O output.right pin I0 input.left pin I1 input.left pin I2 input.left fillcolor 1
load symbol LUT2 hdi_primitives BOX pin O output.right pin I0 input.left pin I1 input.left fillcolor 1
load port clk input -pg 1 -lvl 0 -x 0 -y 270
load port load input -pg 1 -lvl 0 -x 0 -y 110
load port rst input -pg 1 -lvl 0 -x 0 -y 340
load port serial_out output -pg 1 -lvl 20 -x 4450 -y 250
load port shift input -pg 1 -lvl 0 -x 0 -y 40
load portBus parallel_in input [7:0] -attr @name parallel_in[7:0] -pg 1 -lvl 0 -x 0 -y 180
load inst clk_IBUF_BUFG_inst BUFG hdi_primitives -attr @cell(#000000) BUFG -pg 1 -lvl 2 -x 310 -y 270
load inst clk_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 1 -x 60 -y 270
load inst load_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 1 -x 60 -y 110
load inst parallel_in_IBUF[0]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 15 -x 3530 -y 60
load inst parallel_in_IBUF[1]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 13 -x 3040 -y 100
load inst parallel_in_IBUF[2]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 11 -x 2550 -y 110
load inst parallel_in_IBUF[3]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2060 -y 110
load inst parallel_in_IBUF[4]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 7 -x 1570 -y 110
load inst parallel_in_IBUF[5]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 5 -x 1080 -y 110
load inst parallel_in_IBUF[6]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 3 -x 590 -y 180
load inst parallel_in_IBUF[7]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 1 -x 60 -y 180
load inst rst_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 2 -x 310 -y 340
load inst serial_out_OBUF_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 19 -x 4270 -y 250
load inst serial_out_reg FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 18 -x 4140 -y 250
load inst shift_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 1 -x 60 -y 40
load inst shift_reg[0]_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 16 -x 3780 -y 80
load inst shift_reg[1]_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 14 -x 3310 -y 140
load inst shift_reg[2]_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 12 -x 2820 -y 180
load inst shift_reg[3]_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 10 -x 2330 -y 190
load inst shift_reg[4]_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 8 -x 1840 -y 190
load inst shift_reg[5]_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 6 -x 1350 -y 190
load inst shift_reg[6]_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 4 -x 860 -y 190
load inst shift_reg[7]_i_1 LUT2 hdi_primitives -attr @cell(#000000) LUT2 -pg 1 -lvl 2 -x 310 -y 50
load inst shift_reg[7]_i_2 LUT2 hdi_primitives -attr @cell(#000000) LUT2 -pg 1 -lvl 2 -x 310 -y 150
load inst shift_reg_reg[0] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 17 -x 3960 -y 300
load inst shift_reg_reg[1] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 15 -x 3530 -y 190
load inst shift_reg_reg[2] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 13 -x 3040 -y 230
load inst shift_reg_reg[3] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 11 -x 2550 -y 240
load inst shift_reg_reg[4] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 9 -x 2060 -y 240
load inst shift_reg_reg[5] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 7 -x 1570 -y 240
load inst shift_reg_reg[6] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 5 -x 1080 -y 240
load inst shift_reg_reg[7] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 3 -x 590 -y 290
load net clk -port clk -pin clk_IBUF_inst I
netloc clk 1 0 1 NJ 270
load net clk_IBUF -pin clk_IBUF_BUFG_inst I -pin clk_IBUF_inst O
netloc clk_IBUF 1 1 1 NJ 270
load net clk_IBUF_BUFG -pin clk_IBUF_BUFG_inst O -pin serial_out_reg C -pin shift_reg_reg[0] C -pin shift_reg_reg[1] C -pin shift_reg_reg[2] C -pin shift_reg_reg[3] C -pin shift_reg_reg[4] C -pin shift_reg_reg[5] C -pin shift_reg_reg[6] C -pin shift_reg_reg[7] C
netloc clk_IBUF_BUFG 1 2 16 480 390 NJ 390 990 340 NJ 340 1480 340 NJ 340 1970 340 NJ 340 2460 340 NJ 340 2970 330 NJ 330 3440 270 NJ 270 3910 220 NJ
load net load -port load -pin load_IBUF_inst I
netloc load 1 0 1 NJ 110
load net load_IBUF -pin load_IBUF_inst O -pin shift_reg[0]_i_1 I1 -pin shift_reg[1]_i_1 I1 -pin shift_reg[2]_i_1 I1 -pin shift_reg[3]_i_1 I1 -pin shift_reg[4]_i_1 I1 -pin shift_reg[5]_i_1 I1 -pin shift_reg[6]_i_1 I1 -pin shift_reg[7]_i_1 I1 -pin shift_reg[7]_i_2 I0
netloc load_IBUF 1 1 15 260 120 NJ 120 810 160 NJ 160 1300 160 NJ 160 1790 160 NJ 160 2280 160 NJ 160 2770 150 NJ 150 3260 110 NJ 110 NJ
load net p_1_in[0] -pin shift_reg[0]_i_1 O -pin shift_reg_reg[0] D
netloc p_1_in[0] 1 16 1 3890 110n
load net p_1_in[1] -pin shift_reg[1]_i_1 O -pin shift_reg_reg[1] D
netloc p_1_in[1] 1 14 1 3420 170n
load net p_1_in[2] -pin shift_reg[2]_i_1 O -pin shift_reg_reg[2] D
netloc p_1_in[2] 1 12 1 2930 210n
load net p_1_in[3] -pin shift_reg[3]_i_1 O -pin shift_reg_reg[3] D
netloc p_1_in[3] 1 10 1 2440 220n
load net p_1_in[4] -pin shift_reg[4]_i_1 O -pin shift_reg_reg[4] D
netloc p_1_in[4] 1 8 1 1950 220n
load net p_1_in[5] -pin shift_reg[5]_i_1 O -pin shift_reg_reg[5] D
netloc p_1_in[5] 1 6 1 1460 220n
load net p_1_in[6] -pin shift_reg[6]_i_1 O -pin shift_reg_reg[6] D
netloc p_1_in[6] 1 4 1 970 220n
load net p_1_in[7] -pin shift_reg[7]_i_2 O -pin shift_reg_reg[7] D
netloc p_1_in[7] 1 2 1 500 160n
load net parallel_in[0] -attr @rip(#000000) parallel_in[0] -port parallel_in[0] -pin parallel_in_IBUF[0]_inst I
load net parallel_in[1] -attr @rip(#000000) parallel_in[1] -port parallel_in[1] -pin parallel_in_IBUF[1]_inst I
load net parallel_in[2] -attr @rip(#000000) parallel_in[2] -port parallel_in[2] -pin parallel_in_IBUF[2]_inst I
load net parallel_in[3] -attr @rip(#000000) parallel_in[3] -port parallel_in[3] -pin parallel_in_IBUF[3]_inst I
load net parallel_in[4] -attr @rip(#000000) parallel_in[4] -port parallel_in[4] -pin parallel_in_IBUF[4]_inst I
load net parallel_in[5] -attr @rip(#000000) parallel_in[5] -port parallel_in[5] -pin parallel_in_IBUF[5]_inst I
load net parallel_in[6] -attr @rip(#000000) parallel_in[6] -port parallel_in[6] -pin parallel_in_IBUF[6]_inst I
load net parallel_in[7] -attr @rip(#000000) parallel_in[7] -port parallel_in[7] -pin parallel_in_IBUF[7]_inst I
load net parallel_in_IBUF[0] -pin parallel_in_IBUF[0]_inst O -pin shift_reg[0]_i_1 I0
netloc parallel_in_IBUF[0] 1 15 1 3730J 60n
load net parallel_in_IBUF[1] -pin parallel_in_IBUF[1]_inst O -pin shift_reg[1]_i_1 I0
netloc parallel_in_IBUF[1] 1 13 1 3240J 100n
load net parallel_in_IBUF[2] -pin parallel_in_IBUF[2]_inst O -pin shift_reg[2]_i_1 I0
netloc parallel_in_IBUF[2] 1 11 1 2750J 110n
load net parallel_in_IBUF[3] -pin parallel_in_IBUF[3]_inst O -pin shift_reg[3]_i_1 I0
netloc parallel_in_IBUF[3] 1 9 1 2260J 110n
load net parallel_in_IBUF[4] -pin parallel_in_IBUF[4]_inst O -pin shift_reg[4]_i_1 I0
netloc parallel_in_IBUF[4] 1 7 1 1770J 110n
load net parallel_in_IBUF[5] -pin parallel_in_IBUF[5]_inst O -pin shift_reg[5]_i_1 I0
netloc parallel_in_IBUF[5] 1 5 1 1280J 110n
load net parallel_in_IBUF[6] -pin parallel_in_IBUF[6]_inst O -pin shift_reg[6]_i_1 I0
netloc parallel_in_IBUF[6] 1 3 1 790J 180n
load net parallel_in_IBUF[7] -pin parallel_in_IBUF[7]_inst O -pin shift_reg[7]_i_2 I1
netloc parallel_in_IBUF[7] 1 1 1 NJ 180
load net rst -port rst -pin rst_IBUF_inst I
netloc rst 1 0 2 NJ 340 NJ
load net rst_IBUF -pin rst_IBUF_inst O -pin serial_out_reg R -pin shift_reg_reg[0] R -pin shift_reg_reg[1] R -pin shift_reg_reg[2] R -pin shift_reg_reg[3] R -pin shift_reg_reg[4] R -pin shift_reg_reg[5] R -pin shift_reg_reg[6] R -pin shift_reg_reg[7] R
netloc rst_IBUF 1 2 16 540 410 NJ 410 1030 360 NJ 360 1520 360 NJ 360 2010 360 NJ 360 2500 360 NJ 360 2990 350 NJ 350 3480 330 NJ 330 3910 380 4090J
load net serial_out -port serial_out -pin serial_out_OBUF_inst O
netloc serial_out 1 19 1 NJ 250
load net serial_out_OBUF -pin serial_out_OBUF_inst I -pin serial_out_reg Q
netloc serial_out_OBUF 1 18 1 NJ 250
load net shift -port shift -pin shift_IBUF_inst I
netloc shift 1 0 1 NJ 40
load net shift_IBUF -pin serial_out_reg CE -pin shift_IBUF_inst O -pin shift_reg[7]_i_1 I0
netloc shift_IBUF 1 1 17 260 20 NJ 20 NJ 20 NJ 20 NJ 20 NJ 20 NJ 20 NJ 20 NJ 20 NJ 20 NJ 20 NJ 20 NJ 20 NJ 20 NJ 20 NJ 20 4070
load net shift_reg[7]_i_1_n_0 -pin shift_reg[7]_i_1 O -pin shift_reg_reg[0] CE -pin shift_reg_reg[1] CE -pin shift_reg_reg[2] CE -pin shift_reg_reg[3] CE -pin shift_reg_reg[4] CE -pin shift_reg_reg[5] CE -pin shift_reg_reg[6] CE -pin shift_reg_reg[7] CE
netloc shift_reg[7]_i_1_n_0 1 2 15 520 370 NJ 370 1010 320 NJ 320 1500 320 NJ 320 1990 320 NJ 320 2480 320 NJ 320 2950 310 NJ 310 3460 290 NJ 290 NJ
load net shift_reg_reg_n_0_[0] -pin serial_out_reg D -pin shift_reg_reg[0] Q
netloc shift_reg_reg_n_0_[0] 1 17 1 4070 260n
load net shift_reg_reg_n_0_[1] -pin shift_reg[0]_i_1 I2 -pin shift_reg_reg[1] Q
netloc shift_reg_reg_n_0_[1] 1 15 1 3730 130n
load net shift_reg_reg_n_0_[2] -pin shift_reg[1]_i_1 I2 -pin shift_reg_reg[2] Q
netloc shift_reg_reg_n_0_[2] 1 13 1 3240 190n
load net shift_reg_reg_n_0_[3] -pin shift_reg[2]_i_1 I2 -pin shift_reg_reg[3] Q
netloc shift_reg_reg_n_0_[3] 1 11 1 2750 230n
load net shift_reg_reg_n_0_[4] -pin shift_reg[3]_i_1 I2 -pin shift_reg_reg[4] Q
netloc shift_reg_reg_n_0_[4] 1 9 1 N 240
load net shift_reg_reg_n_0_[5] -pin shift_reg[4]_i_1 I2 -pin shift_reg_reg[5] Q
netloc shift_reg_reg_n_0_[5] 1 7 1 N 240
load net shift_reg_reg_n_0_[6] -pin shift_reg[5]_i_1 I2 -pin shift_reg_reg[6] Q
netloc shift_reg_reg_n_0_[6] 1 5 1 N 240
load net shift_reg_reg_n_0_[7] -pin shift_reg[6]_i_1 I2 -pin shift_reg_reg[7] Q
netloc shift_reg_reg_n_0_[7] 1 3 1 790 240n
load netBundle @parallel_in 8 parallel_in[7] parallel_in[6] parallel_in[5] parallel_in[4] parallel_in[3] parallel_in[2] parallel_in[1] parallel_in[0] -autobundled
netbloc @parallel_in 1 0 15 20 230 NJ 230 480 140 NJ 140 990 70 NJ 70 1460 70 NJ 70 1950 70 NJ 70 2440 70 NJ 70 2930 60 NJ 60 3480J
levelinfo -pg 1 0 60 310 590 860 1080 1350 1570 1840 2060 2330 2550 2820 3040 3310 3530 3780 3960 4140 4270 4450
pagesize -pg 1 -db -bbox -sgen -150 0 4570 420
show
fullfit
#
# initialize ictrl to current module PSIO_8bit work:PSIO_8bit:NOFILE
ictrl init topinfo |
