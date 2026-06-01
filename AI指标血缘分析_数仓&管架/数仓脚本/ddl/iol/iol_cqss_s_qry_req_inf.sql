/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_s_qry_req_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_s_qry_req_inf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_s_qry_req_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_s_qry_req_inf(
    qry_req_id varchar2(64) -- 
    ,biz_elmt_val varchar2(128) -- 
    ,ent_idt_tp varchar2(4) -- 
    ,ent_idt_no varchar2(240) -- 
    ,ent_nm nvarchar2(1000) -- 
    ,ind_idt_tp varchar2(4) -- 
    ,ind_idt_no varchar2(240) -- 
    ,ind_nm nvarchar2(1000) -- 
    ,pbc_qry_rscd varchar2(12) -- 
    ,qry_stgy varchar2(2) -- 
    ,qry_user_id varchar2(128) -- 
    ,qry_user_nm nvarchar2(200) -- 
    ,user_office_id varchar2(128) -- 
    ,user_office_nm nvarchar2(400) -- 
    ,qry_office_id varchar2(128) -- 
    ,qry_office_nm nvarchar2(400) -- 
    ,app_user_id varchar2(128) -- 
    ,app_user_nm nvarchar2(200) -- 
    ,app_office_id varchar2(128) -- 
    ,app_office_nm nvarchar2(400) -- 
    ,pbc_org_cd varchar2(40) -- 
    ,pbc_usr varchar2(128) -- 
    ,qry_req_tm date -- 
    ,qry_res_tm date -- 
    ,failed_qry_tm date -- 
    ,qry_rslt_cd varchar2(24) -- 
    ,qry_rslt_desc nvarchar2(200) -- 
    ,result_type varchar2(24) -- 
    ,result_desc nvarchar2(200) -- 
    ,msgidno varchar2(70) -- 
    ,qry_st varchar2(2) -- 
    ,src_sys_cd varchar2(20) -- 
    ,dt_src_tp varchar2(2) -- 
    ,ori_rsp_msg varchar2(4000) -- 
    ,score varchar2(20) -- 
    ,position varchar2(20) -- 
    ,score_time date -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cqss_s_qry_req_inf to ${iml_schema};
grant select on ${iol_schema}.cqss_s_qry_req_inf to ${icl_schema};
grant select on ${iol_schema}.cqss_s_qry_req_inf to ${idl_schema};
grant select on ${iol_schema}.cqss_s_qry_req_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_s_qry_req_inf is '小微企业评分卡查询记录';
comment on column ${iol_schema}.cqss_s_qry_req_inf.qry_req_id is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.biz_elmt_val is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.ent_idt_tp is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.ent_idt_no is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.ent_nm is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.ind_idt_tp is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.ind_idt_no is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.ind_nm is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.pbc_qry_rscd is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.qry_stgy is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.qry_user_id is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.qry_user_nm is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.user_office_id is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.user_office_nm is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.qry_office_id is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.qry_office_nm is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.app_user_id is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.app_user_nm is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.app_office_id is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.app_office_nm is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.pbc_org_cd is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.pbc_usr is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.qry_req_tm is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.qry_res_tm is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.failed_qry_tm is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.qry_rslt_cd is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.qry_rslt_desc is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.result_type is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.result_desc is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.msgidno is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.qry_st is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.src_sys_cd is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.dt_src_tp is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.ori_rsp_msg is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.score is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.position is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.score_time is '';
comment on column ${iol_schema}.cqss_s_qry_req_inf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_s_qry_req_inf.etl_timestamp is 'ETL处理时间戳';
