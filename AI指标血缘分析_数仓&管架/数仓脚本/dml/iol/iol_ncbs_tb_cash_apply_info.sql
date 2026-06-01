/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_cash_apply_info
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
create table ${iol_schema}.ncbs_tb_cash_apply_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_cash_apply_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_cash_apply_info_op purge;
drop table ${iol_schema}.ncbs_tb_cash_apply_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_apply_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_cash_apply_info where 0=1;

create table ${iol_schema}.ncbs_tb_cash_apply_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_cash_apply_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_cash_apply_info_cl(
            reference -- 交易参考号
            ,apply_id -- 申请预约编号
            ,apply_type -- 预约申请类型
            ,company -- 法人
            ,confirm_user_id -- 确认柜员编号
            ,in_out_type -- 调入调出方式
            ,move_id -- 调拨转移id
            ,narrative -- 摘要
            ,apply_date -- 申请日期
            ,approve_date -- 批准日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,apply_user_id -- 申请柜员
            ,appr_user_id -- 复核柜员
            ,approve_branch -- 复核柜员所属机构
            ,refuse_reason -- 拒绝原因
            ,to_branch -- 对方机构
            ,from_branch -- 转出机构
            ,apply_branch -- 申请机构
            ,dispatch_date -- 调拨日期
            ,apply_status -- 现金凭证预约状态
            ,confirm_branch -- 确认机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_cash_apply_info_op(
            reference -- 交易参考号
            ,apply_id -- 申请预约编号
            ,apply_type -- 预约申请类型
            ,company -- 法人
            ,confirm_user_id -- 确认柜员编号
            ,in_out_type -- 调入调出方式
            ,move_id -- 调拨转移id
            ,narrative -- 摘要
            ,apply_date -- 申请日期
            ,approve_date -- 批准日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,apply_user_id -- 申请柜员
            ,appr_user_id -- 复核柜员
            ,approve_branch -- 复核柜员所属机构
            ,refuse_reason -- 拒绝原因
            ,to_branch -- 对方机构
            ,from_branch -- 转出机构
            ,apply_branch -- 申请机构
            ,dispatch_date -- 调拨日期
            ,apply_status -- 现金凭证预约状态
            ,confirm_branch -- 确认机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.apply_id, o.apply_id) as apply_id -- 申请预约编号
    ,nvl(n.apply_type, o.apply_type) as apply_type -- 预约申请类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.confirm_user_id, o.confirm_user_id) as confirm_user_id -- 确认柜员编号
    ,nvl(n.in_out_type, o.in_out_type) as in_out_type -- 调入调出方式
    ,nvl(n.move_id, o.move_id) as move_id -- 调拨转移id
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 申请日期
    ,nvl(n.approve_date, o.approve_date) as approve_date -- 批准日期
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.apply_user_id, o.apply_user_id) as apply_user_id -- 申请柜员
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.approve_branch, o.approve_branch) as approve_branch -- 复核柜员所属机构
    ,nvl(n.refuse_reason, o.refuse_reason) as refuse_reason -- 拒绝原因
    ,nvl(n.to_branch, o.to_branch) as to_branch -- 对方机构
    ,nvl(n.from_branch, o.from_branch) as from_branch -- 转出机构
    ,nvl(n.apply_branch, o.apply_branch) as apply_branch -- 申请机构
    ,nvl(n.dispatch_date, o.dispatch_date) as dispatch_date -- 调拨日期
    ,nvl(n.apply_status, o.apply_status) as apply_status -- 现金凭证预约状态
    ,nvl(n.confirm_branch, o.confirm_branch) as confirm_branch -- 确认机构
    ,case when
            n.apply_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.apply_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.apply_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_cash_apply_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_cash_apply_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.apply_id = n.apply_id
where (
        o.apply_id is null
    )
    or (
        n.apply_id is null
    )
    or (
        o.reference <> n.reference
        or o.apply_type <> n.apply_type
        or o.company <> n.company
        or o.confirm_user_id <> n.confirm_user_id
        or o.in_out_type <> n.in_out_type
        or o.move_id <> n.move_id
        or o.narrative <> n.narrative
        or o.apply_date <> n.apply_date
        or o.approve_date <> n.approve_date
        or o.effect_date <> n.effect_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.apply_user_id <> n.apply_user_id
        or o.appr_user_id <> n.appr_user_id
        or o.approve_branch <> n.approve_branch
        or o.refuse_reason <> n.refuse_reason
        or o.to_branch <> n.to_branch
        or o.from_branch <> n.from_branch
        or o.apply_branch <> n.apply_branch
        or o.dispatch_date <> n.dispatch_date
        or o.apply_status <> n.apply_status
        or o.confirm_branch <> n.confirm_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_cash_apply_info_cl(
            reference -- 交易参考号
            ,apply_id -- 申请预约编号
            ,apply_type -- 预约申请类型
            ,company -- 法人
            ,confirm_user_id -- 确认柜员编号
            ,in_out_type -- 调入调出方式
            ,move_id -- 调拨转移id
            ,narrative -- 摘要
            ,apply_date -- 申请日期
            ,approve_date -- 批准日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,apply_user_id -- 申请柜员
            ,appr_user_id -- 复核柜员
            ,approve_branch -- 复核柜员所属机构
            ,refuse_reason -- 拒绝原因
            ,to_branch -- 对方机构
            ,from_branch -- 转出机构
            ,apply_branch -- 申请机构
            ,dispatch_date -- 调拨日期
            ,apply_status -- 现金凭证预约状态
            ,confirm_branch -- 确认机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_cash_apply_info_op(
            reference -- 交易参考号
            ,apply_id -- 申请预约编号
            ,apply_type -- 预约申请类型
            ,company -- 法人
            ,confirm_user_id -- 确认柜员编号
            ,in_out_type -- 调入调出方式
            ,move_id -- 调拨转移id
            ,narrative -- 摘要
            ,apply_date -- 申请日期
            ,approve_date -- 批准日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,apply_user_id -- 申请柜员
            ,appr_user_id -- 复核柜员
            ,approve_branch -- 复核柜员所属机构
            ,refuse_reason -- 拒绝原因
            ,to_branch -- 对方机构
            ,from_branch -- 转出机构
            ,apply_branch -- 申请机构
            ,dispatch_date -- 调拨日期
            ,apply_status -- 现金凭证预约状态
            ,confirm_branch -- 确认机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.reference -- 交易参考号
    ,o.apply_id -- 申请预约编号
    ,o.apply_type -- 预约申请类型
    ,o.company -- 法人
    ,o.confirm_user_id -- 确认柜员编号
    ,o.in_out_type -- 调入调出方式
    ,o.move_id -- 调拨转移id
    ,o.narrative -- 摘要
    ,o.apply_date -- 申请日期
    ,o.approve_date -- 批准日期
    ,o.effect_date -- 产品生效日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.apply_user_id -- 申请柜员
    ,o.appr_user_id -- 复核柜员
    ,o.approve_branch -- 复核柜员所属机构
    ,o.refuse_reason -- 拒绝原因
    ,o.to_branch -- 对方机构
    ,o.from_branch -- 转出机构
    ,o.apply_branch -- 申请机构
    ,o.dispatch_date -- 调拨日期
    ,o.apply_status -- 现金凭证预约状态
    ,o.confirm_branch -- 确认机构
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
from ${iol_schema}.ncbs_tb_cash_apply_info_bk o
    left join ${iol_schema}.ncbs_tb_cash_apply_info_op n
        on
            o.apply_id = n.apply_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_cash_apply_info_cl d
        on
            o.apply_id = d.apply_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_cash_apply_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_cash_apply_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_cash_apply_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_cash_apply_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_cash_apply_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_cash_apply_info_cl;
alter table ${iol_schema}.ncbs_tb_cash_apply_info exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_cash_apply_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_cash_apply_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_cash_apply_info_op purge;
drop table ${iol_schema}.ncbs_tb_cash_apply_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_cash_apply_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_cash_apply_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
