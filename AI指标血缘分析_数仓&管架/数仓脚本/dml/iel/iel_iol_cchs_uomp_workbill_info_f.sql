: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cchs_uomp_workbill_info_f
CreateDate: 20240822
FileName:   ${iel_data_path}/cchs_uomp_workbill_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.workbill_no,chr(13),''),chr(10),'') as workbill_no
,replace(replace(t1.workbill_type,chr(13),''),chr(10),'') as workbill_type
,replace(replace(t1.workbill_sub_type,chr(13),''),chr(10),'') as workbill_sub_type
,replace(replace(t1.work_sum_no,chr(13),''),chr(10),'') as work_sum_no
,replace(replace(t1.call_no,chr(13),''),chr(10),'') as call_no
,replace(replace(t1.call_type,chr(13),''),chr(10),'') as call_type
,replace(replace(t1.connection_id,chr(13),''),chr(10),'') as connection_id
,replace(replace(t1.creater_code,chr(13),''),chr(10),'') as creater_code
,create_date
,replace(replace(t1.workbill_level,chr(13),''),chr(10),'') as workbill_level
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.workbill_status,chr(13),''),chr(10),'') as workbill_status
,over_time
,replace(replace(t1.over_org_code,chr(13),''),chr(10),'') as over_org_code
,replace(replace(t1.over_code,chr(13),''),chr(10),'') as over_code
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_sex,chr(13),''),chr(10),'') as cust_sex
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.card_type,chr(13),''),chr(10),'') as card_type
,replace(replace(t1.cust_phone,chr(13),''),chr(10),'') as cust_phone
,replace(replace(t1.cust_paper_id,chr(13),''),chr(10),'') as cust_paper_id
,replace(replace(t1.cust_paper_type,chr(13),''),chr(10),'') as cust_paper_type
,replace(replace(t1.cust_email,chr(13),''),chr(10),'') as cust_email
,replace(replace(t1.flow_code,chr(13),''),chr(10),'') as flow_code
,replace(replace(t1.event_type,chr(13),''),chr(10),'') as event_type
,replace(replace(t1.workbill_channel,chr(13),''),chr(10),'') as workbill_channel
,dead_line_date
,replace(replace(t1.over_flag,chr(13),''),chr(10),'') as over_flag
,replace(replace(t1.creater_name,chr(13),''),chr(10),'') as creater_name
,replace(replace(t1.over_name,chr(13),''),chr(10),'') as over_name
,replace(replace(t1.call_name,chr(13),''),chr(10),'') as call_name
,replace(replace(t1.buss_type,chr(13),''),chr(10),'') as buss_type
,replace(replace(t1.buss_sub_type,chr(13),''),chr(10),'') as buss_sub_type
,replace(replace(t1.dev_condition,chr(13),''),chr(10),'') as dev_condition
,replace(replace(t1.device_no,chr(13),''),chr(10),'') as device_no
,replace(replace(t1.card_attach,chr(13),''),chr(10),'') as card_attach
,replace(replace(t1.workbill_content,chr(13),''),chr(10),'') as workbill_content
,replace(replace(t1.re_complain,chr(13),''),chr(10),'') as re_complain
,replace(replace(t1.complain,chr(13),''),chr(10),'') as complain
,replace(replace(t1.templ_code,chr(13),''),chr(10),'') as templ_code
,replace(replace(t1.node_code,chr(13),''),chr(10),'') as node_code
,replace(replace(t1.detail_code,chr(13),''),chr(10),'') as detail_code
,replace(replace(t1.org_code,chr(13),''),chr(10),'') as org_code
,replace(replace(t1.submit_code,chr(13),''),chr(10),'') as submit_code
,replace(replace(t1.submit_name,chr(13),''),chr(10),'') as submit_name
,submit_date
,replace(replace(t1.mistake_sign,chr(13),''),chr(10),'') as mistake_sign
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.satisfied,chr(13),''),chr(10),'') as satisfied
,replace(replace(t1.complaintype_first,chr(13),''),chr(10),'') as complaintype_first
,replace(replace(t1.complaintype_sec,chr(13),''),chr(10),'') as complaintype_sec
,replace(replace(t1.complaintype_third,chr(13),''),chr(10),'') as complaintype_third
,replace(replace(t1.complaintype_first_name,chr(13),''),chr(10),'') as complaintype_first_name
,replace(replace(t1.complaintype_sec_name,chr(13),''),chr(10),'') as complaintype_sec_name
,replace(replace(t1.complaintype_third_name,chr(13),''),chr(10),'') as complaintype_third_name
,replace(replace(t1.complainchannel_first,chr(13),''),chr(10),'') as complainchannel_first
,replace(replace(t1.complainchannel_first_name,chr(13),''),chr(10),'') as complainchannel_first_name
,replace(replace(t1.complainchannel_sec,chr(13),''),chr(10),'') as complainchannel_sec
,replace(replace(t1.complainchannel_sec_name,chr(13),''),chr(10),'') as complainchannel_sec_name
,replace(replace(t1.complainchannel_third,chr(13),''),chr(10),'') as complainchannel_third
,replace(replace(t1.complainchannel_third_name,chr(13),''),chr(10),'') as complainchannel_third_name
,replace(replace(t1.complainreason_first,chr(13),''),chr(10),'') as complainreason_first
,replace(replace(t1.complainreason_first_name,chr(13),''),chr(10),'') as complainreason_first_name
,replace(replace(t1.complainreason_sec,chr(13),''),chr(10),'') as complainreason_sec
,replace(replace(t1.complainreason_sec_name,chr(13),''),chr(10),'') as complainreason_sec_name
,replace(replace(t1.return_visit_date,chr(13),''),chr(10),'') as return_visit_date
,replace(replace(t1.return_visit_content,chr(13),''),chr(10),'') as return_visit_content
,replace(replace(t1.fallback_status,chr(13),''),chr(10),'') as fallback_status
,replace(replace(t1.fallback_date,chr(13),''),chr(10),'') as fallback_date
,replace(replace(t1.fallback_content,chr(13),''),chr(10),'') as fallback_content
,replace(replace(t1.call_sex,chr(13),''),chr(10),'') as call_sex
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.bank_name,chr(13),''),chr(10),'') as bank_name
,replace(replace(t1.survey_handle_unit_first_code,chr(13),''),chr(10),'') as survey_handle_unit_first_code
,replace(replace(t1.survey_handle_unit_first_name,chr(13),''),chr(10),'') as survey_handle_unit_first_name
,replace(replace(t1.survey_handle_unit_sec_code,chr(13),''),chr(10),'') as survey_handle_unit_sec_code
,replace(replace(t1.survey_handle_unit_sec_name,chr(13),''),chr(10),'') as survey_handle_unit_sec_name
,replace(replace(t1.is_need_trans,chr(13),''),chr(10),'') as is_need_trans
,complain_date
,replace(replace(t1.risk_hidden,chr(13),''),chr(10),'') as risk_hidden
,replace(replace(t1.is_supervise_org_trans,chr(13),''),chr(10),'') as is_supervise_org_trans
,replace(replace(t1.supervise_org,chr(13),''),chr(10),'') as supervise_org
,branch_begin_date
,branch_end_date
,replace(replace(t1.workbill_from,chr(13),''),chr(10),'') as workbill_from
,replace(replace(t1.delete_remark,chr(13),''),chr(10),'') as delete_remark
,replace(replace(t1.read_status,chr(13),''),chr(10),'') as read_status
,replace(replace(t1.complain_deal_remark,chr(13),''),chr(10),'') as complain_deal_remark
,replace(replace(t1.is_trans,chr(13),''),chr(10),'') as is_trans
,replace(replace(t1.is_solved,chr(13),''),chr(10),'') as is_solved
,replace(replace(t1.is_upgrade,chr(13),''),chr(10),'') as is_upgrade
,replace(replace(t1.is_skipgrade,chr(13),''),chr(10),'') as is_skipgrade
,replace(replace(t1.extend,chr(13),''),chr(10),'') as extend

from ${iol_schema}.cchs_uomp_workbill_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cchs_uomp_workbill_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
