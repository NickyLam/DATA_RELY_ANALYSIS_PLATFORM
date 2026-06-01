/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_bd_account
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
create table ${iol_schema}.iers_bd_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_bd_account
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_account_op purge;
drop table ${iol_schema}.iers_bd_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_account_op nologging
for exchange with table
${iol_schema}.iers_bd_account;

create table ${iol_schema}.iers_bd_account_cl nologging
for exchange with table
${iol_schema}.iers_bd_account;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_account_cl(
            acclev -- 科目级次
            ,accproperty -- 科目属性
            ,balancetype -- 
            ,balanflag -- 
            ,balanorient -- 科目方向
            ,bankacc -- 
            ,billdate -- 单据日期
            ,billnumber -- 
            ,billtype -- 单据类型
            ,bothorient -- 
            ,cashtype -- 现金分类
            ,code -- 科目编码
            ,combineform -- 合并报表科目
            ,currency -- 
            ,dataoriginflag -- 数据来源
            ,dr -- 删除标志
            ,enablestate -- 使用状态
            ,incurflag -- 
            ,inneracc -- 
            ,innercode -- 内部码
            ,innerinfo -- 
            ,name -- 名称
            ,name2 -- 名称2
            ,name3 -- 名称3
            ,name4 -- 名称4
            ,name5 -- 名称5
            ,name6 -- 名称6
            ,nparallelaccounts -- 平行记账例外科目
            ,outflag -- 表外科目
            ,parallelaccounts -- 平行记账标志
            ,pid -- 上级科目
            ,pk_accchart -- 创建科目表
            ,pk_account -- 主键
            ,pk_acctype -- 科目类型
            ,pk_originalaccount -- 原始科目主键
            ,price -- 单价
            ,quantity -- 
            ,remcode -- 助记码
            ,sumprint_level -- 
            ,ts -- 时间戳
            ,unit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_account_op(
            acclev -- 科目级次
            ,accproperty -- 科目属性
            ,balancetype -- 
            ,balanflag -- 
            ,balanorient -- 科目方向
            ,bankacc -- 
            ,billdate -- 单据日期
            ,billnumber -- 
            ,billtype -- 单据类型
            ,bothorient -- 
            ,cashtype -- 现金分类
            ,code -- 科目编码
            ,combineform -- 合并报表科目
            ,currency -- 
            ,dataoriginflag -- 数据来源
            ,dr -- 删除标志
            ,enablestate -- 使用状态
            ,incurflag -- 
            ,inneracc -- 
            ,innercode -- 内部码
            ,innerinfo -- 
            ,name -- 名称
            ,name2 -- 名称2
            ,name3 -- 名称3
            ,name4 -- 名称4
            ,name5 -- 名称5
            ,name6 -- 名称6
            ,nparallelaccounts -- 平行记账例外科目
            ,outflag -- 表外科目
            ,parallelaccounts -- 平行记账标志
            ,pid -- 上级科目
            ,pk_accchart -- 创建科目表
            ,pk_account -- 主键
            ,pk_acctype -- 科目类型
            ,pk_originalaccount -- 原始科目主键
            ,price -- 单价
            ,quantity -- 
            ,remcode -- 助记码
            ,sumprint_level -- 
            ,ts -- 时间戳
            ,unit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acclev, o.acclev) as acclev -- 科目级次
    ,nvl(n.accproperty, o.accproperty) as accproperty -- 科目属性
    ,nvl(n.balancetype, o.balancetype) as balancetype -- 
    ,nvl(n.balanflag, o.balanflag) as balanflag -- 
    ,nvl(n.balanorient, o.balanorient) as balanorient -- 科目方向
    ,nvl(n.bankacc, o.bankacc) as bankacc -- 
    ,nvl(n.billdate, o.billdate) as billdate -- 单据日期
    ,nvl(n.billnumber, o.billnumber) as billnumber -- 
    ,nvl(n.billtype, o.billtype) as billtype -- 单据类型
    ,nvl(n.bothorient, o.bothorient) as bothorient -- 
    ,nvl(n.cashtype, o.cashtype) as cashtype -- 现金分类
    ,nvl(n.code, o.code) as code -- 科目编码
    ,nvl(n.combineform, o.combineform) as combineform -- 合并报表科目
    ,nvl(n.currency, o.currency) as currency -- 
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 数据来源
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 使用状态
    ,nvl(n.incurflag, o.incurflag) as incurflag -- 
    ,nvl(n.inneracc, o.inneracc) as inneracc -- 
    ,nvl(n.innercode, o.innercode) as innercode -- 内部码
    ,nvl(n.innerinfo, o.innerinfo) as innerinfo -- 
    ,nvl(n.name, o.name) as name -- 名称
    ,nvl(n.name2, o.name2) as name2 -- 名称2
    ,nvl(n.name3, o.name3) as name3 -- 名称3
    ,nvl(n.name4, o.name4) as name4 -- 名称4
    ,nvl(n.name5, o.name5) as name5 -- 名称5
    ,nvl(n.name6, o.name6) as name6 -- 名称6
    ,nvl(n.nparallelaccounts, o.nparallelaccounts) as nparallelaccounts -- 平行记账例外科目
    ,nvl(n.outflag, o.outflag) as outflag -- 表外科目
    ,nvl(n.parallelaccounts, o.parallelaccounts) as parallelaccounts -- 平行记账标志
    ,nvl(n.pid, o.pid) as pid -- 上级科目
    ,nvl(n.pk_accchart, o.pk_accchart) as pk_accchart -- 创建科目表
    ,nvl(n.pk_account, o.pk_account) as pk_account -- 主键
    ,nvl(n.pk_acctype, o.pk_acctype) as pk_acctype -- 科目类型
    ,nvl(n.pk_originalaccount, o.pk_originalaccount) as pk_originalaccount -- 原始科目主键
    ,nvl(n.price, o.price) as price -- 单价
    ,nvl(n.quantity, o.quantity) as quantity -- 
    ,nvl(n.remcode, o.remcode) as remcode -- 助记码
    ,nvl(n.sumprint_level, o.sumprint_level) as sumprint_level -- 
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.unit, o.unit) as unit -- 
    ,case when
            n.pk_account is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_account is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_account is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_bd_account_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_bd_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_account = n.pk_account
