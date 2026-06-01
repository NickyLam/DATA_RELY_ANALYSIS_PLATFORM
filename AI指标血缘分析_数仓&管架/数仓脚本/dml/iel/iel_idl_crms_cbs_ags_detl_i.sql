: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_ags_detl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cbs_ags_detl_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
btdate
,bachno
,agentp
,btprcd
,agntid
,mdtrdt
,mdtrsq
,detlac
,detlna
,tranam
,sucsam
,rvam01
,rvam02
,rvam03
,rvch01
,rvch02
,rvch03
,smrycd
,prrtcd
,transt
,trandt
,transq
,erortx
,unintg
,trantp
,otercd
,ortrdt
,ortrsq
from ${idl_schema}.crms_cbs_ags_detl
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cbs_ags_detl_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes