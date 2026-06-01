: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_hsgrsvfndpfrcrdbscinf_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_hsgrsvfndpfrcrdbscinf.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.acc_id,chr(13),''),chr(10),'') as acc_id
    ,replace(replace(t.first_py_yrmo,chr(13),''),chr(10),'') as first_py_yrmo
    ,t.emplnum as emplnum
    ,t.hsgrsvfnd_pyf_crdnlt as hsgrsvfnd_pyf_crdnlt
    ,t.rctly_oc_pyf_dt as rctly_oc_pyf_dt
    ,replace(replace(t.hsgrsvfnd_pyt_yrmo,chr(13),''),chr(10),'') as hsgrsvfnd_pyt_yrmo
    ,replace(replace(t.cr_hsgrsvfnd_pyf_stcd,chr(13),''),chr(10),'') as cr_hsgrsvfnd_pyf_stcd
    ,t.acm_ow_amt as acm_ow_amt
    ,replace(replace(t.stat_yrmo,chr(13),''),chr(10),'') as stat_yrmo
    ,t.pyf_rcrd_num as pyf_rcrd_num
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_hsgrsvfndpfrcrdbscinf t
  where to_char(t.crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_hsgrsvfndpfrcrdbscinf.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes