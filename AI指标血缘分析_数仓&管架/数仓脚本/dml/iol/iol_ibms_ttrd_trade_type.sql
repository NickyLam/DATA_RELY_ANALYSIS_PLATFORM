/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_trade_type
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
create table ${iol_schema}.ibms_ttrd_trade_type_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_trade_type;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_trade_type_op purge;
drop table ${iol_schema}.ibms_ttrd_trade_type_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_trade_type_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_trade_type where 0=1;

create table ${iol_schema}.ibms_ttrd_trade_type_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_trade_type where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_trade_type_cl(
            trd_type -- 交易类型
            ,description -- 交易类型描述
            ,isperiod_inst -- 是否是周期指令 0：首期指令 1 :周期指令 2:存续期交易指令 3:存续期非交易指令
            ,ordernum -- 排序序号
            ,word_template_code -- WORD打印模板要素(选填)(审批单)
            ,batch_word_template_code -- 批量WORD打印模板要素(选填)(审批单)
            ,word_template_code_trade -- WORD打印模板要素(选填)(交易单)
            ,batch_word_template_code_trade -- 批量WORD打印模板要素(选填)(交易单)
            ,need_access -- 是否需要准入 0：不需要（默认）1：需要
            ,need_credit_risk -- 是否需要信用风险审查 0：不需要（默认）1：需要
            ,need_bond_access -- 是否需要校验准入库 0-否；1-是；
            ,parent_id -- 父ID
            ,leaf -- 是否叶子节点
            ,need_sppi_check -- 是否允许SPPI测试 0不允许1允许
            ,need_bw_list -- 是否黑白名单控制 1:是 0:否
            ,def_transfer_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_trade_type_op(
            trd_type -- 交易类型
            ,description -- 交易类型描述
            ,isperiod_inst -- 是否是周期指令 0：首期指令 1 :周期指令 2:存续期交易指令 3:存续期非交易指令
            ,ordernum -- 排序序号
            ,word_template_code -- WORD打印模板要素(选填)(审批单)
            ,batch_word_template_code -- 批量WORD打印模板要素(选填)(审批单)
            ,word_template_code_trade -- WORD打印模板要素(选填)(交易单)
            ,batch_word_template_code_trade -- 批量WORD打印模板要素(选填)(交易单)
            ,need_access -- 是否需要准入 0：不需要（默认）1：需要
            ,need_credit_risk -- 是否需要信用风险审查 0：不需要（默认）1：需要
            ,need_bond_access -- 是否需要校验准入库 0-否；1-是；
            ,parent_id -- 父ID
            ,leaf -- 是否叶子节点
            ,need_sppi_check -- 是否允许SPPI测试 0不允许1允许
            ,need_bw_list -- 是否黑白名单控制 1:是 0:否
            ,def_transfer_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trd_type, o.trd_type) as trd_type -- 交易类型
    ,nvl(n.description, o.description) as description -- 交易类型描述
    ,nvl(n.isperiod_inst, o.isperiod_inst) as isperiod_inst -- 是否是周期指令 0：首期指令 1 :周期指令 2:存续期交易指令 3:存续期非交易指令
    ,nvl(n.ordernum, o.ordernum) as ordernum -- 排序序号
    ,nvl(n.word_template_code, o.word_template_code) as word_template_code -- WORD打印模板要素(选填)(审批单)
    ,nvl(n.batch_word_template_code, o.batch_word_template_code) as batch_word_template_code -- 批量WORD打印模板要素(选填)(审批单)
    ,nvl(n.word_template_code_trade, o.word_template_code_trade) as word_template_code_trade -- WORD打印模板要素(选填)(交易单)
    ,nvl(n.batch_word_template_code_trade, o.batch_word_template_code_trade) as batch_word_template_code_trade -- 批量WORD打印模板要素(选填)(交易单)
    ,nvl(n.need_access, o.need_access) as need_access -- 是否需要准入 0：不需要（默认）1：需要
    ,nvl(n.need_credit_risk, o.need_credit_risk) as need_credit_risk -- 是否需要信用风险审查 0：不需要（默认）1：需要
    ,nvl(n.need_bond_access, o.need_bond_access) as need_bond_access -- 是否需要校验准入库 0-否；1-是；
    ,nvl(n.parent_id, o.parent_id) as parent_id -- 父ID
    ,nvl(n.leaf, o.leaf) as leaf -- 是否叶子节点
    ,nvl(n.need_sppi_check, o.need_sppi_check) as need_sppi_check -- 是否允许SPPI测试 0不允许1允许
    ,nvl(n.need_bw_list, o.need_bw_list) as need_bw_list -- 是否黑白名单控制 1:是 0:否
    ,nvl(n.def_transfer_type, o.def_transfer_type) as def_transfer_type -- 
    ,case when
            n.trd_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trd_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trd_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_trade_type_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_trade_type where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trd_type = n.trd_type
where (
        o.trd_type is null
    )
    or (
        n.trd_type is null
    )
    or (
        o.description <> n.description
        or o.isperiod_inst <> n.isperiod_inst
        or o.ordernum <> n.ordernum
        or o.word_template_code <> n.word_template_code
        or o.batch_word_template_code <> n.batch_word_template_code
        or o.word_template_code_trade <> n.word_template_code_trade
        or o.batch_word_template_code_trade <> n.batch_word_template_code_trade
        or o.need_access <> n.need_access
        or o.need_credit_risk <> n.need_credit_risk
        or o.need_bond_access <> n.need_bond_access
        or o.parent_id <> n.parent_id
        or o.leaf <> n.leaf
        or o.need_sppi_check <> n.need_sppi_check
        or o.need_bw_list <> n.need_bw_list
        or o.def_transfer_type <> n.def_transfer_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_trade_type_cl(
            trd_type -- 交易类型
            ,description -- 交易类型描述
            ,isperiod_inst -- 是否是周期指令 0：首期指令 1 :周期指令 2:存续期交易指令 3:存续期非交易指令
            ,ordernum -- 排序序号
            ,word_template_code -- WORD打印模板要素(选填)(审批单)
            ,batch_word_template_code -- 批量WORD打印模板要素(选填)(审批单)
            ,word_template_code_trade -- WORD打印模板要素(选填)(交易单)
            ,batch_word_template_code_trade -- 批量WORD打印模板要素(选填)(交易单)
            ,need_access -- 是否需要准入 0：不需要（默认）1：需要
            ,need_credit_risk -- 是否需要信用风险审查 0：不需要（默认）1：需要
            ,need_bond_access -- 是否需要校验准入库 0-否；1-是；
            ,parent_id -- 父ID
            ,leaf -- 是否叶子节点
            ,need_sppi_check -- 是否允许SPPI测试 0不允许1允许
            ,need_bw_list -- 是否黑白名单控制 1:是 0:否
            ,def_transfer_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_trade_type_op(
            trd_type -- 交易类型
            ,description -- 交易类型描述
            ,isperiod_inst -- 是否是周期指令 0：首期指令 1 :周期指令 2:存续期交易指令 3:存续期非交易指令
            ,ordernum -- 排序序号
            ,word_template_code -- WORD打印模板要素(选填)(审批单)
            ,batch_word_template_code -- 批量WORD打印模板要素(选填)(审批单)
            ,word_template_code_trade -- WORD打印模板要素(选填)(交易单)
            ,batch_word_template_code_trade -- 批量WORD打印模板要素(选填)(交易单)
            ,need_access -- 是否需要准入 0：不需要（默认）1：需要
            ,need_credit_risk -- 是否需要信用风险审查 0：不需要（默认）1：需要
            ,need_bond_access -- 是否需要校验准入库 0-否；1-是；
            ,parent_id -- 父ID
            ,leaf -- 是否叶子节点
            ,need_sppi_check -- 是否允许SPPI测试 0不允许1允许
            ,need_bw_list -- 是否黑白名单控制 1:是 0:否
            ,def_transfer_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trd_type -- 交易类型
    ,o.description -- 交易类型描述
    ,o.isperiod_inst -- 是否是周期指令 0：首期指令 1 :周期指令 2:存续期交易指令 3:存续期非交易指令
    ,o.ordernum -- 排序序号
    ,o.word_template_code -- WORD打印模板要素(选填)(审批单)
    ,o.batch_word_template_code -- 批量WORD打印模板要素(选填)(审批单)
    ,o.word_template_code_trade -- WORD打印模板要素(选填)(交易单)
    ,o.batch_word_template_code_trade -- 批量WORD打印模板要素(选填)(交易单)
    ,o.need_access -- 是否需要准入 0：不需要（默认）1：需要
    ,o.need_credit_risk -- 是否需要信用风险审查 0：不需要（默认）1：需要
    ,o.need_bond_access -- 是否需要校验准入库 0-否；1-是；
    ,o.parent_id -- 父ID
    ,o.leaf -- 是否叶子节点
    ,o.need_sppi_check -- 是否允许SPPI测试 0不允许1允许
    ,o.need_bw_list -- 是否黑白名单控制 1:是 0:否
    ,o.def_transfer_type -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_trade_type_bk o
    left join ${iol_schema}.ibms_ttrd_trade_type_op n
        on
            o.trd_type = n.trd_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_trade_type_cl d
        on
            o.trd_type = d.trd_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_trade_type;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_trade_type exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_trade_type_cl;
alter table ${iol_schema}.ibms_ttrd_trade_type exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_trade_type_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_trade_type to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_trade_type_op purge;
drop table ${iol_schema}.ibms_ttrd_trade_type_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_trade_type_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_trade_type',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
