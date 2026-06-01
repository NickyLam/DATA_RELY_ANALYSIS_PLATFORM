/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_renew_info
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
create table ${iol_schema}.icms_renew_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_renew_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_renew_info_op purge;
drop table ${iol_schema}.icms_renew_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_renew_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_renew_info where 0=1;

create table ${iol_schema}.icms_renew_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_renew_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_renew_info_cl(
            serialno -- 流水号
            ,duebillserialno -- 借据编号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,baseratetype -- 利率类型
            ,maturity -- 展期终止日期
            ,termmonth -- 展期期限（月）
            ,baserate -- LPR(%)
            ,floatrange -- 展期浮动点差BP
            ,ratefloattype -- 展期正常利率浮动方式
            ,executerate -- 展期执行利率(%)
            ,overdueratefloattype -- 展期逾期利率浮动方式
            ,overdueratefloatvalue -- 展期逾期利率浮动比例
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,whethertorestructuretheloan -- 是否重组贷款
            ,completeflag -- 数据录入完整性
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期
            ,status -- 处理状态
            ,remark -- 处理备注
            ,newrepaytype -- 还款方式
            ,newrepaycycle -- 还款周期
            ,balldate -- 气球摊销日期
            ,bailsum -- 递增金额
            ,pdgpaypercent -- 递增比例
            ,orderno -- 预约编号
            ,execstatus -- 执行结果
            ,contractno -- 展期合同号
            ,oldmaturity -- 原合同到期日
            ,oldratefloattype -- 原利率浮动方式
            ,oldrateadjusttype -- 原利率调整周期
            ,oldfloatrange -- 原贷款浮动点差BP
            ,oldexecuterate -- 原执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_renew_info_op(
            serialno -- 流水号
            ,duebillserialno -- 借据编号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,baseratetype -- 利率类型
            ,maturity -- 展期终止日期
            ,termmonth -- 展期期限（月）
            ,baserate -- LPR(%)
            ,floatrange -- 展期浮动点差BP
            ,ratefloattype -- 展期正常利率浮动方式
            ,executerate -- 展期执行利率(%)
            ,overdueratefloattype -- 展期逾期利率浮动方式
            ,overdueratefloatvalue -- 展期逾期利率浮动比例
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,whethertorestructuretheloan -- 是否重组贷款
            ,completeflag -- 数据录入完整性
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期
            ,status -- 处理状态
            ,remark -- 处理备注
            ,newrepaytype -- 还款方式
            ,newrepaycycle -- 还款周期
            ,balldate -- 气球摊销日期
            ,bailsum -- 递增金额
            ,pdgpaypercent -- 递增比例
            ,orderno -- 预约编号
            ,execstatus -- 执行结果
            ,contractno -- 展期合同号
            ,oldmaturity -- 原合同到期日
            ,oldratefloattype -- 原利率浮动方式
            ,oldrateadjusttype -- 原利率调整周期
            ,oldfloatrange -- 原贷款浮动点差BP
            ,oldexecuterate -- 原执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.duebillserialno, o.duebillserialno) as duebillserialno -- 借据编号
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 利率类型
    ,nvl(n.maturity, o.maturity) as maturity -- 展期终止日期
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 展期期限（月）
    ,nvl(n.baserate, o.baserate) as baserate -- LPR(%)
    ,nvl(n.floatrange, o.floatrange) as floatrange -- 展期浮动点差BP
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 展期正常利率浮动方式
    ,nvl(n.executerate, o.executerate) as executerate -- 展期执行利率(%)
    ,nvl(n.overdueratefloattype, o.overdueratefloattype) as overdueratefloattype -- 展期逾期利率浮动方式
    ,nvl(n.overdueratefloatvalue, o.overdueratefloatvalue) as overdueratefloatvalue -- 展期逾期利率浮动比例
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式
    ,nvl(n.rateadjustfrequency, o.rateadjustfrequency) as rateadjustfrequency -- 利率调整周期
    ,nvl(n.whethertorestructuretheloan, o.whethertorestructuretheloan) as whethertorestructuretheloan -- 是否重组贷款
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 数据录入完整性
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期
    ,nvl(n.status, o.status) as status -- 处理状态
    ,nvl(n.remark, o.remark) as remark -- 处理备注
    ,nvl(n.newrepaytype, o.newrepaytype) as newrepaytype -- 还款方式
    ,nvl(n.newrepaycycle, o.newrepaycycle) as newrepaycycle -- 还款周期
    ,nvl(n.balldate, o.balldate) as balldate -- 气球摊销日期
    ,nvl(n.bailsum, o.bailsum) as bailsum -- 递增金额
    ,nvl(n.pdgpaypercent, o.pdgpaypercent) as pdgpaypercent -- 递增比例
    ,nvl(n.orderno, o.orderno) as orderno -- 预约编号
    ,nvl(n.execstatus, o.execstatus) as execstatus -- 执行结果
    ,nvl(n.contractno, o.contractno) as contractno -- 展期合同号
    ,nvl(n.oldmaturity, o.oldmaturity) as oldmaturity -- 原合同到期日
    ,nvl(n.oldratefloattype, o.oldratefloattype) as oldratefloattype -- 原利率浮动方式
    ,nvl(n.oldrateadjusttype, o.oldrateadjusttype) as oldrateadjusttype -- 原利率调整周期
    ,nvl(n.oldfloatrange, o.oldfloatrange) as oldfloatrange -- 原贷款浮动点差BP
    ,nvl(n.oldexecuterate, o.oldexecuterate) as oldexecuterate -- 原执行年利率
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
from (select * from ${iol_schema}.icms_renew_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_renew_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.duebillserialno <> n.duebillserialno
        or o.objectno <> n.objectno
        or o.objecttype <> n.objecttype
        or o.baseratetype <> n.baseratetype
        or o.maturity <> n.maturity
        or o.termmonth <> n.termmonth
        or o.baserate <> n.baserate
        or o.floatrange <> n.floatrange
        or o.ratefloattype <> n.ratefloattype
        or o.executerate <> n.executerate
        or o.overdueratefloattype <> n.overdueratefloattype
        or o.overdueratefloatvalue <> n.overdueratefloatvalue
        or o.rateadjusttype <> n.rateadjusttype
        or o.rateadjustfrequency <> n.rateadjustfrequency
        or o.whethertorestructuretheloan <> n.whethertorestructuretheloan
        or o.completeflag <> n.completeflag
        or o.repaytype <> n.repaytype
        or o.repaycycle <> n.repaycycle
        or o.status <> n.status
        or o.remark <> n.remark
        or o.newrepaytype <> n.newrepaytype
        or o.newrepaycycle <> n.newrepaycycle
        or o.balldate <> n.balldate
        or o.bailsum <> n.bailsum
        or o.pdgpaypercent <> n.pdgpaypercent
        or o.orderno <> n.orderno
        or o.execstatus <> n.execstatus
        or o.contractno <> n.contractno
        or o.oldmaturity <> n.oldmaturity
        or o.oldratefloattype <> n.oldratefloattype
        or o.oldrateadjusttype <> n.oldrateadjusttype
        or o.oldfloatrange <> n.oldfloatrange
        or o.oldexecuterate <> n.oldexecuterate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_renew_info_cl(
            serialno -- 流水号
            ,duebillserialno -- 借据编号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,baseratetype -- 利率类型
            ,maturity -- 展期终止日期
            ,termmonth -- 展期期限（月）
            ,baserate -- LPR(%)
            ,floatrange -- 展期浮动点差BP
            ,ratefloattype -- 展期正常利率浮动方式
            ,executerate -- 展期执行利率(%)
            ,overdueratefloattype -- 展期逾期利率浮动方式
            ,overdueratefloatvalue -- 展期逾期利率浮动比例
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,whethertorestructuretheloan -- 是否重组贷款
            ,completeflag -- 数据录入完整性
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期
            ,status -- 处理状态
            ,remark -- 处理备注
            ,newrepaytype -- 还款方式
            ,newrepaycycle -- 还款周期
            ,balldate -- 气球摊销日期
            ,bailsum -- 递增金额
            ,pdgpaypercent -- 递增比例
            ,orderno -- 预约编号
            ,execstatus -- 执行结果
            ,contractno -- 展期合同号
            ,oldmaturity -- 原合同到期日
            ,oldratefloattype -- 原利率浮动方式
            ,oldrateadjusttype -- 原利率调整周期
            ,oldfloatrange -- 原贷款浮动点差BP
            ,oldexecuterate -- 原执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_renew_info_op(
            serialno -- 流水号
            ,duebillserialno -- 借据编号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,baseratetype -- 利率类型
            ,maturity -- 展期终止日期
            ,termmonth -- 展期期限（月）
            ,baserate -- LPR(%)
            ,floatrange -- 展期浮动点差BP
            ,ratefloattype -- 展期正常利率浮动方式
            ,executerate -- 展期执行利率(%)
            ,overdueratefloattype -- 展期逾期利率浮动方式
            ,overdueratefloatvalue -- 展期逾期利率浮动比例
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,whethertorestructuretheloan -- 是否重组贷款
            ,completeflag -- 数据录入完整性
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期
            ,status -- 处理状态
            ,remark -- 处理备注
            ,newrepaytype -- 还款方式
            ,newrepaycycle -- 还款周期
            ,balldate -- 气球摊销日期
            ,bailsum -- 递增金额
            ,pdgpaypercent -- 递增比例
            ,orderno -- 预约编号
            ,execstatus -- 执行结果
            ,contractno -- 展期合同号
            ,oldmaturity -- 原合同到期日
            ,oldratefloattype -- 原利率浮动方式
            ,oldrateadjusttype -- 原利率调整周期
            ,oldfloatrange -- 原贷款浮动点差BP
            ,oldexecuterate -- 原执行年利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.duebillserialno -- 借据编号
    ,o.objectno -- 对象编号
    ,o.objecttype -- 对象类型
    ,o.baseratetype -- 利率类型
    ,o.maturity -- 展期终止日期
    ,o.termmonth -- 展期期限（月）
    ,o.baserate -- LPR(%)
    ,o.floatrange -- 展期浮动点差BP
    ,o.ratefloattype -- 展期正常利率浮动方式
    ,o.executerate -- 展期执行利率(%)
    ,o.overdueratefloattype -- 展期逾期利率浮动方式
    ,o.overdueratefloatvalue -- 展期逾期利率浮动比例
    ,o.rateadjusttype -- 利率调整方式
    ,o.rateadjustfrequency -- 利率调整周期
    ,o.whethertorestructuretheloan -- 是否重组贷款
    ,o.completeflag -- 数据录入完整性
    ,o.repaytype -- 还款方式
    ,o.repaycycle -- 还款周期
    ,o.status -- 处理状态
    ,o.remark -- 处理备注
    ,o.newrepaytype -- 还款方式
    ,o.newrepaycycle -- 还款周期
    ,o.balldate -- 气球摊销日期
    ,o.bailsum -- 递增金额
    ,o.pdgpaypercent -- 递增比例
    ,o.orderno -- 预约编号
    ,o.execstatus -- 执行结果
    ,o.contractno -- 展期合同号
    ,o.oldmaturity -- 原合同到期日
    ,o.oldratefloattype -- 原利率浮动方式
    ,o.oldrateadjusttype -- 原利率调整周期
    ,o.oldfloatrange -- 原贷款浮动点差BP
    ,o.oldexecuterate -- 原执行年利率
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
from ${iol_schema}.icms_renew_info_bk o
    left join ${iol_schema}.icms_renew_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_renew_info_cl d
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
--truncate table ${iol_schema}.icms_renew_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_renew_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_renew_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_renew_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_renew_info exchange partition p_${batch_date} with table ${iol_schema}.icms_renew_info_cl;
alter table ${iol_schema}.icms_renew_info exchange partition p_20991231 with table ${iol_schema}.icms_renew_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_renew_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_renew_info_op purge;
drop table ${iol_schema}.icms_renew_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_renew_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_renew_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
