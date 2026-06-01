/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_lmis_hae_journal_entry
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.lmis_hae_journal_entry_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.lmis_hae_journal_entry
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.lmis_hae_journal_entry_op purge;
drop table ${iol_schema}.lmis_hae_journal_entry_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.lmis_hae_journal_entry_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.lmis_hae_journal_entry where 0=1;

create table ${iol_schema}.lmis_hae_journal_entry_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.lmis_hae_journal_entry where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.lmis_hae_journal_entry_cl(
            id -- 会计分录ID
            ,source_flag -- 来源系统标识
            ,target_flag -- 目标系统标识
            ,error_message -- 错误信息
            ,ledger_code -- 账套
            ,company_code -- 会计主体1
            ,department_code -- 会计主体2
            ,period_name -- 会计日期1
            ,accounting_date -- 会计日期2
            ,account_code -- 会计要素1
            ,account_detail -- 会计要素2
            ,currency_code -- 货币计量1
            ,exchange_type -- 货币计量2
            ,exchange_date -- 货币计量3
            ,exchange_rate -- 货币计量4
            ,entered_amount_dr -- 会计度量1借方
            ,entered_amount_cr -- 会计度量1贷方
            ,functional_amount_dr -- 会计度量2借方
            ,functional_amount_cr -- 会计度量2贷方
            ,cashflow_category -- 现金流标识1
            ,cashflow_direction -- 现金流标识2
            ,dimension1 -- 分析维度1
            ,dimension2 -- 分析维度2
            ,dimension3 -- 分析维度3
            ,dimension4 -- 分析维度4
            ,dimension5 -- 分析维度5
            ,dimension6 -- 分析维度6
            ,dimension7 -- 分析维度7
            ,dimension8 -- 分析维度8
            ,dimension9 -- 分析维度9
            ,dimension10 -- 分析维度10
            ,dimension11 -- 分析维度11
            ,dimension12 -- 分析维度12
            ,dimension13 -- 分析维度13
            ,dimension14 -- 分析维度14
            ,dimension15 -- 分析维度15
            ,journal_number -- 凭证编号
            ,subtype_id -- 子类型id
            ,event_id -- 会计事件配置id
            ,transaction_type -- 来源事务code
            ,transaction_ins_id -- 来源事务实例id
            ,transaction_number -- 来源事务编码
            ,transaction_line_type -- 分录来源行类型code
            ,transaction_line_id -- 分录来源行id
            ,attribute1 -- 备用字段1
            ,attribute2 -- 备用字段2
            ,attribute3 -- 备用字段3
            ,attribute4 -- 备用字段4
            ,attribute5 -- 备用字段5
            ,created_date -- 创建日期
            ,created_by -- 创建人
            ,last_updated_date -- 最后更新日期
            ,last_updated_by -- 最后更新人
            ,version_number -- 版本号
            ,dimension16 -- 分析维度16
            ,dimension17 -- 分析维度17
            ,dimension18 -- 分析维度18
            ,dimension19 -- 分析维度19
            ,dimension20 -- 分析维度20
            ,dimension21 -- 分析维度21
            ,dimension22 -- 分析维度22
            ,dimension23 -- 分析维度23
            ,dimension24 -- 分析维度24
            ,dimension25 -- 分析维度25
            ,dimension26 -- 分析维度26
            ,dimension27 -- 分析维度27
            ,dimension28 -- 分析维度28
            ,dimension29 -- 分析维度29
            ,dimension30 -- 分析维度30
            ,tenant_id -- 租户ID
            ,batch_number -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.lmis_hae_journal_entry_op(
            id -- 会计分录ID
            ,source_flag -- 来源系统标识
            ,target_flag -- 目标系统标识
            ,error_message -- 错误信息
            ,ledger_code -- 账套
            ,company_code -- 会计主体1
            ,department_code -- 会计主体2
            ,period_name -- 会计日期1
            ,accounting_date -- 会计日期2
            ,account_code -- 会计要素1
            ,account_detail -- 会计要素2
            ,currency_code -- 货币计量1
            ,exchange_type -- 货币计量2
            ,exchange_date -- 货币计量3
            ,exchange_rate -- 货币计量4
            ,entered_amount_dr -- 会计度量1借方
            ,entered_amount_cr -- 会计度量1贷方
            ,functional_amount_dr -- 会计度量2借方
            ,functional_amount_cr -- 会计度量2贷方
            ,cashflow_category -- 现金流标识1
            ,cashflow_direction -- 现金流标识2
            ,dimension1 -- 分析维度1
            ,dimension2 -- 分析维度2
            ,dimension3 -- 分析维度3
            ,dimension4 -- 分析维度4
            ,dimension5 -- 分析维度5
            ,dimension6 -- 分析维度6
            ,dimension7 -- 分析维度7
            ,dimension8 -- 分析维度8
            ,dimension9 -- 分析维度9
            ,dimension10 -- 分析维度10
            ,dimension11 -- 分析维度11
            ,dimension12 -- 分析维度12
            ,dimension13 -- 分析维度13
            ,dimension14 -- 分析维度14
            ,dimension15 -- 分析维度15
            ,journal_number -- 凭证编号
            ,subtype_id -- 子类型id
            ,event_id -- 会计事件配置id
            ,transaction_type -- 来源事务code
            ,transaction_ins_id -- 来源事务实例id
            ,transaction_number -- 来源事务编码
            ,transaction_line_type -- 分录来源行类型code
            ,transaction_line_id -- 分录来源行id
            ,attribute1 -- 备用字段1
            ,attribute2 -- 备用字段2
            ,attribute3 -- 备用字段3
            ,attribute4 -- 备用字段4
            ,attribute5 -- 备用字段5
            ,created_date -- 创建日期
            ,created_by -- 创建人
            ,last_updated_date -- 最后更新日期
            ,last_updated_by -- 最后更新人
            ,version_number -- 版本号
            ,dimension16 -- 分析维度16
            ,dimension17 -- 分析维度17
            ,dimension18 -- 分析维度18
            ,dimension19 -- 分析维度19
            ,dimension20 -- 分析维度20
            ,dimension21 -- 分析维度21
            ,dimension22 -- 分析维度22
            ,dimension23 -- 分析维度23
            ,dimension24 -- 分析维度24
            ,dimension25 -- 分析维度25
            ,dimension26 -- 分析维度26
            ,dimension27 -- 分析维度27
            ,dimension28 -- 分析维度28
            ,dimension29 -- 分析维度29
            ,dimension30 -- 分析维度30
            ,tenant_id -- 租户ID
            ,batch_number -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 会计分录ID
    ,nvl(n.source_flag, o.source_flag) as source_flag -- 来源系统标识
    ,nvl(n.target_flag, o.target_flag) as target_flag -- 目标系统标识
    ,nvl(n.error_message, o.error_message) as error_message -- 错误信息
    ,nvl(n.ledger_code, o.ledger_code) as ledger_code -- 账套
    ,nvl(n.company_code, o.company_code) as company_code -- 会计主体1
    ,nvl(n.department_code, o.department_code) as department_code -- 会计主体2
    ,nvl(n.period_name, o.period_name) as period_name -- 会计日期1
    ,nvl(n.accounting_date, o.accounting_date) as accounting_date -- 会计日期2
    ,nvl(n.account_code, o.account_code) as account_code -- 会计要素1
    ,nvl(n.account_detail, o.account_detail) as account_detail -- 会计要素2
    ,nvl(n.currency_code, o.currency_code) as currency_code -- 货币计量1
    ,nvl(n.exchange_type, o.exchange_type) as exchange_type -- 货币计量2
    ,nvl(n.exchange_date, o.exchange_date) as exchange_date -- 货币计量3
    ,nvl(n.exchange_rate, o.exchange_rate) as exchange_rate -- 货币计量4
    ,nvl(n.entered_amount_dr, o.entered_amount_dr) as entered_amount_dr -- 会计度量1借方
    ,nvl(n.entered_amount_cr, o.entered_amount_cr) as entered_amount_cr -- 会计度量1贷方
    ,nvl(n.functional_amount_dr, o.functional_amount_dr) as functional_amount_dr -- 会计度量2借方
    ,nvl(n.functional_amount_cr, o.functional_amount_cr) as functional_amount_cr -- 会计度量2贷方
    ,nvl(n.cashflow_category, o.cashflow_category) as cashflow_category -- 现金流标识1
    ,nvl(n.cashflow_direction, o.cashflow_direction) as cashflow_direction -- 现金流标识2
    ,nvl(n.dimension1, o.dimension1) as dimension1 -- 分析维度1
    ,nvl(n.dimension2, o.dimension2) as dimension2 -- 分析维度2
    ,nvl(n.dimension3, o.dimension3) as dimension3 -- 分析维度3
    ,nvl(n.dimension4, o.dimension4) as dimension4 -- 分析维度4
    ,nvl(n.dimension5, o.dimension5) as dimension5 -- 分析维度5
    ,nvl(n.dimension6, o.dimension6) as dimension6 -- 分析维度6
    ,nvl(n.dimension7, o.dimension7) as dimension7 -- 分析维度7
    ,nvl(n.dimension8, o.dimension8) as dimension8 -- 分析维度8
    ,nvl(n.dimension9, o.dimension9) as dimension9 -- 分析维度9
    ,nvl(n.dimension10, o.dimension10) as dimension10 -- 分析维度10
    ,nvl(n.dimension11, o.dimension11) as dimension11 -- 分析维度11
    ,nvl(n.dimension12, o.dimension12) as dimension12 -- 分析维度12
    ,nvl(n.dimension13, o.dimension13) as dimension13 -- 分析维度13
    ,nvl(n.dimension14, o.dimension14) as dimension14 -- 分析维度14
    ,nvl(n.dimension15, o.dimension15) as dimension15 -- 分析维度15
    ,nvl(n.journal_number, o.journal_number) as journal_number -- 凭证编号
    ,nvl(n.subtype_id, o.subtype_id) as subtype_id -- 子类型id
    ,nvl(n.event_id, o.event_id) as event_id -- 会计事件配置id
    ,nvl(n.transaction_type, o.transaction_type) as transaction_type -- 来源事务code
    ,nvl(n.transaction_ins_id, o.transaction_ins_id) as transaction_ins_id -- 来源事务实例id
    ,nvl(n.transaction_number, o.transaction_number) as transaction_number -- 来源事务编码
    ,nvl(n.transaction_line_type, o.transaction_line_type) as transaction_line_type -- 分录来源行类型code
    ,nvl(n.transaction_line_id, o.transaction_line_id) as transaction_line_id -- 分录来源行id
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 备用字段1
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 备用字段2
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 备用字段3
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 备用字段4
    ,nvl(n.attribute5, o.attribute5) as attribute5 -- 备用字段5
    ,nvl(n.created_date, o.created_date) as created_date -- 创建日期
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.last_updated_date, o.last_updated_date) as last_updated_date -- 最后更新日期
    ,nvl(n.last_updated_by, o.last_updated_by) as last_updated_by -- 最后更新人
    ,nvl(n.version_number, o.version_number) as version_number -- 版本号
    ,nvl(n.dimension16, o.dimension16) as dimension16 -- 分析维度16
    ,nvl(n.dimension17, o.dimension17) as dimension17 -- 分析维度17
    ,nvl(n.dimension18, o.dimension18) as dimension18 -- 分析维度18
    ,nvl(n.dimension19, o.dimension19) as dimension19 -- 分析维度19
    ,nvl(n.dimension20, o.dimension20) as dimension20 -- 分析维度20
    ,nvl(n.dimension21, o.dimension21) as dimension21 -- 分析维度21
    ,nvl(n.dimension22, o.dimension22) as dimension22 -- 分析维度22
    ,nvl(n.dimension23, o.dimension23) as dimension23 -- 分析维度23
    ,nvl(n.dimension24, o.dimension24) as dimension24 -- 分析维度24
    ,nvl(n.dimension25, o.dimension25) as dimension25 -- 分析维度25
    ,nvl(n.dimension26, o.dimension26) as dimension26 -- 分析维度26
    ,nvl(n.dimension27, o.dimension27) as dimension27 -- 分析维度27
    ,nvl(n.dimension28, o.dimension28) as dimension28 -- 分析维度28
    ,nvl(n.dimension29, o.dimension29) as dimension29 -- 分析维度29
    ,nvl(n.dimension30, o.dimension30) as dimension30 -- 分析维度30
    ,nvl(n.tenant_id, o.tenant_id) as tenant_id -- 租户ID
    ,nvl(n.batch_number, o.batch_number) as batch_number -- 批次号
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.lmis_hae_journal_entry_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.lmis_hae_journal_entry where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.source_flag <> n.source_flag
        or o.target_flag <> n.target_flag
        or o.error_message <> n.error_message
        or o.ledger_code <> n.ledger_code
        or o.company_code <> n.company_code
        or o.department_code <> n.department_code
        or o.period_name <> n.period_name
        or o.accounting_date <> n.accounting_date
        or o.account_code <> n.account_code
        or o.account_detail <> n.account_detail
        or o.currency_code <> n.currency_code
        or o.exchange_type <> n.exchange_type
        or o.exchange_date <> n.exchange_date
        or o.exchange_rate <> n.exchange_rate
        or o.entered_amount_dr <> n.entered_amount_dr
        or o.entered_amount_cr <> n.entered_amount_cr
        or o.functional_amount_dr <> n.functional_amount_dr
        or o.functional_amount_cr <> n.functional_amount_cr
        or o.cashflow_category <> n.cashflow_category
        or o.cashflow_direction <> n.cashflow_direction
        or o.dimension1 <> n.dimension1
        or o.dimension2 <> n.dimension2
        or o.dimension3 <> n.dimension3
        or o.dimension4 <> n.dimension4
        or o.dimension5 <> n.dimension5
        or o.dimension6 <> n.dimension6
        or o.dimension7 <> n.dimension7
        or o.dimension8 <> n.dimension8
        or o.dimension9 <> n.dimension9
        or o.dimension10 <> n.dimension10
        or o.dimension11 <> n.dimension11
        or o.dimension12 <> n.dimension12
        or o.dimension13 <> n.dimension13
        or o.dimension14 <> n.dimension14
        or o.dimension15 <> n.dimension15
        or o.journal_number <> n.journal_number
        or o.subtype_id <> n.subtype_id
        or o.event_id <> n.event_id
        or o.transaction_type <> n.transaction_type
        or o.transaction_ins_id <> n.transaction_ins_id
        or o.transaction_number <> n.transaction_number
        or o.transaction_line_type <> n.transaction_line_type
        or o.transaction_line_id <> n.transaction_line_id
        or o.attribute1 <> n.attribute1
        or o.attribute2 <> n.attribute2
        or o.attribute3 <> n.attribute3
        or o.attribute4 <> n.attribute4
        or o.attribute5 <> n.attribute5
        or o.created_date <> n.created_date
        or o.created_by <> n.created_by
        or o.last_updated_date <> n.last_updated_date
        or o.last_updated_by <> n.last_updated_by
        or o.version_number <> n.version_number
        or o.dimension16 <> n.dimension16
        or o.dimension17 <> n.dimension17
        or o.dimension18 <> n.dimension18
        or o.dimension19 <> n.dimension19
        or o.dimension20 <> n.dimension20
        or o.dimension21 <> n.dimension21
        or o.dimension22 <> n.dimension22
        or o.dimension23 <> n.dimension23
        or o.dimension24 <> n.dimension24
        or o.dimension25 <> n.dimension25
        or o.dimension26 <> n.dimension26
        or o.dimension27 <> n.dimension27
        or o.dimension28 <> n.dimension28
        or o.dimension29 <> n.dimension29
        or o.dimension30 <> n.dimension30
        or o.tenant_id <> n.tenant_id
        or o.batch_number <> n.batch_number
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.lmis_hae_journal_entry_cl(
            id -- 会计分录ID
            ,source_flag -- 来源系统标识
            ,target_flag -- 目标系统标识
            ,error_message -- 错误信息
            ,ledger_code -- 账套
            ,company_code -- 会计主体1
            ,department_code -- 会计主体2
            ,period_name -- 会计日期1
            ,accounting_date -- 会计日期2
            ,account_code -- 会计要素1
            ,account_detail -- 会计要素2
            ,currency_code -- 货币计量1
            ,exchange_type -- 货币计量2
            ,exchange_date -- 货币计量3
            ,exchange_rate -- 货币计量4
            ,entered_amount_dr -- 会计度量1借方
            ,entered_amount_cr -- 会计度量1贷方
            ,functional_amount_dr -- 会计度量2借方
            ,functional_amount_cr -- 会计度量2贷方
            ,cashflow_category -- 现金流标识1
            ,cashflow_direction -- 现金流标识2
            ,dimension1 -- 分析维度1
            ,dimension2 -- 分析维度2
            ,dimension3 -- 分析维度3
            ,dimension4 -- 分析维度4
            ,dimension5 -- 分析维度5
            ,dimension6 -- 分析维度6
            ,dimension7 -- 分析维度7
            ,dimension8 -- 分析维度8
            ,dimension9 -- 分析维度9
            ,dimension10 -- 分析维度10
            ,dimension11 -- 分析维度11
            ,dimension12 -- 分析维度12
            ,dimension13 -- 分析维度13
            ,dimension14 -- 分析维度14
            ,dimension15 -- 分析维度15
            ,journal_number -- 凭证编号
            ,subtype_id -- 子类型id
            ,event_id -- 会计事件配置id
            ,transaction_type -- 来源事务code
            ,transaction_ins_id -- 来源事务实例id
            ,transaction_number -- 来源事务编码
            ,transaction_line_type -- 分录来源行类型code
            ,transaction_line_id -- 分录来源行id
            ,attribute1 -- 备用字段1
            ,attribute2 -- 备用字段2
            ,attribute3 -- 备用字段3
            ,attribute4 -- 备用字段4
            ,attribute5 -- 备用字段5
            ,created_date -- 创建日期
            ,created_by -- 创建人
            ,last_updated_date -- 最后更新日期
            ,last_updated_by -- 最后更新人
            ,version_number -- 版本号
            ,dimension16 -- 分析维度16
            ,dimension17 -- 分析维度17
            ,dimension18 -- 分析维度18
            ,dimension19 -- 分析维度19
            ,dimension20 -- 分析维度20
            ,dimension21 -- 分析维度21
            ,dimension22 -- 分析维度22
            ,dimension23 -- 分析维度23
            ,dimension24 -- 分析维度24
            ,dimension25 -- 分析维度25
            ,dimension26 -- 分析维度26
            ,dimension27 -- 分析维度27
            ,dimension28 -- 分析维度28
            ,dimension29 -- 分析维度29
            ,dimension30 -- 分析维度30
            ,tenant_id -- 租户ID
            ,batch_number -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.lmis_hae_journal_entry_op(
            id -- 会计分录ID
            ,source_flag -- 来源系统标识
            ,target_flag -- 目标系统标识
            ,error_message -- 错误信息
            ,ledger_code -- 账套
            ,company_code -- 会计主体1
            ,department_code -- 会计主体2
            ,period_name -- 会计日期1
            ,accounting_date -- 会计日期2
            ,account_code -- 会计要素1
            ,account_detail -- 会计要素2
            ,currency_code -- 货币计量1
            ,exchange_type -- 货币计量2
            ,exchange_date -- 货币计量3
            ,exchange_rate -- 货币计量4
            ,entered_amount_dr -- 会计度量1借方
            ,entered_amount_cr -- 会计度量1贷方
            ,functional_amount_dr -- 会计度量2借方
            ,functional_amount_cr -- 会计度量2贷方
            ,cashflow_category -- 现金流标识1
            ,cashflow_direction -- 现金流标识2
            ,dimension1 -- 分析维度1
            ,dimension2 -- 分析维度2
            ,dimension3 -- 分析维度3
            ,dimension4 -- 分析维度4
            ,dimension5 -- 分析维度5
            ,dimension6 -- 分析维度6
            ,dimension7 -- 分析维度7
            ,dimension8 -- 分析维度8
            ,dimension9 -- 分析维度9
            ,dimension10 -- 分析维度10
            ,dimension11 -- 分析维度11
            ,dimension12 -- 分析维度12
            ,dimension13 -- 分析维度13
            ,dimension14 -- 分析维度14
            ,dimension15 -- 分析维度15
            ,journal_number -- 凭证编号
            ,subtype_id -- 子类型id
            ,event_id -- 会计事件配置id
            ,transaction_type -- 来源事务code
            ,transaction_ins_id -- 来源事务实例id
            ,transaction_number -- 来源事务编码
            ,transaction_line_type -- 分录来源行类型code
            ,transaction_line_id -- 分录来源行id
            ,attribute1 -- 备用字段1
            ,attribute2 -- 备用字段2
            ,attribute3 -- 备用字段3
            ,attribute4 -- 备用字段4
            ,attribute5 -- 备用字段5
            ,created_date -- 创建日期
            ,created_by -- 创建人
            ,last_updated_date -- 最后更新日期
            ,last_updated_by -- 最后更新人
            ,version_number -- 版本号
            ,dimension16 -- 分析维度16
            ,dimension17 -- 分析维度17
            ,dimension18 -- 分析维度18
            ,dimension19 -- 分析维度19
            ,dimension20 -- 分析维度20
            ,dimension21 -- 分析维度21
            ,dimension22 -- 分析维度22
            ,dimension23 -- 分析维度23
            ,dimension24 -- 分析维度24
            ,dimension25 -- 分析维度25
            ,dimension26 -- 分析维度26
            ,dimension27 -- 分析维度27
            ,dimension28 -- 分析维度28
            ,dimension29 -- 分析维度29
            ,dimension30 -- 分析维度30
            ,tenant_id -- 租户ID
            ,batch_number -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 会计分录ID
    ,o.source_flag -- 来源系统标识
    ,o.target_flag -- 目标系统标识
    ,o.error_message -- 错误信息
    ,o.ledger_code -- 账套
    ,o.company_code -- 会计主体1
    ,o.department_code -- 会计主体2
    ,o.period_name -- 会计日期1
    ,o.accounting_date -- 会计日期2
    ,o.account_code -- 会计要素1
    ,o.account_detail -- 会计要素2
    ,o.currency_code -- 货币计量1
    ,o.exchange_type -- 货币计量2
    ,o.exchange_date -- 货币计量3
    ,o.exchange_rate -- 货币计量4
    ,o.entered_amount_dr -- 会计度量1借方
    ,o.entered_amount_cr -- 会计度量1贷方
    ,o.functional_amount_dr -- 会计度量2借方
    ,o.functional_amount_cr -- 会计度量2贷方
    ,o.cashflow_category -- 现金流标识1
    ,o.cashflow_direction -- 现金流标识2
    ,o.dimension1 -- 分析维度1
    ,o.dimension2 -- 分析维度2
    ,o.dimension3 -- 分析维度3
    ,o.dimension4 -- 分析维度4
    ,o.dimension5 -- 分析维度5
    ,o.dimension6 -- 分析维度6
    ,o.dimension7 -- 分析维度7
    ,o.dimension8 -- 分析维度8
    ,o.dimension9 -- 分析维度9
    ,o.dimension10 -- 分析维度10
    ,o.dimension11 -- 分析维度11
    ,o.dimension12 -- 分析维度12
    ,o.dimension13 -- 分析维度13
    ,o.dimension14 -- 分析维度14
    ,o.dimension15 -- 分析维度15
    ,o.journal_number -- 凭证编号
    ,o.subtype_id -- 子类型id
    ,o.event_id -- 会计事件配置id
    ,o.transaction_type -- 来源事务code
    ,o.transaction_ins_id -- 来源事务实例id
    ,o.transaction_number -- 来源事务编码
    ,o.transaction_line_type -- 分录来源行类型code
    ,o.transaction_line_id -- 分录来源行id
    ,o.attribute1 -- 备用字段1
    ,o.attribute2 -- 备用字段2
    ,o.attribute3 -- 备用字段3
    ,o.attribute4 -- 备用字段4
    ,o.attribute5 -- 备用字段5
    ,o.created_date -- 创建日期
    ,o.created_by -- 创建人
    ,o.last_updated_date -- 最后更新日期
    ,o.last_updated_by -- 最后更新人
    ,o.version_number -- 版本号
    ,o.dimension16 -- 分析维度16
    ,o.dimension17 -- 分析维度17
    ,o.dimension18 -- 分析维度18
    ,o.dimension19 -- 分析维度19
    ,o.dimension20 -- 分析维度20
    ,o.dimension21 -- 分析维度21
    ,o.dimension22 -- 分析维度22
    ,o.dimension23 -- 分析维度23
    ,o.dimension24 -- 分析维度24
    ,o.dimension25 -- 分析维度25
    ,o.dimension26 -- 分析维度26
    ,o.dimension27 -- 分析维度27
    ,o.dimension28 -- 分析维度28
    ,o.dimension29 -- 分析维度29
    ,o.dimension30 -- 分析维度30
    ,o.tenant_id -- 租户ID
    ,o.batch_number -- 批次号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.lmis_hae_journal_entry_bk o
    left join ${iol_schema}.lmis_hae_journal_entry_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.lmis_hae_journal_entry_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.lmis_hae_journal_entry;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('lmis_hae_journal_entry') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.lmis_hae_journal_entry drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.lmis_hae_journal_entry add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.lmis_hae_journal_entry exchange partition p_${batch_date} with table ${iol_schema}.lmis_hae_journal_entry_cl;
alter table ${iol_schema}.lmis_hae_journal_entry exchange partition p_20991231 with table ${iol_schema}.lmis_hae_journal_entry_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.lmis_hae_journal_entry to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.lmis_hae_journal_entry_op purge;
drop table ${iol_schema}.lmis_hae_journal_entry_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.lmis_hae_journal_entry_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'lmis_hae_journal_entry',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
