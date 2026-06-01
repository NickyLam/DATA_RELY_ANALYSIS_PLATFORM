: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_gsxx_hsj_top_ten_sh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_gsxx_hsj_top_ten_sh.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.ent_name,chr(13),''),chr(10),'') as ent_name
,t.ratio_no as ratio_no
,replace(replace(t.share_holder_name,chr(13),''),chr(10),'') as share_holder_name
,t.ratio as ratio
,t.quantity as quantity
,replace(replace(t.last_date,chr(13),''),chr(10),'') as last_date
,t.jcxx_id as jcxx_id
from iol.ilss_ghb_gsxx_hsj_top_ten_sh t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_gsxx_hsj_top_ten_sh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes