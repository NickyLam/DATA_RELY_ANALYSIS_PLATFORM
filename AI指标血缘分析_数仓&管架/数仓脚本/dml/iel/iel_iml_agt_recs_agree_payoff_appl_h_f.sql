: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_recs_agree_payoff_appl_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_recs_agree_payoff_appl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt    
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.bill_curr_cd,chr(13),''),chr(10),'') as bill_curr_cd
,t1.bill_amt as bill_amt
,t1.agree_payoff_dt as agree_payoff_dt
,replace(replace(t1.agree_payoff_curr_cd,chr(13),''),chr(10),'') as agree_payoff_curr_cd
,t1.agree_payoff_amt as agree_payoff_amt
,replace(replace(t1.agree_payoff_ps_cate_cd,chr(13),''),chr(10),'') as agree_payoff_ps_cate_cd
,replace(replace(t1.agree_payoff_ps_name,chr(13),''),chr(10),'') as agree_payoff_ps_name
,replace(replace(t1.agree_payoff_ps_orgnz_cd,chr(13),''),chr(10),'') as agree_payoff_ps_orgnz_cd
,replace(replace(t1.agree_payoff_ps_acct_id,chr(13),''),chr(10),'') as agree_payoff_ps_acct_id
,replace(replace(t1.agree_payoff_ps_open_bank_no,chr(13),''),chr(10),'') as agree_payoff_ps_open_bank_no
,replace(replace(t1.agree_payoff_ps_udtake_bk_bank_no,chr(13),''),chr(10),'') as agree_payoff_ps_udtake_bk_bank_no
,t1.recv_dt as recv_dt
,replace(replace(t1.recv_opinion_type_cd,chr(13),''),chr(10),'') as recv_opinion_type_cd
,replace(replace(t1.recs_agree_payoff_status_cd,chr(13),''),chr(10),'') as recs_agree_payoff_status_cd
,t1.revo_dt as revo_dt
,replace(replace(t1.send_out_recs_rgst_b_id,chr(13),''),chr(10),'') as send_out_recs_rgst_b_id
,replace(replace(t1.final_modif_teller_id,chr(13),''),chr(10),'') as final_modif_teller_id
,t1.final_modif_teller_tm as final_modif_teller_tm
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,t1.entry_dt as entry_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.agt_recs_agree_payoff_appl_h t1 
  where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt >  to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_recs_agree_payoff_appl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes