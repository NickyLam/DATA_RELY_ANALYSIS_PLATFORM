/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_yp_guardsitributeforjour
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
create table ${iol_schema}.mims_yp_guardsitributeforjour_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_yp_guardsitributeforjour
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_guardsitributeforjour_op purge;
drop table ${iol_schema}.mims_yp_guardsitributeforjour_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_guardsitributeforjour_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_guardsitributeforjour where 0=1;

create table ${iol_schema}.mims_yp_guardsitributeforjour_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_guardsitributeforjour where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_guardsitributeforjour_cl(
            sccode -- 押品编号
            ,contractno -- 合同号
            ,balance -- 合同余额
            ,distvalue -- 贷款分配价值
            ,contguartype -- 合同主担保方式
            ,guartype -- 押品类型
            ,credittype -- 业务品种
            ,barsign -- 条线
            ,interindustry -- 行业
            ,custscale -- 规模
            ,reporttype -- 表内表外标识
            ,deptcode -- 所属机构
            ,fiveclass -- 五级分类
            ,credno -- 借据号
            ,bal -- 借据余额
            ,confmamt -- 分配我行确认价值
            ,firstconfmamt -- 分配初评我行确认价值
            ,datecode -- 报表日期
            ,credlevel -- 分配等级 1:一级分配 2:二级分配
            ,creditname -- 业务品种名称
            ,occurtype -- 发生类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_guardsitributeforjour_op(
            sccode -- 押品编号
            ,contractno -- 合同号
            ,balance -- 合同余额
            ,distvalue -- 贷款分配价值
            ,contguartype -- 合同主担保方式
            ,guartype -- 押品类型
            ,credittype -- 业务品种
            ,barsign -- 条线
            ,interindustry -- 行业
            ,custscale -- 规模
            ,reporttype -- 表内表外标识
            ,deptcode -- 所属机构
            ,fiveclass -- 五级分类
            ,credno -- 借据号
            ,bal -- 借据余额
            ,confmamt -- 分配我行确认价值
            ,firstconfmamt -- 分配初评我行确认价值
            ,datecode -- 报表日期
            ,credlevel -- 分配等级 1:一级分配 2:二级分配
            ,creditname -- 业务品种名称
            ,occurtype -- 发生类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 押品编号
    ,nvl(n.contractno, o.contractno) as contractno -- 合同号
    ,nvl(n.balance, o.balance) as balance -- 合同余额
    ,nvl(n.distvalue, o.distvalue) as distvalue -- 贷款分配价值
    ,nvl(n.contguartype, o.contguartype) as contguartype -- 合同主担保方式
    ,nvl(n.guartype, o.guartype) as guartype -- 押品类型
    ,nvl(n.credittype, o.credittype) as credittype -- 业务品种
    ,nvl(n.barsign, o.barsign) as barsign -- 条线
    ,nvl(n.interindustry, o.interindustry) as interindustry -- 行业
    ,nvl(n.custscale, o.custscale) as custscale -- 规模
    ,nvl(n.reporttype, o.reporttype) as reporttype -- 表内表外标识
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 所属机构
    ,nvl(n.fiveclass, o.fiveclass) as fiveclass -- 五级分类
    ,nvl(n.credno, o.credno) as credno -- 借据号
    ,nvl(n.bal, o.bal) as bal -- 借据余额
    ,nvl(n.confmamt, o.confmamt) as confmamt -- 分配我行确认价值
    ,nvl(n.firstconfmamt, o.firstconfmamt) as firstconfmamt -- 分配初评我行确认价值
    ,nvl(n.datecode, o.datecode) as datecode -- 报表日期
    ,nvl(n.credlevel, o.credlevel) as credlevel -- 分配等级 1:一级分配 2:二级分配
    ,nvl(n.creditname, o.creditname) as creditname -- 业务品种名称
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 发生类型
    ,case when
            n.sccode is null
            and n.contractno is null
            and n.credno is null
            and n.datecode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
            and n.contractno is null
            and n.credno is null
            and n.datecode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
            and n.contractno is null
            and n.credno is null
            and n.datecode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_yp_guardsitributeforjour_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_yp_guardsitributeforjour where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
            and o.contractno = n.contractno
            and o.credno = n.credno
            and o.datecode = n.datecode
where (
        o.sccode is null
        and o.contractno is null
        and o.credno is null
        and o.datecode is null
    )
    or (
        n.sccode is null
        and n.contractno is null
        and n.credno is null
        and n.datecode is null
    )
    or (
        o.balance <> n.balance
        or o.distvalue <> n.distvalue
        or o.contguartype <> n.contguartype
        or o.guartype <> n.guartype
        or o.credittype <> n.credittype
        or o.barsign <> n.barsign
        or o.interindustry <> n.interindustry
        or o.custscale <> n.custscale
        or o.reporttype <> n.reporttype
        or o.deptcode <> n.deptcode
        or o.fiveclass <> n.fiveclass
        or o.bal <> n.bal
        or o.confmamt <> n.confmamt
        or o.firstconfmamt <> n.firstconfmamt
        or o.credlevel <> n.credlevel
        or o.creditname <> n.creditname
        or o.occurtype <> n.occurtype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_guardsitributeforjour_cl(
            sccode -- 押品编号
            ,contractno -- 合同号
            ,balance -- 合同余额
            ,distvalue -- 贷款分配价值
            ,contguartype -- 合同主担保方式
            ,guartype -- 押品类型
            ,credittype -- 业务品种
            ,barsign -- 条线
            ,interindustry -- 行业
            ,custscale -- 规模
            ,reporttype -- 表内表外标识
            ,deptcode -- 所属机构
            ,fiveclass -- 五级分类
            ,credno -- 借据号
            ,bal -- 借据余额
            ,confmamt -- 分配我行确认价值
            ,firstconfmamt -- 分配初评我行确认价值
            ,datecode -- 报表日期
            ,credlevel -- 分配等级 1:一级分配 2:二级分配
            ,creditname -- 业务品种名称
            ,occurtype -- 发生类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_guardsitributeforjour_op(
            sccode -- 押品编号
            ,contractno -- 合同号
            ,balance -- 合同余额
            ,distvalue -- 贷款分配价值
            ,contguartype -- 合同主担保方式
            ,guartype -- 押品类型
            ,credittype -- 业务品种
            ,barsign -- 条线
            ,interindustry -- 行业
            ,custscale -- 规模
            ,reporttype -- 表内表外标识
            ,deptcode -- 所属机构
            ,fiveclass -- 五级分类
            ,credno -- 借据号
            ,bal -- 借据余额
            ,confmamt -- 分配我行确认价值
            ,firstconfmamt -- 分配初评我行确认价值
            ,datecode -- 报表日期
            ,credlevel -- 分配等级 1:一级分配 2:二级分配
            ,creditname -- 业务品种名称
            ,occurtype -- 发生类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 押品编号
    ,o.contractno -- 合同号
    ,o.balance -- 合同余额
    ,o.distvalue -- 贷款分配价值
    ,o.contguartype -- 合同主担保方式
    ,o.guartype -- 押品类型
    ,o.credittype -- 业务品种
    ,o.barsign -- 条线
    ,o.interindustry -- 行业
    ,o.custscale -- 规模
    ,o.reporttype -- 表内表外标识
    ,o.deptcode -- 所属机构
    ,o.fiveclass -- 五级分类
    ,o.credno -- 借据号
    ,o.bal -- 借据余额
    ,o.confmamt -- 分配我行确认价值
    ,o.firstconfmamt -- 分配初评我行确认价值
    ,o.datecode -- 报表日期
    ,o.credlevel -- 分配等级 1:一级分配 2:二级分配
    ,o.creditname -- 业务品种名称
    ,o.occurtype -- 发生类型
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
from ${iol_schema}.mims_yp_guardsitributeforjour_bk o
    left join ${iol_schema}.mims_yp_guardsitributeforjour_op n
        on
            o.sccode = n.sccode
            and o.contractno = n.contractno
            and o.credno = n.credno
            and o.datecode = n.datecode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_yp_guardsitributeforjour_cl d
        on
            o.sccode = d.sccode
            and o.contractno = d.contractno
            and o.credno = d.credno
            and o.datecode = d.datecode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_yp_guardsitributeforjour;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_yp_guardsitributeforjour') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_yp_guardsitributeforjour drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_yp_guardsitributeforjour add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_yp_guardsitributeforjour exchange partition p_${batch_date} with table ${iol_schema}.mims_yp_guardsitributeforjour_cl;
alter table ${iol_schema}.mims_yp_guardsitributeforjour exchange partition p_20991231 with table ${iol_schema}.mims_yp_guardsitributeforjour_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_yp_guardsitributeforjour to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_guardsitributeforjour_op purge;
drop table ${iol_schema}.mims_yp_guardsitributeforjour_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_yp_guardsitributeforjour_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_yp_guardsitributeforjour',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
