: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_paper_bill_inpwn_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_paper_bill_inpwn_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,t1.bill_amt as bill_amt
,t1.bill_exp_dt as bill_exp_dt
,replace(replace(t1.acpt_bank_no,chr(13),''),chr(10),'') as acpt_bank_no
,replace(replace(t1.acpt_bank_name,chr(13),''),chr(10),'') as acpt_bank_name
,t1.inpwn_dt as inpwn_dt
,replace(replace(t1.pledgor_name,chr(13),''),chr(10),'') as pledgor_name
,replace(replace(t1.pledgor_acct_id,chr(13),''),chr(10),'') as pledgor_acct_id
,replace(replace(t1.pledgor_open_bank_no,chr(13),''),chr(10),'') as pledgor_open_bank_no
,replace(replace(t1.pledgor_open_bank_name,chr(13),''),chr(10),'') as pledgor_open_bank_name
,replace(replace(t1.pledgor_unify_soci_crdt_id,chr(13),''),chr(10),'') as pledgor_unify_soci_crdt_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.pawnee_open_bank_name,chr(13),''),chr(10),'') as pawnee_open_bank_name
,replace(replace(t1.inpwn_flg,chr(13),''),chr(10),'') as inpwn_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ast_paper_bill_inpwn_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_paper_bill_inpwn_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes