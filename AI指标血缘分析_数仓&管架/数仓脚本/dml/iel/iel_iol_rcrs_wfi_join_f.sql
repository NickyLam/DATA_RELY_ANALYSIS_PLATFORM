: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_wfi_join_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_wfi_join.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.instanceid,chr(13),''),chr(10),'') as instanceid
    ,replace(replace(t.table_name,chr(13),''),chr(10),'') as table_name
    ,replace(replace(t.pk_col,chr(13),''),chr(10),'') as pk_col
    ,replace(replace(t.pk_value,chr(13),''),chr(10),'') as pk_value
    ,replace(replace(t.wfi_status,chr(13),''),chr(10),'') as wfi_status
    ,replace(replace(t.wfi_operate_time,chr(13),''),chr(10),'') as wfi_operate_time
    ,replace(replace(t.wfi_start_time,chr(13),''),chr(10),'') as wfi_start_time
    ,replace(replace(t.wfi_end_time,chr(13),''),chr(10),'') as wfi_end_time
    ,replace(replace(t.wfi_end_user,chr(13),''),chr(10),'') as wfi_end_user
    ,replace(replace(t.wfi_end_org,chr(13),''),chr(10),'') as wfi_end_org
    ,replace(replace(t.wfsign,chr(13),''),chr(10),'') as wfsign
    ,replace(replace(t.wfi_current_node_id,chr(13),''),chr(10),'') as wfi_current_node_id
    ,replace(replace(t.wfi_app_period,chr(13),''),chr(10),'') as wfi_app_period
    ,replace(replace(t.wfi_pre_node_id,chr(13),''),chr(10),'') as wfi_pre_node_id
    ,replace(replace(t.wfi_next_node_id,chr(13),''),chr(10),'') as wfi_next_node_id
    ,replace(replace(t.wfi_version,chr(13),''),chr(10),'') as wfi_version
    ,replace(replace(t.appl_type,chr(13),''),chr(10),'') as appl_type
    ,replace(replace(t.prevent_list,chr(13),''),chr(10),'') as prevent_list
    ,replace(replace(t.appl_seq,chr(13),''),chr(10),'') as appl_seq
    ,replace(replace(t.prd_name,chr(13),''),chr(10),'') as prd_name
    ,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
    ,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
    ,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
    ,replace(replace(t.cert_code,chr(13),''),chr(10),'') as cert_code
    ,t.amt as amt
    ,t.term as term
    ,t.ruling_ir as ruling_ir
    ,t.reality_ir_y as reality_ir_y
    ,replace(replace(t.cont_no,chr(13),''),chr(10),'') as cont_no
    ,replace(replace(t.bill_no,chr(13),''),chr(10),'') as bill_no
    ,replace(replace(t.input_id,chr(13),''),chr(10),'') as input_id
    ,replace(replace(t.input_br_id,chr(13),''),chr(10),'') as input_br_id
    ,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
    ,replace(replace(t.owner,chr(13),''),chr(10),'') as owner
    ,replace(replace(t.cus_type,chr(13),''),chr(10),'') as cus_type
    ,replace(replace(t.type1,chr(13),''),chr(10),'') as type1
    ,replace(replace(t.wfi_start_user,chr(13),''),chr(10),'') as wfi_start_user
    ,replace(replace(t.app_url,chr(13),''),chr(10),'') as app_url
    ,replace(replace(t.update_url,chr(13),''),chr(10),'') as update_url
    ,replace(replace(t.apply_info_value,chr(13),''),chr(10),'') as apply_info_value
    ,replace(replace(t.wfi_shf_book_id,chr(13),''),chr(10),'') as wfi_shf_book_id
    ,replace(replace(t.biz_page,chr(13),''),chr(10),'') as biz_page
    ,replace(replace(t.wfi_start_arti_org,chr(13),''),chr(10),'') as wfi_start_arti_org
    ,replace(replace(t.wfi_start_node_id,chr(13),''),chr(10),'') as wfi_start_node_id
    ,replace(replace(t.end_app_url,chr(13),''),chr(10),'') as end_app_url
    ,replace(replace(t.scd_chk_flag,chr(13),''),chr(10),'') as scd_chk_flag
    ,replace(replace(t.scd_chk_id,chr(13),''),chr(10),'') as scd_chk_id
    ,replace(replace(t.show_appl_type,chr(13),''),chr(10),'') as show_appl_type
    ,replace(replace(t.no_amt_flag,chr(13),''),chr(10),'') as no_amt_flag
    ,replace(replace(t.transfer_info,chr(13),''),chr(10),'') as transfer_info
    ,t.risk_open_amt as risk_open_amt
    ,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
    ,replace(replace(t.current_scene_id,chr(13),''),chr(10),'') as current_scene_id
    ,t.security_money_amt as security_money_amt
    ,t.assureamt_ratio as assureamt_ratio
    ,replace(replace(t.limit_ind,chr(13),''),chr(10),'') as limit_ind
    ,replace(replace(t.prd_userdf_type,chr(13),''),chr(10),'') as prd_userdf_type
    ,replace(replace(t.lmt_appl_type,chr(13),''),chr(10),'') as lmt_appl_type
from iol.rcrs_wfi_join t
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_wfi_join.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes