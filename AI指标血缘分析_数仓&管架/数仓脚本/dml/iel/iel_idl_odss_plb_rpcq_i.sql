: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_plb_rpcq_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_plb_rpcq_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select RPLSDT
,RPLSSQ
,TRANSQ
,RPLSFS
,ACCTNO
,DCMTTP
,DCMTNO
,DCTPID
,TRANAM
,REMTDT
,PYERNA
,PYEENA
,APLYNA
,LOSSDT
,LOSSAD
,LOSSMK
,CTNAME
,CTSTNO
,STATUS
,RPLSUS
,BRCHNO
,AGCUNA
,AGIDTP
,AGIDNO
,AGCUAD
,AGCUTL
,EXUSNA
,EXIDTP
,EXIDNO
,REMKTX
,EUSNA2
,EIDTP2
,EIDNO2 from IDL.ODSS_PLB_RPCQ where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_plb_rpcq_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes