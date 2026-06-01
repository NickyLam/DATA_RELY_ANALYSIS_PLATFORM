: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_myrzftp_hqckmx_a
CreateDate: 20250609
FileName:   ${iel_data_path}/pams_jxbb_myrzftp_hqckmx.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,tjrq
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.gyllxmc_list,chr(13),''),chr(10),'') as gyllxmc_list
,replace(replace(t1.glhxqykhmc,chr(13),''),chr(10),'') as glhxqykhmc
,hqckye
,hqckyrj
,hqckjrj
,hqcknrj
,dghqckye
,dghqckyrj
,dghqckjrj
,dghqcknrj
,bzjckye
,bzjckyrj
,bzjckjrj
,bzjcknrj
,xdckye
,xdckyrj
,xdckjrj
,xdcknrj
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh

from ${iol_schema}.pams_jxbb_myrzftp_hqckmx t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_myrzftp_hqckmx.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
