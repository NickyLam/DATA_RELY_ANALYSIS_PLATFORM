: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_careerinexinfo2013_i
CreateDate: 20241216
FileName:   ${iel_data_path}/cqss_e_r_careerinexinfo2013.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
,fnc_alwc_crrov_srpls
,fnc_alwc_incm
,crer_expn
,crer_crrov_srpls
,crcgy_incm
,crer_incm
,supr_alwc_incm
,aflt_unit_tnov_incm
,oicm
,dntn_incm
,crcgy_expn
,non_fnc_alwc_crer_expn
,tnov_supr_expn
,aflt_unit_alwc_expn
,othexp
,crnprd_oprt_srpls
,oprt_incm
,oprt_expn
,flup_bfrls_afs_oprt_stlmt
,tsyr_non_fnc_crrov_srpls
,non_fnc_crrov
,tsyr_non_fnc_srpls
,pbl_entp_incmtax
,rtrv_spclpps_fnd
,tfrin_crer_fnd
,crt_dt_tm

from ${iol_schema}.cqss_e_r_careerinexinfo2013 t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_careerinexinfo2013.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
