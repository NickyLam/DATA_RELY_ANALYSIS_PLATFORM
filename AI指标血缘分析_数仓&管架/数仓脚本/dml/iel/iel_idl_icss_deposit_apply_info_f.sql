: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icss_deposit_apply_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/DEPOSIT_APPLY_INFO_${batch_date}_ALL.dat
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
,hascancel from idl.icss_deposit_apply_info where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/DEPOSIT_APPLY_INFO_${batch_date}_ALL.dat" \
        charset=zhs16gbk
        safe=yes