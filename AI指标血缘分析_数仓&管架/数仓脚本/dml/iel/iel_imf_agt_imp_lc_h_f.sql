: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_imp_lc_h_f
CreateDate: 20251017
FileName:   ${iel_data_path}/agt_imp_lc_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.intnal_lc_id,chr(13),''),chr(10),'') as intnal_lc_id
,replace(replace(t1.lc_id,chr(13),''),chr(10),'') as lc_id
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id
,lc_effect_dt
,lc_issue_dt
,lc_invalid_dt
,replace(replace(t1.advise_bank_name,chr(13),''),chr(10),'') as advise_bank_name
,replace(replace(t1.advise_bank_ref_id,chr(13),''),chr(10),'') as advise_bank_ref_id
,final_modif_dt
,replace(replace(t1.applit_name,chr(13),''),chr(10),'') as applit_name
,replace(replace(t1.pay_way_cd,chr(13),''),chr(10),'') as pay_way_cd
,replace(replace(t1.benefc_name,chr(13),''),chr(10),'') as benefc_name
,replace(replace(t1.fee_src_cd,chr(13),''),chr(10),'') as fee_src_cd
,replace(replace(t1.cfm_way_cd,chr(13),''),chr(10),'') as cfm_way_cd
,lc_valid_dt
,replace(replace(t1.present_site,chr(13),''),chr(10),'') as present_site
,replace(replace(t1.lc_type_cd,chr(13),''),chr(10),'') as lc_type_cd
,pre_advise_dt
,replace(replace(t1.pay_back_flg,chr(13),''),chr(10),'') as pay_back_flg
,replace(replace(t1.red_green_claus_flg,chr(13),''),chr(10),'') as red_green_claus_flg
,replace(replace(t1.backtb_lc_flg,chr(13),''),chr(10),'') as backtb_lc_flg
,replace(replace(t1.backtb_lc_id,chr(13),''),chr(10),'') as backtb_lc_id
,fwd_tenor
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,margin_recvbl_ratio
,replace(replace(t1.issue_way_cd,chr(13),''),chr(10),'') as issue_way_cd
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,margin_actl_recv_ratio
,replace(replace(t1.dom_lc_flg,chr(13),''),chr(10),'') as dom_lc_flg
,lc_bal
,replace(replace(t1.inpwn_type_cd,chr(13),''),chr(10),'') as inpwn_type_cd

from ${iml_schema}.agt_imp_lc_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_imp_lc_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
