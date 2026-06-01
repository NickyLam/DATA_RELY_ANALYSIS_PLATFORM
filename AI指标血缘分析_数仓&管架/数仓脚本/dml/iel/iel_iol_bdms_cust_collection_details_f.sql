: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_cust_collection_details_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_cust_collection_details.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.business_no,chr(13),''),chr(10),'') as business_no
,t.batch_id as batch_id
,t.draft_id as draft_id
,replace(replace(t.account_status,chr(13),''),chr(10),'') as account_status
,replace(replace(t.colle_date,chr(13),''),chr(10),'') as colle_date
,replace(replace(t.acceptor_address,chr(13),''),chr(10),'') as acceptor_address
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.core_account,chr(13),''),chr(10),'') as core_account
,replace(replace(t.account_date,chr(13),''),chr(10),'') as account_date
,replace(replace(t.trandate,chr(13),''),chr(10),'') as trandate
,replace(replace(t.paymsgsrc,chr(13),''),chr(10),'') as paymsgsrc
,replace(replace(t.trannumber,chr(13),''),chr(10),'') as trannumber
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_cust_collection_details t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_cust_collection_details.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes