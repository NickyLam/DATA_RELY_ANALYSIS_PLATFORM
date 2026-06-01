: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_pcls_wf_flow_node_exec_log_f
CreateDate: 20250516
FileName:   ${iel_data_path}/pcls_wf_flow_node_exec_log.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.id as id
,t1.log_no as log_no
,t1.flow_no as flow_no
,t1.node_no as node_no
,t1.biz_no as biz_no
,t1.sub_biz_no as sub_biz_no
,t1.org_no as org_no
,t1.sub_org_no as sub_org_no
,t1.channel_no as channel_no
,t1.product_code as product_code
,t1.biz_type as biz_type
,t1.sub_biz_type as sub_biz_type
,t1.instance_no as instance_no
,t1.exec_status as exec_status
,t1.exec_fail_num as exec_fail_num
,t1.params as params
,t1.date_begin as date_begin
,t1.date_end as date_end
,t1.date_created as date_created
,t1.created_by as created_by
,t1.date_updated as date_updated
,t1.updated_by as updated_by

from ${idl_schema}.pcls_wf_flow_node_exec_log t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pcls_wf_flow_node_exec_log.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
