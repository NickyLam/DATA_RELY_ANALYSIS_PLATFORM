: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_nras_pty_indv_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_indv.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,party_id
,lp_id
,indv_en_name
,birth_dt
,birth_addr
,depositr_cate_cd
,party_name
,indv_bus_flg
,indv_bus_cert_no
,nation_cd
,marriage_situ_cd
,nati_place_cd
,resd_status_cd
,nationty_cd
,taxpayer_idtfy_num
,real_name_flg
,tax_resdnt_cty_cd
,tax_resdnt_idti_type_cd
,sm_bus_owner_flg
,sm_bus_owner_cert_no
,sm_bus_owner_cert_type_cd
,gender_cd
,name
,degree_cd
,blood_type_cd
,ctysd_contr_oper_acct_flg
,farm_flg
,have_work_unit_flg
,post_cd
,title_cd
,resdnt_char_cd
,rg_cd
,emply_flg
,dist_cd
,resdnt_flg
,nati_place
,age
,owner_type_cd
,politic_status_cd
,ghb_rela_peop_flg
,health_status_cd
,spoken
,sys_in_cust_flg
,cust_lev_cd
,tax_stament_flg
,indv_party_type_cd
,hxb_post_type_cd
,grad_school
,crdt_cust_flg
,main_type_cd
,tax_num_null_rs_descb from idl.nras_pty_indv where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_indv.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes