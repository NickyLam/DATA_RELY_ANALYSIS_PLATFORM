: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_ln_ac_amt_info_02_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_ln_ac_amt_info_02.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(loan_acct_id,chr(10),''),chr(13),'') as loan_acct_id
      ,etl_dt
      ,loan_total_term
      ,loan_new_term
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,loan_total_bal
      ,loan_bal
      ,day_accr_int
      ,paid_prcp
      ,paid_int
      ,paid_pnlt
      ,paid_compd_int
      ,paid_cost
      ,aggr_rcvable_int_amt
      ,int_on_bs_bal
      ,int_off_bs_bal
      ,on_int
      ,off_int
      ,provn
      ,prev_adj_int_dt
      ,next_adj_int_dt
      ,next_stl_dt
      ,actl_write_off_prcp
      ,actl_write_off_int
      ,rcva_acr_intr
      ,rcva_owe_int
      ,rcva_accr_pnlt
      ,rcva_pnlt
      ,accr_cmpd_intr
      ,rcva_cmpd_intr
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_agt_ln_ac_amt_info_02 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_ln_ac_amt_info_02.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes