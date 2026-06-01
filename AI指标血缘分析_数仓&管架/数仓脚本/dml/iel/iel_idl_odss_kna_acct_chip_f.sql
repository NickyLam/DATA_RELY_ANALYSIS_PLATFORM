: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kna_acct_chip_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kna_acct_chip_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select ACCTNO
,CUSTNA
,IDTFTP
,IDTFNO
,EFCTDT
,INEFDT
,MXBLAM
,MXLIMT
,ATTRPT
,ATTRAM
,SAVEAM
,DRAWAM
,LSTOFF
,OFLINE
,OPENBR
,OPENSQ
,ONLNBL
,LSTRDT
,LSTRSQ
,CLOSDT
,CLOSSQ
,ACCTST
,CARDSQ from IDL.ODSS_KNA_ACCT_CHIP where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kna_acct_chip_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes