: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_nsr_djnsrxxkz_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_nsr_djnsrxxkz.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.djxh,chr(13),''),chr(10),'') as djxh
,replace(replace(t.hjszd,chr(13),''),chr(10),'') as hjszd
,replace(replace(t.jyfw,chr(13),''),chr(10),'') as jyfw
,replace(replace(t.zcdlxdh,chr(13),''),chr(10),'') as zcdlxdh
,replace(replace(t.zcdyzbm,chr(13),''),chr(10),'') as zcdyzbm
,replace(replace(t.scjydlxdh,chr(13),''),chr(10),'') as scjydlxdh
,replace(replace(t.scjydyzbm,chr(13),''),chr(10),'') as scjydyzbm
,replace(replace(t.hsfs_dm,chr(13),''),chr(10),'') as hsfs_dm
,replace(replace(t.hsfsmc,chr(13),''),chr(10),'') as hsfsmc
,t.cyrs as cyrs
,t.wjcyrs as wjcyrs
,t.hhrs as hhrs
,t.ggrs as ggrs
,t.gdgrs as gdgrs
,replace(replace(t.zzjglx_dm,chr(13),''),chr(10),'') as zzjglx_dm
,replace(replace(t.zzjglxmc,chr(13),''),chr(10),'') as zzjglxmc
,replace(replace(t.kjzdzz_dm,chr(13),''),chr(10),'') as kjzdzz_dm
,replace(replace(t.kjzdzzmc,chr(13),''),chr(10),'') as kjzdzzmc
,replace(replace(t.swdlrlxdh,chr(13),''),chr(10),'') as swdlrlxdh
,replace(replace(t.swdlrdzxx,chr(13),''),chr(10),'') as swdlrdzxx
,t.zczb as zczb
,t.tzze as tzze
,t.zrrtzbl as zrrtzbl
,t.wztzbl as wztzbl
,t.gytzbl as gytzbl
,replace(replace(t.gykglx_dm,chr(13),''),chr(10),'') as gykglx_dm
,replace(replace(t.gykglxmc,chr(13),''),chr(10),'') as gykglxmc
,replace(replace(t.zfjglx_dm,chr(13),''),chr(10),'') as zfjglx_dm
,replace(replace(t.zfjglxmc,chr(13),''),chr(10),'') as zfjglxmc
,replace(replace(t.bzfs_dm,chr(13),''),chr(10),'') as bzfs_dm
,replace(replace(t.bzfsmc,chr(13),''),chr(10),'') as bzfsmc
,replace(replace(t.fddbrgddh,chr(13),''),chr(10),'') as fddbrgddh
,replace(replace(t.fddbryddh,chr(13),''),chr(10),'') as fddbryddh
,replace(replace(t.fddbrdzxx,chr(13),''),chr(10),'') as fddbrdzxx
,replace(replace(t.cwfzrxm,chr(13),''),chr(10),'') as cwfzrxm
,replace(replace(t.cwfzrsfzjzl_dm,chr(13),''),chr(10),'') as cwfzrsfzjzl_dm
,replace(replace(t.cwfzrsfzjzlmc,chr(13),''),chr(10),'') as cwfzrsfzjzlmc
,replace(replace(t.cwfzrsfzjhm,chr(13),''),chr(10),'') as cwfzrsfzjhm
,replace(replace(t.cwfzrgddh,chr(13),''),chr(10),'') as cwfzrgddh
,replace(replace(t.cwfzryddh,chr(13),''),chr(10),'') as cwfzryddh
,replace(replace(t.cwfzrdzxx,chr(13),''),chr(10),'') as cwfzrdzxx
,replace(replace(t.bsrxm,chr(13),''),chr(10),'') as bsrxm
,replace(replace(t.bsrsfzjzl_dm,chr(13),''),chr(10),'') as bsrsfzjzl_dm
,replace(replace(t.bsrsfzjzlmc,chr(13),''),chr(10),'') as bsrsfzjzlmc
,replace(replace(t.bsrsfzjhm,chr(13),''),chr(10),'') as bsrsfzjhm
,replace(replace(t.bsrgddh,chr(13),''),chr(10),'') as bsrgddh
,replace(replace(t.bsryddh,chr(13),''),chr(10),'') as bsryddh
,replace(replace(t.bsrdzxx,chr(13),''),chr(10),'') as bsrdzxx
,replace(replace(t.swdlrnsrsbh,chr(13),''),chr(10),'') as swdlrnsrsbh
,replace(replace(t.swdlrmc,chr(13),''),chr(10),'') as swdlrmc
,replace(replace(t.zzsjylb,chr(13),''),chr(10),'') as zzsjylb
,replace(replace(t.zzsqylx_dm,chr(13),''),chr(10),'') as zzsqylx_dm
,replace(replace(t.zzsqylxmc,chr(13),''),chr(10),'') as zzsqylxmc
,replace(replace(t.gjhdqsz_dm,chr(13),''),chr(10),'') as gjhdqsz_dm
,replace(replace(t.gjhdqszmc,chr(13),''),chr(10),'') as gjhdqszmc
,replace(replace(t.ygznsrlx_dm,chr(13),''),chr(10),'') as ygznsrlx_dm
,replace(replace(t.ygznsrlxmc,chr(13),''),chr(10),'') as ygznsrlxmc
,replace(replace(t.auth_uuid,chr(13),''),chr(10),'') as auth_uuid
,t.create_time as create_time
,t.update_time as update_time
,t.data_syn_time as data_syn_time
from iol.ilss_ghb_nsr_djnsrxxkz t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_nsr_djnsrxxkz.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes