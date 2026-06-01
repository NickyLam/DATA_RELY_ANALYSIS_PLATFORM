/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_recovery_service
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
create table ${iol_schema}.icms_ap_recovery_service_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_recovery_service
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_recovery_service_op purge;
drop table ${iol_schema}.icms_ap_recovery_service_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_recovery_service_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_recovery_service where 0=1;

create table ${iol_schema}.icms_ap_recovery_service_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_recovery_service where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_recovery_service_cl(
            serviceno -- 记录编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,deleteflag -- 删除标志
            ,remark -- 备注
            ,planno -- 处置内容编号
            ,firstparty -- 甲方
            ,protocolnumber -- 协议编号
            ,signdate -- 签约日期
            ,toobject -- 签约对象
            ,updateorgid -- 更新机构
            ,fileno -- 影像平台编号
            ,programno -- 方案编号
            ,serviceprotocol -- 清收服务协议上传
            ,tmsp -- 时间戳
            ,servicematurity -- 清收服务期限
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,serviceexpenses -- 服务费用
            ,serviceinfo -- 清收服务协议主要内容
            ,inputuserid -- 登记人
            ,secondparty -- 乙方
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_recovery_service_op(
            serviceno -- 记录编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,deleteflag -- 删除标志
            ,remark -- 备注
            ,planno -- 处置内容编号
            ,firstparty -- 甲方
            ,protocolnumber -- 协议编号
            ,signdate -- 签约日期
            ,toobject -- 签约对象
            ,updateorgid -- 更新机构
            ,fileno -- 影像平台编号
            ,programno -- 方案编号
            ,serviceprotocol -- 清收服务协议上传
            ,tmsp -- 时间戳
            ,servicematurity -- 清收服务期限
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,serviceexpenses -- 服务费用
            ,serviceinfo -- 清收服务协议主要内容
            ,inputuserid -- 登记人
            ,secondparty -- 乙方
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serviceno, o.serviceno) as serviceno -- 记录编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.planno, o.planno) as planno -- 处置内容编号
    ,nvl(n.firstparty, o.firstparty) as firstparty -- 甲方
    ,nvl(n.protocolnumber, o.protocolnumber) as protocolnumber -- 协议编号
    ,nvl(n.signdate, o.signdate) as signdate -- 签约日期
    ,nvl(n.toobject, o.toobject) as toobject -- 签约对象
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.fileno, o.fileno) as fileno -- 影像平台编号
    ,nvl(n.programno, o.programno) as programno -- 方案编号
    ,nvl(n.serviceprotocol, o.serviceprotocol) as serviceprotocol -- 清收服务协议上传
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.servicematurity, o.servicematurity) as servicematurity -- 清收服务期限
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.serviceexpenses, o.serviceexpenses) as serviceexpenses -- 服务费用
    ,nvl(n.serviceinfo, o.serviceinfo) as serviceinfo -- 清收服务协议主要内容
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.secondparty, o.secondparty) as secondparty -- 乙方
    ,case when
            n.serviceno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serviceno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serviceno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_recovery_service_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_recovery_service where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serviceno = n.serviceno
where (
        o.serviceno is null
    )
    or (
        n.serviceno is null
    )
    or (
        o.inputorgid <> n.inputorgid
        or o.updatedate <> n.updatedate
        or o.deleteflag <> n.deleteflag
        or o.remark <> n.remark
        or o.planno <> n.planno
        or o.firstparty <> n.firstparty
        or o.protocolnumber <> n.protocolnumber
        or o.signdate <> n.signdate
        or o.toobject <> n.toobject
        or o.updateorgid <> n.updateorgid
        or o.fileno <> n.fileno
        or o.programno <> n.programno
        or o.serviceprotocol <> n.serviceprotocol
        or o.tmsp <> n.tmsp
        or o.servicematurity <> n.servicematurity
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.serviceexpenses <> n.serviceexpenses
        or o.serviceinfo <> n.serviceinfo
        or o.inputuserid <> n.inputuserid
        or o.secondparty <> n.secondparty
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_recovery_service_cl(
            serviceno -- 记录编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,deleteflag -- 删除标志
            ,remark -- 备注
            ,planno -- 处置内容编号
            ,firstparty -- 甲方
            ,protocolnumber -- 协议编号
            ,signdate -- 签约日期
            ,toobject -- 签约对象
            ,updateorgid -- 更新机构
            ,fileno -- 影像平台编号
            ,programno -- 方案编号
            ,serviceprotocol -- 清收服务协议上传
            ,tmsp -- 时间戳
            ,servicematurity -- 清收服务期限
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,serviceexpenses -- 服务费用
            ,serviceinfo -- 清收服务协议主要内容
            ,inputuserid -- 登记人
            ,secondparty -- 乙方
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_recovery_service_op(
            serviceno -- 记录编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,deleteflag -- 删除标志
            ,remark -- 备注
            ,planno -- 处置内容编号
            ,firstparty -- 甲方
            ,protocolnumber -- 协议编号
            ,signdate -- 签约日期
            ,toobject -- 签约对象
            ,updateorgid -- 更新机构
            ,fileno -- 影像平台编号
            ,programno -- 方案编号
            ,serviceprotocol -- 清收服务协议上传
            ,tmsp -- 时间戳
            ,servicematurity -- 清收服务期限
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,serviceexpenses -- 服务费用
            ,serviceinfo -- 清收服务协议主要内容
            ,inputuserid -- 登记人
            ,secondparty -- 乙方
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serviceno -- 记录编号
    ,o.inputorgid -- 登记机构
    ,o.updatedate -- 更新日期
    ,o.deleteflag -- 删除标志
    ,o.remark -- 备注
    ,o.planno -- 处置内容编号
    ,o.firstparty -- 甲方
    ,o.protocolnumber -- 协议编号
    ,o.signdate -- 签约日期
    ,o.toobject -- 签约对象
    ,o.updateorgid -- 更新机构
    ,o.fileno -- 影像平台编号
    ,o.programno -- 方案编号
    ,o.serviceprotocol -- 清收服务协议上传
    ,o.tmsp -- 时间戳
    ,o.servicematurity -- 清收服务期限
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.serviceexpenses -- 服务费用
    ,o.serviceinfo -- 清收服务协议主要内容
    ,o.inputuserid -- 登记人
    ,o.secondparty -- 乙方
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
from ${iol_schema}.icms_ap_recovery_service_bk o
    left join ${iol_schema}.icms_ap_recovery_service_op n
        on
            o.serviceno = n.serviceno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_recovery_service_cl d
        on
            o.serviceno = d.serviceno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_recovery_service;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_recovery_service') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_recovery_service drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_recovery_service add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_recovery_service exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_recovery_service_cl;
alter table ${iol_schema}.icms_ap_recovery_service exchange partition p_20991231 with table ${iol_schema}.icms_ap_recovery_service_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_recovery_service to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_recovery_service_op purge;
drop table ${iol_schema}.icms_ap_recovery_service_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_recovery_service_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_recovery_service',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
