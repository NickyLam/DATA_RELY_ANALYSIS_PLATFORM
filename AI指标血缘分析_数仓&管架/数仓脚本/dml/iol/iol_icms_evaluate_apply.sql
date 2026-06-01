/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_evaluate_apply
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
create table ${iol_schema}.icms_evaluate_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_evaluate_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_evaluate_apply_op purge;
drop table ${iol_schema}.icms_evaluate_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_evaluate_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_evaluate_apply where 0=1;

create table ${iol_schema}.icms_evaluate_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_evaluate_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_evaluate_apply_cl(
            serialno -- 流水号
            ,evaluateresult2 -- 分行评级结果
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,taskno -- 内评流水号
            ,raterisklevel -- 内评客户评级
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,havescorecard -- 是否有打分卡
            ,inputdate -- 登记日期
            ,evaluatetype -- 评级类型
            ,customername -- 客户名
            ,evaluateresult1 -- 支行评级结果
            ,nrrstatus -- 内评评级状态
            ,evaluateresult3 -- 总行评级结果
            ,ratelimitamt -- 内评限额
            ,isnrrapply -- 授信批复内评评级
            ,ratebegindate -- 评级核定日
            ,modeltype -- 模型类型
            ,attribute1 -- 属性一
            ,updatetime -- 更新时间
            ,isnewcus -- 是否新客户
            ,attribute3 -- 属性三
            ,relobjectno -- 关联对象号
            ,attribute2 -- 属性二
            ,rateenddate -- 评级到期日
            ,customerid -- 客户号
            ,remark -- 备注
            ,effectflag -- 生效标志
            ,relobjecttype -- 关联对象类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_evaluate_apply_op(
            serialno -- 流水号
            ,evaluateresult2 -- 分行评级结果
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,taskno -- 内评流水号
            ,raterisklevel -- 内评客户评级
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,havescorecard -- 是否有打分卡
            ,inputdate -- 登记日期
            ,evaluatetype -- 评级类型
            ,customername -- 客户名
            ,evaluateresult1 -- 支行评级结果
            ,nrrstatus -- 内评评级状态
            ,evaluateresult3 -- 总行评级结果
            ,ratelimitamt -- 内评限额
            ,isnrrapply -- 授信批复内评评级
            ,ratebegindate -- 评级核定日
            ,modeltype -- 模型类型
            ,attribute1 -- 属性一
            ,updatetime -- 更新时间
            ,isnewcus -- 是否新客户
            ,attribute3 -- 属性三
            ,relobjectno -- 关联对象号
            ,attribute2 -- 属性二
            ,rateenddate -- 评级到期日
            ,customerid -- 客户号
            ,remark -- 备注
            ,effectflag -- 生效标志
            ,relobjecttype -- 关联对象类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.evaluateresult2, o.evaluateresult2) as evaluateresult2 -- 分行评级结果
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.taskno, o.taskno) as taskno -- 内评流水号
    ,nvl(n.raterisklevel, o.raterisklevel) as raterisklevel -- 内评客户评级
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.havescorecard, o.havescorecard) as havescorecard -- 是否有打分卡
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.evaluatetype, o.evaluatetype) as evaluatetype -- 评级类型
    ,nvl(n.customername, o.customername) as customername -- 客户名
    ,nvl(n.evaluateresult1, o.evaluateresult1) as evaluateresult1 -- 支行评级结果
    ,nvl(n.nrrstatus, o.nrrstatus) as nrrstatus -- 内评评级状态
    ,nvl(n.evaluateresult3, o.evaluateresult3) as evaluateresult3 -- 总行评级结果
    ,nvl(n.ratelimitamt, o.ratelimitamt) as ratelimitamt -- 内评限额
    ,nvl(n.isnrrapply, o.isnrrapply) as isnrrapply -- 授信批复内评评级
    ,nvl(n.ratebegindate, o.ratebegindate) as ratebegindate -- 评级核定日
    ,nvl(n.modeltype, o.modeltype) as modeltype -- 模型类型
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 属性一
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.isnewcus, o.isnewcus) as isnewcus -- 是否新客户
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 属性三
    ,nvl(n.relobjectno, o.relobjectno) as relobjectno -- 关联对象号
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 属性二
    ,nvl(n.rateenddate, o.rateenddate) as rateenddate -- 评级到期日
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.effectflag, o.effectflag) as effectflag -- 生效标志
    ,nvl(n.relobjecttype, o.relobjecttype) as relobjecttype -- 关联对象类型
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
from (select * from ${iol_schema}.icms_evaluate_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_evaluate_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.evaluateresult2 <> n.evaluateresult2
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.taskno <> n.taskno
        or o.raterisklevel <> n.raterisklevel
        or o.migtflag <> n.migtflag
        or o.havescorecard <> n.havescorecard
        or o.inputdate <> n.inputdate
        or o.evaluatetype <> n.evaluatetype
        or o.customername <> n.customername
        or o.evaluateresult1 <> n.evaluateresult1
        or o.nrrstatus <> n.nrrstatus
        or o.evaluateresult3 <> n.evaluateresult3
        or o.ratelimitamt <> n.ratelimitamt
        or o.isnrrapply <> n.isnrrapply
        or o.ratebegindate <> n.ratebegindate
        or o.modeltype <> n.modeltype
        or o.attribute1 <> n.attribute1
        or o.updatetime <> n.updatetime
        or o.isnewcus <> n.isnewcus
        or o.attribute3 <> n.attribute3
        or o.relobjectno <> n.relobjectno
        or o.attribute2 <> n.attribute2
        or o.rateenddate <> n.rateenddate
        or o.customerid <> n.customerid
        or o.remark <> n.remark
        or o.effectflag <> n.effectflag
        or o.relobjecttype <> n.relobjecttype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_evaluate_apply_cl(
            serialno -- 流水号
            ,evaluateresult2 -- 分行评级结果
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,taskno -- 内评流水号
            ,raterisklevel -- 内评客户评级
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,havescorecard -- 是否有打分卡
            ,inputdate -- 登记日期
            ,evaluatetype -- 评级类型
            ,customername -- 客户名
            ,evaluateresult1 -- 支行评级结果
            ,nrrstatus -- 内评评级状态
            ,evaluateresult3 -- 总行评级结果
            ,ratelimitamt -- 内评限额
            ,isnrrapply -- 授信批复内评评级
            ,ratebegindate -- 评级核定日
            ,modeltype -- 模型类型
            ,attribute1 -- 属性一
            ,updatetime -- 更新时间
            ,isnewcus -- 是否新客户
            ,attribute3 -- 属性三
            ,relobjectno -- 关联对象号
            ,attribute2 -- 属性二
            ,rateenddate -- 评级到期日
            ,customerid -- 客户号
            ,remark -- 备注
            ,effectflag -- 生效标志
            ,relobjecttype -- 关联对象类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_evaluate_apply_op(
            serialno -- 流水号
            ,evaluateresult2 -- 分行评级结果
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,taskno -- 内评流水号
            ,raterisklevel -- 内评客户评级
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,havescorecard -- 是否有打分卡
            ,inputdate -- 登记日期
            ,evaluatetype -- 评级类型
            ,customername -- 客户名
            ,evaluateresult1 -- 支行评级结果
            ,nrrstatus -- 内评评级状态
            ,evaluateresult3 -- 总行评级结果
            ,ratelimitamt -- 内评限额
            ,isnrrapply -- 授信批复内评评级
            ,ratebegindate -- 评级核定日
            ,modeltype -- 模型类型
            ,attribute1 -- 属性一
            ,updatetime -- 更新时间
            ,isnewcus -- 是否新客户
            ,attribute3 -- 属性三
            ,relobjectno -- 关联对象号
            ,attribute2 -- 属性二
            ,rateenddate -- 评级到期日
            ,customerid -- 客户号
            ,remark -- 备注
            ,effectflag -- 生效标志
            ,relobjecttype -- 关联对象类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.evaluateresult2 -- 分行评级结果
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.taskno -- 内评流水号
    ,o.raterisklevel -- 内评客户评级
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.havescorecard -- 是否有打分卡
    ,o.inputdate -- 登记日期
    ,o.evaluatetype -- 评级类型
    ,o.customername -- 客户名
    ,o.evaluateresult1 -- 支行评级结果
    ,o.nrrstatus -- 内评评级状态
    ,o.evaluateresult3 -- 总行评级结果
    ,o.ratelimitamt -- 内评限额
    ,o.isnrrapply -- 授信批复内评评级
    ,o.ratebegindate -- 评级核定日
    ,o.modeltype -- 模型类型
    ,o.attribute1 -- 属性一
    ,o.updatetime -- 更新时间
    ,o.isnewcus -- 是否新客户
    ,o.attribute3 -- 属性三
    ,o.relobjectno -- 关联对象号
    ,o.attribute2 -- 属性二
    ,o.rateenddate -- 评级到期日
    ,o.customerid -- 客户号
    ,o.remark -- 备注
    ,o.effectflag -- 生效标志
    ,o.relobjecttype -- 关联对象类型
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
from ${iol_schema}.icms_evaluate_apply_bk o
    left join ${iol_schema}.icms_evaluate_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_evaluate_apply_cl d
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
--truncate table ${iol_schema}.icms_evaluate_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_evaluate_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_evaluate_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_evaluate_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_evaluate_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_evaluate_apply_cl;
alter table ${iol_schema}.icms_evaluate_apply exchange partition p_20991231 with table ${iol_schema}.icms_evaluate_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_evaluate_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_evaluate_apply_op purge;
drop table ${iol_schema}.icms_evaluate_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_evaluate_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_evaluate_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
