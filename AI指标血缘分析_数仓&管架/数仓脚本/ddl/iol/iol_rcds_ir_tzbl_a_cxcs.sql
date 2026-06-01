/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_a_cxcs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_a_cxcs
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_a_cxcs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_a_cxcs(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,serialno varchar2(40) -- 申请流水号
    ,create_time varchar2(20) -- 创建时间
    ,a_freq_query_24m_ca number(10,0) -- 主申人查询过去24个月信贷审核查询次数
    ,a_freq_query_24m_tot number(10,0) -- 主申人查询过去24个月查询总次数
    ,a_freq_query_12m_ca number(10,0) -- 主申人查询过去12个月信贷审核查询次数
    ,a_freq_query_12m_tot number(10,0) -- 主申人查询过去12个月查询总次数
    ,a_freq_query_3m_ca number(10,0) -- 主申人查询过去3个月信贷审核查询次数
    ,a_freq_query_3m_tot number(10,0) -- 主申人查询过去3个月查询总次数
    ,a_freq_query_6m_ca number(10,0) -- 主申人查询过去6个月信贷审核查询次数
    ,a_freq_query_6m_tot number(10,0) -- 主申人查询过去6个月查询总次数
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_ir_tzbl_a_cxcs to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_cxcs to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_cxcs to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_cxcs to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_a_cxcs is '查询次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.serialno is '申请流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.create_time is '创建时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.a_freq_query_24m_ca is '主申人查询过去24个月信贷审核查询次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.a_freq_query_24m_tot is '主申人查询过去24个月查询总次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.a_freq_query_12m_ca is '主申人查询过去12个月信贷审核查询次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.a_freq_query_12m_tot is '主申人查询过去12个月查询总次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.a_freq_query_3m_ca is '主申人查询过去3个月信贷审核查询次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.a_freq_query_3m_tot is '主申人查询过去3个月查询总次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.a_freq_query_6m_ca is '主申人查询过去6个月信贷审核查询次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.a_freq_query_6m_tot is '主申人查询过去6个月查询总次数';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_tzbl_a_cxcs.etl_timestamp is 'ETL处理时间戳';
