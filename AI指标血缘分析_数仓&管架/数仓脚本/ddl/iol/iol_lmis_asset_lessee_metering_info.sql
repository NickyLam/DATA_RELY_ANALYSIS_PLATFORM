/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol lmis_asset_lessee_metering_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.lmis_asset_lessee_metering_info
whenever sqlerror continue none;
drop table ${iol_schema}.lmis_asset_lessee_metering_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.lmis_asset_lessee_metering_info(
    id number(22) -- 承租计量id
    ,lessee_id number(22) -- 承租资产id
    ,metering_date timestamp -- 计量日期
    ,book_code varchar2(30) -- 账簿代码
    ,period_name varchar2(45) -- 期间名称
    ,asset_amount_begin number(22) -- 期初使用权资产余额
    ,deprn_amount number(22) -- 本期折旧
    ,accumulated_deprn_amount number(22) -- 累计折旧
    ,asset_amount_end number(22) -- 期末使用权资产余额
    ,payable_amount_begin number(22) -- 期初租赁负债-应付租赁款（不含税）
    ,period_payable_amount number(22) -- 本期应付款（计划付款额不含税）
    ,accumulated_payable_amount number(22) -- 累计应付款
    ,payable_amount_end number(22) -- 期末租赁负债-应付租赁款（不含税）
    ,amortized_cost_begin number(22) -- 期初租赁负债（摊余成本）余额
    ,period_amortized_cost number(22) -- 本期租赁负债变化
    ,accumulated_amortized_cost number(22) -- 累计租赁负债变化
    ,amortized_cost_end number(22) -- 期末租赁负债（摊余成本）余额
    ,interest_begin number(22) -- 期初租赁负债-未确认融资费用余额
    ,period_interest number(22) -- 本期利息费用
    ,accumulated_interest number(22) -- 累计利息费用
    ,interest_end number(22) -- 期末租赁负债-未确认融资费用余额
    ,tenant_id number(22) -- 租户id
    ,created_by number(22) -- 创建人
    ,created_date timestamp -- 创建时间
    ,last_updated_by number(22) -- 最后更新人
    ,last_updated_date timestamp -- 最后更新时间
    ,version_number number(22) -- 版本号
    ,asset_adj_amount number(22) -- 本期使用权资产价值调整额
    ,asset_mod_amount number(22) -- 本期合同变更使用权资产发生额
    ,payable_amount_mod number(22) -- 本期合同变更租赁负债应付租赁款
    ,amortized_cost_mod number(22) -- 本期合同变更摊余成本发生额
    ,interest_mod number(22) -- 本期合同变更租赁负债-未确认融资费用发生额
    ,new_account_amount number(22) -- 新准则期间损益金额
    ,old_account_amount number(22) -- 旧准则期间损益金额
    ,differ_amount number(22) -- 新旧准则损益差异
    ,month_payable_amount number(22) -- 本期租赁负债应付租赁款减少额(本月累计)
    ,month_amortized_cost number(22) -- 本期租赁负债变化(当月累计)
    ,month_period_interest number(22) -- 本期利息费用(当月累计)
    ,accumulated_account_amount number(22) -- 累计旧准则期间损益金额
    ,date_type varchar2(75) -- 
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
grant select on ${iol_schema}.lmis_asset_lessee_metering_info to ${iml_schema};
grant select on ${iol_schema}.lmis_asset_lessee_metering_info to ${icl_schema};
grant select on ${iol_schema}.lmis_asset_lessee_metering_info to ${idl_schema};
grant select on ${iol_schema}.lmis_asset_lessee_metering_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.lmis_asset_lessee_metering_info is '承租租赁资产计量信息表';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.id is '承租计量id';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.lessee_id is '承租资产id';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.metering_date is '计量日期';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.book_code is '账簿代码';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.period_name is '期间名称';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.asset_amount_begin is '期初使用权资产余额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.deprn_amount is '本期折旧';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.accumulated_deprn_amount is '累计折旧';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.asset_amount_end is '期末使用权资产余额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.payable_amount_begin is '期初租赁负债-应付租赁款（不含税）';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.period_payable_amount is '本期应付款（计划付款额不含税）';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.accumulated_payable_amount is '累计应付款';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.payable_amount_end is '期末租赁负债-应付租赁款（不含税）';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.amortized_cost_begin is '期初租赁负债（摊余成本）余额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.period_amortized_cost is '本期租赁负债变化';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.accumulated_amortized_cost is '累计租赁负债变化';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.amortized_cost_end is '期末租赁负债（摊余成本）余额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.interest_begin is '期初租赁负债-未确认融资费用余额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.period_interest is '本期利息费用';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.accumulated_interest is '累计利息费用';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.interest_end is '期末租赁负债-未确认融资费用余额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.tenant_id is '租户id';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.created_by is '创建人';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.created_date is '创建时间';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.last_updated_by is '最后更新人';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.last_updated_date is '最后更新时间';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.version_number is '版本号';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.asset_adj_amount is '本期使用权资产价值调整额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.asset_mod_amount is '本期合同变更使用权资产发生额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.payable_amount_mod is '本期合同变更租赁负债应付租赁款';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.amortized_cost_mod is '本期合同变更摊余成本发生额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.interest_mod is '本期合同变更租赁负债-未确认融资费用发生额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.new_account_amount is '新准则期间损益金额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.old_account_amount is '旧准则期间损益金额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.differ_amount is '新旧准则损益差异';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.month_payable_amount is '本期租赁负债应付租赁款减少额(本月累计)';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.month_amortized_cost is '本期租赁负债变化(当月累计)';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.month_period_interest is '本期利息费用(当月累计)';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.accumulated_account_amount is '累计旧准则期间损益金额';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.date_type is '';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.start_dt is '开始时间';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.end_dt is '结束时间';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.id_mark is '增删标志';
comment on column ${iol_schema}.lmis_asset_lessee_metering_info.etl_timestamp is 'ETL处理时间戳';
