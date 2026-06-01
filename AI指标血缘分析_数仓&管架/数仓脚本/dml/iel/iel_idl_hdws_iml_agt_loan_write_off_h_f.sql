: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_loan_write_off_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_loan_write_off_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,'0' as del_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,t1.write_off_dt as write_off_dt
,t1.actl_write_off_loan_prcp as actl_write_off_loan_prcp
,t1.actl_write_off_on_int as actl_write_off_on_int
,t1.actl_write_off_off_int as actl_write_off_off_int
,t1.write_off_retra_prcp as write_off_retra_prcp
,t1.write_off_retra_on_int as write_off_retra_on_int
,t1.write_off_retra_off_int as write_off_retra_off_int
,t1.write_off_retra_adv_cost as write_off_retra_adv_cost
,t1.write_off_after_new_stl_int as write_off_after_new_stl_int
,t1.retra_write_off_after_int as retra_write_off_after_int
,t1.write_off_retra_cnt as write_off_retra_cnt
,replace(replace(t1.retra_flg,chr(13),''),chr(10),'') as retra_flg
,t1.write_off_retra_dt as write_off_retra_dt
,replace(replace(t1.write_off_retra_tell_num,chr(13),''),chr(10),'') as write_off_retra_tell_num
from ${idl_schema}.hdws_iml_agt_loan_write_off t1
where  ((etl_dt = to_date('${batch_date}','yyyymmdd')-1 and data_src_cd = 'LHWD') OR (etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd <> 'LHWD'));" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_loan_write_off_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes