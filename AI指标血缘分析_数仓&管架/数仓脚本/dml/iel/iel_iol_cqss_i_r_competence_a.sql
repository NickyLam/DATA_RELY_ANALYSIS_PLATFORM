: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_competence_a
CreateDate: 20241111
FileName:   ${iel_data_path}/cqss_i_r_competence.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.cr_ocp_qua_nm,chr(13),''),chr(10),'') as cr_ocp_qua_nm
    ,replace(replace(t.inst_nm,chr(13),''),chr(10),'') as inst_nm
    ,replace(replace(t.cr_ocp_qua_grd_cd,chr(13),''),chr(10),'') as cr_ocp_qua_grd_cd
    ,replace(replace(t.cr_ocp_qua_inst_lo,chr(13),''),chr(10),'') as cr_ocp_qua_inst_lo
    ,replace(replace(t.cr_ocp_qua_obtn_yrmo,chr(13),''),chr(10),'') as cr_ocp_qua_obtn_yrmo
    ,replace(replace(t.cr_ocp_qua_exp_yrmo,chr(13),''),chr(10),'') as cr_ocp_qua_exp_yrmo
    ,replace(replace(t.cr_ocp_qua_lout_yrmo,chr(13),''),chr(10),'') as cr_ocp_qua_lout_yrmo
    ,t.annttn_and_sttmnt_num as annttn_and_sttmnt_num
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_competence t
  where to_char(t.crt_dt_tm,'yyyymmdd')<='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_competence.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes