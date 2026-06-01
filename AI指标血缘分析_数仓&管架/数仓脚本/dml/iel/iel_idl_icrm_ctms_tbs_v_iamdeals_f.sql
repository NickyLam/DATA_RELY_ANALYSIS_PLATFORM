: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ctms_tbs_v_iamdeals_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ctms_tbs_v_iamdeals.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,deal_id
,deal_tablename
,aspclient_id
,serial_number
,trade_date
,value_date
,maturity_date
,buyorsell
,repo_rate
,amount
,maturity_amount
,fee
,tax_amt
,broker_amt
,interest
,portfolio_id
,portfolio_name
,keepfolder_id
,keepfolder_shortname
,cptys_short_name
,cptys_id
,dealer_id
,dealer_name
,ref_number
,cfets_from
,lastmodified
,datasymbol_id
,repo_days
,iamdeals_id_grand
,note
,counterparty_type
,repo_id from idl.icrm_ctms_tbs_v_iamdeals where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ctms_tbs_v_iamdeals.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes