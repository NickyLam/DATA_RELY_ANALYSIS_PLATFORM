: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_important_prompt_i
CreateDate: 20241216
FileName:   ${iel_data_path}/cqss_e_r_important_prompt.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.pbc_fnc_inst_ecd,chr(13),''),chr(10),'') as pbc_fnc_inst_ecd
,replace(replace(t1.entp_idnt_idr_tp,chr(13),''),chr(10),'') as entp_idnt_idr_tp
,replace(replace(t1.entp_idnt_idr_no,chr(13),''),chr(10),'') as entp_idnt_idr_no
,replace(replace(t1.entp_impt_prmpt_cd,chr(13),''),chr(10),'') as entp_impt_prmpt_cd
,inf_udt_tm
,crt_dt_tm

from ${iol_schema}.cqss_e_r_important_prompt t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_important_prompt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
