: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_bookkeeping_obj_acctg_f
CreateDate: 20221105
FileName:   ${iel_data_path}/ibms_ttrd_bookkeeping_obj_acctg.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.tsk_id,chr(13),''),chr(10),'') as tsk_id
    ,replace(replace(t.beg_date,chr(13),''),chr(10),'') as beg_date
    ,replace(replace(t.end_date,chr(13),''),chr(10),'') as end_date
    ,replace(replace(t.subj_org_id,chr(13),''),chr(10),'') as subj_org_id
    ,replace(replace(t.subj_code,chr(13),''),chr(10),'') as subj_code
    ,replace(replace(t.subj_sub_code,chr(13),''),chr(10),'') as subj_sub_code
    ,replace(replace(t.inner_acct_sn,chr(13),''),chr(10),'') as inner_acct_sn
    ,replace(replace(t.core_acct_code,chr(13),''),chr(10),'') as core_acct_code
    ,replace(replace(t.currency,chr(13),''),chr(10),'') as currency
    ,t.debit_value as debit_value
    ,t.credit_value as credit_value
    ,t.pay_value as pay_value
    ,t.receive_value as receive_value
    ,replace(replace(t.secu_acct_id,chr(13),''),chr(10),'') as secu_acct_id
    ,replace(replace(t.cash_acct_id,chr(13),''),chr(10),'') as cash_acct_id
    ,replace(replace(t.update_time,chr(13),''),chr(10),'') as update_time
    ,replace(replace(t.core_acct_name,chr(13),''),chr(10),'') as core_acct_name
    ,replace(replace(t.t_currency,chr(13),''),chr(10),'') as t_currency
    ,t.t_credit_value as t_credit_value
    ,t.t_debit_value as t_debit_value
    ,replace(replace(t.acctg_obj_id,chr(13),''),chr(10),'') as acctg_obj_id
    ,replace(replace(t.ext_i_code,chr(13),''),chr(10),'') as ext_i_code
    ,replace(replace(t.ext_a_type,chr(13),''),chr(10),'') as ext_a_type
    ,replace(replace(t.ext_m_type,chr(13),''),chr(10),'') as ext_m_type
    ,replace(replace(t.ext_dim1,chr(13),''),chr(10),'') as ext_dim1
    ,replace(replace(t.ext_dim2,chr(13),''),chr(10),'') as ext_dim2
    ,replace(replace(t.ext_dim3,chr(13),''),chr(10),'') as ext_dim3
    ,replace(replace(t.ext_dim4,chr(13),''),chr(10),'') as ext_dim4
    ,replace(replace(t.ext_dim5,chr(13),''),chr(10),'') as ext_dim5
    ,replace(replace(t.ext_dim6,chr(13),''),chr(10),'') as ext_dim6
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ibms_ttrd_bookkeeping_obj_acctg t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_bookkeeping_obj_acctg.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes