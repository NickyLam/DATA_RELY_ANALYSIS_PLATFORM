/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_ehoutai_whitelist
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
create table ${iol_schema}.tbps_cpr_ehoutai_whitelist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_ehoutai_whitelist;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_ehoutai_whitelist_op purge;
drop table ${iol_schema}.tbps_cpr_ehoutai_whitelist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_ehoutai_whitelist_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_ehoutai_whitelist where 0=1;

create table ${iol_schema}.tbps_cpr_ehoutai_whitelist_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_ehoutai_whitelist where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_ehoutai_whitelist_cl(
            ewl_ecifno -- ecif客户号
            ,ewl_custnamne -- 客户名称
            ,ewl_brchno -- 机构号
            ,ewl_brchname -- 机构名称
            ,ewl_createtime -- 生成时间
            ,ewl_userseq -- 操作员网银序号
            ,ewl_certno -- 操作员证件号码
            ,ewl_certtype -- 操作员证件类型
            ,ewl_movestate -- 是否已经做数据迁移(0:已经迁移(查询白名单请带这个状态);1:新增客户待迁移;2:迁移失败的客户)
            ,ewl_returncode -- 迁移返回码(空表示未执行迁移脚本,90表示迁移成功,其他错误码表示迁移失败)
            ,ewl_returnmsg -- 迁移返回信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_ehoutai_whitelist_op(
            ewl_ecifno -- ecif客户号
            ,ewl_custnamne -- 客户名称
            ,ewl_brchno -- 机构号
            ,ewl_brchname -- 机构名称
            ,ewl_createtime -- 生成时间
            ,ewl_userseq -- 操作员网银序号
            ,ewl_certno -- 操作员证件号码
            ,ewl_certtype -- 操作员证件类型
            ,ewl_movestate -- 是否已经做数据迁移(0:已经迁移(查询白名单请带这个状态);1:新增客户待迁移;2:迁移失败的客户)
            ,ewl_returncode -- 迁移返回码(空表示未执行迁移脚本,90表示迁移成功,其他错误码表示迁移失败)
            ,ewl_returnmsg -- 迁移返回信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ewl_ecifno, o.ewl_ecifno) as ewl_ecifno -- ecif客户号
    ,nvl(n.ewl_custnamne, o.ewl_custnamne) as ewl_custnamne -- 客户名称
    ,nvl(n.ewl_brchno, o.ewl_brchno) as ewl_brchno -- 机构号
    ,nvl(n.ewl_brchname, o.ewl_brchname) as ewl_brchname -- 机构名称
    ,nvl(n.ewl_createtime, o.ewl_createtime) as ewl_createtime -- 生成时间
    ,nvl(n.ewl_userseq, o.ewl_userseq) as ewl_userseq -- 操作员网银序号
    ,nvl(n.ewl_certno, o.ewl_certno) as ewl_certno -- 操作员证件号码
    ,nvl(n.ewl_certtype, o.ewl_certtype) as ewl_certtype -- 操作员证件类型
    ,nvl(n.ewl_movestate, o.ewl_movestate) as ewl_movestate -- 是否已经做数据迁移(0:已经迁移(查询白名单请带这个状态);1:新增客户待迁移;2:迁移失败的客户)
    ,nvl(n.ewl_returncode, o.ewl_returncode) as ewl_returncode -- 迁移返回码(空表示未执行迁移脚本,90表示迁移成功,其他错误码表示迁移失败)
    ,nvl(n.ewl_returnmsg, o.ewl_returnmsg) as ewl_returnmsg -- 迁移返回信息
    ,case when
            n.ewl_ecifno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ewl_ecifno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ewl_ecifno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_ehoutai_whitelist_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_ehoutai_whitelist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ewl_ecifno = n.ewl_ecifno
where (
        o.ewl_ecifno is null
    )
    or (
        n.ewl_ecifno is null
    )
    or (
        o.ewl_custnamne <> n.ewl_custnamne
        or o.ewl_brchno <> n.ewl_brchno
        or o.ewl_brchname <> n.ewl_brchname
        or o.ewl_createtime <> n.ewl_createtime
        or o.ewl_userseq <> n.ewl_userseq
        or o.ewl_certno <> n.ewl_certno
        or o.ewl_certtype <> n.ewl_certtype
        or o.ewl_movestate <> n.ewl_movestate
        or o.ewl_returncode <> n.ewl_returncode
        or o.ewl_returnmsg <> n.ewl_returnmsg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_ehoutai_whitelist_cl(
            ewl_ecifno -- ecif客户号
            ,ewl_custnamne -- 客户名称
            ,ewl_brchno -- 机构号
            ,ewl_brchname -- 机构名称
            ,ewl_createtime -- 生成时间
            ,ewl_userseq -- 操作员网银序号
            ,ewl_certno -- 操作员证件号码
            ,ewl_certtype -- 操作员证件类型
            ,ewl_movestate -- 是否已经做数据迁移(0:已经迁移(查询白名单请带这个状态);1:新增客户待迁移;2:迁移失败的客户)
            ,ewl_returncode -- 迁移返回码(空表示未执行迁移脚本,90表示迁移成功,其他错误码表示迁移失败)
            ,ewl_returnmsg -- 迁移返回信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_ehoutai_whitelist_op(
            ewl_ecifno -- ecif客户号
            ,ewl_custnamne -- 客户名称
            ,ewl_brchno -- 机构号
            ,ewl_brchname -- 机构名称
            ,ewl_createtime -- 生成时间
            ,ewl_userseq -- 操作员网银序号
            ,ewl_certno -- 操作员证件号码
            ,ewl_certtype -- 操作员证件类型
            ,ewl_movestate -- 是否已经做数据迁移(0:已经迁移(查询白名单请带这个状态);1:新增客户待迁移;2:迁移失败的客户)
            ,ewl_returncode -- 迁移返回码(空表示未执行迁移脚本,90表示迁移成功,其他错误码表示迁移失败)
            ,ewl_returnmsg -- 迁移返回信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ewl_ecifno -- ecif客户号
    ,o.ewl_custnamne -- 客户名称
    ,o.ewl_brchno -- 机构号
    ,o.ewl_brchname -- 机构名称
    ,o.ewl_createtime -- 生成时间
    ,o.ewl_userseq -- 操作员网银序号
    ,o.ewl_certno -- 操作员证件号码
    ,o.ewl_certtype -- 操作员证件类型
    ,o.ewl_movestate -- 是否已经做数据迁移(0:已经迁移(查询白名单请带这个状态);1:新增客户待迁移;2:迁移失败的客户)
    ,o.ewl_returncode -- 迁移返回码(空表示未执行迁移脚本,90表示迁移成功,其他错误码表示迁移失败)
    ,o.ewl_returnmsg -- 迁移返回信息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_ehoutai_whitelist_bk o
    left join ${iol_schema}.tbps_cpr_ehoutai_whitelist_op n
        on
            o.ewl_ecifno = n.ewl_ecifno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_ehoutai_whitelist_cl d
        on
            o.ewl_ecifno = d.ewl_ecifno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_ehoutai_whitelist;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_ehoutai_whitelist exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_ehoutai_whitelist_cl;
alter table ${iol_schema}.tbps_cpr_ehoutai_whitelist exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_ehoutai_whitelist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_ehoutai_whitelist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_ehoutai_whitelist_op purge;
drop table ${iol_schema}.tbps_cpr_ehoutai_whitelist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_ehoutai_whitelist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_ehoutai_whitelist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
