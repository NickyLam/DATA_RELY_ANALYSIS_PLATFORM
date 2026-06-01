: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_c_sub_coa_mild_sum_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_c_sub_coa_mild_sum.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(data_range,chr(10),''),chr(13),'') as data_range
      ,replace(replace(org_id,chr(10),''),chr(13),'') as org_id
      ,replace(replace(accting_coa_id,chr(10),''),chr(13),'') as accting_coa_id
      ,replace(replace(carr_ind_cd,chr(10),''),chr(13),'') as carr_ind_cd
      ,replace(replace(sum_ind,chr(10),''),chr(13),'') as sum_ind
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,term_debit_bal
      ,term_cr_bal
      ,net_bal
      ,term_debit_amt
      ,term_cr_amt
      ,last_debit_bal
      ,last_cr_bal
      ,last_me_debit_bal
      ,last_me_cr_bal
      ,last_end_of_qtr_debit_bal
      ,last_end_of_qtr_cr_bal
      ,last_half_ye_debit_bal
      ,last_half_ye_cr_bal
      ,last_eoy_debit_bal
      ,last_eoy_cr_bal
      ,term_addup_debit_amt
      ,term_addup_cr_amt 
from idl.hdws_dul_d_rpts_c_sub_coa_mild_sum 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_c_sub_coa_mild_sum.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes