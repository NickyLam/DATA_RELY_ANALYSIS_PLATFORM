: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_aos_bcop_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_aos_bcop_${batch_date}_f.dat
IF_mark:    f
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
,AGACNO
,TRANAM
,DCMTTP
,DCTPID
,CRCYCD
,CSEXTG
,DETLNA
,IDTFTP
,IDTFNO
,GENDER
,DEBTTP
,OFFCTL
,HOMETL
,MOBITL
,MAILCD
,MAILAD
,AGIDTP
,AGIDNO
,AGCUNA
,RVAM01
,RVAM02
,RVAM03
,RVCH01
,RVCH02
,RVCH03
,SMRYCD
,PRRTCD
,TRANST
,SUCSAM
,ACCTNO
,SUBSAC
,DCMTNO
,TRANDT
,TRANSQ
,ERORTX from IDL.ODSS_AOS_BCOP where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_aos_bcop_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes