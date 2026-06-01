: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_e_chn_tim_plan_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_e_chn_tim_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(tim_task_id,chr(10),''),chr(13),'') as tim_task_id
      ,replace(replace(tim_task_typ_cd,chr(10),''),chr(13),'') as tim_task_typ_cd
      ,replace(replace(user_id,chr(10),''),chr(13),'') as user_id
      ,tim_task_sys_def_dt
      ,replace(replace(tim_type_cd,chr(10),''),chr(13),'') as tim_type_cd
      ,replace(replace(tim_freq_type_cd,chr(10),''),chr(13),'') as tim_freq_type_cd
      ,replace(replace(tim_rule_desc,chr(10),''),chr(13),'') as tim_rule_desc
      ,replace(replace(tim_task_status_cd,chr(10),''),chr(13),'') as tim_task_status_cd
      ,tim_task_st_dt
      ,tim_task_end_dt
      ,tim_task_canc_dt
      ,replace(replace(payer_blng_org_cd,chr(10),''),chr(13),'') as payer_blng_org_cd
      ,replace(replace(payer_acct,chr(10),''),chr(13),'') as payer_acct
      ,replace(replace(cntrpty_acct_id,chr(10),''),chr(13),'') as cntrpty_acct_id
      ,replace(replace(cntrpty_acct_name,chr(10),''),chr(13),'') as cntrpty_acct_name
      ,replace(replace(cntrpty_acct_openbk_num,chr(10),''),chr(13),'') as cntrpty_acct_openbk_num
      ,replace(replace(cntrpty_acct_open_bk_name,chr(10),''),chr(13),'') as cntrpty_acct_open_bk_name
      ,replace(replace(cntrpty_acct_prov_cd,chr(10),''),chr(13),'') as cntrpty_acct_prov_cd
      ,replace(replace(cntrpty_acct_city_cd,chr(10),''),chr(13),'') as cntrpty_acct_city_cd
      ,replace(replace(cntrpty_acct_brch_num,chr(10),''),chr(13),'') as cntrpty_acct_brch_num
      ,replace(replace(cntrpty_acct_brch_name,chr(10),''),chr(13),'') as cntrpty_acct_brch_name
      ,replace(replace(cntrpty_acct_clr_bnk_num,chr(10),''),chr(13),'') as cntrpty_acct_clr_bnk_num
      ,replace(replace(cntrpty_ceph_num,chr(10),''),chr(13),'') as cntrpty_ceph_num
      ,plan_exec_cnt
      ,exec_cnt
      ,succ_cnt
      ,succ_amt
      ,fail_cnt
      ,fail_amt
      ,non_exec_cnt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_agt_e_chn_tim_plan 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_e_chn_tim_plan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes