: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tla_lnpreintr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tla_lnpreintr_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,draftid
,lnprvseq
,lnprvtype
,lnprvunit
,planperi
,prvdt
,lstdt
,nxtdt
,overdt
,brcd
,prvintamt
,prvdayamt
,prvintbal
,lntxndesc
,busstype
,status
,dbsubj
,crsubj
from ${idl_schema}.odss_tla_lnpreintr
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tla_lnpreintr_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes