/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_business_relative
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
create table ${iol_schema}.icms_clr_business_relative_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_business_relative
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_business_relative_op purge;
drop table ${iol_schema}.icms_clr_business_relative_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_business_relative_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_business_relative where 0=1;

create table ${iol_schema}.icms_clr_business_relative_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_business_relative where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_business_relative_cl(
            objectno -- 对象编号
            ,objecttype -- 对象类型
            ,guarantycontractno -- 担保合同号码
            ,clrid -- 押品编号
            ,status -- 状态
            ,relativetime -- 关联时间
            ,clrsortno -- 押权顺序
            ,guarantysum -- 本次担保金额
            ,guarantycurrency -- 担保币种
            ,approveno -- 批复编号
            ,productid -- 产品编号
            ,belongdept -- 业务条线
            ,guarantyrate -- 参考抵质押率
            ,actuallyrate -- 抵质押率
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,firstvalnum -- 初始评估价值流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_business_relative_op(
            objectno -- 对象编号
            ,objecttype -- 对象类型
            ,guarantycontractno -- 担保合同号码
            ,clrid -- 押品编号
            ,status -- 状态
            ,relativetime -- 关联时间
            ,clrsortno -- 押权顺序
            ,guarantysum -- 本次担保金额
            ,guarantycurrency -- 担保币种
            ,approveno -- 批复编号
            ,productid -- 产品编号
            ,belongdept -- 业务条线
            ,guarantyrate -- 参考抵质押率
            ,actuallyrate -- 抵质押率
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,firstvalnum -- 初始评估价值流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.guarantycontractno, o.guarantycontractno) as guarantycontractno -- 担保合同号码
    ,nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.relativetime, o.relativetime) as relativetime -- 关联时间
    ,nvl(n.clrsortno, o.clrsortno) as clrsortno -- 押权顺序
    ,nvl(n.guarantysum, o.guarantysum) as guarantysum -- 本次担保金额
    ,nvl(n.guarantycurrency, o.guarantycurrency) as guarantycurrency -- 担保币种
    ,nvl(n.approveno, o.approveno) as approveno -- 批复编号
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 业务条线
    ,nvl(n.guarantyrate, o.guarantyrate) as guarantyrate -- 参考抵质押率
    ,nvl(n.actuallyrate, o.actuallyrate) as actuallyrate -- 抵质押率
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,nvl(n.firstvalnum, o.firstvalnum) as firstvalnum -- 初始评估价值流水
    ,case when
            n.objectno is null
            and n.objecttype is null
            and n.guarantycontractno is null
            and n.clrid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.objectno is null
            and n.objecttype is null
            and n.guarantycontractno is null
            and n.clrid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.objectno is null
            and n.objecttype is null
            and n.guarantycontractno is null
            and n.clrid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_business_relative_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_business_relative where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.objectno = n.objectno
            and o.objecttype = n.objecttype
            and o.guarantycontractno = n.guarantycontractno
            and o.clrid = n.clrid
where (
        o.objectno is null
        and o.objecttype is null
        and o.guarantycontractno is null
        and o.clrid is null
    )
    or (
        n.objectno is null
        and n.objecttype is null
        and n.guarantycontractno is null
        and n.clrid is null
    )
    or (
        o.status <> n.status
        or o.relativetime <> n.relativetime
        or o.clrsortno <> n.clrsortno
        or o.guarantysum <> n.guarantysum
        or o.guarantycurrency <> n.guarantycurrency
        or o.approveno <> n.approveno
        or o.productid <> n.productid
        or o.belongdept <> n.belongdept
        or o.guarantyrate <> n.guarantyrate
        or o.actuallyrate <> n.actuallyrate
        or o.migtflag <> n.migtflag
        or o.firstvalnum <> n.firstvalnum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_business_relative_cl(
            objectno -- 对象编号
            ,objecttype -- 对象类型
            ,guarantycontractno -- 担保合同号码
            ,clrid -- 押品编号
            ,status -- 状态
            ,relativetime -- 关联时间
            ,clrsortno -- 押权顺序
            ,guarantysum -- 本次担保金额
            ,guarantycurrency -- 担保币种
            ,approveno -- 批复编号
            ,productid -- 产品编号
            ,belongdept -- 业务条线
            ,guarantyrate -- 参考抵质押率
            ,actuallyrate -- 抵质押率
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,firstvalnum -- 初始评估价值流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_business_relative_op(
            objectno -- 对象编号
            ,objecttype -- 对象类型
            ,guarantycontractno -- 担保合同号码
            ,clrid -- 押品编号
            ,status -- 状态
            ,relativetime -- 关联时间
            ,clrsortno -- 押权顺序
            ,guarantysum -- 本次担保金额
            ,guarantycurrency -- 担保币种
            ,approveno -- 批复编号
            ,productid -- 产品编号
            ,belongdept -- 业务条线
            ,guarantyrate -- 参考抵质押率
            ,actuallyrate -- 抵质押率
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,firstvalnum -- 初始评估价值流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.objectno -- 对象编号
    ,o.objecttype -- 对象类型
    ,o.guarantycontractno -- 担保合同号码
    ,o.clrid -- 押品编号
    ,o.status -- 状态
    ,o.relativetime -- 关联时间
    ,o.clrsortno -- 押权顺序
    ,o.guarantysum -- 本次担保金额
    ,o.guarantycurrency -- 担保币种
    ,o.approveno -- 批复编号
    ,o.productid -- 产品编号
    ,o.belongdept -- 业务条线
    ,o.guarantyrate -- 参考抵质押率
    ,o.actuallyrate -- 抵质押率
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
    ,o.firstvalnum -- 初始评估价值流水
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
from ${iol_schema}.icms_clr_business_relative_bk o
    left join ${iol_schema}.icms_clr_business_relative_op n
        on
            o.objectno = n.objectno
            and o.objecttype = n.objecttype
            and o.guarantycontractno = n.guarantycontractno
            and o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_business_relative_cl d
        on
            o.objectno = d.objectno
            and o.objecttype = d.objecttype
            and o.guarantycontractno = d.guarantycontractno
            and o.clrid = d.clrid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_business_relative;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_business_relative') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_business_relative drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_business_relative add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_business_relative exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_business_relative_cl;
alter table ${iol_schema}.icms_clr_business_relative exchange partition p_20991231 with table ${iol_schema}.icms_clr_business_relative_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_business_relative to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_business_relative_op purge;
drop table ${iol_schema}.icms_clr_business_relative_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_business_relative_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_business_relative',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
