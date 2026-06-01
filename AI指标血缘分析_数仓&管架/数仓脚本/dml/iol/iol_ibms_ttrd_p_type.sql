/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_p_type
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
create table ${iol_schema}.ibms_ttrd_p_type_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_p_type;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_p_type_op purge;
drop table ${iol_schema}.ibms_ttrd_p_type_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_p_type_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_p_type where 0=1;

create table ${iol_schema}.ibms_ttrd_p_type_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_p_type where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_p_type_cl(
            id -- 产品分类ID
            ,a_type -- 资产类型
            ,p_type -- 产品类型
            ,p_type_name -- 产品类型名称
            ,is_auto_prft -- 是否自动息差；1：是，0：否
            ,is_allow_delay -- 是否允许延迟到期；   0:自动确认   1:允许延期手动确认   2:不允许延期手动确认
            ,amort_method -- 摊销算法； -1:不摊销， 0:直线摊销， 1:到期收益率算法， 使用交易全价， 2:到期收益率算法， 使用条款全价， 3:平价收益率算法， 使用交易全价， 4:平价收益率算法， 使用条款全价， 5:日实际利率摊销算法， 使用公式计算的日摊销利息收入， 6:日实际利率摊销算法， 使用公式计算的日实际利息收入， 7:年实际利率摊销算法， 使用公式计算的日摊销利息收入， 8:年实际利率摊销算法， 使用公式计算的日实际利息收入， 9:到期收益率算法，每天贴现，使用交易全价， 10:到期收益率算法，每天贴现，使用条款全价， 11:平价收益率算法，每天贴现，使用交易全价， 12:平价收益率算法，每天贴现，使用条款全价
            ,amort_method_name -- 摊销算法名称
            ,is_tprice -- 是否估值
            ,fv_type -- 估值类型；   0:不估值，   1:手工维护优先，次之外部导入，最后系统定价,   2:手工维护优先，而后系统定价，最后外部导入   3:手工维护优先，而后外部导入，不使用系统定价
            ,is_allow_withdraw -- 是否允许支取 0:不允许支持 1:允许支持（不需要审批） 2:允许支持（需要审批）
            ,is_allow_accrue -- 是否允许计提
            ,is_allow_receiveai -- 是否允许随时收息
            ,is_auto_overdue -- 是否自动逾期;1:是，0：否
            ,pending_account -- 挂账账户
            ,pending_account_name -- 挂账账户户名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_p_type_op(
            id -- 产品分类ID
            ,a_type -- 资产类型
            ,p_type -- 产品类型
            ,p_type_name -- 产品类型名称
            ,is_auto_prft -- 是否自动息差；1：是，0：否
            ,is_allow_delay -- 是否允许延迟到期；   0:自动确认   1:允许延期手动确认   2:不允许延期手动确认
            ,amort_method -- 摊销算法； -1:不摊销， 0:直线摊销， 1:到期收益率算法， 使用交易全价， 2:到期收益率算法， 使用条款全价， 3:平价收益率算法， 使用交易全价， 4:平价收益率算法， 使用条款全价， 5:日实际利率摊销算法， 使用公式计算的日摊销利息收入， 6:日实际利率摊销算法， 使用公式计算的日实际利息收入， 7:年实际利率摊销算法， 使用公式计算的日摊销利息收入， 8:年实际利率摊销算法， 使用公式计算的日实际利息收入， 9:到期收益率算法，每天贴现，使用交易全价， 10:到期收益率算法，每天贴现，使用条款全价， 11:平价收益率算法，每天贴现，使用交易全价， 12:平价收益率算法，每天贴现，使用条款全价
            ,amort_method_name -- 摊销算法名称
            ,is_tprice -- 是否估值
            ,fv_type -- 估值类型；   0:不估值，   1:手工维护优先，次之外部导入，最后系统定价,   2:手工维护优先，而后系统定价，最后外部导入   3:手工维护优先，而后外部导入，不使用系统定价
            ,is_allow_withdraw -- 是否允许支取 0:不允许支持 1:允许支持（不需要审批） 2:允许支持（需要审批）
            ,is_allow_accrue -- 是否允许计提
            ,is_allow_receiveai -- 是否允许随时收息
            ,is_auto_overdue -- 是否自动逾期;1:是，0：否
            ,pending_account -- 挂账账户
            ,pending_account_name -- 挂账账户户名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 产品分类ID
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.p_type, o.p_type) as p_type -- 产品类型
    ,nvl(n.p_type_name, o.p_type_name) as p_type_name -- 产品类型名称
    ,nvl(n.is_auto_prft, o.is_auto_prft) as is_auto_prft -- 是否自动息差；1：是，0：否
    ,nvl(n.is_allow_delay, o.is_allow_delay) as is_allow_delay -- 是否允许延迟到期；   0:自动确认   1:允许延期手动确认   2:不允许延期手动确认
    ,nvl(n.amort_method, o.amort_method) as amort_method -- 摊销算法； -1:不摊销， 0:直线摊销， 1:到期收益率算法， 使用交易全价， 2:到期收益率算法， 使用条款全价， 3:平价收益率算法， 使用交易全价， 4:平价收益率算法， 使用条款全价， 5:日实际利率摊销算法， 使用公式计算的日摊销利息收入， 6:日实际利率摊销算法， 使用公式计算的日实际利息收入， 7:年实际利率摊销算法， 使用公式计算的日摊销利息收入， 8:年实际利率摊销算法， 使用公式计算的日实际利息收入， 9:到期收益率算法，每天贴现，使用交易全价， 10:到期收益率算法，每天贴现，使用条款全价， 11:平价收益率算法，每天贴现，使用交易全价， 12:平价收益率算法，每天贴现，使用条款全价
    ,nvl(n.amort_method_name, o.amort_method_name) as amort_method_name -- 摊销算法名称
    ,nvl(n.is_tprice, o.is_tprice) as is_tprice -- 是否估值
    ,nvl(n.fv_type, o.fv_type) as fv_type -- 估值类型；   0:不估值，   1:手工维护优先，次之外部导入，最后系统定价,   2:手工维护优先，而后系统定价，最后外部导入   3:手工维护优先，而后外部导入，不使用系统定价
    ,nvl(n.is_allow_withdraw, o.is_allow_withdraw) as is_allow_withdraw -- 是否允许支取 0:不允许支持 1:允许支持（不需要审批） 2:允许支持（需要审批）
    ,nvl(n.is_allow_accrue, o.is_allow_accrue) as is_allow_accrue -- 是否允许计提
    ,nvl(n.is_allow_receiveai, o.is_allow_receiveai) as is_allow_receiveai -- 是否允许随时收息
    ,nvl(n.is_auto_overdue, o.is_auto_overdue) as is_auto_overdue -- 是否自动逾期;1:是，0：否
    ,nvl(n.pending_account, o.pending_account) as pending_account -- 挂账账户
    ,nvl(n.pending_account_name, o.pending_account_name) as pending_account_name -- 挂账账户户名
    ,case when
            n.p_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.p_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.p_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_p_type_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_p_type where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.p_type = n.p_type
where (
        o.p_type is null
    )
    or (
        n.p_type is null
    )
    or (
        o.id <> n.id
        or o.a_type <> n.a_type
        or o.p_type_name <> n.p_type_name
        or o.is_auto_prft <> n.is_auto_prft
        or o.is_allow_delay <> n.is_allow_delay
        or o.amort_method <> n.amort_method
        or o.amort_method_name <> n.amort_method_name
        or o.is_tprice <> n.is_tprice
        or o.fv_type <> n.fv_type
        or o.is_allow_withdraw <> n.is_allow_withdraw
        or o.is_allow_accrue <> n.is_allow_accrue
        or o.is_allow_receiveai <> n.is_allow_receiveai
        or o.is_auto_overdue <> n.is_auto_overdue
        or o.pending_account <> n.pending_account
        or o.pending_account_name <> n.pending_account_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_p_type_cl(
            id -- 产品分类ID
            ,a_type -- 资产类型
            ,p_type -- 产品类型
            ,p_type_name -- 产品类型名称
            ,is_auto_prft -- 是否自动息差；1：是，0：否
            ,is_allow_delay -- 是否允许延迟到期；   0:自动确认   1:允许延期手动确认   2:不允许延期手动确认
            ,amort_method -- 摊销算法； -1:不摊销， 0:直线摊销， 1:到期收益率算法， 使用交易全价， 2:到期收益率算法， 使用条款全价， 3:平价收益率算法， 使用交易全价， 4:平价收益率算法， 使用条款全价， 5:日实际利率摊销算法， 使用公式计算的日摊销利息收入， 6:日实际利率摊销算法， 使用公式计算的日实际利息收入， 7:年实际利率摊销算法， 使用公式计算的日摊销利息收入， 8:年实际利率摊销算法， 使用公式计算的日实际利息收入， 9:到期收益率算法，每天贴现，使用交易全价， 10:到期收益率算法，每天贴现，使用条款全价， 11:平价收益率算法，每天贴现，使用交易全价， 12:平价收益率算法，每天贴现，使用条款全价
            ,amort_method_name -- 摊销算法名称
            ,is_tprice -- 是否估值
            ,fv_type -- 估值类型；   0:不估值，   1:手工维护优先，次之外部导入，最后系统定价,   2:手工维护优先，而后系统定价，最后外部导入   3:手工维护优先，而后外部导入，不使用系统定价
            ,is_allow_withdraw -- 是否允许支取 0:不允许支持 1:允许支持（不需要审批） 2:允许支持（需要审批）
            ,is_allow_accrue -- 是否允许计提
            ,is_allow_receiveai -- 是否允许随时收息
            ,is_auto_overdue -- 是否自动逾期;1:是，0：否
            ,pending_account -- 挂账账户
            ,pending_account_name -- 挂账账户户名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_p_type_op(
            id -- 产品分类ID
            ,a_type -- 资产类型
            ,p_type -- 产品类型
            ,p_type_name -- 产品类型名称
            ,is_auto_prft -- 是否自动息差；1：是，0：否
            ,is_allow_delay -- 是否允许延迟到期；   0:自动确认   1:允许延期手动确认   2:不允许延期手动确认
            ,amort_method -- 摊销算法； -1:不摊销， 0:直线摊销， 1:到期收益率算法， 使用交易全价， 2:到期收益率算法， 使用条款全价， 3:平价收益率算法， 使用交易全价， 4:平价收益率算法， 使用条款全价， 5:日实际利率摊销算法， 使用公式计算的日摊销利息收入， 6:日实际利率摊销算法， 使用公式计算的日实际利息收入， 7:年实际利率摊销算法， 使用公式计算的日摊销利息收入， 8:年实际利率摊销算法， 使用公式计算的日实际利息收入， 9:到期收益率算法，每天贴现，使用交易全价， 10:到期收益率算法，每天贴现，使用条款全价， 11:平价收益率算法，每天贴现，使用交易全价， 12:平价收益率算法，每天贴现，使用条款全价
            ,amort_method_name -- 摊销算法名称
            ,is_tprice -- 是否估值
            ,fv_type -- 估值类型；   0:不估值，   1:手工维护优先，次之外部导入，最后系统定价,   2:手工维护优先，而后系统定价，最后外部导入   3:手工维护优先，而后外部导入，不使用系统定价
            ,is_allow_withdraw -- 是否允许支取 0:不允许支持 1:允许支持（不需要审批） 2:允许支持（需要审批）
            ,is_allow_accrue -- 是否允许计提
            ,is_allow_receiveai -- 是否允许随时收息
            ,is_auto_overdue -- 是否自动逾期;1:是，0：否
            ,pending_account -- 挂账账户
            ,pending_account_name -- 挂账账户户名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 产品分类ID
    ,o.a_type -- 资产类型
    ,o.p_type -- 产品类型
    ,o.p_type_name -- 产品类型名称
    ,o.is_auto_prft -- 是否自动息差；1：是，0：否
    ,o.is_allow_delay -- 是否允许延迟到期；   0:自动确认   1:允许延期手动确认   2:不允许延期手动确认
    ,o.amort_method -- 摊销算法； -1:不摊销， 0:直线摊销， 1:到期收益率算法， 使用交易全价， 2:到期收益率算法， 使用条款全价， 3:平价收益率算法， 使用交易全价， 4:平价收益率算法， 使用条款全价， 5:日实际利率摊销算法， 使用公式计算的日摊销利息收入， 6:日实际利率摊销算法， 使用公式计算的日实际利息收入， 7:年实际利率摊销算法， 使用公式计算的日摊销利息收入， 8:年实际利率摊销算法， 使用公式计算的日实际利息收入， 9:到期收益率算法，每天贴现，使用交易全价， 10:到期收益率算法，每天贴现，使用条款全价， 11:平价收益率算法，每天贴现，使用交易全价， 12:平价收益率算法，每天贴现，使用条款全价
    ,o.amort_method_name -- 摊销算法名称
    ,o.is_tprice -- 是否估值
    ,o.fv_type -- 估值类型；   0:不估值，   1:手工维护优先，次之外部导入，最后系统定价,   2:手工维护优先，而后系统定价，最后外部导入   3:手工维护优先，而后外部导入，不使用系统定价
    ,o.is_allow_withdraw -- 是否允许支取 0:不允许支持 1:允许支持（不需要审批） 2:允许支持（需要审批）
    ,o.is_allow_accrue -- 是否允许计提
    ,o.is_allow_receiveai -- 是否允许随时收息
    ,o.is_auto_overdue -- 是否自动逾期;1:是，0：否
    ,o.pending_account -- 挂账账户
    ,o.pending_account_name -- 挂账账户户名
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_p_type_bk o
    left join ${iol_schema}.ibms_ttrd_p_type_op n
        on
            o.p_type = n.p_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_p_type_cl d
        on
            o.p_type = d.p_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_p_type;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_p_type exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_p_type_cl;
alter table ${iol_schema}.ibms_ttrd_p_type exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_p_type_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_p_type to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_p_type_op purge;
drop table ${iol_schema}.ibms_ttrd_p_type_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_p_type_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_p_type',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
