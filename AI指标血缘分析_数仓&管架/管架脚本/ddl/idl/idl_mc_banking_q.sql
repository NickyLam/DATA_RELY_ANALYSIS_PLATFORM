/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_banking_q
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_banking_q
whenever sqlerror continue none;
drop table ${idl_schema}.mc_banking_q purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_banking_q(
     etl_dt  DATE                                   -- 数据日期 
    ,wind_code  VARCHAR2(10)                        -- 万德ID 
    ,banking_name  VARCHAR2(30)                     -- 银行名称 
    ,banking_sort  VARCHAR2(6)                      -- 银行性质分类 
    ,banking_ipo  VARCHAR2(30)                      -- 银行上市分类 
    ,index_no  VARCHAR2(12)                         -- 指标编码 
    ,index_name  VARCHAR2(30)                       -- 指标名称 
    ,index_value  NUMBER(38,6)                      -- 指标值 
    ,accu_index_value  NUMBER(38,6)                 -- 累计值 
    ,rate_up_day  NUMBER(38,6)                      -- 比上日 
    ,rate_last_month  NUMBER(38,6)                  -- 比上月 
    ,rate_last_year  NUMBER(38,6)                   -- 比上年 
    ,rate_last_period  VARCHAR2(30)                 -- 比同期 
    ,rate_up_day_per  NUMBER(38,6)                  -- 比上日百分比 
    ,rate_last_month_per  NUMBER(38,6)              -- 比上月百分比 
    ,rate_last_year_per  NUMBER(38,6)               -- 比上年百分比 
    ,rate_last_period_per  NUMBER(38,6)              -- 比同期百分比 
    ,index_ranking_ccb  NUMBER(10,0)                 -- 当前排名_城商行 
    ,index_ranking_cha_ccb  NUMBER(10,0)             -- 排名变动_城商行 
    ,index_value_avg_ccb  NUMBER(10,0)               -- 均值_城商行 
    ,index_value_total_ccb  NUMBER(38,6)             -- 总计_城商行 
    ,index_ranking_jsb  NUMBER(10,0)                 -- 当前排名_股份制 
    ,index_ranking_cha_jsb  NUMBER(10,0)             -- 排名变动_股份制 
    ,index_value_avg_jsb  NUMBER(10,0)               -- 均值_股份制 
    ,index_value_total_jsb  NUMBER(38,6)            -- 总计_股份制 
    ,index_ranking_banking  NUMBER(10,0)             -- 当前排名_银行业 
    ,index_ranking_cha_banking  NUMBER(10,0)         -- 排名变动_银行业 
    ,index_value_avg_banking  NUMBER(10,0)           -- 均值_银行业 
    ,index_value_total_banking  NUMBER(38,6)        -- 总计_银行业 
    ,index_ranking_stand  NUMBER(10,0)               -- 当前排名_对标行 
    ,index_ranking_cha_stand  NUMBER(10,0)           -- 排名变动_对标行 
    ,index_value_avg_stand  NUMBER(38,6)             -- 均值_对标行 
    ,index_value_total_stand  NUMBER(38,6)          -- 总计_对标行 
    ,curr_name	VARCHAR2(6)                         -- 币种   
    ,unit	VARCHAR2(6)                               -- 单位   
    ,frequency	VARCHAR2(4)                         -- 频度   
    ,benchmarking_flag	VARCHAR2(2)                 -- 是否对标行
    ,enabled_flag	VARCHAR2(2)                       -- 是否有效 
    ,report_period DATE                             -- 报告时间
    ,etl_timestamp timestamp                        -- ETL处理时间戳
)
partition by list(etl_dt)
(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
    
)
storage (initial 128k next 128k)
compress ${option_switch} for query high
nologging
;

-- grant
-- comment
comment on table  ${idl_schema}.mc_banking_q                              is '同业数据表';
comment on column ${idl_schema}.mc_banking_q.etl_dt                       is '数据日期';
comment on column ${idl_schema}.mc_banking_q.wind_code                    is '万德ID';
comment on column ${idl_schema}.mc_banking_q.banking_name                 is '银行名称';
comment on column ${idl_schema}.mc_banking_q.banking_sort                 is '银行性质分类';
comment on column ${idl_schema}.mc_banking_q.banking_ipo                  is '银行上市分类';
comment on column ${idl_schema}.mc_banking_q.index_no                     is '指标编码';
comment on column ${idl_schema}.mc_banking_q.index_name                   is '指标名称';
comment on column ${idl_schema}.mc_banking_q.index_value                  is '指标值';
comment on column ${idl_schema}.mc_banking_q.accu_index_value             is '累计值';
comment on column ${idl_schema}.mc_banking_q.rate_up_day                  is '比上日';
comment on column ${idl_schema}.mc_banking_q.rate_last_month              is '比上月';
comment on column ${idl_schema}.mc_banking_q.rate_last_year               is '比上年';
comment on column ${idl_schema}.mc_banking_q.rate_last_period             is '比同期';
comment on column ${idl_schema}.mc_banking_q.rate_up_day_per              is '比上日百分比';
comment on column ${idl_schema}.mc_banking_q.rate_last_month_per          is '比上月百分比';
comment on column ${idl_schema}.mc_banking_q.rate_last_year_per           is '比上年百分比';
comment on column ${idl_schema}.mc_banking_q.rate_last_period_per         is '比同期百分比';
comment on column ${idl_schema}.mc_banking_q.index_ranking_ccb            is '当前排名_城商行';
comment on column ${idl_schema}.mc_banking_q.index_ranking_cha_ccb        is '排名变动_城商行';
comment on column ${idl_schema}.mc_banking_q.index_value_avg_ccb          is '均值_城商行';
comment on column ${idl_schema}.mc_banking_q.index_value_total_ccb        is '总计_城商行';
comment on column ${idl_schema}.mc_banking_q.index_ranking_jsb            is '当前排名_股份制';
comment on column ${idl_schema}.mc_banking_q.index_ranking_cha_jsb        is '排名变动_股份制';
comment on column ${idl_schema}.mc_banking_q.index_value_avg_jsb          is '均值_股份制';
comment on column ${idl_schema}.mc_banking_q.index_value_total_jsb        is '总计_股份制';
comment on column ${idl_schema}.mc_banking_q.index_ranking_banking        is '当前排名_银行业';
comment on column ${idl_schema}.mc_banking_q.index_ranking_cha_banking    is '排名变动_银行业';
comment on column ${idl_schema}.mc_banking_q.index_value_avg_banking      is '均值_银行业';
comment on column ${idl_schema}.mc_banking_q.index_value_total_banking    is '总计_银行业';
comment on column ${idl_schema}.mc_banking_q.index_ranking_stand          is '当前排名_对标行';
comment on column ${idl_schema}.mc_banking_q.index_ranking_cha_stand      is '排名变动_对标行';
comment on column ${idl_schema}.mc_banking_q.index_value_avg_stand        is '均值_对标行';
comment on column ${idl_schema}.mc_banking_q.index_value_total_stand      is '总计_对标行';
comment on column ${idl_schema}.mc_banking_q.curr_name                    is '币种';
comment on column ${idl_schema}.mc_banking_q.unit                         is '单位';
comment on column ${idl_schema}.mc_banking_q.frequency                    is '频度';
comment on column ${idl_schema}.mc_banking_q.benchmarking_flag            is '是否对标行';
comment on column ${idl_schema}.mc_banking_q.enabled_flag                 is '是否有效';
comment on column ${idl_schema}.mc_banking_q.report_period                is '报告时间';
comment on column ${idl_schema}.mc_banking_q.etl_timestamp                is 'ETL处理时间戳';