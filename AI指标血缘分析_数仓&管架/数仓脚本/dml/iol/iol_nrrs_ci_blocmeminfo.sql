/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_ci_blocmeminfo
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
create table ${iol_schema}.nrrs_ci_blocmeminfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_ci_blocmeminfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_ci_blocmeminfo_op purge;
drop table ${iol_schema}.nrrs_ci_blocmeminfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_ci_blocmeminfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_ci_blocmeminfo where 0=1;

create table ${iol_schema}.nrrs_ci_blocmeminfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_ci_blocmeminfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_ci_blocmeminfo_cl(
            bloccustid -- 第三主营业务
            ,custid -- 集团客户状态:1-有效 0-无效
            ,memcustid -- 部门
            ,memregioncode -- 客户所有制类型
            ,memcusttype -- 第一主营业务占比
            ,subbloccustid -- 组织机构代码
            ,custlevel -- 客户类型
            ,upcustid -- 证件号码
            ,upregioncode -- 第一主营业务
            ,inputdate -- 登记人
            ,outdate -- 证件类型
            ,inputorg -- 所属国家
            ,state -- 1-有效 0-无效
            ,havelower -- 第二主营业务
            ,ishead -- 是否母公司
            ,inputusername -- 登记人名称
            ,inputorgname -- 登记机构名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_ci_blocmeminfo_op(
            bloccustid -- 第三主营业务
            ,custid -- 集团客户状态:1-有效 0-无效
            ,memcustid -- 部门
            ,memregioncode -- 客户所有制类型
            ,memcusttype -- 第一主营业务占比
            ,subbloccustid -- 组织机构代码
            ,custlevel -- 客户类型
            ,upcustid -- 证件号码
            ,upregioncode -- 第一主营业务
            ,inputdate -- 登记人
            ,outdate -- 证件类型
            ,inputorg -- 所属国家
            ,state -- 1-有效 0-无效
            ,havelower -- 第二主营业务
            ,ishead -- 是否母公司
            ,inputusername -- 登记人名称
            ,inputorgname -- 登记机构名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bloccustid, o.bloccustid) as bloccustid -- 第三主营业务
    ,nvl(n.custid, o.custid) as custid -- 集团客户状态:1-有效 0-无效
    ,nvl(n.memcustid, o.memcustid) as memcustid -- 部门
    ,nvl(n.memregioncode, o.memregioncode) as memregioncode -- 客户所有制类型
    ,nvl(n.memcusttype, o.memcusttype) as memcusttype -- 第一主营业务占比
    ,nvl(n.subbloccustid, o.subbloccustid) as subbloccustid -- 组织机构代码
    ,nvl(n.custlevel, o.custlevel) as custlevel -- 客户类型
    ,nvl(n.upcustid, o.upcustid) as upcustid -- 证件号码
    ,nvl(n.upregioncode, o.upregioncode) as upregioncode -- 第一主营业务
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记人
    ,nvl(n.outdate, o.outdate) as outdate -- 证件类型
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 所属国家
    ,nvl(n.state, o.state) as state -- 1-有效 0-无效
    ,nvl(n.havelower, o.havelower) as havelower -- 第二主营业务
    ,nvl(n.ishead, o.ishead) as ishead -- 是否母公司
    ,nvl(n.inputusername, o.inputusername) as inputusername -- 登记人名称
    ,nvl(n.inputorgname, o.inputorgname) as inputorgname -- 登记机构名称
    ,case when
            n.bloccustid is null
            and n.memcustid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bloccustid is null
            and n.memcustid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bloccustid is null
            and n.memcustid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_ci_blocmeminfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nrrs_ci_blocmeminfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bloccustid = n.bloccustid
            and o.memcustid = n.memcustid
where (
        o.bloccustid is null
        and o.memcustid is null
    )
    or (
        n.bloccustid is null
        and n.memcustid is null
    )
    or (
        o.custid <> n.custid
        or o.memregioncode <> n.memregioncode
        or o.memcusttype <> n.memcusttype
        or o.subbloccustid <> n.subbloccustid
        or o.custlevel <> n.custlevel
        or o.upcustid <> n.upcustid
        or o.upregioncode <> n.upregioncode
        or o.inputdate <> n.inputdate
        or o.outdate <> n.outdate
        or o.inputorg <> n.inputorg
        or o.state <> n.state
        or o.havelower <> n.havelower
        or o.ishead <> n.ishead
        or o.inputusername <> n.inputusername
        or o.inputorgname <> n.inputorgname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_ci_blocmeminfo_cl(
            bloccustid -- 第三主营业务
            ,custid -- 集团客户状态:1-有效 0-无效
            ,memcustid -- 部门
            ,memregioncode -- 客户所有制类型
            ,memcusttype -- 第一主营业务占比
            ,subbloccustid -- 组织机构代码
            ,custlevel -- 客户类型
            ,upcustid -- 证件号码
            ,upregioncode -- 第一主营业务
            ,inputdate -- 登记人
            ,outdate -- 证件类型
            ,inputorg -- 所属国家
            ,state -- 1-有效 0-无效
            ,havelower -- 第二主营业务
            ,ishead -- 是否母公司
            ,inputusername -- 登记人名称
            ,inputorgname -- 登记机构名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_ci_blocmeminfo_op(
            bloccustid -- 第三主营业务
            ,custid -- 集团客户状态:1-有效 0-无效
            ,memcustid -- 部门
            ,memregioncode -- 客户所有制类型
            ,memcusttype -- 第一主营业务占比
            ,subbloccustid -- 组织机构代码
            ,custlevel -- 客户类型
            ,upcustid -- 证件号码
            ,upregioncode -- 第一主营业务
            ,inputdate -- 登记人
            ,outdate -- 证件类型
            ,inputorg -- 所属国家
            ,state -- 1-有效 0-无效
            ,havelower -- 第二主营业务
            ,ishead -- 是否母公司
            ,inputusername -- 登记人名称
            ,inputorgname -- 登记机构名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bloccustid -- 第三主营业务
    ,o.custid -- 集团客户状态:1-有效 0-无效
    ,o.memcustid -- 部门
    ,o.memregioncode -- 客户所有制类型
    ,o.memcusttype -- 第一主营业务占比
    ,o.subbloccustid -- 组织机构代码
    ,o.custlevel -- 客户类型
    ,o.upcustid -- 证件号码
    ,o.upregioncode -- 第一主营业务
    ,o.inputdate -- 登记人
    ,o.outdate -- 证件类型
    ,o.inputorg -- 所属国家
    ,o.state -- 1-有效 0-无效
    ,o.havelower -- 第二主营业务
    ,o.ishead -- 是否母公司
    ,o.inputusername -- 登记人名称
    ,o.inputorgname -- 登记机构名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nrrs_ci_blocmeminfo_bk o
    left join ${iol_schema}.nrrs_ci_blocmeminfo_op n
        on
            o.bloccustid = n.bloccustid
            and o.memcustid = n.memcustid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nrrs_ci_blocmeminfo_cl d
        on
            o.bloccustid = d.bloccustid
            and o.memcustid = d.memcustid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nrrs_ci_blocmeminfo;

-- 4.2 exchange partition
alter table ${iol_schema}.nrrs_ci_blocmeminfo exchange partition p_19000101 with table ${iol_schema}.nrrs_ci_blocmeminfo_cl;
alter table ${iol_schema}.nrrs_ci_blocmeminfo exchange partition p_20991231 with table ${iol_schema}.nrrs_ci_blocmeminfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_ci_blocmeminfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_ci_blocmeminfo_op purge;
drop table ${iol_schema}.nrrs_ci_blocmeminfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_ci_blocmeminfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_ci_blocmeminfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
