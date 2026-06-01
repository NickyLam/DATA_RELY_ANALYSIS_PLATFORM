: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_institution_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_institution_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(i_id,chr(10),''),chr(13),'') as i_id
,replace(replace(org_id,chr(10),''),chr(13),'') as org_id
,replace(replace(i_name,chr(10),''),chr(13),'') as i_name
,replace(replace(i_fullname,chr(10),''),chr(13),'') as i_fullname
,replace(replace(i_alias,chr(10),''),chr(13),'') as i_alias
,replace(replace(py_code,chr(10),''),chr(13),'') as py_code
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(t_code,chr(10),''),chr(13),'') as t_code
,replace(replace(p_type,chr(10),''),chr(13),'') as p_type
,replace(replace(online_date,chr(10),''),chr(13),'') as online_date
,replace(replace(i_business_license,chr(10),''),chr(13),'') as i_business_license
,replace(replace(i_lr_inst_code,chr(10),''),chr(13),'') as i_lr_inst_code
,replace(replace(i_financial_license,chr(10),''),chr(13),'') as i_financial_license
,replace(replace(cnaps_code,chr(10),''),chr(13),'') as cnaps_code
,replace(replace(swift_code,chr(10),''),chr(13),'') as swift_code
,replace(replace(update_user,chr(10),''),chr(13),'') as update_user
,replace(replace(update_date,chr(10),''),chr(13),'') as update_date
,replace(replace(update_time,chr(10),''),chr(13),'') as update_time
,replace(replace(belong_to_area,chr(10),''),chr(13),'') as belong_to_area
,replace(replace(pipe_id,chr(10),''),chr(13),'') as pipe_id
,replace(replace(imp_date,chr(10),''),chr(13),'') as imp_date
,replace(replace(core_sys_customer_code,chr(10),''),chr(13),'') as core_sys_customer_code
,replace(replace(t_path,chr(10),''),chr(13),'') as t_path
,replace(replace(i_level,chr(10),''),chr(13),'') as i_level
,replace(replace(edit_iid,chr(10),''),chr(13),'') as edit_iid
,replace(replace(edit_iname,chr(10),''),chr(13),'') as edit_iname
,replace(replace(issuer_code,chr(10),''),chr(13),'') as issuer_code
,replace(replace(cfets_member_id,chr(10),''),chr(13),'') as cfets_member_id
,replace(replace(inst_class,chr(10),''),chr(13),'') as inst_class
,replace(replace(member_id,chr(10),''),chr(13),'') as member_id
,replace(replace(is_market_maker,chr(10),''),chr(13),'') as is_market_maker
,replace(replace(rev_state,chr(10),''),chr(13),'') as rev_state
,replace(replace(en_name,chr(10),''),chr(13),'') as en_name
,replace(replace(en_fullname,chr(10),''),chr(13),'') as en_fullname
,replace(replace(cfets_org_code,chr(10),''),chr(13),'') as cfets_org_code
,replace(replace(create_user,chr(10),''),chr(13),'') as create_user
,replace(replace(acctg_i_id,chr(10),''),chr(13),'') as acctg_i_id
,replace(replace(is_spv,chr(10),''),chr(13),'') as is_spv
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_institution
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_institution_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes