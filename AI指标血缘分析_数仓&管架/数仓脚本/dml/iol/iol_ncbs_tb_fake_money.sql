/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_fake_money
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
create table ${iol_schema}.ncbs_tb_fake_money_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_fake_money
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_fake_money_op purge;
drop table ${iol_schema}.ncbs_tb_fake_money_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_fake_money_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_fake_money where 0=1;

create table ${iol_schema}.ncbs_tb_fake_money_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_fake_money where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_fake_money_cl(
            ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,remark -- 备注
            ,bond_number -- 套数
            ,bond_version_num -- 版别
            ,company -- 法人
            ,fake_ccy_no -- 假币冠字号码
            ,fake_money_status -- 假币状态
            ,fake_num -- 假币张数
            ,make_type -- 制作方式
            ,par_value_id -- 券别代码
            ,seq_no -- 序号
            ,turn_over_branch -- 上缴人行机构
            ,capture_date -- 收缴日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,belong_user_id -- 所属柜员
            ,capture_branch -- 收缴机构
            ,capture_user_id -- 收缴柜员
            ,fake_amt -- 假币账面金额
            ,holder_global_id -- 持有人证件号码
            ,holder_global_type -- 持有人证件类型
            ,holder_name -- 持有人名称
            ,turn_over_date -- 上缴人行日期
            ,turn_over_user_id -- 上缴人行柜员
            ,belong_branch -- 归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_fake_money_op(
            ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,remark -- 备注
            ,bond_number -- 套数
            ,bond_version_num -- 版别
            ,company -- 法人
            ,fake_ccy_no -- 假币冠字号码
            ,fake_money_status -- 假币状态
            ,fake_num -- 假币张数
            ,make_type -- 制作方式
            ,par_value_id -- 券别代码
            ,seq_no -- 序号
            ,turn_over_branch -- 上缴人行机构
            ,capture_date -- 收缴日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,belong_user_id -- 所属柜员
            ,capture_branch -- 收缴机构
            ,capture_user_id -- 收缴柜员
            ,fake_amt -- 假币账面金额
            ,holder_global_id -- 持有人证件号码
            ,holder_global_type -- 持有人证件类型
            ,holder_name -- 持有人名称
            ,turn_over_date -- 上缴人行日期
            ,turn_over_user_id -- 上缴人行柜员
            ,belong_branch -- 归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.bond_number, o.bond_number) as bond_number -- 套数
    ,nvl(n.bond_version_num, o.bond_version_num) as bond_version_num -- 版别
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.fake_ccy_no, o.fake_ccy_no) as fake_ccy_no -- 假币冠字号码
    ,nvl(n.fake_money_status, o.fake_money_status) as fake_money_status -- 假币状态
    ,nvl(n.fake_num, o.fake_num) as fake_num -- 假币张数
    ,nvl(n.make_type, o.make_type) as make_type -- 制作方式
    ,nvl(n.par_value_id, o.par_value_id) as par_value_id -- 券别代码
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.turn_over_branch, o.turn_over_branch) as turn_over_branch -- 上缴人行机构
    ,nvl(n.capture_date, o.capture_date) as capture_date -- 收缴日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.belong_user_id, o.belong_user_id) as belong_user_id -- 所属柜员
    ,nvl(n.capture_branch, o.capture_branch) as capture_branch -- 收缴机构
    ,nvl(n.capture_user_id, o.capture_user_id) as capture_user_id -- 收缴柜员
    ,nvl(n.fake_amt, o.fake_amt) as fake_amt -- 假币账面金额
    ,nvl(n.holder_global_id, o.holder_global_id) as holder_global_id -- 持有人证件号码
    ,nvl(n.holder_global_type, o.holder_global_type) as holder_global_type -- 持有人证件类型
    ,nvl(n.holder_name, o.holder_name) as holder_name -- 持有人名称
    ,nvl(n.turn_over_date, o.turn_over_date) as turn_over_date -- 上缴人行日期
    ,nvl(n.turn_over_user_id, o.turn_over_user_id) as turn_over_user_id -- 上缴人行柜员
    ,nvl(n.belong_branch, o.belong_branch) as belong_branch -- 归属机构
    ,case when
            n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_fake_money_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_fake_money where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.ccy <> n.ccy
        or o.client_name <> n.client_name
        or o.client_no <> n.client_no
        or o.remark <> n.remark
        or o.bond_number <> n.bond_number
        or o.bond_version_num <> n.bond_version_num
        or o.company <> n.company
        or o.fake_ccy_no <> n.fake_ccy_no
        or o.fake_money_status <> n.fake_money_status
        or o.fake_num <> n.fake_num
        or o.make_type <> n.make_type
        or o.par_value_id <> n.par_value_id
        or o.turn_over_branch <> n.turn_over_branch
        or o.capture_date <> n.capture_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.auth_user_id <> n.auth_user_id
        or o.belong_user_id <> n.belong_user_id
        or o.capture_branch <> n.capture_branch
        or o.capture_user_id <> n.capture_user_id
        or o.fake_amt <> n.fake_amt
        or o.holder_global_id <> n.holder_global_id
        or o.holder_global_type <> n.holder_global_type
        or o.holder_name <> n.holder_name
        or o.turn_over_date <> n.turn_over_date
        or o.turn_over_user_id <> n.turn_over_user_id
        or o.belong_branch <> n.belong_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_fake_money_cl(
            ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,remark -- 备注
            ,bond_number -- 套数
            ,bond_version_num -- 版别
            ,company -- 法人
            ,fake_ccy_no -- 假币冠字号码
            ,fake_money_status -- 假币状态
            ,fake_num -- 假币张数
            ,make_type -- 制作方式
            ,par_value_id -- 券别代码
            ,seq_no -- 序号
            ,turn_over_branch -- 上缴人行机构
            ,capture_date -- 收缴日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,belong_user_id -- 所属柜员
            ,capture_branch -- 收缴机构
            ,capture_user_id -- 收缴柜员
            ,fake_amt -- 假币账面金额
            ,holder_global_id -- 持有人证件号码
            ,holder_global_type -- 持有人证件类型
            ,holder_name -- 持有人名称
            ,turn_over_date -- 上缴人行日期
            ,turn_over_user_id -- 上缴人行柜员
            ,belong_branch -- 归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_fake_money_op(
            ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,remark -- 备注
            ,bond_number -- 套数
            ,bond_version_num -- 版别
            ,company -- 法人
            ,fake_ccy_no -- 假币冠字号码
            ,fake_money_status -- 假币状态
            ,fake_num -- 假币张数
            ,make_type -- 制作方式
            ,par_value_id -- 券别代码
            ,seq_no -- 序号
            ,turn_over_branch -- 上缴人行机构
            ,capture_date -- 收缴日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,belong_user_id -- 所属柜员
            ,capture_branch -- 收缴机构
            ,capture_user_id -- 收缴柜员
            ,fake_amt -- 假币账面金额
            ,holder_global_id -- 持有人证件号码
            ,holder_global_type -- 持有人证件类型
            ,holder_name -- 持有人名称
            ,turn_over_date -- 上缴人行日期
            ,turn_over_user_id -- 上缴人行柜员
            ,belong_branch -- 归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.client_name -- 客户名称
    ,o.client_no -- 客户编号
    ,o.remark -- 备注
    ,o.bond_number -- 套数
    ,o.bond_version_num -- 版别
    ,o.company -- 法人
    ,o.fake_ccy_no -- 假币冠字号码
    ,o.fake_money_status -- 假币状态
    ,o.fake_num -- 假币张数
    ,o.make_type -- 制作方式
    ,o.par_value_id -- 券别代码
    ,o.seq_no -- 序号
    ,o.turn_over_branch -- 上缴人行机构
    ,o.capture_date -- 收缴日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.auth_user_id -- 授权柜员
    ,o.belong_user_id -- 所属柜员
    ,o.capture_branch -- 收缴机构
    ,o.capture_user_id -- 收缴柜员
    ,o.fake_amt -- 假币账面金额
    ,o.holder_global_id -- 持有人证件号码
    ,o.holder_global_type -- 持有人证件类型
    ,o.holder_name -- 持有人名称
    ,o.turn_over_date -- 上缴人行日期
    ,o.turn_over_user_id -- 上缴人行柜员
    ,o.belong_branch -- 归属机构
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
from ${iol_schema}.ncbs_tb_fake_money_bk o
    left join ${iol_schema}.ncbs_tb_fake_money_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_fake_money_cl d
        on
            o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_fake_money;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_fake_money') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_fake_money drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_fake_money add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_fake_money exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_fake_money_cl;
alter table ${iol_schema}.ncbs_tb_fake_money exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_fake_money_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_fake_money to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_fake_money_op purge;
drop table ${iol_schema}.ncbs_tb_fake_money_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_fake_money_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_fake_money',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
