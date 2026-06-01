: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_e_r_infsmy_i
CreateDate: 20250703
FileName:   ${iel_data_path}/cqss_e_r_infsmy.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.ftm_ext_crln_txn_s_yr,chr(13),''),chr(10),'') as ftm_ext_crln_txn_s_yr
,replace(replace(t1.ftmextrelrepyrspls_yr,chr(13),''),chr(10),'') as ftmextrelrepyrspls_yr
,hpncrlntxn_s_inst_num
,crnotclsg_ln_inst_num
,dbtcr_txn_bal
,berec_s_dbtcr_txn_bal
,fcs_cgy_dbtcr_txn_bal
,bad_cgy_dbtcr_txn_bal
,wrnt_txn_bal_bal
,fcs_cgy_wrnt_txn_bal
,bad_cgy_wrnt_txn_bal
,noncr_tnac_num
,ow_tax_rcrd_num
,cvl_jdgmt_rcrd_num
,efrcexe_rcrd_num
,admn_pnsh_rcrd_num
,notclsgwrttclsentrnum
,alrdyclsgwtclsentrnum
,dbtcrtxnrelrrspltpnum
,wrnttxnrelryrspltpnum
,hist_lby_mo_num
,crt_dt_tm

from ${iol_schema}.cqss_e_r_infsmy t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_infsmy.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
