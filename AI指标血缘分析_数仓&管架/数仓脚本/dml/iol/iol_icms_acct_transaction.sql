/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_acct_transaction
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
create table ${iol_schema}.icms_acct_transaction_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_acct_transaction
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_acct_transaction_op purge;
drop table ${iol_schema}.icms_acct_transaction_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_acct_transaction_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_acct_transaction where 0=1;

create table ${iol_schema}.icms_acct_transaction_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_acct_transaction where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_acct_transaction_cl(
            serialno -- 交易流水号
            ,parenttransserialno -- 关联交易流水号
            ,transcode -- 交易代码
            ,relativeobjecttype -- 关联对象类型
            ,relativeobjectno -- 关联对象编号
            ,documenttype -- 单据类型
            ,documentno -- 单据流水号
            ,channelid -- 交易渠道
            ,occurdate -- 交易操作日期
            ,occurtime -- 交易时间
            ,transdate -- 交易日期
            ,transstatus -- 交易状态(CodeNo:TransStatus)
            ,inputorgid -- 录入机构
            ,inputuserid -- 录入用户
            ,inputtime -- 录入日期
            ,remark -- 备注
            ,log -- 其他日志
            ,fallbacktransserialno -- 回退交易流水
            ,tellerserialno -- 柜员流水号
            ,transsum -- 交易金额
            ,cnsmrsrlno -- 消费方流水号(调用还款交易接口时的消费方流水号)
            ,accountingserialno -- 唯一核心记账流水号
            ,transtype -- 转让类型(福费廷转让使用)
            ,transoccurtype -- 交易发生类型
            ,completeflag -- 数据录入完整性标识
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,graceinterestflag -- 是否宽限利息
            ,graceprincipalflag -- 是否宽限本金
            ,repayreason -- 提前还款说明
            ,repaysource -- 提前还款资金来源
            ,whethertorestructuretheloan -- 是否重组贷款
            ,updatedate -- 更新时间
            ,repayreasontype -- 提前还款原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_acct_transaction_op(
            serialno -- 交易流水号
            ,parenttransserialno -- 关联交易流水号
            ,transcode -- 交易代码
            ,relativeobjecttype -- 关联对象类型
            ,relativeobjectno -- 关联对象编号
            ,documenttype -- 单据类型
            ,documentno -- 单据流水号
            ,channelid -- 交易渠道
            ,occurdate -- 交易操作日期
            ,occurtime -- 交易时间
            ,transdate -- 交易日期
            ,transstatus -- 交易状态(CodeNo:TransStatus)
            ,inputorgid -- 录入机构
            ,inputuserid -- 录入用户
            ,inputtime -- 录入日期
            ,remark -- 备注
            ,log -- 其他日志
            ,fallbacktransserialno -- 回退交易流水
            ,tellerserialno -- 柜员流水号
            ,transsum -- 交易金额
            ,cnsmrsrlno -- 消费方流水号(调用还款交易接口时的消费方流水号)
            ,accountingserialno -- 唯一核心记账流水号
            ,transtype -- 转让类型(福费廷转让使用)
            ,transoccurtype -- 交易发生类型
            ,completeflag -- 数据录入完整性标识
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,graceinterestflag -- 是否宽限利息
            ,graceprincipalflag -- 是否宽限本金
            ,repayreason -- 提前还款说明
            ,repaysource -- 提前还款资金来源
            ,whethertorestructuretheloan -- 是否重组贷款
            ,updatedate -- 更新时间
            ,repayreasontype -- 提前还款原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 交易流水号
    ,nvl(n.parenttransserialno, o.parenttransserialno) as parenttransserialno -- 关联交易流水号
    ,nvl(n.transcode, o.transcode) as transcode -- 交易代码
    ,nvl(n.relativeobjecttype, o.relativeobjecttype) as relativeobjecttype -- 关联对象类型
    ,nvl(n.relativeobjectno, o.relativeobjectno) as relativeobjectno -- 关联对象编号
    ,nvl(n.documenttype, o.documenttype) as documenttype -- 单据类型
    ,nvl(n.documentno, o.documentno) as documentno -- 单据流水号
    ,nvl(n.channelid, o.channelid) as channelid -- 交易渠道
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 交易操作日期
    ,nvl(n.occurtime, o.occurtime) as occurtime -- 交易时间
    ,nvl(n.transdate, o.transdate) as transdate -- 交易日期
    ,nvl(n.transstatus, o.transstatus) as transstatus -- 交易状态(CodeNo:TransStatus)
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 录入机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 录入用户
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 录入日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.log, o.log) as log -- 其他日志
    ,nvl(n.fallbacktransserialno, o.fallbacktransserialno) as fallbacktransserialno -- 回退交易流水
    ,nvl(n.tellerserialno, o.tellerserialno) as tellerserialno -- 柜员流水号
    ,nvl(n.transsum, o.transsum) as transsum -- 交易金额
    ,nvl(n.cnsmrsrlno, o.cnsmrsrlno) as cnsmrsrlno -- 消费方流水号(调用还款交易接口时的消费方流水号)
    ,nvl(n.accountingserialno, o.accountingserialno) as accountingserialno -- 唯一核心记账流水号
    ,nvl(n.transtype, o.transtype) as transtype -- 转让类型(福费廷转让使用)
    ,nvl(n.transoccurtype, o.transoccurtype) as transoccurtype -- 交易发生类型
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 数据录入完整性标识
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.graceinterestflag, o.graceinterestflag) as graceinterestflag -- 是否宽限利息
    ,nvl(n.graceprincipalflag, o.graceprincipalflag) as graceprincipalflag -- 是否宽限本金
    ,nvl(n.repayreason, o.repayreason) as repayreason -- 提前还款说明
    ,nvl(n.repaysource, o.repaysource) as repaysource -- 提前还款资金来源
    ,nvl(n.whethertorestructuretheloan, o.whethertorestructuretheloan) as whethertorestructuretheloan -- 是否重组贷款
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.repayreasontype, o.repayreasontype) as repayreasontype -- 提前还款原因
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_acct_transaction_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_acct_transaction where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.parenttransserialno <> n.parenttransserialno
        or o.transcode <> n.transcode
        or o.relativeobjecttype <> n.relativeobjecttype
        or o.relativeobjectno <> n.relativeobjectno
        or o.documenttype <> n.documenttype
        or o.documentno <> n.documentno
        or o.channelid <> n.channelid
        or o.occurdate <> n.occurdate
        or o.occurtime <> n.occurtime
        or o.transdate <> n.transdate
        or o.transstatus <> n.transstatus
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.inputtime <> n.inputtime
        or o.remark <> n.remark
        or o.log <> n.log
        or o.fallbacktransserialno <> n.fallbacktransserialno
        or o.tellerserialno <> n.tellerserialno
        or o.transsum <> n.transsum
        or o.cnsmrsrlno <> n.cnsmrsrlno
        or o.accountingserialno <> n.accountingserialno
        or o.transtype <> n.transtype
        or o.transoccurtype <> n.transoccurtype
        or o.completeflag <> n.completeflag
        or o.migtflag <> n.migtflag
        or o.graceinterestflag <> n.graceinterestflag
        or o.graceprincipalflag <> n.graceprincipalflag
        or o.repayreason <> n.repayreason
        or o.repaysource <> n.repaysource
        or o.whethertorestructuretheloan <> n.whethertorestructuretheloan
        or o.updatedate <> n.updatedate
        or o.repayreasontype <> n.repayreasontype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_acct_transaction_cl(
            serialno -- 交易流水号
            ,parenttransserialno -- 关联交易流水号
            ,transcode -- 交易代码
            ,relativeobjecttype -- 关联对象类型
            ,relativeobjectno -- 关联对象编号
            ,documenttype -- 单据类型
            ,documentno -- 单据流水号
            ,channelid -- 交易渠道
            ,occurdate -- 交易操作日期
            ,occurtime -- 交易时间
            ,transdate -- 交易日期
            ,transstatus -- 交易状态(CodeNo:TransStatus)
            ,inputorgid -- 录入机构
            ,inputuserid -- 录入用户
            ,inputtime -- 录入日期
            ,remark -- 备注
            ,log -- 其他日志
            ,fallbacktransserialno -- 回退交易流水
            ,tellerserialno -- 柜员流水号
            ,transsum -- 交易金额
            ,cnsmrsrlno -- 消费方流水号(调用还款交易接口时的消费方流水号)
            ,accountingserialno -- 唯一核心记账流水号
            ,transtype -- 转让类型(福费廷转让使用)
            ,transoccurtype -- 交易发生类型
            ,completeflag -- 数据录入完整性标识
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,graceinterestflag -- 是否宽限利息
            ,graceprincipalflag -- 是否宽限本金
            ,repayreason -- 提前还款说明
            ,repaysource -- 提前还款资金来源
            ,whethertorestructuretheloan -- 是否重组贷款
            ,updatedate -- 更新时间
            ,repayreasontype -- 提前还款原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_acct_transaction_op(
            serialno -- 交易流水号
            ,parenttransserialno -- 关联交易流水号
            ,transcode -- 交易代码
            ,relativeobjecttype -- 关联对象类型
            ,relativeobjectno -- 关联对象编号
            ,documenttype -- 单据类型
            ,documentno -- 单据流水号
            ,channelid -- 交易渠道
            ,occurdate -- 交易操作日期
            ,occurtime -- 交易时间
            ,transdate -- 交易日期
            ,transstatus -- 交易状态(CodeNo:TransStatus)
            ,inputorgid -- 录入机构
            ,inputuserid -- 录入用户
            ,inputtime -- 录入日期
            ,remark -- 备注
            ,log -- 其他日志
            ,fallbacktransserialno -- 回退交易流水
            ,tellerserialno -- 柜员流水号
            ,transsum -- 交易金额
            ,cnsmrsrlno -- 消费方流水号(调用还款交易接口时的消费方流水号)
            ,accountingserialno -- 唯一核心记账流水号
            ,transtype -- 转让类型(福费廷转让使用)
            ,transoccurtype -- 交易发生类型
            ,completeflag -- 数据录入完整性标识
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,graceinterestflag -- 是否宽限利息
            ,graceprincipalflag -- 是否宽限本金
            ,repayreason -- 提前还款说明
            ,repaysource -- 提前还款资金来源
            ,whethertorestructuretheloan -- 是否重组贷款
            ,updatedate -- 更新时间
            ,repayreasontype -- 提前还款原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 交易流水号
    ,o.parenttransserialno -- 关联交易流水号
    ,o.transcode -- 交易代码
    ,o.relativeobjecttype -- 关联对象类型
    ,o.relativeobjectno -- 关联对象编号
    ,o.documenttype -- 单据类型
    ,o.documentno -- 单据流水号
    ,o.channelid -- 交易渠道
    ,o.occurdate -- 交易操作日期
    ,o.occurtime -- 交易时间
    ,o.transdate -- 交易日期
    ,o.transstatus -- 交易状态(CodeNo:TransStatus)
    ,o.inputorgid -- 录入机构
    ,o.inputuserid -- 录入用户
    ,o.inputtime -- 录入日期
    ,o.remark -- 备注
    ,o.log -- 其他日志
    ,o.fallbacktransserialno -- 回退交易流水
    ,o.tellerserialno -- 柜员流水号
    ,o.transsum -- 交易金额
    ,o.cnsmrsrlno -- 消费方流水号(调用还款交易接口时的消费方流水号)
    ,o.accountingserialno -- 唯一核心记账流水号
    ,o.transtype -- 转让类型(福费廷转让使用)
    ,o.transoccurtype -- 交易发生类型
    ,o.completeflag -- 数据录入完整性标识
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.graceinterestflag -- 是否宽限利息
    ,o.graceprincipalflag -- 是否宽限本金
    ,o.repayreason -- 提前还款说明
    ,o.repaysource -- 提前还款资金来源
    ,o.whethertorestructuretheloan -- 是否重组贷款
    ,o.updatedate -- 更新时间
    ,o.repayreasontype -- 提前还款原因
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
from ${iol_schema}.icms_acct_transaction_bk o
    left join ${iol_schema}.icms_acct_transaction_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_acct_transaction_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_acct_transaction;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_acct_transaction') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_acct_transaction drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_acct_transaction add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_acct_transaction exchange partition p_${batch_date} with table ${iol_schema}.icms_acct_transaction_cl;
alter table ${iol_schema}.icms_acct_transaction exchange partition p_20991231 with table ${iol_schema}.icms_acct_transaction_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_acct_transaction to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_acct_transaction_op purge;
drop table ${iol_schema}.icms_acct_transaction_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_acct_transaction_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_acct_transaction',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
