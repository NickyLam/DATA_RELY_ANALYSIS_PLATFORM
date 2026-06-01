: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_bookkeeping_obj_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_ttrd_bookkeeping_obj.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tsk_id,chr(13),''),chr(10),'') as tsk_id
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.subj_org_id,chr(13),''),chr(10),'') as subj_org_id
,replace(replace(t1.subj_code,chr(13),''),chr(10),'') as subj_code
,replace(replace(t1.subj_sub_code,chr(13),''),chr(10),'') as subj_sub_code
,replace(replace(t1.inner_acct_sn,chr(13),''),chr(10),'') as inner_acct_sn
,replace(replace(t1.core_acct_code,chr(13),''),chr(10),'') as core_acct_code
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,t1.debit_value as debit_value
,t1.credit_value as credit_value
,t1.pay_value as pay_value
,t1.receive_value as receive_value
,replace(replace(t1.secu_acct_id,chr(13),''),chr(10),'') as secu_acct_id
,replace(replace(t1.cash_acct_id,chr(13),''),chr(10),'') as cash_acct_id
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.core_acct_name,chr(13),''),chr(10),'') as core_acct_name
,replace(replace(t1.t_currency,chr(13),''),chr(10),'') as t_currency
,t1.t_credit_value as t_credit_value
,t1.t_debit_value as t_debit_value
,replace(replace(t1.ext_i_code,chr(13),''),chr(10),'') as ext_i_code
,replace(replace(t1.ext_a_type,chr(13),''),chr(10),'') as ext_a_type
,replace(replace(t1.ext_m_type,chr(13),''),chr(10),'') as ext_m_type
,replace(replace(t1.ext_dim1,chr(13),''),chr(10),'') as ext_dim1
,replace(replace(t1.ext_dim2,chr(13),''),chr(10),'') as ext_dim2
,replace(replace(t1.ext_dim3,chr(13),''),chr(10),'') as ext_dim3
,replace(replace(t1.ext_dim4,chr(13),''),chr(10),'') as ext_dim4
,replace(replace(t1.ext_dim5,chr(13),''),chr(10),'') as ext_dim5
,replace(replace(t1.ext_dim6,chr(13),''),chr(10),'') as ext_dim6

from ${iol_schema}.ibms_ttrd_bookkeeping_obj t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_bookkeeping_obj.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
