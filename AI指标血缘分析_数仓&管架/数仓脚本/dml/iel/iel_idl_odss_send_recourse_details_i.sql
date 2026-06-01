: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_send_recourse_details_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_send_recourse_details_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,draft_id
,isse_curcd
,isse_amt
,rcrs_tp
,apply_date
,req_curcd
,req_amt
,rcrs_rsncd
,rcrsr_role
,rcrsr_cmonid
,rcrsr_name
,rcrsr_actno
,rcrsr_ubank
,rcrsr_agcy_ubank
,rcvgprsn_cmon_id
,rcvgprsn_name
,rcvgprsn_actno
,rcvgprsn_ubank
,rcvgprsn_agcy_ubank
,recourse_status
,endst_date
,cancel_date
,cancel_opid
,cm_status
,cm_err_procd
,ecds_prc_msg
,swt_biz_id
,rcrs_rsn
,last_upd_oper_id
,last_upd_time
,agredtls_id
from ${idl_schema}.odss_send_recourse_details
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_send_recourse_details_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes