: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_guarante_details_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_guarante_details_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,draft_id
,warn_role
,warn_name
,warn_cmonid
,warn_actno
,warn_ubank
,warn_agcy_ubank
,guar_dt
,guar_btch_nb
,guar_role
,guar_cmonid
,guar_name
,guar_actno
,guar_ubank
,appstatus
,rcv_dt
,rcv_operator_id
,send_dt
,send_operator_id
,account_flag
,account_dt
,account_operator_id
,gura_status
,sig_mk
,cm_status
,cm_err_procd
,swt_biz_id
,misc
,last_upd_oper_id
,last_upd_time
,req_remark
,ecds_prc_msg
,rcv_prxy_sgntr
,cancel_date
,actlog_id
,contract_id,appno
from ${idl_schema}.odss_guarante_details
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_guarante_details_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes