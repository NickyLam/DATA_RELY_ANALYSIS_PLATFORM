: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_admnpnshrcrd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_admnpnshrcrd.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.cr_inf_id,chr(13),''),chr(10),'') as cr_inf_id
    ,replace(replace(t.inst_nm,chr(13),''),chr(10),'') as inst_nm
    ,replace(replace(t.pnsh_wrtdcs_no,chr(13),''),chr(10),'') as pnsh_wrtdcs_no
    ,replace(replace(t.admnpnshillg_bhvr_dsc,chr(13),''),chr(10),'') as admnpnshillg_bhvr_dsc
    ,replace(replace(t.pnsh_dcd_dsc,chr(13),''),chr(10),'') as pnsh_dcd_dsc
    ,t.cr_admn_pnsh_efdt as cr_admn_pnsh_efdt
    ,t.cr_admn_pnsh_amt as cr_admn_pnsh_amt
    ,replace(replace(t.admn_pnsh_exec_stndsc,chr(13),''),chr(10),'') as admn_pnsh_exec_stndsc
    ,replace(replace(t.cradmnpnshanrcnsdrslt,chr(13),''),chr(10),'') as cradmnpnshanrcnsdrslt
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_admnpnshrcrd t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_admnpnshrcrd.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes