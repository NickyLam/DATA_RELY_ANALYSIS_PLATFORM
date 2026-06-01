: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_nbzz_khcklrhz_f
CreateDate: 20240806
FileName:   ${iel_data_path}/pams_nbzz_khcklrhz.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.dzybz,chr(13),''),chr(10),'') as dzybz
,replace(replace(t1.whzhbz,chr(13),''),chr(10),'') as whzhbz
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,ye
,ylj
,jlj
,nlj
,drsy
,dysy
,djsy
,dnsy

from ${iol_schema}.pams_nbzz_khcklrhz t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_khcklrhz.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
