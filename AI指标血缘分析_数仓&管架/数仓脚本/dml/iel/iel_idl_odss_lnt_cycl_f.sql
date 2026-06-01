: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_lnt_cycl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_lnt_cycl_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select CNTRNO
,LNSQNO
,LOANCN
,CARDNO
,LOANAM
,QTMUDT
,ITEMCD
,LNRTTP
,INSTRT
,NMFLRT
,FRCGDT
,PNDGPT
,PNDGTP
,CLOSDT
,CLOSUS
,CNTRST
,RETNTG from IDL.ODSS_LNT_CYCL where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_lnt_cycl_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes