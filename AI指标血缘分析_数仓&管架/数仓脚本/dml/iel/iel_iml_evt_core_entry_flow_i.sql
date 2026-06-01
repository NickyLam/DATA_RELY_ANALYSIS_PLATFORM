: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_core_entry_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_core_entry_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.tran_id,chr(13),''),chr(10),'') as tran_id
    ,t.tran_dt as tran_dt
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,replace(replace(t.entry_cancel_flg,chr(13),''),chr(10),'') as entry_cancel_flg
    ,replace(replace(t.entry_flow_num,chr(13),''),chr(10),'') as entry_flow_num
    ,replace(replace(t.hxp_tran_flg,chr(13),''),chr(10),'') as hxp_tran_flg
    ,replace(replace(t.msg_send_status_cd,chr(13),''),chr(10),'') as msg_send_status_cd
    ,replace(replace(t.err_cd,chr(13),''),chr(10),'') as err_cd
    ,replace(replace(t.err_rs,chr(13),''),chr(10),'') as err_rs
    ,replace(replace(t.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
    ,replace(replace(t.buy_dtl_id,chr(13),''),chr(10),'') as buy_dtl_id
    ,replace(replace(t.bill_id,chr(13),''),chr(10),'') as bill_id
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
    ,replace(replace(t.entry_way_cd,chr(13),''),chr(10),'') as entry_way_cd
    ,replace(replace(t.final_modif_operr_id,chr(13),''),chr(10),'') as final_modif_operr_id
    ,t.final_modif_tm as final_modif_tm
    ,replace(replace(t.bill_uniq_ind_no,chr(13),''),chr(10),'') as bill_uniq_ind_no
    ,replace(replace(t.forgn_sys_bill_uniq_ind_no,chr(13),''),chr(10),'') as forgn_sys_bill_uniq_ind_no
    ,replace(replace(t.entry_step_seq_num,chr(13),''),chr(10),'') as entry_step_seq_num
    ,replace(replace(t.sugst_pay_appl_flow_num,chr(13),''),chr(10),'') as sugst_pay_appl_flow_num
from ${iml_schema}.evt_core_entry_flow t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_core_entry_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes