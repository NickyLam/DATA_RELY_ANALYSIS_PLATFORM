: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_cmm_fx_ib_lend_a
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_cmm_fx_ib_lend.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,bus_id
,dept_id
,entry_org_id
,tran_acct_b_id
,cust_id
,cntpty_id
,cntpty_name
,portf_id
,portf_name
,portf_class_name
,inv_port_status_cd
,subj_id
,tran_aim_cd
,tran_dir_cd
,tran_mode_cd
,clear_way_cd
,ib_lend_type_cd
,clear_org_cd
,input_dt
,tran_dt
,value_dt
,exp_dt
,tenor
,int_rat_adj_way_cd
,int_accr_base_cd
,int_rat_float_dir_cd
,int_rat_float_point
,int_rat_tenor_cd
,exec_int_rat
,curr_cd
,tran_amt
,exp_amt
,usd_tran_amt
,acru_int
,currt_bal
,td_acru_int
,currt_acru_int
,pay_int_ped_cd
,fir_pay_int_dt
,pay_stub_proc_way_cd
,bag_status_cd
,tran_src_cd
,tran_site_cd
,bag_id
,tran_id from idl.icrm_cmm_fx_ib_lend where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_cmm_fx_ib_lend.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes