: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_tbsysarg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_tbsysarg_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select seller_code
,bank_name
,system_name
,bank_short_name
,prev_date
,init_date
,host_check_date
,rights
,unfrozen_flag
,holddays
,status
,befbkup_date
,aftbkup_date
,hisbkup_date
,fstunloadbeg_date
,sharechg_days
,reserve1 from  ${idl_schema}.gzfh_tbsysarg where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_tbsysarg_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes