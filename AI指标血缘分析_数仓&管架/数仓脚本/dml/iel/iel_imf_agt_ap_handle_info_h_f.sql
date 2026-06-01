: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_ap_handle_info_h_f
CreateDate: 20240903
FileName:   ${iel_data_path}/agt_ap_handle_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prop_id,chr(13),''),chr(10),'') as prop_id
,replace(replace(t1.prop_name,chr(13),''),chr(10),'') as prop_name
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.apedx_id,chr(13),''),chr(10),'') as apedx_id
,replace(replace(t1.prop_kind_id,chr(13),''),chr(10),'') as prop_kind_id
,replace(replace(t1.main_disp_type_cd,chr(13),''),chr(10),'') as main_disp_type_cd
,replace(replace(t1.disp_type_cd,chr(13),''),chr(10),'') as disp_type_cd
,replace(replace(t1.subrch_prvlg_flg,chr(13),''),chr(10),'') as subrch_prvlg_flg
,replace(replace(t1.reply_id,chr(13),''),chr(10),'') as reply_id
,replace(replace(t1.reply_content_descb,chr(13),''),chr(10),'') as reply_content_descb
,reply_input_dt
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,disp_amt
,rpbl_pric_amt
,rpbl_in_bs_int_amt
,rpbl_off_bs_int_amt
,derate_pric_amt
,derate_tot_amt
,derate_in_bs_int_amt
,derate_off_bs_int_amt
,derate_bf_pric_bal
,derate_bf_in_bs_over_int_amt
,derate_bf_off_bs_over_int_amt
,replace(replace(t1.brwer_cert_type_cd,chr(13),''),chr(10),'') as brwer_cert_type_cd
,replace(replace(t1.brwer_cert_no,chr(13),''),chr(10),'') as brwer_cert_no
,replace(replace(t1.prop_invo_trd_cust_descb,chr(13),''),chr(10),'') as prop_invo_trd_cust_descb
,replace(replace(t1.prop_invo_trd_cust_name_comb,chr(13),''),chr(10),'') as prop_invo_trd_cust_name_comb
,replace(replace(t1.prop_invo_trd_cust_id_comb,chr(13),''),chr(10),'') as prop_invo_trd_cust_id_comb
,replace(replace(t1.risk_asset_comb,chr(13),''),chr(10),'') as risk_asset_comb
,replace(replace(t1.prop_descb,chr(13),''),chr(10),'') as prop_descb
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,up_date
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark

from ${iml_schema}.agt_ap_handle_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ap_handle_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
