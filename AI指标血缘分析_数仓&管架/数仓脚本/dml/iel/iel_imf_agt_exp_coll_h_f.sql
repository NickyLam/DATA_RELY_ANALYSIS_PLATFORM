: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_exp_coll_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_exp_coll_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,t1.shipment_dt as shipment_dt
,t1.sugst_dt as sugst_dt
,t1.present_dt as present_dt
,t1.send_bill_dt as send_bill_dt
,t1.advise_dt as advise_dt
,t1.valid_pay_dt as valid_pay_dt
,t1.bus_cmplt_dt as bus_cmplt_dt
,replace(replace(t1.coll_type_cd,chr(13),''),chr(10),'') as coll_type_cd
,t1.vp_days as vp_days
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.traff_doc_type_cd,chr(13),''),chr(10),'') as traff_doc_type_cd
,replace(replace(t1.traff_doc_id,chr(13),''),chr(10),'') as traff_doc_id
,t1.traff_dt as traff_dt
,replace(replace(t1.traff_tool_type_cd,chr(13),''),chr(10),'') as traff_tool_type_cd
,replace(replace(t1.coll_bk_fee_refuse_flg,chr(13),''),chr(10),'') as coll_bk_fee_refuse_flg
,replace(replace(t1.ghb_refuse_pay_flg,chr(13),''),chr(10),'') as ghb_refuse_pay_flg
,replace(replace(t1.pay_src_cd,chr(13),''),chr(10),'') as pay_src_cd
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd
,replace(replace(t1.cargo_type_cd,chr(13),''),chr(10),'') as cargo_type_cd
,t1.acquiri_bank_rgst_dt as acquiri_bank_rgst_dt
,replace(replace(t1.bus_teller_id,chr(13),''),chr(10),'') as bus_teller_id
,replace(replace(t1.free_pay_present_flg,chr(13),''),chr(10),'') as free_pay_present_flg
,replace(replace(t1.dir_coll_flg,chr(13),''),chr(10),'') as dir_coll_flg
,t1.clean_coll_open_dt as clean_coll_open_dt
,replace(replace(t1.blend_pay_flg,chr(13),''),chr(10),'') as blend_pay_flg
,replace(replace(t1.delay_pay_type_cd,chr(13),''),chr(10),'') as delay_pay_type_cd
,replace(replace(t1.doc_status_cd,chr(13),''),chr(10),'') as doc_status_cd
,replace(replace(t1.secd_recv_bank_cd,chr(13),''),chr(10),'') as secd_recv_bank_cd
,t1.overs_comm_fee as overs_comm_fee
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.trast_org_id,chr(13),''),chr(10),'') as trast_org_id
,replace(replace(t1.nra_pay_flg,chr(13),''),chr(10),'') as nra_pay_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_exp_coll_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_exp_coll_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes