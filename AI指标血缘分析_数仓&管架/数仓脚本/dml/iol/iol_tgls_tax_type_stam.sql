/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_tax_type_stam
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
create table ${iol_schema}.tgls_tax_type_stam_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_tax_type_stam
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_type_stam_op purge;
drop table ${iol_schema}.tgls_tax_type_stam_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_type_stam_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_type_stam where 0=1;

create table ${iol_schema}.tgls_tax_type_stam_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_type_stam where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_type_stam_cl(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,vatxrt -- 税率/单价
            ,begndt -- 生效日期
            ,endddt -- 失效日期
            ,smrytx -- 备注
            ,valutp -- 计价方式（0：从价，1：从量）
            ,contrst -- 合同类型
            ,precis -- 取值精度（0：元，1：角，2：分）
            ,morewy -- 取余方式（0：按精度向下取整，1：按精度向上取整）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,savedt -- 数据写入时间
            ,wtrelo -- 是否循环贷(y/n/h)h:不涉及
            ,salprd -- 可售产品(取多维里面的产品)
            ,valtyp -- 取值类型(印花税合同信息金额字段)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_type_stam_op(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,vatxrt -- 税率/单价
            ,begndt -- 生效日期
            ,endddt -- 失效日期
            ,smrytx -- 备注
            ,valutp -- 计价方式（0：从价，1：从量）
            ,contrst -- 合同类型
            ,precis -- 取值精度（0：元，1：角，2：分）
            ,morewy -- 取余方式（0：按精度向下取整，1：按精度向上取整）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,savedt -- 数据写入时间
            ,wtrelo -- 是否循环贷(y/n/h)h:不涉及
            ,salprd -- 可售产品(取多维里面的产品)
            ,valtyp -- 取值类型(印花税合同信息金额字段)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.taxscd, o.taxscd) as taxscd -- 税种代码
    ,nvl(n.deptcd, o.deptcd) as deptcd -- 机构编号
    ,nvl(n.vatxrt, o.vatxrt) as vatxrt -- 税率/单价
    ,nvl(n.begndt, o.begndt) as begndt -- 生效日期
    ,nvl(n.endddt, o.endddt) as endddt -- 失效日期
    ,nvl(n.smrytx, o.smrytx) as smrytx -- 备注
    ,nvl(n.valutp, o.valutp) as valutp -- 计价方式（0：从价，1：从量）
    ,nvl(n.contrst, o.contrst) as contrst -- 合同类型
    ,nvl(n.precis, o.precis) as precis -- 取值精度（0：元，1：角，2：分）
    ,nvl(n.morewy, o.morewy) as morewy -- 取余方式（0：按精度向下取整，1：按精度向上取整）
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 弹性域列(备用)
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 弹性域列(备用)
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 弹性域列(备用)
    ,nvl(n.savedt, o.savedt) as savedt -- 数据写入时间
    ,nvl(n.wtrelo, o.wtrelo) as wtrelo -- 是否循环贷(y/n/h)h:不涉及
    ,nvl(n.salprd, o.salprd) as salprd -- 可售产品(取多维里面的产品)
    ,nvl(n.valtyp, o.valtyp) as valtyp -- 取值类型(印花税合同信息金额字段)
    ,case when
            n.stacid is null
            and n.taxscd is null
            and n.deptcd is null
            and n.begndt is null
            and n.endddt is null
            and n.contrst is null
            and n.savedt is null
            and n.wtrelo is null
            and n.salprd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.taxscd is null
            and n.deptcd is null
            and n.begndt is null
            and n.endddt is null
            and n.contrst is null
            and n.savedt is null
            and n.wtrelo is null
            and n.salprd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.taxscd is null
            and n.deptcd is null
            and n.begndt is null
            and n.endddt is null
            and n.contrst is null
            and n.savedt is null
            and n.wtrelo is null
            and n.salprd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_tax_type_stam_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_tax_type_stam where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.taxscd = n.taxscd
            and o.deptcd = n.deptcd
            and o.begndt = n.begndt
            and o.endddt = n.endddt
            and o.contrst = n.contrst
            and o.savedt = n.savedt
            and o.wtrelo = n.wtrelo
            and o.salprd = n.salprd
where (
        o.stacid is null
        and o.taxscd is null
        and o.deptcd is null
        and o.begndt is null
        and o.endddt is null
        and o.contrst is null
        and o.savedt is null
        and o.wtrelo is null
        and o.salprd is null
    )
    or (
        n.stacid is null
        and n.taxscd is null
        and n.deptcd is null
        and n.begndt is null
        and n.endddt is null
        and n.contrst is null
        and n.savedt is null
        and n.wtrelo is null
        and n.salprd is null
    )
    or (
        o.vatxrt <> n.vatxrt
        or o.smrytx <> n.smrytx
        or o.valutp <> n.valutp
        or o.precis <> n.precis
        or o.morewy <> n.morewy
        or o.attribute1 <> n.attribute1
        or o.attribute2 <> n.attribute2
        or o.attribute3 <> n.attribute3
        or o.valtyp <> n.valtyp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_type_stam_cl(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,vatxrt -- 税率/单价
            ,begndt -- 生效日期
            ,endddt -- 失效日期
            ,smrytx -- 备注
            ,valutp -- 计价方式（0：从价，1：从量）
            ,contrst -- 合同类型
            ,precis -- 取值精度（0：元，1：角，2：分）
            ,morewy -- 取余方式（0：按精度向下取整，1：按精度向上取整）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,savedt -- 数据写入时间
            ,wtrelo -- 是否循环贷(y/n/h)h:不涉及
            ,salprd -- 可售产品(取多维里面的产品)
            ,valtyp -- 取值类型(印花税合同信息金额字段)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_type_stam_op(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,vatxrt -- 税率/单价
            ,begndt -- 生效日期
            ,endddt -- 失效日期
            ,smrytx -- 备注
            ,valutp -- 计价方式（0：从价，1：从量）
            ,contrst -- 合同类型
            ,precis -- 取值精度（0：元，1：角，2：分）
            ,morewy -- 取余方式（0：按精度向下取整，1：按精度向上取整）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,savedt -- 数据写入时间
            ,wtrelo -- 是否循环贷(y/n/h)h:不涉及
            ,salprd -- 可售产品(取多维里面的产品)
            ,valtyp -- 取值类型(印花税合同信息金额字段)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.taxscd -- 税种代码
    ,o.deptcd -- 机构编号
    ,o.vatxrt -- 税率/单价
    ,o.begndt -- 生效日期
    ,o.endddt -- 失效日期
    ,o.smrytx -- 备注
    ,o.valutp -- 计价方式（0：从价，1：从量）
    ,o.contrst -- 合同类型
    ,o.precis -- 取值精度（0：元，1：角，2：分）
    ,o.morewy -- 取余方式（0：按精度向下取整，1：按精度向上取整）
    ,o.attribute1 -- 弹性域列(备用)
    ,o.attribute2 -- 弹性域列(备用)
    ,o.attribute3 -- 弹性域列(备用)
    ,o.savedt -- 数据写入时间
    ,o.wtrelo -- 是否循环贷(y/n/h)h:不涉及
    ,o.salprd -- 可售产品(取多维里面的产品)
    ,o.valtyp -- 取值类型(印花税合同信息金额字段)
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
from ${iol_schema}.tgls_tax_type_stam_bk o
    left join ${iol_schema}.tgls_tax_type_stam_op n
        on
            o.stacid = n.stacid
            and o.taxscd = n.taxscd
            and o.deptcd = n.deptcd
            and o.begndt = n.begndt
            and o.endddt = n.endddt
            and o.contrst = n.contrst
            and o.savedt = n.savedt
            and o.wtrelo = n.wtrelo
            and o.salprd = n.salprd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_tax_type_stam_cl d
        on
            o.stacid = d.stacid
            and o.taxscd = d.taxscd
            and o.deptcd = d.deptcd
            and o.begndt = d.begndt
            and o.endddt = d.endddt
            and o.contrst = d.contrst
            and o.savedt = d.savedt
            and o.wtrelo = d.wtrelo
            and o.salprd = d.salprd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_tax_type_stam;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_tax_type_stam') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_tax_type_stam drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_tax_type_stam add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_tax_type_stam exchange partition p_${batch_date} with table ${iol_schema}.tgls_tax_type_stam_cl;
alter table ${iol_schema}.tgls_tax_type_stam exchange partition p_20991231 with table ${iol_schema}.tgls_tax_type_stam_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_tax_type_stam to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_type_stam_op purge;
drop table ${iol_schema}.tgls_tax_type_stam_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_tax_type_stam_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_tax_type_stam',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
