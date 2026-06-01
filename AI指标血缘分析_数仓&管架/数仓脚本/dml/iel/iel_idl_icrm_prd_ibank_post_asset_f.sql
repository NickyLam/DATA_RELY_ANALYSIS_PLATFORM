: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_prd_ibank_post_asset_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_prd_ibank_post_asset.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select prod_id
,lp_id
,prod_type_cd
,prod_cd
,prod_name
,effect_dt
,ftp_int_rat
,remark
,value_dt
,exp_dt
,rgst_type_cd
,proj
,risk_wt
,risk_asset_tot
,rgst_dt
,market_inst
,customer_manager
,asset_type_cd
,market_type_cd
,vch_accti_obj_id
,amt
,etl_dt
,job_cd from idl.icrm_prd_ibank_post_asset where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_prd_ibank_post_asset.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes