/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_mb_fee_mapping
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
create table ${iol_schema}.ncbs_mb_fee_mapping_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_mb_fee_mapping
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_fee_mapping_op purge;
drop table ${iol_schema}.ncbs_mb_fee_mapping_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_fee_mapping_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_fee_mapping where 0=1;

create table ${iol_schema}.ncbs_mb_fee_mapping_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_fee_mapping where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_fee_mapping_cl(
            branch_rule -- 机构匹配规则
            ,category_type_rule -- 客户类型细类
            ,ccy_rule -- 费用启用规则币种
            ,client_type_rule -- 费用启用规则客户类型
            ,company -- 法人
            ,company_rule -- 费用启用规则法人
            ,doc_type_rule -- 凭证类型启用规则
            ,event_type_rule -- 费用启用规则事件类型
            ,fee_type -- 费率类型
            ,irl_seq_no -- 费率编号
            ,is_local_rule -- 跨行标志
            ,new_status_rule -- 新凭证状态启用规则
            ,old_status_rule -- 原凭证状态启用规则
            ,prod_group_rule -- 费用启用规则产品组
            ,rule_flag -- 是否使用规则
            ,service_id_rule -- 规则匹配代码
            ,source_type_rule -- 渠道类型配置值
            ,tran_type_rule -- 费用启用规则交易类型
            ,urgent_flag_rule -- 加急标志
            ,prod_type_rule -- 费用启用规则产品类型
            ,tran_timestamp -- 交易时间戳
            ,area_code_rule -- 地区匹配规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_fee_mapping_op(
            branch_rule -- 机构匹配规则
            ,category_type_rule -- 客户类型细类
            ,ccy_rule -- 费用启用规则币种
            ,client_type_rule -- 费用启用规则客户类型
            ,company -- 法人
            ,company_rule -- 费用启用规则法人
            ,doc_type_rule -- 凭证类型启用规则
            ,event_type_rule -- 费用启用规则事件类型
            ,fee_type -- 费率类型
            ,irl_seq_no -- 费率编号
            ,is_local_rule -- 跨行标志
            ,new_status_rule -- 新凭证状态启用规则
            ,old_status_rule -- 原凭证状态启用规则
            ,prod_group_rule -- 费用启用规则产品组
            ,rule_flag -- 是否使用规则
            ,service_id_rule -- 规则匹配代码
            ,source_type_rule -- 渠道类型配置值
            ,tran_type_rule -- 费用启用规则交易类型
            ,urgent_flag_rule -- 加急标志
            ,prod_type_rule -- 费用启用规则产品类型
            ,tran_timestamp -- 交易时间戳
            ,area_code_rule -- 地区匹配规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch_rule, o.branch_rule) as branch_rule -- 机构匹配规则
    ,nvl(n.category_type_rule, o.category_type_rule) as category_type_rule -- 客户类型细类
    ,nvl(n.ccy_rule, o.ccy_rule) as ccy_rule -- 费用启用规则币种
    ,nvl(n.client_type_rule, o.client_type_rule) as client_type_rule -- 费用启用规则客户类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.company_rule, o.company_rule) as company_rule -- 费用启用规则法人
    ,nvl(n.doc_type_rule, o.doc_type_rule) as doc_type_rule -- 凭证类型启用规则
    ,nvl(n.event_type_rule, o.event_type_rule) as event_type_rule -- 费用启用规则事件类型
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费率类型
    ,nvl(n.irl_seq_no, o.irl_seq_no) as irl_seq_no -- 费率编号
    ,nvl(n.is_local_rule, o.is_local_rule) as is_local_rule -- 跨行标志
    ,nvl(n.new_status_rule, o.new_status_rule) as new_status_rule -- 新凭证状态启用规则
    ,nvl(n.old_status_rule, o.old_status_rule) as old_status_rule -- 原凭证状态启用规则
    ,nvl(n.prod_group_rule, o.prod_group_rule) as prod_group_rule -- 费用启用规则产品组
    ,nvl(n.rule_flag, o.rule_flag) as rule_flag -- 是否使用规则
    ,nvl(n.service_id_rule, o.service_id_rule) as service_id_rule -- 规则匹配代码
    ,nvl(n.source_type_rule, o.source_type_rule) as source_type_rule -- 渠道类型配置值
    ,nvl(n.tran_type_rule, o.tran_type_rule) as tran_type_rule -- 费用启用规则交易类型
    ,nvl(n.urgent_flag_rule, o.urgent_flag_rule) as urgent_flag_rule -- 加急标志
    ,nvl(n.prod_type_rule, o.prod_type_rule) as prod_type_rule -- 费用启用规则产品类型
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.area_code_rule, o.area_code_rule) as area_code_rule -- 地区匹配规则
    ,case when
            n.irl_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.irl_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.irl_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_mb_fee_mapping_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_mb_fee_mapping where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.irl_seq_no = n.irl_seq_no
where (
        o.irl_seq_no is null
    )
    or (
        n.irl_seq_no is null
    )
    or (
        o.branch_rule <> n.branch_rule
        or o.category_type_rule <> n.category_type_rule
        or o.ccy_rule <> n.ccy_rule
        or o.client_type_rule <> n.client_type_rule
        or o.company <> n.company
        or o.company_rule <> n.company_rule
        or o.doc_type_rule <> n.doc_type_rule
        or o.event_type_rule <> n.event_type_rule
        or o.fee_type <> n.fee_type
        or o.is_local_rule <> n.is_local_rule
        or o.new_status_rule <> n.new_status_rule
        or o.old_status_rule <> n.old_status_rule
        or o.prod_group_rule <> n.prod_group_rule
        or o.rule_flag <> n.rule_flag
        or o.service_id_rule <> n.service_id_rule
        or o.source_type_rule <> n.source_type_rule
        or o.tran_type_rule <> n.tran_type_rule
        or o.urgent_flag_rule <> n.urgent_flag_rule
        or o.prod_type_rule <> n.prod_type_rule
        or o.tran_timestamp <> n.tran_timestamp
        or o.area_code_rule <> n.area_code_rule
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_fee_mapping_cl(
            branch_rule -- 机构匹配规则
            ,category_type_rule -- 客户类型细类
            ,ccy_rule -- 费用启用规则币种
            ,client_type_rule -- 费用启用规则客户类型
            ,company -- 法人
            ,company_rule -- 费用启用规则法人
            ,doc_type_rule -- 凭证类型启用规则
            ,event_type_rule -- 费用启用规则事件类型
            ,fee_type -- 费率类型
            ,irl_seq_no -- 费率编号
            ,is_local_rule -- 跨行标志
            ,new_status_rule -- 新凭证状态启用规则
            ,old_status_rule -- 原凭证状态启用规则
            ,prod_group_rule -- 费用启用规则产品组
            ,rule_flag -- 是否使用规则
            ,service_id_rule -- 规则匹配代码
            ,source_type_rule -- 渠道类型配置值
            ,tran_type_rule -- 费用启用规则交易类型
            ,urgent_flag_rule -- 加急标志
            ,prod_type_rule -- 费用启用规则产品类型
            ,tran_timestamp -- 交易时间戳
            ,area_code_rule -- 地区匹配规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_fee_mapping_op(
            branch_rule -- 机构匹配规则
            ,category_type_rule -- 客户类型细类
            ,ccy_rule -- 费用启用规则币种
            ,client_type_rule -- 费用启用规则客户类型
            ,company -- 法人
            ,company_rule -- 费用启用规则法人
            ,doc_type_rule -- 凭证类型启用规则
            ,event_type_rule -- 费用启用规则事件类型
            ,fee_type -- 费率类型
            ,irl_seq_no -- 费率编号
            ,is_local_rule -- 跨行标志
            ,new_status_rule -- 新凭证状态启用规则
            ,old_status_rule -- 原凭证状态启用规则
            ,prod_group_rule -- 费用启用规则产品组
            ,rule_flag -- 是否使用规则
            ,service_id_rule -- 规则匹配代码
            ,source_type_rule -- 渠道类型配置值
            ,tran_type_rule -- 费用启用规则交易类型
            ,urgent_flag_rule -- 加急标志
            ,prod_type_rule -- 费用启用规则产品类型
            ,tran_timestamp -- 交易时间戳
            ,area_code_rule -- 地区匹配规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch_rule -- 机构匹配规则
    ,o.category_type_rule -- 客户类型细类
    ,o.ccy_rule -- 费用启用规则币种
    ,o.client_type_rule -- 费用启用规则客户类型
    ,o.company -- 法人
    ,o.company_rule -- 费用启用规则法人
    ,o.doc_type_rule -- 凭证类型启用规则
    ,o.event_type_rule -- 费用启用规则事件类型
    ,o.fee_type -- 费率类型
    ,o.irl_seq_no -- 费率编号
    ,o.is_local_rule -- 跨行标志
    ,o.new_status_rule -- 新凭证状态启用规则
    ,o.old_status_rule -- 原凭证状态启用规则
    ,o.prod_group_rule -- 费用启用规则产品组
    ,o.rule_flag -- 是否使用规则
    ,o.service_id_rule -- 规则匹配代码
    ,o.source_type_rule -- 渠道类型配置值
    ,o.tran_type_rule -- 费用启用规则交易类型
    ,o.urgent_flag_rule -- 加急标志
    ,o.prod_type_rule -- 费用启用规则产品类型
    ,o.tran_timestamp -- 交易时间戳
    ,o.area_code_rule -- 地区匹配规则
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
from ${iol_schema}.ncbs_mb_fee_mapping_bk o
    left join ${iol_schema}.ncbs_mb_fee_mapping_op n
        on
            o.irl_seq_no = n.irl_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_mb_fee_mapping_cl d
        on
            o.irl_seq_no = d.irl_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_mb_fee_mapping;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_mb_fee_mapping') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_mb_fee_mapping drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_mb_fee_mapping add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_mb_fee_mapping exchange partition p_${batch_date} with table ${iol_schema}.ncbs_mb_fee_mapping_cl;
alter table ${iol_schema}.ncbs_mb_fee_mapping exchange partition p_20991231 with table ${iol_schema}.ncbs_mb_fee_mapping_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_mb_fee_mapping to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_fee_mapping_op purge;
drop table ${iol_schema}.ncbs_mb_fee_mapping_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_mb_fee_mapping_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_mb_fee_mapping',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
