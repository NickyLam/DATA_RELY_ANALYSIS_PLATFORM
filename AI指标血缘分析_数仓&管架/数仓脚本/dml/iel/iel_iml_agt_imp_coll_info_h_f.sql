: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_imp_coll_info_h_f
CreateDate: 20231110
FileName:   ${iel_data_path}/agt_imp_coll_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,replace(replace(t1.cargo_type_cd,chr(13),''),chr(10),'') as cargo_type_cd
,replace(replace(t1.cargo_auth_cd,chr(13),''),chr(10),'') as cargo_auth_cd
,cargo_arrive_dt
,revid_cargo_dt
,sugst_dt
,ship_send_out_dt
,create_date
,advise_dt
,effect_dt
,invalid_dt
,exp_dt
,effect_days
,replace(replace(t1.dt_type_cd,chr(13),''),chr(10),'') as dt_type_cd
,issue_dt
,replace(replace(t1.coll_type_cd,chr(13),''),chr(10),'') as coll_type_cd
,replace(replace(t1.bus_oper_teller_id,chr(13),''),chr(10),'') as bus_oper_teller_id
,replace(replace(t1.doc_type_cd,chr(13),''),chr(10),'') as doc_type_cd
,replace(replace(t1.doc_status_cd,chr(13),''),chr(10),'') as doc_status_cd
,replace(replace(t1.doc_id,chr(13),''),chr(10),'') as doc_id
,doc_send_out_dt
,replace(replace(t1.doc_send_out_way_cd,chr(13),''),chr(10),'') as doc_send_out_way_cd
,replace(replace(t1.dispatch_site,chr(13),''),chr(10),'') as dispatch_site
,replace(replace(t1.cargo_arrive_site,chr(13),''),chr(10),'') as cargo_arrive_site
,replace(replace(t1.pay_dir_cd,chr(13),''),chr(10),'') as pay_dir_cd
,replace(replace(t1.delay_pay_type_cd,chr(13),''),chr(10),'') as delay_pay_type_cd
,replace(replace(t1.cty_id,chr(13),''),chr(10),'') as cty_id
,acpt_dt
,replace(replace(t1.bank_guar_flg,chr(13),''),chr(10),'') as bank_guar_flg
,traff_guar_exp_dt
,replace(replace(t1.pick_goods_type_cd,chr(13),''),chr(10),'') as pick_goods_type_cd
,pick_goods_dt
,replace(replace(t1.goods_flg,chr(13),''),chr(10),'') as goods_flg
,replace(replace(t1.blend_pay_flg,chr(13),''),chr(10),'') as blend_pay_flg
,replace(replace(t1.free_pay_present_flg,chr(13),''),chr(10),'') as free_pay_present_flg
,replace(replace(t1.nomal_tran_flg,chr(13),''),chr(10),'') as nomal_tran_flg
,replace(replace(t1.coll_bk_fee_refuse_pay_give_up_idf,chr(13),''),chr(10),'') as coll_bk_fee_refuse_pay_give_up_idf
,replace(replace(t1.ghb_fee_refuse_pay_give_up_idf,chr(13),''),chr(10),'') as ghb_fee_refuse_pay_give_up_idf
,replace(replace(t1.send_face_letr_flg,chr(13),''),chr(10),'') as send_face_letr_flg
,replace(replace(t1.nra_recvbl_flg,chr(13),''),chr(10),'') as nra_recvbl_flg
,replace(replace(t1.clear_chn_cd,chr(13),''),chr(10),'') as clear_chn_cd
,replace(replace(t1.refuse_pay_flg_cd,chr(13),''),chr(10),'') as refuse_pay_flg_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id

from ${iml_schema}.agt_imp_coll_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_imp_coll_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
