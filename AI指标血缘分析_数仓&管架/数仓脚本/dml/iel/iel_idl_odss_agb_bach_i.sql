: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_agb_bach_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_agb_bach_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select BTDATE
,BACHNO
,AGENTP
,BTPRCD
,BRCHNO
,ACCTNO
,RCRDDT
,RCRDUS
,TRANAM
,TRANAN
,COMTAM
,COMTAN
,TRANDT
,BACHST
,REMKTX
,DCMTTP
,DCTPID
,CSBXNO
,SMRYCD
,CRCYCD
,CSEXTG
,PAYSTP
,FILENA
,DLTRDT
,DLTRSQ
,FILETP
,DCMTNO
,SMRY01
,SMRY02
,SMRY03
,SMRY04 from IDL.ODSS_AGB_BACH where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_agb_bach_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes