: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ibms_ttrd_institution_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ibms_ttrd_institution.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.i_id
,t1.org_id
,t1.i_name
,t1.i_fullname
,t1.i_alias
,t1.py_code
,t1.status
,t1.t_code
,t1.p_type
,t1.online_date
,t1.i_business_license
,t1.i_lr_inst_code
,t1.i_financial_license
,t1.cnaps_code
,t1.swift_code
,t1.update_user
,t1.update_date
,t1.update_time
,t1.belong_to_area
,t1.pipe_id
,t1.imp_date
,t1.core_sys_customer_code
,t1.t_path
,t1.i_level
,t1.edit_iid
,t1.edit_iname
,t1.issuer_code
,t1.cfets_member_id
,t1.inst_class
,t1.member_id
,t1.is_market_maker
,t1.rev_state
,t1.en_name
,t1.en_fullname
,t1.cfets_org_code
,t1.create_user
,t1.acctg_i_id
,t1.is_spv
,t1.address
,t1.legal_representative
,t1.is_ticketinfo
,t1.main_protocol_code
,t1.start_dt
,t1.end_dt
,t1.id_mark
,t1.etl_timestamp
,t1.rwa_code
,t1.rwa_name
,t1.spv_manager
from ${idl_schema}.hdws_ibms_ttrd_institution t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ibms_ttrd_institution.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes