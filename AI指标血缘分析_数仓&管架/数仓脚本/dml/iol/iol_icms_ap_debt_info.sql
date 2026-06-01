/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_debt_info
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
create table ${iol_schema}.icms_ap_debt_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_debt_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_debt_info_op purge;
drop table ${iol_schema}.icms_ap_debt_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_debt_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_debt_info where 0=1;

create table ${iol_schema}.icms_ap_debt_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_debt_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_debt_info_cl(
            serialno -- 流水号
            ,interestbalance -- 基准日利息余额元）
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,actpayinterest -- 实际偿还利息元）
            ,contractno -- 合同流水号
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,principalbalance -- 基准日本金余额元）
            ,inputdate -- 登记日期
            ,singledividebal -- 单户分配金额元）
            ,singleliqrate -- 单户清收比例%）
            ,legalitycost -- 基准日法律性费用元）
            ,actpaylegalitycost -- 实际偿还法律性费用元）
            ,programno -- 方案编号
            ,standarddate -- 基准日期
            ,updateuserid -- 更新人
            ,actpaybalance -- 实际偿还本金元）
            ,debtsum -- 基准日债权总额元）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_debt_info_op(
            serialno -- 流水号
            ,interestbalance -- 基准日利息余额元）
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,actpayinterest -- 实际偿还利息元）
            ,contractno -- 合同流水号
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,principalbalance -- 基准日本金余额元）
            ,inputdate -- 登记日期
            ,singledividebal -- 单户分配金额元）
            ,singleliqrate -- 单户清收比例%）
            ,legalitycost -- 基准日法律性费用元）
            ,actpaylegalitycost -- 实际偿还法律性费用元）
            ,programno -- 方案编号
            ,standarddate -- 基准日期
            ,updateuserid -- 更新人
            ,actpaybalance -- 实际偿还本金元）
            ,debtsum -- 基准日债权总额元）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.interestbalance, o.interestbalance) as interestbalance -- 基准日利息余额元）
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.actpayinterest, o.actpayinterest) as actpayinterest -- 实际偿还利息元）
    ,nvl(n.contractno, o.contractno) as contractno -- 合同流水号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.principalbalance, o.principalbalance) as principalbalance -- 基准日本金余额元）
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.singledividebal, o.singledividebal) as singledividebal -- 单户分配金额元）
    ,nvl(n.singleliqrate, o.singleliqrate) as singleliqrate -- 单户清收比例%）
    ,nvl(n.legalitycost, o.legalitycost) as legalitycost -- 基准日法律性费用元）
    ,nvl(n.actpaylegalitycost, o.actpaylegalitycost) as actpaylegalitycost -- 实际偿还法律性费用元）
    ,nvl(n.programno, o.programno) as programno -- 方案编号
    ,nvl(n.standarddate, o.standarddate) as standarddate -- 基准日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.actpaybalance, o.actpaybalance) as actpaybalance -- 实际偿还本金元）
    ,nvl(n.debtsum, o.debtsum) as debtsum -- 基准日债权总额元）
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
from (select * from ${iol_schema}.icms_ap_debt_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_debt_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.interestbalance <> n.interestbalance
        or o.inputorgid <> n.inputorgid
        or o.updatedate <> n.updatedate
        or o.actpayinterest <> n.actpayinterest
        or o.contractno <> n.contractno
        or o.inputuserid <> n.inputuserid
        or o.updateorgid <> n.updateorgid
        or o.principalbalance <> n.principalbalance
        or o.inputdate <> n.inputdate
        or o.singledividebal <> n.singledividebal
        or o.singleliqrate <> n.singleliqrate
        or o.legalitycost <> n.legalitycost
        or o.actpaylegalitycost <> n.actpaylegalitycost
        or o.programno <> n.programno
        or o.standarddate <> n.standarddate
        or o.updateuserid <> n.updateuserid
        or o.actpaybalance <> n.actpaybalance
        or o.debtsum <> n.debtsum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_debt_info_cl(
            serialno -- 流水号
            ,interestbalance -- 基准日利息余额元）
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,actpayinterest -- 实际偿还利息元）
            ,contractno -- 合同流水号
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,principalbalance -- 基准日本金余额元）
            ,inputdate -- 登记日期
            ,singledividebal -- 单户分配金额元）
            ,singleliqrate -- 单户清收比例%）
            ,legalitycost -- 基准日法律性费用元）
            ,actpaylegalitycost -- 实际偿还法律性费用元）
            ,programno -- 方案编号
            ,standarddate -- 基准日期
            ,updateuserid -- 更新人
            ,actpaybalance -- 实际偿还本金元）
            ,debtsum -- 基准日债权总额元）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_debt_info_op(
            serialno -- 流水号
            ,interestbalance -- 基准日利息余额元）
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,actpayinterest -- 实际偿还利息元）
            ,contractno -- 合同流水号
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,principalbalance -- 基准日本金余额元）
            ,inputdate -- 登记日期
            ,singledividebal -- 单户分配金额元）
            ,singleliqrate -- 单户清收比例%）
            ,legalitycost -- 基准日法律性费用元）
            ,actpaylegalitycost -- 实际偿还法律性费用元）
            ,programno -- 方案编号
            ,standarddate -- 基准日期
            ,updateuserid -- 更新人
            ,actpaybalance -- 实际偿还本金元）
            ,debtsum -- 基准日债权总额元）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.interestbalance -- 基准日利息余额元）
    ,o.inputorgid -- 登记机构
    ,o.updatedate -- 更新日期
    ,o.actpayinterest -- 实际偿还利息元）
    ,o.contractno -- 合同流水号
    ,o.inputuserid -- 登记人
    ,o.updateorgid -- 更新机构
    ,o.principalbalance -- 基准日本金余额元）
    ,o.inputdate -- 登记日期
    ,o.singledividebal -- 单户分配金额元）
    ,o.singleliqrate -- 单户清收比例%）
    ,o.legalitycost -- 基准日法律性费用元）
    ,o.actpaylegalitycost -- 实际偿还法律性费用元）
    ,o.programno -- 方案编号
    ,o.standarddate -- 基准日期
    ,o.updateuserid -- 更新人
    ,o.actpaybalance -- 实际偿还本金元）
    ,o.debtsum -- 基准日债权总额元）
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
from ${iol_schema}.icms_ap_debt_info_bk o
    left join ${iol_schema}.icms_ap_debt_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_debt_info_cl d
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
--truncate table ${iol_schema}.icms_ap_debt_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_debt_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_debt_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_debt_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_debt_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_debt_info_cl;
alter table ${iol_schema}.icms_ap_debt_info exchange partition p_20991231 with table ${iol_schema}.icms_ap_debt_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_debt_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_debt_info_op purge;
drop table ${iol_schema}.icms_ap_debt_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_debt_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_debt_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
