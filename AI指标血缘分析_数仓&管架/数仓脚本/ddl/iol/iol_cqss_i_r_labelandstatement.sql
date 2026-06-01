/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_labelandstatement
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_labelandstatement
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_labelandstatement purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_labelandstatement(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,inf_unit_tp varchar2(45) -- 信息单元类型
    ,annttn_and_sttmnt_tp varchar2(9) -- 标注及声明类型:pd01zd01
    ,annttnor_sttmnt_cntnt varchar2(4000) -- 标注或声明内容:pd01zq01
    ,add_dt date -- 添加日期:pd01zr01
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,crt_dt_tm date -- 创建日期时间
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
grant select on ${iol_schema}.cqss_i_r_labelandstatement to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_labelandstatement to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_labelandstatement to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_labelandstatement to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_labelandstatement is '标注及声明';
comment on column ${iol_schema}.cqss_i_r_labelandstatement.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_labelandstatement.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_labelandstatement.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_labelandstatement.inf_unit_tp is '信息单元类型';
comment on column ${iol_schema}.cqss_i_r_labelandstatement.annttn_and_sttmnt_tp is '标注及声明类型:pd01zd01';
comment on column ${iol_schema}.cqss_i_r_labelandstatement.annttnor_sttmnt_cntnt is '标注或声明内容:pd01zq01';
comment on column ${iol_schema}.cqss_i_r_labelandstatement.add_dt is '添加日期:pd01zr01';
comment on column ${iol_schema}.cqss_i_r_labelandstatement.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_labelandstatement.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_labelandstatement.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_labelandstatement.etl_timestamp is 'ETL处理时间戳';
