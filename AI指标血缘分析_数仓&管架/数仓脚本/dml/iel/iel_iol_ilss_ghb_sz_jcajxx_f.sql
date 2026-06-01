: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_jcajxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_jcajxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.jcajbh,chr(13),''),chr(10),'') as jcajbh
,replace(replace(t.ajmc,chr(13),''),chr(10),'') as ajmc
,replace(replace(t.ajlxmc,chr(13),''),chr(10),'') as ajlxmc
,replace(replace(t.jcssqjq,chr(13),''),chr(10),'') as jcssqjq
,replace(replace(t.jcssqjz,chr(13),''),chr(10),'') as jcssqjz
,replace(replace(t.larq,chr(13),''),chr(10),'') as larq
,replace(replace(t.rwxdrq,chr(13),''),chr(10),'') as rwxdrq
,replace(replace(t.jcdjrq,chr(13),''),chr(10),'') as jcdjrq
,replace(replace(t.swjctzssdrq,chr(13),''),chr(10),'') as swjctzssdrq
,replace(replace(t.jcjsrq,chr(13),''),chr(10),'') as jcjsrq
,replace(replace(t.sldjrq,chr(13),''),chr(10),'') as sldjrq
,replace(replace(t.sljsrq,chr(13),''),chr(10),'') as sljsrq
,replace(replace(t.zxdjrq,chr(13),''),chr(10),'') as zxdjrq
,replace(replace(t.zxwbrq,chr(13),''),chr(10),'') as zxwbrq
,replace(replace(t.yjskze,chr(13),''),chr(10),'') as yjskze
,t.yjfkze as yjfkze
,t.yjznjze as yjznjze
,t.sjskze as sjskze
,t.sjznjze as sjznjze
,t.sjfkze as sjfkze
,replace(replace(t.slyj2,chr(13),''),chr(10),'') as slyj2
,replace(replace(t.jcrqq,chr(13),''),chr(10),'') as jcrqq
,replace(replace(t.lrrq,chr(13),''),chr(10),'') as lrrq
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_jcajxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_jcajxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes