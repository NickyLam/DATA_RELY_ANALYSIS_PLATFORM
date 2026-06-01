/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_ces_quote_details_info
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
create table ${iol_schema}.bdms_ces_quote_details_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_ces_quote_details_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_ces_quote_details_info_op purge;
drop table ${iol_schema}.bdms_ces_quote_details_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_ces_quote_details_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_ces_quote_details_info where 0=1;

create table ${iol_schema}.bdms_ces_quote_details_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_ces_quote_details_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_ces_quote_details_info_cl(
            id -- ID
            ,deal_id -- 成交表ID
            ,draft_id -- 票据表ID
            ,quote_id -- 报价信息表ID
            ,del_quote_id -- 删除此票据的报价信息表ID
            ,del_flag -- 删除标志： 0 否 1 是
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,due_tenor_days -- 到期剩余期限
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_branch -- 信用主体
            ,is_approve -- 是否成交标识： 1 是 0 否
            ,msg_note -- 报文备注
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,org_draft_amount -- 原始票据（包）金额
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,draft_number -- 票据（包）号
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_ces_quote_details_info_op(
            id -- ID
            ,deal_id -- 成交表ID
            ,draft_id -- 票据表ID
            ,quote_id -- 报价信息表ID
            ,del_quote_id -- 删除此票据的报价信息表ID
            ,del_flag -- 删除标志： 0 否 1 是
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,due_tenor_days -- 到期剩余期限
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_branch -- 信用主体
            ,is_approve -- 是否成交标识： 1 是 0 否
            ,msg_note -- 报文备注
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,org_draft_amount -- 原始票据（包）金额
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,draft_number -- 票据（包）号
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.deal_id, o.deal_id) as deal_id -- 成交表ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据表ID
    ,nvl(n.quote_id, o.quote_id) as quote_id -- 报价信息表ID
    ,nvl(n.del_quote_id, o.del_quote_id) as del_quote_id -- 删除此票据的报价信息表ID
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 删除标志： 0 否 1 是
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票面金额
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 票据到期日
    ,nvl(n.real_due_date, o.real_due_date) as real_due_date -- 实际到期日
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 剩余期限
    ,nvl(n.due_tenor_days, o.due_tenor_days) as due_tenor_days -- 到期剩余期限
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.due_pay_interest, o.due_pay_interest) as due_pay_interest -- 到期应付利息
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.due_settle_amt, o.due_settle_amt) as due_settle_amt -- 到期结算金额
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.credit_type, o.credit_type) as credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,nvl(n.credit_branch, o.credit_branch) as credit_branch -- 信用主体
    ,nvl(n.is_approve, o.is_approve) as is_approve -- 是否成交标识： 1 是 0 否
    ,nvl(n.msg_note, o.msg_note) as msg_note -- 报文备注
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 子票区间
    ,nvl(n.standard_amt, o.standard_amt) as standard_amt -- 标准金额
    ,nvl(n.split_range, o.split_range) as split_range -- 拆前区间
    ,nvl(n.org_draft_amount, o.org_draft_amount) as org_draft_amount -- 原始票据（包）金额
    ,nvl(n.cd_split, o.cd_split) as cd_split -- 是否允许分包流转： 0 否 1 是
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据（包）号
    ,nvl(n.create_time, o.create_time) as create_time -- 鍒涘缓鏃堕棿
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
from (select * from ${iol_schema}.bdms_ces_quote_details_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_ces_quote_details_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.deal_id <> n.deal_id
        or o.draft_id <> n.draft_id
        or o.quote_id <> n.quote_id
        or o.del_quote_id <> n.del_quote_id
        or o.del_flag <> n.del_flag
        or o.draft_amount <> n.draft_amount
        or o.maturity_date <> n.maturity_date
        or o.real_due_date <> n.real_due_date
        or o.tenor_days <> n.tenor_days
        or o.due_tenor_days <> n.due_tenor_days
        or o.pay_interest <> n.pay_interest
        or o.due_pay_interest <> n.due_pay_interest
        or o.settle_amt <> n.settle_amt
        or o.due_settle_amt <> n.due_settle_amt
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.credit_type <> n.credit_type
        or o.credit_branch <> n.credit_branch
        or o.is_approve <> n.is_approve
        or o.msg_note <> n.msg_note
        or o.cd_range <> n.cd_range
        or o.standard_amt <> n.standard_amt
        or o.split_range <> n.split_range
        or o.org_draft_amount <> n.org_draft_amount
        or o.cd_split <> n.cd_split
        or o.draft_number <> n.draft_number
        or o.create_time <> n.create_time
        or o.create_by <> n.create_by
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_ces_quote_details_info_cl(
            id -- ID
            ,deal_id -- 成交表ID
            ,draft_id -- 票据表ID
            ,quote_id -- 报价信息表ID
            ,del_quote_id -- 删除此票据的报价信息表ID
            ,del_flag -- 删除标志： 0 否 1 是
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,due_tenor_days -- 到期剩余期限
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_branch -- 信用主体
            ,is_approve -- 是否成交标识： 1 是 0 否
            ,msg_note -- 报文备注
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,org_draft_amount -- 原始票据（包）金额
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,draft_number -- 票据（包）号
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_ces_quote_details_info_op(
            id -- ID
            ,deal_id -- 成交表ID
            ,draft_id -- 票据表ID
            ,quote_id -- 报价信息表ID
            ,del_quote_id -- 删除此票据的报价信息表ID
            ,del_flag -- 删除标志： 0 否 1 是
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,due_tenor_days -- 到期剩余期限
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_branch -- 信用主体
            ,is_approve -- 是否成交标识： 1 是 0 否
            ,msg_note -- 报文备注
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,org_draft_amount -- 原始票据（包）金额
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,draft_number -- 票据（包）号
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.deal_id -- 成交表ID
    ,o.draft_id -- 票据表ID
    ,o.quote_id -- 报价信息表ID
    ,o.del_quote_id -- 删除此票据的报价信息表ID
    ,o.del_flag -- 删除标志： 0 否 1 是
    ,o.draft_amount -- 票面金额
    ,o.maturity_date -- 票据到期日
    ,o.real_due_date -- 实际到期日
    ,o.tenor_days -- 剩余期限
    ,o.due_tenor_days -- 到期剩余期限
    ,o.pay_interest -- 应付利息
    ,o.due_pay_interest -- 到期应付利息
    ,o.settle_amt -- 结算金额
    ,o.due_settle_amt -- 到期结算金额
    ,o.last_upd_opr -- 最后操作人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,o.credit_branch -- 信用主体
    ,o.is_approve -- 是否成交标识： 1 是 0 否
    ,o.msg_note -- 报文备注
    ,o.cd_range -- 子票区间
    ,o.standard_amt -- 标准金额
    ,o.split_range -- 拆前区间
    ,o.org_draft_amount -- 原始票据（包）金额
    ,o.cd_split -- 是否允许分包流转： 0 否 1 是
    ,o.draft_number -- 票据（包）号
    ,o.create_time -- 鍒涘缓鏃堕棿
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
from ${iol_schema}.bdms_ces_quote_details_info_bk o
    left join ${iol_schema}.bdms_ces_quote_details_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_ces_quote_details_info_cl d
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
--truncate table ${iol_schema}.bdms_ces_quote_details_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_ces_quote_details_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_ces_quote_details_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_ces_quote_details_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_ces_quote_details_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_ces_quote_details_info_cl;
alter table ${iol_schema}.bdms_ces_quote_details_info exchange partition p_20991231 with table ${iol_schema}.bdms_ces_quote_details_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_ces_quote_details_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_ces_quote_details_info_op purge;
drop table ${iol_schema}.bdms_ces_quote_details_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_ces_quote_details_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_ces_quote_details_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
