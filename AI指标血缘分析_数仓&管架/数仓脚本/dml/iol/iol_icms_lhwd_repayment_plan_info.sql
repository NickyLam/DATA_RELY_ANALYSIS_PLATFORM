/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lhwd_repayment_plan_info
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
create table ${iol_schema}.icms_lhwd_repayment_plan_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lhwd_repayment_plan_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_repayment_plan_info_op purge;
drop table ${iol_schema}.icms_lhwd_repayment_plan_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_repayment_plan_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_repayment_plan_info where 0=1;

create table ${iol_schema}.icms_lhwd_repayment_plan_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_repayment_plan_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhwd_repayment_plan_info_cl(
            curdate -- 业务日期 D日
            ,loanid -- 借据号
            ,termno -- 期次 从1开始
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,withdrawenddate -- 计息结束日期
            ,cleardate -- 结清日期
            ,termstatus -- 本期状态 1-正常 2-逾期 3-结清
            ,normalsum -- 应还本金
            ,prinbal -- 应还本金-实还本金
            ,inttotal -- 应还利息
            ,pnltinttotal -- 应还罚息
            ,pnltodiamt -- 应还复利
            ,prinrepay -- 实还本金
            ,intrepay -- 实还利息
            ,pnltintrepay -- 实还罚息
            ,pnltodiamtpay -- 实还复利
            ,intdiscount -- 减免利息
            ,pnltintdiscount -- 减免罚息
            ,pnltodidiscount -- 减免复利
            ,intbal -- 应还利息-实还利息
            ,pnltintbal -- 应还罚息-实还罚息
            ,pnltodibal -- 应还复利-实还复利
            ,daysovd -- 逾期天数
            ,intdaysovd -- 逾期天数
            ,daysovdt -- 根据本金逾期天数倒推
            ,intdaysovdt -- 根据利息逾期天数倒推
            ,currency -- 默认CNY 人民币元
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_repayment_plan_info_op(
            curdate -- 业务日期 D日
            ,loanid -- 借据号
            ,termno -- 期次 从1开始
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,withdrawenddate -- 计息结束日期
            ,cleardate -- 结清日期
            ,termstatus -- 本期状态 1-正常 2-逾期 3-结清
            ,normalsum -- 应还本金
            ,prinbal -- 应还本金-实还本金
            ,inttotal -- 应还利息
            ,pnltinttotal -- 应还罚息
            ,pnltodiamt -- 应还复利
            ,prinrepay -- 实还本金
            ,intrepay -- 实还利息
            ,pnltintrepay -- 实还罚息
            ,pnltodiamtpay -- 实还复利
            ,intdiscount -- 减免利息
            ,pnltintdiscount -- 减免罚息
            ,pnltodidiscount -- 减免复利
            ,intbal -- 应还利息-实还利息
            ,pnltintbal -- 应还罚息-实还罚息
            ,pnltodibal -- 应还复利-实还复利
            ,daysovd -- 逾期天数
            ,intdaysovd -- 逾期天数
            ,daysovdt -- 根据本金逾期天数倒推
            ,intdaysovdt -- 根据利息逾期天数倒推
            ,currency -- 默认CNY 人民币元
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.curdate, o.curdate) as curdate -- 业务日期 D日
    ,nvl(n.loanid, o.loanid) as loanid -- 借据号
    ,nvl(n.termno, o.termno) as termno -- 期次 从1开始
    ,nvl(n.startdate, o.startdate) as startdate -- 开始日期
    ,nvl(n.enddate, o.enddate) as enddate -- 到期日期
    ,nvl(n.withdrawenddate, o.withdrawenddate) as withdrawenddate -- 计息结束日期
    ,nvl(n.cleardate, o.cleardate) as cleardate -- 结清日期
    ,nvl(n.termstatus, o.termstatus) as termstatus -- 本期状态 1-正常 2-逾期 3-结清
    ,nvl(n.normalsum, o.normalsum) as normalsum -- 应还本金
    ,nvl(n.prinbal, o.prinbal) as prinbal -- 应还本金-实还本金
    ,nvl(n.inttotal, o.inttotal) as inttotal -- 应还利息
    ,nvl(n.pnltinttotal, o.pnltinttotal) as pnltinttotal -- 应还罚息
    ,nvl(n.pnltodiamt, o.pnltodiamt) as pnltodiamt -- 应还复利
    ,nvl(n.prinrepay, o.prinrepay) as prinrepay -- 实还本金
    ,nvl(n.intrepay, o.intrepay) as intrepay -- 实还利息
    ,nvl(n.pnltintrepay, o.pnltintrepay) as pnltintrepay -- 实还罚息
    ,nvl(n.pnltodiamtpay, o.pnltodiamtpay) as pnltodiamtpay -- 实还复利
    ,nvl(n.intdiscount, o.intdiscount) as intdiscount -- 减免利息
    ,nvl(n.pnltintdiscount, o.pnltintdiscount) as pnltintdiscount -- 减免罚息
    ,nvl(n.pnltodidiscount, o.pnltodidiscount) as pnltodidiscount -- 减免复利
    ,nvl(n.intbal, o.intbal) as intbal -- 应还利息-实还利息
    ,nvl(n.pnltintbal, o.pnltintbal) as pnltintbal -- 应还罚息-实还罚息
    ,nvl(n.pnltodibal, o.pnltodibal) as pnltodibal -- 应还复利-实还复利
    ,nvl(n.daysovd, o.daysovd) as daysovd -- 逾期天数
    ,nvl(n.intdaysovd, o.intdaysovd) as intdaysovd -- 逾期天数
    ,nvl(n.daysovdt, o.daysovdt) as daysovdt -- 根据本金逾期天数倒推
    ,nvl(n.intdaysovdt, o.intdaysovdt) as intdaysovdt -- 根据利息逾期天数倒推
    ,nvl(n.currency, o.currency) as currency -- 默认CNY 人民币元
    ,case when
            n.loanid is null
            and n.termno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.loanid is null
            and n.termno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.loanid is null
            and n.termno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_lhwd_repayment_plan_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lhwd_repayment_plan_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.loanid = n.loanid
            and o.termno = n.termno
where (
        o.loanid is null
        and o.termno is null
    )
    or (
        n.loanid is null
        and n.termno is null
    )
    or (
        o.curdate <> n.curdate
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.withdrawenddate <> n.withdrawenddate
        or o.cleardate <> n.cleardate
        or o.termstatus <> n.termstatus
        or o.normalsum <> n.normalsum
        or o.prinbal <> n.prinbal
        or o.inttotal <> n.inttotal
        or o.pnltinttotal <> n.pnltinttotal
        or o.pnltodiamt <> n.pnltodiamt
        or o.prinrepay <> n.prinrepay
        or o.intrepay <> n.intrepay
        or o.pnltintrepay <> n.pnltintrepay
        or o.pnltodiamtpay <> n.pnltodiamtpay
        or o.intdiscount <> n.intdiscount
        or o.pnltintdiscount <> n.pnltintdiscount
        or o.pnltodidiscount <> n.pnltodidiscount
        or o.intbal <> n.intbal
        or o.pnltintbal <> n.pnltintbal
        or o.pnltodibal <> n.pnltodibal
        or o.daysovd <> n.daysovd
        or o.intdaysovd <> n.intdaysovd
        or o.daysovdt <> n.daysovdt
        or o.intdaysovdt <> n.intdaysovdt
        or o.currency <> n.currency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhwd_repayment_plan_info_cl(
            curdate -- 业务日期 D日
            ,loanid -- 借据号
            ,termno -- 期次 从1开始
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,withdrawenddate -- 计息结束日期
            ,cleardate -- 结清日期
            ,termstatus -- 本期状态 1-正常 2-逾期 3-结清
            ,normalsum -- 应还本金
            ,prinbal -- 应还本金-实还本金
            ,inttotal -- 应还利息
            ,pnltinttotal -- 应还罚息
            ,pnltodiamt -- 应还复利
            ,prinrepay -- 实还本金
            ,intrepay -- 实还利息
            ,pnltintrepay -- 实还罚息
            ,pnltodiamtpay -- 实还复利
            ,intdiscount -- 减免利息
            ,pnltintdiscount -- 减免罚息
            ,pnltodidiscount -- 减免复利
            ,intbal -- 应还利息-实还利息
            ,pnltintbal -- 应还罚息-实还罚息
            ,pnltodibal -- 应还复利-实还复利
            ,daysovd -- 逾期天数
            ,intdaysovd -- 逾期天数
            ,daysovdt -- 根据本金逾期天数倒推
            ,intdaysovdt -- 根据利息逾期天数倒推
            ,currency -- 默认CNY 人民币元
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_repayment_plan_info_op(
            curdate -- 业务日期 D日
            ,loanid -- 借据号
            ,termno -- 期次 从1开始
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,withdrawenddate -- 计息结束日期
            ,cleardate -- 结清日期
            ,termstatus -- 本期状态 1-正常 2-逾期 3-结清
            ,normalsum -- 应还本金
            ,prinbal -- 应还本金-实还本金
            ,inttotal -- 应还利息
            ,pnltinttotal -- 应还罚息
            ,pnltodiamt -- 应还复利
            ,prinrepay -- 实还本金
            ,intrepay -- 实还利息
            ,pnltintrepay -- 实还罚息
            ,pnltodiamtpay -- 实还复利
            ,intdiscount -- 减免利息
            ,pnltintdiscount -- 减免罚息
            ,pnltodidiscount -- 减免复利
            ,intbal -- 应还利息-实还利息
            ,pnltintbal -- 应还罚息-实还罚息
            ,pnltodibal -- 应还复利-实还复利
            ,daysovd -- 逾期天数
            ,intdaysovd -- 逾期天数
            ,daysovdt -- 根据本金逾期天数倒推
            ,intdaysovdt -- 根据利息逾期天数倒推
            ,currency -- 默认CNY 人民币元
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.curdate -- 业务日期 D日
    ,o.loanid -- 借据号
    ,o.termno -- 期次 从1开始
    ,o.startdate -- 开始日期
    ,o.enddate -- 到期日期
    ,o.withdrawenddate -- 计息结束日期
    ,o.cleardate -- 结清日期
    ,o.termstatus -- 本期状态 1-正常 2-逾期 3-结清
    ,o.normalsum -- 应还本金
    ,o.prinbal -- 应还本金-实还本金
    ,o.inttotal -- 应还利息
    ,o.pnltinttotal -- 应还罚息
    ,o.pnltodiamt -- 应还复利
    ,o.prinrepay -- 实还本金
    ,o.intrepay -- 实还利息
    ,o.pnltintrepay -- 实还罚息
    ,o.pnltodiamtpay -- 实还复利
    ,o.intdiscount -- 减免利息
    ,o.pnltintdiscount -- 减免罚息
    ,o.pnltodidiscount -- 减免复利
    ,o.intbal -- 应还利息-实还利息
    ,o.pnltintbal -- 应还罚息-实还罚息
    ,o.pnltodibal -- 应还复利-实还复利
    ,o.daysovd -- 逾期天数
    ,o.intdaysovd -- 逾期天数
    ,o.daysovdt -- 根据本金逾期天数倒推
    ,o.intdaysovdt -- 根据利息逾期天数倒推
    ,o.currency -- 默认CNY 人民币元
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
from ${iol_schema}.icms_lhwd_repayment_plan_info_bk o
    left join ${iol_schema}.icms_lhwd_repayment_plan_info_op n
        on
            o.loanid = n.loanid
            and o.termno = n.termno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lhwd_repayment_plan_info_cl d
        on
            o.loanid = d.loanid
            and o.termno = d.termno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_lhwd_repayment_plan_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lhwd_repayment_plan_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lhwd_repayment_plan_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lhwd_repayment_plan_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lhwd_repayment_plan_info exchange partition p_${batch_date} with table ${iol_schema}.icms_lhwd_repayment_plan_info_cl;
alter table ${iol_schema}.icms_lhwd_repayment_plan_info exchange partition p_20991231 with table ${iol_schema}.icms_lhwd_repayment_plan_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lhwd_repayment_plan_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_repayment_plan_info_op purge;
drop table ${iol_schema}.icms_lhwd_repayment_plan_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lhwd_repayment_plan_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lhwd_repayment_plan_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
