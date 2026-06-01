: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_fx_cap_cntpty_f
CreateDate: 20230629
FileName:   ${iel_data_path}/pty_fx_cap_cntpty.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.cn_name,chr(13),''),chr(10),'') as cn_name
,replace(replace(t1.en_name,chr(13),''),chr(10),'') as en_name
,replace(replace(t1.cn_abbr,chr(13),''),chr(10),'') as cn_abbr
,replace(replace(t1.en_abbr,chr(13),''),chr(10),'') as en_abbr
,replace(replace(t1.fx_id,chr(13),''),chr(10),'') as fx_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.cntpty_ibank_type,chr(13),''),chr(10),'') as cntpty_ibank_type

from ${iml_schema}.pty_fx_cap_cntpty t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_fx_cap_cntpty.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
