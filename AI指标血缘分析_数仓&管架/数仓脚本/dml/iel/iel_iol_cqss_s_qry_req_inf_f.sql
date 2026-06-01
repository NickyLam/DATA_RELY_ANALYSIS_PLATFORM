: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_s_qry_req_inf_f
CreateDate: 20250923
FileName:   ${iel_data_path}/cqss_s_qry_req_inf.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.qry_req_id,chr(13),''),chr(10),'') as qry_req_id
,replace(replace(t1.biz_elmt_val,chr(13),''),chr(10),'') as biz_elmt_val
,replace(replace(t1.ent_idt_tp,chr(13),''),chr(10),'') as ent_idt_tp
,replace(replace(t1.ent_idt_no,chr(13),''),chr(10),'') as ent_idt_no
,replace(replace(t1.ent_nm,chr(13),''),chr(10),'') as ent_nm
,replace(replace(t1.ind_idt_tp,chr(13),''),chr(10),'') as ind_idt_tp
,replace(replace(t1.ind_idt_no,chr(13),''),chr(10),'') as ind_idt_no
,replace(replace(t1.ind_nm,chr(13),''),chr(10),'') as ind_nm
,replace(replace(t1.pbc_qry_rscd,chr(13),''),chr(10),'') as pbc_qry_rscd
,replace(replace(t1.qry_stgy,chr(13),''),chr(10),'') as qry_stgy
,replace(replace(t1.qry_user_id,chr(13),''),chr(10),'') as qry_user_id
,replace(replace(t1.qry_user_nm,chr(13),''),chr(10),'') as qry_user_nm
,replace(replace(t1.user_office_id,chr(13),''),chr(10),'') as user_office_id
,replace(replace(t1.user_office_nm,chr(13),''),chr(10),'') as user_office_nm
,replace(replace(t1.qry_office_id,chr(13),''),chr(10),'') as qry_office_id
,replace(replace(t1.qry_office_nm,chr(13),''),chr(10),'') as qry_office_nm
,replace(replace(t1.app_user_id,chr(13),''),chr(10),'') as app_user_id
,replace(replace(t1.app_user_nm,chr(13),''),chr(10),'') as app_user_nm
,replace(replace(t1.app_office_id,chr(13),''),chr(10),'') as app_office_id
,replace(replace(t1.app_office_nm,chr(13),''),chr(10),'') as app_office_nm
,replace(replace(t1.pbc_org_cd,chr(13),''),chr(10),'') as pbc_org_cd
,replace(replace(t1.pbc_usr,chr(13),''),chr(10),'') as pbc_usr
,qry_req_tm
,qry_res_tm
,failed_qry_tm
,replace(replace(t1.qry_rslt_cd,chr(13),''),chr(10),'') as qry_rslt_cd
,replace(replace(t1.qry_rslt_desc,chr(13),''),chr(10),'') as qry_rslt_desc
,replace(replace(t1.result_type,chr(13),''),chr(10),'') as result_type
,replace(replace(t1.result_desc,chr(13),''),chr(10),'') as result_desc
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.qry_st,chr(13),''),chr(10),'') as qry_st
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,replace(replace(t1.dt_src_tp,chr(13),''),chr(10),'') as dt_src_tp
,replace(replace(t1.ori_rsp_msg,chr(13),''),chr(10),'') as ori_rsp_msg
,replace(replace(t1.score,chr(13),''),chr(10),'') as score
,replace(replace(t1.position,chr(13),''),chr(10),'') as position
,score_time

from ${iol_schema}.cqss_s_qry_req_inf t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_s_qry_req_inf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
