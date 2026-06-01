: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_dc_precontract_info_f
CreateDate: 20230202
FileName:   ${iel_data_path}/ncbs_rb_dc_precontract_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_name,chr(13),''),chr(10),'') as client_name
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.document_id,chr(13),''),chr(10),'') as document_id
,replace(replace(t1.document_type,chr(13),''),chr(10),'') as document_type
,replace(replace(t1.int_type,chr(13),''),chr(10),'') as int_type
,internal_key
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.int_calc_type,chr(13),''),chr(10),'') as int_calc_type
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,replace(replace(t1.precontract_no,chr(13),''),chr(10),'') as precontract_no
,replace(replace(t1.precontract_status,chr(13),''),chr(10),'') as precontract_status
,replace(replace(t1.precontract_stype,chr(13),''),chr(10),'') as precontract_stype
,replace(replace(t1.res_seq_no,chr(13),''),chr(10),'') as res_seq_no
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,replace(replace(t1.stage_code,chr(13),''),chr(10),'') as stage_code
,replace(replace(t1.stage_prod_class,chr(13),''),chr(10),'') as stage_prod_class
,delete_date
,issue_end_date
,issue_start_date
,open_date
,precontract_date
,precontract_open_date
,print_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.iss_country,chr(13),''),chr(10),'') as iss_country
,actual_rate
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.ch_client_name,chr(13),''),chr(10),'') as ch_client_name
,replace(replace(t1.del_auth_user_id,chr(13),''),chr(10),'') as del_auth_user_id
,replace(replace(t1.del_reason,chr(13),''),chr(10),'') as del_reason
,replace(replace(t1.del_user_id,chr(13),''),chr(10),'') as del_user_id
,replace(replace(t1.failure_reason,chr(13),''),chr(10),'') as failure_reason
,float_rate
,issue_amt
,precontract_amt
,replace(replace(t1.precontract_amt_branch,chr(13),''),chr(10),'') as precontract_amt_branch
,replace(replace(t1.precontract_branch,chr(13),''),chr(10),'') as precontract_branch
,replace(replace(t1.precontract_ccy,chr(13),''),chr(10),'') as precontract_ccy
,replace(replace(t1.print_user_id,chr(13),''),chr(10),'') as print_user_id
,real_rate
,replace(replace(t1.comb_prod_no,chr(13),''),chr(10),'') as comb_prod_no

from ${iol_schema}.ncbs_rb_dc_precontract_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_dc_precontract_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
