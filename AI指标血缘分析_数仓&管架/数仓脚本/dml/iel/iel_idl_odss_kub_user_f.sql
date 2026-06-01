: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kub_user_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kub_user_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select USERID
,USERNA
,BRCHNO
,USERST
,USSATG
,LASTLG
,USERTP
,LSTRDT
,MENUGP from IDL.ODSS_KUB_USER where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kub_user_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes