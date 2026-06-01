: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nfss_tcs_tbclientext_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nfss_tcs_tbclientext.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.in_client_no,chr(13),''),chr(10),'') as in_client_no
    ,replace(replace(t.adrtype,chr(13),''),chr(10),'') as adrtype
    ,replace(replace(t.adrsta,chr(13),''),chr(10),'') as adrsta
    ,replace(replace(t.adrcty,chr(13),''),chr(10),'') as adrcty
    ,replace(replace(t.adrsec,chr(13),''),chr(10),'') as adrsec
    ,replace(replace(t.adrdet,chr(13),''),chr(10),'') as adrdet
    ,replace(replace(t.telint,chr(13),''),chr(10),'') as telint
    ,replace(replace(t.telzon,chr(13),''),chr(10),'') as telzon
    ,replace(replace(t.telnum,chr(13),''),chr(10),'') as telnum
    ,replace(replace(t.telext,chr(13),''),chr(10),'') as telext
    ,replace(replace(t.mobint,chr(13),''),chr(10),'') as mobint
    ,replace(replace(t.gzdw,chr(13),''),chr(10),'') as gzdw
    ,replace(replace(t.hy,chr(13),''),chr(10),'') as hy
    ,replace(replace(t.xqah,chr(13),''),chr(10),'') as xqah
    ,replace(replace(t.hyzt,chr(13),''),chr(10),'') as hyzt
    ,replace(replace(t.jrzc,chr(13),''),chr(10),'') as jrzc
    ,replace(replace(t.zzsyq,chr(13),''),chr(10),'') as zzsyq
    ,replace(replace(t.jtgj,chr(13),''),chr(10),'') as jtgj
    ,replace(replace(t.jtkhlx,chr(13),''),chr(10),'') as jtkhlx
    ,replace(replace(t.khsqjb,chr(13),''),chr(10),'') as khsqjb
    ,replace(replace(t.sqjbxgsj,chr(13),''),chr(10),'') as sqjbxgsj
    ,replace(replace(t.zyyw,chr(13),''),chr(10),'') as zyyw
    ,t.nzsr as nzsr
    ,replace(replace(t.zzlx,chr(13),''),chr(10),'') as zzlx
    ,replace(replace(t.ygrs,chr(13),''),chr(10),'') as ygrs
    ,replace(replace(t.zhxgyh,chr(13),''),chr(10),'') as zhxgyh
    ,replace(replace(t.zhxgsj,chr(13),''),chr(10),'') as zhxgsj
    ,replace(replace(t.reserve1,chr(13),''),chr(10),'') as reserve1
    ,replace(replace(t.investor_type,chr(13),''),chr(10),'') as investor_type
    ,replace(replace(t.fold_in_client_no,chr(13),''),chr(10),'') as fold_in_client_no
    ,replace(replace(t.fold_id_type,chr(13),''),chr(10),'') as fold_id_type
    ,replace(replace(t.fold_id_code,chr(13),''),chr(10),'') as fold_id_code
    ,replace(replace(t.modify_flag,chr(13),''),chr(10),'') as modify_flag
    ,t.fdaily_upd_date as fdaily_upd_date
    ,replace(replace(t.other_id_type_name,chr(13),''),chr(10),'') as other_id_type_name
    ,replace(replace(t.fold_client_name,chr(13),''),chr(10),'') as fold_client_name
    ,replace(replace(t.old_other_id_type_name,chr(13),''),chr(10),'') as old_other_id_type_name
    ,replace(replace(t.host_id_type,chr(13),''),chr(10),'') as host_id_type
    ,replace(replace(t.old_host_id_type,chr(13),''),chr(10),'') as old_host_id_type
    ,replace(replace(t.spv_branch,chr(13),''),chr(10),'') as spv_branch
    ,replace(replace(t.other_branch,chr(13),''),chr(10),'') as other_branch
    ,replace(replace(t.spv_account,chr(13),''),chr(10),'') as spv_account
    ,replace(replace(t.reserve2,chr(13),''),chr(10),'') as reserve2
    ,replace(replace(t.reserve3,chr(13),''),chr(10),'') as reserve3
    ,replace(replace(t.reserve4,chr(13),''),chr(10),'') as reserve4
    ,replace(replace(t.reserve5,chr(13),''),chr(10),'') as reserve5
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.nfss_tcs_tbclientext t
  where start_dt <= to_date('${batch_date}','yyyymmdd')
    and end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nfss_tcs_tbclientext.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes