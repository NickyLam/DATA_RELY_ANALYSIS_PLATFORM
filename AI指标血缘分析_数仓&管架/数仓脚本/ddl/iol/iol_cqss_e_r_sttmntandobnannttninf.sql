/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_sttmntandobnannttninf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_sttmntandobnannttninf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_sttmntandobnannttninf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_sttmntandobnannttninf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,obj_tp varchar2(9) -- 对象类型:ei010d01
    ,obj_idr varchar2(11) -- 对象标识:ei010i01
    ,annttn_and_sttmnt_tp varchar2(9) -- 标注及声明类型:ei010d02
    ,annttnor_sttmnt_cntnt varchar2(4000) -- 标注或声明内容:ei010q01
    ,add_dt date -- 添加日期:ei010r01
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
grant select on ${iol_schema}.cqss_e_r_sttmntandobnannttninf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_sttmntandobnannttninf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_sttmntandobnannttninf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_sttmntandobnannttninf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_sttmntandobnannttninf is '声明及异议标注信息';
comment on column ${iol_schema}.cqss_e_r_sttmntandobnannttninf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_sttmntandobnannttninf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_sttmntandobnannttninf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_sttmntandobnannttninf.obj_tp is '对象类型:ei010d01';
comment on column ${iol_schema}.cqss_e_r_sttmntandobnannttninf.obj_idr is '对象标识:ei010i01';
comment on column ${iol_schema}.cqss_e_r_sttmntandobnannttninf.annttn_and_sttmnt_tp is '标注及声明类型:ei010d02';
comment on column ${iol_schema}.cqss_e_r_sttmntandobnannttninf.annttnor_sttmnt_cntnt is '标注或声明内容:ei010q01';
comment on column ${iol_schema}.cqss_e_r_sttmntandobnannttninf.add_dt is '添加日期:ei010r01';
comment on column ${iol_schema}.cqss_e_r_sttmntandobnannttninf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_sttmntandobnannttninf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_sttmntandobnannttninf.etl_timestamp is 'ETL处理时间戳';
