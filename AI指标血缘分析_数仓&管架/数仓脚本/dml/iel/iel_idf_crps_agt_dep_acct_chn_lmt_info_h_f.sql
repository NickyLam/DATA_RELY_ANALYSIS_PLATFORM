: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_agt_dep_acct_chn_lmt_info_h_f
CreateDate: 20241230
FileName:   ${iel_data_path}/crps_agt_dep_acct_chn_lmt_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ctrl_id,chr(13),''),chr(10),'') as ctrl_id
,replace(replace(t1.ctrl_type_cd,chr(13),''),chr(10),'') as ctrl_type_cd
,replace(replace(t1.ctrl_status_cd,chr(13),''),chr(10),'') as ctrl_status_cd
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.lmt_lev_cd,chr(13),''),chr(10),'') as lmt_lev_cd
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.lmt_acct_range_cd,chr(13),''),chr(10),'') as lmt_acct_range_cd
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,effect_dt
,invalid_dt
,final_modif_dt
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.final_modif_teller_id,chr(13),''),chr(10),'') as final_modif_teller_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,unloss_tm
,replace(replace(t1.unloss_teller_id,chr(13),''),chr(10),'') as unloss_teller_id
,replace(replace(t1.memo_descb,chr(13),''),chr(10),'') as memo_descb
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,tran_timestamp
,begin_dt
,exp_dt

from iml.agt_dep_acct_chn_lmt_info_h t1 
where 1 = 1; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_agt_dep_acct_chn_lmt_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
