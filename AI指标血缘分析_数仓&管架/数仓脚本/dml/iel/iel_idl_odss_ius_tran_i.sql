: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_ius_tran_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_ius_tran_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,TRANSQ
,SYSTRN
,ACPTID
,SENDID
,TRANTI
,PRCSCD
,SERVTP
,TRANTP
,CRCYCD
,CARDNO
,DCMTNO
,TRANAM
,TRANAC
,OPPSAC
,STORTP
,STORCD
,UNIODT
,POSCOD
,TSBKCD
,UNTSTP
,AREATP
,AUAUSQ
,USERID
,REMKTX
,TRANST
,CORRDT
,CORTSQ
,HANDCH
,DZTRST
,SETLDT
,SETLTG
,FROZSQ from IDL.ODSS_IUS_TRAN where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_ius_tran_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes