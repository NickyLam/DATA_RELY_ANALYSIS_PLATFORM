: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_kna_accs_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cbs_kna_accs_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
acctno
,subsac
,acctid
,accstp
,basetg
,crcycd
,csextg
,prodcd
,acpdcd
from ${idl_schema}.crms_cbs_kna_accs
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cbs_kna_accs_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes