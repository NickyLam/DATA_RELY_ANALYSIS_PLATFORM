: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_hx_counterparty_registry_f
CreateDate: 20240131
FileName:   ${iel_data_path}/ibms_ttrd_hx_counterparty_registry.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,registry_id
,replace(replace(t1.entry_id,chr(13),''),chr(10),'') as entry_id
,replace(replace(t1.entry_date,chr(13),''),chr(10),'') as entry_date
,inst_id
,replace(replace(t1.global_flow_no,chr(13),''),chr(10),'') as global_flow_no
,replace(replace(t1.flow_no,chr(13),''),chr(10),'') as flow_no
,replace(replace(t1.flow_inner_sn,chr(13),''),chr(10),'') as flow_inner_sn
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.p_type,chr(13),''),chr(10),'') as p_type
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,replace(replace(t1.i_name,chr(13),''),chr(10),'') as i_name
,replace(replace(t1.subj_code,chr(13),''),chr(10),'') as subj_code
,replace(replace(t1.debit_credit_flag,chr(13),''),chr(10),'') as debit_credit_flag
,replace(replace(t1.red_blue_flag,chr(13),''),chr(10),'') as red_blue_flag
,value
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.prod_code,chr(13),''),chr(10),'') as prod_code
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.party_acct_code,chr(13),''),chr(10),'') as party_acct_code
,replace(replace(t1.party_acct_name,chr(13),''),chr(10),'') as party_acct_name
,replace(replace(t1.party_bank_code,chr(13),''),chr(10),'') as party_bank_code
,replace(replace(t1.party_bank_name,chr(13),''),chr(10),'') as party_bank_name
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time

from ${iol_schema}.ibms_ttrd_hx_counterparty_registry t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_hx_counterparty_registry.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
