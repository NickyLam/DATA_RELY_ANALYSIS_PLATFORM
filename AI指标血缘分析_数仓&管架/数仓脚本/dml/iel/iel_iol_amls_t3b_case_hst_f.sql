: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t3b_case_hst_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t3b_case_hst.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.case_id,chr(13),''),chr(10),'') as case_id
    ,t.stat_dt as stat_dt
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,replace(replace(t.case_dt,chr(13),''),chr(10),'') as case_dt
    ,replace(replace(t.case_kind,chr(13),''),chr(10),'') as case_kind
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.cust_type,chr(13),''),chr(10),'') as cust_type
    ,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
    ,replace(replace(t.post_id,chr(13),''),chr(10),'') as post_id
    ,replace(replace(t.node_id,chr(13),''),chr(10),'') as node_id
    ,replace(replace(t.case_sts,chr(13),''),chr(10),'') as case_sts
    ,replace(replace(t.is_del,chr(13),''),chr(10),'') as is_del
    ,replace(replace(t.is_sys_del,chr(13),''),chr(10),'') as is_sys_del
    ,replace(replace(t.create_mode,chr(13),''),chr(10),'') as create_mode
    ,replace(replace(t.invalid_dt,chr(13),''),chr(10),'') as invalid_dt
    ,replace(replace(t.is_local_curr,chr(13),''),chr(10),'') as is_local_curr
    ,replace(replace(t.susp_lvl,chr(13),''),chr(10),'') as susp_lvl
    ,replace(replace(t.take_action,chr(13),''),chr(10),'') as take_action
    ,replace(replace(t.crime_type,chr(13),''),chr(10),'') as crime_type
    ,replace(replace(t.trig_point,chr(13),''),chr(10),'') as trig_point
    ,replace(replace(t.is_valid,chr(13),''),chr(10),'') as is_valid
    ,t.due_dt as due_dt
    ,replace(replace(t.create_tm,chr(13),''),chr(10),'') as create_tm
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,replace(replace(t.modify_tm,chr(13),''),chr(10),'') as modify_tm
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.fin_act_desc,chr(13),''),chr(10),'') as fin_act_desc
    ,replace(replace(t.other_desc,chr(13),''),chr(10),'') as other_desc
    ,replace(replace(t.is_follow,chr(13),''),chr(10),'') as is_follow
    ,replace(replace(t.eme_lvl,chr(13),''),chr(10),'') as eme_lvl
    ,replace(replace(t.is_free_trade,chr(13),''),chr(10),'') as is_free_trade
    ,replace(replace(t.rpt_num,chr(13),''),chr(10),'') as rpt_num
    ,replace(replace(t.is_continue,chr(13),''),chr(10),'') as is_continue
    ,replace(replace(t.init_case,chr(13),''),chr(10),'') as init_case
    ,replace(replace(t.init_report,chr(13),''),chr(10),'') as init_report
    ,replace(replace(t.p_case_id,chr(13),''),chr(10),'') as p_case_id
    ,t.score as score
    ,replace(replace(t.level_name,chr(13),''),chr(10),'') as level_name
    ,replace(replace(t.score_des,chr(13),''),chr(10),'') as score_des
    ,replace(replace(t.fill_man,chr(13),''),chr(10),'') as fill_man
    ,replace(replace(t.init_msg,chr(13),''),chr(10),'') as init_msg
    ,replace(replace(t.mirs,chr(13),''),chr(10),'') as mirs
    ,replace(replace(t.busi_prod,chr(13),''),chr(10),'') as busi_prod
from iol.amls_t3b_case_hst t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t3b_case_hst.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes