/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wqd_risk_impawn
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
create table ${iol_schema}.icms_wqd_risk_impawn_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wqd_risk_impawn
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wqd_risk_impawn_op purge;
drop table ${iol_schema}.icms_wqd_risk_impawn_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wqd_risk_impawn_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wqd_risk_impawn where 0=1;

create table ${iol_schema}.icms_wqd_risk_impawn_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wqd_risk_impawn where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wqd_risk_impawn_cl(
            serialno -- 流水号
            ,objecttype -- 决策对象
            ,objectno -- 决策编号
            ,applyno -- 信贷申请流水号
            ,buildingtype   -- 抵押物类型
            ,buildingaddress    -- 抵押物地址
            ,finalvaluationtotal         -- 最终评估价值
            ,valuationamount -- 单个抵押物审批额度
            ,serialnumber -- 序号
            ,valuationcompany -- 评估公司名称
            ,valuationtotal -- 评估总价
            ,isfinalvaluationtotal -- 是否被引用为最终评估价值
            ,remark1 -- 备用字段1
            ,remark2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wqd_risk_impawn_op(
            serialno -- 流水号
            ,objecttype -- 决策对象
            ,objectno -- 决策编号
            ,applyno -- 信贷申请流水号
            ,buildingtype   -- 抵押物类型
            ,buildingaddress    -- 抵押物地址
            ,finalvaluationtotal         -- 最终评估价值
            ,valuationamount -- 单个抵押物审批额度
            ,serialnumber -- 序号
            ,valuationcompany -- 评估公司名称
            ,valuationtotal -- 评估总价
            ,isfinalvaluationtotal -- 是否被引用为最终评估价值
            ,remark1 -- 备用字段1
            ,remark2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 决策对象
    ,nvl(n.objectno, o.objectno) as objectno -- 决策编号
    ,nvl(n.applyno, o.applyno) as applyno -- 信贷申请流水号
    ,nvl(n.buildingtype  , o.buildingtype  ) as buildingtype   -- 抵押物类型
    ,nvl(n.buildingaddress   , o.buildingaddress   ) as buildingaddress    -- 抵押物地址
    ,nvl(n.finalvaluationtotal        , o.finalvaluationtotal        ) as finalvaluationtotal         -- 最终评估价值
    ,nvl(n.valuationamount, o.valuationamount) as valuationamount -- 单个抵押物审批额度
    ,nvl(n.serialnumber, o.serialnumber) as serialnumber -- 序号
    ,nvl(n.valuationcompany, o.valuationcompany) as valuationcompany -- 评估公司名称
    ,nvl(n.valuationtotal, o.valuationtotal) as valuationtotal -- 评估总价
    ,nvl(n.isfinalvaluationtotal, o.isfinalvaluationtotal) as isfinalvaluationtotal -- 是否被引用为最终评估价值
    ,nvl(n.remark1, o.remark1) as remark1 -- 备用字段1
    ,nvl(n.remark2, o.remark2) as remark2 -- 备用字段2
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
from (select * from ${iol_schema}.icms_wqd_risk_impawn_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wqd_risk_impawn where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.objecttype <> n.objecttype
        or o.objectno <> n.objectno
        or o.applyno <> n.applyno
        or o.buildingtype   <> n.buildingtype  
        or o.buildingaddress    <> n.buildingaddress   
        or o.finalvaluationtotal         <> n.finalvaluationtotal        
        or o.valuationamount <> n.valuationamount
        or o.serialnumber <> n.serialnumber
        or o.valuationcompany <> n.valuationcompany
        or o.valuationtotal <> n.valuationtotal
        or o.isfinalvaluationtotal <> n.isfinalvaluationtotal
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wqd_risk_impawn_cl(
            serialno -- 流水号
            ,objecttype -- 决策对象
            ,objectno -- 决策编号
            ,applyno -- 信贷申请流水号
            ,buildingtype   -- 抵押物类型
            ,buildingaddress    -- 抵押物地址
            ,finalvaluationtotal         -- 最终评估价值
            ,valuationamount -- 单个抵押物审批额度
            ,serialnumber -- 序号
            ,valuationcompany -- 评估公司名称
            ,valuationtotal -- 评估总价
            ,isfinalvaluationtotal -- 是否被引用为最终评估价值
            ,remark1 -- 备用字段1
            ,remark2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wqd_risk_impawn_op(
            serialno -- 流水号
            ,objecttype -- 决策对象
            ,objectno -- 决策编号
            ,applyno -- 信贷申请流水号
            ,buildingtype   -- 抵押物类型
            ,buildingaddress    -- 抵押物地址
            ,finalvaluationtotal         -- 最终评估价值
            ,valuationamount -- 单个抵押物审批额度
            ,serialnumber -- 序号
            ,valuationcompany -- 评估公司名称
            ,valuationtotal -- 评估总价
            ,isfinalvaluationtotal -- 是否被引用为最终评估价值
            ,remark1 -- 备用字段1
            ,remark2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.objecttype -- 决策对象
    ,o.objectno -- 决策编号
    ,o.applyno -- 信贷申请流水号
    ,o.buildingtype   -- 抵押物类型
    ,o.buildingaddress    -- 抵押物地址
    ,o.finalvaluationtotal         -- 最终评估价值
    ,o.valuationamount -- 单个抵押物审批额度
    ,o.serialnumber -- 序号
    ,o.valuationcompany -- 评估公司名称
    ,o.valuationtotal -- 评估总价
    ,o.isfinalvaluationtotal -- 是否被引用为最终评估价值
    ,o.remark1 -- 备用字段1
    ,o.remark2 -- 备用字段2
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
from ${iol_schema}.icms_wqd_risk_impawn_bk o
    left join ${iol_schema}.icms_wqd_risk_impawn_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wqd_risk_impawn_cl d
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
--truncate table ${iol_schema}.icms_wqd_risk_impawn;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wqd_risk_impawn') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wqd_risk_impawn drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wqd_risk_impawn add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wqd_risk_impawn exchange partition p_${batch_date} with table ${iol_schema}.icms_wqd_risk_impawn_cl;
alter table ${iol_schema}.icms_wqd_risk_impawn exchange partition p_20991231 with table ${iol_schema}.icms_wqd_risk_impawn_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wqd_risk_impawn to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wqd_risk_impawn_op purge;
drop table ${iol_schema}.icms_wqd_risk_impawn_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wqd_risk_impawn_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wqd_risk_impawn',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
