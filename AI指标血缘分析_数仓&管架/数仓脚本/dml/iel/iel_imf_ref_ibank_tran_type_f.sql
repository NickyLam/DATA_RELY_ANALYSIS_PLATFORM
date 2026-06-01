: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_ibank_tran_type_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_ibank_tran_type.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tran_type_id,chr(13),''),chr(10),'') as tran_type_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_type_descb,chr(13),''),chr(10),'') as tran_type_descb
,replace(replace(t1.ped_instr_cd,chr(13),''),chr(10),'') as ped_instr_cd
,replace(replace(t1.crdt_risk_check_flg,chr(13),''),chr(10),'') as crdt_risk_check_flg
,replace(replace(t1.check_admit_lib_flg,chr(13),''),chr(10),'') as check_admit_lib_flg
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,create_dt
,update_dt

from ${iml_schema}.ref_ibank_tran_type t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_ibank_tran_type.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
