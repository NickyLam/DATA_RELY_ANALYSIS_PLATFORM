: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_bscinf_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_bscinf_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t.pbc_cr_ecn_tpcd,chr(13),''),chr(10),'') as pbc_cr_ecn_tpcd
,replace(replace(t.org_inst_tp,chr(13),''),chr(10),'') as org_inst_tp
,replace(replace(t.pbc_cr_entp_sz,chr(13),''),chr(10),'') as pbc_cr_entp_sz
,replace(replace(t.bliy_cd,chr(13),''),chr(10),'') as bliy_cd
,replace(replace(t.rgs_adr,chr(13),''),chr(10),'') as rgs_adr
,replace(replace(t.fd_yr,chr(13),''),chr(10),'') as fd_yr
,t.lc_avldt_codt as lc_avldt_codt
,replace(replace(t.oprt_adr,chr(13),''),chr(10),'') as oprt_adr
,replace(replace(t.pbc_cr_exstn_st,chr(13),''),chr(10),'') as pbc_cr_exstn_st
,t.cmps_stff_num as cmps_stff_num
,t.cmps_stff_inf_udt_dt as cmps_stff_inf_udt_dt
,t.act_ctrlr_num as act_ctrlr_num
,t.act_ctrlr_inf_udt_dt as act_ctrlr_inf_udt_dt
,t.rgst_cptl as rgst_cptl
,t.main_fndd_psn_num as main_fndd_psn_num
,t.rgstcptlandmfpifudtdt as rgstcptlandmfpifudtdt
,replace(replace(t.pbc_cr_supr_inst_tp,chr(13),''),chr(10),'') as pbc_cr_supr_inst_tp
,replace(replace(t.entp_cr_supr_inst_nm,chr(13),''),chr(10),'') as entp_cr_supr_inst_nm
,replace(replace(t.entpsuprinstidntidrtp,chr(13),''),chr(10),'') as entpsuprinstidntidrtp
,replace(replace(t.supr_inst_idnt_idr_cd,chr(13),''),chr(10),'') as supr_inst_idnt_idr_cd
,t.supr_inst_inf_udt_dt as supr_inst_inf_udt_dt
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_bscinf t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_bscinf_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes