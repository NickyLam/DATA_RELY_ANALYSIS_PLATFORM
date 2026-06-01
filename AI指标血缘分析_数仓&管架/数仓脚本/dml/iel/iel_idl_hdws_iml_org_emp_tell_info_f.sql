: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_org_emp_tell_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_org_emp_tell_infof.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.tell_id
,t.etl_dt
,t.tell_typ_cd
,t.tell_status_cd
,t.tell_user_level_cd
,t.tell_perm_level_cd
,t.blng_org_id
,t.post_id
,t.posts_dt
,t.cust_mgr_flg
,t.entt_tell_flg
,t.syn_tell_flg
,t.super_tell_flg
,t.oper_acct_flg
,t.perm_mgmt_flg
,t.comn_mgmt_flg
,t.cms_person_flg
,t.librarian_flg
,t.auth_flg
,t.auth_scope
,t.data_src_cd
from idl.hdws_iml_org_emp_tell_info t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_org_emp_tell_infof.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes