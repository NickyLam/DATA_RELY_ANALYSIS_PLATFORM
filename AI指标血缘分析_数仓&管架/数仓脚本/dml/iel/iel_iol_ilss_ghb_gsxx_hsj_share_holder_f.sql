: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_gsxx_hsj_share_holder_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_gsxx_hsj_share_holder.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.ent_name,chr(13),''),chr(10),'') as ent_name
,replace(replace(t.share_holder_name,chr(13),''),chr(10),'') as share_holder_name
,replace(replace(t.share_holder_type,chr(13),''),chr(10),'') as share_holder_type
,replace(replace(t.blic_type,chr(13),''),chr(10),'') as blic_type
,replace(replace(t.blic_no,chr(13),''),chr(10),'') as blic_no
,t.sub_conam as sub_conam
,replace(replace(t.sub_currency,chr(13),''),chr(10),'') as sub_currency
,replace(replace(t.con_date,chr(13),''),chr(10),'') as con_date
,t.funded_ratio as funded_ratio
,replace(replace(t.country,chr(13),''),chr(10),'') as country
,t.jcxx_id as jcxx_id
from iol.ilss_ghb_gsxx_hsj_share_holder t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_gsxx_hsj_share_holder.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes