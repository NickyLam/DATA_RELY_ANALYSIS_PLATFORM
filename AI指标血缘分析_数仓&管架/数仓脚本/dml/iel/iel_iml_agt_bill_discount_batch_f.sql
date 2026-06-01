: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_discount_batch_f
CreateDate: 20230804
FileName:   ${iel_data_path}/agt_bill_discount_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,appl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,bus_dt
,replace(replace(t1.quot_bill_id,chr(13),''),chr(10),'') as quot_bill_id
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.sys_in_flg,chr(13),''),chr(10),'') as sys_in_flg
,replace(replace(t1.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_belong_bank_no,chr(13),''),chr(10),'') as cust_belong_bank_no
,replace(replace(t1.cust_belong_org_id,chr(13),''),chr(10),'') as cust_belong_org_id
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,bill_cnt
,bill_tot
,repo_amt
,hold_tenor
,replace(replace(t1.part_bag_option_flg,chr(13),''),chr(10),'') as part_bag_option_flg
,quot_valid_tm
,replace(replace(t1.clear_speed_cd,chr(13),''),chr(10),'') as clear_speed_cd
,replace(replace(t1.clear_type_cd,chr(13),''),chr(10),'') as clear_type_cd
,latest_stl_tm
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,stl_amt
,exp_stl_amt
,stl_dt
,exp_stl_dt
,int_rat
,exp_int_rat
,int_paybl
,exp_int_paybl
,yld_rat
,replace(replace(t1.select_type_cd,chr(13),''),chr(10),'') as select_type_cd
,replace(replace(t1.bill_pkg_id,chr(13),''),chr(10),'') as bill_pkg_id
,replace(replace(t1.crdt_check_status_cd,chr(13),''),chr(10),'') as crdt_check_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.msg_status_cd,chr(13),''),chr(10),'') as msg_status_cd
,replace(replace(t1.clear_status_cd,chr(13),''),chr(10),'') as clear_status_cd
,final_modif_tm
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.modif_flg,chr(13),''),chr(10),'') as modif_flg
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,create_dt
,update_dt
,replace(replace(t1.send_msg_flg,chr(13),''),chr(10),'') as send_msg_flg
,replace(replace(t1.remark_1,chr(13),''),chr(10),'') as remark_1

from ${iml_schema}.agt_bill_discount_batch t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_discount_batch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
