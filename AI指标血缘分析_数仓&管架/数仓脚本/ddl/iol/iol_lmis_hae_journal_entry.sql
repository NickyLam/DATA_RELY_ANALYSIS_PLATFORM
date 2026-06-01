/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol lmis_hae_journal_entry
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.lmis_hae_journal_entry
whenever sqlerror continue none;
drop table ${iol_schema}.lmis_hae_journal_entry purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.lmis_hae_journal_entry(
    id number(38,0) -- 会计分录id
    ,source_flag varchar2(15) -- 来源系统标识
    ,target_flag varchar2(15) -- 目标系统标识
    ,error_message varchar2(1500) -- 错误信息
    ,ledger_code varchar2(45) -- 账套
    ,company_code varchar2(45) -- 会计主体1
    ,department_code varchar2(45) -- 会计主体2
    ,period_name varchar2(45) -- 会计日期1
    ,accounting_date varchar2(45) -- 会计日期2
    ,account_code varchar2(45) -- 会计要素1
    ,account_detail varchar2(45) -- 会计要素2
    ,currency_code varchar2(45) -- 货币计量1
    ,exchange_type varchar2(45) -- 货币计量2
    ,exchange_date varchar2(45) -- 货币计量3
    ,exchange_rate varchar2(45) -- 货币计量4
    ,entered_amount_dr number(20,2) -- 会计度量1借方
    ,entered_amount_cr number(20,2) -- 会计度量1贷方
    ,functional_amount_dr number(20,2) -- 会计度量2借方
    ,functional_amount_cr number(20,2) -- 会计度量2贷方
    ,cashflow_category varchar2(45) -- 现金流标识1
    ,cashflow_direction varchar2(45) -- 现金流标识2
    ,dimension1 varchar2(225) -- 分析维度1
    ,dimension2 varchar2(225) -- 分析维度2
    ,dimension3 varchar2(225) -- 分析维度3
    ,dimension4 varchar2(225) -- 分析维度4
    ,dimension5 varchar2(225) -- 分析维度5
    ,dimension6 varchar2(225) -- 分析维度6
    ,dimension7 varchar2(225) -- 分析维度7
    ,dimension8 varchar2(225) -- 分析维度8
    ,dimension9 varchar2(225) -- 分析维度9
    ,dimension10 varchar2(225) -- 分析维度10
    ,dimension11 varchar2(225) -- 分析维度11
    ,dimension12 varchar2(225) -- 分析维度12
    ,dimension13 varchar2(225) -- 分析维度13
    ,dimension14 varchar2(225) -- 分析维度14
    ,dimension15 varchar2(225) -- 分析维度15
    ,journal_number varchar2(150) -- 凭证编号
    ,subtype_id number(38,0) -- 子类型id
    ,event_id number(38,0) -- 会计事件配置id
    ,transaction_type varchar2(45) -- 来源事务code
    ,transaction_ins_id number(38,0) -- 来源事务实例id
    ,transaction_number varchar2(300) -- 来源事务编码
    ,transaction_line_type varchar2(45) -- 分录来源行类型code
    ,transaction_line_id number(38,0) -- 分录来源行id
    ,attribute1 varchar2(375) -- 备用字段1
    ,attribute2 varchar2(375) -- 备用字段2
    ,attribute3 varchar2(375) -- 备用字段3
    ,attribute4 varchar2(375) -- 备用字段4
    ,attribute5 varchar2(375) -- 备用字段5
    ,created_date timestamp -- 创建日期
    ,created_by number(38,0) -- 创建人
    ,last_updated_date timestamp -- 最后更新日期
    ,last_updated_by number(38,0) -- 最后更新人
    ,version_number number(38,0) -- 版本号
    ,dimension16 varchar2(225) -- 分析维度16
    ,dimension17 varchar2(225) -- 分析维度17
    ,dimension18 varchar2(225) -- 分析维度18
    ,dimension19 varchar2(225) -- 分析维度19
    ,dimension20 varchar2(225) -- 分析维度20
    ,dimension21 varchar2(225) -- 分析维度21
    ,dimension22 varchar2(225) -- 分析维度22
    ,dimension23 varchar2(225) -- 分析维度23
    ,dimension24 varchar2(225) -- 分析维度24
    ,dimension25 varchar2(225) -- 分析维度25
    ,dimension26 varchar2(225) -- 分析维度26
    ,dimension27 varchar2(225) -- 分析维度27
    ,dimension28 varchar2(225) -- 分析维度28
    ,dimension29 varchar2(225) -- 分析维度29
    ,dimension30 varchar2(225) -- 分析维度30
    ,tenant_id number(38,0) -- 租户id
    ,batch_number varchar2(300) -- 批次号
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
grant select on ${iol_schema}.lmis_hae_journal_entry to ${iml_schema};
grant select on ${iol_schema}.lmis_hae_journal_entry to ${icl_schema};
grant select on ${iol_schema}.lmis_hae_journal_entry to ${idl_schema};
grant select on ${iol_schema}.lmis_hae_journal_entry to ${iel_schema};

-- comment
comment on table ${iol_schema}.lmis_hae_journal_entry is '会计分录表';
comment on column ${iol_schema}.lmis_hae_journal_entry.id is '会计分录id';
comment on column ${iol_schema}.lmis_hae_journal_entry.source_flag is '来源系统标识';
comment on column ${iol_schema}.lmis_hae_journal_entry.target_flag is '目标系统标识';
comment on column ${iol_schema}.lmis_hae_journal_entry.error_message is '错误信息';
comment on column ${iol_schema}.lmis_hae_journal_entry.ledger_code is '账套';
comment on column ${iol_schema}.lmis_hae_journal_entry.company_code is '会计主体1';
comment on column ${iol_schema}.lmis_hae_journal_entry.department_code is '会计主体2';
comment on column ${iol_schema}.lmis_hae_journal_entry.period_name is '会计日期1';
comment on column ${iol_schema}.lmis_hae_journal_entry.accounting_date is '会计日期2';
comment on column ${iol_schema}.lmis_hae_journal_entry.account_code is '会计要素1';
comment on column ${iol_schema}.lmis_hae_journal_entry.account_detail is '会计要素2';
comment on column ${iol_schema}.lmis_hae_journal_entry.currency_code is '货币计量1';
comment on column ${iol_schema}.lmis_hae_journal_entry.exchange_type is '货币计量2';
comment on column ${iol_schema}.lmis_hae_journal_entry.exchange_date is '货币计量3';
comment on column ${iol_schema}.lmis_hae_journal_entry.exchange_rate is '货币计量4';
comment on column ${iol_schema}.lmis_hae_journal_entry.entered_amount_dr is '会计度量1借方';
comment on column ${iol_schema}.lmis_hae_journal_entry.entered_amount_cr is '会计度量1贷方';
comment on column ${iol_schema}.lmis_hae_journal_entry.functional_amount_dr is '会计度量2借方';
comment on column ${iol_schema}.lmis_hae_journal_entry.functional_amount_cr is '会计度量2贷方';
comment on column ${iol_schema}.lmis_hae_journal_entry.cashflow_category is '现金流标识1';
comment on column ${iol_schema}.lmis_hae_journal_entry.cashflow_direction is '现金流标识2';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension1 is '分析维度1';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension2 is '分析维度2';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension3 is '分析维度3';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension4 is '分析维度4';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension5 is '分析维度5';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension6 is '分析维度6';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension7 is '分析维度7';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension8 is '分析维度8';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension9 is '分析维度9';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension10 is '分析维度10';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension11 is '分析维度11';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension12 is '分析维度12';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension13 is '分析维度13';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension14 is '分析维度14';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension15 is '分析维度15';
comment on column ${iol_schema}.lmis_hae_journal_entry.journal_number is '凭证编号';
comment on column ${iol_schema}.lmis_hae_journal_entry.subtype_id is '子类型id';
comment on column ${iol_schema}.lmis_hae_journal_entry.event_id is '会计事件配置id';
comment on column ${iol_schema}.lmis_hae_journal_entry.transaction_type is '来源事务code';
comment on column ${iol_schema}.lmis_hae_journal_entry.transaction_ins_id is '来源事务实例id';
comment on column ${iol_schema}.lmis_hae_journal_entry.transaction_number is '来源事务编码';
comment on column ${iol_schema}.lmis_hae_journal_entry.transaction_line_type is '分录来源行类型code';
comment on column ${iol_schema}.lmis_hae_journal_entry.transaction_line_id is '分录来源行id';
comment on column ${iol_schema}.lmis_hae_journal_entry.attribute1 is '备用字段1';
comment on column ${iol_schema}.lmis_hae_journal_entry.attribute2 is '备用字段2';
comment on column ${iol_schema}.lmis_hae_journal_entry.attribute3 is '备用字段3';
comment on column ${iol_schema}.lmis_hae_journal_entry.attribute4 is '备用字段4';
comment on column ${iol_schema}.lmis_hae_journal_entry.attribute5 is '备用字段5';
comment on column ${iol_schema}.lmis_hae_journal_entry.created_date is '创建日期';
comment on column ${iol_schema}.lmis_hae_journal_entry.created_by is '创建人';
comment on column ${iol_schema}.lmis_hae_journal_entry.last_updated_date is '最后更新日期';
comment on column ${iol_schema}.lmis_hae_journal_entry.last_updated_by is '最后更新人';
comment on column ${iol_schema}.lmis_hae_journal_entry.version_number is '版本号';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension16 is '分析维度16';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension17 is '分析维度17';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension18 is '分析维度18';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension19 is '分析维度19';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension20 is '分析维度20';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension21 is '分析维度21';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension22 is '分析维度22';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension23 is '分析维度23';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension24 is '分析维度24';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension25 is '分析维度25';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension26 is '分析维度26';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension27 is '分析维度27';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension28 is '分析维度28';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension29 is '分析维度29';
comment on column ${iol_schema}.lmis_hae_journal_entry.dimension30 is '分析维度30';
comment on column ${iol_schema}.lmis_hae_journal_entry.tenant_id is '租户id';
comment on column ${iol_schema}.lmis_hae_journal_entry.batch_number is '批次号';
comment on column ${iol_schema}.lmis_hae_journal_entry.start_dt is '开始时间';
comment on column ${iol_schema}.lmis_hae_journal_entry.end_dt is '结束时间';
comment on column ${iol_schema}.lmis_hae_journal_entry.id_mark is '增删标志';
comment on column ${iol_schema}.lmis_hae_journal_entry.etl_timestamp is 'ETL处理时间戳';
