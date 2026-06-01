: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kns_tran_extd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kns_tran_extd_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,TRANSQ
,AGCUNA
,AGIDTP
,AGIDNO
,SMRYTX
,PSTSPT
,EXTDC1
,EXTDC2
,EXTDC3
,EXTDC4
,EXTDC5
,EXTDC6
,EXTDC7
,EXTDC8
,AGENDR
,AGIDMT
,AGTELE
,AGADRS
,AGDESC
,AGTYPE
,OPIDTP
,OPIDNO
,OPCUNA
,NTLYCD from IDL.ODSS_KNS_TRAN_EXTD where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kns_tran_extd_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes