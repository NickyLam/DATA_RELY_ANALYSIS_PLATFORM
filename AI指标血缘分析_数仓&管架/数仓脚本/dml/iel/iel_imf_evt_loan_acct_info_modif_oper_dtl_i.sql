: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_loan_acct_info_modif_oper_dtl_i
CreateDate: 20241022
FileName:   ${iel_data_path}/evt_loan_acct_info_modif_oper_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.modif_bus_cls_cd,chr(13),''),chr(10),'') as modif_bus_cls_cd
,replace(replace(t1.modif_content_key_val,chr(13),''),chr(10),'') as modif_content_key_val
,replace(replace(t1.acct_modif_cate_cd,chr(13),''),chr(10),'') as acct_modif_cate_cd
,replace(replace(t1.modif_item,chr(13),''),chr(10),'') as modif_item
,modif_dt
,replace(replace(t1.modif_bf_val,chr(13),''),chr(10),'') as modif_bf_val
,replace(replace(t1.modif_post_val,chr(13),''),chr(10),'') as modif_post_val
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.acct_aldy_check_flg,chr(13),''),chr(10),'') as acct_aldy_check_flg
,check_dt
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.distr_flow_num,chr(13),''),chr(10),'') as distr_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.modif_batch_no,chr(13),''),chr(10),'') as modif_batch_no
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,tran_tm
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.evt_loan_acct_info_modif_oper_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_acct_info_modif_oper_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
