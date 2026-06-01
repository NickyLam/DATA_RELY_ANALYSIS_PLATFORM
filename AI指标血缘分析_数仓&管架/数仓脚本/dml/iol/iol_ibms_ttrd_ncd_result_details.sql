/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_ncd_result_details
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
create table ${iol_schema}.ibms_ttrd_ncd_result_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_ncd_result_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_ncd_result_details_op purge;
drop table ${iol_schema}.ibms_ttrd_ncd_result_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_ncd_result_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_ncd_result_details where 0=1;

create table ${iol_schema}.ibms_ttrd_ncd_result_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_ncd_result_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_ncd_result_details_cl(
            seq_id -- 序列号
            ,sysordid -- 交易单号
            ,ref_sysordid -- 子交易单号
            ,i_code -- 存单代码
            ,a_type -- 存单资产类型
            ,m_type -- 存单市场类型
            ,issue_type -- 发行方式(1-报价发行,2-招标发行,3-浮息发行)
            ,partyid -- 认购人id
            ,partyname -- 认购人名称
            ,bid_price -- 投标价位(元)
            ,bid_amount -- 投标量(亿元)
            ,bidding_price -- 中标价位(元)
            ,bidding_amount -- 中标量(亿元)
            ,bid_time -- 认购时间
            ,username -- 提交用户
            ,bidding_actual_amount -- 实际认购量
            ,memo -- 备注
            ,sales_organization -- 销售机构
            ,cost_calculate_rule -- 费用计算规则
            ,bidding_pay_amount -- 缴款金额(元)
            ,bank_code -- 开户行行号
            ,trdacccode -- 交易账号
            ,sales_name -- 销售机构名称
            ,sales_org_name -- 销售机构(华兴)
            ,real_party_id -- 实际认购方编码
            ,real_partyname -- 实际认购方名称
            ,belonger -- 业绩归属人
            ,head_belonger -- 总行业绩归属人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_ncd_result_details_op(
            seq_id -- 序列号
            ,sysordid -- 交易单号
            ,ref_sysordid -- 子交易单号
            ,i_code -- 存单代码
            ,a_type -- 存单资产类型
            ,m_type -- 存单市场类型
            ,issue_type -- 发行方式(1-报价发行,2-招标发行,3-浮息发行)
            ,partyid -- 认购人id
            ,partyname -- 认购人名称
            ,bid_price -- 投标价位(元)
            ,bid_amount -- 投标量(亿元)
            ,bidding_price -- 中标价位(元)
            ,bidding_amount -- 中标量(亿元)
            ,bid_time -- 认购时间
            ,username -- 提交用户
            ,bidding_actual_amount -- 实际认购量
            ,memo -- 备注
            ,sales_organization -- 销售机构
            ,cost_calculate_rule -- 费用计算规则
            ,bidding_pay_amount -- 缴款金额(元)
            ,bank_code -- 开户行行号
            ,trdacccode -- 交易账号
            ,sales_name -- 销售机构名称
            ,sales_org_name -- 销售机构(华兴)
            ,real_party_id -- 实际认购方编码
            ,real_partyname -- 实际认购方名称
            ,belonger -- 业绩归属人
            ,head_belonger -- 总行业绩归属人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seq_id, o.seq_id) as seq_id -- 序列号
    ,nvl(n.sysordid, o.sysordid) as sysordid -- 交易单号
    ,nvl(n.ref_sysordid, o.ref_sysordid) as ref_sysordid -- 子交易单号
    ,nvl(n.i_code, o.i_code) as i_code -- 存单代码
    ,nvl(n.a_type, o.a_type) as a_type -- 存单资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 存单市场类型
    ,nvl(n.issue_type, o.issue_type) as issue_type -- 发行方式(1-报价发行,2-招标发行,3-浮息发行)
    ,nvl(n.partyid, o.partyid) as partyid -- 认购人id
    ,nvl(n.partyname, o.partyname) as partyname -- 认购人名称
    ,nvl(n.bid_price, o.bid_price) as bid_price -- 投标价位(元)
    ,nvl(n.bid_amount, o.bid_amount) as bid_amount -- 投标量(亿元)
    ,nvl(n.bidding_price, o.bidding_price) as bidding_price -- 中标价位(元)
    ,nvl(n.bidding_amount, o.bidding_amount) as bidding_amount -- 中标量(亿元)
    ,nvl(n.bid_time, o.bid_time) as bid_time -- 认购时间
    ,nvl(n.username, o.username) as username -- 提交用户
    ,nvl(n.bidding_actual_amount, o.bidding_actual_amount) as bidding_actual_amount -- 实际认购量
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.sales_organization, o.sales_organization) as sales_organization -- 销售机构
    ,nvl(n.cost_calculate_rule, o.cost_calculate_rule) as cost_calculate_rule -- 费用计算规则
    ,nvl(n.bidding_pay_amount, o.bidding_pay_amount) as bidding_pay_amount -- 缴款金额(元)
    ,nvl(n.bank_code, o.bank_code) as bank_code -- 开户行行号
    ,nvl(n.trdacccode, o.trdacccode) as trdacccode -- 交易账号
    ,nvl(n.sales_name, o.sales_name) as sales_name -- 销售机构名称
    ,nvl(n.sales_org_name, o.sales_org_name) as sales_org_name -- 销售机构(华兴)
    ,nvl(n.real_party_id, o.real_party_id) as real_party_id -- 实际认购方编码
    ,nvl(n.real_partyname, o.real_partyname) as real_partyname -- 实际认购方名称
    ,nvl(n.belonger, o.belonger) as belonger -- 业绩归属人
    ,nvl(n.head_belonger, o.head_belonger) as head_belonger -- 总行业绩归属人
    ,case when
            n.seq_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_ncd_result_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_ncd_result_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_id = n.seq_id
where (
        o.seq_id is null
    )
    or (
        n.seq_id is null
    )
    or (
        o.sysordid <> n.sysordid
        or o.ref_sysordid <> n.ref_sysordid
        or o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.issue_type <> n.issue_type
        or o.partyid <> n.partyid
        or o.partyname <> n.partyname
        or o.bid_price <> n.bid_price
        or o.bid_amount <> n.bid_amount
        or o.bidding_price <> n.bidding_price
        or o.bidding_amount <> n.bidding_amount
        or o.bid_time <> n.bid_time
        or o.username <> n.username
        or o.bidding_actual_amount <> n.bidding_actual_amount
        or o.memo <> n.memo
        or o.sales_organization <> n.sales_organization
        or o.cost_calculate_rule <> n.cost_calculate_rule
        or o.bidding_pay_amount <> n.bidding_pay_amount
        or o.bank_code <> n.bank_code
        or o.trdacccode <> n.trdacccode
        or o.sales_name <> n.sales_name
        or o.sales_org_name <> n.sales_org_name
        or o.real_party_id <> n.real_party_id
        or o.real_partyname <> n.real_partyname
        or o.belonger <> n.belonger
        or o.head_belonger <> n.head_belonger
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_ncd_result_details_cl(
            seq_id -- 序列号
            ,sysordid -- 交易单号
            ,ref_sysordid -- 子交易单号
            ,i_code -- 存单代码
            ,a_type -- 存单资产类型
            ,m_type -- 存单市场类型
            ,issue_type -- 发行方式(1-报价发行,2-招标发行,3-浮息发行)
            ,partyid -- 认购人id
            ,partyname -- 认购人名称
            ,bid_price -- 投标价位(元)
            ,bid_amount -- 投标量(亿元)
            ,bidding_price -- 中标价位(元)
            ,bidding_amount -- 中标量(亿元)
            ,bid_time -- 认购时间
            ,username -- 提交用户
            ,bidding_actual_amount -- 实际认购量
            ,memo -- 备注
            ,sales_organization -- 销售机构
            ,cost_calculate_rule -- 费用计算规则
            ,bidding_pay_amount -- 缴款金额(元)
            ,bank_code -- 开户行行号
            ,trdacccode -- 交易账号
            ,sales_name -- 销售机构名称
            ,sales_org_name -- 销售机构(华兴)
            ,real_party_id -- 实际认购方编码
            ,real_partyname -- 实际认购方名称
            ,belonger -- 业绩归属人
            ,head_belonger -- 总行业绩归属人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_ncd_result_details_op(
            seq_id -- 序列号
            ,sysordid -- 交易单号
            ,ref_sysordid -- 子交易单号
            ,i_code -- 存单代码
            ,a_type -- 存单资产类型
            ,m_type -- 存单市场类型
            ,issue_type -- 发行方式(1-报价发行,2-招标发行,3-浮息发行)
            ,partyid -- 认购人id
            ,partyname -- 认购人名称
            ,bid_price -- 投标价位(元)
            ,bid_amount -- 投标量(亿元)
            ,bidding_price -- 中标价位(元)
            ,bidding_amount -- 中标量(亿元)
            ,bid_time -- 认购时间
            ,username -- 提交用户
            ,bidding_actual_amount -- 实际认购量
            ,memo -- 备注
            ,sales_organization -- 销售机构
            ,cost_calculate_rule -- 费用计算规则
            ,bidding_pay_amount -- 缴款金额(元)
            ,bank_code -- 开户行行号
            ,trdacccode -- 交易账号
            ,sales_name -- 销售机构名称
            ,sales_org_name -- 销售机构(华兴)
            ,real_party_id -- 实际认购方编码
            ,real_partyname -- 实际认购方名称
            ,belonger -- 业绩归属人
            ,head_belonger -- 总行业绩归属人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seq_id -- 序列号
    ,o.sysordid -- 交易单号
    ,o.ref_sysordid -- 子交易单号
    ,o.i_code -- 存单代码
    ,o.a_type -- 存单资产类型
    ,o.m_type -- 存单市场类型
    ,o.issue_type -- 发行方式(1-报价发行,2-招标发行,3-浮息发行)
    ,o.partyid -- 认购人id
    ,o.partyname -- 认购人名称
    ,o.bid_price -- 投标价位(元)
    ,o.bid_amount -- 投标量(亿元)
    ,o.bidding_price -- 中标价位(元)
    ,o.bidding_amount -- 中标量(亿元)
    ,o.bid_time -- 认购时间
    ,o.username -- 提交用户
    ,o.bidding_actual_amount -- 实际认购量
    ,o.memo -- 备注
    ,o.sales_organization -- 销售机构
    ,o.cost_calculate_rule -- 费用计算规则
    ,o.bidding_pay_amount -- 缴款金额(元)
    ,o.bank_code -- 开户行行号
    ,o.trdacccode -- 交易账号
    ,o.sales_name -- 销售机构名称
    ,o.sales_org_name -- 销售机构(华兴)
    ,o.real_party_id -- 实际认购方编码
    ,o.real_partyname -- 实际认购方名称
    ,o.belonger -- 业绩归属人
    ,o.head_belonger -- 总行业绩归属人
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
from ${iol_schema}.ibms_ttrd_ncd_result_details_bk o
    left join ${iol_schema}.ibms_ttrd_ncd_result_details_op n
        on
            o.seq_id = n.seq_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_ncd_result_details_cl d
        on
            o.seq_id = d.seq_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_ncd_result_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_ncd_result_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_ncd_result_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_ncd_result_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_ncd_result_details exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_ncd_result_details_cl;
alter table ${iol_schema}.ibms_ttrd_ncd_result_details exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_ncd_result_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_ncd_result_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_ncd_result_details_op purge;
drop table ${iol_schema}.ibms_ttrd_ncd_result_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_ncd_result_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_ncd_result_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
