/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cd_make_card_reg
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
create table ${iol_schema}.ncbs_cd_make_card_reg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cd_make_card_reg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cd_make_card_reg_op purge;
drop table ${iol_schema}.ncbs_cd_make_card_reg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_make_card_reg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cd_make_card_reg where 0=1;

create table ${iol_schema}.ncbs_cd_make_card_reg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cd_make_card_reg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cd_make_card_reg_cl(
            area_code -- 地区码
            ,doc_type -- 凭证类型
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_apply_type -- 制卡申请类型
            ,card_num -- 制卡数量
            ,company -- 法人
            ,gain_type -- 卡片领取方式
            ,lucky_card_flag -- 是否吉祥卡
            ,make_card_type -- 制卡类型
            ,make_cd_status -- 制卡状态
            ,apply_date -- 申请日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,pick_type -- 选号类型
            ,receive_flag -- 签收标志
            ,make_card_date -- 制卡日期
            ,card_provider -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cd_make_card_reg_op(
            area_code -- 地区码
            ,doc_type -- 凭证类型
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_apply_type -- 制卡申请类型
            ,card_num -- 制卡数量
            ,company -- 法人
            ,gain_type -- 卡片领取方式
            ,lucky_card_flag -- 是否吉祥卡
            ,make_card_type -- 制卡类型
            ,make_cd_status -- 制卡状态
            ,apply_date -- 申请日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,pick_type -- 选号类型
            ,receive_flag -- 签收标志
            ,make_card_date -- 制卡日期
            ,card_provider -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.area_code, o.area_code) as area_code -- 地区码
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.apply_no, o.apply_no) as apply_no -- 申请编号
    ,nvl(n.batch_job_no, o.batch_job_no) as batch_job_no -- 制卡文件批次号
    ,nvl(n.card_apply_type, o.card_apply_type) as card_apply_type -- 制卡申请类型
    ,nvl(n.card_num, o.card_num) as card_num -- 制卡数量
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.gain_type, o.gain_type) as gain_type -- 卡片领取方式
    ,nvl(n.lucky_card_flag, o.lucky_card_flag) as lucky_card_flag -- 是否吉祥卡
    ,nvl(n.make_card_type, o.make_card_type) as make_card_type -- 制卡类型
    ,nvl(n.make_cd_status, o.make_cd_status) as make_cd_status -- 制卡状态
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 申请日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.pick_type, o.pick_type) as pick_type -- 选号类型
    ,nvl(n.receive_flag, o.receive_flag) as receive_flag -- 签收标志
    ,nvl(n.make_card_date, o.make_card_date) as make_card_date -- 制卡日期
    ,nvl(n.card_provider, o.card_provider) as card_provider -- 
    ,case when
            n.apply_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.apply_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.apply_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cd_make_card_reg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cd_make_card_reg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.apply_no = n.apply_no
where (
        o.apply_no is null
    )
    or (
        n.apply_no is null
    )
    or (
        o.area_code <> n.area_code
        or o.doc_type <> n.doc_type
        or o.prod_type <> n.prod_type
        or o.remark <> n.remark
        or o.user_id <> n.user_id
        or o.batch_job_no <> n.batch_job_no
        or o.card_apply_type <> n.card_apply_type
        or o.card_num <> n.card_num
        or o.company <> n.company
        or o.gain_type <> n.gain_type
        or o.lucky_card_flag <> n.lucky_card_flag
        or o.make_card_type <> n.make_card_type
        or o.make_cd_status <> n.make_cd_status
        or o.apply_date <> n.apply_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.tran_branch <> n.tran_branch
        or o.pick_type <> n.pick_type
        or o.receive_flag <> n.receive_flag
        or o.make_card_date <> n.make_card_date
        or o.card_provider <> n.card_provider
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cd_make_card_reg_cl(
            area_code -- 地区码
            ,doc_type -- 凭证类型
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_apply_type -- 制卡申请类型
            ,card_num -- 制卡数量
            ,company -- 法人
            ,gain_type -- 卡片领取方式
            ,lucky_card_flag -- 是否吉祥卡
            ,make_card_type -- 制卡类型
            ,make_cd_status -- 制卡状态
            ,apply_date -- 申请日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,pick_type -- 选号类型
            ,receive_flag -- 签收标志
            ,make_card_date -- 制卡日期
            ,card_provider -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cd_make_card_reg_op(
            area_code -- 地区码
            ,doc_type -- 凭证类型
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_apply_type -- 制卡申请类型
            ,card_num -- 制卡数量
            ,company -- 法人
            ,gain_type -- 卡片领取方式
            ,lucky_card_flag -- 是否吉祥卡
            ,make_card_type -- 制卡类型
            ,make_cd_status -- 制卡状态
            ,apply_date -- 申请日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,pick_type -- 选号类型
            ,receive_flag -- 签收标志
            ,make_card_date -- 制卡日期
            ,card_provider -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.area_code -- 地区码
    ,o.doc_type -- 凭证类型
    ,o.prod_type -- 产品编号
    ,o.remark -- 备注
    ,o.user_id -- 交易柜员编号
    ,o.apply_no -- 申请编号
    ,o.batch_job_no -- 制卡文件批次号
    ,o.card_apply_type -- 制卡申请类型
    ,o.card_num -- 制卡数量
    ,o.company -- 法人
    ,o.gain_type -- 卡片领取方式
    ,o.lucky_card_flag -- 是否吉祥卡
    ,o.make_card_type -- 制卡类型
    ,o.make_cd_status -- 制卡状态
    ,o.apply_date -- 申请日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.tran_branch -- 核心交易机构编号
    ,o.pick_type -- 选号类型
    ,o.receive_flag -- 签收标志
    ,o.make_card_date -- 制卡日期
    ,o.card_provider -- 
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
from ${iol_schema}.ncbs_cd_make_card_reg_bk o
    left join ${iol_schema}.ncbs_cd_make_card_reg_op n
        on
            o.apply_no = n.apply_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cd_make_card_reg_cl d
        on
            o.apply_no = d.apply_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cd_make_card_reg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cd_make_card_reg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cd_make_card_reg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cd_make_card_reg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cd_make_card_reg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cd_make_card_reg_cl;
alter table ${iol_schema}.ncbs_cd_make_card_reg exchange partition p_20991231 with table ${iol_schema}.ncbs_cd_make_card_reg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cd_make_card_reg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cd_make_card_reg_op purge;
drop table ${iol_schema}.ncbs_cd_make_card_reg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cd_make_card_reg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cd_make_card_reg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
