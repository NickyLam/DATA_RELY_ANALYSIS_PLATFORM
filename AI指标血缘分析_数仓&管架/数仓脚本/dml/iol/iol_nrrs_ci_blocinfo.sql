/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_ci_blocinfo
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
create table ${iol_schema}.nrrs_ci_blocinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_ci_blocinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_ci_blocinfo_op purge;
drop table ${iol_schema}.nrrs_ci_blocinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_ci_blocinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_ci_blocinfo where 0=1;

create table ${iol_schema}.nrrs_ci_blocinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_ci_blocinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_ci_blocinfo_cl(
            bloccustid -- 集团客户号
            ,blocname -- 总部客户名称
            ,custid -- 建立日期
            ,homename -- 创建人
            ,leveltype -- 客户经理
            ,scalecode -- 集团层级标识
            ,areacode -- 集团客户名称
            ,createman -- 所属机构
            ,createdate -- 所在地区
            ,custmanage -- 集团牵头行
            ,custorg -- 规模
            ,leadbank -- 集团本部编号
            ,state -- 1-有效 0-无效
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,custtype -- 客户类型
            ,comcorptype -- 客户所有制类型
            ,country -- 所属国家
            ,deptcode -- 部门
            ,inputuser -- 登记人
            ,firstbusi -- 第一主营业务
            ,secondbusi -- 第二主营业务
            ,thirdbusi -- 第三主营业务
            ,certificatecode -- 组织机构代码
            ,firstbusirate -- 第一主营业务占比
            ,secondbusirate -- 第二主营业务占比
            ,thirdbusirate -- 第三主营业务占比
            ,mfcustomerid -- 核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_ci_blocinfo_op(
            bloccustid -- 集团客户号
            ,blocname -- 总部客户名称
            ,custid -- 建立日期
            ,homename -- 创建人
            ,leveltype -- 客户经理
            ,scalecode -- 集团层级标识
            ,areacode -- 集团客户名称
            ,createman -- 所属机构
            ,createdate -- 所在地区
            ,custmanage -- 集团牵头行
            ,custorg -- 规模
            ,leadbank -- 集团本部编号
            ,state -- 1-有效 0-无效
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,custtype -- 客户类型
            ,comcorptype -- 客户所有制类型
            ,country -- 所属国家
            ,deptcode -- 部门
            ,inputuser -- 登记人
            ,firstbusi -- 第一主营业务
            ,secondbusi -- 第二主营业务
            ,thirdbusi -- 第三主营业务
            ,certificatecode -- 组织机构代码
            ,firstbusirate -- 第一主营业务占比
            ,secondbusirate -- 第二主营业务占比
            ,thirdbusirate -- 第三主营业务占比
            ,mfcustomerid -- 核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bloccustid, o.bloccustid) as bloccustid -- 集团客户号
    ,nvl(n.blocname, o.blocname) as blocname -- 总部客户名称
    ,nvl(n.custid, o.custid) as custid -- 建立日期
    ,nvl(n.homename, o.homename) as homename -- 创建人
    ,nvl(n.leveltype, o.leveltype) as leveltype -- 客户经理
    ,nvl(n.scalecode, o.scalecode) as scalecode -- 集团层级标识
    ,nvl(n.areacode, o.areacode) as areacode -- 集团客户名称
    ,nvl(n.createman, o.createman) as createman -- 所属机构
    ,nvl(n.createdate, o.createdate) as createdate -- 所在地区
    ,nvl(n.custmanage, o.custmanage) as custmanage -- 集团牵头行
    ,nvl(n.custorg, o.custorg) as custorg -- 规模
    ,nvl(n.leadbank, o.leadbank) as leadbank -- 集团本部编号
    ,nvl(n.state, o.state) as state -- 1-有效 0-无效
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.custtype, o.custtype) as custtype -- 客户类型
    ,nvl(n.comcorptype, o.comcorptype) as comcorptype -- 客户所有制类型
    ,nvl(n.country, o.country) as country -- 所属国家
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 部门
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人
    ,nvl(n.firstbusi, o.firstbusi) as firstbusi -- 第一主营业务
    ,nvl(n.secondbusi, o.secondbusi) as secondbusi -- 第二主营业务
    ,nvl(n.thirdbusi, o.thirdbusi) as thirdbusi -- 第三主营业务
    ,nvl(n.certificatecode, o.certificatecode) as certificatecode -- 组织机构代码
    ,nvl(n.firstbusirate, o.firstbusirate) as firstbusirate -- 第一主营业务占比
    ,nvl(n.secondbusirate, o.secondbusirate) as secondbusirate -- 第二主营业务占比
    ,nvl(n.thirdbusirate, o.thirdbusirate) as thirdbusirate -- 第三主营业务占比
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 核心客户号
    ,case when
            n.bloccustid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bloccustid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bloccustid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_ci_blocinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nrrs_ci_blocinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bloccustid = n.bloccustid
where (
        o.bloccustid is null
    )
    or (
        n.bloccustid is null
    )
    or (
        o.blocname <> n.blocname
        or o.custid <> n.custid
        or o.homename <> n.homename
        or o.leveltype <> n.leveltype
        or o.scalecode <> n.scalecode
        or o.areacode <> n.areacode
        or o.createman <> n.createman
        or o.createdate <> n.createdate
        or o.custmanage <> n.custmanage
        or o.custorg <> n.custorg
        or o.leadbank <> n.leadbank
        or o.state <> n.state
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.custtype <> n.custtype
        or o.comcorptype <> n.comcorptype
        or o.country <> n.country
        or o.deptcode <> n.deptcode
        or o.inputuser <> n.inputuser
        or o.firstbusi <> n.firstbusi
        or o.secondbusi <> n.secondbusi
        or o.thirdbusi <> n.thirdbusi
        or o.certificatecode <> n.certificatecode
        or o.firstbusirate <> n.firstbusirate
        or o.secondbusirate <> n.secondbusirate
        or o.thirdbusirate <> n.thirdbusirate
        or o.mfcustomerid <> n.mfcustomerid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_ci_blocinfo_cl(
            bloccustid -- 集团客户号
            ,blocname -- 总部客户名称
            ,custid -- 建立日期
            ,homename -- 创建人
            ,leveltype -- 客户经理
            ,scalecode -- 集团层级标识
            ,areacode -- 集团客户名称
            ,createman -- 所属机构
            ,createdate -- 所在地区
            ,custmanage -- 集团牵头行
            ,custorg -- 规模
            ,leadbank -- 集团本部编号
            ,state -- 1-有效 0-无效
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,custtype -- 客户类型
            ,comcorptype -- 客户所有制类型
            ,country -- 所属国家
            ,deptcode -- 部门
            ,inputuser -- 登记人
            ,firstbusi -- 第一主营业务
            ,secondbusi -- 第二主营业务
            ,thirdbusi -- 第三主营业务
            ,certificatecode -- 组织机构代码
            ,firstbusirate -- 第一主营业务占比
            ,secondbusirate -- 第二主营业务占比
            ,thirdbusirate -- 第三主营业务占比
            ,mfcustomerid -- 核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_ci_blocinfo_op(
            bloccustid -- 集团客户号
            ,blocname -- 总部客户名称
            ,custid -- 建立日期
            ,homename -- 创建人
            ,leveltype -- 客户经理
            ,scalecode -- 集团层级标识
            ,areacode -- 集团客户名称
            ,createman -- 所属机构
            ,createdate -- 所在地区
            ,custmanage -- 集团牵头行
            ,custorg -- 规模
            ,leadbank -- 集团本部编号
            ,state -- 1-有效 0-无效
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,custtype -- 客户类型
            ,comcorptype -- 客户所有制类型
            ,country -- 所属国家
            ,deptcode -- 部门
            ,inputuser -- 登记人
            ,firstbusi -- 第一主营业务
            ,secondbusi -- 第二主营业务
            ,thirdbusi -- 第三主营业务
            ,certificatecode -- 组织机构代码
            ,firstbusirate -- 第一主营业务占比
            ,secondbusirate -- 第二主营业务占比
            ,thirdbusirate -- 第三主营业务占比
            ,mfcustomerid -- 核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bloccustid -- 集团客户号
    ,o.blocname -- 总部客户名称
    ,o.custid -- 建立日期
    ,o.homename -- 创建人
    ,o.leveltype -- 客户经理
    ,o.scalecode -- 集团层级标识
    ,o.areacode -- 集团客户名称
    ,o.createman -- 所属机构
    ,o.createdate -- 所在地区
    ,o.custmanage -- 集团牵头行
    ,o.custorg -- 规模
    ,o.leadbank -- 集团本部编号
    ,o.state -- 1-有效 0-无效
    ,o.certtype -- 证件类型
    ,o.certid -- 证件号码
    ,o.custtype -- 客户类型
    ,o.comcorptype -- 客户所有制类型
    ,o.country -- 所属国家
    ,o.deptcode -- 部门
    ,o.inputuser -- 登记人
    ,o.firstbusi -- 第一主营业务
    ,o.secondbusi -- 第二主营业务
    ,o.thirdbusi -- 第三主营业务
    ,o.certificatecode -- 组织机构代码
    ,o.firstbusirate -- 第一主营业务占比
    ,o.secondbusirate -- 第二主营业务占比
    ,o.thirdbusirate -- 第三主营业务占比
    ,o.mfcustomerid -- 核心客户号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nrrs_ci_blocinfo_bk o
    left join ${iol_schema}.nrrs_ci_blocinfo_op n
        on
            o.bloccustid = n.bloccustid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nrrs_ci_blocinfo_cl d
        on
            o.bloccustid = d.bloccustid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nrrs_ci_blocinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.nrrs_ci_blocinfo exchange partition p_19000101 with table ${iol_schema}.nrrs_ci_blocinfo_cl;
alter table ${iol_schema}.nrrs_ci_blocinfo exchange partition p_20991231 with table ${iol_schema}.nrrs_ci_blocinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_ci_blocinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_ci_blocinfo_op purge;
drop table ${iol_schema}.nrrs_ci_blocinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_ci_blocinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_ci_blocinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
