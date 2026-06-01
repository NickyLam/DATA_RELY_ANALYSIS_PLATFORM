: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ctms_tbs_v_ldrepodeals_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ctms_tbs_v_ldrepodeals.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,deal_id
,deal_tablename
,aspclient_id
,bondscode
,bondsname
,serial_number
,trade_date
,value_date
,maturity_date
,buyorsell
,face_amount
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
,settle_type
,settle_type2
,dealer_id
,dealer_name
,ref_number
,cfets_from
,lastmodified
,datasymbol_id
,trade_rate
,repo_days
,ldrepodeals_id_grand
,repo_id
,counterparty_type
,clearing_type from idl.icrm_ctms_tbs_v_ldrepodeals where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ctms_tbs_v_ldrepodeals.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes