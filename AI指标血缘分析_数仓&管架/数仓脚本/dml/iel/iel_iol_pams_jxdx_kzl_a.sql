: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_kzl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxdx_kzl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.jxdxdh as jxdxdh 
,replace(replace(t1.kh,chr(13),''),chr(10),'') as kh 
,replace(replace(t1.fhdh,chr(13),''),chr(10),'') as fhdh 
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh 
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh 
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc 
,replace(replace(t1.zh,chr(13),''),chr(10),'') as zh 
,replace(replace(t1.zjlb,chr(13),''),chr(10),'') as zjlb 
,replace(replace(t1.zjhm,chr(13),''),chr(10),'') as zjhm 
,replace(replace(t1.kl,chr(13),''),chr(10),'') as kl 
,replace(replace(t1.kjz,chr(13),''),chr(10),'') as kjz 
,replace(replace(t1.kdj,chr(13),''),chr(10),'') as kdj 
,replace(replace(t1.kztbz,chr(13),''),chr(10),'') as kztbz 
,replace(replace(t1.kyyzt,chr(13),''),chr(10),'') as kyyzt 
,t1.fkrq as fkrq 
,t1.kkrq as kkrq 
,t1.jhrq as jhrq 
,t1.xkrq as xkrq 
,replace(replace(t1.zfkbz,chr(13),''),chr(10),'') as zfkbz 
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh 
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx 
,t1.khdxdh as khdxdh 
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from iol.pams_jxdx_kzl t1 
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_kzl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes