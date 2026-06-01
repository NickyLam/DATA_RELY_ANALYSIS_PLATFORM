: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_lcb_yk_acpt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_lcb_yk_acpt_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select DATAID
,ACPTNO
,ACPTBR
,PYERAC
,CRCYCD
,BLTYPE
,NOTETP
,NOTEAM
,HANDAM
,GRETNO
,GRSBAC
,GRAITO
,TERMCD
,ISSUDT
,CLOSDT
,CLOSSQ
,ACPTST
,CLOSST
,PYMCDT
,PYMCSQ
,PYMCTP
,ACLFAM
,MATUDT
,PYMCAC
,LNCFNO from IDL.ODSS_LCB_YK_ACPT where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_lcb_yk_acpt_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes