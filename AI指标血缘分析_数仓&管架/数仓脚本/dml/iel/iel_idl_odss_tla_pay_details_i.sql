: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tla_pay_details_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tla_pay_details_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,batchno
,batchdate
,accountlogid
,detailid
,dtlseq
,contractno
,draftno
,payactno
,rcvactno
,ovepayactno
,interactno
,bailactno
,faceamt
,payamt
,rcvamt
,ovepayamt
,bailamt
,stlmrefno
,isove
,payseq
,cuspaystats
,torcvtostats
,cuspayreqtime
,cuspayrsptime
,torcvtime
,lstupdtime
,brcd
,isbatflg
from ${idl_schema}.odss_tla_pay_details
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tla_pay_details_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes