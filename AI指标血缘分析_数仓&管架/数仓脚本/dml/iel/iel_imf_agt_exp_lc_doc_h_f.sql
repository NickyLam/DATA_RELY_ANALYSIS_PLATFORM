: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_exp_lc_doc_h_f
CreateDate: 20251013
FileName:   ${iel_data_path}/agt_exp_lc_doc_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.doc_id,chr(13),''),chr(10),'') as doc_id
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.parent_bus_type_cd,chr(13),''),chr(10),'') as parent_bus_type_cd
,replace(replace(t1.parent_tran_intnal_id,chr(13),''),chr(10),'') as parent_tran_intnal_id
,sugst_pay_dt
,cust_present_dt
,shipment_dt
,valid_pay_dt
,replace(replace(t1.doc_type_cd,chr(13),''),chr(10),'') as doc_type_cd
,teller_rgst_dt
,close_dt
,acquiri_bank_rgst_dt
,replace(replace(t1.bus_teller_id,chr(13),''),chr(10),'') as bus_teller_id
,replace(replace(t1.proof_nego_pay_flg,chr(13),''),chr(10),'') as proof_nego_pay_flg
,replace(replace(t1.noth_flg,chr(13),''),chr(10),'') as noth_flg
,replace(replace(t1.iss_ps_type_cd,chr(13),''),chr(10),'') as iss_ps_type_cd
,replace(replace(t1.payer_type_cd,chr(13),''),chr(10),'') as payer_type_cd
,margin_letter_revid_dt
,replace(replace(t1.discrp_flg,chr(13),''),chr(10),'') as discrp_flg
,replace(replace(t1.curt_acpt_flg,chr(13),''),chr(10),'') as curt_acpt_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,pay_tot_amt
,pay_dt
,replace(replace(t1.doc_status_cd,chr(13),''),chr(10),'') as doc_status_cd
,replace(replace(t1.doc_recv_ps_type_cd,chr(13),''),chr(10),'') as doc_recv_ps_type_cd
,replace(replace(t1.send_exp_other_addr_flg,chr(13),''),chr(10),'') as send_exp_other_addr_flg
,replace(replace(t1.return_doc_flg,chr(13),''),chr(10),'') as return_doc_flg
,replace(replace(t1.reim_bank_cd,chr(13),''),chr(10),'') as reim_bank_cd
,overs_comm_fee
,replace(replace(t1.trast_org_id,chr(13),''),chr(10),'') as trast_org_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.nra_pay_flg,chr(13),''),chr(10),'') as nra_pay_flg
,replace(replace(t1.ship_odd_no,chr(13),''),chr(10),'') as ship_odd_no
,replace(replace(t1.traff_doc_type_cd,chr(13),''),chr(10),'') as traff_doc_type_cd
,traff_dt

from ${iml_schema}.agt_exp_lc_doc_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_exp_lc_doc_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
