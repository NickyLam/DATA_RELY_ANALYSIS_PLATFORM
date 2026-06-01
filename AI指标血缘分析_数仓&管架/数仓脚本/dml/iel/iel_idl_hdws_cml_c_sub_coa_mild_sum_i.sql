: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cml_c_sub_coa_mild_sum_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cml_c_sub_coa_mild_sum.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.data_range,chr(13),''),chr(10),'') as data_range
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.accting_coa_id,chr(13),''),chr(10),'') as accting_coa_id
,replace(replace(t1.carr_ind_cd,chr(13),''),chr(10),'') as carr_ind_cd
,replace(replace(t1.sum_ind,chr(13),''),chr(10),'') as sum_ind
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.term_debit_bal as term_debit_bal
,t1.term_cr_bal as term_cr_bal
,t1.net_bal as net_bal
,t1.term_debit_amt as term_debit_amt
,t1.term_cr_amt as term_cr_amt
,t1.last_debit_bal as last_debit_bal
,t1.last_cr_bal as last_cr_bal
,t1.last_me_debit_bal as last_me_debit_bal
,t1.last_me_cr_bal as last_me_cr_bal
,t1.last_end_of_qtr_debit_bal as last_end_of_qtr_debit_bal
,t1.last_end_of_qtr_cr_bal as last_end_of_qtr_cr_bal
,t1.last_half_ye_debit_bal as last_half_ye_debit_bal
,t1.last_half_ye_cr_bal as last_half_ye_cr_bal
,t1.last_eoy_debit_bal as last_eoy_debit_bal
,t1.last_eoy_cr_bal as last_eoy_cr_bal
,t1.term_addup_debit_amt as term_addup_debit_amt
,t1.term_addup_cr_amt as term_addup_cr_amt
from ${idl_schema}.hdws_cml_c_sub_coa_mild_sum t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cml_c_sub_coa_mild_sum.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes