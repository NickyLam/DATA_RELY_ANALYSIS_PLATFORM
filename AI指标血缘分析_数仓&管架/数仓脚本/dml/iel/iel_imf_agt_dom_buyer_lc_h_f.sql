: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_dom_buyer_lc_h_f
CreateDate: 20251017
FileName:   ${iel_data_path}/agt_dom_buyer_lc_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.intnal_lc_id,chr(13),''),chr(10),'') as intnal_lc_id
,replace(replace(t1.lc_id,chr(13),''),chr(10),'') as lc_id
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.bus_teller_id,chr(13),''),chr(10),'') as bus_teller_id
,sys_rgst_dt
,issue_dt
,close_dt
,replace(replace(t1.advise_bank_name,chr(13),''),chr(10),'') as advise_bank_name
,final_modif_dt
,modif_cnt
,replace(replace(t1.applit_name,chr(13),''),chr(10),'') as applit_name
,replace(replace(t1.applit_ref_id,chr(13),''),chr(10),'') as applit_ref_id
,replace(replace(t1.pay_way_cd,chr(13),''),chr(10),'') as pay_way_cd
,replace(replace(t1.benefc_name,chr(13),''),chr(10),'') as benefc_name
,replace(replace(t1.fee_src_cd,chr(13),''),chr(10),'') as fee_src_cd
,replace(replace(t1.cfm_way_cd,chr(13),''),chr(10),'') as cfm_way_cd
,exp_dt
,replace(replace(t1.present_site,chr(13),''),chr(10),'') as present_site
,replace(replace(t1.lc_type_cd,chr(13),''),chr(10),'') as lc_type_cd
,replace(replace(t1.m_l_way_cd,chr(13),''),chr(10),'') as m_l_way_cd
,m_l_cu_ratio
,m_l_lower_ratio
,shipment_dt
,replace(replace(t1.shipment_site,chr(13),''),chr(10),'') as shipment_site
,acpt_cnt
,vp
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.trast_org_id,chr(13),''),chr(10),'') as trast_org_id
,replace(replace(t1.issue_way_cd,chr(13),''),chr(10),'') as issue_way_cd
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.traff_way_cd,chr(13),''),chr(10),'') as traff_way_cd
,lc_bal
,replace(replace(t1.open_way_cd,chr(13),''),chr(10),'') as open_way_cd
,replace(replace(t1.trade_type_cd,chr(13),''),chr(10),'') as trade_type_cd
,replace(replace(t1.cfm_flg,chr(13),''),chr(10),'') as cfm_flg
,replace(replace(t1.pur_sale_cont_id,chr(13),''),chr(10),'') as pur_sale_cont_id
,replace(replace(t1.nego_pay_flg_cd,chr(13),''),chr(10),'') as nego_pay_flg_cd
,replace(replace(t1.cont_curr_cd,chr(13),''),chr(10),'') as cont_curr_cd
,cont_amt
,replace(replace(t1.inpwn_type_cd,chr(13),''),chr(10),'') as inpwn_type_cd

from ${iml_schema}.agt_dom_buyer_lc_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dom_buyer_lc_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
