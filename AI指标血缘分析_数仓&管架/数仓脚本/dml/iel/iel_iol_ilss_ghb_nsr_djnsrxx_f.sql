: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_nsr_djnsrxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_nsr_djnsrxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.djxh,chr(13),''),chr(10),'') as djxh
,replace(replace(t.gdslx_dm,chr(13),''),chr(10),'') as gdslx_dm
,replace(replace(t.gdslxmc,chr(13),''),chr(10),'') as gdslxmc
,replace(replace(t.ssdabh,chr(13),''),chr(10),'') as ssdabh
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.nsrmc,chr(13),''),chr(10),'') as nsrmc
,replace(replace(t.djzclx_dm,chr(13),''),chr(10),'') as djzclx_dm
,replace(replace(t.djzclxmc,chr(13),''),chr(10),'') as djzclxmc
,replace(replace(t.fddbrxm,chr(13),''),chr(10),'') as fddbrxm
,replace(replace(t.fddbrsfzjlx_dm,chr(13),''),chr(10),'') as fddbrsfzjlx_dm
,replace(replace(t.fddbrsfzjlxmc,chr(13),''),chr(10),'') as fddbrsfzjlxmc
,replace(replace(t.scjydz,chr(13),''),chr(10),'') as scjydz
,replace(replace(t.fddbrsfzjhm,chr(13),''),chr(10),'') as fddbrsfzjhm
,replace(replace(t.scjydzxzqhszmc,chr(13),''),chr(10),'') as scjydzxzqhszmc
,replace(replace(t.nsrzt_dm,chr(13),''),chr(10),'') as nsrzt_dm
,replace(replace(t.nsrztmc,chr(13),''),chr(10),'') as nsrztmc
,replace(replace(t.hy_dm,chr(13),''),chr(10),'') as hy_dm
,replace(replace(t.hymc,chr(13),''),chr(10),'') as hymc
,replace(replace(t.zcdz,chr(13),''),chr(10),'') as zcdz
,replace(replace(t.zcdzxzqhsz_dm,chr(13),''),chr(10),'') as zcdzxzqhsz_dm
,replace(replace(t.zcdzxzqhszmc,chr(13),''),chr(10),'') as zcdzxzqhszmc
,replace(replace(t.jdxz_dm,chr(13),''),chr(10),'') as jdxz_dm
,replace(replace(t.jdxzmc,chr(13),''),chr(10),'') as jdxzmc
,replace(replace(t.dwlsgx_dm,chr(13),''),chr(10),'') as dwlsgx_dm
,replace(replace(t.dwlsgxmc,chr(13),''),chr(10),'') as dwlsgxmc
,replace(replace(t.gdghlx_dm,chr(13),''),chr(10),'') as gdghlx_dm
,replace(replace(t.gdghlxmc,chr(13),''),chr(10),'') as gdghlxmc
,replace(replace(t.djjg_dm,chr(13),''),chr(10),'') as djjg_dm
,replace(replace(t.djjgmc,chr(13),''),chr(10),'') as djjgmc
,replace(replace(t.djrq,chr(13),''),chr(10),'') as djrq
,replace(replace(t.zzjg_dm,chr(13),''),chr(10),'') as zzjg_dm
,replace(replace(t.zzjgmc,chr(13),''),chr(10),'') as zzjgmc
,replace(replace(t.zgswj_dm,chr(13),''),chr(10),'') as zgswj_dm
,replace(replace(t.zgswjmc,chr(13),''),chr(10),'') as zgswjmc
,replace(replace(t.zgswskfj_dm,chr(13),''),chr(10),'') as zgswskfj_dm
,replace(replace(t.zgswskfjmc,chr(13),''),chr(10),'') as zgswskfjmc
,replace(replace(t.ssgly_dm,chr(13),''),chr(10),'') as ssgly_dm
,replace(replace(t.ssglymc,chr(13),''),chr(10),'') as ssglymc
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.yxbz,chr(13),''),chr(10),'') as yxbz
,replace(replace(t.zzhm,chr(13),''),chr(10),'') as zzhm
,replace(replace(t.kyslrq,chr(13),''),chr(10),'') as kyslrq
,replace(replace(t.zzlx_dm,chr(13),''),chr(10),'') as zzlx_dm
,replace(replace(t.zzlxmc,chr(13),''),chr(10),'') as zzlxmc
,replace(replace(t.afterttrxseq,chr(13),''),chr(10),'') as afterttrxseq
,replace(replace(t.auth_uuid,chr(13),''),chr(10),'') as auth_uuid
,t.create_time as create_time
,t.update_time as update_time
,t.data_syn_time as data_syn_time
from iol.ilss_ghb_nsr_djnsrxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_nsr_djnsrxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes