: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_loan_write_off_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_loan_write_off.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,etl_dt
      ,replace(replace(loan_acct_id,chr(10),''),chr(13),'') as loan_acct_id
      ,replace(replace(blng_pty_id,chr(10),''),chr(13),'') as blng_pty_id
      ,write_off_dt
      ,actl_write_off_loan_prcp
      ,actl_write_off_on_int
      ,actl_write_off_off_int
      ,write_off_retra_prcp
      ,write_off_retra_on_int
      ,write_off_retra_off_int
      ,write_off_retra_adv_cost
      ,write_off_after_new_stl_int
      ,retra_write_off_after_int
      ,write_off_retra_cnt
      ,replace(replace(retra_flg,chr(10),''),chr(13),'') as retra_flg
      ,write_off_retra_dt
      ,replace(replace(write_off_retra_tell_num,chr(10),''),chr(13),'') as write_off_retra_tell_num 
from idl.hdws_dul_d_rpts_agt_loan_write_off 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_loan_write_off.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes