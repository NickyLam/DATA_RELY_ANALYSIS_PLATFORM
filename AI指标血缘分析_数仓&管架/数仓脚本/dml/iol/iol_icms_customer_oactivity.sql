/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_oactivity
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
create table ${iol_schema}.icms_customer_oactivity_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_oactivity
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_oactivity_op purge;
drop table ${iol_schema}.icms_customer_oactivity_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_oactivity_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_oactivity where 0=1;

create table ${iol_schema}.icms_customer_oactivity_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_oactivity where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_oactivity_cl(
            customerid -- 客户编号
            ,serialno -- 流水号
            ,otherbadrecord -- 在他行不良记录及原因
            ,inputuserid -- 登记人
            ,maturity -- 到期日
            ,uptodate -- 统计截止日期
            ,balance -- 余额
            ,info -- 协议内容
            ,classifyresult -- 五级分类
            ,vouchtype -- 主要担保方式
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,occurorg -- 发生行
            ,lastbusinesssum -- 
            ,businesstype -- 业务类型
            ,inputdate -- 输入日期
            ,remark -- 说明
            ,guarconditions -- 担保条件
            ,migtflag -- 
            ,currency -- 币种
            ,businesssum -- 金额
            ,begindate -- 起始日期
            ,creditmode -- 授信模式
            ,lastbalance -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_oactivity_op(
            customerid -- 客户编号
            ,serialno -- 流水号
            ,otherbadrecord -- 在他行不良记录及原因
            ,inputuserid -- 登记人
            ,maturity -- 到期日
            ,uptodate -- 统计截止日期
            ,balance -- 余额
            ,info -- 协议内容
            ,classifyresult -- 五级分类
            ,vouchtype -- 主要担保方式
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,occurorg -- 发生行
            ,lastbusinesssum -- 
            ,businesstype -- 业务类型
            ,inputdate -- 输入日期
            ,remark -- 说明
            ,guarconditions -- 担保条件
            ,migtflag -- 
            ,currency -- 币种
            ,businesssum -- 金额
            ,begindate -- 起始日期
            ,creditmode -- 授信模式
            ,lastbalance -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.otherbadrecord, o.otherbadrecord) as otherbadrecord -- 在他行不良记录及原因
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.maturity, o.maturity) as maturity -- 到期日
    ,nvl(n.uptodate, o.uptodate) as uptodate -- 统计截止日期
    ,nvl(n.balance, o.balance) as balance -- 余额
    ,nvl(n.info, o.info) as info -- 协议内容
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 五级分类
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主要担保方式
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.occurorg, o.occurorg) as occurorg -- 发生行
    ,nvl(n.lastbusinesssum, o.lastbusinesssum) as lastbusinesssum -- 
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务类型
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 输入日期
    ,nvl(n.remark, o.remark) as remark -- 说明
    ,nvl(n.guarconditions, o.guarconditions) as guarconditions -- 担保条件
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 金额
    ,nvl(n.begindate, o.begindate) as begindate -- 起始日期
    ,nvl(n.creditmode, o.creditmode) as creditmode -- 授信模式
    ,nvl(n.lastbalance, o.lastbalance) as lastbalance -- 
    ,case when
            n.customerid is null
            and n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
            and n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
            and n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_customer_oactivity_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_oactivity where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
            and o.serialno = n.serialno
where (
        o.customerid is null
        and o.serialno is null
    )
    or (
        n.customerid is null
        and n.serialno is null
    )
    or (
        o.otherbadrecord <> n.otherbadrecord
        or o.inputuserid <> n.inputuserid
        or o.maturity <> n.maturity
        or o.uptodate <> n.uptodate
        or o.balance <> n.balance
        or o.info <> n.info
        or o.classifyresult <> n.classifyresult
        or o.vouchtype <> n.vouchtype
        or o.inputorgid <> n.inputorgid
        or o.updatedate <> n.updatedate
        or o.occurorg <> n.occurorg
        or o.lastbusinesssum <> n.lastbusinesssum
        or o.businesstype <> n.businesstype
        or o.inputdate <> n.inputdate
        or o.remark <> n.remark
        or o.guarconditions <> n.guarconditions
        or o.migtflag <> n.migtflag
        or o.currency <> n.currency
        or o.businesssum <> n.businesssum
        or o.begindate <> n.begindate
        or o.creditmode <> n.creditmode
        or o.lastbalance <> n.lastbalance
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_oactivity_cl(
            customerid -- 客户编号
            ,serialno -- 流水号
            ,otherbadrecord -- 在他行不良记录及原因
            ,inputuserid -- 登记人
            ,maturity -- 到期日
            ,uptodate -- 统计截止日期
            ,balance -- 余额
            ,info -- 协议内容
            ,classifyresult -- 五级分类
            ,vouchtype -- 主要担保方式
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,occurorg -- 发生行
            ,lastbusinesssum -- 
            ,businesstype -- 业务类型
            ,inputdate -- 输入日期
            ,remark -- 说明
            ,guarconditions -- 担保条件
            ,migtflag -- 
            ,currency -- 币种
            ,businesssum -- 金额
            ,begindate -- 起始日期
            ,creditmode -- 授信模式
            ,lastbalance -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_oactivity_op(
            customerid -- 客户编号
            ,serialno -- 流水号
            ,otherbadrecord -- 在他行不良记录及原因
            ,inputuserid -- 登记人
            ,maturity -- 到期日
            ,uptodate -- 统计截止日期
            ,balance -- 余额
            ,info -- 协议内容
            ,classifyresult -- 五级分类
            ,vouchtype -- 主要担保方式
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,occurorg -- 发生行
            ,lastbusinesssum -- 
            ,businesstype -- 业务类型
            ,inputdate -- 输入日期
            ,remark -- 说明
            ,guarconditions -- 担保条件
            ,migtflag -- 
            ,currency -- 币种
            ,businesssum -- 金额
            ,begindate -- 起始日期
            ,creditmode -- 授信模式
            ,lastbalance -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 客户编号
    ,o.serialno -- 流水号
    ,o.otherbadrecord -- 在他行不良记录及原因
    ,o.inputuserid -- 登记人
    ,o.maturity -- 到期日
    ,o.uptodate -- 统计截止日期
    ,o.balance -- 余额
    ,o.info -- 协议内容
    ,o.classifyresult -- 五级分类
    ,o.vouchtype -- 主要担保方式
    ,o.inputorgid -- 登记机构
    ,o.updatedate -- 更新日期
    ,o.occurorg -- 发生行
    ,o.lastbusinesssum -- 
    ,o.businesstype -- 业务类型
    ,o.inputdate -- 输入日期
    ,o.remark -- 说明
    ,o.guarconditions -- 担保条件
    ,o.migtflag -- 
    ,o.currency -- 币种
    ,o.businesssum -- 金额
    ,o.begindate -- 起始日期
    ,o.creditmode -- 授信模式
    ,o.lastbalance -- 
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
from ${iol_schema}.icms_customer_oactivity_bk o
    left join ${iol_schema}.icms_customer_oactivity_op n
        on
            o.customerid = n.customerid
            and o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_oactivity_cl d
        on
            o.customerid = d.customerid
            and o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_customer_oactivity;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_oactivity') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_oactivity drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_oactivity add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_oactivity exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_oactivity_cl;
alter table ${iol_schema}.icms_customer_oactivity exchange partition p_20991231 with table ${iol_schema}.icms_customer_oactivity_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_oactivity to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_oactivity_op purge;
drop table ${iol_schema}.icms_customer_oactivity_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_oactivity_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_oactivity',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
