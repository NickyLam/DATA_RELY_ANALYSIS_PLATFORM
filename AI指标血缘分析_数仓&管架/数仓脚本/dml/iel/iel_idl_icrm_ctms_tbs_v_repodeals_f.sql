: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ctms_tbs_v_repodeals_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ctms_tbs_v_repodeals.f.${batch_date}.dat
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
,first_price
,maturity_price
,repo_rate
,amount
,maturity_amount
,fee1
,tax_amt1
,broker_amt1
,fee2
,tax_amt2
,broker_amt2
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
,repo_days
,repodeals_id_grand
,repo_id
,clearing_type from idl.icrm_ctms_tbs_v_repodeals where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ctms_tbs_v_repodeals.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes