/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_repayment_plan_info
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
create table ${iol_schema}.icms_repayment_plan_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_repayment_plan_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_repayment_plan_info_op purge;
drop table ${iol_schema}.icms_repayment_plan_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_repayment_plan_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_repayment_plan_info where 0=1;

create table ${iol_schema}.icms_repayment_plan_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_repayment_plan_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_repayment_plan_info_cl(
            duebillserialno -- 借据流水号
            ,dateno -- 期号
            ,penaltyinterest -- 实还罚息
            ,paymenttype -- 还款方式
            ,unpaidsum -- 本期剩余本金
            ,businessrate -- 执行利率
            ,businesscurrency -- 币种
            ,enddate -- 终止日期
            ,flag -- 处理标志（0-已执行1-未执行）
            ,actualsum -- 实还本金
            ,actualinterest -- 实还利息
            ,compoundinterest -- 实还复息
            ,normalsum -- 正常本金
            ,periodinterestsum -- 本期应收利息
            ,executiondate -- 结清日期
            ,periodsum -- 本期应收本金
            ,discountsum -- 其中贴息金额
            ,startdate -- 起始日期
            ,putoutunpaidsum -- 借据剩余贷款本金
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,schedamt -- 每期还款总额
            ,intaccrued -- 应计利息
            ,odpaccrued -- 应计罚息
            ,odiaccrued -- 应计复利
            ,odpoutstanding -- 应收罚息
            ,odioutstanding -- 应收复利
            ,ysintamt -- 应收欠息
            ,remark -- 备注
            ,gracedate -- 宽限日期
            ,respaidintamt -- 剩余应还利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_repayment_plan_info_op(
            duebillserialno -- 借据流水号
            ,dateno -- 期号
            ,penaltyinterest -- 实还罚息
            ,paymenttype -- 还款方式
            ,unpaidsum -- 本期剩余本金
            ,businessrate -- 执行利率
            ,businesscurrency -- 币种
            ,enddate -- 终止日期
            ,flag -- 处理标志（0-已执行1-未执行）
            ,actualsum -- 实还本金
            ,actualinterest -- 实还利息
            ,compoundinterest -- 实还复息
            ,normalsum -- 正常本金
            ,periodinterestsum -- 本期应收利息
            ,executiondate -- 结清日期
            ,periodsum -- 本期应收本金
            ,discountsum -- 其中贴息金额
            ,startdate -- 起始日期
            ,putoutunpaidsum -- 借据剩余贷款本金
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,schedamt -- 每期还款总额
            ,intaccrued -- 应计利息
            ,odpaccrued -- 应计罚息
            ,odiaccrued -- 应计复利
            ,odpoutstanding -- 应收罚息
            ,odioutstanding -- 应收复利
            ,ysintamt -- 应收欠息
            ,remark -- 备注
            ,gracedate -- 宽限日期
            ,respaidintamt -- 剩余应还利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.duebillserialno, o.duebillserialno) as duebillserialno -- 借据流水号
    ,nvl(n.dateno, o.dateno) as dateno -- 期号
    ,nvl(n.penaltyinterest, o.penaltyinterest) as penaltyinterest -- 实还罚息
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 还款方式
    ,nvl(n.unpaidsum, o.unpaidsum) as unpaidsum -- 本期剩余本金
    ,nvl(n.businessrate, o.businessrate) as businessrate -- 执行利率
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 币种
    ,nvl(n.enddate, o.enddate) as enddate -- 终止日期
    ,nvl(n.flag, o.flag) as flag -- 处理标志（0-已执行1-未执行）
    ,nvl(n.actualsum, o.actualsum) as actualsum -- 实还本金
    ,nvl(n.actualinterest, o.actualinterest) as actualinterest -- 实还利息
    ,nvl(n.compoundinterest, o.compoundinterest) as compoundinterest -- 实还复息
    ,nvl(n.normalsum, o.normalsum) as normalsum -- 正常本金
    ,nvl(n.periodinterestsum, o.periodinterestsum) as periodinterestsum -- 本期应收利息
    ,nvl(n.executiondate, o.executiondate) as executiondate -- 结清日期
    ,nvl(n.periodsum, o.periodsum) as periodsum -- 本期应收本金
    ,nvl(n.discountsum, o.discountsum) as discountsum -- 其中贴息金额
    ,nvl(n.startdate, o.startdate) as startdate -- 起始日期
    ,nvl(n.putoutunpaidsum, o.putoutunpaidsum) as putoutunpaidsum -- 借据剩余贷款本金
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.schedamt, o.schedamt) as schedamt -- 每期还款总额
    ,nvl(n.intaccrued, o.intaccrued) as intaccrued -- 应计利息
    ,nvl(n.odpaccrued, o.odpaccrued) as odpaccrued -- 应计罚息
    ,nvl(n.odiaccrued, o.odiaccrued) as odiaccrued -- 应计复利
    ,nvl(n.odpoutstanding, o.odpoutstanding) as odpoutstanding -- 应收罚息
    ,nvl(n.odioutstanding, o.odioutstanding) as odioutstanding -- 应收复利
    ,nvl(n.ysintamt, o.ysintamt) as ysintamt -- 应收欠息
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.gracedate, o.gracedate) as gracedate -- 宽限日期
    ,nvl(n.respaidintamt, o.respaidintamt) as respaidintamt -- 剩余应还利息
    ,case when
            n.duebillserialno is null
            and n.dateno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.duebillserialno is null
            and n.dateno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.duebillserialno is null
            and n.dateno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_repayment_plan_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_repayment_plan_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.duebillserialno = n.duebillserialno
            and o.dateno = n.dateno
