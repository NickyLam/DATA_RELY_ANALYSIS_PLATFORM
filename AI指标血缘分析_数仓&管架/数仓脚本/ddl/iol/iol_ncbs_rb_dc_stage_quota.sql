/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_stage_quota
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_stage_quota
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_stage_quota purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_quota(
    individual_flag varchar2(1) -- 对公对私标志
    ,stage_code varchar2(50) -- 期次代码
    ,issue_year varchar2(5) -- 发行年度
    ,branch varchar2(12) -- 交易机构编号
    ,ccy varchar2(3) -- 币种
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
    ,tran_date date -- 交易日期
    ,user_id varchar2(8) -- 交易柜员编号
    ,distribute_quota number(17,2) -- 已分配额度
    ,holding_quota number(17,2) -- 占用额度
    ,total_quota number(17,2) -- 总额度
    ,parent_quota_class varchar2(50) -- 上级额度类型
    ,leave_quota number(17,2) -- 剩余额度
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
grant select on ${iol_schema}.ncbs_rb_dc_stage_quota to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_quota to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_quota to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_quota to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_stage_quota is '大额存单期次额度表';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.issue_year is '发行年度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.branch is '交易机构编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.distribute_quota is '已分配额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.holding_quota is '占用额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.total_quota is '总额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.parent_quota_class is '上级额度类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.leave_quota is '剩余额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_quota.etl_timestamp is 'ETL处理时间戳';
