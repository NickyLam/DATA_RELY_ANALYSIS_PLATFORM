: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_org_ibank_org_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_org_ibank_org.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select org_id
,lp_id
,intnal_org_id
,org_name
,org_fname
,org_alias
,org_pinyin
,org_status_cd
,org_cls_cd
,prod_type_cd
,found_dt
,bus_lics
,org_cd_cert
,fin_lics
,dc_cnaps_sys_bank_no
,fcurr_cnaps_sys_bank_no
,update_user_id
,h_update_dt
,h_update_tm
,rgst_land
,imp_chn
,imp_dt
,core_cust_no
,cust_cls
,org_hibchy_cd
,matn_org_id
,matn_org_name
,cust_type_cd
,mar_maker_flg
,effect_flg
,en_name
,en_fname
,spv_asset_flg
,etl_dt
,job_cd from idl.icrm_org_ibank_org where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_org_ibank_org.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes