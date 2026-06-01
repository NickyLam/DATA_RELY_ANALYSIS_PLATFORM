/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_otherlabelandstatement
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_otherlabelandstatement
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_otherlabelandstatement purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_otherlabelandstatement(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,obj_tp varchar2(9) -- 对象类型:pg010d01
    ,obj_idr varchar2(9) -- 对象标识:pg010d02
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数:pg010s01
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
grant select on ${iol_schema}.cqss_i_r_otherlabelandstatement to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_otherlabelandstatement to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_otherlabelandstatement to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_otherlabelandstatement to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_otherlabelandstatement is '其他标注及声明信息';
comment on column ${iol_schema}.cqss_i_r_otherlabelandstatement.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_otherlabelandstatement.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_otherlabelandstatement.obj_tp is '对象类型:pg010d01';
comment on column ${iol_schema}.cqss_i_r_otherlabelandstatement.obj_idr is '对象标识:pg010d02';
comment on column ${iol_schema}.cqss_i_r_otherlabelandstatement.annttn_and_sttmnt_num is '标注及声明个数:pg010s01';
comment on column ${iol_schema}.cqss_i_r_otherlabelandstatement.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_otherlabelandstatement.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_otherlabelandstatement.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_otherlabelandstatement.etl_timestamp is 'ETL处理时间戳';
