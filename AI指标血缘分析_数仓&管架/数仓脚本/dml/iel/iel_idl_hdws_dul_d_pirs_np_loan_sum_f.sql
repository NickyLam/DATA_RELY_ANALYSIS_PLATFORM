: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pirs_np_loan_sum_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pirs_np_loan_sum.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_char(etl_dt,'YYYY-MM-DD') as etl_dt
      ,replace(replace(org_id,chr(10),''),chr(13),'') as org_id
      ,replace(replace(biz_typ_cd,chr(10),''),chr(13),'') as biz_typ_cd
      ,biz_amt
      ,biz_bal
      ,write_off_amt
      ,replace(replace(pay_term,chr(10),''),chr(13),'') as pay_term
      ,replace(replace(par_amt,chr(10),''),chr(13),'') as par_amt
      ,replace(replace(pty_blng_indu_cd,chr(10),''),chr(13),'') as pty_blng_indu_cd 
from idl.hdws_dul_d_pirs_np_loan_sum 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pirs_np_loan_sum.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes