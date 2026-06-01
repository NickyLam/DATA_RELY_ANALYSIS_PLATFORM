: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_v4a_cust_wf_log_orw_f
CreateDate: 20250828
FileName:   ${iel_data_path}/amls_v4a_cust_wf_log_orw.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tr_tm,chr(13),''),chr(10),'') as tr_tm
,replace(replace(t1.tr_org_id,chr(13),''),chr(10),'') as tr_org_id
,replace(replace(t1.post_name,chr(13),''),chr(10),'') as post_name
,replace(replace(t1.opr_user,chr(13),''),chr(10),'') as opr_user
,replace(replace(t1.opr_user_name,chr(13),''),chr(10),'') as opr_user_name
,replace(replace(t1.opr_id,chr(13),''),chr(10),'') as opr_id
,replace(replace(t1.opr_name,chr(13),''),chr(10),'') as opr_name
,replace(replace(t1.opr_org_id,chr(13),''),chr(10),'') as opr_org_id
,replace(replace(t1.tr_code,chr(13),''),chr(10),'') as tr_code
,replace(replace(t1.tr_name,chr(13),''),chr(10),'') as tr_name
,tr_begin_tm
,tr_end_tm
,replace(replace(t1.tr_no,chr(13),''),chr(10),'') as tr_no
,replace(replace(t1.system,chr(13),''),chr(10),'') as system

from ${iol_schema}.amls_v4a_cust_wf_log_orw t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_v4a_cust_wf_log_orw.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
