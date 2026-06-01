/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alss_am_outside_business_tb
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
create table ${iol_schema}.alss_am_outside_business_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.alss_am_outside_business_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.alss_am_outside_business_tb_op purge;
drop table ${iol_schema}.alss_am_outside_business_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_am_outside_business_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alss_am_outside_business_tb where 0=1;

create table ${iol_schema}.alss_am_outside_business_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alss_am_outside_business_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.alss_am_outside_business_tb_cl(
            id -- ID
            ,bach_date -- 批次年月
            ,acct_no -- 账号
            ,card_id -- 卡号
            ,acct_name -- 户名
            ,open_acct_organ -- 开户机构
            ,approve_result -- 审批结果
            ,approve_date -- 审批日期
            ,upload_date -- 上传日志
            ,jx_money -- 久悬金额
            ,open_acct_date -- 开户日期
            ,bd_date -- 设置不动户日期
            ,jx_date -- 设置久悬户日期
            ,old_trans_date -- 上一次主动交易日期
            ,one_acct_num -- 一人多户数量
            ,is_iden_date -- 是否证件过期（0-否，1-是）
            ,nine_info -- 9要素是否齐全
            ,gg_person -- 共管人
            ,gh_person -- 管户人
            ,last_aum -- 上季度AUM
            ,cus_wealth_level -- 客户财富等级
            ,last_quarter_approve -- 上季度审批情况
            ,last_quarter_ncbs_approve -- 上季度核心处理结果
            ,data_type -- 数据类型
            ,acct_seq_no -- 账户子账号
            ,sys_user_id -- 共管人ID
            ,mag_cst_mgr_id -- 管户人ID
            ,fail_reason -- 
            ,bach_no -- 
            ,date1 -- 
            ,cust_id -- 
            ,querter -- 季度
            ,is_exception_of_phone -- 手机号是否异常
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.alss_am_outside_business_tb_op(
            id -- ID
            ,bach_date -- 批次年月
            ,acct_no -- 账号
            ,card_id -- 卡号
            ,acct_name -- 户名
            ,open_acct_organ -- 开户机构
            ,approve_result -- 审批结果
            ,approve_date -- 审批日期
            ,upload_date -- 上传日志
            ,jx_money -- 久悬金额
            ,open_acct_date -- 开户日期
            ,bd_date -- 设置不动户日期
            ,jx_date -- 设置久悬户日期
            ,old_trans_date -- 上一次主动交易日期
            ,one_acct_num -- 一人多户数量
            ,is_iden_date -- 是否证件过期（0-否，1-是）
            ,nine_info -- 9要素是否齐全
            ,gg_person -- 共管人
            ,gh_person -- 管户人
            ,last_aum -- 上季度AUM
            ,cus_wealth_level -- 客户财富等级
            ,last_quarter_approve -- 上季度审批情况
            ,last_quarter_ncbs_approve -- 上季度核心处理结果
            ,data_type -- 数据类型
            ,acct_seq_no -- 账户子账号
            ,sys_user_id -- 共管人ID
            ,mag_cst_mgr_id -- 管户人ID
            ,fail_reason -- 
            ,bach_no -- 
            ,date1 -- 
            ,cust_id -- 
            ,querter -- 季度
            ,is_exception_of_phone -- 手机号是否异常
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.bach_date, o.bach_date) as bach_date -- 批次年月
    ,nvl(n.acct_no, o.acct_no) as acct_no -- 账号
    ,nvl(n.card_id, o.card_id) as card_id -- 卡号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 户名
    ,nvl(n.open_acct_organ, o.open_acct_organ) as open_acct_organ -- 开户机构
    ,nvl(n.approve_result, o.approve_result) as approve_result -- 审批结果
    ,nvl(n.approve_date, o.approve_date) as approve_date -- 审批日期
    ,nvl(n.upload_date, o.upload_date) as upload_date -- 上传日志
    ,nvl(n.jx_money, o.jx_money) as jx_money -- 久悬金额
    ,nvl(n.open_acct_date, o.open_acct_date) as open_acct_date -- 开户日期
    ,nvl(n.bd_date, o.bd_date) as bd_date -- 设置不动户日期
    ,nvl(n.jx_date, o.jx_date) as jx_date -- 设置久悬户日期
    ,nvl(n.old_trans_date, o.old_trans_date) as old_trans_date -- 上一次主动交易日期
    ,nvl(n.one_acct_num, o.one_acct_num) as one_acct_num -- 一人多户数量
    ,nvl(n.is_iden_date, o.is_iden_date) as is_iden_date -- 是否证件过期（0-否，1-是）
    ,nvl(n.nine_info, o.nine_info) as nine_info -- 9要素是否齐全
    ,nvl(n.gg_person, o.gg_person) as gg_person -- 共管人
    ,nvl(n.gh_person, o.gh_person) as gh_person -- 管户人
    ,nvl(n.last_aum, o.last_aum) as last_aum -- 上季度AUM
    ,nvl(n.cus_wealth_level, o.cus_wealth_level) as cus_wealth_level -- 客户财富等级
    ,nvl(n.last_quarter_approve, o.last_quarter_approve) as last_quarter_approve -- 上季度审批情况
    ,nvl(n.last_quarter_ncbs_approve, o.last_quarter_ncbs_approve) as last_quarter_ncbs_approve -- 上季度核心处理结果
    ,nvl(n.data_type, o.data_type) as data_type -- 数据类型
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.sys_user_id, o.sys_user_id) as sys_user_id -- 共管人ID
    ,nvl(n.mag_cst_mgr_id, o.mag_cst_mgr_id) as mag_cst_mgr_id -- 管户人ID
    ,nvl(n.fail_reason, o.fail_reason) as fail_reason -- 
    ,nvl(n.bach_no, o.bach_no) as bach_no -- 
    ,nvl(n.date1, o.date1) as date1 -- 
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 
    ,nvl(n.querter, o.querter) as querter -- 季度
    ,nvl(n.is_exception_of_phone, o.is_exception_of_phone) as is_exception_of_phone -- 手机号是否异常
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.alss_am_outside_business_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.alss_am_outside_business_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.bach_date <> n.bach_date
        or o.acct_no <> n.acct_no
        or o.card_id <> n.card_id
        or o.acct_name <> n.acct_name
        or o.open_acct_organ <> n.open_acct_organ
        or o.approve_result <> n.approve_result
        or o.approve_date <> n.approve_date
        or o.upload_date <> n.upload_date
        or o.jx_money <> n.jx_money
        or o.open_acct_date <> n.open_acct_date
        or o.bd_date <> n.bd_date
        or o.jx_date <> n.jx_date
        or o.old_trans_date <> n.old_trans_date
        or o.one_acct_num <> n.one_acct_num
        or o.is_iden_date <> n.is_iden_date
        or o.nine_info <> n.nine_info
        or o.gg_person <> n.gg_person
        or o.gh_person <> n.gh_person
        or o.last_aum <> n.last_aum
        or o.cus_wealth_level <> n.cus_wealth_level
        or o.last_quarter_approve <> n.last_quarter_approve
        or o.last_quarter_ncbs_approve <> n.last_quarter_ncbs_approve
        or o.data_type <> n.data_type
        or o.acct_seq_no <> n.acct_seq_no
        or o.sys_user_id <> n.sys_user_id
        or o.mag_cst_mgr_id <> n.mag_cst_mgr_id
        or o.fail_reason <> n.fail_reason
        or o.bach_no <> n.bach_no
        or o.date1 <> n.date1
        or o.cust_id <> n.cust_id
        or o.querter <> n.querter
        or o.is_exception_of_phone <> n.is_exception_of_phone
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.alss_am_outside_business_tb_cl(
            id -- ID
            ,bach_date -- 批次年月
            ,acct_no -- 账号
            ,card_id -- 卡号
            ,acct_name -- 户名
            ,open_acct_organ -- 开户机构
            ,approve_result -- 审批结果
            ,approve_date -- 审批日期
            ,upload_date -- 上传日志
            ,jx_money -- 久悬金额
            ,open_acct_date -- 开户日期
            ,bd_date -- 设置不动户日期
            ,jx_date -- 设置久悬户日期
            ,old_trans_date -- 上一次主动交易日期
            ,one_acct_num -- 一人多户数量
            ,is_iden_date -- 是否证件过期（0-否，1-是）
            ,nine_info -- 9要素是否齐全
            ,gg_person -- 共管人
            ,gh_person -- 管户人
            ,last_aum -- 上季度AUM
            ,cus_wealth_level -- 客户财富等级
            ,last_quarter_approve -- 上季度审批情况
            ,last_quarter_ncbs_approve -- 上季度核心处理结果
            ,data_type -- 数据类型
            ,acct_seq_no -- 账户子账号
            ,sys_user_id -- 共管人ID
            ,mag_cst_mgr_id -- 管户人ID
            ,fail_reason -- 
            ,bach_no -- 
            ,date1 -- 
            ,cust_id -- 
            ,querter -- 季度
            ,is_exception_of_phone -- 手机号是否异常
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.alss_am_outside_business_tb_op(
            id -- ID
            ,bach_date -- 批次年月
            ,acct_no -- 账号
            ,card_id -- 卡号
            ,acct_name -- 户名
            ,open_acct_organ -- 开户机构
            ,approve_result -- 审批结果
            ,approve_date -- 审批日期
            ,upload_date -- 上传日志
            ,jx_money -- 久悬金额
            ,open_acct_date -- 开户日期
            ,bd_date -- 设置不动户日期
            ,jx_date -- 设置久悬户日期
            ,old_trans_date -- 上一次主动交易日期
            ,one_acct_num -- 一人多户数量
            ,is_iden_date -- 是否证件过期（0-否，1-是）
            ,nine_info -- 9要素是否齐全
            ,gg_person -- 共管人
            ,gh_person -- 管户人
            ,last_aum -- 上季度AUM
            ,cus_wealth_level -- 客户财富等级
            ,last_quarter_approve -- 上季度审批情况
            ,last_quarter_ncbs_approve -- 上季度核心处理结果
            ,data_type -- 数据类型
            ,acct_seq_no -- 账户子账号
            ,sys_user_id -- 共管人ID
            ,mag_cst_mgr_id -- 管户人ID
            ,fail_reason -- 
            ,bach_no -- 
            ,date1 -- 
            ,cust_id -- 
            ,querter -- 季度
            ,is_exception_of_phone -- 手机号是否异常
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.bach_date -- 批次年月
    ,o.acct_no -- 账号
    ,o.card_id -- 卡号
    ,o.acct_name -- 户名
    ,o.open_acct_organ -- 开户机构
    ,o.approve_result -- 审批结果
    ,o.approve_date -- 审批日期
    ,o.upload_date -- 上传日志
    ,o.jx_money -- 久悬金额
    ,o.open_acct_date -- 开户日期
    ,o.bd_date -- 设置不动户日期
    ,o.jx_date -- 设置久悬户日期
    ,o.old_trans_date -- 上一次主动交易日期
    ,o.one_acct_num -- 一人多户数量
    ,o.is_iden_date -- 是否证件过期（0-否，1-是）
    ,o.nine_info -- 9要素是否齐全
    ,o.gg_person -- 共管人
    ,o.gh_person -- 管户人
    ,o.last_aum -- 上季度AUM
    ,o.cus_wealth_level -- 客户财富等级
    ,o.last_quarter_approve -- 上季度审批情况
    ,o.last_quarter_ncbs_approve -- 上季度核心处理结果
    ,o.data_type -- 数据类型
    ,o.acct_seq_no -- 账户子账号
    ,o.sys_user_id -- 共管人ID
    ,o.mag_cst_mgr_id -- 管户人ID
    ,o.fail_reason -- 
    ,o.bach_no -- 
    ,o.date1 -- 
    ,o.cust_id -- 
    ,o.querter -- 季度
    ,o.is_exception_of_phone -- 手机号是否异常
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
from ${iol_schema}.alss_am_outside_business_tb_bk o
    left join ${iol_schema}.alss_am_outside_business_tb_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.alss_am_outside_business_tb_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.alss_am_outside_business_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('alss_am_outside_business_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.alss_am_outside_business_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.alss_am_outside_business_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.alss_am_outside_business_tb exchange partition p_${batch_date} with table ${iol_schema}.alss_am_outside_business_tb_cl;
alter table ${iol_schema}.alss_am_outside_business_tb exchange partition p_20991231 with table ${iol_schema}.alss_am_outside_business_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alss_am_outside_business_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.alss_am_outside_business_tb_op purge;
drop table ${iol_schema}.alss_am_outside_business_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.alss_am_outside_business_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alss_am_outside_business_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
