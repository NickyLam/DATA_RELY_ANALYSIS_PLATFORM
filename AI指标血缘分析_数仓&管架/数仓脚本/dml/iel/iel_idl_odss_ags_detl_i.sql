: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_ags_detl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_ags_detl_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select BTDATE
,BACHNO
,AGENTP
,BTPRCD
,AGNTID
,MDTRDT
,MDTRSQ
,DETLAC
,DETLNA
,TRANAM
,SUCSAM
,RVAM01
,RVAM02
,RVAM03
,RVCH01
,RVCH02
,RVCH03
,SMRYCD
,PRRTCD
,TRANST
,TRANDT
,TRANSQ
,ERORTX
,UNINTG
,TRANTP
,OTERCD
,ORTRDT
,ORTRSQ from IDL.ODSS_AGS_DETL where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_ags_detl_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes