: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dom_buyer_lc_doc_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_dom_buyer_lc_doc_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.bill_bus_id,chr(13),''),chr(10),'') as bill_bus_id
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.bus_teller_id,chr(13),''),chr(10),'') as bus_teller_id
,sys_rgst_dt
,issue_dt
,close_dt
,replace(replace(t1.parent_bus_type_cd,chr(13),''),chr(10),'') as parent_bus_type_cd
,replace(replace(t1.parent_tran_intnal_id,chr(13),''),chr(10),'') as parent_tran_intnal_id
,send_bill_bk_send_bill_dt
,latest_ship_dt
,valid_pay_dt
,load_bill_revid_dt
,discrp_advise_dt
,replace(replace(t1.doc_type_cd,chr(13),''),chr(10),'') as doc_type_cd
,replace(replace(t1.refuse_pay_flg_cd,chr(13),''),chr(10),'') as refuse_pay_flg_cd
,replace(replace(t1.free_pay_present_flg,chr(13),''),chr(10),'') as free_pay_present_flg
,replace(replace(t1.edit_id,chr(13),''),chr(10),'') as edit_id
,replace(replace(t1.recv_advise_type_cd,chr(13),''),chr(10),'') as recv_advise_type_cd
,replace(replace(t1.cargo_auth_applit_flg,chr(13),''),chr(10),'') as cargo_auth_applit_flg
,replace(replace(t1.multi_tenor_flg,chr(13),''),chr(10),'') as multi_tenor_flg
,replace(replace(t1.doc_diff_flg,chr(13),''),chr(10),'') as doc_diff_flg
,replace(replace(t1.submit_role_type_cd,chr(13),''),chr(10),'') as submit_role_type_cd
,replace(replace(t1.doc_status_cd,chr(13),''),chr(10),'') as doc_status_cd
,replace(replace(t1.ignore_discrp_flg,chr(13),''),chr(10),'') as ignore_discrp_flg
,replace(replace(t1.pay_curr_cd,chr(13),''),chr(10),'') as pay_curr_cd
,pay_tot_amt
,replace(replace(t1.payer_type_cd,chr(13),''),chr(10),'') as payer_type_cd
,replace(replace(t1.acpt_flg,chr(13),''),chr(10),'') as acpt_flg
,income_bill_dt
,replace(replace(t1.chargeback_flg,chr(13),''),chr(10),'') as chargeback_flg
,replace(replace(t1.trast_org_id,chr(13),''),chr(10),'') as trast_org_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.inv_id,chr(13),''),chr(10),'') as inv_id
,replace(replace(t1.cfm_curr_cd,chr(13),''),chr(10),'') as cfm_curr_cd
,cfm_amt
,replace(replace(t1.doc_cont_id,chr(13),''),chr(10),'') as doc_cont_id
,replace(replace(t1.clear_way_cd,chr(13),''),chr(10),'') as clear_way_cd
,replace(replace(t1.send_bill_claim_money_id,chr(13),''),chr(10),'') as send_bill_claim_money_id

from ${iml_schema}.agt_dom_buyer_lc_doc_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dom_buyer_lc_doc_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
