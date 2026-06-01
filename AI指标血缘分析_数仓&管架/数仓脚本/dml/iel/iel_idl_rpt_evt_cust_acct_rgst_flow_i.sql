: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_evt_cust_acct_rgst_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_evt_cust_acct_rgst_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select evt_id
,lp_id
,midgrod_tran_code
,msg_type
,tran_dt
,tran_flow_num
,pbc_flow_num
,tran_tm
,origi_bank_no
,recv_bank_no
,acct_rgst_bus_type_cd
,cert_type_cd
,cert_no
,acct_attr_cd
,onl_bank_sys_open_bank_no
,acct_num
,acct_name
,mask_acct_name
,acct_open_bank_no
,acct_clear_bank_no
,mobile_no
,remark
,wrtoff_bank_no
,new_acct_num
,new_acct_rgst_attr_cd
,new_acct_rgst_bank_no
,cont_flg
,bus_status_cd
,bus_refuse_cd
,pbc_proc_dt
,err_info
,rgst_status_cd
,chn_id
,chn_flow_num
,st_msg_ser_num
,init_pbc_flow_num
,etl_dt
,job_cd from idl.rpt_evt_cust_acct_rgst_flow where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_evt_cust_acct_rgst_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes