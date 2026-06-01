: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ibms_ttrd_institution_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ibms_ttrd_institution.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 t1.i_id as i_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.i_name,chr(13),''),chr(10),'') as i_name
,replace(replace(t1.i_fullname,chr(13),''),chr(10),'') as i_fullname
,replace(replace(t1.i_alias,chr(13),''),chr(10),'') as i_alias
,replace(replace(t1.py_code,chr(13),''),chr(10),'') as py_code
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,t1.t_code as t_code
,t1.p_type as p_type
,replace(replace(t1.online_date,chr(13),''),chr(10),'') as online_date
,replace(replace(t1.i_business_license,chr(13),''),chr(10),'') as i_business_license
,replace(replace(t1.i_lr_inst_code,chr(13),''),chr(10),'') as i_lr_inst_code
,replace(replace(t1.i_financial_license,chr(13),''),chr(10),'') as i_financial_license
,replace(replace(t1.cnaps_code,chr(13),''),chr(10),'') as cnaps_code
,replace(replace(t1.swift_code,chr(13),''),chr(10),'') as swift_code
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t1.update_date,chr(13),''),chr(10),'') as update_date
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.belong_to_area,chr(13),''),chr(10),'') as belong_to_area
,t1.pipe_id as pipe_id
,replace(replace(t1.imp_date,chr(13),''),chr(10),'') as imp_date
,replace(replace(t1.core_sys_customer_code,chr(13),''),chr(10),'') as core_sys_customer_code
,replace(replace(t1.t_path,chr(13),''),chr(10),'') as t_path
,replace(replace(t1.i_level,chr(13),''),chr(10),'') as i_level
,t1.edit_iid as edit_iid
,replace(replace(t1.edit_iname,chr(13),''),chr(10),'') as edit_iname
,replace(replace(t1.issuer_code,chr(13),''),chr(10),'') as issuer_code
,replace(replace(t1.cfets_member_id,chr(13),''),chr(10),'') as cfets_member_id
,replace(replace(t1.inst_class,chr(13),''),chr(10),'') as inst_class
,replace(replace(t1.member_id,chr(13),''),chr(10),'') as member_id
,replace(replace(t1.is_market_maker,chr(13),''),chr(10),'') as is_market_maker
,replace(replace(t1.rev_state,chr(13),''),chr(10),'') as rev_state
,replace(replace(t1.en_name,chr(13),''),chr(10),'') as en_name
,replace(replace(t1.en_fullname,chr(13),''),chr(10),'') as en_fullname
,replace(replace(t1.cfets_org_code,chr(13),''),chr(10),'') as cfets_org_code
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.acctg_i_id,chr(13),''),chr(10),'') as acctg_i_id
,replace(replace(t1.is_spv,chr(13),''),chr(10),'') as is_spv
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.legal_representative,chr(13),''),chr(10),'') as legal_representative
,replace(replace(t1.is_ticketinfo,chr(13),''),chr(10),'') as is_ticketinfo
,replace(replace(t1.main_protocol_code,chr(13),''),chr(10),'') as main_protocol_code
 from iol.ibms_ttrd_institution T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ibms_ttrd_institution.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes