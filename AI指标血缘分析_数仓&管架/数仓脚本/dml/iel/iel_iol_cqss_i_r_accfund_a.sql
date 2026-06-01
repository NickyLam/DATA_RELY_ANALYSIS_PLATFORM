: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_accfund_a
CreateDate: 20241111
FileName:   ${iel_data_path}/cqss_i_r_accfund.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.crprvdfnd_pcp_pyf_adr,chr(13),''),chr(10),'') as crprvdfnd_pcp_pyf_adr
    ,t.cr_prvdfnd_pcp_pyf_dt as cr_prvdfnd_pcp_pyf_dt
    ,replace(replace(t.cr_hsgrsvfnd_pyf_stcd,chr(13),''),chr(10),'') as cr_hsgrsvfnd_pyf_stcd
    ,replace(replace(t.crprvdfnd_ftm_pymt_dt,chr(13),''),chr(10),'') as crprvdfnd_ftm_pymt_dt
    ,replace(replace(t.hsgrsvfnd_pyt_yrmo,chr(13),''),chr(10),'') as hsgrsvfnd_pyt_yrmo
    ,t.prvdfndunit_depd_pctg as prvdfndunit_depd_pctg
    ,t.prvdfnd_idv_depd_pctg as prvdfnd_idv_depd_pctg
    ,t.cr_prvdfnd_mo_pym_amt as cr_prvdfnd_mo_pym_amt
    ,replace(replace(t.prvdfnd_unit_nm,chr(13),''),chr(10),'') as prvdfnd_unit_nm
    ,t.cr_inf_udt_dt as cr_inf_udt_dt
    ,t.annttn_and_sttmnt_num as annttn_and_sttmnt_num
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_accfund t
  where to_char(t.crt_dt_tm,'yyyymmdd')<='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_accfund.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes