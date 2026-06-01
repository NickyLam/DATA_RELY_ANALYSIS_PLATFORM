: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_bill_acpt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_bill_acpt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,bus_id
,batch_id
,bill_num
,cust_id
,bill_med_cd
,bill_kind_cd
,appl_dt
,recv_dt
,draw_dt
,exp_dt
,dir_indus_name
,main_guar_way_cd
,drawer_name
,drawer_cate_cd
,drawer_acct_num
,drawer_open_bank_no
,drawer_open_bank_name
,accptor_name
,accptor_acct_num
,accptor_open_bank_no
,accptor_open_bank_name
,recver_cust_id
,recver_name
,recver_acct_num
,recver_open_bank_no
,recver_open_bank_name
,repay_num
,entry_dt
,revo_dt
,bus_flow_num
,margin_ratio
,comm_fee_ratio
,entry_status_cd
,draw_status_cd
,tranbl_flg
,uncond_pay_flg
,curr_cd
,fac_val_amt
,payoff_flg
,lmt_ocup_amt
,lmt_ocup_status_cd
,comm_fee
,todos
,acpt_fee
,mgmt_fee
,accptor_crdt_level_cd
,accptor_rating_exp_dt
,issue_org_id
,enter_acct_org_id
,cust_mgr_id
,dept_id
,operr_id
,group_open_flg
,group_name
,group_id
,group_open_drawer_name
,group_open_drawer_cust_no
,job_cd from idl.aml_cmm_bill_acpt_info where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_bill_acpt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes