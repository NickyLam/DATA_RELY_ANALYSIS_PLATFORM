/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a49teforginfo
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
create table ${iol_schema}.mpcs_a49teforginfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a49teforginfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a49teforginfo_op purge;
drop table ${iol_schema}.mpcs_a49teforginfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49teforginfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49teforginfo where 0=1;

create table ${iol_schema}.mpcs_a49teforginfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49teforginfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a49teforginfo_cl(
            deptcd -- 机构代码
            ,deptnm -- 机构名称
            ,zoneid -- 地区代码
            ,trantype -- 业务种类
            ,txntype -- 交易类型细分
            ,currencycd -- 交易货币
            ,opnbrn -- 开户行行号
            ,payeeacc -- 收款人账号
            ,payeename -- 收款人名称
            ,phone -- 联系电话
            ,linkman -- 联系人
            ,effdate -- 生效日期
            ,invdate -- 停用日期
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a49teforginfo_op(
            deptcd -- 机构代码
            ,deptnm -- 机构名称
            ,zoneid -- 地区代码
            ,trantype -- 业务种类
            ,txntype -- 交易类型细分
            ,currencycd -- 交易货币
            ,opnbrn -- 开户行行号
            ,payeeacc -- 收款人账号
            ,payeename -- 收款人名称
            ,phone -- 联系电话
            ,linkman -- 联系人
            ,effdate -- 生效日期
            ,invdate -- 停用日期
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deptcd, o.deptcd) as deptcd -- 机构代码
    ,nvl(n.deptnm, o.deptnm) as deptnm -- 机构名称
    ,nvl(n.zoneid, o.zoneid) as zoneid -- 地区代码
    ,nvl(n.trantype, o.trantype) as trantype -- 业务种类
    ,nvl(n.txntype, o.txntype) as txntype -- 交易类型细分
    ,nvl(n.currencycd, o.currencycd) as currencycd -- 交易货币
    ,nvl(n.opnbrn, o.opnbrn) as opnbrn -- 开户行行号
    ,nvl(n.payeeacc, o.payeeacc) as payeeacc -- 收款人账号
    ,nvl(n.payeename, o.payeename) as payeename -- 收款人名称
    ,nvl(n.phone, o.phone) as phone -- 联系电话
    ,nvl(n.linkman, o.linkman) as linkman -- 联系人
    ,nvl(n.effdate, o.effdate) as effdate -- 生效日期
    ,nvl(n.invdate, o.invdate) as invdate -- 停用日期
    ,nvl(n.status, o.status) as status -- 状态
    ,case when
            n.deptcd is null
            and n.zoneid is null
            and n.trantype is null
            and n.txntype is null
            and n.opnbrn is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deptcd is null
            and n.zoneid is null
            and n.trantype is null
            and n.txntype is null
            and n.opnbrn is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deptcd is null
            and n.zoneid is null
            and n.trantype is null
            and n.txntype is null
            and n.opnbrn is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a49teforginfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a49teforginfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deptcd = n.deptcd
            and o.zoneid = n.zoneid
            and o.trantype = n.trantype
            and o.txntype = n.txntype
            and o.opnbrn = n.opnbrn
where (
        o.deptcd is null
        and o.zoneid is null
        and o.trantype is null
        and o.txntype is null
        and o.opnbrn is null
    )
    or (
        n.deptcd is null
        and n.zoneid is null
        and n.trantype is null
        and n.txntype is null
        and n.opnbrn is null
    )
    or (
        o.deptnm <> n.deptnm
        or o.currencycd <> n.currencycd
        or o.payeeacc <> n.payeeacc
        or o.payeename <> n.payeename
        or o.phone <> n.phone
        or o.linkman <> n.linkman
        or o.effdate <> n.effdate
        or o.invdate <> n.invdate
        or o.status <> n.status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a49teforginfo_cl(
            deptcd -- 机构代码
            ,deptnm -- 机构名称
            ,zoneid -- 地区代码
            ,trantype -- 业务种类
            ,txntype -- 交易类型细分
            ,currencycd -- 交易货币
            ,opnbrn -- 开户行行号
            ,payeeacc -- 收款人账号
            ,payeename -- 收款人名称
            ,phone -- 联系电话
            ,linkman -- 联系人
            ,effdate -- 生效日期
            ,invdate -- 停用日期
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a49teforginfo_op(
            deptcd -- 机构代码
            ,deptnm -- 机构名称
            ,zoneid -- 地区代码
            ,trantype -- 业务种类
            ,txntype -- 交易类型细分
            ,currencycd -- 交易货币
            ,opnbrn -- 开户行行号
            ,payeeacc -- 收款人账号
            ,payeename -- 收款人名称
            ,phone -- 联系电话
            ,linkman -- 联系人
            ,effdate -- 生效日期
            ,invdate -- 停用日期
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deptcd -- 机构代码
    ,o.deptnm -- 机构名称
    ,o.zoneid -- 地区代码
    ,o.trantype -- 业务种类
    ,o.txntype -- 交易类型细分
    ,o.currencycd -- 交易货币
    ,o.opnbrn -- 开户行行号
    ,o.payeeacc -- 收款人账号
    ,o.payeename -- 收款人名称
    ,o.phone -- 联系电话
    ,o.linkman -- 联系人
    ,o.effdate -- 生效日期
    ,o.invdate -- 停用日期
    ,o.status -- 状态
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a49teforginfo_bk o
    left join ${iol_schema}.mpcs_a49teforginfo_op n
        on
            o.deptcd = n.deptcd
            and o.zoneid = n.zoneid
            and o.trantype = n.trantype
            and o.txntype = n.txntype
            and o.opnbrn = n.opnbrn
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a49teforginfo_cl d
        on
            o.deptcd = d.deptcd
            and o.zoneid = d.zoneid
            and o.trantype = d.trantype
            and o.txntype = d.txntype
            and o.opnbrn = d.opnbrn
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a49teforginfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a49teforginfo exchange partition p_19000101 with table ${iol_schema}.mpcs_a49teforginfo_cl;
alter table ${iol_schema}.mpcs_a49teforginfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a49teforginfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a49teforginfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a49teforginfo_op purge;
drop table ${iol_schema}.mpcs_a49teforginfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a49teforginfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a49teforginfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
