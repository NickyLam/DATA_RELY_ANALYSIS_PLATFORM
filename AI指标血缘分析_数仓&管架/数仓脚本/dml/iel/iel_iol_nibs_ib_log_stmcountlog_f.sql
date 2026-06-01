: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_ib_log_stmcountlog_f
CreateDate: 20260115
FileName:   ${iel_data_path}/nibs_ib_log_stmcountlog.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tx_seq_num,chr(13),''),chr(10),'') as tx_seq_num
,channeldate
,channeltime
,worktime
,replace(replace(t1.menunum,chr(13),''),chr(10),'') as menunum
,replace(replace(t1.menuname,chr(13),''),chr(10),'') as menuname
,replace(replace(t1.branchnum,chr(13),''),chr(10),'') as branchnum
,replace(replace(t1.branchname,chr(13),''),chr(10),'') as branchname
,replace(replace(t1.usernum,chr(13),''),chr(10),'') as usernum
,replace(replace(t1.username,chr(13),''),chr(10),'') as username

from ${iol_schema}.nibs_ib_log_stmcountlog t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_ib_log_stmcountlog.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
