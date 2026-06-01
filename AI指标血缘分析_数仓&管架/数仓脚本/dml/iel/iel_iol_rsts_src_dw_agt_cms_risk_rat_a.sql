: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_src_dw_agt_cms_risk_rat_a
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_src_dw_agt_cms_risk_rat.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,etl_dt_ora
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.risk_rat_categ_cd,chr(13),''),chr(10),'') as risk_rat_categ_cd
,replace(replace(t1.risk_rat_resu_cd,chr(13),''),chr(10),'') as risk_rat_resu_cd
,rat_dt
,replace(replace(t1.rat_org_id,chr(13),''),chr(10),'') as rat_org_id
,replace(replace(t1.rat_oper_emply_id,chr(13),''),chr(10),'') as rat_oper_emply_id
,replace(replace(t1.auto_rat_flg,chr(13),''),chr(10),'') as auto_rat_flg
,replace(replace(t1.aprv_emply_num,chr(13),''),chr(10),'') as aprv_emply_num
,replace(replace(t1.auth_emply_num,chr(13),''),chr(10),'') as auth_emply_num
,replace(replace(t1.adj_emply_num,chr(13),''),chr(10),'') as adj_emply_num
,replace(replace(t1.loan_fifth_modal_chg_rsns,chr(13),''),chr(10),'') as loan_fifth_modal_chg_rsns
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg

from ${iol_schema}.rsts_src_dw_agt_cms_risk_rat t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_src_dw_agt_cms_risk_rat.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
