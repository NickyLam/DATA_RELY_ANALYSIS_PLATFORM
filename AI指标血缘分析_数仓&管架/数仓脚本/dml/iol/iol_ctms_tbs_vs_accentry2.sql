/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_accentry2
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
create table ${iol_schema}.ctms_tbs_vs_accentry2_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_accentry2;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_accentry2_op purge;
drop table ${iol_schema}.ctms_tbs_vs_accentry2_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_accentry2_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_accentry2 where 0=1;

create table ${iol_schema}.ctms_tbs_vs_accentry2_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_accentry2 where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_accentry2_cl(
            accentry2_id -- 会计分录2ID
            ,aspclient_id -- 所属部门ID
            ,keepfolder_id -- 账户ID
            ,acccode -- 分录代码
            ,settledate -- 支付日期
            ,inouttype -- 表内/表外
            ,debitcredit -- 借方/贷方
            ,accountingcode -- 会计科目代码
            ,amount -- 面额
            ,status -- 状态
            ,lastmodified -- 最后修改时间
            ,send_time -- 发送时间
            ,batchcode -- 代码批处理
            ,cptycode -- 交易对手代码
            ,accountingdesc -- 会计科目描述
            ,bundlecode -- 代码绑定
            ,note -- 备注
            ,accentry2_id_rev -- 冲回分录用来记录被冲分录的ID
            ,rev_flag -- 冲回分录标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_accentry2_op(
            accentry2_id -- 会计分录2ID
            ,aspclient_id -- 所属部门ID
            ,keepfolder_id -- 账户ID
            ,acccode -- 分录代码
            ,settledate -- 支付日期
            ,inouttype -- 表内/表外
            ,debitcredit -- 借方/贷方
            ,accountingcode -- 会计科目代码
            ,amount -- 面额
            ,status -- 状态
            ,lastmodified -- 最后修改时间
            ,send_time -- 发送时间
            ,batchcode -- 代码批处理
            ,cptycode -- 交易对手代码
            ,accountingdesc -- 会计科目描述
            ,bundlecode -- 代码绑定
            ,note -- 备注
            ,accentry2_id_rev -- 冲回分录用来记录被冲分录的ID
            ,rev_flag -- 冲回分录标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.accentry2_id, o.accentry2_id) as accentry2_id -- 会计分录2ID
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 所属部门ID
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.acccode, o.acccode) as acccode -- 分录代码
    ,nvl(n.settledate, o.settledate) as settledate -- 支付日期
    ,nvl(n.inouttype, o.inouttype) as inouttype -- 表内/表外
    ,nvl(n.debitcredit, o.debitcredit) as debitcredit -- 借方/贷方
    ,nvl(n.accountingcode, o.accountingcode) as accountingcode -- 会计科目代码
    ,nvl(n.amount, o.amount) as amount -- 面额
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.send_time, o.send_time) as send_time -- 发送时间
    ,nvl(n.batchcode, o.batchcode) as batchcode -- 代码批处理
    ,nvl(n.cptycode, o.cptycode) as cptycode -- 交易对手代码
    ,nvl(n.accountingdesc, o.accountingdesc) as accountingdesc -- 会计科目描述
    ,nvl(n.bundlecode, o.bundlecode) as bundlecode -- 代码绑定
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.accentry2_id_rev, o.accentry2_id_rev) as accentry2_id_rev -- 冲回分录用来记录被冲分录的ID
    ,nvl(n.rev_flag, o.rev_flag) as rev_flag -- 冲回分录标记
    ,case when
            n.accentry2_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.accentry2_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.accentry2_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_vs_accentry2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_accentry2 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.accentry2_id = n.accentry2_id
where (
        o.accentry2_id is null
    )
    or (
        n.accentry2_id is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.keepfolder_id <> n.keepfolder_id
        or o.acccode <> n.acccode
        or o.settledate <> n.settledate
        or o.inouttype <> n.inouttype
        or o.debitcredit <> n.debitcredit
        or o.accountingcode <> n.accountingcode
        or o.amount <> n.amount
        or o.status <> n.status
        or o.lastmodified <> n.lastmodified
        or o.send_time <> n.send_time
        or o.batchcode <> n.batchcode
        or o.cptycode <> n.cptycode
        or o.accountingdesc <> n.accountingdesc
        or o.bundlecode <> n.bundlecode
        or o.note <> n.note
        or o.accentry2_id_rev <> n.accentry2_id_rev
        or o.rev_flag <> n.rev_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_accentry2_cl(
            accentry2_id -- 会计分录2ID
            ,aspclient_id -- 所属部门ID
            ,keepfolder_id -- 账户ID
            ,acccode -- 分录代码
            ,settledate -- 支付日期
            ,inouttype -- 表内/表外
            ,debitcredit -- 借方/贷方
            ,accountingcode -- 会计科目代码
            ,amount -- 面额
            ,status -- 状态
            ,lastmodified -- 最后修改时间
            ,send_time -- 发送时间
            ,batchcode -- 代码批处理
            ,cptycode -- 交易对手代码
            ,accountingdesc -- 会计科目描述
            ,bundlecode -- 代码绑定
            ,note -- 备注
            ,accentry2_id_rev -- 冲回分录用来记录被冲分录的ID
            ,rev_flag -- 冲回分录标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_accentry2_op(
            accentry2_id -- 会计分录2ID
            ,aspclient_id -- 所属部门ID
            ,keepfolder_id -- 账户ID
            ,acccode -- 分录代码
            ,settledate -- 支付日期
            ,inouttype -- 表内/表外
            ,debitcredit -- 借方/贷方
            ,accountingcode -- 会计科目代码
            ,amount -- 面额
            ,status -- 状态
            ,lastmodified -- 最后修改时间
            ,send_time -- 发送时间
            ,batchcode -- 代码批处理
            ,cptycode -- 交易对手代码
            ,accountingdesc -- 会计科目描述
            ,bundlecode -- 代码绑定
            ,note -- 备注
            ,accentry2_id_rev -- 冲回分录用来记录被冲分录的ID
            ,rev_flag -- 冲回分录标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.accentry2_id -- 会计分录2ID
    ,o.aspclient_id -- 所属部门ID
    ,o.keepfolder_id -- 账户ID
    ,o.acccode -- 分录代码
    ,o.settledate -- 支付日期
    ,o.inouttype -- 表内/表外
    ,o.debitcredit -- 借方/贷方
    ,o.accountingcode -- 会计科目代码
    ,o.amount -- 面额
    ,o.status -- 状态
    ,o.lastmodified -- 最后修改时间
    ,o.send_time -- 发送时间
    ,o.batchcode -- 代码批处理
    ,o.cptycode -- 交易对手代码
    ,o.accountingdesc -- 会计科目描述
    ,o.bundlecode -- 代码绑定
    ,o.note -- 备注
    ,o.accentry2_id_rev -- 冲回分录用来记录被冲分录的ID
    ,o.rev_flag -- 冲回分录标记
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_accentry2_bk o
    left join ${iol_schema}.ctms_tbs_vs_accentry2_op n
        on
            o.accentry2_id = n.accentry2_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_accentry2_cl d
        on
            o.accentry2_id = d.accentry2_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_vs_accentry2;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_accentry2 exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_accentry2_cl;
alter table ${iol_schema}.ctms_tbs_vs_accentry2 exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_accentry2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_accentry2 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_accentry2_op purge;
drop table ${iol_schema}.ctms_tbs_vs_accentry2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_accentry2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_accentry2',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
