/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpp_dscnt_deal
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
create table ${iol_schema}.bdms_cpp_dscnt_deal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpp_dscnt_deal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpp_dscnt_deal_op purge;
drop table ${iol_schema}.bdms_cpp_dscnt_deal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpp_dscnt_deal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpp_dscnt_deal where 0=1;

create table ${iol_schema}.bdms_cpp_dscnt_deal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpp_dscnt_deal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpp_dscnt_deal_cl(
            id -- ID
            ,dealed_no -- 成交单编号
            ,quote_no -- 报价单编号
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,busi_type -- 业务类型： RE4001 贴现通
            ,trade_type -- 成交方式： TT01 对话报价 TT02 挂牌询价
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
            ,settle_status -- 清算状态： SS00 待清算 SS01 部分清算 SS02 全部清算
            ,bro_brh_no -- 经济机构代码
            ,bro_user_id -- 经济机构交易员ID
            ,dsc_brh_no -- 贴现机构代码
            ,dsc_user_id -- 贴现机构交易员ID
            ,dsc_bank_no -- 贴入人开户行号
            ,dsc_acct_no -- 贴入人账号
            ,cust_name -- 申请人名称
            ,cust_social_no -- 申请人社会信用代码
            ,cust_bank_no -- 申请人开户行号
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,ave_tenor_days -- 加权平均剩余期限
            ,rate -- 贴现利率
            ,clear_speed -- 
            ,settle_date -- 结算日期
            ,settle_mode -- 清算方式： CS00 T+0 CS01 T+1
            ,settle_amt -- 结算金额
            ,misc -- 
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpp_dscnt_deal_op(
            id -- ID
            ,dealed_no -- 成交单编号
            ,quote_no -- 报价单编号
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,busi_type -- 业务类型： RE4001 贴现通
            ,trade_type -- 成交方式： TT01 对话报价 TT02 挂牌询价
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
            ,settle_status -- 清算状态： SS00 待清算 SS01 部分清算 SS02 全部清算
            ,bro_brh_no -- 经济机构代码
            ,bro_user_id -- 经济机构交易员ID
            ,dsc_brh_no -- 贴现机构代码
            ,dsc_user_id -- 贴现机构交易员ID
            ,dsc_bank_no -- 贴入人开户行号
            ,dsc_acct_no -- 贴入人账号
            ,cust_name -- 申请人名称
            ,cust_social_no -- 申请人社会信用代码
            ,cust_bank_no -- 申请人开户行号
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,ave_tenor_days -- 加权平均剩余期限
            ,rate -- 贴现利率
            ,clear_speed -- 
            ,settle_date -- 结算日期
            ,settle_mode -- 清算方式： CS00 T+0 CS01 T+1
            ,settle_amt -- 结算金额
            ,misc -- 
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.dealed_no, o.dealed_no) as dealed_no -- 成交单编号
    ,nvl(n.quote_no, o.quote_no) as quote_no -- 报价单编号
    ,nvl(n.trade_direct, o.trade_direct) as trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型： RE4001 贴现通
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 成交方式： TT01 对话报价 TT02 挂牌询价
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 成交日期
    ,nvl(n.trade_time, o.trade_time) as trade_time -- 成交时间
    ,nvl(n.trade_status, o.trade_status) as trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 清算状态： SS00 待清算 SS01 部分清算 SS02 全部清算
    ,nvl(n.bro_brh_no, o.bro_brh_no) as bro_brh_no -- 经济机构代码
    ,nvl(n.bro_user_id, o.bro_user_id) as bro_user_id -- 经济机构交易员ID
    ,nvl(n.dsc_brh_no, o.dsc_brh_no) as dsc_brh_no -- 贴现机构代码
    ,nvl(n.dsc_user_id, o.dsc_user_id) as dsc_user_id -- 贴现机构交易员ID
    ,nvl(n.dsc_bank_no, o.dsc_bank_no) as dsc_bank_no -- 贴入人开户行号
    ,nvl(n.dsc_acct_no, o.dsc_acct_no) as dsc_acct_no -- 贴入人账号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 申请人名称
    ,nvl(n.cust_social_no, o.cust_social_no) as cust_social_no -- 申请人社会信用代码
    ,nvl(n.cust_bank_no, o.cust_bank_no) as cust_bank_no -- 申请人开户行号
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.sum_count, o.sum_count) as sum_count -- 票据张数
    ,nvl(n.sum_amount, o.sum_amount) as sum_amount -- 票据总额
    ,nvl(n.ave_tenor_days, o.ave_tenor_days) as ave_tenor_days -- 加权平均剩余期限
    ,nvl(n.rate, o.rate) as rate -- 贴现利率
    ,nvl(n.clear_speed, o.clear_speed) as clear_speed -- 
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.settle_mode, o.settle_mode) as settle_mode -- 清算方式： CS00 T+0 CS01 T+1
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.misc, o.misc) as misc -- 
    ,nvl(n.reserver1, o.reserver1) as reserver1 -- 预留域1
    ,nvl(n.reserver2, o.reserver2) as reserver2 -- 预留域2
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
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
from (select * from ${iol_schema}.bdms_cpp_dscnt_deal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpp_dscnt_deal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.dealed_no <> n.dealed_no
        or o.quote_no <> n.quote_no
        or o.trade_direct <> n.trade_direct
        or o.busi_type <> n.busi_type
        or o.trade_type <> n.trade_type
        or o.trade_date <> n.trade_date
        or o.trade_time <> n.trade_time
        or o.trade_status <> n.trade_status
        or o.settle_status <> n.settle_status
        or o.bro_brh_no <> n.bro_brh_no
        or o.bro_user_id <> n.bro_user_id
        or o.dsc_brh_no <> n.dsc_brh_no
        or o.dsc_user_id <> n.dsc_user_id
        or o.dsc_bank_no <> n.dsc_bank_no
        or o.dsc_acct_no <> n.dsc_acct_no
        or o.cust_name <> n.cust_name
        or o.cust_social_no <> n.cust_social_no
        or o.cust_bank_no <> n.cust_bank_no
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.sum_count <> n.sum_count
        or o.sum_amount <> n.sum_amount
        or o.ave_tenor_days <> n.ave_tenor_days
        or o.rate <> n.rate
        or o.clear_speed <> n.clear_speed
        or o.settle_date <> n.settle_date
        or o.settle_mode <> n.settle_mode
        or o.settle_amt <> n.settle_amt
        or o.misc <> n.misc
        or o.reserver1 <> n.reserver1
        or o.reserver2 <> n.reserver2
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.create_time <> n.create_time
        or o.create_by <> n.create_by
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpp_dscnt_deal_cl(
            id -- ID
            ,dealed_no -- 成交单编号
            ,quote_no -- 报价单编号
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,busi_type -- 业务类型： RE4001 贴现通
            ,trade_type -- 成交方式： TT01 对话报价 TT02 挂牌询价
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
            ,settle_status -- 清算状态： SS00 待清算 SS01 部分清算 SS02 全部清算
            ,bro_brh_no -- 经济机构代码
            ,bro_user_id -- 经济机构交易员ID
            ,dsc_brh_no -- 贴现机构代码
            ,dsc_user_id -- 贴现机构交易员ID
            ,dsc_bank_no -- 贴入人开户行号
            ,dsc_acct_no -- 贴入人账号
            ,cust_name -- 申请人名称
            ,cust_social_no -- 申请人社会信用代码
            ,cust_bank_no -- 申请人开户行号
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,ave_tenor_days -- 加权平均剩余期限
            ,rate -- 贴现利率
            ,clear_speed -- 
            ,settle_date -- 结算日期
            ,settle_mode -- 清算方式： CS00 T+0 CS01 T+1
            ,settle_amt -- 结算金额
            ,misc -- 
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpp_dscnt_deal_op(
            id -- ID
            ,dealed_no -- 成交单编号
            ,quote_no -- 报价单编号
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,busi_type -- 业务类型： RE4001 贴现通
            ,trade_type -- 成交方式： TT01 对话报价 TT02 挂牌询价
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
            ,settle_status -- 清算状态： SS00 待清算 SS01 部分清算 SS02 全部清算
            ,bro_brh_no -- 经济机构代码
            ,bro_user_id -- 经济机构交易员ID
            ,dsc_brh_no -- 贴现机构代码
            ,dsc_user_id -- 贴现机构交易员ID
            ,dsc_bank_no -- 贴入人开户行号
            ,dsc_acct_no -- 贴入人账号
            ,cust_name -- 申请人名称
            ,cust_social_no -- 申请人社会信用代码
            ,cust_bank_no -- 申请人开户行号
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,ave_tenor_days -- 加权平均剩余期限
            ,rate -- 贴现利率
            ,clear_speed -- 
            ,settle_date -- 结算日期
            ,settle_mode -- 清算方式： CS00 T+0 CS01 T+1
            ,settle_amt -- 结算金额
            ,misc -- 
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.dealed_no -- 成交单编号
    ,o.quote_no -- 报价单编号
    ,o.trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
    ,o.busi_type -- 业务类型： RE4001 贴现通
    ,o.trade_type -- 成交方式： TT01 对话报价 TT02 挂牌询价
    ,o.trade_date -- 成交日期
    ,o.trade_time -- 成交时间
    ,o.trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
    ,o.settle_status -- 清算状态： SS00 待清算 SS01 部分清算 SS02 全部清算
    ,o.bro_brh_no -- 经济机构代码
    ,o.bro_user_id -- 经济机构交易员ID
    ,o.dsc_brh_no -- 贴现机构代码
    ,o.dsc_user_id -- 贴现机构交易员ID
    ,o.dsc_bank_no -- 贴入人开户行号
    ,o.dsc_acct_no -- 贴入人账号
    ,o.cust_name -- 申请人名称
    ,o.cust_social_no -- 申请人社会信用代码
    ,o.cust_bank_no -- 申请人开户行号
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.sum_count -- 票据张数
    ,o.sum_amount -- 票据总额
    ,o.ave_tenor_days -- 加权平均剩余期限
    ,o.rate -- 贴现利率
    ,o.clear_speed -- 
    ,o.settle_date -- 结算日期
    ,o.settle_mode -- 清算方式： CS00 T+0 CS01 T+1
    ,o.settle_amt -- 结算金额
    ,o.misc -- 
    ,o.reserver1 -- 预留域1
    ,o.reserver2 -- 预留域2
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.create_time -- 创建时间
    ,o.create_by -- 创建人
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
from ${iol_schema}.bdms_cpp_dscnt_deal_bk o
    left join ${iol_schema}.bdms_cpp_dscnt_deal_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpp_dscnt_deal_cl d
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
--truncate table ${iol_schema}.bdms_cpp_dscnt_deal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpp_dscnt_deal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpp_dscnt_deal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpp_dscnt_deal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpp_dscnt_deal exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpp_dscnt_deal_cl;
alter table ${iol_schema}.bdms_cpp_dscnt_deal exchange partition p_20991231 with table ${iol_schema}.bdms_cpp_dscnt_deal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpp_dscnt_deal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpp_dscnt_deal_op purge;
drop table ${iol_schema}.bdms_cpp_dscnt_deal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpp_dscnt_deal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpp_dscnt_deal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
