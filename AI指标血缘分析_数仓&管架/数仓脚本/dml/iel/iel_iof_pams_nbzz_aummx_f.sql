: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_nbzz_aummx_f
CreateDate: 20240906
FileName:   ${iel_data_path}/pams_nbzz_aummx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,aumye
,zlbl
,hyaumye
,hyaumylj
,hyaumjlj
,hyaumnlj
,aumyrjye
,aumjrjye
,aumnrjye
,hyxtjhye
,hyxtjhylj
,hyxtjhjlj
,hyxtjhnlj
,xtjhyrjye
,xtjhjrjye
,xtjhnrjye
,xtjhye
,replace(replace(t1.lskhbz1,chr(13),''),chr(10),'') as lskhbz1

from ${iol_schema}.pams_nbzz_aummx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_aummx.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
