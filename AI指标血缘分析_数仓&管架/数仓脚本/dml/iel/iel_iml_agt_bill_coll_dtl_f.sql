: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_coll_dtl_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_bill_coll_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.coll_dtl_id,chr(13),''),chr(10),'') as coll_dtl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.acpt_bank_addr,chr(13),''),chr(10),'') as acpt_bank_addr
,replace(replace(t1.core_entry_acct_num,chr(13),''),chr(10),'') as core_entry_acct_num
,entry_dt
,in_acct_dt
,replace(replace(t1.in_acct_info_src_name,chr(13),''),chr(10),'') as in_acct_info_src_name
,replace(replace(t1.in_acct_que_flow_num,chr(13),''),chr(10),'') as in_acct_que_flow_num
,replace(replace(t1.valet_coll_flg,chr(13),''),chr(10),'') as valet_coll_flg
,replace(replace(t1.sugst_payer_name,chr(13),''),chr(10),'') as sugst_payer_name
,replace(replace(t1.sugst_payer_acct_num,chr(13),''),chr(10),'') as sugst_payer_acct_num
,replace(replace(t1.sugst_payer_open_bank_no,chr(13),''),chr(10),'') as sugst_payer_open_bank_no
,send_out_coll_dt
,replace(replace(t1.sugst_pay_curr_cd,chr(13),''),chr(10),'') as sugst_pay_curr_cd
,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'') as final_modif_operr_id
,final_modif_tm
,replace(replace(t1.coll_dtl_status_cd,chr(13),''),chr(10),'') as coll_dtl_status_cd
,bill_amt
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,to_date('${batch_date}','yyyymmdd') as etl_dt

from ${iml_schema}.agt_bill_coll_dtl t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_coll_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
