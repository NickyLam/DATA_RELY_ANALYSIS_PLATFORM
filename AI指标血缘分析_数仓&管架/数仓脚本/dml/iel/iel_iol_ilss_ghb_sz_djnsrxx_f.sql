: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_djnsrxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_djnsrxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.nsrmc,chr(13),''),chr(10),'') as nsrmc
,replace(replace(t.zzlxmc,chr(13),''),chr(10),'') as zzlxmc
,replace(replace(t.zzhm,chr(13),''),chr(10),'') as zzhm
,replace(replace(t.nsrztmc,chr(13),''),chr(10),'') as nsrztmc
,replace(replace(t.nsrlxmc,chr(13),''),chr(10),'') as nsrlxmc
,replace(replace(t.zzsqylxmc,chr(13),''),chr(10),'') as zzsqylxmc
,replace(replace(t.zcdz,chr(13),''),chr(10),'') as zcdz
,replace(replace(t.scjydz,chr(13),''),chr(10),'') as scjydz
,replace(replace(t.djrq,chr(13),''),chr(10),'') as djrq
,replace(replace(t.kyslrq,chr(13),''),chr(10),'') as kyslrq
,replace(replace(t.scjyqxq,chr(13),''),chr(10),'') as scjyqxq
,replace(replace(t.scjyqxz,chr(13),''),chr(10),'') as scjyqxz
,replace(replace(t.djzclxmc,chr(13),''),chr(10),'') as djzclxmc
,replace(replace(t.hy_mc,chr(13),''),chr(10),'') as hy_mc
,replace(replace(t.jyfw,chr(13),''),chr(10),'') as jyfw
,t.cyrs as cyrs
,t.zczb as zczb
,replace(replace(t.kjzdzzmc,chr(13),''),chr(10),'') as kjzdzzmc
,replace(replace(t.swjgmc,chr(13),''),chr(10),'') as swjgmc
,replace(replace(t.fddbrxm,chr(13),''),chr(10),'') as fddbrxm
,replace(replace(t.fddbrsfzjlx,chr(13),''),chr(10),'') as fddbrsfzjlx
,replace(replace(t.fddbrsfzjhm,chr(13),''),chr(10),'') as fddbrsfzjhm
,replace(replace(t.cwfzrsfzjzl,chr(13),''),chr(10),'') as cwfzrsfzjzl
,replace(replace(t.cwfzrsfzjhm,chr(13),''),chr(10),'') as cwfzrsfzjhm
,replace(replace(t.bsrxm,chr(13),''),chr(10),'') as bsrxm
,replace(replace(t.bsrsfzjzl,chr(13),''),chr(10),'') as bsrsfzjzl
,replace(replace(t.bsrsfzjhm,chr(13),''),chr(10),'') as bsrsfzjhm
,replace(replace(t.zzjg_dm,chr(13),''),chr(10),'') as zzjg_dm
,replace(replace(t.zgswj_dm,chr(13),''),chr(10),'') as zgswj_dm
,replace(replace(t.kqccsztdjbz,chr(13),''),chr(10),'') as kqccsztdjbz
,replace(replace(t.zfjglx_dm,chr(13),''),chr(10),'') as zfjglx_dm
,replace(replace(t.fddbryddh,chr(13),''),chr(10),'') as fddbryddh
,replace(replace(t.cwfzrxm,chr(13),''),chr(10),'') as cwfzrxm
,t.create_time as create_time
,t.update_time as update_time
,replace(replace(t.hy_dm,chr(13),''),chr(10),'') as hy_dm
from iol.ilss_ghb_sz_djnsrxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_djnsrxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes