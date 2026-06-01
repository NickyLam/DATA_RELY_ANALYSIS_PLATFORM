/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cap_amort
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cap_amort
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cap_amort purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cap_amort(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,bus_table_name varchar2(150) -- 业务表名称
    ,dept_id varchar2(60) -- 部门编号
    ,amort_dt date -- 摊销日期
    ,asset_bal_id varchar2(60) -- 资产余额编号
    ,post_qtty number(18,0) -- 持仓数量
    ,net_price_cost number(30,8) -- 净价成本
    ,amort_amt number(30,8) -- 摊销金额
    ,amort_post_net_price_cost number(30,8) -- 摊销后净价成本
    ,actl_int_rat number(30,8) -- 实际利率
    ,acct_b_id varchar2(60) -- 账簿编号
    ,asset_type_name varchar2(150) -- 资产类型名称
    ,main_asset_id varchar2(60) -- 主资产编号
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_cap_amort to ${icl_schema};
grant select on ${iml_schema}.evt_cap_amort to ${idl_schema};
grant select on ${iml_schema}.evt_cap_amort to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cap_amort is '资金摊销事件';
comment on column ${iml_schema}.evt_cap_amort.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cap_amort.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cap_amort.bus_id is '业务编号';
comment on column ${iml_schema}.evt_cap_amort.bus_table_name is '业务表名称';
comment on column ${iml_schema}.evt_cap_amort.dept_id is '部门编号';
comment on column ${iml_schema}.evt_cap_amort.amort_dt is '摊销日期';
comment on column ${iml_schema}.evt_cap_amort.asset_bal_id is '资产余额编号';
comment on column ${iml_schema}.evt_cap_amort.post_qtty is '持仓数量';
comment on column ${iml_schema}.evt_cap_amort.net_price_cost is '净价成本';
comment on column ${iml_schema}.evt_cap_amort.amort_amt is '摊销金额';
comment on column ${iml_schema}.evt_cap_amort.amort_post_net_price_cost is '摊销后净价成本';
comment on column ${iml_schema}.evt_cap_amort.actl_int_rat is '实际利率';
comment on column ${iml_schema}.evt_cap_amort.acct_b_id is '账簿编号';
comment on column ${iml_schema}.evt_cap_amort.asset_type_name is '资产类型名称';
comment on column ${iml_schema}.evt_cap_amort.main_asset_id is '主资产编号';
comment on column ${iml_schema}.evt_cap_amort.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_cap_amort.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cap_amort.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cap_amort.etl_timestamp is 'ETL处理时间戳';
