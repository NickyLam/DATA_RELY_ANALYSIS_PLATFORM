/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_parallel_reservation
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
create table ${iol_schema}.icms_parallel_reservation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_parallel_reservation
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_parallel_reservation_op purge;
drop table ${iol_schema}.icms_parallel_reservation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_parallel_reservation_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_parallel_reservation where 0=1;

create table ${iol_schema}.icms_parallel_reservation_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_parallel_reservation where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_parallel_reservation_cl(
            serialno -- 流水号
            ,baserialno -- 关联授信流水号
            ,customerid -- 客户id
            ,customername -- 客户名称
            ,reservationdate -- 预约作业时间
            ,reservationplace -- 预约作业地点
            ,approvedate -- 审批作业时间
            ,remark -- 备注
            ,actualdate -- 客户经理签到时间
            ,actualplace -- 客户经理签到地点
            ,reportstatus -- 报告状态
            ,actualdistance -- 客户经理签到地址与注册地距离
            ,situationremark -- 客户经理现场情况说明
            ,approvestatus -- 流程状态
            ,imageserialno -- 影像流水号
            ,riskmanagerid -- 风险经理id
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,riskactualdate -- 风险经理签到时间
            ,riskactualplace -- 风险经理签到地点
            ,riskactualdistance -- 风险经理签到地址与注册地距离
            ,risksituationremark -- 风险经理现场情况说明
            ,issignin -- 客户经理是否签到
            ,isrisksignin -- 风险经理是否签到
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_parallel_reservation_op(
            serialno -- 流水号
            ,baserialno -- 关联授信流水号
            ,customerid -- 客户id
            ,customername -- 客户名称
            ,reservationdate -- 预约作业时间
            ,reservationplace -- 预约作业地点
            ,approvedate -- 审批作业时间
            ,remark -- 备注
            ,actualdate -- 客户经理签到时间
            ,actualplace -- 客户经理签到地点
            ,reportstatus -- 报告状态
            ,actualdistance -- 客户经理签到地址与注册地距离
            ,situationremark -- 客户经理现场情况说明
            ,approvestatus -- 流程状态
            ,imageserialno -- 影像流水号
            ,riskmanagerid -- 风险经理id
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,riskactualdate -- 风险经理签到时间
            ,riskactualplace -- 风险经理签到地点
            ,riskactualdistance -- 风险经理签到地址与注册地距离
            ,risksituationremark -- 风险经理现场情况说明
            ,issignin -- 客户经理是否签到
            ,isrisksignin -- 风险经理是否签到
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.baserialno, o.baserialno) as baserialno -- 关联授信流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户id
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.reservationdate, o.reservationdate) as reservationdate -- 预约作业时间
    ,nvl(n.reservationplace, o.reservationplace) as reservationplace -- 预约作业地点
    ,nvl(n.approvedate, o.approvedate) as approvedate -- 审批作业时间
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.actualdate, o.actualdate) as actualdate -- 客户经理签到时间
    ,nvl(n.actualplace, o.actualplace) as actualplace -- 客户经理签到地点
    ,nvl(n.reportstatus, o.reportstatus) as reportstatus -- 报告状态
    ,nvl(n.actualdistance, o.actualdistance) as actualdistance -- 客户经理签到地址与注册地距离
    ,nvl(n.situationremark, o.situationremark) as situationremark -- 客户经理现场情况说明
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 流程状态
    ,nvl(n.imageserialno, o.imageserialno) as imageserialno -- 影像流水号
    ,nvl(n.riskmanagerid, o.riskmanagerid) as riskmanagerid -- 风险经理id
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.riskactualdate, o.riskactualdate) as riskactualdate -- 风险经理签到时间
    ,nvl(n.riskactualplace, o.riskactualplace) as riskactualplace -- 风险经理签到地点
    ,nvl(n.riskactualdistance, o.riskactualdistance) as riskactualdistance -- 风险经理签到地址与注册地距离
    ,nvl(n.risksituationremark, o.risksituationremark) as risksituationremark -- 风险经理现场情况说明
    ,nvl(n.issignin, o.issignin) as issignin -- 客户经理是否签到
    ,nvl(n.isrisksignin, o.isrisksignin) as isrisksignin -- 风险经理是否签到
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
from (select * from ${iol_schema}.icms_parallel_reservation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_parallel_reservation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.baserialno <> n.baserialno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.reservationdate <> n.reservationdate
        or o.reservationplace <> n.reservationplace
        or o.approvedate <> n.approvedate
        or o.remark <> n.remark
        or o.actualdate <> n.actualdate
        or o.actualplace <> n.actualplace
        or o.reportstatus <> n.reportstatus
        or o.actualdistance <> n.actualdistance
        or o.situationremark <> n.situationremark
        or o.approvestatus <> n.approvestatus
        or o.imageserialno <> n.imageserialno
        or o.riskmanagerid <> n.riskmanagerid
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.riskactualdate <> n.riskactualdate
        or o.riskactualplace <> n.riskactualplace
        or o.riskactualdistance <> n.riskactualdistance
        or o.risksituationremark <> n.risksituationremark
        or o.issignin <> n.issignin
        or o.isrisksignin <> n.isrisksignin
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_parallel_reservation_cl(
            serialno -- 流水号
            ,baserialno -- 关联授信流水号
            ,customerid -- 客户id
            ,customername -- 客户名称
            ,reservationdate -- 预约作业时间
            ,reservationplace -- 预约作业地点
            ,approvedate -- 审批作业时间
            ,remark -- 备注
            ,actualdate -- 客户经理签到时间
            ,actualplace -- 客户经理签到地点
            ,reportstatus -- 报告状态
            ,actualdistance -- 客户经理签到地址与注册地距离
            ,situationremark -- 客户经理现场情况说明
            ,approvestatus -- 流程状态
            ,imageserialno -- 影像流水号
            ,riskmanagerid -- 风险经理id
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,riskactualdate -- 风险经理签到时间
            ,riskactualplace -- 风险经理签到地点
            ,riskactualdistance -- 风险经理签到地址与注册地距离
            ,risksituationremark -- 风险经理现场情况说明
            ,issignin -- 客户经理是否签到
            ,isrisksignin -- 风险经理是否签到
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_parallel_reservation_op(
            serialno -- 流水号
            ,baserialno -- 关联授信流水号
            ,customerid -- 客户id
            ,customername -- 客户名称
            ,reservationdate -- 预约作业时间
            ,reservationplace -- 预约作业地点
            ,approvedate -- 审批作业时间
            ,remark -- 备注
            ,actualdate -- 客户经理签到时间
            ,actualplace -- 客户经理签到地点
            ,reportstatus -- 报告状态
            ,actualdistance -- 客户经理签到地址与注册地距离
            ,situationremark -- 客户经理现场情况说明
            ,approvestatus -- 流程状态
            ,imageserialno -- 影像流水号
            ,riskmanagerid -- 风险经理id
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,riskactualdate -- 风险经理签到时间
            ,riskactualplace -- 风险经理签到地点
            ,riskactualdistance -- 风险经理签到地址与注册地距离
            ,risksituationremark -- 风险经理现场情况说明
            ,issignin -- 客户经理是否签到
            ,isrisksignin -- 风险经理是否签到
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.baserialno -- 关联授信流水号
    ,o.customerid -- 客户id
    ,o.customername -- 客户名称
    ,o.reservationdate -- 预约作业时间
    ,o.reservationplace -- 预约作业地点
    ,o.approvedate -- 审批作业时间
    ,o.remark -- 备注
    ,o.actualdate -- 客户经理签到时间
    ,o.actualplace -- 客户经理签到地点
    ,o.reportstatus -- 报告状态
    ,o.actualdistance -- 客户经理签到地址与注册地距离
    ,o.situationremark -- 客户经理现场情况说明
    ,o.approvestatus -- 流程状态
    ,o.imageserialno -- 影像流水号
    ,o.riskmanagerid -- 风险经理id
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.riskactualdate -- 风险经理签到时间
    ,o.riskactualplace -- 风险经理签到地点
    ,o.riskactualdistance -- 风险经理签到地址与注册地距离
    ,o.risksituationremark -- 风险经理现场情况说明
    ,o.issignin -- 客户经理是否签到
    ,o.isrisksignin -- 风险经理是否签到
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
from ${iol_schema}.icms_parallel_reservation_bk o
    left join ${iol_schema}.icms_parallel_reservation_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_parallel_reservation_cl d
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
--truncate table ${iol_schema}.icms_parallel_reservation;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_parallel_reservation') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_parallel_reservation drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_parallel_reservation add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_parallel_reservation exchange partition p_${batch_date} with table ${iol_schema}.icms_parallel_reservation_cl;
alter table ${iol_schema}.icms_parallel_reservation exchange partition p_20991231 with table ${iol_schema}.icms_parallel_reservation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_parallel_reservation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_parallel_reservation_op purge;
drop table ${iol_schema}.icms_parallel_reservation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_parallel_reservation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_parallel_reservation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
