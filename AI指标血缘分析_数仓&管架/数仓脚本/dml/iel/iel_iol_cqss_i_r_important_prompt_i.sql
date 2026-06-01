: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_important_prompt_i
CreateDate: 20241107
FileName:   ${iel_data_path}/cqss_i_r_important_prompt.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.pbc_fnc_inst_ecd,chr(13),''),chr(10),'') as pbc_fnc_inst_ecd
,replace(replace(t1.cr_enqd_ppl_nm,chr(13),''),chr(10),'') as cr_enqd_ppl_nm
,replace(replace(t1.pbc_tngncr_pts_tpcd,chr(13),''),chr(10),'') as pbc_tngncr_pts_tpcd
,replace(replace(t1.crrptenqd_psn_crdt_no,chr(13),''),chr(10),'') as crrptenqd_psn_crdt_no
,replace(replace(t1.idv_impt_prmpt_cd,chr(13),''),chr(10),'') as idv_impt_prmpt_cd
,inf_udt_tm
,crt_dt_tm

from ${iol_schema}.cqss_i_r_important_prompt t1
where to_char(crt_dt_tm,'yyyymmdd') = '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_important_prompt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
