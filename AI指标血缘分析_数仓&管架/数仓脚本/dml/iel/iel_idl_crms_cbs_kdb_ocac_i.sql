: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_kdb_ocac_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cbs_kdb_ocac_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
trandt
,ocacsq
,transq
,opactg
,corrtg
,brchno
,acctbr
,acctno
,subsac
,acctna
,crcycd
,csextg
,debttp
,termcd
,dcmttp
,dcmtno
,oddcid
,tranam
,schlpv
,instam
,intxam
,bfstat
,ownint
,trdint
from ${idl_schema}.crms_cbs_kdb_ocac
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cbs_kdb_ocac_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes