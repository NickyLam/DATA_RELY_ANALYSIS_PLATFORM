: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ref_exch_rat_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ref_exch_rat_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select curr_cd
,effect_dt
,invalid_dt
,status_cd
,cn_name
,en_abbr
,convt_corp
,cash_buy_price
,cash_sell_price
,exch_buy_price
,exch_sell_price
,mdl_p
,fori_exch_mdl_p
,job_cd
,etl_dt from idl.icrm_ref_exch_rat_h where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ref_exch_rat_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes