: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ctms_tbs_v_openrepodeals_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ctms_tbs_v_openrepodeals.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,deal_id
,deal_tablename
,aspclient_id
,serial_number
,portfolio_id
,portfolio_name
,keepfolder_id
,keepfolder_shortname
,currency
,buyorsell
,amount
,trade_rate
,ref_number
,trade_date
,value_date
,maturity_date
,bondscode
,bondsname
,face_amount
,first_price
,maturity_price
,maturity_amount
,interest
,cpty_id
,cpty_name
,dealer_id
,dealer_name
,fee1
,tax_amt1
,broker_amt1
,fee2
,tax_amt2
,broker_amt2
,tradingfee
,settle_type
,settle_type2
,source
,cfets_from
,spot_v
,fwd_v
,cstp_req
,keep_type
,note
,datasymbol_id
,lastmodified
,openrepodeals_id_grand from idl.icrm_ctms_tbs_v_openrepodeals where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ctms_tbs_v_openrepodeals.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes