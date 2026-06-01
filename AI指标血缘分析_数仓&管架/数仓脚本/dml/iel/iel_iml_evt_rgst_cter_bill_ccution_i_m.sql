: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_rgst_cter_bill_ccution_i_m
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_rgst_cter_bill_ccution_m.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,evt_id
      ,lp_id
      ,rgst_id
      ,agt_id
      ,agt_dtl_id
      ,bill_id
      ,bus_attr_cd
      ,replace(replace(bill_num,chr(13),''),chr(10),'') as bill_num
      ,tran_dir_cd
      ,tran_dt
      ,reqer_type_cd
      ,replace(replace(reqer_name,chr(13),''),chr(10),'') as reqer_name
      ,reqer_soci_crdt_cd
      ,replace(replace(reqer_acct_num,chr(13),''),chr(10),'') as reqer_acct_num
      ,reqer_mem_id
      ,reqer_org_id
      ,replace(replace(reqer_pay_sys_bank_no,chr(13),''),chr(10),'') as reqer_pay_sys_bank_no
      ,recver_type_cd
      ,replace(replace(recver_name,chr(13),''),chr(10),'') as recver_name
      ,recver_soci_crdt_cd
      ,replace(replace(recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
      ,replace(replace(recver_mem_code,chr(13),''),chr(10),'') as recver_mem_code
      ,recver_org_id
      ,replace(replace(recver_pay_sys_bank_no,chr(13),''),chr(10),'') as recver_pay_sys_bank_no
      ,actl_amt
      ,actl_int
      ,int_rat
      ,stop_pay_type_cd
      ,remit_stop_pay_type_cd
      ,surp_tenor
      ,stl_amt
      ,sys_in_flg
      ,tran_status_cd
      ,payoff_type_cd
      ,invtry_org_id
      ,hq_org_id
  from ${iml_schema}.evt_rgst_cter_bill_ccution t1 where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > add_months(to_date('${batch_date}','yyyymmdd'),-1);" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_rgst_cter_bill_ccution_m.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes