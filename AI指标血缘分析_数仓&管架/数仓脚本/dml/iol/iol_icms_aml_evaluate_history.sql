/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_aml_evaluate_history
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
create table ${iol_schema}.icms_aml_evaluate_history_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_aml_evaluate_history
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_aml_evaluate_history_op purge;
drop table ${iol_schema}.icms_aml_evaluate_history_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_aml_evaluate_history_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_aml_evaluate_history where 0=1;

create table ${iol_schema}.icms_aml_evaluate_history_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_aml_evaluate_history where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_aml_evaluate_history_cl(
            serialno -- 流水号
            ,objectno -- 业务流水号
            ,objecttype -- 业务类型
            ,businessstatus -- 业务状态
            ,evaluateflowserialno -- 评级结果对应的评级编号
            ,evaluateresult -- 评级风险等级
            ,evaluatereason -- 评级原因
            ,evaluateexcuse -- 评级理由
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,belongorgid -- 客户归属机构（反洗钱）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_aml_evaluate_history_op(
            serialno -- 流水号
            ,objectno -- 业务流水号
            ,objecttype -- 业务类型
            ,businessstatus -- 业务状态
            ,evaluateflowserialno -- 评级结果对应的评级编号
            ,evaluateresult -- 评级风险等级
            ,evaluatereason -- 评级原因
            ,evaluateexcuse -- 评级理由
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,belongorgid -- 客户归属机构（反洗钱）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.objectno, o.objectno) as objectno -- 业务流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 业务类型
    ,nvl(n.businessstatus, o.businessstatus) as businessstatus -- 业务状态
    ,nvl(n.evaluateflowserialno, o.evaluateflowserialno) as evaluateflowserialno -- 评级结果对应的评级编号
    ,nvl(n.evaluateresult, o.evaluateresult) as evaluateresult -- 评级风险等级
    ,nvl(n.evaluatereason, o.evaluatereason) as evaluatereason -- 评级原因
    ,nvl(n.evaluateexcuse, o.evaluateexcuse) as evaluateexcuse -- 评级理由
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 录入人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 录入机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 录入日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.belongorgid, o.belongorgid) as belongorgid -- 客户归属机构（反洗钱）
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
from (select * from ${iol_schema}.icms_aml_evaluate_history_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_aml_evaluate_history where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.businessstatus <> n.businessstatus
        or o.evaluateflowserialno <> n.evaluateflowserialno
        or o.evaluateresult <> n.evaluateresult
        or o.evaluatereason <> n.evaluatereason
        or o.evaluateexcuse <> n.evaluateexcuse
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.belongorgid <> n.belongorgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_aml_evaluate_history_cl(
            serialno -- 流水号
            ,objectno -- 业务流水号
            ,objecttype -- 业务类型
            ,businessstatus -- 业务状态
            ,evaluateflowserialno -- 评级结果对应的评级编号
            ,evaluateresult -- 评级风险等级
            ,evaluatereason -- 评级原因
            ,evaluateexcuse -- 评级理由
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,belongorgid -- 客户归属机构（反洗钱）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_aml_evaluate_history_op(
            serialno -- 流水号
            ,objectno -- 业务流水号
            ,objecttype -- 业务类型
            ,businessstatus -- 业务状态
            ,evaluateflowserialno -- 评级结果对应的评级编号
            ,evaluateresult -- 评级风险等级
            ,evaluatereason -- 评级原因
            ,evaluateexcuse -- 评级理由
            ,inputuserid -- 录入人
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,belongorgid -- 客户归属机构（反洗钱）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.objectno -- 业务流水号
    ,o.objecttype -- 业务类型
    ,o.businessstatus -- 业务状态
    ,o.evaluateflowserialno -- 评级结果对应的评级编号
    ,o.evaluateresult -- 评级风险等级
    ,o.evaluatereason -- 评级原因
    ,o.evaluateexcuse -- 评级理由
    ,o.inputuserid -- 录入人
    ,o.inputorgid -- 录入机构
    ,o.inputdate -- 录入日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.belongorgid -- 客户归属机构（反洗钱）
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
from ${iol_schema}.icms_aml_evaluate_history_bk o
    left join ${iol_schema}.icms_aml_evaluate_history_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_aml_evaluate_history_cl d
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
--truncate table ${iol_schema}.icms_aml_evaluate_history;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_aml_evaluate_history') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_aml_evaluate_history drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_aml_evaluate_history add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_aml_evaluate_history exchange partition p_${batch_date} with table ${iol_schema}.icms_aml_evaluate_history_cl;
alter table ${iol_schema}.icms_aml_evaluate_history exchange partition p_20991231 with table ${iol_schema}.icms_aml_evaluate_history_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_aml_evaluate_history to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_aml_evaluate_history_op purge;
drop table ${iol_schema}.icms_aml_evaluate_history_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_aml_evaluate_history_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_aml_evaluate_history',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
