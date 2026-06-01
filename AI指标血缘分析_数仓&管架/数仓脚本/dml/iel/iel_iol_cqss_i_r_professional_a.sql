: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_professional_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_professional.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.pbc_cr_emp_sttn,chr(13),''),chr(10),'') as pbc_cr_emp_sttn
    ,replace(replace(t.wrk_unit_nm,chr(13),''),chr(10),'') as wrk_unit_nm
    ,replace(replace(t.pbc_cr_unit_char,chr(13),''),chr(10),'') as pbc_cr_unit_char
    ,replace(replace(t.idy_cd,chr(13),''),chr(10),'') as idy_cd
    ,replace(replace(t.cr_rsdnc_adr,chr(13),''),chr(10),'') as cr_rsdnc_adr
    ,replace(replace(t.move_telno,chr(13),''),chr(10),'') as move_telno
    ,replace(replace(t.pbc_cr_ocp,chr(13),''),chr(10),'') as pbc_cr_ocp
    ,replace(replace(t.pbc_cr_post,chr(13),''),chr(10),'') as pbc_cr_post
    ,replace(replace(t.pbc_cr_ttl,chr(13),''),chr(10),'') as pbc_cr_ttl
    ,t.entr_crnco_wkdy_prd as entr_crnco_wkdy_prd
    ,t.cr_inf_udt_dt as cr_inf_udt_dt
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_professional t
  where to_char(t.crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_professional.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes