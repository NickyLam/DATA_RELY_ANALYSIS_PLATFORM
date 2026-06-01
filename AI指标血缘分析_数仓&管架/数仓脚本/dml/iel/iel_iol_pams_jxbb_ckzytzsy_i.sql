: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_ckzytzsy_i
CreateDate: 20260415
FileName:   ${iel_data_path}/pams_jxbb_ckzytzsy.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,replace(replace(t1.zyzqlx,chr(13),''),chr(10),'') as zyzqlx
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,zyzqje
,tzsy
,sdtzsy
,tzsyylj
,tzsyjlj
,tzsynlj
,replace(replace(t1.khjlgh,chr(13),''),chr(10),'') as khjlgh
,replace(replace(t1.hth,chr(13),''),chr(10),'') as hth
,zyr
,dqr
,replace(replace(t1.ldpz,chr(13),''),chr(10),'') as ldpz

from ${iol_schema}.pams_jxbb_ckzytzsy t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_ckzytzsy.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
