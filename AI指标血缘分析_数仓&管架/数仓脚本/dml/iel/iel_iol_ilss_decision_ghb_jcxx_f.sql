: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_decision_ghb_jcxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_decision_ghb_jcxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,replace(replace(t1.nsrmc,chr(13),''),chr(10),'') as nsrmc 
,replace(replace(t1.zzjgdm,chr(13),''),chr(10),'') as zzjgdm 
,replace(replace(t1.nsrsbh,chr(13),''),chr(10),'') as nsrsbh 
,replace(replace(t1.zcdz,chr(13),''),chr(10),'') as zcdz 
,replace(replace(t1.scjydz,chr(13),''),chr(10),'') as scjydz 
,replace(replace(t1.zcd_dhhm,chr(13),''),chr(10),'') as zcd_dhhm 
,replace(replace(t1.hymx_dm,chr(13),''),chr(10),'') as hymx_dm 
,replace(replace(t1.hymx_mc,chr(13),''),chr(10),'') as hymx_mc 
,replace(replace(t1.jyfw,chr(13),''),chr(10),'') as jyfw 
,replace(replace(t1.djrq,chr(13),''),chr(10),'') as djrq 
,t1.cyrs as cyrs 
,replace(replace(t1.djzclx_dm,chr(13),''),chr(10),'') as djzclx_dm 
,replace(replace(t1.djzclx_mc,chr(13),''),chr(10),'') as djzclx_mc 
,t1.zczb_ze as zczb_ze 
,replace(replace(t1.zcbz_mc,chr(13),''),chr(10),'') as zcbz_mc 
,replace(replace(t1.sykjzd_dm,chr(13),''),chr(10),'') as sykjzd_dm 
,replace(replace(t1.sykjzd_mc,chr(13),''),chr(10),'') as sykjzd_mc 
,replace(replace(t1.nsrzt_mc,chr(13),''),chr(10),'') as nsrzt_mc 
,replace(replace(t1.nsrlx_mc,chr(13),''),chr(10),'') as nsrlx_mc 
,replace(replace(t1.xydj,chr(13),''),chr(10),'') as xydj 
,replace(replace(t1.xypfsj,chr(13),''),chr(10),'') as xypfsj 
,t1.xypffs as xypffs 
,replace(replace(t1.zgswjg_mc,chr(13),''),chr(10),'') as zgswjg_mc 
,replace(replace(t1.ss,chr(13),''),chr(10),'') as ss 
,replace(replace(t1.ds,chr(13),''),chr(10),'') as ds 
,replace(replace(t1.swjg_dm,chr(13),''),chr(10),'') as swjg_dm 
,replace(replace(t1.fddbrmc,chr(13),''),chr(10),'') as fddbrmc 
,replace(replace(t1.fr_gddhhm,chr(13),''),chr(10),'') as fr_gddhhm 
,replace(replace(t1.fr_yddhhm,chr(13),''),chr(10),'') as fr_yddhhm 
,replace(replace(t1.fr_dydz,chr(13),''),chr(10),'') as fr_dydz 
,replace(replace(t1.fr_zjlx_mc,chr(13),''),chr(10),'') as fr_zjlx_mc 
,replace(replace(t1.fr_zjhm,chr(13),''),chr(10),'') as fr_zjhm 
,replace(replace(t1.gszch,chr(13),''),chr(10),'') as gszch 
from ${iol_schema}.ilss_decision_ghb_jcxx t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_decision_ghb_jcxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes