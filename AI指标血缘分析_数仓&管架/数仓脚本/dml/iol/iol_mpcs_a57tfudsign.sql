/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a57tfudsign
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
create table ${iol_schema}.mpcs_a57tfudsign_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a57tfudsign;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a57tfudsign_op purge;
drop table ${iol_schema}.mpcs_a57tfudsign_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a57tfudsign_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a57tfudsign where 0=1;

create table ${iol_schema}.mpcs_a57tfudsign_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a57tfudsign where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a57tfudsign_cl(
            sysid -- 渠道标识
            ,srcseqno -- 请求流水
            ,custname -- 客户名称
            ,idtype -- 证件类型
            ,idno -- 身份识别码
            ,idcd -- 
            ,custno -- 客户号
            ,acctno -- 结算账号
            ,reqtm -- 申请时间
            ,mobile -- 手机号
            ,tel -- 固定电话
            ,addr -- 地址
            ,zip -- 邮编
            ,email -- 邮箱
            ,memo -- 附加信息
            ,fudcustno -- 基金账号
            ,fudacctno -- 基金交易账号
            ,rspcd -- 响应码
            ,rspmsg -- 响应信息
            ,status -- 开户结果
            ,rsptm -- 响应时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a57tfudsign_op(
            sysid -- 渠道标识
            ,srcseqno -- 请求流水
            ,custname -- 客户名称
            ,idtype -- 证件类型
            ,idno -- 身份识别码
            ,idcd -- 
            ,custno -- 客户号
            ,acctno -- 结算账号
            ,reqtm -- 申请时间
            ,mobile -- 手机号
            ,tel -- 固定电话
            ,addr -- 地址
            ,zip -- 邮编
            ,email -- 邮箱
            ,memo -- 附加信息
            ,fudcustno -- 基金账号
            ,fudacctno -- 基金交易账号
            ,rspcd -- 响应码
            ,rspmsg -- 响应信息
            ,status -- 开户结果
            ,rsptm -- 响应时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sysid, o.sysid) as sysid -- 渠道标识
    ,nvl(n.srcseqno, o.srcseqno) as srcseqno -- 请求流水
    ,nvl(n.custname, o.custname) as custname -- 客户名称
    ,nvl(n.idtype, o.idtype) as idtype -- 证件类型
    ,nvl(n.idno, o.idno) as idno -- 身份识别码
    ,nvl(n.idcd, o.idcd) as idcd -- 
    ,nvl(n.custno, o.custno) as custno -- 客户号
    ,nvl(n.acctno, o.acctno) as acctno -- 结算账号
    ,nvl(n.reqtm, o.reqtm) as reqtm -- 申请时间
    ,nvl(n.mobile, o.mobile) as mobile -- 手机号
    ,nvl(n.tel, o.tel) as tel -- 固定电话
    ,nvl(n.addr, o.addr) as addr -- 地址
    ,nvl(n.zip, o.zip) as zip -- 邮编
    ,nvl(n.email, o.email) as email -- 邮箱
    ,nvl(n.memo, o.memo) as memo -- 附加信息
    ,nvl(n.fudcustno, o.fudcustno) as fudcustno -- 基金账号
    ,nvl(n.fudacctno, o.fudacctno) as fudacctno -- 基金交易账号
    ,nvl(n.rspcd, o.rspcd) as rspcd -- 响应码
    ,nvl(n.rspmsg, o.rspmsg) as rspmsg -- 响应信息
    ,nvl(n.status, o.status) as status -- 开户结果
    ,nvl(n.rsptm, o.rsptm) as rsptm -- 响应时间
    ,case when
            n.sysid is null
            and n.srcseqno is null
            and n.custno is null
            and n.acctno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sysid is null
            and n.srcseqno is null
            and n.custno is null
            and n.acctno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sysid is null
            and n.srcseqno is null
            and n.custno is null
            and n.acctno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a57tfudsign_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a57tfudsign where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sysid = n.sysid
            and o.srcseqno = n.srcseqno
            and o.custno = n.custno
            and o.acctno = n.acctno
where (
        o.sysid is null
        and o.srcseqno is null
        and o.custno is null
        and o.acctno is null
    )
    or (
        n.sysid is null
        and n.srcseqno is null
        and n.custno is null
        and n.acctno is null
    )
    or (
        o.custname <> n.custname
        or o.idtype <> n.idtype
        or o.idno <> n.idno
        or o.idcd <> n.idcd
        or o.reqtm <> n.reqtm
        or o.mobile <> n.mobile
        or o.tel <> n.tel
        or o.addr <> n.addr
        or o.zip <> n.zip
        or o.email <> n.email
        or o.memo <> n.memo
        or o.fudcustno <> n.fudcustno
        or o.fudacctno <> n.fudacctno
        or o.rspcd <> n.rspcd
        or o.rspmsg <> n.rspmsg
        or o.status <> n.status
        or o.rsptm <> n.rsptm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a57tfudsign_cl(
            sysid -- 渠道标识
            ,srcseqno -- 请求流水
            ,custname -- 客户名称
            ,idtype -- 证件类型
            ,idno -- 身份识别码
            ,idcd -- 
            ,custno -- 客户号
            ,acctno -- 结算账号
            ,reqtm -- 申请时间
            ,mobile -- 手机号
            ,tel -- 固定电话
            ,addr -- 地址
            ,zip -- 邮编
            ,email -- 邮箱
            ,memo -- 附加信息
            ,fudcustno -- 基金账号
            ,fudacctno -- 基金交易账号
            ,rspcd -- 响应码
            ,rspmsg -- 响应信息
            ,status -- 开户结果
            ,rsptm -- 响应时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a57tfudsign_op(
            sysid -- 渠道标识
            ,srcseqno -- 请求流水
            ,custname -- 客户名称
            ,idtype -- 证件类型
            ,idno -- 身份识别码
            ,idcd -- 
            ,custno -- 客户号
            ,acctno -- 结算账号
            ,reqtm -- 申请时间
            ,mobile -- 手机号
            ,tel -- 固定电话
            ,addr -- 地址
            ,zip -- 邮编
            ,email -- 邮箱
            ,memo -- 附加信息
            ,fudcustno -- 基金账号
            ,fudacctno -- 基金交易账号
            ,rspcd -- 响应码
            ,rspmsg -- 响应信息
            ,status -- 开户结果
            ,rsptm -- 响应时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sysid -- 渠道标识
    ,o.srcseqno -- 请求流水
    ,o.custname -- 客户名称
    ,o.idtype -- 证件类型
    ,o.idno -- 身份识别码
    ,o.idcd -- 
    ,o.custno -- 客户号
    ,o.acctno -- 结算账号
    ,o.reqtm -- 申请时间
    ,o.mobile -- 手机号
    ,o.tel -- 固定电话
    ,o.addr -- 地址
    ,o.zip -- 邮编
    ,o.email -- 邮箱
    ,o.memo -- 附加信息
    ,o.fudcustno -- 基金账号
    ,o.fudacctno -- 基金交易账号
    ,o.rspcd -- 响应码
    ,o.rspmsg -- 响应信息
    ,o.status -- 开户结果
    ,o.rsptm -- 响应时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a57tfudsign_bk o
    left join ${iol_schema}.mpcs_a57tfudsign_op n
        on
            o.sysid = n.sysid
            and o.srcseqno = n.srcseqno
            and o.custno = n.custno
            and o.acctno = n.acctno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a57tfudsign_cl d
        on
            o.sysid = d.sysid
            and o.srcseqno = d.srcseqno
            and o.custno = d.custno
            and o.acctno = d.acctno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a57tfudsign;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a57tfudsign exchange partition p_19000101 with table ${iol_schema}.mpcs_a57tfudsign_cl;
alter table ${iol_schema}.mpcs_a57tfudsign exchange partition p_20991231 with table ${iol_schema}.mpcs_a57tfudsign_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a57tfudsign to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a57tfudsign_op purge;
drop table ${iol_schema}.mpcs_a57tfudsign_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a57tfudsign_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a57tfudsign',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
