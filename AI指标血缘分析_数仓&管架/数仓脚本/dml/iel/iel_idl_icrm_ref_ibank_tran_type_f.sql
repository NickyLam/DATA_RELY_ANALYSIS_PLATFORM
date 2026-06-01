: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ref_ibank_tran_type_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ref_ibank_tran_type.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select tran_type_id
,lp_id
,tran_type_descb
,ped_instr_cd
,crdt_risk_check_flg
,check_admit_lib_flg
,seq_num
,etl_dt
,job_cd from idl.icrm_ref_ibank_tran_type where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ref_ibank_tran_type.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes