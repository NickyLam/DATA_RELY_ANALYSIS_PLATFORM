/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_bond_rating_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_bond_rating_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_bond_rating_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_bond_rating_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bond_id varchar2(60) -- 债券编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,bond_market_type_cd varchar2(10) -- 债券市场类型代码
    ,rating_corp_id varchar2(60) -- 评级公司编号
    ,rating_corp_cn_name varchar2(750) -- 评级公司中文名称
    ,rating_corp_en_name varchar2(250) -- 评级公司英文名称
    ,bond_name varchar2(750) -- 债券名称
    ,bond_abbr varchar2(375) -- 债券简称
    ,bond_type_cd varchar2(10) -- 债券类型代码
    ,bond_cls_name varchar2(150) -- 债券分类名称
    ,issuer_name varchar2(375) -- 发行人名称
    ,rating_rest_cd varchar2(10) -- 评级结果代码
    ,rating_type_cd varchar2(10) -- 评级类型代码
    ,rating_dt date -- 评级日期
    ,src_sys_idf varchar2(10) -- 来源系统标识
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_bond_rating_info to ${idl_schema};
grant select on ${icl_schema}.cmm_bond_rating_info to ${iel_schema};
grant select on ${icl_schema}.cmm_bond_rating_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_bond_rating_info is '债券评级信息';
comment on column ${icl_schema}.cmm_bond_rating_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_bond_rating_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_bond_rating_info.bond_id is '债券编号';
comment on column ${icl_schema}.cmm_bond_rating_info.asset_type_id is '资产类型编号';
comment on column ${icl_schema}.cmm_bond_rating_info.bond_market_type_cd is '债券市场类型代码';
comment on column ${icl_schema}.cmm_bond_rating_info.rating_corp_id is '评级公司编号';
comment on column ${icl_schema}.cmm_bond_rating_info.rating_corp_cn_name is '评级公司中文名称';
comment on column ${icl_schema}.cmm_bond_rating_info.rating_corp_en_name is '评级公司英文名称';
comment on column ${icl_schema}.cmm_bond_rating_info.bond_name is '债券名称';
comment on column ${icl_schema}.cmm_bond_rating_info.bond_abbr is '债券简称';
comment on column ${icl_schema}.cmm_bond_rating_info.bond_type_cd is '债券类型代码';
comment on column ${icl_schema}.cmm_bond_rating_info.bond_cls_name is '债券分类名称';
comment on column ${icl_schema}.cmm_bond_rating_info.issuer_name is '发行人名称';
comment on column ${icl_schema}.cmm_bond_rating_info.rating_rest_cd is '评级结果代码';
comment on column ${icl_schema}.cmm_bond_rating_info.rating_type_cd is '评级类型代码';
comment on column ${icl_schema}.cmm_bond_rating_info.rating_dt is '评级日期';
comment on column ${icl_schema}.cmm_bond_rating_info.src_sys_idf is '来源系统标识';
comment on column ${icl_schema}.cmm_bond_rating_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_bond_rating_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_bond_rating_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_bond_rating_info.etl_timestamp is 'ETL处理时间戳';
