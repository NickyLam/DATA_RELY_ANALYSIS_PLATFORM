/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_branch_change
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
create table ${iol_schema}.ncbs_tb_branch_change_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_branch_change
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_branch_change_op purge;
drop table ${iol_schema}.ncbs_tb_branch_change_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_branch_change_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_branch_change where 0=1;

create table ${iol_schema}.ncbs_tb_branch_change_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_branch_change where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_branch_change_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_type -- 客户类型
            ,file_name -- 文件名称
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,amend_seq_no -- 变更序号
            ,batch_no -- 批次号
            ,branch_change_flag -- 机构变更处理标志
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,narrative -- 摘要
            ,system_id -- 系统id
            ,effect_date -- 产品生效日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,dest_branch_no -- 目标机构编号
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,tran_branch -- 核心交易机构编号
            ,update_user_id -- 修改柜员
            ,branch_change_type -- 机构撤并交易类型
            ,change_custody_item_flag -- 是否转移代保管物品
            ,change_user_flag -- 是否转移柜员
            ,old_branch_name -- 转出机构名称
            ,retain_old_branch_flag -- 是否保留转出机构
            ,new_branch_name -- 转入机构名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_branch_change_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_type -- 客户类型
            ,file_name -- 文件名称
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,amend_seq_no -- 变更序号
            ,batch_no -- 批次号
            ,branch_change_flag -- 机构变更处理标志
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,narrative -- 摘要
            ,system_id -- 系统id
            ,effect_date -- 产品生效日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,dest_branch_no -- 目标机构编号
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,tran_branch -- 核心交易机构编号
            ,update_user_id -- 修改柜员
            ,branch_change_type -- 机构撤并交易类型
            ,change_custody_item_flag -- 是否转移代保管物品
            ,change_user_flag -- 是否转移柜员
            ,old_branch_name -- 转出机构名称
            ,retain_old_branch_flag -- 是否保留转出机构
            ,new_branch_name -- 转入机构名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.file_name, o.file_name) as file_name -- 文件名称
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.amend_seq_no, o.amend_seq_no) as amend_seq_no -- 变更序号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.branch_change_flag, o.branch_change_flag) as branch_change_flag -- 机构变更处理标志
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.system_id, o.system_id) as system_id -- 系统id
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.dest_branch_no, o.dest_branch_no) as dest_branch_no -- 目标机构编号
    ,nvl(n.new_branch, o.new_branch) as new_branch -- 变更后机构
    ,nvl(n.old_branch, o.old_branch) as old_branch -- 变更前机构
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.update_user_id, o.update_user_id) as update_user_id -- 修改柜员
    ,nvl(n.branch_change_type, o.branch_change_type) as branch_change_type -- 机构撤并交易类型
    ,nvl(n.change_custody_item_flag, o.change_custody_item_flag) as change_custody_item_flag -- 是否转移代保管物品
    ,nvl(n.change_user_flag, o.change_user_flag) as change_user_flag -- 是否转移柜员
    ,nvl(n.old_branch_name, o.old_branch_name) as old_branch_name -- 转出机构名称
    ,nvl(n.retain_old_branch_flag, o.retain_old_branch_flag) as retain_old_branch_flag -- 是否保留转出机构
    ,nvl(n.new_branch_name, o.new_branch_name) as new_branch_name -- 转入机构名称
    ,case when
            n.amend_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.amend_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.amend_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_branch_change_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_branch_change where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.amend_seq_no = n.amend_seq_no
where (
        o.amend_seq_no is null
    )
    or (
        n.amend_seq_no is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.ccy <> n.ccy
        or o.client_type <> n.client_type
        or o.file_name <> n.file_name
        or o.prod_type <> n.prod_type
        or o.reference <> n.reference
        or o.user_id <> n.user_id
        or o.batch_no <> n.batch_no
        or o.branch_change_flag <> n.branch_change_flag
        or o.channel_seq_no <> n.channel_seq_no
        or o.company <> n.company
        or o.narrative <> n.narrative
        or o.system_id <> n.system_id
        or o.effect_date <> n.effect_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.dest_branch_no <> n.dest_branch_no
        or o.new_branch <> n.new_branch
        or o.old_branch <> n.old_branch
        or o.tran_branch <> n.tran_branch
        or o.update_user_id <> n.update_user_id
        or o.branch_change_type <> n.branch_change_type
        or o.change_custody_item_flag <> n.change_custody_item_flag
        or o.change_user_flag <> n.change_user_flag
        or o.old_branch_name <> n.old_branch_name
        or o.retain_old_branch_flag <> n.retain_old_branch_flag
        or o.new_branch_name <> n.new_branch_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_branch_change_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_type -- 客户类型
            ,file_name -- 文件名称
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,amend_seq_no -- 变更序号
            ,batch_no -- 批次号
            ,branch_change_flag -- 机构变更处理标志
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,narrative -- 摘要
            ,system_id -- 系统id
            ,effect_date -- 产品生效日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,dest_branch_no -- 目标机构编号
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,tran_branch -- 核心交易机构编号
            ,update_user_id -- 修改柜员
            ,branch_change_type -- 机构撤并交易类型
            ,change_custody_item_flag -- 是否转移代保管物品
            ,change_user_flag -- 是否转移柜员
            ,old_branch_name -- 转出机构名称
            ,retain_old_branch_flag -- 是否保留转出机构
            ,new_branch_name -- 转入机构名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_branch_change_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_type -- 客户类型
            ,file_name -- 文件名称
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,amend_seq_no -- 变更序号
            ,batch_no -- 批次号
            ,branch_change_flag -- 机构变更处理标志
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,narrative -- 摘要
            ,system_id -- 系统id
            ,effect_date -- 产品生效日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,dest_branch_no -- 目标机构编号
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,tran_branch -- 核心交易机构编号
            ,update_user_id -- 修改柜员
            ,branch_change_type -- 机构撤并交易类型
            ,change_custody_item_flag -- 是否转移代保管物品
            ,change_user_flag -- 是否转移柜员
            ,old_branch_name -- 转出机构名称
            ,retain_old_branch_flag -- 是否保留转出机构
            ,new_branch_name -- 转入机构名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.ccy -- 币种
    ,o.client_type -- 客户类型
    ,o.file_name -- 文件名称
    ,o.prod_type -- 产品编号
    ,o.reference -- 交易参考号
    ,o.user_id -- 交易柜员编号
    ,o.amend_seq_no -- 变更序号
    ,o.batch_no -- 批次号
    ,o.branch_change_flag -- 机构变更处理标志
    ,o.channel_seq_no -- 全局流水号
    ,o.company -- 法人
    ,o.narrative -- 摘要
    ,o.system_id -- 系统id
    ,o.effect_date -- 产品生效日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.dest_branch_no -- 目标机构编号
    ,o.new_branch -- 变更后机构
    ,o.old_branch -- 变更前机构
    ,o.tran_branch -- 核心交易机构编号
    ,o.update_user_id -- 修改柜员
    ,o.branch_change_type -- 机构撤并交易类型
    ,o.change_custody_item_flag -- 是否转移代保管物品
    ,o.change_user_flag -- 是否转移柜员
    ,o.old_branch_name -- 转出机构名称
    ,o.retain_old_branch_flag -- 是否保留转出机构
    ,o.new_branch_name -- 转入机构名称
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
from ${iol_schema}.ncbs_tb_branch_change_bk o
    left join ${iol_schema}.ncbs_tb_branch_change_op n
        on
            o.amend_seq_no = n.amend_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_branch_change_cl d
        on
            o.amend_seq_no = d.amend_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_branch_change;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_branch_change') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_branch_change drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_branch_change add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_branch_change exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_branch_change_cl;
alter table ${iol_schema}.ncbs_tb_branch_change exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_branch_change_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_branch_change to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_branch_change_op purge;
drop table ${iol_schema}.ncbs_tb_branch_change_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_branch_change_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_branch_change',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
