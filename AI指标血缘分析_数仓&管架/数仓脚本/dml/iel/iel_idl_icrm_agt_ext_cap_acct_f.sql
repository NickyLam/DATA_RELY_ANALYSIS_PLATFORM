: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_agt_ext_cap_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_agt_ext_cap_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select agt_id
,lp_id
,acct_id
,acct_name
,tran_market_id
,exchg_acct_id
,curr_cd
,open_acct_bank_no
,open_acct_bank_name
,open_acct_dt
,cntpty_id
,cntpty_name
,intnal_cap_acct_num
,cap_acct_type_cd
,intnal_acct_num
,entry_org_id
,intnal_acct_name
,src_pay_int_ped_cd
,pay_int_ped_corp_cd
,pay_int_ped_freq
,int_rat_def_id
,cap_type_cd
,pay_mon
,pay_days
,int_rat
,clos_acct_dt
,prod_type_id
,prod_cls_name
,subj_id
,swift_cd
,belong_org_id
,etl_dt
,job_cd from idl.icrm_agt_ext_cap_acct where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_agt_ext_cap_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes