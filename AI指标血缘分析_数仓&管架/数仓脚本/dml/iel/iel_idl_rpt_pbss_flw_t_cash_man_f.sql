: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_pbss_flw_t_cash_man_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_pbss_flw_t_cash_man.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.scan_seq_no,chr(13),''),chr(10),'') as scan_seq_no
,replace(replace(t1.parent_rev_no,chr(13),''),chr(10),'') as parent_rev_no
,replace(replace(t1.receive_no,chr(13),''),chr(10),'') as receive_no
,replace(replace(t1.biz_code,chr(13),''),chr(10),'') as biz_code
,replace(replace(t1.acc_no,chr(13),''),chr(10),'') as acc_no
,replace(replace(t1.acc_typ,chr(13),''),chr(10),'') as acc_typ
,replace(replace(t1.child_img,chr(13),''),chr(10),'') as child_img
,replace(replace(t1.group_acc,chr(13),''),chr(10),'') as group_acc
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_typ,chr(13),''),chr(10),'') as cust_typ
,replace(replace(t1.cust_number,chr(13),''),chr(10),'') as cust_number
,replace(replace(t1.acc_func_stu,chr(13),''),chr(10),'') as acc_func_stu
,replace(replace(t1.acc_func_opn,chr(13),''),chr(10),'') as acc_func_opn
,replace(replace(t1.sign_state,chr(13),''),chr(10),'') as sign_state
,replace(replace(t1.acc_br_code,chr(13),''),chr(10),'') as acc_br_code
,replace(replace(t1.belong_br_code,chr(13),''),chr(10),'') as belong_br_code
,replace(replace(t1.corp_code,chr(13),''),chr(10),'') as corp_code
,replace(replace(t1.principal_papers_name,chr(13),''),chr(10),'') as principal_papers_name
,replace(replace(t1.principal_papers_type,chr(13),''),chr(10),'') as principal_papers_type
,replace(replace(t1.principal_papers_number,chr(13),''),chr(10),'') as principal_papers_number
,replace(replace(t1.seal_step,chr(13),''),chr(10),'') as seal_step
,replace(replace(t1.seal_typ,chr(13),''),chr(10),'') as seal_typ
,replace(replace(t1.fr_org_code,chr(13),''),chr(10),'') as fr_org_code
,replace(replace(t1.back_center_id,chr(13),''),chr(10),'') as back_center_id
,replace(replace(t1.fr_tlr_opr_no,chr(13),''),chr(10),'') as fr_tlr_opr_no
,replace(replace(t1.charge_id,chr(13),''),chr(10),'') as charge_id
,t1.trade_date as trade_date
,replace(replace(t1.corp_addr,chr(13),''),chr(10),'') as corp_addr
,replace(replace(t1.corp_phone1,chr(13),''),chr(10),'') as corp_phone1
,replace(replace(t1.corp_phone2,chr(13),''),chr(10),'') as corp_phone2
,replace(replace(t1.corp_phone3,chr(13),''),chr(10),'') as corp_phone3
,replace(replace(t1.child_acc_list,chr(13),''),chr(10),'') as child_acc_list
,replace(replace(t1.child_cust_id,chr(13),''),chr(10),'') as child_cust_id
,replace(replace(t1.child_cust_name,chr(13),''),chr(10),'') as child_cust_name
,replace(replace(t1.child_cust_typ,chr(13),''),chr(10),'') as child_cust_typ
,replace(replace(t1.child_cust_number,chr(13),''),chr(10),'') as child_cust_number
,replace(replace(t1.acc_name,chr(13),''),chr(10),'') as acc_name
,replace(replace(t1.modify_date,chr(13),''),chr(10),'') as modify_date
from ${iol_schema}.pbss_flw_t_cash_man t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_pbss_flw_t_cash_man.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes