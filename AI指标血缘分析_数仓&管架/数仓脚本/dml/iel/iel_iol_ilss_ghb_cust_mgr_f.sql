: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_cust_mgr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_cust_mgr.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.manager_code,chr(13),''),chr(10),'') as manager_code
,replace(replace(t.manager_name,chr(13),''),chr(10),'') as manager_name
,replace(replace(t.manager_mobile,chr(13),''),chr(10),'') as manager_mobile
,t.group_id as group_id
,replace(replace(t.branch_code,chr(13),''),chr(10),'') as branch_code
,replace(replace(t.branch_name,chr(13),''),chr(10),'') as branch_name
,replace(replace(t.finance_branch_code,chr(13),''),chr(10),'') as finance_branch_code
,replace(replace(t.finance_branch_name,chr(13),''),chr(10),'') as finance_branch_name
,replace(replace(t.area_code,chr(13),''),chr(10),'') as area_code
,replace(replace(t.area_name,chr(13),''),chr(10),'') as area_name
,t.credit_amt as credit_amt
,t.loan_amt as loan_amt
,t.repay_amt as repay_amt
,t.inst_amt as inst_amt
,t.overdue_amt as overdue_amt
,t.ovrd90_amt as ovrd90_amt
,t.ovrd180_amt as ovrd180_amt
,t.credit_pass as credit_pass
,t.credit_reject as credit_reject
,t.loan_cnt as loan_cnt
,t.overdue_cnt as overdue_cnt
,replace(replace(t.create_user,chr(13),''),chr(10),'') as create_user
,t.create_time as create_time
,replace(replace(t.update_user,chr(13),''),chr(10),'') as update_user
,t.update_time as update_time
,t.use_yn as use_yn
,replace(replace(t.mkt_prod_no,chr(13),''),chr(10),'') as mkt_prod_no
,replace(replace(t.mkt_merchant_no,chr(13),''),chr(10),'') as mkt_merchant_no
,replace(replace(t.id_no,chr(13),''),chr(10),'') as id_no
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ilss_ghb_cust_mgr t
where start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_cust_mgr.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes