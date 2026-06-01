/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_agreement
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
create table ${iol_schema}.ncbs_cl_agreement_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_agreement
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_agreement_op purge;
drop table ${iol_schema}.ncbs_cl_agreement_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_agreement_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_agreement where 0=1;

create table ${iol_schema}.ncbs_cl_agreement_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_agreement where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_agreement_cl(
            acct_name -- 账户名称
            ,branch -- 机构编号
            ,card_no -- 卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_short -- 客户简称
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_class -- 协议分类
            ,agreement_close_acct_flag -- 签约后是否允许销户
            ,agreement_id -- 协议编号
            ,agreement_key -- 协议键值
            ,agreement_key_type -- 协议键类型
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,out_sign_channel -- 解约渠道
            ,sex -- 性别
            ,sign_channel -- 签约渠道
            ,agreement_open_date -- 协议签订日期
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,out_sign_date -- 解约日期
            ,sign_date -- 签约日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,agre_prod_type -- 签约主产品类型
            ,agreement_amt -- 协议金额
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,opposite_internal_key -- 签约对方账户内部键
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_agreement_op(
            acct_name -- 账户名称
            ,branch -- 机构编号
            ,card_no -- 卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_short -- 客户简称
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_class -- 协议分类
            ,agreement_close_acct_flag -- 签约后是否允许销户
            ,agreement_id -- 协议编号
            ,agreement_key -- 协议键值
            ,agreement_key_type -- 协议键类型
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,out_sign_channel -- 解约渠道
            ,sex -- 性别
            ,sign_channel -- 签约渠道
            ,agreement_open_date -- 协议签订日期
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,out_sign_date -- 解约日期
            ,sign_date -- 签约日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,agre_prod_type -- 签约主产品类型
            ,agreement_amt -- 协议金额
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,opposite_internal_key -- 签约对方账户内部键
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_short, o.client_short) as client_short -- 客户简称
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.agreement_class, o.agreement_class) as agreement_class -- 协议分类
    ,nvl(n.agreement_close_acct_flag, o.agreement_close_acct_flag) as agreement_close_acct_flag -- 签约后是否允许销户
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_key, o.agreement_key) as agreement_key -- 协议键值
    ,nvl(n.agreement_key_type, o.agreement_key_type) as agreement_key_type -- 协议键类型
    ,nvl(n.agreement_status, o.agreement_status) as agreement_status -- 协议状态
    ,nvl(n.agreement_type, o.agreement_type) as agreement_type -- 协议类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.out_sign_channel, o.out_sign_channel) as out_sign_channel -- 解约渠道
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.sign_channel, o.sign_channel) as sign_channel -- 签约渠道
    ,nvl(n.agreement_open_date, o.agreement_open_date) as agreement_open_date -- 协议签订日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.out_sign_date, o.out_sign_date) as out_sign_date -- 解约日期
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 签约日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.agre_prod_type, o.agre_prod_type) as agre_prod_type -- 签约主产品类型
    ,nvl(n.agreement_amt, o.agreement_amt) as agreement_amt -- 协议金额
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.opposite_internal_key, o.opposite_internal_key) as opposite_internal_key -- 签约对方账户内部键
    ,nvl(n.out_sign_branch, o.out_sign_branch) as out_sign_branch -- 解约机构
    ,nvl(n.out_sign_user_id, o.out_sign_user_id) as out_sign_user_id -- 解约柜员
    ,nvl(n.sign_branch, o.sign_branch) as sign_branch -- 签约机构
    ,nvl(n.sign_user_id, o.sign_user_id) as sign_user_id -- 签约柜员
    ,case when
            n.agreement_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agreement_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agreement_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_agreement_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_agreement where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
where (
        o.agreement_id is null
    )
    or (
        n.agreement_id is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.branch <> n.branch
        or o.card_no <> n.card_no
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.client_short <> n.client_short
        or o.dd_no <> n.dd_no
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.agreement_class <> n.agreement_class
        or o.agreement_close_acct_flag <> n.agreement_close_acct_flag
        or o.agreement_key <> n.agreement_key
        or o.agreement_key_type <> n.agreement_key_type
        or o.agreement_status <> n.agreement_status
        or o.agreement_type <> n.agreement_type
        or o.company <> n.company
        or o.out_sign_channel <> n.out_sign_channel
        or o.sex <> n.sex
        or o.sign_channel <> n.sign_channel
        or o.agreement_open_date <> n.agreement_open_date
        or o.end_date <> n.end_date
        or o.last_change_date <> n.last_change_date
        or o.out_sign_date <> n.out_sign_date
        or o.sign_date <> n.sign_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.agre_prod_type <> n.agre_prod_type
        or o.agreement_amt <> n.agreement_amt
        or o.last_change_user_id <> n.last_change_user_id
        or o.loan_no <> n.loan_no
        or o.opposite_internal_key <> n.opposite_internal_key
        or o.out_sign_branch <> n.out_sign_branch
        or o.out_sign_user_id <> n.out_sign_user_id
        or o.sign_branch <> n.sign_branch
        or o.sign_user_id <> n.sign_user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_agreement_cl(
            acct_name -- 账户名称
            ,branch -- 机构编号
            ,card_no -- 卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_short -- 客户简称
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_class -- 协议分类
            ,agreement_close_acct_flag -- 签约后是否允许销户
            ,agreement_id -- 协议编号
            ,agreement_key -- 协议键值
            ,agreement_key_type -- 协议键类型
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,out_sign_channel -- 解约渠道
            ,sex -- 性别
            ,sign_channel -- 签约渠道
            ,agreement_open_date -- 协议签订日期
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,out_sign_date -- 解约日期
            ,sign_date -- 签约日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,agre_prod_type -- 签约主产品类型
            ,agreement_amt -- 协议金额
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,opposite_internal_key -- 签约对方账户内部键
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_agreement_op(
            acct_name -- 账户名称
            ,branch -- 机构编号
            ,card_no -- 卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_short -- 客户简称
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_class -- 协议分类
            ,agreement_close_acct_flag -- 签约后是否允许销户
            ,agreement_id -- 协议编号
            ,agreement_key -- 协议键值
            ,agreement_key_type -- 协议键类型
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,out_sign_channel -- 解约渠道
            ,sex -- 性别
            ,sign_channel -- 签约渠道
            ,agreement_open_date -- 协议签订日期
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,out_sign_date -- 解约日期
            ,sign_date -- 签约日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,agre_prod_type -- 签约主产品类型
            ,agreement_amt -- 协议金额
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,opposite_internal_key -- 签约对方账户内部键
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.branch -- 机构编号
    ,o.card_no -- 卡号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.client_short -- 客户简称
    ,o.dd_no -- 发放号
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.agreement_class -- 协议分类
    ,o.agreement_close_acct_flag -- 签约后是否允许销户
    ,o.agreement_id -- 协议编号
    ,o.agreement_key -- 协议键值
    ,o.agreement_key_type -- 协议键类型
    ,o.agreement_status -- 协议状态
    ,o.agreement_type -- 协议类型
    ,o.company -- 法人
    ,o.out_sign_channel -- 解约渠道
    ,o.sex -- 性别
    ,o.sign_channel -- 签约渠道
    ,o.agreement_open_date -- 协议签订日期
    ,o.end_date -- 结束日期
    ,o.last_change_date -- 最后修改日期
    ,o.out_sign_date -- 解约日期
    ,o.sign_date -- 签约日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.agre_prod_type -- 签约主产品类型
    ,o.agreement_amt -- 协议金额
    ,o.last_change_user_id -- 最后修改柜员
    ,o.loan_no -- 贷款号
    ,o.opposite_internal_key -- 签约对方账户内部键
    ,o.out_sign_branch -- 解约机构
    ,o.out_sign_user_id -- 解约柜员
    ,o.sign_branch -- 签约机构
    ,o.sign_user_id -- 签约柜员
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
from ${iol_schema}.ncbs_cl_agreement_bk o
    left join ${iol_schema}.ncbs_cl_agreement_op n
        on
            o.agreement_id = n.agreement_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_agreement_cl d
        on
            o.agreement_id = d.agreement_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_agreement;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_agreement') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_agreement drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_agreement add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_agreement exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_agreement_cl;
alter table ${iol_schema}.ncbs_cl_agreement exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_agreement_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_agreement to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_agreement_op purge;
drop table ${iol_schema}.ncbs_cl_agreement_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_agreement_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_agreement',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
