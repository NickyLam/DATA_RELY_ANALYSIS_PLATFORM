: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_bill_acpt_info_f
CreateDate: 20241021
FileName:   ${iel_data_path}/cmm_bill_acpt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.bill_kind_cd,chr(13),''),chr(10),'') as bill_kind_cd
,appl_dt
,recv_dt
,draw_dt
,exp_dt
,replace(replace(t1.dir_indus_name,chr(13),''),chr(10),'') as dir_indus_name
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
,replace(replace(t1.drawer_name,chr(13),''),chr(10),'') as drawer_name
,replace(replace(t1.drawer_cate_cd,chr(13),''),chr(10),'') as drawer_cate_cd
,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'') as drawer_acct_num
,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'') as drawer_open_bank_no
,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'') as drawer_open_bank_name
,replace(replace(t1.accptor_name,chr(13),''),chr(10),'') as accptor_name
,replace(replace(t1.accptor_acct_num,chr(13),''),chr(10),'') as accptor_acct_num
,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'') as accptor_open_bank_no
,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'') as accptor_open_bank_name
,replace(replace(t1.recver_cust_id,chr(13),''),chr(10),'') as recver_cust_id
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.repay_num,chr(13),''),chr(10),'') as repay_num
,entry_dt
,revo_dt
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,margin_ratio
,comm_fee_ratio
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.draw_status_cd,chr(13),''),chr(10),'') as draw_status_cd
,replace(replace(t1.tranbl_flg,chr(13),''),chr(10),'') as tranbl_flg
,replace(replace(t1.uncond_pay_flg,chr(13),''),chr(10),'') as uncond_pay_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,fac_val_amt
,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'') as payoff_flg
,lmt_ocup_amt
,replace(replace(t1.lmt_ocup_status_cd,chr(13),''),chr(10),'') as lmt_ocup_status_cd
,comm_fee
,todos
,acpt_fee
,mgmt_fee
,replace(replace(t1.accptor_crdt_level_cd,chr(13),''),chr(10),'') as accptor_crdt_level_cd
,accptor_rating_exp_dt
,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'') as issue_org_id
,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.group_open_flg,chr(13),''),chr(10),'') as group_open_flg
,replace(replace(t1.group_name,chr(13),''),chr(10),'') as group_name
,replace(replace(t1.group_id,chr(13),''),chr(10),'') as group_id
,replace(replace(t1.group_open_drawer_name,chr(13),''),chr(10),'') as group_open_drawer_name
,replace(replace(t1.group_open_drawer_cust_no,chr(13),''),chr(10),'') as group_open_drawer_cust_no
,replace(replace(t1.bill_entry_id,chr(13),''),chr(10),'') as bill_entry_id
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,replace(replace(t1.rela_party_que_rest_cd,chr(13),''),chr(10),'') as rela_party_que_rest_cd
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.bill_acpt_status_cd,chr(13),''),chr(10),'') as bill_acpt_status_cd
,replace(replace(t1.open_type_cd,chr(13),''),chr(10),'') as open_type_cd
,open_amt
,replace(replace(t1.acpt_agt_batch_id,chr(13),''),chr(10),'') as acpt_agt_batch_id

from ${icl_schema}.cmm_bill_acpt_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_bill_acpt_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
