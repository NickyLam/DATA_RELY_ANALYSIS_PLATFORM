: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_batch_dig_main_a
CreateDate: 20241107
FileName:   ${iel_data_path}/cqss_i_r_batch_dig_main.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,tsk_seq_no
,inf_rcrd_idr_no
,replace(replace(t1.rslt_cd,chr(13),''),chr(10),'') as rslt_cd
,replace(replace(t1.enqr_rslt_dsc,chr(13),''),chr(10),'') as enqr_rslt_dsc
,replace(replace(t1.pbc_fnc_inst_ecd,chr(13),''),chr(10),'') as pbc_fnc_inst_ecd
,replace(replace(t1.itt_psn,chr(13),''),chr(10),'') as itt_psn
,replace(replace(t1.cr_enqd_ppl_nm,chr(13),''),chr(10),'') as cr_enqd_ppl_nm
,replace(replace(t1.pbc_tngncr_pts_tpcd,chr(13),''),chr(10),'') as pbc_tngncr_pts_tpcd
,replace(replace(t1.crrptenqd_psn_crdt_no,chr(13),''),chr(10),'') as crrptenqd_psn_crdt_no
,replace(replace(t1.pbc_enqr_rscd,chr(13),''),chr(10),'') as pbc_enqr_rscd
,replace(replace(t1.rel_svc_cd,chr(13),''),chr(10),'') as rel_svc_cd
,pd_dt
,replace(replace(t1.digtiptn_enqr_rslt_tp,chr(13),''),chr(10),'') as digtiptn_enqr_rslt_tp
,pbc_digt_iptn
,aft_num
,rel_lo
,clc_dt
,crt_dt_tm

from ${iol_schema}.cqss_i_r_batch_dig_main t1
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_batch_dig_main.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
