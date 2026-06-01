: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_tbox_cash_tran_flow_f
CreateDate: 20251202
FileName:   ${iel_data_path}/ref_tbox_cash_tran_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,tran_dt
,replace(replace(t1.tran_out_org_id,chr(13),''),chr(10),'') as tran_out_org_id
,replace(replace(t1.cntpty_org_type_cd,chr(13),''),chr(10),'') as cntpty_org_type_cd
,replace(replace(t1.cntpty_org_id,chr(13),''),chr(10),'') as cntpty_org_id
,replace(replace(t1.tran_out_tail_box_id,chr(13),''),chr(10),'') as tran_out_tail_box_id
,replace(replace(t1.cntpty_tail_box_id,chr(13),''),chr(10),'') as cntpty_tail_box_id
,replace(replace(t1.tran_out_teller_id,chr(13),''),chr(10),'') as tran_out_teller_id
,replace(replace(t1.cntpty_teller_id,chr(13),''),chr(10),'') as cntpty_teller_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.cntpty_tran_ref_no,chr(13),''),chr(10),'') as cntpty_tran_ref_no
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.cntpty_cust_id,chr(13),''),chr(10),'') as cntpty_cust_id
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.pbc_cash_out_in_whs_type_cd,chr(13),''),chr(10),'') as pbc_cash_out_in_whs_type_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.ref_tbox_cash_tran_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_tbox_cash_tran_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
