: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_zfldspd_zjb_cksy_xy_f
CreateDate: 20250513
FileName:   ${iel_data_path}/pams_jxbb_zfldspd_zjb_cksy_xy.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,cksybl
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,jbr
,cjrq
,jlsj

from ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_zfldspd_zjb_cksy_xy.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
