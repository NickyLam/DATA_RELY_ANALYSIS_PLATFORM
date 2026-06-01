/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_pty_party_cert_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_pty_party_cert_info_h
whenever sqlerror continue none;
drop table ${idl_schema}.aml_pty_party_cert_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_pty_party_cert_info_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,sorc_sys_cd varchar2(10) -- 源系统代码
    ,cert_type_cd varchar2(10) -- 证件类型代码
    ,start_dt date -- 开始日期
    ,cert_num varchar2(60) -- 证件号码
    ,cert_addr varchar2(100) -- 证件地址
    ,issue_cert_org varchar2(100) -- 发证机关
    ,issue_cert_org_cty_cd varchar2(10) -- 发证机关国家代码
    ,cert_effect_dt date -- 证件生效日期
    ,cert_invalid_dt date -- 证件失效日期
    ,licen_issue_autho_dist_cd varchar2(10) -- 发证机关行政区划代码
    ,crdt_cd_cert_id varchar2(60) -- 信用代码证编号
    ,cert_valid_flg varchar2(10) -- 证件有效标志
    ,cert_status_cd varchar2(10) -- 证件状态代码
    ,main_cert_no_flg varchar2(10) -- 主证件号标志
    ,end_dt date -- 结束日期
    ,id_mark varchar2(10) -- 删除标识
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
    ,etl_dt date -- ETL处理日期
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_pty_party_cert_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_pty_party_cert_info_h is '当事人证件信息历史';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.party_id is '当事人编号';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.lp_id is '法人编号';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.sorc_sys_cd is '源系统代码';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.start_dt is '开始日期';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.cert_num is '证件号码';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.cert_addr is '证件地址';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.issue_cert_org is '发证机关';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.issue_cert_org_cty_cd is '发证机关国家代码';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.cert_effect_dt is '证件生效日期';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.cert_invalid_dt is '证件失效日期';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.licen_issue_autho_dist_cd is '发证机关行政区划代码';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.crdt_cd_cert_id is '信用代码证编号';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.cert_valid_flg is '证件有效标志';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.cert_status_cd is '证件状态代码';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.main_cert_no_flg is '主证件号标志';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.end_dt is '结束日期';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.id_mark is '删除标识';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.src_table_name is '源表名称';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.job_cd is '任务代码';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.etl_timestamp is '数据处理时间';
comment on column ${idl_schema}.aml_pty_party_cert_info_h.etl_dt is 'ETL处理日期';