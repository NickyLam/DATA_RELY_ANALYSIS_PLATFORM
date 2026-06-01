: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_ref_exch_rat_h_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_ref_exch_rat_h.i.${batch_date}.dat
IF_mark:    i
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
,start_dt 
,end_dt 
,id_mark 
,src_table_name 
,job_cd 
,etl_timestamp from idl.aml_ref_exch_rat_h where start_dt<=to_date('${batch_date}','yyyymmdd') and end_dt>to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_ref_exch_rat_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes