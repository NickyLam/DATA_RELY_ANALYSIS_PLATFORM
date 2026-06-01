: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_bookkeeping_obj_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_bookkeeping_obj_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(tsk_id,chr(10),''),chr(13),'') as tsk_id
,replace(replace(beg_date,chr(10),''),chr(13),'') as beg_date
,replace(replace(end_date,chr(10),''),chr(13),'') as end_date
,replace(replace(subj_org_id,chr(10),''),chr(13),'') as subj_org_id
,replace(replace(subj_code,chr(10),''),chr(13),'') as subj_code
,replace(replace(subj_sub_code,chr(10),''),chr(13),'') as subj_sub_code
,replace(replace(inner_acct_sn,chr(10),''),chr(13),'') as inner_acct_sn
,replace(replace(core_acct_code,chr(10),''),chr(13),'') as core_acct_code
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(debit_value,chr(10),''),chr(13),'') as debit_value
,replace(replace(credit_value,chr(10),''),chr(13),'') as credit_value
,replace(replace(pay_value,chr(10),''),chr(13),'') as pay_value
,replace(replace(receive_value,chr(10),''),chr(13),'') as receive_value
,replace(replace(secu_acct_id,chr(10),''),chr(13),'') as secu_acct_id
,replace(replace(cash_acct_id,chr(10),''),chr(13),'') as cash_acct_id
,replace(replace(update_time,chr(10),''),chr(13),'') as update_time
,replace(replace(core_acct_name,chr(10),''),chr(13),'') as core_acct_name
,replace(replace(t_currency,chr(10),''),chr(13),'') as t_currency
,replace(replace(t_credit_value,chr(10),''),chr(13),'') as t_credit_value
,replace(replace(t_debit_value,chr(10),''),chr(13),'') as t_debit_value
,replace(replace(ext_i_code,chr(10),''),chr(13),'') as ext_i_code
,replace(replace(ext_a_type,chr(10),''),chr(13),'') as ext_a_type
,replace(replace(ext_m_type,chr(10),''),chr(13),'') as ext_m_type
,replace(replace(ext_dim1,chr(10),''),chr(13),'') as ext_dim1
,replace(replace(ext_dim2,chr(10),''),chr(13),'') as ext_dim2
,replace(replace(ext_dim3,chr(10),''),chr(13),'') as ext_dim3
,replace(replace(ext_dim4,chr(10),''),chr(13),'') as ext_dim4
,replace(replace(ext_dim5,chr(10),''),chr(13),'') as ext_dim5
,replace(replace(ext_dim6,chr(10),''),chr(13),'') as ext_dim6
,etl_dt
,etl_timestamp
from iol.ibms_ttrd_bookkeeping_obj 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_bookkeeping_obj_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes