/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_fund_risk_pct_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_fund_risk_pct_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_fund_risk_pct_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fund_risk_pct_info_h(
    lp_id varchar2(60) -- 法人编号
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,market_type_id varchar2(100) -- 市场类型编号
    ,risk_pct_id varchar2(100) -- 风险占比编号
    ,asset_name varchar2(750) -- 资产名称
    ,wt number(30,8) -- 权重
    ,pct number(30,8) -- 占比
    ,effect_dt date -- 生效日期
    ,effect_flg varchar2(30) -- 生效标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_fund_risk_pct_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_fund_risk_pct_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_fund_risk_pct_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_fund_risk_pct_info_h is '基金风险占比信息历史';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.risk_pct_id is '风险占比编号';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.asset_name is '资产名称';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.wt is '权重';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.pct is '占比';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.effect_flg is '生效标志';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_fund_risk_pct_info_h.etl_timestamp is 'ETL处理时间戳';
