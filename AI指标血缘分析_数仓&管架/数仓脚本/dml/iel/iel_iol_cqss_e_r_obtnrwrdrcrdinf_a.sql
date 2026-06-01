: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_obtnrwrdrcrdinf_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_obtnrwrdrcrdinf.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.cr_inf_id,chr(13),''),chr(10),'') as cr_inf_id
    ,replace(replace(t.rwrd_dept_nm,chr(13),''),chr(10),'') as rwrd_dept_nm
    ,replace(replace(t.rwrd_nm,chr(13),''),chr(10),'') as rwrd_nm
    ,t.awrd_dt as awrd_dt
    ,t.codt as codt
    ,replace(replace(t.rwrd_fct,chr(13),''),chr(10),'') as rwrd_fct
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_obtnrwrdrcrdinf t
  where to_char(t.crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_obtnrwrdrcrdinf.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes