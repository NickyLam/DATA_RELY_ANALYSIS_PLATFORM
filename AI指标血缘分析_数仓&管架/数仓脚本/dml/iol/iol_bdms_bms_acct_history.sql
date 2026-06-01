/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_acct_history
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
create table ${iol_schema}.bdms_bms_acct_history_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_acct_history
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_acct_history_op purge;
drop table ${iol_schema}.bdms_bms_acct_history_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_acct_history_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_acct_history where 0=1;

create table ${iol_schema}.bdms_bms_acct_history_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_acct_history where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_acct_history_cl(
            ah_id -- 余额ID
            ,top_branch_no -- 所属总行机构号
            ,busi_branch_no -- 交易机构号
            ,contract_id -- 协议ID
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_amount -- 票面金额
            ,draft_type -- 票据种类： 1 银票 2 商票
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,dr_cr -- 借贷标志 D:借 C:贷
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,product_no -- 业务产品号
            ,sele_prono -- 买出产品号
            ,start_dt_ora -- 开始日期
            ,end_dt_ora -- 结束日期--卖出，托收
            ,status -- 状态： 0 初始化 1 开始 2 结束
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,sale_detail_id -- 卖断时关联业务明细ID
            ,buy_protocol_no -- 买入协议号
            ,sale_contract_id -- 卖出协议ID
            ,sale_protocol_no -- 卖出协议号
            ,acct_branch_no -- 账务机构号
            ,jiti_type -- 计提类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,cd_range -- 子票区间
            ,sale_draft_id -- 结束的票据ID
            ,sale_cd_range -- 结束的子票区间
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,settle_status -- 结算状态
            ,sale_amount -- 结束金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_acct_history_op(
            ah_id -- 余额ID
            ,top_branch_no -- 所属总行机构号
            ,busi_branch_no -- 交易机构号
            ,contract_id -- 协议ID
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_amount -- 票面金额
            ,draft_type -- 票据种类： 1 银票 2 商票
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,dr_cr -- 借贷标志 D:借 C:贷
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,product_no -- 业务产品号
            ,sele_prono -- 买出产品号
            ,start_dt_ora -- 开始日期
            ,end_dt_ora -- 结束日期--卖出，托收
            ,status -- 状态： 0 初始化 1 开始 2 结束
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,sale_detail_id -- 卖断时关联业务明细ID
            ,buy_protocol_no -- 买入协议号
            ,sale_contract_id -- 卖出协议ID
            ,sale_protocol_no -- 卖出协议号
            ,acct_branch_no -- 账务机构号
            ,jiti_type -- 计提类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,cd_range -- 子票区间
            ,sale_draft_id -- 结束的票据ID
            ,sale_cd_range -- 结束的子票区间
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,settle_status -- 结算状态
            ,sale_amount -- 结束金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ah_id, o.ah_id) as ah_id -- 余额ID
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 所属总行机构号
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 交易机构号
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 协议ID
    ,nvl(n.detail_id, o.detail_id) as detail_id -- 业务明细ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票面金额
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据种类： 1 银票 2 商票
    ,nvl(n.subject_no, o.subject_no) as subject_no -- 科目号
    ,nvl(n.subject_name, o.subject_name) as subject_name -- 科目名称
    ,nvl(n.dr_cr, o.dr_cr) as dr_cr -- 借贷标志 D:借 C:贷
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.product_no, o.product_no) as product_no -- 业务产品号
    ,nvl(n.sele_prono, o.sele_prono) as sele_prono -- 买出产品号
    ,nvl(n.start_dt_ora, o.start_dt_ora) as start_dt_ora -- 开始日期
    ,nvl(n.end_dt_ora, o.end_dt_ora) as end_dt_ora -- 结束日期--卖出，托收
    ,nvl(n.status, o.status) as status -- 状态： 0 初始化 1 开始 2 结束
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 保留字段3
    ,nvl(n.sale_detail_id, o.sale_detail_id) as sale_detail_id -- 卖断时关联业务明细ID
    ,nvl(n.buy_protocol_no, o.buy_protocol_no) as buy_protocol_no -- 买入协议号
    ,nvl(n.sale_contract_id, o.sale_contract_id) as sale_contract_id -- 卖出协议ID
    ,nvl(n.sale_protocol_no, o.sale_protocol_no) as sale_protocol_no -- 卖出协议号
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 账务机构号
    ,nvl(n.jiti_type, o.jiti_type) as jiti_type -- 计提类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
    ,nvl(n.cd_split, o.cd_split) as cd_split -- 是否允许分包流转： 0 否 1 是
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 子票区间
    ,nvl(n.sale_draft_id, o.sale_draft_id) as sale_draft_id -- 结束的票据ID
    ,nvl(n.sale_cd_range, o.sale_cd_range) as sale_cd_range -- 结束的子票区间
    ,nvl(n.bms_draft_id, o.bms_draft_id) as bms_draft_id -- 原票据系统的登记中心ID
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 结算状态
    ,nvl(n.sale_amount, o.sale_amount) as sale_amount -- 结束金额
    ,case when
            n.ah_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ah_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ah_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_acct_history_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_acct_history where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ah_id = n.ah_id
where (
        o.ah_id is null
    )
    or (
        n.ah_id is null
    )
    or (
        o.top_branch_no <> n.top_branch_no
        or o.busi_branch_no <> n.busi_branch_no
        or o.contract_id <> n.contract_id
        or o.detail_id <> n.detail_id
        or o.draft_id <> n.draft_id
        or o.draft_number <> n.draft_number
        or o.draft_amount <> n.draft_amount
        or o.draft_type <> n.draft_type
        or o.subject_no <> n.subject_no
        or o.subject_name <> n.subject_name
        or o.dr_cr <> n.dr_cr
        or o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.product_no <> n.product_no
        or o.sele_prono <> n.sele_prono
        or o.start_dt_ora <> n.start_dt_ora
        or o.end_dt_ora <> n.end_dt_ora
        or o.status <> n.status
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.sale_detail_id <> n.sale_detail_id
        or o.buy_protocol_no <> n.buy_protocol_no
        or o.sale_contract_id <> n.sale_contract_id
        or o.sale_protocol_no <> n.sale_protocol_no
        or o.acct_branch_no <> n.acct_branch_no
        or o.jiti_type <> n.jiti_type
        or o.cd_split <> n.cd_split
        or o.cd_range <> n.cd_range
        or o.sale_draft_id <> n.sale_draft_id
        or o.sale_cd_range <> n.sale_cd_range
        or o.bms_draft_id <> n.bms_draft_id
        or o.settle_status <> n.settle_status
        or o.sale_amount <> n.sale_amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_acct_history_cl(
            ah_id -- 余额ID
            ,top_branch_no -- 所属总行机构号
            ,busi_branch_no -- 交易机构号
            ,contract_id -- 协议ID
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_amount -- 票面金额
            ,draft_type -- 票据种类： 1 银票 2 商票
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,dr_cr -- 借贷标志 D:借 C:贷
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,product_no -- 业务产品号
            ,sele_prono -- 买出产品号
            ,start_dt_ora -- 开始日期
            ,end_dt_ora -- 结束日期--卖出，托收
            ,status -- 状态： 0 初始化 1 开始 2 结束
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,sale_detail_id -- 卖断时关联业务明细ID
            ,buy_protocol_no -- 买入协议号
            ,sale_contract_id -- 卖出协议ID
            ,sale_protocol_no -- 卖出协议号
            ,acct_branch_no -- 账务机构号
            ,jiti_type -- 计提类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,cd_range -- 子票区间
            ,sale_draft_id -- 结束的票据ID
            ,sale_cd_range -- 结束的子票区间
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,settle_status -- 结算状态
            ,sale_amount -- 结束金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_acct_history_op(
            ah_id -- 余额ID
            ,top_branch_no -- 所属总行机构号
            ,busi_branch_no -- 交易机构号
            ,contract_id -- 协议ID
            ,detail_id -- 业务明细ID
            ,draft_id -- 票据ID
            ,draft_number -- 票据号
            ,draft_amount -- 票面金额
            ,draft_type -- 票据种类： 1 银票 2 商票
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,dr_cr -- 借贷标志 D:借 C:贷
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,product_no -- 业务产品号
            ,sele_prono -- 买出产品号
            ,start_dt_ora -- 开始日期
            ,end_dt_ora -- 结束日期--卖出，托收
            ,status -- 状态： 0 初始化 1 开始 2 结束
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,sale_detail_id -- 卖断时关联业务明细ID
            ,buy_protocol_no -- 买入协议号
            ,sale_contract_id -- 卖出协议ID
            ,sale_protocol_no -- 卖出协议号
            ,acct_branch_no -- 账务机构号
            ,jiti_type -- 计提类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,cd_range -- 子票区间
            ,sale_draft_id -- 结束的票据ID
            ,sale_cd_range -- 结束的子票区间
            ,bms_draft_id -- 原票据系统的登记中心ID
            ,settle_status -- 结算状态
            ,sale_amount -- 结束金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ah_id -- 余额ID
    ,o.top_branch_no -- 所属总行机构号
    ,o.busi_branch_no -- 交易机构号
    ,o.contract_id -- 协议ID
    ,o.detail_id -- 业务明细ID
    ,o.draft_id -- 票据ID
    ,o.draft_number -- 票据号
    ,o.draft_amount -- 票面金额
    ,o.draft_type -- 票据种类： 1 银票 2 商票
    ,o.subject_no -- 科目号
    ,o.subject_name -- 科目名称
    ,o.dr_cr -- 借贷标志 D:借 C:贷
    ,o.cust_no -- 客户号
    ,o.cust_name -- 客户名称
    ,o.product_no -- 业务产品号
    ,o.sele_prono -- 买出产品号
    ,o.start_dt_ora -- 开始日期
    ,o.end_dt_ora -- 结束日期--卖出，托收
    ,o.status -- 状态： 0 初始化 1 开始 2 结束
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.reserve1 -- 保留字段1
    ,o.reserve2 -- 保留字段2
    ,o.reserve3 -- 保留字段3
    ,o.sale_detail_id -- 卖断时关联业务明细ID
    ,o.buy_protocol_no -- 买入协议号
    ,o.sale_contract_id -- 卖出协议ID
    ,o.sale_protocol_no -- 卖出协议号
    ,o.acct_branch_no -- 账务机构号
    ,o.jiti_type -- 计提类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
    ,o.cd_split -- 是否允许分包流转： 0 否 1 是
    ,o.cd_range -- 子票区间
    ,o.sale_draft_id -- 结束的票据ID
    ,o.sale_cd_range -- 结束的子票区间
    ,o.bms_draft_id -- 原票据系统的登记中心ID
    ,o.settle_status -- 结算状态
    ,o.sale_amount -- 结束金额
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
from ${iol_schema}.bdms_bms_acct_history_bk o
    left join ${iol_schema}.bdms_bms_acct_history_op n
        on
            o.ah_id = n.ah_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_acct_history_cl d
        on
            o.ah_id = d.ah_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_acct_history;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_acct_history') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_acct_history drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_acct_history add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_acct_history exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_acct_history_cl;
alter table ${iol_schema}.bdms_bms_acct_history exchange partition p_20991231 with table ${iol_schema}.bdms_bms_acct_history_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_acct_history to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_acct_history_op purge;
drop table ${iol_schema}.bdms_bms_acct_history_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_acct_history_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_acct_history',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
