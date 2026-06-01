: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_fcs_list_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_fcs_list.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.tranbr,chr(13),''),chr(10),'') as tranbr
,replace(replace(t.tranus,chr(13),''),chr(10),'') as tranus
,replace(replace(t.foretp,chr(13),''),chr(10),'') as foretp
,replace(replace(t.fosbtp,chr(13),''),chr(10),'') as fosbtp
,replace(replace(t.projtg,chr(13),''),chr(10),'') as projtg
,replace(replace(t.bycrcy,chr(13),''),chr(10),'') as bycrcy
,replace(replace(t.byacct,chr(13),''),chr(10),'') as byacct
,replace(replace(t.bysubc,chr(13),''),chr(10),'') as bysubc
,replace(replace(t.bycsex,chr(13),''),chr(10),'') as bycsex
,t.byexrt as byexrt
,t.bytrex as bytrex
,t.bytram as bytram
,t.inbypr as inbypr
,replace(replace(t.slcrcy,chr(13),''),chr(10),'') as slcrcy
,replace(replace(t.slacct,chr(13),''),chr(10),'') as slacct
,replace(replace(t.slsubc,chr(13),''),chr(10),'') as slsubc
,replace(replace(t.slcsex,chr(13),''),chr(10),'') as slcsex
,t.slexrt as slexrt
,t.sltrex as sltrex
,t.sltram as sltram
,replace(replace(t.middcy,chr(13),''),chr(10),'') as middcy
,t.middam as middam
,t.inslpr as inslpr
,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t.custna,chr(13),''),chr(10),'') as custna
,t.prfpot as prfpot
,replace(replace(t.natnty,chr(13),''),chr(10),'') as natnty
,replace(replace(t.idtftp,chr(13),''),chr(10),'') as idtftp
,replace(replace(t.idtfno,chr(13),''),chr(10),'') as idtfno
,replace(replace(t.bjtime,chr(13),''),chr(10),'') as bjtime
,replace(replace(t.busitp,chr(13),''),chr(10),'') as busitp
,replace(replace(t.bysltg,chr(13),''),chr(10),'') as bysltg
,replace(replace(t.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t.isretn,chr(13),''),chr(10),'') as isretn
,replace(replace(t.servtp,chr(13),''),chr(10),'') as servtp
from iol.cbss_fcs_list t
where t.trandt = '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_fcs_list.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes