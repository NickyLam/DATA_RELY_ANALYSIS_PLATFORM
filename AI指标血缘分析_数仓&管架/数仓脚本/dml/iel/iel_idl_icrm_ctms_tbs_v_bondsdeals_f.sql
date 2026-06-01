: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ctms_tbs_v_bondsdeals_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ctms_tbs_v_bondsdeals.f.${batch_date}.dat
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
,bondstype
,serial_number
,tradedate
,settledate
,buyorsell
,cleanprice
,dirtyprice
,yieldtomaturity
,settleamount
,portfolio_id
,portfolio_name
,keepfolder_id
,keepfolder_shortname
,folderatts
,classfyname
,cptys_shortname
,cptys_id
,settletype
,dealer_id
,dealer_name
,ref_number
,feeamount
,taxamount
,brokeramount
,note
,nominal
,accruedamount
,cfets_from
,source
,lastmodified
,datasymbol_id
,assettype_id
,bondsdeals_id_grand
,stock_id
,convert_price
,stock_price
,convert_quantity from idl.icrm_ctms_tbs_v_bondsdeals where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ctms_tbs_v_bondsdeals.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes