/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_hx_counterparty_registry
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
create table ${iol_schema}.ibms_ttrd_hx_counterparty_registry_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_hx_counterparty_registry
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_hx_counterparty_registry_op purge;
drop table ${iol_schema}.ibms_ttrd_hx_counterparty_registry_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_hx_counterparty_registry_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_hx_counterparty_registry where 0=1;

create table ${iol_schema}.ibms_ttrd_hx_counterparty_registry_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_hx_counterparty_registry where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_hx_counterparty_registry_cl(
            registry_id -- 主键
            ,entry_id -- 分录ID
            ,entry_date -- 记账日期
            ,inst_id -- 指令号
            ,global_flow_no -- 全局流水号
            ,flow_no -- 系统分录流水号
            ,flow_inner_sn -- 交易流水序号
            ,i_code -- 金融工具代码
            ,a_type -- 资产代码
            ,m_type -- 市场类型
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,i_name -- 金融工具名称
            ,subj_code -- 科目号
            ,debit_credit_flag -- 借贷标识,1：借；2：贷。
            ,red_blue_flag -- 红蓝字标识,1：普通,2：红；3：蓝
            ,value -- 金额
            ,currency -- 币种
            ,prod_code -- 标准产品编码
            ,prod_name -- 标准产品名称
            ,party_acct_code -- 对手方账号
            ,party_acct_name -- 对手方户名
            ,party_bank_code -- 对手方开户行
            ,party_bank_name -- 对手方开户行名
            ,state -- 状态，0:交易对手信息未填充，1：交易对手信息已填充
            ,update_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_hx_counterparty_registry_op(
            registry_id -- 主键
            ,entry_id -- 分录ID
            ,entry_date -- 记账日期
            ,inst_id -- 指令号
            ,global_flow_no -- 全局流水号
            ,flow_no -- 系统分录流水号
            ,flow_inner_sn -- 交易流水序号
            ,i_code -- 金融工具代码
            ,a_type -- 资产代码
            ,m_type -- 市场类型
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,i_name -- 金融工具名称
            ,subj_code -- 科目号
            ,debit_credit_flag -- 借贷标识,1：借；2：贷。
            ,red_blue_flag -- 红蓝字标识,1：普通,2：红；3：蓝
            ,value -- 金额
            ,currency -- 币种
            ,prod_code -- 标准产品编码
            ,prod_name -- 标准产品名称
            ,party_acct_code -- 对手方账号
            ,party_acct_name -- 对手方户名
            ,party_bank_code -- 对手方开户行
            ,party_bank_name -- 对手方开户行名
            ,state -- 状态，0:交易对手信息未填充，1：交易对手信息已填充
            ,update_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.registry_id, o.registry_id) as registry_id -- 主键
    ,nvl(n.entry_id, o.entry_id) as entry_id -- 分录ID
    ,nvl(n.entry_date, o.entry_date) as entry_date -- 记账日期
    ,nvl(n.inst_id, o.inst_id) as inst_id -- 指令号
    ,nvl(n.global_flow_no, o.global_flow_no) as global_flow_no -- 全局流水号
    ,nvl(n.flow_no, o.flow_no) as flow_no -- 系统分录流水号
    ,nvl(n.flow_inner_sn, o.flow_inner_sn) as flow_inner_sn -- 交易流水序号
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产代码
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.p_type, o.p_type) as p_type -- 产品类型
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类
    ,nvl(n.i_name, o.i_name) as i_name -- 金融工具名称
    ,nvl(n.subj_code, o.subj_code) as subj_code -- 科目号
    ,nvl(n.debit_credit_flag, o.debit_credit_flag) as debit_credit_flag -- 借贷标识,1：借；2：贷。
    ,nvl(n.red_blue_flag, o.red_blue_flag) as red_blue_flag -- 红蓝字标识,1：普通,2：红；3：蓝
    ,nvl(n.value, o.value) as value -- 金额
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.prod_code, o.prod_code) as prod_code -- 标准产品编码
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 标准产品名称
    ,nvl(n.party_acct_code, o.party_acct_code) as party_acct_code -- 对手方账号
    ,nvl(n.party_acct_name, o.party_acct_name) as party_acct_name -- 对手方户名
    ,nvl(n.party_bank_code, o.party_bank_code) as party_bank_code -- 对手方开户行
    ,nvl(n.party_bank_name, o.party_bank_name) as party_bank_name -- 对手方开户行名
    ,nvl(n.state, o.state) as state -- 状态，0:交易对手信息未填充，1：交易对手信息已填充
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,case when
            n.registry_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.registry_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.registry_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_hx_counterparty_registry_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_hx_counterparty_registry where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.registry_id = n.registry_id
where (
        o.registry_id is null
    )
    or (
        n.registry_id is null
    )
    or (
        o.entry_id <> n.entry_id
        or o.entry_date <> n.entry_date
        or o.inst_id <> n.inst_id
        or o.global_flow_no <> n.global_flow_no
        or o.flow_no <> n.flow_no
        or o.flow_inner_sn <> n.flow_inner_sn
        or o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.p_type <> n.p_type
        or o.p_class <> n.p_class
        or o.i_name <> n.i_name
        or o.subj_code <> n.subj_code
        or o.debit_credit_flag <> n.debit_credit_flag
        or o.red_blue_flag <> n.red_blue_flag
        or o.value <> n.value
        or o.currency <> n.currency
        or o.prod_code <> n.prod_code
        or o.prod_name <> n.prod_name
        or o.party_acct_code <> n.party_acct_code
        or o.party_acct_name <> n.party_acct_name
        or o.party_bank_code <> n.party_bank_code
        or o.party_bank_name <> n.party_bank_name
        or o.state <> n.state
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_hx_counterparty_registry_cl(
            registry_id -- 主键
            ,entry_id -- 分录ID
            ,entry_date -- 记账日期
            ,inst_id -- 指令号
            ,global_flow_no -- 全局流水号
            ,flow_no -- 系统分录流水号
            ,flow_inner_sn -- 交易流水序号
            ,i_code -- 金融工具代码
            ,a_type -- 资产代码
            ,m_type -- 市场类型
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,i_name -- 金融工具名称
            ,subj_code -- 科目号
            ,debit_credit_flag -- 借贷标识,1：借；2：贷。
            ,red_blue_flag -- 红蓝字标识,1：普通,2：红；3：蓝
            ,value -- 金额
            ,currency -- 币种
            ,prod_code -- 标准产品编码
            ,prod_name -- 标准产品名称
            ,party_acct_code -- 对手方账号
            ,party_acct_name -- 对手方户名
            ,party_bank_code -- 对手方开户行
            ,party_bank_name -- 对手方开户行名
            ,state -- 状态，0:交易对手信息未填充，1：交易对手信息已填充
            ,update_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_hx_counterparty_registry_op(
            registry_id -- 主键
            ,entry_id -- 分录ID
            ,entry_date -- 记账日期
            ,inst_id -- 指令号
            ,global_flow_no -- 全局流水号
            ,flow_no -- 系统分录流水号
            ,flow_inner_sn -- 交易流水序号
            ,i_code -- 金融工具代码
            ,a_type -- 资产代码
            ,m_type -- 市场类型
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,i_name -- 金融工具名称
            ,subj_code -- 科目号
            ,debit_credit_flag -- 借贷标识,1：借；2：贷。
            ,red_blue_flag -- 红蓝字标识,1：普通,2：红；3：蓝
            ,value -- 金额
            ,currency -- 币种
            ,prod_code -- 标准产品编码
            ,prod_name -- 标准产品名称
            ,party_acct_code -- 对手方账号
            ,party_acct_name -- 对手方户名
            ,party_bank_code -- 对手方开户行
            ,party_bank_name -- 对手方开户行名
            ,state -- 状态，0:交易对手信息未填充，1：交易对手信息已填充
            ,update_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.registry_id -- 主键
    ,o.entry_id -- 分录ID
    ,o.entry_date -- 记账日期
    ,o.inst_id -- 指令号
    ,o.global_flow_no -- 全局流水号
    ,o.flow_no -- 系统分录流水号
    ,o.flow_inner_sn -- 交易流水序号
    ,o.i_code -- 金融工具代码
    ,o.a_type -- 资产代码
    ,o.m_type -- 市场类型
    ,o.p_type -- 产品类型
    ,o.p_class -- 产品分类
    ,o.i_name -- 金融工具名称
    ,o.subj_code -- 科目号
    ,o.debit_credit_flag -- 借贷标识,1：借；2：贷。
    ,o.red_blue_flag -- 红蓝字标识,1：普通,2：红；3：蓝
    ,o.value -- 金额
    ,o.currency -- 币种
    ,o.prod_code -- 标准产品编码
    ,o.prod_name -- 标准产品名称
    ,o.party_acct_code -- 对手方账号
    ,o.party_acct_name -- 对手方户名
    ,o.party_bank_code -- 对手方开户行
    ,o.party_bank_name -- 对手方开户行名
    ,o.state -- 状态，0:交易对手信息未填充，1：交易对手信息已填充
    ,o.update_time -- 
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
from ${iol_schema}.ibms_ttrd_hx_counterparty_registry_bk o
    left join ${iol_schema}.ibms_ttrd_hx_counterparty_registry_op n
        on
            o.registry_id = n.registry_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_hx_counterparty_registry_cl d
        on
            o.registry_id = d.registry_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_hx_counterparty_registry;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_hx_counterparty_registry') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_hx_counterparty_registry drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_hx_counterparty_registry add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_hx_counterparty_registry exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_hx_counterparty_registry_cl;
alter table ${iol_schema}.ibms_ttrd_hx_counterparty_registry exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_hx_counterparty_registry_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_hx_counterparty_registry to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_hx_counterparty_registry_op purge;
drop table ${iol_schema}.ibms_ttrd_hx_counterparty_registry_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_hx_counterparty_registry_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_hx_counterparty_registry',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
