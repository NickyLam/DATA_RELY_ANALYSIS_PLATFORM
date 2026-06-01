: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_gl_brg_glis_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_gl_brg_glis_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select ACCTDT
,BRCHNO
,CRCYCD
,ITEMCD
,DRLTBL
,CRLTBL
,DRTSAM
,DRTSNM
,CRTSAM
,CRTSNM
,DRCTBL
,CRCTBL
,IOFLAG from IDL.ODSS_GL_BRG_GLIS where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_gl_brg_glis_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes