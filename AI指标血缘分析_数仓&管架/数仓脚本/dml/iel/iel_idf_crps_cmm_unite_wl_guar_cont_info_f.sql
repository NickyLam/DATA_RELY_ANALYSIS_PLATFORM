: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_cmm_unite_wl_guar_cont_info_f
CreateDate: 20231113
FileName:   ${iel_data_path}/crps_cmm_unite_wl_guar_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
etl_dt
,lp_id
,guar_cont_id
,guar_cont_type_cd
,guar_way_cd
,guar_kind_cd
,status_cd
,curr_cd
,sign_dt
,effect_dt
,exp_dt
,cust_id
,guartor_cust_id
,guartor_name
,guartor_cert_type_cd
,guartor_cert_no
,guar_amt
,gover_fin_guar_corp_guar_flg
,rev_guar_flg
,guar_org_name
,guar_item_promis_id
,rgst_org_id
,rgstrat_id
,rgst_dt

from ${idl_schema}.crps_cmm_unite_wl_guar_cont_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_cmm_unite_wl_guar_cont_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
