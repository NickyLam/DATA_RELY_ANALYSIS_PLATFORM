: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_rep_asset_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_rep_asset.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.rpasuuid,chr(13),''),chr(10),'') as rpasuuid
,replace(replace(t1.repduuid,chr(13),''),chr(10),'') as repduuid
,replace(replace(t1.assettype,chr(13),''),chr(10),'') as assettype
,replace(replace(t1.assetuuid,chr(13),''),chr(10),'') as assetuuid
,t1.seqno as seqno
,t1.convrate as convrate
,t1.facetotalamt as facetotalamt
,t1.dealamt as dealamt
,t1.vdprice as vdprice
,t1.vcprice as vcprice
,t1.vaccuir as vaccuir
,t1.vyield as vyield
,t1.vdpriceamt as vdpriceamt
,t1.vcpriceamt as vcpriceamt
,t1.vaccuiramt as vaccuiramt
,t1.mcprice as mcprice
,t1.mdprice as mdprice
,t1.maccuir as maccuir
,t1.myield as myield
,t1.mcpriceamt as mcpriceamt
,t1.mdpriceamt as mdpriceamt
,t1.maccuiramt as maccuiramt
,replace(replace(t1.createuser,chr(13),''),chr(10),'') as createuser
,t1.createtime as createtime
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser
,t1.updatetime as updatetime
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,t1.mdpricetheoryamt as mdpricetheoryamt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.fams_rep_asset t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_rep_asset.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes