/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a56tsmcustinfo
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
create table ${iol_schema}.mpcs_a56tsmcustinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a56tsmcustinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a56tsmcustinfo_op purge;
drop table ${iol_schema}.mpcs_a56tsmcustinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a56tsmcustinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a56tsmcustinfo where 0=1;

create table ${iol_schema}.mpcs_a56tsmcustinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a56tsmcustinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a56tsmcustinfo_cl(
            seid -- 安全载体标识
            ,appid -- 
            ,appversion -- 
            ,processid -- 申请单号
            ,acctno -- 账号
            ,pin -- 密码
            ,acctstate -- TSM账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）
            ,accttype -- 账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）
            ,custno -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号
            ,acctname -- 姓名
            ,mobile -- 手机号
            ,mobilestate -- 11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-MOCAM注册通知
            ,bindacctno -- 开卡时上送的验证卡号
            ,relacctno -- TSM电子现金账户关联转出账户卡号
            ,relacctnotype -- TSM电子现金账户关联转出账户卡号类型
            ,relacctnoold -- TSM电子现金账户关联转出账户卡号（更换前卡号，没有更换过则为空）
            ,relacctnomdl -- 更换关联转出账号通知（0-已通知，1-待通知银联TSM，为空表示未更换卡号）
            ,sharedtype -- 是否共享账户（0-否， 1-是）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个
            ,chnlid -- 渠道码
            ,opendate -- 开卡日期
            ,expirydata -- 账户有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a56tsmcustinfo_op(
            seid -- 安全载体标识
            ,appid -- 
            ,appversion -- 
            ,processid -- 申请单号
            ,acctno -- 账号
            ,pin -- 密码
            ,acctstate -- TSM账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）
            ,accttype -- 账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）
            ,custno -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号
            ,acctname -- 姓名
            ,mobile -- 手机号
            ,mobilestate -- 11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-MOCAM注册通知
            ,bindacctno -- 开卡时上送的验证卡号
            ,relacctno -- TSM电子现金账户关联转出账户卡号
            ,relacctnotype -- TSM电子现金账户关联转出账户卡号类型
            ,relacctnoold -- TSM电子现金账户关联转出账户卡号（更换前卡号，没有更换过则为空）
            ,relacctnomdl -- 更换关联转出账号通知（0-已通知，1-待通知银联TSM，为空表示未更换卡号）
            ,sharedtype -- 是否共享账户（0-否， 1-是）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个
            ,chnlid -- 渠道码
            ,opendate -- 开卡日期
            ,expirydata -- 账户有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seid, o.seid) as seid -- 安全载体标识
    ,nvl(n.appid, o.appid) as appid -- 
    ,nvl(n.appversion, o.appversion) as appversion -- 
    ,nvl(n.processid, o.processid) as processid -- 申请单号
    ,nvl(n.acctno, o.acctno) as acctno -- 账号
    ,nvl(n.pin, o.pin) as pin -- 密码
    ,nvl(n.acctstate, o.acctstate) as acctstate -- TSM账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）
    ,nvl(n.accttype, o.accttype) as accttype -- 账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）
    ,nvl(n.custno, o.custno) as custno -- 客户号
    ,nvl(n.idtype, o.idtype) as idtype -- 证件类型
    ,nvl(n.idno, o.idno) as idno -- 证件号
    ,nvl(n.acctname, o.acctname) as acctname -- 姓名
    ,nvl(n.mobile, o.mobile) as mobile -- 手机号
    ,nvl(n.mobilestate, o.mobilestate) as mobilestate -- 11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-MOCAM注册通知
    ,nvl(n.bindacctno, o.bindacctno) as bindacctno -- 开卡时上送的验证卡号
    ,nvl(n.relacctno, o.relacctno) as relacctno -- TSM电子现金账户关联转出账户卡号
    ,nvl(n.relacctnotype, o.relacctnotype) as relacctnotype -- TSM电子现金账户关联转出账户卡号类型
    ,nvl(n.relacctnoold, o.relacctnoold) as relacctnoold -- TSM电子现金账户关联转出账户卡号（更换前卡号，没有更换过则为空）
    ,nvl(n.relacctnomdl, o.relacctnomdl) as relacctnomdl -- 更换关联转出账号通知（0-已通知，1-待通知银联TSM，为空表示未更换卡号）
    ,nvl(n.sharedtype, o.sharedtype) as sharedtype -- 是否共享账户（0-否， 1-是）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个
    ,nvl(n.chnlid, o.chnlid) as chnlid -- 渠道码
    ,nvl(n.opendate, o.opendate) as opendate -- 开卡日期
    ,nvl(n.expirydata, o.expirydata) as expirydata -- 账户有效期
    ,case when
            n.processid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.processid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.processid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a56tsmcustinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a56tsmcustinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.processid = n.processid
where (
        o.processid is null
    )
    or (
        n.processid is null
    )
    or (
        o.seid <> n.seid
        or o.appid <> n.appid
        or o.appversion <> n.appversion
        or o.acctno <> n.acctno
        or o.pin <> n.pin
        or o.acctstate <> n.acctstate
        or o.accttype <> n.accttype
        or o.custno <> n.custno
        or o.idtype <> n.idtype
        or o.idno <> n.idno
        or o.acctname <> n.acctname
        or o.mobile <> n.mobile
        or o.mobilestate <> n.mobilestate
        or o.bindacctno <> n.bindacctno
        or o.relacctno <> n.relacctno
        or o.relacctnotype <> n.relacctnotype
        or o.relacctnoold <> n.relacctnoold
        or o.relacctnomdl <> n.relacctnomdl
        or o.sharedtype <> n.sharedtype
        or o.chnlid <> n.chnlid
        or o.opendate <> n.opendate
        or o.expirydata <> n.expirydata
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a56tsmcustinfo_cl(
            seid -- 安全载体标识
            ,appid -- 
            ,appversion -- 
            ,processid -- 申请单号
            ,acctno -- 账号
            ,pin -- 密码
            ,acctstate -- TSM账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）
            ,accttype -- 账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）
            ,custno -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号
            ,acctname -- 姓名
            ,mobile -- 手机号
            ,mobilestate -- 11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-MOCAM注册通知
            ,bindacctno -- 开卡时上送的验证卡号
            ,relacctno -- TSM电子现金账户关联转出账户卡号
            ,relacctnotype -- TSM电子现金账户关联转出账户卡号类型
            ,relacctnoold -- TSM电子现金账户关联转出账户卡号（更换前卡号，没有更换过则为空）
            ,relacctnomdl -- 更换关联转出账号通知（0-已通知，1-待通知银联TSM，为空表示未更换卡号）
            ,sharedtype -- 是否共享账户（0-否， 1-是）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个
            ,chnlid -- 渠道码
            ,opendate -- 开卡日期
            ,expirydata -- 账户有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a56tsmcustinfo_op(
            seid -- 安全载体标识
            ,appid -- 
            ,appversion -- 
            ,processid -- 申请单号
            ,acctno -- 账号
            ,pin -- 密码
            ,acctstate -- TSM账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）
            ,accttype -- 账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）
            ,custno -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号
            ,acctname -- 姓名
            ,mobile -- 手机号
            ,mobilestate -- 11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-MOCAM注册通知
            ,bindacctno -- 开卡时上送的验证卡号
            ,relacctno -- TSM电子现金账户关联转出账户卡号
            ,relacctnotype -- TSM电子现金账户关联转出账户卡号类型
            ,relacctnoold -- TSM电子现金账户关联转出账户卡号（更换前卡号，没有更换过则为空）
            ,relacctnomdl -- 更换关联转出账号通知（0-已通知，1-待通知银联TSM，为空表示未更换卡号）
            ,sharedtype -- 是否共享账户（0-否， 1-是）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个
            ,chnlid -- 渠道码
            ,opendate -- 开卡日期
            ,expirydata -- 账户有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seid -- 安全载体标识
    ,o.appid -- 
    ,o.appversion -- 
    ,o.processid -- 申请单号
    ,o.acctno -- 账号
    ,o.pin -- 密码
    ,o.acctstate -- TSM账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）
    ,o.accttype -- 账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）
    ,o.custno -- 客户号
    ,o.idtype -- 证件类型
    ,o.idno -- 证件号
    ,o.acctname -- 姓名
    ,o.mobile -- 手机号
    ,o.mobilestate -- 11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-MOCAM注册通知
    ,o.bindacctno -- 开卡时上送的验证卡号
    ,o.relacctno -- TSM电子现金账户关联转出账户卡号
    ,o.relacctnotype -- TSM电子现金账户关联转出账户卡号类型
    ,o.relacctnoold -- TSM电子现金账户关联转出账户卡号（更换前卡号，没有更换过则为空）
    ,o.relacctnomdl -- 更换关联转出账号通知（0-已通知，1-待通知银联TSM，为空表示未更换卡号）
    ,o.sharedtype -- 是否共享账户（0-否， 1-是）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个
    ,o.chnlid -- 渠道码
    ,o.opendate -- 开卡日期
    ,o.expirydata -- 账户有效期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a56tsmcustinfo_bk o
    left join ${iol_schema}.mpcs_a56tsmcustinfo_op n
        on
            o.processid = n.processid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a56tsmcustinfo_cl d
        on
            o.processid = d.processid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a56tsmcustinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a56tsmcustinfo exchange partition p_19000101 with table ${iol_schema}.mpcs_a56tsmcustinfo_cl;
alter table ${iol_schema}.mpcs_a56tsmcustinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a56tsmcustinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a56tsmcustinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a56tsmcustinfo_op purge;
drop table ${iol_schema}.mpcs_a56tsmcustinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a56tsmcustinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a56tsmcustinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
