: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_lnb_lbsq_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_lnb_lbsq_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select LNBLSQ
,ACCTID
,LNBLTP
,CRCYCD
,INLNBL
,TERMNO
,PAYRTP
,INPTDT
,INPTSQ
,ORGIBL
,INTRSQ
,INSTDT
,INEDDT
,ONLNBL
,BGINDT
,MATUDT
,ACMLDT
,ACMLBL
,INSTAM
,ACPTAM
,CLOSDT
,CLOSSQ
,TRANST
,EDCTBL
,INSTTG from IDL.ODSS_LNB_LBSQ where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_lnb_lbsq_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes