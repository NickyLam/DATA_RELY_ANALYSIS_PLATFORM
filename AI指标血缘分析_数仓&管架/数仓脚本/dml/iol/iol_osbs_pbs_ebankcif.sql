/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_pbs_ebankcif
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
create table ${iol_schema}.osbs_pbs_ebankcif_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_pbs_ebankcif;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_ebankcif_op purge;
drop table ${iol_schema}.osbs_pbs_ebankcif_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_ebankcif_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_ebankcif where 0=1;

create table ${iol_schema}.osbs_pbs_ebankcif_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_ebankcif where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_ebankcif_cl(
            pec_signchannel -- 签约渠道
            ,pec_ecifno -- 全行统一客户号
            ,pec_userno -- 用户顺序号
            ,pec_loginid -- 用户登陆名
            ,pec_state -- 状态
            ,pec_opendate -- 开户日期
            ,pec_closedate -- 销户日期
            ,pec_cstlabel -- 用户标签
            ,pec_cstlogo -- 头像
            ,pec_protect -- 敏感标志
            ,pec_pbpausestate -- 暂停状态
            ,pec_pbpausedate -- 暂停结束日期
            ,pec_pbpauseenddate -- 暂停日期
            ,pec_pauseremark -- 暂停附言
            ,pec_mbpausestate -- 手机银行暂停状态
            ,pec_mbpausedate -- 银行暂停开始时间
            ,pec_mobilepauseenddate -- 手机银行暂停结束时间
            ,pec_mbpauseremark -- 手机银行暂停使用备注
            ,pec_storageflag -- 是否为网银存量用户标识位
            ,pec_agreedate -- 存量用户同意接受手机银行协议日期
            ,pec_eaccsignchannel -- 电子账户签约渠道
            ,pec_securitytype -- 安全认证方式
            ,pec_channel -- 所属渠道
            ,pec_message_open -- 第一位登录短信开关,第二位隐私提示开关
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_ebankcif_op(
            pec_signchannel -- 签约渠道
            ,pec_ecifno -- 全行统一客户号
            ,pec_userno -- 用户顺序号
            ,pec_loginid -- 用户登陆名
            ,pec_state -- 状态
            ,pec_opendate -- 开户日期
            ,pec_closedate -- 销户日期
            ,pec_cstlabel -- 用户标签
            ,pec_cstlogo -- 头像
            ,pec_protect -- 敏感标志
            ,pec_pbpausestate -- 暂停状态
            ,pec_pbpausedate -- 暂停结束日期
            ,pec_pbpauseenddate -- 暂停日期
            ,pec_pauseremark -- 暂停附言
            ,pec_mbpausestate -- 手机银行暂停状态
            ,pec_mbpausedate -- 银行暂停开始时间
            ,pec_mobilepauseenddate -- 手机银行暂停结束时间
            ,pec_mbpauseremark -- 手机银行暂停使用备注
            ,pec_storageflag -- 是否为网银存量用户标识位
            ,pec_agreedate -- 存量用户同意接受手机银行协议日期
            ,pec_eaccsignchannel -- 电子账户签约渠道
            ,pec_securitytype -- 安全认证方式
            ,pec_channel -- 所属渠道
            ,pec_message_open -- 第一位登录短信开关,第二位隐私提示开关
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pec_signchannel, o.pec_signchannel) as pec_signchannel -- 签约渠道
    ,nvl(n.pec_ecifno, o.pec_ecifno) as pec_ecifno -- 全行统一客户号
    ,nvl(n.pec_userno, o.pec_userno) as pec_userno -- 用户顺序号
    ,nvl(n.pec_loginid, o.pec_loginid) as pec_loginid -- 用户登陆名
    ,nvl(n.pec_state, o.pec_state) as pec_state -- 状态
    ,nvl(n.pec_opendate, o.pec_opendate) as pec_opendate -- 开户日期
    ,nvl(n.pec_closedate, o.pec_closedate) as pec_closedate -- 销户日期
    ,nvl(n.pec_cstlabel, o.pec_cstlabel) as pec_cstlabel -- 用户标签
    ,nvl(n.pec_cstlogo, o.pec_cstlogo) as pec_cstlogo -- 头像
    ,nvl(n.pec_protect, o.pec_protect) as pec_protect -- 敏感标志
    ,nvl(n.pec_pbpausestate, o.pec_pbpausestate) as pec_pbpausestate -- 暂停状态
    ,nvl(n.pec_pbpausedate, o.pec_pbpausedate) as pec_pbpausedate -- 暂停结束日期
    ,nvl(n.pec_pbpauseenddate, o.pec_pbpauseenddate) as pec_pbpauseenddate -- 暂停日期
    ,nvl(n.pec_pauseremark, o.pec_pauseremark) as pec_pauseremark -- 暂停附言
    ,nvl(n.pec_mbpausestate, o.pec_mbpausestate) as pec_mbpausestate -- 手机银行暂停状态
    ,nvl(n.pec_mbpausedate, o.pec_mbpausedate) as pec_mbpausedate -- 银行暂停开始时间
    ,nvl(n.pec_mobilepauseenddate, o.pec_mobilepauseenddate) as pec_mobilepauseenddate -- 手机银行暂停结束时间
    ,nvl(n.pec_mbpauseremark, o.pec_mbpauseremark) as pec_mbpauseremark -- 手机银行暂停使用备注
    ,nvl(n.pec_storageflag, o.pec_storageflag) as pec_storageflag -- 是否为网银存量用户标识位
    ,nvl(n.pec_agreedate, o.pec_agreedate) as pec_agreedate -- 存量用户同意接受手机银行协议日期
    ,nvl(n.pec_eaccsignchannel, o.pec_eaccsignchannel) as pec_eaccsignchannel -- 电子账户签约渠道
    ,nvl(n.pec_securitytype, o.pec_securitytype) as pec_securitytype -- 安全认证方式
    ,nvl(n.pec_channel, o.pec_channel) as pec_channel -- 所属渠道
    ,nvl(n.pec_message_open, o.pec_message_open) as pec_message_open -- 第一位登录短信开关,第二位隐私提示开关
    ,case when
            n.pec_ecifno is null
            and n.pec_channel is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pec_ecifno is null
            and n.pec_channel is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pec_ecifno is null
            and n.pec_channel is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_pbs_ebankcif_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_pbs_ebankcif where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pec_ecifno = n.pec_ecifno
            and o.pec_channel = n.pec_channel
where (
        o.pec_ecifno is null
        and o.pec_channel is null
    )
    or (
        n.pec_ecifno is null
        and n.pec_channel is null
    )
    or (
        o.pec_signchannel <> n.pec_signchannel
        or o.pec_userno <> n.pec_userno
        or o.pec_loginid <> n.pec_loginid
        or o.pec_state <> n.pec_state
        or o.pec_opendate <> n.pec_opendate
        or o.pec_closedate <> n.pec_closedate
        or o.pec_cstlabel <> n.pec_cstlabel
        or o.pec_cstlogo <> n.pec_cstlogo
        or o.pec_protect <> n.pec_protect
        or o.pec_pbpausestate <> n.pec_pbpausestate
        or o.pec_pbpausedate <> n.pec_pbpausedate
        or o.pec_pbpauseenddate <> n.pec_pbpauseenddate
        or o.pec_pauseremark <> n.pec_pauseremark
        or o.pec_mbpausestate <> n.pec_mbpausestate
        or o.pec_mbpausedate <> n.pec_mbpausedate
        or o.pec_mobilepauseenddate <> n.pec_mobilepauseenddate
        or o.pec_mbpauseremark <> n.pec_mbpauseremark
        or o.pec_storageflag <> n.pec_storageflag
        or o.pec_agreedate <> n.pec_agreedate
        or o.pec_eaccsignchannel <> n.pec_eaccsignchannel
        or o.pec_securitytype <> n.pec_securitytype
        or o.pec_message_open <> n.pec_message_open
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_ebankcif_cl(
            pec_signchannel -- 签约渠道
            ,pec_ecifno -- 全行统一客户号
            ,pec_userno -- 用户顺序号
            ,pec_loginid -- 用户登陆名
            ,pec_state -- 状态
            ,pec_opendate -- 开户日期
            ,pec_closedate -- 销户日期
            ,pec_cstlabel -- 用户标签
            ,pec_cstlogo -- 头像
            ,pec_protect -- 敏感标志
            ,pec_pbpausestate -- 暂停状态
            ,pec_pbpausedate -- 暂停结束日期
            ,pec_pbpauseenddate -- 暂停日期
            ,pec_pauseremark -- 暂停附言
            ,pec_mbpausestate -- 手机银行暂停状态
            ,pec_mbpausedate -- 银行暂停开始时间
            ,pec_mobilepauseenddate -- 手机银行暂停结束时间
            ,pec_mbpauseremark -- 手机银行暂停使用备注
            ,pec_storageflag -- 是否为网银存量用户标识位
            ,pec_agreedate -- 存量用户同意接受手机银行协议日期
            ,pec_eaccsignchannel -- 电子账户签约渠道
            ,pec_securitytype -- 安全认证方式
            ,pec_channel -- 所属渠道
            ,pec_message_open -- 第一位登录短信开关,第二位隐私提示开关
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_ebankcif_op(
            pec_signchannel -- 签约渠道
            ,pec_ecifno -- 全行统一客户号
            ,pec_userno -- 用户顺序号
            ,pec_loginid -- 用户登陆名
            ,pec_state -- 状态
            ,pec_opendate -- 开户日期
            ,pec_closedate -- 销户日期
            ,pec_cstlabel -- 用户标签
            ,pec_cstlogo -- 头像
            ,pec_protect -- 敏感标志
            ,pec_pbpausestate -- 暂停状态
            ,pec_pbpausedate -- 暂停结束日期
            ,pec_pbpauseenddate -- 暂停日期
            ,pec_pauseremark -- 暂停附言
            ,pec_mbpausestate -- 手机银行暂停状态
            ,pec_mbpausedate -- 银行暂停开始时间
            ,pec_mobilepauseenddate -- 手机银行暂停结束时间
            ,pec_mbpauseremark -- 手机银行暂停使用备注
            ,pec_storageflag -- 是否为网银存量用户标识位
            ,pec_agreedate -- 存量用户同意接受手机银行协议日期
            ,pec_eaccsignchannel -- 电子账户签约渠道
            ,pec_securitytype -- 安全认证方式
            ,pec_channel -- 所属渠道
            ,pec_message_open -- 第一位登录短信开关,第二位隐私提示开关
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pec_signchannel -- 签约渠道
    ,o.pec_ecifno -- 全行统一客户号
    ,o.pec_userno -- 用户顺序号
    ,o.pec_loginid -- 用户登陆名
    ,o.pec_state -- 状态
    ,o.pec_opendate -- 开户日期
    ,o.pec_closedate -- 销户日期
    ,o.pec_cstlabel -- 用户标签
    ,o.pec_cstlogo -- 头像
    ,o.pec_protect -- 敏感标志
    ,o.pec_pbpausestate -- 暂停状态
    ,o.pec_pbpausedate -- 暂停结束日期
    ,o.pec_pbpauseenddate -- 暂停日期
    ,o.pec_pauseremark -- 暂停附言
    ,o.pec_mbpausestate -- 手机银行暂停状态
    ,o.pec_mbpausedate -- 银行暂停开始时间
    ,o.pec_mobilepauseenddate -- 手机银行暂停结束时间
    ,o.pec_mbpauseremark -- 手机银行暂停使用备注
    ,o.pec_storageflag -- 是否为网银存量用户标识位
    ,o.pec_agreedate -- 存量用户同意接受手机银行协议日期
    ,o.pec_eaccsignchannel -- 电子账户签约渠道
    ,o.pec_securitytype -- 安全认证方式
    ,o.pec_channel -- 所属渠道
    ,o.pec_message_open -- 第一位登录短信开关,第二位隐私提示开关
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_pbs_ebankcif_bk o
    left join ${iol_schema}.osbs_pbs_ebankcif_op n
        on
            o.pec_ecifno = n.pec_ecifno
            and o.pec_channel = n.pec_channel
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_pbs_ebankcif_cl d
        on
            o.pec_ecifno = d.pec_ecifno
            and o.pec_channel = d.pec_channel
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_pbs_ebankcif;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_pbs_ebankcif exchange partition p_19000101 with table ${iol_schema}.osbs_pbs_ebankcif_cl;
alter table ${iol_schema}.osbs_pbs_ebankcif exchange partition p_20991231 with table ${iol_schema}.osbs_pbs_ebankcif_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_pbs_ebankcif to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_ebankcif_op purge;
drop table ${iol_schema}.osbs_pbs_ebankcif_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_pbs_ebankcif_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_pbs_ebankcif',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
