: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_exp_lc_h_f
CreateDate: 20251013
FileName:   ${iel_data_path}/agt_exp_lc_h.f.${batch_date}.dat
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
,lc_exp_dt
,cfm_dt
,advise_dt
,replace(replace(t1.issue_bank_name,chr(13),''),chr(10),'') as issue_bank_name
,replace(replace(t1.benefc_name,chr(13),''),chr(10),'') as benefc_name
,replace(replace(t1.cfm_way_cd,chr(13),''),chr(10),'') as cfm_way_cd
,exp_dt
,replace(replace(t1.tran_cmplt_site,chr(13),''),chr(10),'') as tran_cmplt_site
,replace(replace(t1.lc_type_cd,chr(13),''),chr(10),'') as lc_type_cd
,pre_advise_dt
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd
,replace(replace(t1.red_green_claus_flg,chr(13),''),chr(10),'') as red_green_claus_flg
,cfm_pct
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.dom_lc_flg,chr(13),''),chr(10),'') as dom_lc_flg

from ${iml_schema}.agt_exp_lc_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_exp_lc_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
