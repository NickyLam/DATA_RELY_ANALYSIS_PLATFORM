/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_ci_repdataldx
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
create table ${iol_schema}.nrrs_ci_repdataldx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_ci_repdataldx;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_ci_repdataldx_op purge;
drop table ${iol_schema}.nrrs_ci_repdataldx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_ci_repdataldx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_ci_repdataldx where 0=1;

create table ${iol_schema}.nrrs_ci_repdataldx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_ci_repdataldx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_ci_repdataldx_cl(
            custid -- 客户号
            ,repno -- 报表期数
            ,caliber -- 报表口径
            ,nando -- 新旧会计准则
            ,typecode -- 报表类型
            ,currenttype -- 币种代码
            ,countinghouse -- 会计师事务所名称
            ,auditrepno -- 审计报告编号
            ,auditrst -- 审计意见
            ,auditdate -- 审计日期
            ,auditor -- 审计人员名称
            ,mergescope -- 合并范围
            ,repcustmgr -- 客户经理
            ,credibility -- 财务可信度
            ,submitdate -- 提交时间
            ,state -- 状态
            ,regioncode -- 地区号
            ,jsstate -- 解锁状态0未解锁1解锁
            ,jzdate -- 报表截止日期
            ,unit -- 报表单位
            ,inputdate -- 登记日期
            ,updatedate -- 修改日期
            ,repperiod -- 报表周期
            ,isaudit -- 是否审计：1审计 0未审计
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,recordno -- 报表流水号（信贷）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_ci_repdataldx_op(
            custid -- 客户号
            ,repno -- 报表期数
            ,caliber -- 报表口径
            ,nando -- 新旧会计准则
            ,typecode -- 报表类型
            ,currenttype -- 币种代码
            ,countinghouse -- 会计师事务所名称
            ,auditrepno -- 审计报告编号
            ,auditrst -- 审计意见
            ,auditdate -- 审计日期
            ,auditor -- 审计人员名称
            ,mergescope -- 合并范围
            ,repcustmgr -- 客户经理
            ,credibility -- 财务可信度
            ,submitdate -- 提交时间
            ,state -- 状态
            ,regioncode -- 地区号
            ,jsstate -- 解锁状态0未解锁1解锁
            ,jzdate -- 报表截止日期
            ,unit -- 报表单位
            ,inputdate -- 登记日期
            ,updatedate -- 修改日期
            ,repperiod -- 报表周期
            ,isaudit -- 是否审计：1审计 0未审计
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,recordno -- 报表流水号（信贷）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.custid, o.custid) as custid -- 客户号
    ,nvl(n.repno, o.repno) as repno -- 报表期数
    ,nvl(n.caliber, o.caliber) as caliber -- 报表口径
    ,nvl(n.nando, o.nando) as nando -- 新旧会计准则
    ,nvl(n.typecode, o.typecode) as typecode -- 报表类型
    ,nvl(n.currenttype, o.currenttype) as currenttype -- 币种代码
    ,nvl(n.countinghouse, o.countinghouse) as countinghouse -- 会计师事务所名称
    ,nvl(n.auditrepno, o.auditrepno) as auditrepno -- 审计报告编号
    ,nvl(n.auditrst, o.auditrst) as auditrst -- 审计意见
    ,nvl(n.auditdate, o.auditdate) as auditdate -- 审计日期
    ,nvl(n.auditor, o.auditor) as auditor -- 审计人员名称
    ,nvl(n.mergescope, o.mergescope) as mergescope -- 合并范围
    ,nvl(n.repcustmgr, o.repcustmgr) as repcustmgr -- 客户经理
    ,nvl(n.credibility, o.credibility) as credibility -- 财务可信度
    ,nvl(n.submitdate, o.submitdate) as submitdate -- 提交时间
    ,nvl(n.state, o.state) as state -- 状态
    ,nvl(n.regioncode, o.regioncode) as regioncode -- 地区号
    ,nvl(n.jsstate, o.jsstate) as jsstate -- 解锁状态0未解锁1解锁
    ,nvl(n.jzdate, o.jzdate) as jzdate -- 报表截止日期
    ,nvl(n.unit, o.unit) as unit -- 报表单位
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 修改日期
    ,nvl(n.repperiod, o.repperiod) as repperiod -- 报表周期
    ,nvl(n.isaudit, o.isaudit) as isaudit -- 是否审计：1审计 0未审计
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 登记机构
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人
    ,nvl(n.recordno, o.recordno) as recordno -- 报表流水号（信贷）
    ,case when
            n.custid is null
            and n.repno is null
            and n.caliber is null
            and n.recordno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.custid is null
            and n.repno is null
            and n.caliber is null
            and n.recordno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.custid is null
            and n.repno is null
            and n.caliber is null
            and n.recordno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_ci_repdataldx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nrrs_ci_repdataldx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custid = n.custid
            and o.repno = n.repno
            and o.caliber = n.caliber
            and o.recordno = n.recordno
where (
        o.custid is null
        and o.repno is null
        and o.caliber is null
        and o.recordno is null
    )
    or (
        n.custid is null
        and n.repno is null
        and n.caliber is null
        and n.recordno is null
    )
    or (
        o.nando <> n.nando
        or o.typecode <> n.typecode
        or o.currenttype <> n.currenttype
        or o.countinghouse <> n.countinghouse
        or o.auditrepno <> n.auditrepno
        or o.auditrst <> n.auditrst
        or o.auditdate <> n.auditdate
        or o.auditor <> n.auditor
        or o.mergescope <> n.mergescope
        or o.repcustmgr <> n.repcustmgr
        or o.credibility <> n.credibility
        or o.submitdate <> n.submitdate
        or o.state <> n.state
        or o.regioncode <> n.regioncode
        or o.jsstate <> n.jsstate
        or o.jzdate <> n.jzdate
        or o.unit <> n.unit
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.repperiod <> n.repperiod
        or o.isaudit <> n.isaudit
        or o.inputorg <> n.inputorg
        or o.inputuser <> n.inputuser
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_ci_repdataldx_cl(
            custid -- 客户号
            ,repno -- 报表期数
            ,caliber -- 报表口径
            ,nando -- 新旧会计准则
            ,typecode -- 报表类型
            ,currenttype -- 币种代码
            ,countinghouse -- 会计师事务所名称
            ,auditrepno -- 审计报告编号
            ,auditrst -- 审计意见
            ,auditdate -- 审计日期
            ,auditor -- 审计人员名称
            ,mergescope -- 合并范围
            ,repcustmgr -- 客户经理
            ,credibility -- 财务可信度
            ,submitdate -- 提交时间
            ,state -- 状态
            ,regioncode -- 地区号
            ,jsstate -- 解锁状态0未解锁1解锁
            ,jzdate -- 报表截止日期
            ,unit -- 报表单位
            ,inputdate -- 登记日期
            ,updatedate -- 修改日期
            ,repperiod -- 报表周期
            ,isaudit -- 是否审计：1审计 0未审计
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,recordno -- 报表流水号（信贷）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_ci_repdataldx_op(
            custid -- 客户号
            ,repno -- 报表期数
            ,caliber -- 报表口径
            ,nando -- 新旧会计准则
            ,typecode -- 报表类型
            ,currenttype -- 币种代码
            ,countinghouse -- 会计师事务所名称
            ,auditrepno -- 审计报告编号
            ,auditrst -- 审计意见
            ,auditdate -- 审计日期
            ,auditor -- 审计人员名称
            ,mergescope -- 合并范围
            ,repcustmgr -- 客户经理
            ,credibility -- 财务可信度
            ,submitdate -- 提交时间
            ,state -- 状态
            ,regioncode -- 地区号
            ,jsstate -- 解锁状态0未解锁1解锁
            ,jzdate -- 报表截止日期
            ,unit -- 报表单位
            ,inputdate -- 登记日期
            ,updatedate -- 修改日期
            ,repperiod -- 报表周期
            ,isaudit -- 是否审计：1审计 0未审计
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,recordno -- 报表流水号（信贷）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.custid -- 客户号
    ,o.repno -- 报表期数
    ,o.caliber -- 报表口径
    ,o.nando -- 新旧会计准则
    ,o.typecode -- 报表类型
    ,o.currenttype -- 币种代码
    ,o.countinghouse -- 会计师事务所名称
    ,o.auditrepno -- 审计报告编号
    ,o.auditrst -- 审计意见
    ,o.auditdate -- 审计日期
    ,o.auditor -- 审计人员名称
    ,o.mergescope -- 合并范围
    ,o.repcustmgr -- 客户经理
    ,o.credibility -- 财务可信度
    ,o.submitdate -- 提交时间
    ,o.state -- 状态
    ,o.regioncode -- 地区号
    ,o.jsstate -- 解锁状态0未解锁1解锁
    ,o.jzdate -- 报表截止日期
    ,o.unit -- 报表单位
    ,o.inputdate -- 登记日期
    ,o.updatedate -- 修改日期
    ,o.repperiod -- 报表周期
    ,o.isaudit -- 是否审计：1审计 0未审计
    ,o.inputorg -- 登记机构
    ,o.inputuser -- 登记人
    ,o.recordno -- 报表流水号（信贷）
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nrrs_ci_repdataldx_bk o
    left join ${iol_schema}.nrrs_ci_repdataldx_op n
        on
            o.custid = n.custid
            and o.repno = n.repno
            and o.caliber = n.caliber
            and o.recordno = n.recordno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nrrs_ci_repdataldx_cl d
        on
            o.custid = d.custid
            and o.repno = d.repno
            and o.caliber = d.caliber
            and o.recordno = d.recordno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nrrs_ci_repdataldx;

-- 4.2 exchange partition
alter table ${iol_schema}.nrrs_ci_repdataldx exchange partition p_19000101 with table ${iol_schema}.nrrs_ci_repdataldx_cl;
alter table ${iol_schema}.nrrs_ci_repdataldx exchange partition p_20991231 with table ${iol_schema}.nrrs_ci_repdataldx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_ci_repdataldx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_ci_repdataldx_op purge;
drop table ${iol_schema}.nrrs_ci_repdataldx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_ci_repdataldx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_ci_repdataldx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
