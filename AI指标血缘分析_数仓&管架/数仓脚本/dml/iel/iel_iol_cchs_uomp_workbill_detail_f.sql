: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cchs_uomp_workbill_detail_f
CreateDate: 20240822
FileName:   ${iel_data_path}/cchs_uomp_workbill_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.workbill_no,chr(13),''),chr(10),'') as workbill_no
,replace(replace(t1.workbill_type,chr(13),''),chr(10),'') as workbill_type
,replace(replace(t1.workbill_sub_type,chr(13),''),chr(10),'') as workbill_sub_type
,replace(replace(t1.deal_node_code,chr(13),''),chr(10),'') as deal_node_code
,replace(replace(t1.next_node_code,chr(13),''),chr(10),'') as next_node_code
,replace(replace(t1.prev_node_code,chr(13),''),chr(10),'') as prev_node_code
,replace(replace(t1.prev_org_code,chr(13),''),chr(10),'') as prev_org_code
,replace(replace(t1.prev_emp_code,chr(13),''),chr(10),'') as prev_emp_code
,replace(replace(t1.deal_org_code,chr(13),''),chr(10),'') as deal_org_code
,replace(replace(t1.deal_emp_code,chr(13),''),chr(10),'') as deal_emp_code
,replace(replace(t1.deal_content,chr(13),''),chr(10),'') as deal_content
,replace(replace(t1.reason,chr(13),''),chr(10),'') as reason
,deal_date
,last_deal_date
,replace(replace(t1.is_late_flag,chr(13),''),chr(10),'') as is_late_flag
,replace(replace(t1.prev_emp_name,chr(13),''),chr(10),'') as prev_emp_name
,replace(replace(t1.deal_emp_name,chr(13),''),chr(10),'') as deal_emp_name
,replace(replace(t1.next_org_code,chr(13),''),chr(10),'') as next_org_code
,accept_date
,replace(replace(t1.deal_node_name,chr(13),''),chr(10),'') as deal_node_name
,replace(replace(t1.workbill_status,chr(13),''),chr(10),'') as workbill_status
,replace(replace(t1.deal_org_name,chr(13),''),chr(10),'') as deal_org_name
,init_date
,replace(replace(t1.complain,chr(13),''),chr(10),'') as complain

from ${iol_schema}.cchs_uomp_workbill_detail t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cchs_uomp_workbill_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
