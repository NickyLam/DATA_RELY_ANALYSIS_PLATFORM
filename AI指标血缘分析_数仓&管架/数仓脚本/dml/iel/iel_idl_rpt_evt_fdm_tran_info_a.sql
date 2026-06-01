: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_evt_fdm_tran_info_a
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_evt_fdm_tran_info.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,src_evt_id
,entry_dt
,rept_tm
,proc_tm
,bus_flow_num
,tran_flow_num
,acct_num
,acct_duty_center_id
,tran_duty_center_id
,curr_cd
,prod_type_id
,tran_cd
,amt_dir_cd
,group_int_cont_id
,chn_cd
,sorc_sys_cd
,amt
,bal
,create_pay_id
,create_inv_id
,err_cd
,revs_flow_num
,revs_status_cd from idl.rpt_evt_fdm_tran_info where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_evt_fdm_tran_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes