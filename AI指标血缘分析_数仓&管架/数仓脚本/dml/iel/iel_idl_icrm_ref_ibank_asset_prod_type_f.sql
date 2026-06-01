: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ref_ibank_asset_prod_type_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ref_ibank_asset_prod_type.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select prod_type_cd
,lp_id
,asset_type_cd
,prod_type_name
,auto_ird_flg
,delay_exp_flg
,amort_way_cd
,amort_way_name
,evltion_flg
,evltion_type_cd
,drawdown_flg
,provi_flg
,col_int_flg
,auto_ovdue_flg
,on_acct_id
,on_acct_name
,etl_dt
,job_cd from idl.icrm_ref_ibank_asset_prod_type where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ref_ibank_asset_prod_type.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes