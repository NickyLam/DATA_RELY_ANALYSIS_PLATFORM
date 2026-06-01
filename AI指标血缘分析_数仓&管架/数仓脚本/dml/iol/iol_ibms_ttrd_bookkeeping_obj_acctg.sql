/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_bookkeeping_obj_acctg
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
create table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_op purge;
drop table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg where 0=1;

create table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_cl(
            tsk_id -- 
            ,beg_date -- 
            ,end_date -- 
            ,subj_org_id -- 
            ,subj_code -- 
            ,subj_sub_code -- 
            ,inner_acct_sn -- 
            ,core_acct_code -- 
            ,currency -- 
            ,debit_value -- 
            ,credit_value -- 
            ,pay_value -- 
            ,receive_value -- 
            ,secu_acct_id -- 
            ,cash_acct_id -- 
            ,update_time -- 
            ,core_acct_name -- 
            ,t_currency -- 折算币种
            ,t_credit_value -- 折算后贷方余额
            ,t_debit_value -- 折算后借方余额
            ,acctg_obj_id -- 核算对象ID
            ,ext_i_code -- 金融工具代码
            ,ext_a_type -- 金融工具资产类型
            ,ext_m_type -- 金融工具市场类型
            ,ext_dim1 -- 扩展维度1
            ,ext_dim2 -- 扩展维度2
            ,ext_dim3 -- 扩展维度3
            ,ext_dim4 -- 扩展维度4
            ,ext_dim5 -- 扩展维度5
            ,ext_dim6 -- 扩展维度6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_op(
            tsk_id -- 
            ,beg_date -- 
            ,end_date -- 
            ,subj_org_id -- 
            ,subj_code -- 
            ,subj_sub_code -- 
            ,inner_acct_sn -- 
            ,core_acct_code -- 
            ,currency -- 
            ,debit_value -- 
            ,credit_value -- 
            ,pay_value -- 
            ,receive_value -- 
            ,secu_acct_id -- 
            ,cash_acct_id -- 
            ,update_time -- 
            ,core_acct_name -- 
            ,t_currency -- 折算币种
            ,t_credit_value -- 折算后贷方余额
            ,t_debit_value -- 折算后借方余额
            ,acctg_obj_id -- 核算对象ID
            ,ext_i_code -- 金融工具代码
            ,ext_a_type -- 金融工具资产类型
            ,ext_m_type -- 金融工具市场类型
            ,ext_dim1 -- 扩展维度1
            ,ext_dim2 -- 扩展维度2
            ,ext_dim3 -- 扩展维度3
            ,ext_dim4 -- 扩展维度4
            ,ext_dim5 -- 扩展维度5
            ,ext_dim6 -- 扩展维度6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tsk_id, o.tsk_id) as tsk_id -- 
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 
    ,nvl(n.end_date, o.end_date) as end_date -- 
    ,nvl(n.subj_org_id, o.subj_org_id) as subj_org_id -- 
    ,nvl(n.subj_code, o.subj_code) as subj_code -- 
    ,nvl(n.subj_sub_code, o.subj_sub_code) as subj_sub_code -- 
    ,nvl(n.inner_acct_sn, o.inner_acct_sn) as inner_acct_sn -- 
    ,nvl(n.core_acct_code, o.core_acct_code) as core_acct_code -- 
    ,nvl(n.currency, o.currency) as currency -- 
    ,nvl(n.debit_value, o.debit_value) as debit_value -- 
    ,nvl(n.credit_value, o.credit_value) as credit_value -- 
    ,nvl(n.pay_value, o.pay_value) as pay_value -- 
    ,nvl(n.receive_value, o.receive_value) as receive_value -- 
    ,nvl(n.secu_acct_id, o.secu_acct_id) as secu_acct_id -- 
    ,nvl(n.cash_acct_id, o.cash_acct_id) as cash_acct_id -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.core_acct_name, o.core_acct_name) as core_acct_name -- 
    ,nvl(n.t_currency, o.t_currency) as t_currency -- 折算币种
    ,nvl(n.t_credit_value, o.t_credit_value) as t_credit_value -- 折算后贷方余额
    ,nvl(n.t_debit_value, o.t_debit_value) as t_debit_value -- 折算后借方余额
    ,nvl(n.acctg_obj_id, o.acctg_obj_id) as acctg_obj_id -- 核算对象ID
    ,nvl(n.ext_i_code, o.ext_i_code) as ext_i_code -- 金融工具代码
    ,nvl(n.ext_a_type, o.ext_a_type) as ext_a_type -- 金融工具资产类型
    ,nvl(n.ext_m_type, o.ext_m_type) as ext_m_type -- 金融工具市场类型
    ,nvl(n.ext_dim1, o.ext_dim1) as ext_dim1 -- 扩展维度1
    ,nvl(n.ext_dim2, o.ext_dim2) as ext_dim2 -- 扩展维度2
    ,nvl(n.ext_dim3, o.ext_dim3) as ext_dim3 -- 扩展维度3
    ,nvl(n.ext_dim4, o.ext_dim4) as ext_dim4 -- 扩展维度4
    ,nvl(n.ext_dim5, o.ext_dim5) as ext_dim5 -- 扩展维度5
    ,nvl(n.ext_dim6, o.ext_dim6) as ext_dim6 -- 扩展维度6
    ,case when
            n.tsk_id is null
            and n.beg_date is null
            and n.subj_org_id is null
            and n.subj_code is null
            and n.subj_sub_code is null
            and n.inner_acct_sn is null
            and n.currency is null
            and n.secu_acct_id is null
            and n.cash_acct_id is null
            and n.acctg_obj_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tsk_id is null
            and n.beg_date is null
            and n.subj_org_id is null
            and n.subj_code is null
            and n.subj_sub_code is null
            and n.inner_acct_sn is null
            and n.currency is null
            and n.secu_acct_id is null
            and n.cash_acct_id is null
            and n.acctg_obj_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tsk_id is null
            and n.beg_date is null
            and n.subj_org_id is null
            and n.subj_code is null
            and n.subj_sub_code is null
            and n.inner_acct_sn is null
            and n.currency is null
            and n.secu_acct_id is null
            and n.cash_acct_id is null
            and n.acctg_obj_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_bookkeeping_obj_acctg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tsk_id = n.tsk_id
            and o.beg_date = n.beg_date
            and o.subj_org_id = n.subj_org_id
            and o.subj_code = n.subj_code
            and o.subj_sub_code = n.subj_sub_code
            and o.inner_acct_sn = n.inner_acct_sn
            and o.currency = n.currency
            and o.secu_acct_id = n.secu_acct_id
            and o.cash_acct_id = n.cash_acct_id
            and o.acctg_obj_id = n.acctg_obj_id
where (
        o.tsk_id is null
        and o.beg_date is null
        and o.subj_org_id is null
        and o.subj_code is null
        and o.subj_sub_code is null
        and o.inner_acct_sn is null
        and o.currency is null
        and o.secu_acct_id is null
        and o.cash_acct_id is null
        and o.acctg_obj_id is null
    )
    or (
        n.tsk_id is null
        and n.beg_date is null
        and n.subj_org_id is null
        and n.subj_code is null
        and n.subj_sub_code is null
        and n.inner_acct_sn is null
        and n.currency is null
        and n.secu_acct_id is null
        and n.cash_acct_id is null
        and n.acctg_obj_id is null
    )
    or (
        o.end_date <> n.end_date
        or o.core_acct_code <> n.core_acct_code
        or o.debit_value <> n.debit_value
        or o.credit_value <> n.credit_value
        or o.pay_value <> n.pay_value
        or o.receive_value <> n.receive_value
        or o.update_time <> n.update_time
        or o.core_acct_name <> n.core_acct_name
        or o.t_currency <> n.t_currency
        or o.t_credit_value <> n.t_credit_value
        or o.t_debit_value <> n.t_debit_value
        or o.ext_i_code <> n.ext_i_code
        or o.ext_a_type <> n.ext_a_type
        or o.ext_m_type <> n.ext_m_type
        or o.ext_dim1 <> n.ext_dim1
        or o.ext_dim2 <> n.ext_dim2
        or o.ext_dim3 <> n.ext_dim3
        or o.ext_dim4 <> n.ext_dim4
        or o.ext_dim5 <> n.ext_dim5
        or o.ext_dim6 <> n.ext_dim6
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_cl(
            tsk_id -- 
            ,beg_date -- 
            ,end_date -- 
            ,subj_org_id -- 
            ,subj_code -- 
            ,subj_sub_code -- 
            ,inner_acct_sn -- 
            ,core_acct_code -- 
            ,currency -- 
            ,debit_value -- 
            ,credit_value -- 
            ,pay_value -- 
            ,receive_value -- 
            ,secu_acct_id -- 
            ,cash_acct_id -- 
            ,update_time -- 
            ,core_acct_name -- 
            ,t_currency -- 折算币种
            ,t_credit_value -- 折算后贷方余额
            ,t_debit_value -- 折算后借方余额
            ,acctg_obj_id -- 核算对象ID
            ,ext_i_code -- 金融工具代码
            ,ext_a_type -- 金融工具资产类型
            ,ext_m_type -- 金融工具市场类型
            ,ext_dim1 -- 扩展维度1
            ,ext_dim2 -- 扩展维度2
            ,ext_dim3 -- 扩展维度3
            ,ext_dim4 -- 扩展维度4
            ,ext_dim5 -- 扩展维度5
            ,ext_dim6 -- 扩展维度6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_op(
            tsk_id -- 
            ,beg_date -- 
            ,end_date -- 
            ,subj_org_id -- 
            ,subj_code -- 
            ,subj_sub_code -- 
            ,inner_acct_sn -- 
            ,core_acct_code -- 
            ,currency -- 
            ,debit_value -- 
            ,credit_value -- 
            ,pay_value -- 
            ,receive_value -- 
            ,secu_acct_id -- 
            ,cash_acct_id -- 
            ,update_time -- 
            ,core_acct_name -- 
            ,t_currency -- 折算币种
            ,t_credit_value -- 折算后贷方余额
            ,t_debit_value -- 折算后借方余额
            ,acctg_obj_id -- 核算对象ID
            ,ext_i_code -- 金融工具代码
            ,ext_a_type -- 金融工具资产类型
            ,ext_m_type -- 金融工具市场类型
            ,ext_dim1 -- 扩展维度1
            ,ext_dim2 -- 扩展维度2
            ,ext_dim3 -- 扩展维度3
            ,ext_dim4 -- 扩展维度4
            ,ext_dim5 -- 扩展维度5
            ,ext_dim6 -- 扩展维度6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tsk_id -- 
    ,o.beg_date -- 
    ,o.end_date -- 
    ,o.subj_org_id -- 
    ,o.subj_code -- 
    ,o.subj_sub_code -- 
    ,o.inner_acct_sn -- 
    ,o.core_acct_code -- 
    ,o.currency -- 
    ,o.debit_value -- 
    ,o.credit_value -- 
    ,o.pay_value -- 
    ,o.receive_value -- 
    ,o.secu_acct_id -- 
    ,o.cash_acct_id -- 
    ,o.update_time -- 
    ,o.core_acct_name -- 
    ,o.t_currency -- 折算币种
    ,o.t_credit_value -- 折算后贷方余额
    ,o.t_debit_value -- 折算后借方余额
    ,o.acctg_obj_id -- 核算对象ID
    ,o.ext_i_code -- 金融工具代码
    ,o.ext_a_type -- 金融工具资产类型
    ,o.ext_m_type -- 金融工具市场类型
    ,o.ext_dim1 -- 扩展维度1
    ,o.ext_dim2 -- 扩展维度2
    ,o.ext_dim3 -- 扩展维度3
    ,o.ext_dim4 -- 扩展维度4
    ,o.ext_dim5 -- 扩展维度5
    ,o.ext_dim6 -- 扩展维度6
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_bk o
    left join ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_op n
        on
            o.tsk_id = n.tsk_id
            and o.beg_date = n.beg_date
            and o.subj_org_id = n.subj_org_id
            and o.subj_code = n.subj_code
            and o.subj_sub_code = n.subj_sub_code
            and o.inner_acct_sn = n.inner_acct_sn
            and o.currency = n.currency
            and o.secu_acct_id = n.secu_acct_id
            and o.cash_acct_id = n.cash_acct_id
            and o.acctg_obj_id = n.acctg_obj_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_cl d
        on
            o.tsk_id = d.tsk_id
            and o.beg_date = d.beg_date
            and o.subj_org_id = d.subj_org_id
            and o.subj_code = d.subj_code
            and o.subj_sub_code = d.subj_sub_code
            and o.inner_acct_sn = d.inner_acct_sn
            and o.currency = d.currency
            and o.secu_acct_id = d.secu_acct_id
            and o.cash_acct_id = d.cash_acct_id
            and o.acctg_obj_id = d.acctg_obj_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_cl;
alter table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_op purge;
drop table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_bookkeeping_obj_acctg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
