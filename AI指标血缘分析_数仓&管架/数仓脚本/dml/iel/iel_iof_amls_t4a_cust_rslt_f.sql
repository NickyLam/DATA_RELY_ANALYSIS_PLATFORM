: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_amls_t4a_cust_rslt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t4a_cust_rslt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rslt_id,chr(13),''),chr(10),'') as rslt_id
,replace(replace(t1.model_id,chr(13),''),chr(10),'') as model_id
,replace(replace(t1.fomula_id,chr(13),''),chr(10),'') as fomula_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.first_lvl,chr(13),''),chr(10),'') as first_lvl
,replace(replace(t1.adjust_lvl,chr(13),''),chr(10),'') as adjust_lvl
,replace(replace(t1.curr_lvl,chr(13),''),chr(10),'') as curr_lvl
,replace(replace(t1.last_lvl,chr(13),''),chr(10),'') as last_lvl
,t1.stat_dt as stat_dt
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.rslt_sts,chr(13),''),chr(10),'') as rslt_sts
,replace(replace(t1.model_type,chr(13),''),chr(10),'') as model_type
,replace(replace(t1.model_freq,chr(13),''),chr(10),'') as model_freq
,t1.create_dt as create_dt
,replace(replace(t1.post_id,chr(13),''),chr(10),'') as post_id
,replace(replace(t1.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.modify_tm,chr(13),''),chr(10),'') as modify_tm
,replace(replace(t1.reason,chr(13),''),chr(10),'') as reason
,replace(replace(t1.model_catg,chr(13),''),chr(10),'') as model_catg
,t1.score as score
,t1.curr_score as curr_score
,replace(replace(t1.is_adjust_score,chr(13),''),chr(10),'') as is_adjust_score
,t1.due_dt as due_dt
,t1.next_stat_dt as next_stat_dt
,replace(replace(t1.assist_sts,chr(13),''),chr(10),'') as assist_sts
,replace(replace(t1.rate_source,chr(13),''),chr(10),'') as rate_source
,replace(replace(t1.rate_type,chr(13),''),chr(10),'') as rate_type
,t1.re_adjust_dt as re_adjust_dt
,replace(replace(t1.adjust_score_reason,chr(13),''),chr(10),'') as adjust_score_reason
,replace(replace(t1.cust_sts,chr(13),''),chr(10),'') as cust_sts
from ${iol_schema}.amls_t4a_cust_rslt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t4a_cust_rslt.f.${batch_date}.dat" \
        charset=utf8
        safe=yes