/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_handover
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
create table ${iol_schema}.icms_customer_handover_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_handover
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_handover_op purge;
drop table ${iol_schema}.icms_customer_handover_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_handover_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_handover where 0=1;

create table ${iol_schema}.icms_customer_handover_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_handover where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_handover_cl(
            serialno -- 流水号
            ,transferrange -- 移交范围，01-全部客户，02-部分客户
            ,updateuserid -- 更新人编号
            ,istransfer -- 是否可移交
            ,operateorgid -- 操作人机构编号
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新时间
            ,operateuserid -- 操作人编号
            ,neworgid -- 新客户经理机构编号
            ,transfercomment -- 移交说明
            ,updateorgid -- 更新机构编号
            ,issucc -- 是否成功
            ,batchno -- 移交批次号（合作商移交申请流水号）
            ,inputdate -- 登记时间
            ,businesstype -- 移交业务类型
            ,transferrelative -- 移交机构关系，01-机构内移交，02-跨机构移交
            ,olduserid -- 旧客户经理编号
            ,inputorgid -- 登记机构编号
            ,businessno -- 业务流水号
            ,operatedate -- 操作时间
            ,newuserid -- 新客户经理编号
            ,oldorgid -- 旧客户机构编号
            ,operatetype -- 移交类型
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_handover_op(
            serialno -- 流水号
            ,transferrange -- 移交范围，01-全部客户，02-部分客户
            ,updateuserid -- 更新人编号
            ,istransfer -- 是否可移交
            ,operateorgid -- 操作人机构编号
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新时间
            ,operateuserid -- 操作人编号
            ,neworgid -- 新客户经理机构编号
            ,transfercomment -- 移交说明
            ,updateorgid -- 更新机构编号
            ,issucc -- 是否成功
            ,batchno -- 移交批次号（合作商移交申请流水号）
            ,inputdate -- 登记时间
            ,businesstype -- 移交业务类型
            ,transferrelative -- 移交机构关系，01-机构内移交，02-跨机构移交
            ,olduserid -- 旧客户经理编号
            ,inputorgid -- 登记机构编号
            ,businessno -- 业务流水号
            ,operatedate -- 操作时间
            ,newuserid -- 新客户经理编号
            ,oldorgid -- 旧客户机构编号
            ,operatetype -- 移交类型
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.transferrange, o.transferrange) as transferrange -- 移交范围，01-全部客户，02-部分客户
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.istransfer, o.istransfer) as istransfer -- 是否可移交
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 操作人机构编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 操作人编号
    ,nvl(n.neworgid, o.neworgid) as neworgid -- 新客户经理机构编号
    ,nvl(n.transfercomment, o.transfercomment) as transfercomment -- 移交说明
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.issucc, o.issucc) as issucc -- 是否成功
    ,nvl(n.batchno, o.batchno) as batchno -- 移交批次号（合作商移交申请流水号）
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 移交业务类型
    ,nvl(n.transferrelative, o.transferrelative) as transferrelative -- 移交机构关系，01-机构内移交，02-跨机构移交
    ,nvl(n.olduserid, o.olduserid) as olduserid -- 旧客户经理编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.businessno, o.businessno) as businessno -- 业务流水号
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 操作时间
    ,nvl(n.newuserid, o.newuserid) as newuserid -- 新客户经理编号
    ,nvl(n.oldorgid, o.oldorgid) as oldorgid -- 旧客户机构编号
    ,nvl(n.operatetype, o.operatetype) as operatetype -- 移交类型
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志
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
from (select * from ${iol_schema}.icms_customer_handover_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_handover where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.transferrange <> n.transferrange
        or o.updateuserid <> n.updateuserid
        or o.istransfer <> n.istransfer
        or o.operateorgid <> n.operateorgid
        or o.inputuserid <> n.inputuserid
        or o.updatedate <> n.updatedate
        or o.operateuserid <> n.operateuserid
        or o.neworgid <> n.neworgid
        or o.transfercomment <> n.transfercomment
        or o.updateorgid <> n.updateorgid
        or o.issucc <> n.issucc
        or o.batchno <> n.batchno
        or o.inputdate <> n.inputdate
        or o.businesstype <> n.businesstype
        or o.transferrelative <> n.transferrelative
        or o.olduserid <> n.olduserid
        or o.inputorgid <> n.inputorgid
        or o.businessno <> n.businessno
        or o.operatedate <> n.operatedate
        or o.newuserid <> n.newuserid
        or o.oldorgid <> n.oldorgid
        or o.operatetype <> n.operatetype
        or o.customerid <> n.customerid
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_handover_cl(
            serialno -- 流水号
            ,transferrange -- 移交范围，01-全部客户，02-部分客户
            ,updateuserid -- 更新人编号
            ,istransfer -- 是否可移交
            ,operateorgid -- 操作人机构编号
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新时间
            ,operateuserid -- 操作人编号
            ,neworgid -- 新客户经理机构编号
            ,transfercomment -- 移交说明
            ,updateorgid -- 更新机构编号
            ,issucc -- 是否成功
            ,batchno -- 移交批次号（合作商移交申请流水号）
            ,inputdate -- 登记时间
            ,businesstype -- 移交业务类型
            ,transferrelative -- 移交机构关系，01-机构内移交，02-跨机构移交
            ,olduserid -- 旧客户经理编号
            ,inputorgid -- 登记机构编号
            ,businessno -- 业务流水号
            ,operatedate -- 操作时间
            ,newuserid -- 新客户经理编号
            ,oldorgid -- 旧客户机构编号
            ,operatetype -- 移交类型
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_handover_op(
            serialno -- 流水号
            ,transferrange -- 移交范围，01-全部客户，02-部分客户
            ,updateuserid -- 更新人编号
            ,istransfer -- 是否可移交
            ,operateorgid -- 操作人机构编号
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新时间
            ,operateuserid -- 操作人编号
            ,neworgid -- 新客户经理机构编号
            ,transfercomment -- 移交说明
            ,updateorgid -- 更新机构编号
            ,issucc -- 是否成功
            ,batchno -- 移交批次号（合作商移交申请流水号）
            ,inputdate -- 登记时间
            ,businesstype -- 移交业务类型
            ,transferrelative -- 移交机构关系，01-机构内移交，02-跨机构移交
            ,olduserid -- 旧客户经理编号
            ,inputorgid -- 登记机构编号
            ,businessno -- 业务流水号
            ,operatedate -- 操作时间
            ,newuserid -- 新客户经理编号
            ,oldorgid -- 旧客户机构编号
            ,operatetype -- 移交类型
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.transferrange -- 移交范围，01-全部客户，02-部分客户
    ,o.updateuserid -- 更新人编号
    ,o.istransfer -- 是否可移交
    ,o.operateorgid -- 操作人机构编号
    ,o.inputuserid -- 登记人编号
    ,o.updatedate -- 更新时间
    ,o.operateuserid -- 操作人编号
    ,o.neworgid -- 新客户经理机构编号
    ,o.transfercomment -- 移交说明
    ,o.updateorgid -- 更新机构编号
    ,o.issucc -- 是否成功
    ,o.batchno -- 移交批次号（合作商移交申请流水号）
    ,o.inputdate -- 登记时间
    ,o.businesstype -- 移交业务类型
    ,o.transferrelative -- 移交机构关系，01-机构内移交，02-跨机构移交
    ,o.olduserid -- 旧客户经理编号
    ,o.inputorgid -- 登记机构编号
    ,o.businessno -- 业务流水号
    ,o.operatedate -- 操作时间
    ,o.newuserid -- 新客户经理编号
    ,o.oldorgid -- 旧客户机构编号
    ,o.operatetype -- 移交类型
    ,o.customerid -- 客户编号
    ,o.migtflag -- 迁移标志
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
from ${iol_schema}.icms_customer_handover_bk o
    left join ${iol_schema}.icms_customer_handover_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_handover_cl d
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
--truncate table ${iol_schema}.icms_customer_handover;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_handover') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_handover drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_handover add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_handover exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_handover_cl;
alter table ${iol_schema}.icms_customer_handover exchange partition p_20991231 with table ${iol_schema}.icms_customer_handover_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_handover to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_handover_op purge;
drop table ${iol_schema}.icms_customer_handover_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_handover_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_handover',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
