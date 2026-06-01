: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_ap_register_info_h_f
CreateDate: 20230915
FileName:   ${iel_data_path}/agt_ap_register_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.prop_id,chr(13),''),chr(10),'') as prop_id
,replace(replace(t1.prop_name,chr(13),''),chr(10),'') as prop_name
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.disp_type_cd,chr(13),''),chr(10),'') as disp_type_cd
,cont_amt
,cont_bal
,fin_acct_recvbl
,in_bs_int_bal
,off_bs_int_bal
,cred_rht_amt
,tran_amt
,replace(replace(t1.seller_invstg_agent_org_name,chr(13),''),chr(10),'') as seller_invstg_agent_org_name
,replace(replace(t1.buyer_name,chr(13),''),chr(10),'') as buyer_name
,suit_stage_law_fee_amt
,ckwrf_asset_pric_bal
,ckwrf_asset_inbsoverint_bal
,ckwrf_asset_offbsoverint_bal
,replace(replace(t1.prop_descb,chr(13),''),chr(10),'') as prop_descb
,replace(replace(t1.risk_asset_comb,chr(13),''),chr(10),'') as risk_asset_comb
,replace(replace(t1.exec_status_cd,chr(13),''),chr(10),'') as exec_status_cd
,pkg_dt
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.modif_post_org_id,chr(13),''),chr(10),'') as modif_post_org_id
,advc_suit_fee
,replace(replace(t1.pay_way_cd,chr(13),''),chr(10),'') as pay_way_cd
,first_pay_amt
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,up_date

from ${iml_schema}.agt_ap_register_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ap_register_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
