/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wld_tm_schedule
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
create table ${iol_schema}.icms_wld_tm_schedule_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wld_tm_schedule
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wld_tm_schedule_op purge;
drop table ${iol_schema}.icms_wld_tm_schedule_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wld_tm_schedule_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wld_tm_schedule where 0=1;

create table ${iol_schema}.icms_wld_tm_schedule_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wld_tm_schedule where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wld_tm_schedule_cl(
            scheduleid -- 分配表id
            ,loanid -- 贷款计划id
            ,org -- 机构号
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,logicalcardno -- 逻辑卡号
            ,cardno -- 卡号
            ,loaninitprin -- 贷款总本金
            ,loaninitterm -- 贷款总期数
            ,currterm -- 当前期数
            ,loantermprin -- 应还本金
            ,loantermfee1 -- 应还费用
            ,loantermintegererest -- 应还利息
            ,loanpmtduedate -- 到款到期还款日期
            ,loangracedate -- 宽限日
            ,lastmodifieddatetime -- 修改时间
            ,startdate -- 起息日
            ,scheduleaction -- 还款计划操作动作
            ,prinpaid -- 已偿还本金
            ,integerpaid -- 已偿还利息
            ,penaltypaid -- 已偿还罚息
            ,compoundpaid -- 已偿还复利
            ,feepaid -- 已偿还费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wld_tm_schedule_op(
            scheduleid -- 分配表id
            ,loanid -- 贷款计划id
            ,org -- 机构号
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,logicalcardno -- 逻辑卡号
            ,cardno -- 卡号
            ,loaninitprin -- 贷款总本金
            ,loaninitterm -- 贷款总期数
            ,currterm -- 当前期数
            ,loantermprin -- 应还本金
            ,loantermfee1 -- 应还费用
            ,loantermintegererest -- 应还利息
            ,loanpmtduedate -- 到款到期还款日期
            ,loangracedate -- 宽限日
            ,lastmodifieddatetime -- 修改时间
            ,startdate -- 起息日
            ,scheduleaction -- 还款计划操作动作
            ,prinpaid -- 已偿还本金
            ,integerpaid -- 已偿还利息
            ,penaltypaid -- 已偿还罚息
            ,compoundpaid -- 已偿还复利
            ,feepaid -- 已偿还费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.scheduleid, o.scheduleid) as scheduleid -- 分配表id
    ,nvl(n.loanid, o.loanid) as loanid -- 贷款计划id
    ,nvl(n.org, o.org) as org -- 机构号
    ,nvl(n.acctno, o.acctno) as acctno -- 账户编号
    ,nvl(n.accttype, o.accttype) as accttype -- 账户类型
    ,nvl(n.logicalcardno, o.logicalcardno) as logicalcardno -- 逻辑卡号
    ,nvl(n.cardno, o.cardno) as cardno -- 卡号
    ,nvl(n.loaninitprin, o.loaninitprin) as loaninitprin -- 贷款总本金
    ,nvl(n.loaninitterm, o.loaninitterm) as loaninitterm -- 贷款总期数
    ,nvl(n.currterm, o.currterm) as currterm -- 当前期数
    ,nvl(n.loantermprin, o.loantermprin) as loantermprin -- 应还本金
    ,nvl(n.loantermfee1, o.loantermfee1) as loantermfee1 -- 应还费用
    ,nvl(n.loantermintegererest, o.loantermintegererest) as loantermintegererest -- 应还利息
    ,nvl(n.loanpmtduedate, o.loanpmtduedate) as loanpmtduedate -- 到款到期还款日期
    ,nvl(n.loangracedate, o.loangracedate) as loangracedate -- 宽限日
    ,nvl(n.lastmodifieddatetime, o.lastmodifieddatetime) as lastmodifieddatetime -- 修改时间
    ,nvl(n.startdate, o.startdate) as startdate -- 起息日
    ,nvl(n.scheduleaction, o.scheduleaction) as scheduleaction -- 还款计划操作动作
    ,nvl(n.prinpaid, o.prinpaid) as prinpaid -- 已偿还本金
    ,nvl(n.integerpaid, o.integerpaid) as integerpaid -- 已偿还利息
    ,nvl(n.penaltypaid, o.penaltypaid) as penaltypaid -- 已偿还罚息
    ,nvl(n.compoundpaid, o.compoundpaid) as compoundpaid -- 已偿还复利
    ,nvl(n.feepaid, o.feepaid) as feepaid -- 已偿还费用
    ,case when
            n.scheduleid is null
            and n.loanid is null
            and n.currterm is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.scheduleid is null
            and n.loanid is null
            and n.currterm is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.scheduleid is null
            and n.loanid is null
            and n.currterm is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wld_tm_schedule_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wld_tm_schedule where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.scheduleid = n.scheduleid
            and o.loanid = n.loanid
            and o.currterm = n.currterm
where (
        o.scheduleid is null
        and o.loanid is null
        and o.currterm is null
    )
    or (
        n.scheduleid is null
        and n.loanid is null
        and n.currterm is null
    )
    or (
        o.org <> n.org
        or o.acctno <> n.acctno
        or o.accttype <> n.accttype
        or o.logicalcardno <> n.logicalcardno
        or o.cardno <> n.cardno
        or o.loaninitprin <> n.loaninitprin
        or o.loaninitterm <> n.loaninitterm
        or o.loantermprin <> n.loantermprin
        or o.loantermfee1 <> n.loantermfee1
        or o.loantermintegererest <> n.loantermintegererest
        or o.loanpmtduedate <> n.loanpmtduedate
        or o.loangracedate <> n.loangracedate
        or o.lastmodifieddatetime <> n.lastmodifieddatetime
        or o.startdate <> n.startdate
        or o.scheduleaction <> n.scheduleaction
        or o.prinpaid <> n.prinpaid
        or o.integerpaid <> n.integerpaid
        or o.penaltypaid <> n.penaltypaid
        or o.compoundpaid <> n.compoundpaid
        or o.feepaid <> n.feepaid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wld_tm_schedule_cl(
            scheduleid -- 分配表id
            ,loanid -- 贷款计划id
            ,org -- 机构号
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,logicalcardno -- 逻辑卡号
            ,cardno -- 卡号
            ,loaninitprin -- 贷款总本金
            ,loaninitterm -- 贷款总期数
            ,currterm -- 当前期数
            ,loantermprin -- 应还本金
            ,loantermfee1 -- 应还费用
            ,loantermintegererest -- 应还利息
            ,loanpmtduedate -- 到款到期还款日期
            ,loangracedate -- 宽限日
            ,lastmodifieddatetime -- 修改时间
            ,startdate -- 起息日
            ,scheduleaction -- 还款计划操作动作
            ,prinpaid -- 已偿还本金
            ,integerpaid -- 已偿还利息
            ,penaltypaid -- 已偿还罚息
            ,compoundpaid -- 已偿还复利
            ,feepaid -- 已偿还费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wld_tm_schedule_op(
            scheduleid -- 分配表id
            ,loanid -- 贷款计划id
            ,org -- 机构号
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,logicalcardno -- 逻辑卡号
            ,cardno -- 卡号
            ,loaninitprin -- 贷款总本金
            ,loaninitterm -- 贷款总期数
            ,currterm -- 当前期数
            ,loantermprin -- 应还本金
            ,loantermfee1 -- 应还费用
            ,loantermintegererest -- 应还利息
            ,loanpmtduedate -- 到款到期还款日期
            ,loangracedate -- 宽限日
            ,lastmodifieddatetime -- 修改时间
            ,startdate -- 起息日
            ,scheduleaction -- 还款计划操作动作
            ,prinpaid -- 已偿还本金
            ,integerpaid -- 已偿还利息
            ,penaltypaid -- 已偿还罚息
            ,compoundpaid -- 已偿还复利
            ,feepaid -- 已偿还费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.scheduleid -- 分配表id
    ,o.loanid -- 贷款计划id
    ,o.org -- 机构号
    ,o.acctno -- 账户编号
    ,o.accttype -- 账户类型
    ,o.logicalcardno -- 逻辑卡号
    ,o.cardno -- 卡号
    ,o.loaninitprin -- 贷款总本金
    ,o.loaninitterm -- 贷款总期数
    ,o.currterm -- 当前期数
    ,o.loantermprin -- 应还本金
    ,o.loantermfee1 -- 应还费用
    ,o.loantermintegererest -- 应还利息
    ,o.loanpmtduedate -- 到款到期还款日期
    ,o.loangracedate -- 宽限日
    ,o.lastmodifieddatetime -- 修改时间
    ,o.startdate -- 起息日
    ,o.scheduleaction -- 还款计划操作动作
    ,o.prinpaid -- 已偿还本金
    ,o.integerpaid -- 已偿还利息
    ,o.penaltypaid -- 已偿还罚息
    ,o.compoundpaid -- 已偿还复利
    ,o.feepaid -- 已偿还费用
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
from ${iol_schema}.icms_wld_tm_schedule_bk o
    left join ${iol_schema}.icms_wld_tm_schedule_op n
        on
            o.scheduleid = n.scheduleid
            and o.loanid = n.loanid
            and o.currterm = n.currterm
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wld_tm_schedule_cl d
        on
            o.scheduleid = d.scheduleid
            and o.loanid = d.loanid
            and o.currterm = d.currterm
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wld_tm_schedule;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wld_tm_schedule') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wld_tm_schedule drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wld_tm_schedule add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wld_tm_schedule exchange partition p_${batch_date} with table ${iol_schema}.icms_wld_tm_schedule_cl;
alter table ${iol_schema}.icms_wld_tm_schedule exchange partition p_20991231 with table ${iol_schema}.icms_wld_tm_schedule_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wld_tm_schedule to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wld_tm_schedule_op purge;
drop table ${iol_schema}.icms_wld_tm_schedule_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wld_tm_schedule_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wld_tm_schedule',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
