: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_nsr_fjgxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_nsr_fjgxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.fzjgfduuid,chr(13),''),chr(10),'') as fzjgfduuid
,replace(replace(t.fzjghfddjxh,chr(13),''),chr(10),'') as fzjghfddjxh
,replace(replace(t.fzjghfdnsrsbh,chr(13),''),chr(10),'') as fzjghfdnsrsbh
,replace(replace(t.fzjghfdmc,chr(13),''),chr(10),'') as fzjghfdmc
,replace(replace(t.fzjghfddz,chr(13),''),chr(10),'') as fzjghfddz
,replace(replace(t.fzjghfdlxdh,chr(13),''),chr(10),'') as fzjghfdlxdh
,replace(replace(t.yxqq,chr(13),''),chr(10),'') as yxqq
,replace(replace(t.yxqz,chr(13),''),chr(10),'') as yxqz
,replace(replace(t.djxh,chr(13),''),chr(10),'') as djxh
,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t.auth_uuid,chr(13),''),chr(10),'') as auth_uuid
,t.data_syn_time as data_syn_time
from iol.ilss_ghb_nsr_fjgxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_nsr_fjgxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes