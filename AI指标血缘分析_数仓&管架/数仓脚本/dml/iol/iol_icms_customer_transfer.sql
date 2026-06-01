/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_transfer
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
create table ${iol_schema}.icms_customer_transfer_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_transfer
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_transfer_op purge;
drop table ${iol_schema}.icms_customer_transfer_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_transfer_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_transfer where 0=1;

create table ${iol_schema}.icms_customer_transfer_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_transfer where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_transfer_cl(
            serialno -- 流水号
            ,affirmorgid -- 确认机构
            ,operatetype -- 操作类型
            ,customerid -- 客户编号
            ,refusedate -- 拒绝接收日期
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,righttype -- 权限类型
            ,affirmdate -- 确认日期
            ,transfertype -- 转让状态
            ,updateorgid -- 更新机构
            ,affirmuserid -- 确认人
            ,remark -- 备注
            ,unoperatetype -- 相反操作类型
            ,inputorgid -- 登记机构
            ,receiveuserid -- 接受用户号
            ,receiveorgid -- 接受用户所属机构
            ,afrightflag -- 业务管户权转移标志
            ,maintaintime -- 维护权期限
            ,updateuserid -- 更新人
            ,inputdate -- 登记日期
            ,inputuserid -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_transfer_op(
            serialno -- 流水号
            ,affirmorgid -- 确认机构
            ,operatetype -- 操作类型
            ,customerid -- 客户编号
            ,refusedate -- 拒绝接收日期
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,righttype -- 权限类型
            ,affirmdate -- 确认日期
            ,transfertype -- 转让状态
            ,updateorgid -- 更新机构
            ,affirmuserid -- 确认人
            ,remark -- 备注
            ,unoperatetype -- 相反操作类型
            ,inputorgid -- 登记机构
            ,receiveuserid -- 接受用户号
            ,receiveorgid -- 接受用户所属机构
            ,afrightflag -- 业务管户权转移标志
            ,maintaintime -- 维护权期限
            ,updateuserid -- 更新人
            ,inputdate -- 登记日期
            ,inputuserid -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.affirmorgid, o.affirmorgid) as affirmorgid -- 确认机构
    ,nvl(n.operatetype, o.operatetype) as operatetype -- 操作类型
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.refusedate, o.refusedate) as refusedate -- 拒绝接收日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.righttype, o.righttype) as righttype -- 权限类型
    ,nvl(n.affirmdate, o.affirmdate) as affirmdate -- 确认日期
    ,nvl(n.transfertype, o.transfertype) as transfertype -- 转让状态
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.affirmuserid, o.affirmuserid) as affirmuserid -- 确认人
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.unoperatetype, o.unoperatetype) as unoperatetype -- 相反操作类型
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.receiveuserid, o.receiveuserid) as receiveuserid -- 接受用户号
    ,nvl(n.receiveorgid, o.receiveorgid) as receiveorgid -- 接受用户所属机构
    ,nvl(n.afrightflag, o.afrightflag) as afrightflag -- 业务管户权转移标志
    ,nvl(n.maintaintime, o.maintaintime) as maintaintime -- 维护权期限
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
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
from (select * from ${iol_schema}.icms_customer_transfer_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_transfer where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.affirmorgid <> n.affirmorgid
        or o.operatetype <> n.operatetype
        or o.customerid <> n.customerid
        or o.refusedate <> n.refusedate
        or o.updatedate <> n.updatedate
        or o.corporgid <> n.corporgid
        or o.righttype <> n.righttype
        or o.affirmdate <> n.affirmdate
        or o.transfertype <> n.transfertype
        or o.updateorgid <> n.updateorgid
        or o.affirmuserid <> n.affirmuserid
        or o.remark <> n.remark
        or o.unoperatetype <> n.unoperatetype
        or o.inputorgid <> n.inputorgid
        or o.receiveuserid <> n.receiveuserid
        or o.receiveorgid <> n.receiveorgid
        or o.afrightflag <> n.afrightflag
        or o.maintaintime <> n.maintaintime
        or o.updateuserid <> n.updateuserid
        or o.inputdate <> n.inputdate
        or o.inputuserid <> n.inputuserid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_transfer_cl(
            serialno -- 流水号
            ,affirmorgid -- 确认机构
            ,operatetype -- 操作类型
            ,customerid -- 客户编号
            ,refusedate -- 拒绝接收日期
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,righttype -- 权限类型
            ,affirmdate -- 确认日期
            ,transfertype -- 转让状态
            ,updateorgid -- 更新机构
            ,affirmuserid -- 确认人
            ,remark -- 备注
            ,unoperatetype -- 相反操作类型
            ,inputorgid -- 登记机构
            ,receiveuserid -- 接受用户号
            ,receiveorgid -- 接受用户所属机构
            ,afrightflag -- 业务管户权转移标志
            ,maintaintime -- 维护权期限
            ,updateuserid -- 更新人
            ,inputdate -- 登记日期
            ,inputuserid -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_transfer_op(
            serialno -- 流水号
            ,affirmorgid -- 确认机构
            ,operatetype -- 操作类型
            ,customerid -- 客户编号
            ,refusedate -- 拒绝接收日期
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,righttype -- 权限类型
            ,affirmdate -- 确认日期
            ,transfertype -- 转让状态
            ,updateorgid -- 更新机构
            ,affirmuserid -- 确认人
            ,remark -- 备注
            ,unoperatetype -- 相反操作类型
            ,inputorgid -- 登记机构
            ,receiveuserid -- 接受用户号
            ,receiveorgid -- 接受用户所属机构
            ,afrightflag -- 业务管户权转移标志
            ,maintaintime -- 维护权期限
            ,updateuserid -- 更新人
            ,inputdate -- 登记日期
            ,inputuserid -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.affirmorgid -- 确认机构
    ,o.operatetype -- 操作类型
    ,o.customerid -- 客户编号
    ,o.refusedate -- 拒绝接收日期
    ,o.updatedate -- 更新日期
    ,o.corporgid -- 法人机构编号
    ,o.righttype -- 权限类型
    ,o.affirmdate -- 确认日期
    ,o.transfertype -- 转让状态
    ,o.updateorgid -- 更新机构
    ,o.affirmuserid -- 确认人
    ,o.remark -- 备注
    ,o.unoperatetype -- 相反操作类型
    ,o.inputorgid -- 登记机构
    ,o.receiveuserid -- 接受用户号
    ,o.receiveorgid -- 接受用户所属机构
    ,o.afrightflag -- 业务管户权转移标志
    ,o.maintaintime -- 维护权期限
    ,o.updateuserid -- 更新人
    ,o.inputdate -- 登记日期
    ,o.inputuserid -- 登记人
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
from ${iol_schema}.icms_customer_transfer_bk o
    left join ${iol_schema}.icms_customer_transfer_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_transfer_cl d
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
--truncate table ${iol_schema}.icms_customer_transfer;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_transfer') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_transfer drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_transfer add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_transfer exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_transfer_cl;
alter table ${iol_schema}.icms_customer_transfer exchange partition p_20991231 with table ${iol_schema}.icms_customer_transfer_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_transfer to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_transfer_op purge;
drop table ${iol_schema}.icms_customer_transfer_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_transfer_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_transfer',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
