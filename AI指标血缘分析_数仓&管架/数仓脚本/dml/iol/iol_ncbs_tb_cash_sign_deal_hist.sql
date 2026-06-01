/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_cash_sign_deal_hist
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
create table ${iol_schema}.ncbs_tb_cash_sign_deal_hist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_cash_sign_deal_hist
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_cash_sign_deal_hist_op purge;
drop table ${iol_schema}.ncbs_tb_cash_sign_deal_hist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_sign_deal_hist_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_cash_sign_deal_hist where 0=1;

create table ${iol_schema}.ncbs_tb_cash_sign_deal_hist_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_cash_sign_deal_hist where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_cash_sign_deal_hist_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,cash_from_to -- 资金去向来源
            ,cash_item -- 现金项目
            ,cash_sign_type -- 长短款标记
            ,cash_sign_id -- 现金长短款汇总编号
            ,cash_sign_no -- 长短款明细编号
            ,company -- 法人
            ,narrative -- 摘要
            ,cash_sign_deal_no -- 长短款明细处理序号
            ,reserve_flag -- 冲正标志
            ,seq_no -- 序号
            ,effect_date -- 产品生效日期
            ,cash_sign_deal_date -- 长短钞处理日期
            ,reversal_date -- 冲正日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,cash_sign_deal_branch -- 处理机构
            ,cash_sign_deal_user -- 现金长短款处理柜员
            ,reversal_auth_user_id -- 冲正授权柜员
            ,reversal_user_id -- 冲正柜员
            ,tran_amt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_cash_sign_deal_hist_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,cash_from_to -- 资金去向来源
            ,cash_item -- 现金项目
            ,cash_sign_type -- 长短款标记
            ,cash_sign_id -- 现金长短款汇总编号
            ,cash_sign_no -- 长短款明细编号
            ,company -- 法人
            ,narrative -- 摘要
            ,cash_sign_deal_no -- 长短款明细处理序号
            ,reserve_flag -- 冲正标志
            ,seq_no -- 序号
            ,effect_date -- 产品生效日期
            ,cash_sign_deal_date -- 长短钞处理日期
            ,reversal_date -- 冲正日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,cash_sign_deal_branch -- 处理机构
            ,cash_sign_deal_user -- 现金长短款处理柜员
            ,reversal_auth_user_id -- 冲正授权柜员
            ,reversal_user_id -- 冲正柜员
            ,tran_amt -- 交易金额
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
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.cash_from_to, o.cash_from_to) as cash_from_to -- 资金去向来源
    ,nvl(n.cash_item, o.cash_item) as cash_item -- 现金项目
    ,nvl(n.cash_sign_type, o.cash_sign_type) as cash_sign_type -- 长短款标记
    ,nvl(n.cash_sign_id, o.cash_sign_id) as cash_sign_id -- 现金长短款汇总编号
    ,nvl(n.cash_sign_no, o.cash_sign_no) as cash_sign_no -- 长短款明细编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.cash_sign_deal_no, o.cash_sign_deal_no) as cash_sign_deal_no -- 长短款明细处理序号
    ,nvl(n.reserve_flag, o.reserve_flag) as reserve_flag -- 冲正标志
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.cash_sign_deal_date, o.cash_sign_deal_date) as cash_sign_deal_date -- 长短钞处理日期
    ,nvl(n.reversal_date, o.reversal_date) as reversal_date -- 冲正日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.cash_sign_deal_branch, o.cash_sign_deal_branch) as cash_sign_deal_branch -- 处理机构
    ,nvl(n.cash_sign_deal_user, o.cash_sign_deal_user) as cash_sign_deal_user -- 现金长短款处理柜员
    ,nvl(n.reversal_auth_user_id, o.reversal_auth_user_id) as reversal_auth_user_id -- 冲正授权柜员
    ,nvl(n.reversal_user_id, o.reversal_user_id) as reversal_user_id -- 冲正柜员
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,case when
            n.cash_sign_no is null
            and n.cash_sign_deal_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cash_sign_no is null
            and n.cash_sign_deal_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cash_sign_no is null
            and n.cash_sign_deal_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_cash_sign_deal_hist_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_cash_sign_deal_hist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cash_sign_no = n.cash_sign_no
            and o.cash_sign_deal_no = n.cash_sign_deal_no
where (
        o.cash_sign_no is null
        and o.cash_sign_deal_no is null
    )
    or (
        n.cash_sign_no is null
        and n.cash_sign_deal_no is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.prod_type <> n.prod_type
        or o.reference <> n.reference
        or o.tran_type <> n.tran_type
        or o.cash_from_to <> n.cash_from_to
        or o.cash_item <> n.cash_item
        or o.cash_sign_type <> n.cash_sign_type
        or o.cash_sign_id <> n.cash_sign_id
        or o.company <> n.company
        or o.narrative <> n.narrative
        or o.reserve_flag <> n.reserve_flag
        or o.seq_no <> n.seq_no
        or o.effect_date <> n.effect_date
        or o.cash_sign_deal_date <> n.cash_sign_deal_date
        or o.reversal_date <> n.reversal_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.auth_user_id <> n.auth_user_id
        or o.cash_sign_deal_branch <> n.cash_sign_deal_branch
        or o.cash_sign_deal_user <> n.cash_sign_deal_user
        or o.reversal_auth_user_id <> n.reversal_auth_user_id
        or o.reversal_user_id <> n.reversal_user_id
        or o.tran_amt <> n.tran_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_cash_sign_deal_hist_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,cash_from_to -- 资金去向来源
            ,cash_item -- 现金项目
            ,cash_sign_type -- 长短款标记
            ,cash_sign_id -- 现金长短款汇总编号
            ,cash_sign_no -- 长短款明细编号
            ,company -- 法人
            ,narrative -- 摘要
            ,cash_sign_deal_no -- 长短款明细处理序号
            ,reserve_flag -- 冲正标志
            ,seq_no -- 序号
            ,effect_date -- 产品生效日期
            ,cash_sign_deal_date -- 长短钞处理日期
            ,reversal_date -- 冲正日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,cash_sign_deal_branch -- 处理机构
            ,cash_sign_deal_user -- 现金长短款处理柜员
            ,reversal_auth_user_id -- 冲正授权柜员
            ,reversal_user_id -- 冲正柜员
            ,tran_amt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_cash_sign_deal_hist_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,cash_from_to -- 资金去向来源
            ,cash_item -- 现金项目
            ,cash_sign_type -- 长短款标记
            ,cash_sign_id -- 现金长短款汇总编号
            ,cash_sign_no -- 长短款明细编号
            ,company -- 法人
            ,narrative -- 摘要
            ,cash_sign_deal_no -- 长短款明细处理序号
            ,reserve_flag -- 冲正标志
            ,seq_no -- 序号
            ,effect_date -- 产品生效日期
            ,cash_sign_deal_date -- 长短钞处理日期
            ,reversal_date -- 冲正日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,cash_sign_deal_branch -- 处理机构
            ,cash_sign_deal_user -- 现金长短款处理柜员
            ,reversal_auth_user_id -- 冲正授权柜员
            ,reversal_user_id -- 冲正柜员
            ,tran_amt -- 交易金额
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
    ,o.client_no -- 客户编号
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.prod_type -- 产品编号
    ,o.reference -- 交易参考号
    ,o.tran_type -- 交易类型
    ,o.cash_from_to -- 资金去向来源
    ,o.cash_item -- 现金项目
    ,o.cash_sign_type -- 长短款标记
    ,o.cash_sign_id -- 现金长短款汇总编号
    ,o.cash_sign_no -- 长短款明细编号
    ,o.company -- 法人
    ,o.narrative -- 摘要
    ,o.cash_sign_deal_no -- 长短款明细处理序号
    ,o.reserve_flag -- 冲正标志
    ,o.seq_no -- 序号
    ,o.effect_date -- 产品生效日期
    ,o.cash_sign_deal_date -- 长短钞处理日期
    ,o.reversal_date -- 冲正日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.auth_user_id -- 授权柜员
    ,o.cash_sign_deal_branch -- 处理机构
    ,o.cash_sign_deal_user -- 现金长短款处理柜员
    ,o.reversal_auth_user_id -- 冲正授权柜员
    ,o.reversal_user_id -- 冲正柜员
    ,o.tran_amt -- 交易金额
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
from ${iol_schema}.ncbs_tb_cash_sign_deal_hist_bk o
    left join ${iol_schema}.ncbs_tb_cash_sign_deal_hist_op n
        on
            o.cash_sign_no = n.cash_sign_no
            and o.cash_sign_deal_no = n.cash_sign_deal_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_cash_sign_deal_hist_cl d
        on
            o.cash_sign_no = d.cash_sign_no
            and o.cash_sign_deal_no = d.cash_sign_deal_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_cash_sign_deal_hist;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_cash_sign_deal_hist') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_cash_sign_deal_hist drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_cash_sign_deal_hist add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_cash_sign_deal_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_cash_sign_deal_hist_cl;
alter table ${iol_schema}.ncbs_tb_cash_sign_deal_hist exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_cash_sign_deal_hist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_cash_sign_deal_hist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_cash_sign_deal_hist_op purge;
drop table ${iol_schema}.ncbs_tb_cash_sign_deal_hist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_cash_sign_deal_hist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_cash_sign_deal_hist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
