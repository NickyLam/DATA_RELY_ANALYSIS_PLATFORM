: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_pcp_sub_acct_info_f
CreateDate: 20230829
FileName:   ${iel_data_path}/ncbs_rb_pcp_sub_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,internal_key
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.inc_exp_ind,chr(13),''),chr(10),'') as inc_exp_ind
,replace(replace(t1.min_sub_status,chr(13),''),chr(10),'') as min_sub_status
,replace(replace(t1.pcp_group_id,chr(13),''),chr(10),'') as pcp_group_id
,replace(replace(t1.priority,chr(13),''),chr(10),'') as priority
,replace(replace(t1.sub_seq_no,chr(13),''),chr(10),'') as sub_seq_no
,create_date
,effect_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.upper_base_acct_no,chr(13),''),chr(10),'') as upper_base_acct_no
,upper_internal_key

from ${iol_schema}.ncbs_rb_pcp_sub_acct_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_pcp_sub_acct_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