where (
        o.duebillserialno is null
        and o.dateno is null
    )
    or (
        n.duebillserialno is null
        and n.dateno is null
    )
    or (
        o.penaltyinterest <> n.penaltyinterest
        or o.paymenttype <> n.paymenttype
        or o.unpaidsum <> n.unpaidsum
        or o.businessrate <> n.businessrate
        or o.businesscurrency <> n.businesscurrency
        or o.enddate <> n.enddate
        or o.flag <> n.flag
        or o.actualsum <> n.actualsum
        or o.actualinterest <> n.actualinterest
        or o.compoundinterest <> n.compoundinterest
        or o.normalsum <> n.normalsum
        or o.periodinterestsum <> n.periodinterestsum
        or o.executiondate <> n.executiondate
        or o.periodsum <> n.periodsum
        or o.discountsum <> n.discountsum
        or o.startdate <> n.startdate
        or o.putoutunpaidsum <> n.putoutunpaidsum
        or o.migtflag <> n.migtflag
        or o.schedamt <> n.schedamt
        or o.intaccrued <> n.intaccrued
        or o.odpaccrued <> n.odpaccrued
        or o.odiaccrued <> n.odiaccrued
        or o.odpoutstanding <> n.odpoutstanding
        or o.odioutstanding <> n.odioutstanding
        or o.ysintamt <> n.ysintamt
        or o.remark <> n.remark
        or o.gracedate <> n.gracedate
        or o.respaidintamt <> n.respaidintamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_repayment_plan_info_cl(
            duebillserialno -- 借据流水号
            ,dateno -- 期号
            ,penaltyinterest -- 实还罚息
            ,paymenttype -- 还款方式
            ,unpaidsum -- 本期剩余本金
            ,businessrate -- 执行利率
            ,businesscurrency -- 币种
            ,enddate -- 终止日期
            ,flag -- 处理标志（0-已执行1-未执行）
            ,actualsum -- 实还本金
            ,actualinterest -- 实还利息
            ,compoundinterest -- 实还复息
            ,normalsum -- 正常本金
            ,periodinterestsum -- 本期应收利息
            ,executiondate -- 结清日期
            ,periodsum -- 本期应收本金
            ,discountsum -- 其中贴息金额
            ,startdate -- 起始日期
            ,putoutunpaidsum -- 借据剩余贷款本金
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,schedamt -- 每期还款总额
            ,intaccrued -- 应计利息
            ,odpaccrued -- 应计罚息
            ,odiaccrued -- 应计复利
            ,odpoutstanding -- 应收罚息
            ,odioutstanding -- 应收复利
            ,ysintamt -- 应收欠息
            ,remark -- 备注
            ,gracedate -- 宽限日期
            ,respaidintamt -- 剩余应还利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_repayment_plan_info_op(
            duebillserialno -- 借据流水号
            ,dateno -- 期号
            ,penaltyinterest -- 实还罚息
            ,paymenttype -- 还款方式
            ,unpaidsum -- 本期剩余本金
            ,businessrate -- 执行利率
            ,businesscurrency -- 币种
            ,enddate -- 终止日期
            ,flag -- 处理标志（0-已执行1-未执行）
            ,actualsum -- 实还本金
            ,actualinterest -- 实还利息
            ,compoundinterest -- 实还复息
            ,normalsum -- 正常本金
            ,periodinterestsum -- 本期应收利息
            ,executiondate -- 结清日期
            ,periodsum -- 本期应收本金
            ,discountsum -- 其中贴息金额
            ,startdate -- 起始日期
            ,putoutunpaidsum -- 借据剩余贷款本金
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,schedamt -- 每期还款总额
            ,intaccrued -- 应计利息
            ,odpaccrued -- 应计罚息
            ,odiaccrued -- 应计复利
            ,odpoutstanding -- 应收罚息
            ,odioutstanding -- 应收复利
            ,ysintamt -- 应收欠息
            ,remark -- 备注
            ,gracedate -- 宽限日期
            ,respaidintamt -- 剩余应还利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.duebillserialno -- 借据流水号
    ,o.dateno -- 期号
    ,o.penaltyinterest -- 实还罚息
    ,o.paymenttype -- 还款方式
    ,o.unpaidsum -- 本期剩余本金
    ,o.businessrate -- 执行利率
    ,o.businesscurrency -- 币种
    ,o.enddate -- 终止日期
    ,o.flag -- 处理标志（0-已执行1-未执行）
    ,o.actualsum -- 实还本金
    ,o.actualinterest -- 实还利息
    ,o.compoundinterest -- 实还复息
    ,o.normalsum -- 正常本金
    ,o.periodinterestsum -- 本期应收利息
    ,o.executiondate -- 结清日期
    ,o.periodsum -- 本期应收本金
    ,o.discountsum -- 其中贴息金额
    ,o.startdate -- 起始日期
    ,o.putoutunpaidsum -- 借据剩余贷款本金
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.schedamt -- 每期还款总额
    ,o.intaccrued -- 应计利息
    ,o.odpaccrued -- 应计罚息
    ,o.odiaccrued -- 应计复利
    ,o.odpoutstanding -- 应收罚息
    ,o.odioutstanding -- 应收复利
    ,o.ysintamt -- 应收欠息
    ,o.remark -- 备注
    ,o.gracedate -- 宽限日期
    ,o.respaidintamt -- 剩余应还利息
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
from ${iol_schema}.icms_repayment_plan_info_bk o
    left join ${iol_schema}.icms_repayment_plan_info_op n
        on
            o.duebillserialno = n.duebillserialno
            and o.dateno = n.dateno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_repayment_plan_info_cl d
        on
            o.duebillserialno = d.duebillserialno
            and o.dateno = d.dateno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_repayment_plan_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_repayment_plan_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_repayment_plan_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_repayment_plan_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_repayment_plan_info exchange partition p_${batch_date} with table ${iol_schema}.icms_repayment_plan_info_cl;
alter table ${iol_schema}.icms_repayment_plan_info exchange partition p_20991231 with table ${iol_schema}.icms_repayment_plan_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_repayment_plan_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_repayment_plan_info_op purge;
drop table ${iol_schema}.icms_repayment_plan_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_repayment_plan_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_repayment_plan_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