where (
        o.pk_account is null
    )
    or (
        n.pk_account is null
    )
    or (
        o.acclev <> n.acclev
        or o.accproperty <> n.accproperty
        or o.balancetype <> n.balancetype
        or o.balanflag <> n.balanflag
        or o.balanorient <> n.balanorient
        or o.bankacc <> n.bankacc
        or o.billdate <> n.billdate
        or o.billnumber <> n.billnumber
        or o.billtype <> n.billtype
        or o.bothorient <> n.bothorient
        or o.cashtype <> n.cashtype
        or o.code <> n.code
        or o.combineform <> n.combineform
        or o.currency <> n.currency
        or o.dataoriginflag <> n.dataoriginflag
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.incurflag <> n.incurflag
        or o.inneracc <> n.inneracc
        or o.innercode <> n.innercode
        or o.innerinfo <> n.innerinfo
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.nparallelaccounts <> n.nparallelaccounts
        or o.outflag <> n.outflag
        or o.parallelaccounts <> n.parallelaccounts
        or o.pid <> n.pid
        or o.pk_accchart <> n.pk_accchart
        or o.pk_acctype <> n.pk_acctype
        or o.pk_originalaccount <> n.pk_originalaccount
        or o.price <> n.price
        or o.quantity <> n.quantity
        or o.remcode <> n.remcode
        or o.sumprint_level <> n.sumprint_level
        or o.ts <> n.ts
        or o.unit <> n.unit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_account_cl(
            acclev -- 科目级次
            ,accproperty -- 科目属性
            ,balancetype -- 
            ,balanflag -- 
            ,balanorient -- 科目方向
            ,bankacc -- 
            ,billdate -- 单据日期
            ,billnumber -- 
            ,billtype -- 单据类型
            ,bothorient -- 
            ,cashtype -- 现金分类
            ,code -- 科目编码
            ,combineform -- 合并报表科目
            ,currency -- 
            ,dataoriginflag -- 数据来源
            ,dr -- 删除标志
            ,enablestate -- 使用状态
            ,incurflag -- 
            ,inneracc -- 
            ,innercode -- 内部码
            ,innerinfo -- 
            ,name -- 名称
            ,name2 -- 名称2
            ,name3 -- 名称3
            ,name4 -- 名称4
            ,name5 -- 名称5
            ,name6 -- 名称6
            ,nparallelaccounts -- 平行记账例外科目
            ,outflag -- 表外科目
            ,parallelaccounts -- 平行记账标志
            ,pid -- 上级科目
            ,pk_accchart -- 创建科目表
            ,pk_account -- 主键
            ,pk_acctype -- 科目类型
            ,pk_originalaccount -- 原始科目主键
            ,price -- 单价
            ,quantity -- 
            ,remcode -- 助记码
            ,sumprint_level -- 
            ,ts -- 时间戳
            ,unit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_account_op(
            acclev -- 科目级次
            ,accproperty -- 科目属性
            ,balancetype -- 
            ,balanflag -- 
            ,balanorient -- 科目方向
            ,bankacc -- 
            ,billdate -- 单据日期
            ,billnumber -- 
            ,billtype -- 单据类型
            ,bothorient -- 
            ,cashtype -- 现金分类
            ,code -- 科目编码
            ,combineform -- 合并报表科目
            ,currency -- 
            ,dataoriginflag -- 数据来源
            ,dr -- 删除标志
            ,enablestate -- 使用状态
            ,incurflag -- 
            ,inneracc -- 
            ,innercode -- 内部码
            ,innerinfo -- 
            ,name -- 名称
            ,name2 -- 名称2
            ,name3 -- 名称3
            ,name4 -- 名称4
            ,name5 -- 名称5
            ,name6 -- 名称6
            ,nparallelaccounts -- 平行记账例外科目
            ,outflag -- 表外科目
            ,parallelaccounts -- 平行记账标志
            ,pid -- 上级科目
            ,pk_accchart -- 创建科目表
            ,pk_account -- 主键
            ,pk_acctype -- 科目类型
            ,pk_originalaccount -- 原始科目主键
            ,price -- 单价
            ,quantity -- 
            ,remcode -- 助记码
            ,sumprint_level -- 
            ,ts -- 时间戳
            ,unit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acclev -- 科目级次
    ,o.accproperty -- 科目属性
    ,o.balancetype -- 
    ,o.balanflag -- 
    ,o.balanorient -- 科目方向
    ,o.bankacc -- 
    ,o.billdate -- 单据日期
    ,o.billnumber -- 
    ,o.billtype -- 单据类型
    ,o.bothorient -- 
    ,o.cashtype -- 现金分类
    ,o.code -- 科目编码
    ,o.combineform -- 合并报表科目
    ,o.currency -- 
    ,o.dataoriginflag -- 数据来源
    ,o.dr -- 删除标志
    ,o.enablestate -- 使用状态
    ,o.incurflag -- 
    ,o.inneracc -- 
    ,o.innercode -- 内部码
    ,o.innerinfo -- 
    ,o.name -- 名称
    ,o.name2 -- 名称2
    ,o.name3 -- 名称3
    ,o.name4 -- 名称4
    ,o.name5 -- 名称5
    ,o.name6 -- 名称6
    ,o.nparallelaccounts -- 平行记账例外科目
    ,o.outflag -- 表外科目
    ,o.parallelaccounts -- 平行记账标志
    ,o.pid -- 上级科目
    ,o.pk_accchart -- 创建科目表
    ,o.pk_account -- 主键
    ,o.pk_acctype -- 科目类型
    ,o.pk_originalaccount -- 原始科目主键
    ,o.price -- 单价
    ,o.quantity -- 
    ,o.remcode -- 助记码
    ,o.sumprint_level -- 
    ,o.ts -- 时间戳
    ,o.unit -- 
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
from ${iol_schema}.iers_bd_account_bk o
    left join ${iol_schema}.iers_bd_account_op n
        on
            o.pk_account = n.pk_account
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_bd_account_cl d
        on
            o.pk_account = d.pk_account
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_bd_account;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_bd_account') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_bd_account drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_bd_account add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_bd_account exchange partition p_${batch_date} with table ${iol_schema}.iers_bd_account_cl;
alter table ${iol_schema}.iers_bd_account exchange partition p_20991231 with table ${iol_schema}.iers_bd_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_bd_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_account_op purge;
drop table ${iol_schema}.iers_bd_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_bd_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_bd_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
