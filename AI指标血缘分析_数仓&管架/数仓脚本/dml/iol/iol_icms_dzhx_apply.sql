/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_dzhx_apply
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
create table ${iol_schema}.icms_dzhx_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_dzhx_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_dzhx_apply_op purge;
drop table ${iol_schema}.icms_dzhx_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_dzhx_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_dzhx_apply where 0=1;

create table ${iol_schema}.icms_dzhx_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_dzhx_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_dzhx_apply_cl(
            serialno -- 流水号
            ,hxtype -- 核销类别
            ,customerid -- 客户编号
            ,approvehxdate -- 审批核销日期
            ,approvehxmoney -- 审批核销本金
            ,hxdfmoney -- 核销垫付费用
            ,resum -- 复息
            ,customername -- 客户名称
            ,approvehxininterest -- 审批核销表内利息
            ,hxdate -- 核销日期
            ,attribute1 -- 诉讼等垫付费用
            ,inputorgid -- 登记机构
            ,approvehxoutinterest -- 审批核销表外利息
            ,balance -- 贷款余额
            ,commitflag -- 提交状态（0客户经理1保全分发岗2保全经理及以上）
            ,hxininterest -- 核销表内利息
            ,hxmoney -- 核销本金
            ,updatedate -- 更新时间
            ,ifsearch -- 是否保留对债务人的追索权
            ,interest -- 欠息
            ,inputuserid -- 登记人
            ,duebillserialno -- 借据编号
            ,currentuserid -- 分发岗
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,finebalance -- 罚息
            ,manager -- 客户经理（管护人）
            ,businesstype -- 业务品种
            ,approvehxinterest -- 审批核销利息
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,hxoutinterest -- 核销表外利息
            ,updateorgid -- 更新人机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_dzhx_apply_op(
            serialno -- 流水号
            ,hxtype -- 核销类别
            ,customerid -- 客户编号
            ,approvehxdate -- 审批核销日期
            ,approvehxmoney -- 审批核销本金
            ,hxdfmoney -- 核销垫付费用
            ,resum -- 复息
            ,customername -- 客户名称
            ,approvehxininterest -- 审批核销表内利息
            ,hxdate -- 核销日期
            ,attribute1 -- 诉讼等垫付费用
            ,inputorgid -- 登记机构
            ,approvehxoutinterest -- 审批核销表外利息
            ,balance -- 贷款余额
            ,commitflag -- 提交状态（0客户经理1保全分发岗2保全经理及以上）
            ,hxininterest -- 核销表内利息
            ,hxmoney -- 核销本金
            ,updatedate -- 更新时间
            ,ifsearch -- 是否保留对债务人的追索权
            ,interest -- 欠息
            ,inputuserid -- 登记人
            ,duebillserialno -- 借据编号
            ,currentuserid -- 分发岗
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,finebalance -- 罚息
            ,manager -- 客户经理（管护人）
            ,businesstype -- 业务品种
            ,approvehxinterest -- 审批核销利息
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,hxoutinterest -- 核销表外利息
            ,updateorgid -- 更新人机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.hxtype, o.hxtype) as hxtype -- 核销类别
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.approvehxdate, o.approvehxdate) as approvehxdate -- 审批核销日期
    ,nvl(n.approvehxmoney, o.approvehxmoney) as approvehxmoney -- 审批核销本金
    ,nvl(n.hxdfmoney, o.hxdfmoney) as hxdfmoney -- 核销垫付费用
    ,nvl(n.resum, o.resum) as resum -- 复息
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.approvehxininterest, o.approvehxininterest) as approvehxininterest -- 审批核销表内利息
    ,nvl(n.hxdate, o.hxdate) as hxdate -- 核销日期
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 诉讼等垫付费用
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.approvehxoutinterest, o.approvehxoutinterest) as approvehxoutinterest -- 审批核销表外利息
    ,nvl(n.balance, o.balance) as balance -- 贷款余额
    ,nvl(n.commitflag, o.commitflag) as commitflag -- 提交状态（0客户经理1保全分发岗2保全经理及以上）
    ,nvl(n.hxininterest, o.hxininterest) as hxininterest -- 核销表内利息
    ,nvl(n.hxmoney, o.hxmoney) as hxmoney -- 核销本金
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.ifsearch, o.ifsearch) as ifsearch -- 是否保留对债务人的追索权
    ,nvl(n.interest, o.interest) as interest -- 欠息
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.duebillserialno, o.duebillserialno) as duebillserialno -- 借据编号
    ,nvl(n.currentuserid, o.currentuserid) as currentuserid -- 分发岗
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.finebalance, o.finebalance) as finebalance -- 罚息
    ,nvl(n.manager, o.manager) as manager -- 客户经理（管护人）
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务品种
    ,nvl(n.approvehxinterest, o.approvehxinterest) as approvehxinterest -- 审批核销利息
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.hxoutinterest, o.hxoutinterest) as hxoutinterest -- 核销表外利息
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新人机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
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
from (select * from ${iol_schema}.icms_dzhx_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_dzhx_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.hxtype <> n.hxtype
        or o.customerid <> n.customerid
        or o.approvehxdate <> n.approvehxdate
        or o.approvehxmoney <> n.approvehxmoney
        or o.hxdfmoney <> n.hxdfmoney
        or o.resum <> n.resum
        or o.customername <> n.customername
        or o.approvehxininterest <> n.approvehxininterest
        or o.hxdate <> n.hxdate
        or o.attribute1 <> n.attribute1
        or o.inputorgid <> n.inputorgid
        or o.approvehxoutinterest <> n.approvehxoutinterest
        or o.balance <> n.balance
        or o.commitflag <> n.commitflag
        or o.hxininterest <> n.hxininterest
        or o.hxmoney <> n.hxmoney
        or o.updatedate <> n.updatedate
        or o.ifsearch <> n.ifsearch
        or o.interest <> n.interest
        or o.inputuserid <> n.inputuserid
        or o.duebillserialno <> n.duebillserialno
        or o.currentuserid <> n.currentuserid
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.finebalance <> n.finebalance
        or o.manager <> n.manager
        or o.businesstype <> n.businesstype
        or o.approvehxinterest <> n.approvehxinterest
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.hxoutinterest <> n.hxoutinterest
        or o.updateorgid <> n.updateorgid
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_dzhx_apply_cl(
            serialno -- 流水号
            ,hxtype -- 核销类别
            ,customerid -- 客户编号
            ,approvehxdate -- 审批核销日期
            ,approvehxmoney -- 审批核销本金
            ,hxdfmoney -- 核销垫付费用
            ,resum -- 复息
            ,customername -- 客户名称
            ,approvehxininterest -- 审批核销表内利息
            ,hxdate -- 核销日期
            ,attribute1 -- 诉讼等垫付费用
            ,inputorgid -- 登记机构
            ,approvehxoutinterest -- 审批核销表外利息
            ,balance -- 贷款余额
            ,commitflag -- 提交状态（0客户经理1保全分发岗2保全经理及以上）
            ,hxininterest -- 核销表内利息
            ,hxmoney -- 核销本金
            ,updatedate -- 更新时间
            ,ifsearch -- 是否保留对债务人的追索权
            ,interest -- 欠息
            ,inputuserid -- 登记人
            ,duebillserialno -- 借据编号
            ,currentuserid -- 分发岗
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,finebalance -- 罚息
            ,manager -- 客户经理（管护人）
            ,businesstype -- 业务品种
            ,approvehxinterest -- 审批核销利息
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,hxoutinterest -- 核销表外利息
            ,updateorgid -- 更新人机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_dzhx_apply_op(
            serialno -- 流水号
            ,hxtype -- 核销类别
            ,customerid -- 客户编号
            ,approvehxdate -- 审批核销日期
            ,approvehxmoney -- 审批核销本金
            ,hxdfmoney -- 核销垫付费用
            ,resum -- 复息
            ,customername -- 客户名称
            ,approvehxininterest -- 审批核销表内利息
            ,hxdate -- 核销日期
            ,attribute1 -- 诉讼等垫付费用
            ,inputorgid -- 登记机构
            ,approvehxoutinterest -- 审批核销表外利息
            ,balance -- 贷款余额
            ,commitflag -- 提交状态（0客户经理1保全分发岗2保全经理及以上）
            ,hxininterest -- 核销表内利息
            ,hxmoney -- 核销本金
            ,updatedate -- 更新时间
            ,ifsearch -- 是否保留对债务人的追索权
            ,interest -- 欠息
            ,inputuserid -- 登记人
            ,duebillserialno -- 借据编号
            ,currentuserid -- 分发岗
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,finebalance -- 罚息
            ,manager -- 客户经理（管护人）
            ,businesstype -- 业务品种
            ,approvehxinterest -- 审批核销利息
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,hxoutinterest -- 核销表外利息
            ,updateorgid -- 更新人机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.hxtype -- 核销类别
    ,o.customerid -- 客户编号
    ,o.approvehxdate -- 审批核销日期
    ,o.approvehxmoney -- 审批核销本金
    ,o.hxdfmoney -- 核销垫付费用
    ,o.resum -- 复息
    ,o.customername -- 客户名称
    ,o.approvehxininterest -- 审批核销表内利息
    ,o.hxdate -- 核销日期
    ,o.attribute1 -- 诉讼等垫付费用
    ,o.inputorgid -- 登记机构
    ,o.approvehxoutinterest -- 审批核销表外利息
    ,o.balance -- 贷款余额
    ,o.commitflag -- 提交状态（0客户经理1保全分发岗2保全经理及以上）
    ,o.hxininterest -- 核销表内利息
    ,o.hxmoney -- 核销本金
    ,o.updatedate -- 更新时间
    ,o.ifsearch -- 是否保留对债务人的追索权
    ,o.interest -- 欠息
    ,o.inputuserid -- 登记人
    ,o.duebillserialno -- 借据编号
    ,o.currentuserid -- 分发岗
    ,o.certtype -- 证件类型
    ,o.certid -- 证件号码
    ,o.finebalance -- 罚息
    ,o.manager -- 客户经理（管护人）
    ,o.businesstype -- 业务品种
    ,o.approvehxinterest -- 审批核销利息
    ,o.inputdate -- 登记时间
    ,o.updateuserid -- 更新人
    ,o.hxoutinterest -- 核销表外利息
    ,o.updateorgid -- 更新人机构
    ,o.migtflag -- 迁移标志：crsrcrilcupl
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
from ${iol_schema}.icms_dzhx_apply_bk o
    left join ${iol_schema}.icms_dzhx_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_dzhx_apply_cl d
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
--truncate table ${iol_schema}.icms_dzhx_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_dzhx_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_dzhx_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_dzhx_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_dzhx_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_dzhx_apply_cl;
alter table ${iol_schema}.icms_dzhx_apply exchange partition p_20991231 with table ${iol_schema}.icms_dzhx_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_dzhx_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_dzhx_apply_op purge;
drop table ${iol_schema}.icms_dzhx_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_dzhx_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_dzhx_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
