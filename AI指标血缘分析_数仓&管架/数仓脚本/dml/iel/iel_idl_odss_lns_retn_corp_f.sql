: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_lns_retn_corp_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_lns_retn_corp_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select CMSQNO
,LNCFNO
,ACCRBL
,CORPAM
,ADJUTP
,NEWTRM
,TRANDT
,RECVTM
,TRANST
,DFLTAM from IDL.ODSS_LNS_RETN_CORP where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_lns_retn_corp_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes