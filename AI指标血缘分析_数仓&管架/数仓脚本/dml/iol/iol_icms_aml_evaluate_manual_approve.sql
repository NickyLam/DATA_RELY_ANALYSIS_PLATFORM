/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_aml_evaluate_manual_approve
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
create table ${iol_schema}.icms_aml_evaluate_manual_approve_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_aml_evaluate_manual_approve
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_aml_evaluate_manual_approve_op purge;
drop table ${iol_schema}.icms_aml_evaluate_manual_approve_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_aml_evaluate_manual_approve_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_aml_evaluate_manual_approve where 0=1;

create table ${iol_schema}.icms_aml_evaluate_manual_approve_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_aml_evaluate_manual_approve where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_aml_evaluate_manual_approve_cl(
            serialno -- 流水号
            ,objectno -- 业务流水号
            ,objecttype -- 业务类型
            ,flowtaskserialno -- 业务申请阶段
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,manualapprovaldescribe -- 人工审批说明
            ,processstatus -- 处理状态
            ,processreason -- 处理原因
            ,addsource -- 新增方式
            ,completeflag -- 信息完成状态
            ,approvestatus -- 审批状态
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_aml_evaluate_manual_approve_op(
            serialno -- 流水号
            ,objectno -- 业务流水号
            ,objecttype -- 业务类型
            ,flowtaskserialno -- 业务申请阶段
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,manualapprovaldescribe -- 人工审批说明
            ,processstatus -- 处理状态
            ,processreason -- 处理原因
            ,addsource -- 新增方式
            ,completeflag -- 信息完成状态
            ,approvestatus -- 审批状态
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.objectno, o.objectno) as objectno -- 业务流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 业务类型
    ,nvl(n.flowtaskserialno, o.flowtaskserialno) as flowtaskserialno -- 业务申请阶段
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.manualapprovaldescribe, o.manualapprovaldescribe) as manualapprovaldescribe -- 人工审批说明
    ,nvl(n.processstatus, o.processstatus) as processstatus -- 处理状态
    ,nvl(n.processreason, o.processreason) as processreason -- 处理原因
    ,nvl(n.addsource, o.addsource) as addsource -- 新增方式
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 信息完成状态
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 录入人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 录入机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 录入日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
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
from (select * from ${iol_schema}.icms_aml_evaluate_manual_approve_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_aml_evaluate_manual_approve where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.objectno <> n.objectno
        or o.objecttype <> n.objecttype
        or o.flowtaskserialno <> n.flowtaskserialno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.productid <> n.productid
        or o.manualapprovaldescribe <> n.manualapprovaldescribe
        or o.processstatus <> n.processstatus
        or o.processreason <> n.processreason
        or o.addsource <> n.addsource
        or o.completeflag <> n.completeflag
        or o.approvestatus <> n.approvestatus
        or o.operateuserid <> n.operateuserid
        or o.operateorgid <> n.operateorgid
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_aml_evaluate_manual_approve_cl(
            serialno -- 流水号
            ,objectno -- 业务流水号
            ,objecttype -- 业务类型
            ,flowtaskserialno -- 业务申请阶段
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,manualapprovaldescribe -- 人工审批说明
            ,processstatus -- 处理状态
            ,processreason -- 处理原因
            ,addsource -- 新增方式
            ,completeflag -- 信息完成状态
            ,approvestatus -- 审批状态
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_aml_evaluate_manual_approve_op(
            serialno -- 流水号
            ,objectno -- 业务流水号
            ,objecttype -- 业务类型
            ,flowtaskserialno -- 业务申请阶段
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,manualapprovaldescribe -- 人工审批说明
            ,processstatus -- 处理状态
            ,processreason -- 处理原因
            ,addsource -- 新增方式
            ,completeflag -- 信息完成状态
            ,approvestatus -- 审批状态
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.objectno -- 业务流水号
    ,o.objecttype -- 业务类型
    ,o.flowtaskserialno -- 业务申请阶段
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.productid -- 产品编号
    ,o.manualapprovaldescribe -- 人工审批说明
    ,o.processstatus -- 处理状态
    ,o.processreason -- 处理原因
    ,o.addsource -- 新增方式
    ,o.completeflag -- 信息完成状态
    ,o.approvestatus -- 审批状态
    ,o.operateuserid -- 经办人
    ,o.operateorgid -- 经办机构
    ,o.inputuserid -- 录入人
    ,o.inputorgid -- 录入机构
    ,o.inputdate -- 录入日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
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
from ${iol_schema}.icms_aml_evaluate_manual_approve_bk o
    left join ${iol_schema}.icms_aml_evaluate_manual_approve_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_aml_evaluate_manual_approve_cl d
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
--truncate table ${iol_schema}.icms_aml_evaluate_manual_approve;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_aml_evaluate_manual_approve') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_aml_evaluate_manual_approve drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_aml_evaluate_manual_approve add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_aml_evaluate_manual_approve exchange partition p_${batch_date} with table ${iol_schema}.icms_aml_evaluate_manual_approve_cl;
alter table ${iol_schema}.icms_aml_evaluate_manual_approve exchange partition p_20991231 with table ${iol_schema}.icms_aml_evaluate_manual_approve_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_aml_evaluate_manual_approve to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_aml_evaluate_manual_approve_op purge;
drop table ${iol_schema}.icms_aml_evaluate_manual_approve_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_aml_evaluate_manual_approve_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_aml_evaluate_manual_approve',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
