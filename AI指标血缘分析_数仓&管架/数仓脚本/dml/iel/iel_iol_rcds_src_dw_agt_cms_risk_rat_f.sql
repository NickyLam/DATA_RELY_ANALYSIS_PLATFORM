: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_src_dw_agt_cms_risk_rat_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_src_dw_agt_cms_risk_rat.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
    ,t.etl_dt_ora as etl_dt_ora
    ,replace(replace(t.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
    ,replace(replace(t.risk_rat_categ_cd,chr(13),''),chr(10),'') as risk_rat_categ_cd
    ,replace(replace(t.risk_rat_resu_cd,chr(13),''),chr(10),'') as risk_rat_resu_cd
    ,t.rat_dt as rat_dt
    ,replace(replace(t.rat_org_id,chr(13),''),chr(10),'') as rat_org_id
    ,replace(replace(t.rat_oper_emply_id,chr(13),''),chr(10),'') as rat_oper_emply_id
    ,replace(replace(t.auto_rat_flg,chr(13),''),chr(10),'') as auto_rat_flg
    ,replace(replace(t.aprv_emply_num,chr(13),''),chr(10),'') as aprv_emply_num
    ,replace(replace(t.auth_emply_num,chr(13),''),chr(10),'') as auth_emply_num
    ,replace(replace(t.adj_emply_num,chr(13),''),chr(10),'') as adj_emply_num
    ,replace(replace(t.loan_fifth_modal_chg_rsns,chr(13),''),chr(10),'') as loan_fifth_modal_chg_rsns
    ,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
    ,replace(replace(t.del_flg,chr(13),''),chr(10),'') as del_flg
from iol.rcds_src_dw_agt_cms_risk_rat t    
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_src_dw_agt_cms_risk_rat.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes