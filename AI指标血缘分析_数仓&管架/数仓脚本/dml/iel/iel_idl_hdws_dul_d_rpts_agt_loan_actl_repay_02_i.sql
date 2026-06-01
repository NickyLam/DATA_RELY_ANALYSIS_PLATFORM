: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_loan_actl_repay_02_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_loan_actl_repay_02.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(repay_seq_num,chr(10),''),chr(13),'') as repay_seq_num
      ,replace(replace(loan_acct_id,chr(10),''),chr(13),'') as loan_acct_id
      ,etl_dt
      ,replace(replace(blng_pty_id,chr(10),''),chr(13),'') as blng_pty_id
      ,repay_dt
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,curr_repay_prcp
      ,curr_repay_int
      ,curr_repay_pnlt
      ,curr_repay_compd_int
      ,curr_repay_cost
      ,curr_term
      ,curr_bal
      ,replace(replace(adv_repay_flg,chr(10),''),chr(13),'') as adv_repay_flg
      ,replace(replace(ovdue_repay_flg,chr(10),''),chr(13),'') as ovdue_repay_flg
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,replace(replace(repay_acct_id,chr(10),''),chr(13),'') as repay_acct_id
      ,replace(replace(comp_repay_flg,chr(10),''),chr(13),'') as comp_repay_flg
      ,replace(replace(repay_chn_cd,chr(10),''),chr(13),'') as repay_chn_cd
      ,non_enter_acct_int 
from idl.hdws_dul_d_rpts_agt_loan_actl_repay_02 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_loan_actl_repay_02.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes