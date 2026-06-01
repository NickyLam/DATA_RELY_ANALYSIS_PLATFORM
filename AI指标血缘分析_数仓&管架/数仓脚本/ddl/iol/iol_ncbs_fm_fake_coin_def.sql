/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_fake_coin_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_fake_coin_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_fake_coin_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_fake_coin_def(
    ccy varchar2(3) -- 币种
    ,bond_name varchar2(50) -- 券别名称
    ,bond_number number(5) -- 套数
    ,bond_type_id varchar2(30) -- 国债券别代码
    ,bond_version_num varchar2(20) -- 版别
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,bond_notes number(17,2) -- 面额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_fm_fake_coin_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_fake_coin_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_fake_coin_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_fake_coin_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_fake_coin_def is '劵别信息表';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.ccy is '币种';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.bond_name is '券别名称';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.bond_number is '套数';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.bond_type_id is '国债券别代码';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.bond_version_num is '版别';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.company is '法人';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.bond_notes is '面额';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_fake_coin_def.etl_timestamp is 'ETL处理时间戳';
