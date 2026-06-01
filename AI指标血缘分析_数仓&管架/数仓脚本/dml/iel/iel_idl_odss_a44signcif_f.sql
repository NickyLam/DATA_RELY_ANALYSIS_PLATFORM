: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a44signcif_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a44signcif_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
signseqno
,trndt
,trntm
,srcsysid
,idtype
,idno
,idduedt
,custname
,legalname
,legalidtype
,legalidno
,legalidduedt
,legaltel
,corpid
,regicd
,corppr
,corptp
,regiam
,insttype
,zipcd
,fax
,addr
,actorname
,actoridtype
,actoridno
,actoridduedt
,actortel
,actoraddr
,contactname
,contactidtype
,contactidno
,contactidduedt
,contactaddr
,mobile
,state
,custno
,acctno
,openbrcno
,openbrcname
,bstyle
,bacctno
,bacctname
,bacctbankid
,bacctbankname
,updt
,uptm
,custmanagerid
,dealsp
,srcseqno
from ${idl_schema}.odss_a44signcif
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a44signcif_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes