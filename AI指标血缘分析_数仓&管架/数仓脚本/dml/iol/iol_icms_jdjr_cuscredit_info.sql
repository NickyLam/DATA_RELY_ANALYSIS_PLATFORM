/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_jdjr_cuscredit_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.icms_jdjr_cuscredit_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_jdjr_cuscredit_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jdjr_cuscredit_info_op purge;
drop table ${iol_schema}.icms_jdjr_cuscredit_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_cuscredit_info_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_jdjr_cuscredit_info where 0=1;

create table ${iol_schema}.icms_jdjr_cuscredit_info_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_jdjr_cuscredit_info where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.icms_jdjr_cuscredit_info_op(
        limitno -- 客户额度编号
        ,unusedlimitamt -- 未动拨授信额度
        ,creditstatus -- 授信状态A、有效B、无效
        ,creditstartdt -- 授信生效起始日期
        ,creditlimitamt -- 授信额度
        ,templimitflag -- 是否临时额度1、是0、否
        ,prdno -- 产品编号
        ,bussdate -- 数据日期
        ,currency -- 币种
        ,creditenddt -- 授信到期日
        ,cusno -- 京东pin
        ,migtflag -- 
        ,cyclelimitflag -- 循环额度标志
        ,prdcode -- 产品编号（行内）
        ,creditdays -- 授信期限
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.limitno -- 客户额度编号
    ,n.unusedlimitamt -- 未动拨授信额度
    ,n.creditstatus -- 授信状态A、有效B、无效
    ,n.creditstartdt -- 授信生效起始日期
    ,n.creditlimitamt -- 授信额度
    ,n.templimitflag -- 是否临时额度1、是0、否
    ,n.prdno -- 产品编号
    ,n.bussdate -- 数据日期
    ,n.currency -- 币种
    ,n.creditenddt -- 授信到期日
    ,n.cusno -- 京东pin
    ,n.migtflag -- 
    ,n.cyclelimitflag -- 循环额度标志
    ,n.prdcode -- 产品编号（行内）
    ,n.creditdays -- 授信期限
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_jdjr_cuscredit_info_bk o
    right join (select * from ${itl_schema}.icms_jdjr_cuscredit_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.limitno = n.limitno
where (
        o.limitno is null
    )
    or (
        o.unusedlimitamt <> n.unusedlimitamt
        or o.creditstatus <> n.creditstatus
        or o.creditstartdt <> n.creditstartdt
        or o.creditlimitamt <> n.creditlimitamt
        or o.templimitflag <> n.templimitflag
        or o.prdno <> n.prdno
        or o.bussdate <> n.bussdate
        or o.currency <> n.currency
        or o.creditenddt <> n.creditenddt
        or o.cusno <> n.cusno
        or o.migtflag <> n.migtflag
        or o.cyclelimitflag <> n.cyclelimitflag
        or o.prdcode <> n.prdcode
        or o.creditdays <> n.creditdays
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_jdjr_cuscredit_info_cl(
            limitno -- 客户额度编号
        ,unusedlimitamt -- 未动拨授信额度
        ,creditstatus -- 授信状态A、有效B、无效
        ,creditstartdt -- 授信生效起始日期
        ,creditlimitamt -- 授信额度
        ,templimitflag -- 是否临时额度1、是0、否
        ,prdno -- 产品编号
        ,bussdate -- 数据日期
        ,currency -- 币种
        ,creditenddt -- 授信到期日
        ,cusno -- 京东pin
        ,migtflag -- 
        ,cyclelimitflag -- 循环额度标志
        ,prdcode -- 产品编号（行内）
        ,creditdays -- 授信期限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_jdjr_cuscredit_info_op(
            limitno -- 客户额度编号
        ,unusedlimitamt -- 未动拨授信额度
        ,creditstatus -- 授信状态A、有效B、无效
        ,creditstartdt -- 授信生效起始日期
        ,creditlimitamt -- 授信额度
        ,templimitflag -- 是否临时额度1、是0、否
        ,prdno -- 产品编号
        ,bussdate -- 数据日期
        ,currency -- 币种
        ,creditenddt -- 授信到期日
        ,cusno -- 京东pin
        ,migtflag -- 
        ,cyclelimitflag -- 循环额度标志
        ,prdcode -- 产品编号（行内）
        ,creditdays -- 授信期限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.limitno -- 客户额度编号
    ,o.unusedlimitamt -- 未动拨授信额度
    ,o.creditstatus -- 授信状态A、有效B、无效
    ,o.creditstartdt -- 授信生效起始日期
    ,o.creditlimitamt -- 授信额度
    ,o.templimitflag -- 是否临时额度1、是0、否
    ,o.prdno -- 产品编号
    ,o.bussdate -- 数据日期
    ,o.currency -- 币种
    ,o.creditenddt -- 授信到期日
    ,o.cusno -- 京东pin
    ,o.migtflag -- 
    ,o.cyclelimitflag -- 循环额度标志
    ,o.prdcode -- 产品编号（行内）
    ,o.creditdays -- 授信期限
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_jdjr_cuscredit_info_bk o
    left join ${iol_schema}.icms_jdjr_cuscredit_info_op n
        on
            o.limitno = n.limitno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_jdjr_cuscredit_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_jdjr_cuscredit_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_jdjr_cuscredit_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_jdjr_cuscredit_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_jdjr_cuscredit_info exchange partition p_${batch_date} with table ${iol_schema}.icms_jdjr_cuscredit_info_cl;
alter table ${iol_schema}.icms_jdjr_cuscredit_info exchange partition p_20991231 with table ${iol_schema}.icms_jdjr_cuscredit_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_jdjr_cuscredit_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jdjr_cuscredit_info_op purge;
drop table ${iol_schema}.icms_jdjr_cuscredit_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_jdjr_cuscredit_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_jdjr_cuscredit_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
