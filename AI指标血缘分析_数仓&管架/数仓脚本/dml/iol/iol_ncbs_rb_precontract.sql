/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_precontract
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
create table ${iol_schema}.ncbs_rb_precontract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_precontract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_precontract_op purge;
drop table ${iol_schema}.ncbs_rb_precontract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_precontract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_precontract where 0=1;

create table ${iol_schema}.ncbs_rb_precontract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_precontract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_precontract_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,mobile_no -- 电话号码
            ,precontract_method -- 预约方式
            ,precontract_no -- 预约号
            ,precontract_status -- 期次产品预约状态
            ,precontract_type -- 预约登记的账户类型
            ,precontract_wtd_type -- 预约支取方式
            ,last_change_date -- 最后修改日期
            ,precontract_date -- 预约登记日期
            ,precontract_draw_date -- 取款日期
            ,tran_timestamp -- 交易时间戳
            ,precontract_amt -- 预约金额
            ,precontract_ccy -- 期次产品预约币种
            ,tran_branch -- 核心交易机构编号
            ,unlost_user_id -- 解挂柜员
            ,violate_adj -- 通知存款违约基数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_precontract_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,mobile_no -- 电话号码
            ,precontract_method -- 预约方式
            ,precontract_no -- 预约号
            ,precontract_status -- 期次产品预约状态
            ,precontract_type -- 预约登记的账户类型
            ,precontract_wtd_type -- 预约支取方式
            ,last_change_date -- 最后修改日期
            ,precontract_date -- 预约登记日期
            ,precontract_draw_date -- 取款日期
            ,tran_timestamp -- 交易时间戳
            ,precontract_amt -- 预约金额
            ,precontract_ccy -- 期次产品预约币种
            ,tran_branch -- 核心交易机构编号
            ,unlost_user_id -- 解挂柜员
            ,violate_adj -- 通知存款违约基数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 电话号码
    ,nvl(n.precontract_method, o.precontract_method) as precontract_method -- 预约方式
    ,nvl(n.precontract_no, o.precontract_no) as precontract_no -- 预约号
    ,nvl(n.precontract_status, o.precontract_status) as precontract_status -- 期次产品预约状态
    ,nvl(n.precontract_type, o.precontract_type) as precontract_type -- 预约登记的账户类型
    ,nvl(n.precontract_wtd_type, o.precontract_wtd_type) as precontract_wtd_type -- 预约支取方式
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.precontract_date, o.precontract_date) as precontract_date -- 预约登记日期
    ,nvl(n.precontract_draw_date, o.precontract_draw_date) as precontract_draw_date -- 取款日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.precontract_amt, o.precontract_amt) as precontract_amt -- 预约金额
    ,nvl(n.precontract_ccy, o.precontract_ccy) as precontract_ccy -- 期次产品预约币种
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.unlost_user_id, o.unlost_user_id) as unlost_user_id -- 解挂柜员
    ,nvl(n.violate_adj, o.violate_adj) as violate_adj -- 通知存款违约基数
    ,case when
            n.internal_key is null
            and n.precontract_no is null
            and n.precontract_draw_date is null
            and n.precontract_ccy is null
            and n.tran_branch is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.precontract_no is null
            and n.precontract_draw_date is null
            and n.precontract_ccy is null
            and n.tran_branch is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.precontract_no is null
            and n.precontract_draw_date is null
            and n.precontract_ccy is null
            and n.tran_branch is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_precontract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_precontract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.precontract_no = n.precontract_no
            and o.precontract_draw_date = n.precontract_draw_date
            and o.precontract_ccy = n.precontract_ccy
            and o.tran_branch = n.tran_branch
where (
        o.internal_key is null
        and o.precontract_no is null
        and o.precontract_draw_date is null
        and o.precontract_ccy is null
        and o.tran_branch is null
    )
    or (
        n.internal_key is null
        and n.precontract_no is null
        and n.precontract_draw_date is null
        and n.precontract_ccy is null
        and n.tran_branch is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.ccy <> n.ccy
        or o.client_name <> n.client_name
        or o.client_no <> n.client_no
        or o.client_type <> n.client_type
        or o.prod_type <> n.prod_type
        or o.reference <> n.reference
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.mobile_no <> n.mobile_no
        or o.precontract_method <> n.precontract_method
        or o.precontract_status <> n.precontract_status
        or o.precontract_type <> n.precontract_type
        or o.precontract_wtd_type <> n.precontract_wtd_type
        or o.last_change_date <> n.last_change_date
        or o.precontract_date <> n.precontract_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.precontract_amt <> n.precontract_amt
        or o.unlost_user_id <> n.unlost_user_id
        or o.violate_adj <> n.violate_adj
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_precontract_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,mobile_no -- 电话号码
            ,precontract_method -- 预约方式
            ,precontract_no -- 预约号
            ,precontract_status -- 期次产品预约状态
            ,precontract_type -- 预约登记的账户类型
            ,precontract_wtd_type -- 预约支取方式
            ,last_change_date -- 最后修改日期
            ,precontract_date -- 预约登记日期
            ,precontract_draw_date -- 取款日期
            ,tran_timestamp -- 交易时间戳
            ,precontract_amt -- 预约金额
            ,precontract_ccy -- 期次产品预约币种
            ,tran_branch -- 核心交易机构编号
            ,unlost_user_id -- 解挂柜员
            ,violate_adj -- 通知存款违约基数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_precontract_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,mobile_no -- 电话号码
            ,precontract_method -- 预约方式
            ,precontract_no -- 预约号
            ,precontract_status -- 期次产品预约状态
            ,precontract_type -- 预约登记的账户类型
            ,precontract_wtd_type -- 预约支取方式
            ,last_change_date -- 最后修改日期
            ,precontract_date -- 预约登记日期
            ,precontract_draw_date -- 取款日期
            ,tran_timestamp -- 交易时间戳
            ,precontract_amt -- 预约金额
            ,precontract_ccy -- 期次产品预约币种
            ,tran_branch -- 核心交易机构编号
            ,unlost_user_id -- 解挂柜员
            ,violate_adj -- 通知存款违约基数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.ccy -- 币种
    ,o.client_name -- 客户名称
    ,o.client_no -- 客户编号
    ,o.client_type -- 客户类型
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.reference -- 交易参考号
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.mobile_no -- 电话号码
    ,o.precontract_method -- 预约方式
    ,o.precontract_no -- 预约号
    ,o.precontract_status -- 期次产品预约状态
    ,o.precontract_type -- 预约登记的账户类型
    ,o.precontract_wtd_type -- 预约支取方式
    ,o.last_change_date -- 最后修改日期
    ,o.precontract_date -- 预约登记日期
    ,o.precontract_draw_date -- 取款日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.precontract_amt -- 预约金额
    ,o.precontract_ccy -- 期次产品预约币种
    ,o.tran_branch -- 核心交易机构编号
    ,o.unlost_user_id -- 解挂柜员
    ,o.violate_adj -- 通知存款违约基数
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
from ${iol_schema}.ncbs_rb_precontract_bk o
    left join ${iol_schema}.ncbs_rb_precontract_op n
        on
            o.internal_key = n.internal_key
            and o.precontract_no = n.precontract_no
            and o.precontract_draw_date = n.precontract_draw_date
            and o.precontract_ccy = n.precontract_ccy
            and o.tran_branch = n.tran_branch
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_precontract_cl d
        on
            o.internal_key = d.internal_key
            and o.precontract_no = d.precontract_no
            and o.precontract_draw_date = d.precontract_draw_date
            and o.precontract_ccy = d.precontract_ccy
            and o.tran_branch = d.tran_branch
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_precontract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_precontract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_precontract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_precontract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_precontract exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_precontract_cl;
alter table ${iol_schema}.ncbs_rb_precontract exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_precontract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_precontract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_precontract_op purge;
drop table ${iol_schema}.ncbs_rb_precontract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_precontract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_precontract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
