/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_res_biz_bl_cust_first_loan_day
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
create table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_res_biz_bl_cust_first_loan_day
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_op purge;
drop table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_res_biz_bl_cust_first_loan_day where 0=1;

create table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_res_biz_bl_cust_first_loan_day where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_cl(
            logicalcardno -- 逻辑卡号
            ,custid -- 客户号
            ,refnbr -- 首贷交易参考号
            ,bankgroupid -- 参贷方案
            ,obbankproportion -- 合作行出资比例
            ,loaninitprin -- 放款本金
            ,obloaninitprin -- 合作行份额放款本金
            ,firstactivatedate -- 首贷时间
            ,reserve1 -- 备份字段
            ,reserve2 -- 备份字段
            ,reserve3 -- 备份字段
            ,reserve4 -- 备份字段
            ,reserve5 -- 备份字段
            ,reserve6 -- 备份字段
            ,reserve7 -- 备份字段
            ,reserve8 -- 备份字段
            ,reserve9 -- 备份字段
            ,reserve10 -- 备份字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_op(
            logicalcardno -- 逻辑卡号
            ,custid -- 客户号
            ,refnbr -- 首贷交易参考号
            ,bankgroupid -- 参贷方案
            ,obbankproportion -- 合作行出资比例
            ,loaninitprin -- 放款本金
            ,obloaninitprin -- 合作行份额放款本金
            ,firstactivatedate -- 首贷时间
            ,reserve1 -- 备份字段
            ,reserve2 -- 备份字段
            ,reserve3 -- 备份字段
            ,reserve4 -- 备份字段
            ,reserve5 -- 备份字段
            ,reserve6 -- 备份字段
            ,reserve7 -- 备份字段
            ,reserve8 -- 备份字段
            ,reserve9 -- 备份字段
            ,reserve10 -- 备份字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.logicalcardno, o.logicalcardno) as logicalcardno -- 逻辑卡号
    ,nvl(n.custid, o.custid) as custid -- 客户号
    ,nvl(n.refnbr, o.refnbr) as refnbr -- 首贷交易参考号
    ,nvl(n.bankgroupid, o.bankgroupid) as bankgroupid -- 参贷方案
    ,nvl(n.obbankproportion, o.obbankproportion) as obbankproportion -- 合作行出资比例
    ,nvl(n.loaninitprin, o.loaninitprin) as loaninitprin -- 放款本金
    ,nvl(n.obloaninitprin, o.obloaninitprin) as obloaninitprin -- 合作行份额放款本金
    ,nvl(n.firstactivatedate, o.firstactivatedate) as firstactivatedate -- 首贷时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备份字段
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备份字段
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备份字段
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 备份字段
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 备份字段
    ,nvl(n.reserve6, o.reserve6) as reserve6 -- 备份字段
    ,nvl(n.reserve7, o.reserve7) as reserve7 -- 备份字段
    ,nvl(n.reserve8, o.reserve8) as reserve8 -- 备份字段
    ,nvl(n.reserve9, o.reserve9) as reserve9 -- 备份字段
    ,nvl(n.reserve10, o.reserve10) as reserve10 -- 备份字段
    ,case when
            n.refnbr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.refnbr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.refnbr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_res_biz_bl_cust_first_loan_day where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.refnbr = n.refnbr
where (
        o.refnbr is null
    )
    or (
        n.refnbr is null
    )
    or (
        o.logicalcardno <> n.logicalcardno
        or o.custid <> n.custid
        or o.bankgroupid <> n.bankgroupid
        or o.obbankproportion <> n.obbankproportion
        or o.loaninitprin <> n.loaninitprin
        or o.obloaninitprin <> n.obloaninitprin
        or o.firstactivatedate <> n.firstactivatedate
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.reserve6 <> n.reserve6
        or o.reserve7 <> n.reserve7
        or o.reserve8 <> n.reserve8
        or o.reserve9 <> n.reserve9
        or o.reserve10 <> n.reserve10
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_cl(
            logicalcardno -- 逻辑卡号
            ,custid -- 客户号
            ,refnbr -- 首贷交易参考号
            ,bankgroupid -- 参贷方案
            ,obbankproportion -- 合作行出资比例
            ,loaninitprin -- 放款本金
            ,obloaninitprin -- 合作行份额放款本金
            ,firstactivatedate -- 首贷时间
            ,reserve1 -- 备份字段
            ,reserve2 -- 备份字段
            ,reserve3 -- 备份字段
            ,reserve4 -- 备份字段
            ,reserve5 -- 备份字段
            ,reserve6 -- 备份字段
            ,reserve7 -- 备份字段
            ,reserve8 -- 备份字段
            ,reserve9 -- 备份字段
            ,reserve10 -- 备份字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_op(
            logicalcardno -- 逻辑卡号
            ,custid -- 客户号
            ,refnbr -- 首贷交易参考号
            ,bankgroupid -- 参贷方案
            ,obbankproportion -- 合作行出资比例
            ,loaninitprin -- 放款本金
            ,obloaninitprin -- 合作行份额放款本金
            ,firstactivatedate -- 首贷时间
            ,reserve1 -- 备份字段
            ,reserve2 -- 备份字段
            ,reserve3 -- 备份字段
            ,reserve4 -- 备份字段
            ,reserve5 -- 备份字段
            ,reserve6 -- 备份字段
            ,reserve7 -- 备份字段
            ,reserve8 -- 备份字段
            ,reserve9 -- 备份字段
            ,reserve10 -- 备份字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.logicalcardno -- 逻辑卡号
    ,o.custid -- 客户号
    ,o.refnbr -- 首贷交易参考号
    ,o.bankgroupid -- 参贷方案
    ,o.obbankproportion -- 合作行出资比例
    ,o.loaninitprin -- 放款本金
    ,o.obloaninitprin -- 合作行份额放款本金
    ,o.firstactivatedate -- 首贷时间
    ,o.reserve1 -- 备份字段
    ,o.reserve2 -- 备份字段
    ,o.reserve3 -- 备份字段
    ,o.reserve4 -- 备份字段
    ,o.reserve5 -- 备份字段
    ,o.reserve6 -- 备份字段
    ,o.reserve7 -- 备份字段
    ,o.reserve8 -- 备份字段
    ,o.reserve9 -- 备份字段
    ,o.reserve10 -- 备份字段
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
from ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_bk o
    left join ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_op n
        on
            o.refnbr = n.refnbr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_cl d
        on
            o.refnbr = d.refnbr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_res_biz_bl_cust_first_loan_day') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day exchange partition p_${batch_date} with table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_cl;
alter table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day exchange partition p_20991231 with table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_res_biz_bl_cust_first_loan_day to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_op purge;
drop table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_res_biz_bl_cust_first_loan_day_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_res_biz_bl_cust_first_loan_day',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
