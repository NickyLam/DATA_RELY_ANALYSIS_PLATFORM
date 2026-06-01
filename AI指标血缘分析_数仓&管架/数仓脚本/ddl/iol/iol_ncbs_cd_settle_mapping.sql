/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cd_settle_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cd_settle_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cd_settle_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_settle_mapping(
    tran_type varchar2(10) -- 交易类型
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,mapping_no varchar2(50) -- 银联记账流水文件记账序号
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cd_settle_mapping to ${iml_schema};
grant select on ${iol_schema}.ncbs_cd_settle_mapping to ${icl_schema};
grant select on ${iol_schema}.ncbs_cd_settle_mapping to ${idl_schema};
grant select on ${iol_schema}.ncbs_cd_settle_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cd_settle_mapping is '银联清算映射信息表';
comment on column ${iol_schema}.ncbs_cd_settle_mapping.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cd_settle_mapping.company is '法人';
comment on column ${iol_schema}.ncbs_cd_settle_mapping.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_cd_settle_mapping.mapping_no is '银联记账流水文件记账序号';
comment on column ${iol_schema}.ncbs_cd_settle_mapping.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cd_settle_mapping.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cd_settle_mapping.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cd_settle_mapping.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cd_settle_mapping.etl_timestamp is 'ETL处理时间戳';
