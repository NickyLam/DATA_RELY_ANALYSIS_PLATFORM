/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_acc_secu_ext
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
create table ${iol_schema}.ibms_ttrd_acc_secu_ext_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_acc_secu_ext;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_acc_secu_ext_op purge;
drop table ${iol_schema}.ibms_ttrd_acc_secu_ext_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acc_secu_ext_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_acc_secu_ext where 0=1;

create table ${iol_schema}.ibms_ttrd_acc_secu_ext_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_acc_secu_ext where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_acc_secu_ext_cl(
            accid -- 账户代码
            ,accname -- 账户名称
            ,market -- 交易市场
            ,exhacc -- 交易所账户
            ,exhseat -- 交易所席位
            ,acctype -- 账户类型
            ,status -- 账户状态
            ,exec_mode -- 执行模式
            ,grade -- 甲乙丙丁
            ,cash_ext_accid -- 外部资金账户ID
            ,host_market -- 托管场所
            ,i_id -- 机构号
            ,spv_id -- SPV信息ID
            ,s_pset -- 结算场所代码
            ,s_pset_name -- 结算场所名称
            ,s_pset_country -- 国家代码
            ,s_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
            ,s_agent_code_dss -- 代理行代码编码集合名称
            ,s_agent_code -- 代理行代码
            ,s_agent_account -- 代理行账号
            ,s_code_type -- 交易主体代码类型,1:BIC,2:DSS
            ,s_code_dss -- 交易主体代码编码集合名称
            ,s_code -- 交易主体代码
            ,s_account -- 交易主体账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_acc_secu_ext_op(
            accid -- 账户代码
            ,accname -- 账户名称
            ,market -- 交易市场
            ,exhacc -- 交易所账户
            ,exhseat -- 交易所席位
            ,acctype -- 账户类型
            ,status -- 账户状态
            ,exec_mode -- 执行模式
            ,grade -- 甲乙丙丁
            ,cash_ext_accid -- 外部资金账户ID
            ,host_market -- 托管场所
            ,i_id -- 机构号
            ,spv_id -- SPV信息ID
            ,s_pset -- 结算场所代码
            ,s_pset_name -- 结算场所名称
            ,s_pset_country -- 国家代码
            ,s_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
            ,s_agent_code_dss -- 代理行代码编码集合名称
            ,s_agent_code -- 代理行代码
            ,s_agent_account -- 代理行账号
            ,s_code_type -- 交易主体代码类型,1:BIC,2:DSS
            ,s_code_dss -- 交易主体代码编码集合名称
            ,s_code -- 交易主体代码
            ,s_account -- 交易主体账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.accid, o.accid) as accid -- 账户代码
    ,nvl(n.accname, o.accname) as accname -- 账户名称
    ,nvl(n.market, o.market) as market -- 交易市场
    ,nvl(n.exhacc, o.exhacc) as exhacc -- 交易所账户
    ,nvl(n.exhseat, o.exhseat) as exhseat -- 交易所席位
    ,nvl(n.acctype, o.acctype) as acctype -- 账户类型
    ,nvl(n.status, o.status) as status -- 账户状态
    ,nvl(n.exec_mode, o.exec_mode) as exec_mode -- 执行模式
    ,nvl(n.grade, o.grade) as grade -- 甲乙丙丁
    ,nvl(n.cash_ext_accid, o.cash_ext_accid) as cash_ext_accid -- 外部资金账户ID
    ,nvl(n.host_market, o.host_market) as host_market -- 托管场所
    ,nvl(n.i_id, o.i_id) as i_id -- 机构号
    ,nvl(n.spv_id, o.spv_id) as spv_id -- SPV信息ID
    ,nvl(n.s_pset, o.s_pset) as s_pset -- 结算场所代码
    ,nvl(n.s_pset_name, o.s_pset_name) as s_pset_name -- 结算场所名称
    ,nvl(n.s_pset_country, o.s_pset_country) as s_pset_country -- 国家代码
    ,nvl(n.s_agent_code_type, o.s_agent_code_type) as s_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
    ,nvl(n.s_agent_code_dss, o.s_agent_code_dss) as s_agent_code_dss -- 代理行代码编码集合名称
    ,nvl(n.s_agent_code, o.s_agent_code) as s_agent_code -- 代理行代码
    ,nvl(n.s_agent_account, o.s_agent_account) as s_agent_account -- 代理行账号
    ,nvl(n.s_code_type, o.s_code_type) as s_code_type -- 交易主体代码类型,1:BIC,2:DSS
    ,nvl(n.s_code_dss, o.s_code_dss) as s_code_dss -- 交易主体代码编码集合名称
    ,nvl(n.s_code, o.s_code) as s_code -- 交易主体代码
    ,nvl(n.s_account, o.s_account) as s_account -- 交易主体账号
    ,case when
            n.accid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.accid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.accid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_acc_secu_ext_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_acc_secu_ext where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.accid = n.accid
where (
        o.accid is null
    )
    or (
        n.accid is null
    )
    or (
        o.accname <> n.accname
        or o.market <> n.market
        or o.exhacc <> n.exhacc
        or o.exhseat <> n.exhseat
        or o.acctype <> n.acctype
        or o.status <> n.status
        or o.exec_mode <> n.exec_mode
        or o.grade <> n.grade
        or o.cash_ext_accid <> n.cash_ext_accid
        or o.host_market <> n.host_market
        or o.i_id <> n.i_id
        or o.spv_id <> n.spv_id
        or o.s_pset <> n.s_pset
        or o.s_pset_name <> n.s_pset_name
        or o.s_pset_country <> n.s_pset_country
        or o.s_agent_code_type <> n.s_agent_code_type
        or o.s_agent_code_dss <> n.s_agent_code_dss
        or o.s_agent_code <> n.s_agent_code
        or o.s_agent_account <> n.s_agent_account
        or o.s_code_type <> n.s_code_type
        or o.s_code_dss <> n.s_code_dss
        or o.s_code <> n.s_code
        or o.s_account <> n.s_account
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_acc_secu_ext_cl(
            accid -- 账户代码
            ,accname -- 账户名称
            ,market -- 交易市场
            ,exhacc -- 交易所账户
            ,exhseat -- 交易所席位
            ,acctype -- 账户类型
            ,status -- 账户状态
            ,exec_mode -- 执行模式
            ,grade -- 甲乙丙丁
            ,cash_ext_accid -- 外部资金账户ID
            ,host_market -- 托管场所
            ,i_id -- 机构号
            ,spv_id -- SPV信息ID
            ,s_pset -- 结算场所代码
            ,s_pset_name -- 结算场所名称
            ,s_pset_country -- 国家代码
            ,s_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
            ,s_agent_code_dss -- 代理行代码编码集合名称
            ,s_agent_code -- 代理行代码
            ,s_agent_account -- 代理行账号
            ,s_code_type -- 交易主体代码类型,1:BIC,2:DSS
            ,s_code_dss -- 交易主体代码编码集合名称
            ,s_code -- 交易主体代码
            ,s_account -- 交易主体账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_acc_secu_ext_op(
            accid -- 账户代码
            ,accname -- 账户名称
            ,market -- 交易市场
            ,exhacc -- 交易所账户
            ,exhseat -- 交易所席位
            ,acctype -- 账户类型
            ,status -- 账户状态
            ,exec_mode -- 执行模式
            ,grade -- 甲乙丙丁
            ,cash_ext_accid -- 外部资金账户ID
            ,host_market -- 托管场所
            ,i_id -- 机构号
            ,spv_id -- SPV信息ID
            ,s_pset -- 结算场所代码
            ,s_pset_name -- 结算场所名称
            ,s_pset_country -- 国家代码
            ,s_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
            ,s_agent_code_dss -- 代理行代码编码集合名称
            ,s_agent_code -- 代理行代码
            ,s_agent_account -- 代理行账号
            ,s_code_type -- 交易主体代码类型,1:BIC,2:DSS
            ,s_code_dss -- 交易主体代码编码集合名称
            ,s_code -- 交易主体代码
            ,s_account -- 交易主体账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.accid -- 账户代码
    ,o.accname -- 账户名称
    ,o.market -- 交易市场
    ,o.exhacc -- 交易所账户
    ,o.exhseat -- 交易所席位
    ,o.acctype -- 账户类型
    ,o.status -- 账户状态
    ,o.exec_mode -- 执行模式
    ,o.grade -- 甲乙丙丁
    ,o.cash_ext_accid -- 外部资金账户ID
    ,o.host_market -- 托管场所
    ,o.i_id -- 机构号
    ,o.spv_id -- SPV信息ID
    ,o.s_pset -- 结算场所代码
    ,o.s_pset_name -- 结算场所名称
    ,o.s_pset_country -- 国家代码
    ,o.s_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
    ,o.s_agent_code_dss -- 代理行代码编码集合名称
    ,o.s_agent_code -- 代理行代码
    ,o.s_agent_account -- 代理行账号
    ,o.s_code_type -- 交易主体代码类型,1:BIC,2:DSS
    ,o.s_code_dss -- 交易主体代码编码集合名称
    ,o.s_code -- 交易主体代码
    ,o.s_account -- 交易主体账号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_acc_secu_ext_bk o
    left join ${iol_schema}.ibms_ttrd_acc_secu_ext_op n
        on
            o.accid = n.accid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_acc_secu_ext_cl d
        on
            o.accid = d.accid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_acc_secu_ext;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_acc_secu_ext exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_acc_secu_ext_cl;
alter table ${iol_schema}.ibms_ttrd_acc_secu_ext exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_acc_secu_ext_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_acc_secu_ext to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_acc_secu_ext_op purge;
drop table ${iol_schema}.ibms_ttrd_acc_secu_ext_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_acc_secu_ext_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_acc_secu_ext',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
