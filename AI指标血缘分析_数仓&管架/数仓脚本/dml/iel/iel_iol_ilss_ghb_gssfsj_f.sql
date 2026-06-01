: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_gssfsj_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_gssfsj.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.jcxx_id as jcxx_id
,replace(replace(t.gssfjg,chr(13),''),chr(10),'') as gssfjg
,replace(replace(t.msg,chr(13),''),chr(10),'') as msg
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.illegal,chr(13),''),chr(10),'') as illegal
,replace(replace(t.faith,chr(13),''),chr(10),'') as faith
,replace(replace(t.listedcompany,chr(13),''),chr(10),'') as listedcompany
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
from iol.ilss_ghb_gssfsj t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_gssfsj.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes