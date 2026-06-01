: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_retl_crdt_guar_cont_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_crdt_guar_cont_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.guar_cont_id as guar_cont_id
,t.pri_contr_id as pri_contr_id
,t.brwer_cust_id as brwer_cust_id
,t.and_brwer_rela_cd as and_brwer_rela_cd
,t.guartor_cust_id as guartor_cust_id
,t.guartor_name as guartor_name
,t.cert_id as cert_id
,t.cert_type_cd as cert_type_cd
,t.curr_cd as curr_cd
,t.guar_cont_type_cd as guar_cont_type_cd
,t.guar_cont_status_cd as guar_cont_status_cd
,t.guar_way_cd as guar_way_cd
,t.guar_kind_cd as guar_kind_cd
,t.guar_amt as guar_amt
,t.ocup_amt as ocup_amt
,t.guar_tenor as guar_tenor
,t.guar_start_dt as guar_start_dt
,t.guar_exp_dt as guar_exp_dt
,t.sign_dt as sign_dt
,t.rgst_dt as rgst_dt
,t.modif_dt as modif_dt
,t.applit_id as applit_id
,t.cust_mgr_id as cust_mgr_id
,t.rgst_org_id as rgst_org_id
,t.director_org_id as director_org_id
,t.acct_instit_id as acct_instit_id
,t.pri_contr_type_cd as pri_contr_type_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_retl_crdt_guar_cont t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_crdt_guar_cont_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes