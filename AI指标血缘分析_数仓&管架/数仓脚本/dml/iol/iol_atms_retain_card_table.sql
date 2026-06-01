/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_retain_card_table
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
create table ${iol_schema}.atms_retain_card_table_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.atms_retain_card_table
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_retain_card_table_op purge;
drop table ${iol_schema}.atms_retain_card_table_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_retain_card_table_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_retain_card_table where 0=1;

create table ${iol_schema}.atms_retain_card_table_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_retain_card_table where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_retain_card_table_cl(
            logic_id -- 编号
            ,dev_no -- 设备号
            ,retain_date -- 吞卡日期
            ,retain_time -- 吞卡时间
            ,account -- 卡号
            ,reason -- 原因
            ,period -- 会计周期号
            ,card_stuck_org -- 吞卡机构
            ,card_handle_org -- 处理机构
            ,auto_flag -- 自动录入标志
            ,check_op -- 登记人
            ,check_date -- 登记日期
            ,check_time -- 登记时间
            ,op_no -- 处理人
            ,op_date -- 处理日期
            ,op_time -- 处理时间
            ,op_address -- 处理地点
            ,account_name -- 客户姓名
            ,account_id -- 客户证件号
            ,account_phome -- 客户电话
            ,cert_type -- 证件类型
            ,status -- 吞卡状态
            ,account_phone -- 客户电话
            ,type_flag -- 新吞类型（0——吞卡，1——吞钞）
            ,card_retain_type -- 吞卡类型，1-已吞卡到回收箱；2-已吞卡到退卡器；3-吞卡被取走（读卡器）；4-吞卡被取走（退卡器）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_retain_card_table_op(
            logic_id -- 编号
            ,dev_no -- 设备号
            ,retain_date -- 吞卡日期
            ,retain_time -- 吞卡时间
            ,account -- 卡号
            ,reason -- 原因
            ,period -- 会计周期号
            ,card_stuck_org -- 吞卡机构
            ,card_handle_org -- 处理机构
            ,auto_flag -- 自动录入标志
            ,check_op -- 登记人
            ,check_date -- 登记日期
            ,check_time -- 登记时间
            ,op_no -- 处理人
            ,op_date -- 处理日期
            ,op_time -- 处理时间
            ,op_address -- 处理地点
            ,account_name -- 客户姓名
            ,account_id -- 客户证件号
            ,account_phome -- 客户电话
            ,cert_type -- 证件类型
            ,status -- 吞卡状态
            ,account_phone -- 客户电话
            ,type_flag -- 新吞类型（0——吞卡，1——吞钞）
            ,card_retain_type -- 吞卡类型，1-已吞卡到回收箱；2-已吞卡到退卡器；3-吞卡被取走（读卡器）；4-吞卡被取走（退卡器）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.logic_id, o.logic_id) as logic_id -- 编号
    ,nvl(n.dev_no, o.dev_no) as dev_no -- 设备号
    ,nvl(n.retain_date, o.retain_date) as retain_date -- 吞卡日期
    ,nvl(n.retain_time, o.retain_time) as retain_time -- 吞卡时间
    ,nvl(n.account, o.account) as account -- 卡号
    ,nvl(n.reason, o.reason) as reason -- 原因
    ,nvl(n.period, o.period) as period -- 会计周期号
    ,nvl(n.card_stuck_org, o.card_stuck_org) as card_stuck_org -- 吞卡机构
    ,nvl(n.card_handle_org, o.card_handle_org) as card_handle_org -- 处理机构
    ,nvl(n.auto_flag, o.auto_flag) as auto_flag -- 自动录入标志
    ,nvl(n.check_op, o.check_op) as check_op -- 登记人
    ,nvl(n.check_date, o.check_date) as check_date -- 登记日期
    ,nvl(n.check_time, o.check_time) as check_time -- 登记时间
    ,nvl(n.op_no, o.op_no) as op_no -- 处理人
    ,nvl(n.op_date, o.op_date) as op_date -- 处理日期
    ,nvl(n.op_time, o.op_time) as op_time -- 处理时间
    ,nvl(n.op_address, o.op_address) as op_address -- 处理地点
    ,nvl(n.account_name, o.account_name) as account_name -- 客户姓名
    ,nvl(n.account_id, o.account_id) as account_id -- 客户证件号
    ,nvl(n.account_phome, o.account_phome) as account_phome -- 客户电话
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 证件类型
    ,nvl(n.status, o.status) as status -- 吞卡状态
    ,nvl(n.account_phone, o.account_phone) as account_phone -- 客户电话
    ,nvl(n.type_flag, o.type_flag) as type_flag -- 新吞类型（0——吞卡，1——吞钞）
    ,nvl(n.card_retain_type, o.card_retain_type) as card_retain_type -- 吞卡类型，1-已吞卡到回收箱；2-已吞卡到退卡器；3-吞卡被取走（读卡器）；4-吞卡被取走（退卡器）
    ,case when
            n.logic_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.logic_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.logic_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.atms_retain_card_table_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.atms_retain_card_table where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.logic_id = n.logic_id
where (
        o.logic_id is null
    )
    or (
        n.logic_id is null
    )
    or (
        o.dev_no <> n.dev_no
        or o.retain_date <> n.retain_date
        or o.retain_time <> n.retain_time
        or o.account <> n.account
        or o.reason <> n.reason
        or o.period <> n.period
        or o.card_stuck_org <> n.card_stuck_org
        or o.card_handle_org <> n.card_handle_org
        or o.auto_flag <> n.auto_flag
        or o.check_op <> n.check_op
        or o.check_date <> n.check_date
        or o.check_time <> n.check_time
        or o.op_no <> n.op_no
        or o.op_date <> n.op_date
        or o.op_time <> n.op_time
        or o.op_address <> n.op_address
        or o.account_name <> n.account_name
        or o.account_id <> n.account_id
        or o.account_phome <> n.account_phome
        or o.cert_type <> n.cert_type
        or o.status <> n.status
        or o.account_phone <> n.account_phone
        or o.type_flag <> n.type_flag
        or o.card_retain_type <> n.card_retain_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_retain_card_table_cl(
            logic_id -- 编号
            ,dev_no -- 设备号
            ,retain_date -- 吞卡日期
            ,retain_time -- 吞卡时间
            ,account -- 卡号
            ,reason -- 原因
            ,period -- 会计周期号
            ,card_stuck_org -- 吞卡机构
            ,card_handle_org -- 处理机构
            ,auto_flag -- 自动录入标志
            ,check_op -- 登记人
            ,check_date -- 登记日期
            ,check_time -- 登记时间
            ,op_no -- 处理人
            ,op_date -- 处理日期
            ,op_time -- 处理时间
            ,op_address -- 处理地点
            ,account_name -- 客户姓名
            ,account_id -- 客户证件号
            ,account_phome -- 客户电话
            ,cert_type -- 证件类型
            ,status -- 吞卡状态
            ,account_phone -- 客户电话
            ,type_flag -- 新吞类型（0——吞卡，1——吞钞）
            ,card_retain_type -- 吞卡类型，1-已吞卡到回收箱；2-已吞卡到退卡器；3-吞卡被取走（读卡器）；4-吞卡被取走（退卡器）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_retain_card_table_op(
            logic_id -- 编号
            ,dev_no -- 设备号
            ,retain_date -- 吞卡日期
            ,retain_time -- 吞卡时间
            ,account -- 卡号
            ,reason -- 原因
            ,period -- 会计周期号
            ,card_stuck_org -- 吞卡机构
            ,card_handle_org -- 处理机构
            ,auto_flag -- 自动录入标志
            ,check_op -- 登记人
            ,check_date -- 登记日期
            ,check_time -- 登记时间
            ,op_no -- 处理人
            ,op_date -- 处理日期
            ,op_time -- 处理时间
            ,op_address -- 处理地点
            ,account_name -- 客户姓名
            ,account_id -- 客户证件号
            ,account_phome -- 客户电话
            ,cert_type -- 证件类型
            ,status -- 吞卡状态
            ,account_phone -- 客户电话
            ,type_flag -- 新吞类型（0——吞卡，1——吞钞）
            ,card_retain_type -- 吞卡类型，1-已吞卡到回收箱；2-已吞卡到退卡器；3-吞卡被取走（读卡器）；4-吞卡被取走（退卡器）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.logic_id -- 编号
    ,o.dev_no -- 设备号
    ,o.retain_date -- 吞卡日期
    ,o.retain_time -- 吞卡时间
    ,o.account -- 卡号
    ,o.reason -- 原因
    ,o.period -- 会计周期号
    ,o.card_stuck_org -- 吞卡机构
    ,o.card_handle_org -- 处理机构
    ,o.auto_flag -- 自动录入标志
    ,o.check_op -- 登记人
    ,o.check_date -- 登记日期
    ,o.check_time -- 登记时间
    ,o.op_no -- 处理人
    ,o.op_date -- 处理日期
    ,o.op_time -- 处理时间
    ,o.op_address -- 处理地点
    ,o.account_name -- 客户姓名
    ,o.account_id -- 客户证件号
    ,o.account_phome -- 客户电话
    ,o.cert_type -- 证件类型
    ,o.status -- 吞卡状态
    ,o.account_phone -- 客户电话
    ,o.type_flag -- 新吞类型（0——吞卡，1——吞钞）
    ,o.card_retain_type -- 吞卡类型，1-已吞卡到回收箱；2-已吞卡到退卡器；3-吞卡被取走（读卡器）；4-吞卡被取走（退卡器）
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
from ${iol_schema}.atms_retain_card_table_bk o
    left join ${iol_schema}.atms_retain_card_table_op n
        on
            o.logic_id = n.logic_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.atms_retain_card_table_cl d
        on
            o.logic_id = d.logic_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.atms_retain_card_table;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('atms_retain_card_table') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.atms_retain_card_table drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.atms_retain_card_table add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.atms_retain_card_table exchange partition p_${batch_date} with table ${iol_schema}.atms_retain_card_table_cl;
alter table ${iol_schema}.atms_retain_card_table exchange partition p_20991231 with table ${iol_schema}.atms_retain_card_table_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.atms_retain_card_table to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_retain_card_table_op purge;
drop table ${iol_schema}.atms_retain_card_table_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.atms_retain_card_table_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'atms_retain_card_table',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
