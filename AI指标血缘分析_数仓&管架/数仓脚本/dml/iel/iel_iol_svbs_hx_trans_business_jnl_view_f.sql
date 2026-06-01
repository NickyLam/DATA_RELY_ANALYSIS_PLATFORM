: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_svbs_hx_trans_business_jnl_view_f
CreateDate: 20250904
FileName:   ${iel_data_path}/svbs_hx_trans_business_jnl_view.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.trans_date,chr(13),''),chr(10),'') as trans_date
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.departmentid,chr(13),''),chr(10),'') as departmentid
,replace(replace(t1.departmentname,chr(13),''),chr(10),'') as departmentname
,replace(replace(t1.client_id,chr(13),''),chr(10),'') as client_id
,replace(replace(t1.agentname,chr(13),''),chr(10),'') as agentname
,replace(replace(t1.author_id,chr(13),''),chr(10),'') as author_id
,replace(replace(t1.trans_code,chr(13),''),chr(10),'') as trans_code
,replace(replace(t1.resourcename,chr(13),''),chr(10),'') as resourcename
,trans_time
,update_time
,replace(replace(t1.author_name,chr(13),''),chr(10),'') as author_name
,replace(replace(t1.author_org_id,chr(13),''),chr(10),'') as author_org_id
,replace(replace(t1.access_jnl_no,chr(13),''),chr(10),'') as access_jnl_no
,replace(replace(t1.ststem_name,chr(13),''),chr(10),'') as ststem_name
,replace(replace(t1.stm_jnl_no,chr(13),''),chr(10),'') as stm_jnl_no

from ${iol_schema}.svbs_hx_trans_business_jnl_view t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/svbs_hx_trans_business_jnl_view.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
