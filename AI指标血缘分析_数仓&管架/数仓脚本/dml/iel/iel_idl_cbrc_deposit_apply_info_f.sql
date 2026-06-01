: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cbrc_deposit_apply_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbrc_deposit_apply_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
serialno
,cusname
,cusid
,contractno
,putoutno
,opertp
,cntrtp
,dataid
,grtetp
,acptno
,acctno
,tranam
,grteac
,termcd
,matudt
,pigeonholedate
,inputuserid
,inputorgid
,inputdate
,updatedate
,subaccount
,exchangedate
,exchangeserialno
,initexchangedate
,initexchangeserialno
,businesstype
,crcycd
,exchangestate
,exchangetime
,hascancel from idl.cbrc_deposit_apply_info where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/cbrc_deposit_apply_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes