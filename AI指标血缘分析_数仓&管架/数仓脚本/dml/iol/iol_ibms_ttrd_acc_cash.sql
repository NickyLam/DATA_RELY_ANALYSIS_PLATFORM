/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_acc_cash
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
create table ${iol_schema}.ibms_ttrd_acc_cash_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_acc_cash;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_acc_cash_op purge;
drop table ${iol_schema}.ibms_ttrd_acc_cash_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acc_cash_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_acc_cash where 0=1;

create table ${iol_schema}.ibms_ttrd_acc_cash_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_acc_cash where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_acc_cash_cl(
            accid -- 账户代码
            ,accname -- 账户名称
            ,status -- 账户状态 3：停用 11：已启用
            ,remark -- 备注
            ,pc1 -- 资金账户属性1 理财产品定义id
            ,pc2 -- 资金账户属性2
            ,pc3 -- 资金账户属性3
            ,pc4 -- 资金账户属性4
            ,currency -- 币种
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,i_id -- 机构号
            ,pp_env_code -- 定价环境代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_acc_cash_op(
            accid -- 账户代码
            ,accname -- 账户名称
            ,status -- 账户状态 3：停用 11：已启用
            ,remark -- 备注
            ,pc1 -- 资金账户属性1 理财产品定义id
            ,pc2 -- 资金账户属性2
            ,pc3 -- 资金账户属性3
            ,pc4 -- 资金账户属性4
            ,currency -- 币种
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,i_id -- 机构号
            ,pp_env_code -- 定价环境代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.accid, o.accid) as accid -- 账户代码
    ,nvl(n.accname, o.accname) as accname -- 账户名称
    ,nvl(n.status, o.status) as status -- 账户状态 3：停用 11：已启用
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.pc1, o.pc1) as pc1 -- 资金账户属性1 理财产品定义id
    ,nvl(n.pc2, o.pc2) as pc2 -- 资金账户属性2
    ,nvl(n.pc3, o.pc3) as pc3 -- 资金账户属性3
    ,nvl(n.pc4, o.pc4) as pc4 -- 资金账户属性4
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.invest_type, o.invest_type) as invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
    ,nvl(n.i_id, o.i_id) as i_id -- 机构号
    ,nvl(n.pp_env_code, o.pp_env_code) as pp_env_code -- 定价环境代码
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
from (select * from ${iol_schema}.ibms_ttrd_acc_cash_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_acc_cash where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.status <> n.status
        or o.remark <> n.remark
        or o.pc1 <> n.pc1
        or o.pc2 <> n.pc2
        or o.pc3 <> n.pc3
        or o.pc4 <> n.pc4
        or o.currency <> n.currency
        or o.invest_type <> n.invest_type
        or o.i_id <> n.i_id
        or o.pp_env_code <> n.pp_env_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_acc_cash_cl(
            accid -- 账户代码
            ,accname -- 账户名称
            ,status -- 账户状态 3：停用 11：已启用
            ,remark -- 备注
            ,pc1 -- 资金账户属性1 理财产品定义id
            ,pc2 -- 资金账户属性2
            ,pc3 -- 资金账户属性3
            ,pc4 -- 资金账户属性4
            ,currency -- 币种
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,i_id -- 机构号
            ,pp_env_code -- 定价环境代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_acc_cash_op(
            accid -- 账户代码
            ,accname -- 账户名称
            ,status -- 账户状态 3：停用 11：已启用
            ,remark -- 备注
            ,pc1 -- 资金账户属性1 理财产品定义id
            ,pc2 -- 资金账户属性2
            ,pc3 -- 资金账户属性3
            ,pc4 -- 资金账户属性4
            ,currency -- 币种
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,i_id -- 机构号
            ,pp_env_code -- 定价环境代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.accid -- 账户代码
    ,o.accname -- 账户名称
    ,o.status -- 账户状态 3：停用 11：已启用
    ,o.remark -- 备注
    ,o.pc1 -- 资金账户属性1 理财产品定义id
    ,o.pc2 -- 资金账户属性2
    ,o.pc3 -- 资金账户属性3
    ,o.pc4 -- 资金账户属性4
    ,o.currency -- 币种
    ,o.invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
    ,o.i_id -- 机构号
    ,o.pp_env_code -- 定价环境代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_acc_cash_bk o
    left join ${iol_schema}.ibms_ttrd_acc_cash_op n
        on
            o.accid = n.accid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_acc_cash_cl d
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
-- truncate table ${iol_schema}.ibms_ttrd_acc_cash;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_acc_cash exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_acc_cash_cl;
alter table ${iol_schema}.ibms_ttrd_acc_cash exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_acc_cash_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_acc_cash to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_acc_cash_op purge;
drop table ${iol_schema}.ibms_ttrd_acc_cash_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_acc_cash_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_acc_cash',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
