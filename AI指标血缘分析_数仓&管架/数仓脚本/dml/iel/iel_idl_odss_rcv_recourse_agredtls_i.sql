: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_rcv_recourse_agredtls_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_rcv_recourse_agredtls_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,draft_id
,isse_curcd
,isse_amt
,apply_date
,rcrs_curcd
,rcrs_amt
,rcrs_role
,rcrs_name
,rcrs_cmonid
,rcrs_actno
,rcrs_ubank
,rcrs_agcy_ubank
,status
,endst_date
,sig_mk
,cm_status
,cm_err_procd
,swt_biz_id
,last_upd_oper_id
,last_upd_time
,req_remark
,rcv_remark
,cancel_date
,ecds_prc_msg
,rcv_prxy_sgntr
,recourse_id
from ${idl_schema}.odss_rcv_recourse_agredtls
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_rcv_recourse_agredtls_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes