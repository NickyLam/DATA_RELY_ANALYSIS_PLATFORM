: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_kdb_mkcd_extd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/CBS_KDB_MKCD_EXTD_${batch_date}_ALL.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
cardno
,cardvv
,cardv2
,exinfo
,efctdt
,invldt
,servcd
,track1
,track2
,track3
,custno
,custen
,eqtrk1
,eqtrk2
,eqtrk3
from idl.crms_cbs_kdb_mkcd_extd
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/CBS_KDB_MKCD_EXTD_${batch_date}_ALL.dat" \
        charset=zhs16gbk
        safe=yes