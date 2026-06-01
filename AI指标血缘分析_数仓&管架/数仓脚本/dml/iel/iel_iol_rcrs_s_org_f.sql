: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_s_org_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_s_org.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.organno,chr(13),''),chr(10),'') as organno
    ,replace(replace(t.suporganno,chr(13),''),chr(10),'') as suporganno
    ,replace(replace(t.locate,chr(13),''),chr(10),'') as locate
    ,replace(replace(t.organname,chr(13),''),chr(10),'') as organname
    ,replace(replace(t.organshortform,chr(13),''),chr(10),'') as organshortform
    ,replace(replace(t.enname,chr(13),''),chr(10),'') as enname
    ,t.orderno as orderno
    ,replace(replace(t.distno,chr(13),''),chr(10),'') as distno
    ,replace(replace(t.launchdate,chr(13),''),chr(10),'') as launchdate
    ,t.organlevel as organlevel
    ,replace(replace(t.fincode,chr(13),''),chr(10),'') as fincode
    ,t.state as state
    ,replace(replace(t.organchief,chr(13),''),chr(10),'') as organchief
    ,replace(replace(t.telnum,chr(13),''),chr(10),'') as telnum
    ,replace(replace(t.address,chr(13),''),chr(10),'') as address
    ,replace(replace(t.postcode,chr(13),''),chr(10),'') as postcode
    ,replace(replace(t.control,chr(13),''),chr(10),'') as control
    ,replace(replace(t.arti_organno,chr(13),''),chr(10),'') as arti_organno
    ,replace(replace(t.distname,chr(13),''),chr(10),'') as distname
    ,replace(replace(t.area_dev_cate_type,chr(13),''),chr(10),'') as area_dev_cate_type
    ,replace(replace(t.areacode,chr(13),''),chr(10),'') as areacode
    ,replace(replace(t.area_ind,chr(13),''),chr(10),'') as area_ind
    ,replace(replace(t.buz_org_type,chr(13),''),chr(10),'') as buz_org_type
    ,replace(replace(t.is_report_org_flg,chr(13),''),chr(10),'') as is_report_org_flg
    ,replace(replace(t.report_organno,chr(13),''),chr(10),'') as report_organno
    ,replace(replace(t.rep_locate,chr(13),''),chr(10),'') as rep_locate
    ,replace(replace(t.isfingercheck,chr(13),''),chr(10),'') as isfingercheck
    ,replace(replace(t.iszccz,chr(13),''),chr(10),'') as iszccz
    ,replace(replace(t.isxybj,chr(13),''),chr(10),'') as isxybj
    ,replace(replace(t.isxylx,chr(13),''),chr(10),'') as isxylx
    ,replace(replace(t.is_adjust_scale,chr(13),''),chr(10),'') as is_adjust_scale
    ,replace(replace(t.is_change_prd,chr(13),''),chr(10),'') as is_change_prd
    ,replace(replace(t.is_cp_org_flg,chr(13),''),chr(10),'') as is_cp_org_flg
    ,replace(replace(t.org_type,chr(13),''),chr(10),'') as org_type
    ,replace(replace(t.is_cred_org_flg,chr(13),''),chr(10),'') as is_cred_org_flg
    ,replace(replace(t.is_zh_flg,chr(13),''),chr(10),'') as is_zh_flg
    ,replace(replace(t.oid,chr(13),''),chr(10),'') as oid
    ,replace(replace(t.bank_no,chr(13),''),chr(10),'') as bank_no
    ,replace(replace(t.entfincode,chr(13),''),chr(10),'') as entfincode
    ,replace(replace(t.is_fina_br,chr(13),''),chr(10),'') as is_fina_br
    ,replace(replace(t.is_solid_duty,chr(13),''),chr(10),'') as is_solid_duty
    ,replace(replace(t.last_upd_date,chr(13),''),chr(10),'') as last_upd_date
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_s_org t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_s_org.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes