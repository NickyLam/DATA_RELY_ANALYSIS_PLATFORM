: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_scrm_we_flower_customer_rel_f
CreateDate: 20230804
FileName:   ${iel_data_path}/scrm_we_flower_customer_rel.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.qw_user_id,chr(13),''),chr(10),'') as qw_user_id
,replace(replace(t1.external_userid,chr(13),''),chr(10),'') as external_userid
,replace(replace(t1.oper_userid,chr(13),''),chr(10),'') as oper_userid
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.descript,chr(13),''),chr(10),'') as descript
,replace(replace(t1.remark_corp_name,chr(13),''),chr(10),'') as remark_corp_name
,replace(replace(t1.remark_mobiles,chr(13),''),chr(10),'') as remark_mobiles
,replace(replace(t1.add_way,chr(13),''),chr(10),'') as add_way
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,is_open_chat
,replace(replace(t1.crm_contr_id,chr(13),''),chr(10),'') as crm_contr_id
,replace(replace(t1.crm_contr_nm,chr(13),''),chr(10),'') as crm_contr_nm
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.last_modi_by,chr(13),''),chr(10),'') as last_modi_by
,replace(replace(t1.last_modi_time,chr(13),''),chr(10),'') as last_modi_time
,replace(replace(t1.is_have_xing,chr(13),''),chr(10),'') as is_have_xing

from ${iol_schema}.scrm_we_flower_customer_rel t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/scrm_we_flower_customer_rel.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
