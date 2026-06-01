: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a49teffixsign_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a49teffixsign_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
signdt
,cntrsq
,signtm
,custtp
,unitcd
,citycd
,cntrtp
,busitp
,cntrno
,iotype
,recvbk
,rebkna
,recvac
,recvna
,pyerbk
,pybkna
,pyerac
,pyerna
,cncldt
,userid
,brchno
,ckbrus
,cntrst
,modidt
,moditm
,modius
,modibr
,clckus
,remark
from ${idl_schema}.odss_a49teffixsign
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a49teffixsign_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes