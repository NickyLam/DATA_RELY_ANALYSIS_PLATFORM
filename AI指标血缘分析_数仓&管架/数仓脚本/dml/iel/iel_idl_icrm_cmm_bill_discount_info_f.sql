: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_cmm_bill_discount_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_cmm_bill_discount_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,bus_id
,batch_id
,bill_id
,subj_id
,int_adj_subj_id
,bill_prod_id
,bill_med_cd
,bill_kind_cd
,draw_dt
,exp_dt
,actl_exp_dt
,appl_dt
,bus_dt
,stl_dt
,repo_dt
,curr_cd
,fac_val_amt
,stl_amt
,repo_amt
,int_amt
,repo_int_amt
,discnt_int_rat
,currt_bal
,int_adj_bal
,td_acru_int
,currt_acru_int
,bus_type_cd
,tran_dir_cd
,cntpty_id
,cntpty_name
,cntpty_bank_no
,cntpty_cate_cd
,cntpty_type_cd
,hxb_acpt_flg
,bill_src_cd
,sys_in_flg
,quot_way_cd
,stl_way_cd
,lock_flg
,hold_days
,defer_days
,valid_flg
,bus_status_cd
,entry_status_cd
,lmt_id
,lmt_status_cd
,cust_mgr_id
,dept_id
,bus_org_id
,acct_instit_id 
,std_prod_id
,bill_num
,cont_id
,ctr_nt_id
,exp_repo_agt_id
,bill_cont_id
,actl_repo_dt
,redem_int_rat
,asset_thd_cls_cd
,discnt_dt
,discnt_ps_unify_soci_crdt_cd_cert
,discnt_ps_name
,bf_cntpty_flg
,bf_cntpty_name
,bf_cntpty_type_cd
from idl.icrm_cmm_bill_discount_info 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_cmm_bill_discount_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes