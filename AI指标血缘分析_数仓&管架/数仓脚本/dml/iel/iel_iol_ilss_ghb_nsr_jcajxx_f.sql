: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_nsr_jcajxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_nsr_jcajxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.jcajxxuuid,chr(13),''),chr(10),'') as jcajxxuuid
,replace(replace(t.djxh,chr(13),''),chr(10),'') as djxh
,replace(replace(t.zgswjg_dm,chr(13),''),chr(10),'') as zgswjg_dm
,replace(replace(t.zgswjgmc,chr(13),''),chr(10),'') as zgswjgmc
,replace(replace(t.jcssqjq,chr(13),''),chr(10),'') as jcssqjq
,replace(replace(t.jcssqjz,chr(13),''),chr(10),'') as jcssqjz
,replace(replace(t.lasqrq,chr(13),''),chr(10),'') as lasqrq
,replace(replace(t.larq,chr(13),''),chr(10),'') as larq
,replace(replace(t.zxdjrq,chr(13),''),chr(10),'') as zxdjrq
,replace(replace(t.zxwbrq,chr(13),''),chr(10),'') as zxwbrq
,t.yjfkze as yjfkze
,t.yjznjze as yjznjze
,t.sjskze as sjskze
,t.sjznjze as sjznjze
,t.sjfkze as sjfkze
,replace(replace(t.jarq,chr(13),''),chr(10),'') as jarq
,replace(replace(t.dyabz,chr(13),''),chr(10),'') as dyabz
,replace(replace(t.jcrqq,chr(13),''),chr(10),'') as jcrqq
,replace(replace(t.clwbbz,chr(13),''),chr(10),'') as clwbbz
,replace(replace(t.jcjzrq,chr(13),''),chr(10),'') as jcjzrq
,replace(replace(t.sljzrq,chr(13),''),chr(10),'') as sljzrq
,replace(replace(t.jcajbh,chr(13),''),chr(10),'') as jcajbh
,replace(replace(t.ajmc,chr(13),''),chr(10),'') as ajmc
,replace(replace(t.ajlx_dm,chr(13),''),chr(10),'') as ajlx_dm
,replace(replace(t.ajlxmc,chr(13),''),chr(10),'') as ajlxmc
,replace(replace(t.ajjczt_dm,chr(13),''),chr(10),'') as ajjczt_dm
,replace(replace(t.jcxm,chr(13),''),chr(10),'') as jcxm
,replace(replace(t.jcdjrq,chr(13),''),chr(10),'') as jcdjrq
,replace(replace(t.jcjsrq,chr(13),''),chr(10),'') as jcjsrq
,replace(replace(t.sldjrq,chr(13),''),chr(10),'') as sldjrq
,replace(replace(t.sljsrq,chr(13),''),chr(10),'') as sljsrq
,replace(replace(t.jcbm_dm,chr(13),''),chr(10),'') as jcbm_dm
,replace(replace(t.jcbmmc,chr(13),''),chr(10),'') as jcbmmc
,replace(replace(t.zdajbz,chr(13),''),chr(10),'') as zdajbz
,replace(replace(t.lrrq,chr(13),''),chr(10),'') as lrrq
,replace(replace(t.nsrmc,chr(13),''),chr(10),'') as nsrmc
,replace(replace(t.zfbz_1,chr(13),''),chr(10),'') as zfbz_1
,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t.auth_uuid,chr(13),''),chr(10),'') as auth_uuid
,t.data_syn_time as data_syn_time
,t.yjskze as yjskze
from iol.ilss_ghb_nsr_jcajxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_nsr_jcajxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes