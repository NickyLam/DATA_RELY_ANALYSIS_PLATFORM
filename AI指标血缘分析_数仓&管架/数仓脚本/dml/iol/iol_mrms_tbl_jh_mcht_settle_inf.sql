/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_jh_mcht_settle_inf
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
create table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_jh_mcht_settle_inf;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_op purge;
drop table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_jh_mcht_settle_inf where 0=1;

create table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_jh_mcht_settle_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_cl(
            agent_cd -- 代理编号
            ,mcht_no -- 商户号
            ,settle_mode -- 商户本金清算模式
            ,settle_type -- 商户结算方式
            ,settle_bank_no -- 商户结算帐户开户行
            ,settle_bank_nm -- 商户结算帐户开户行名称
            ,settle_acct_nm -- 商户结算帐户户名
            ,settle_acct -- 商户结算帐户号
            ,acct_type -- 账户类型
            ,open_acct_area -- 开户地区
            ,open_acct_addr -- 开户地址
            ,t0_algo_id -- t1打款成本算法id
            ,t1_algo_id -- d0打款成本算法id
            ,rec_upd_ts -- 记录更新时间
            ,rec_crt_ts -- 记录创建时间
            ,misc_1 -- 保留字段1
            ,misc_2 -- 保留字段2
            ,misc_3 -- 保留字段3
            ,misc_flag -- 保留标识1
            ,reserved -- 保留
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_op(
            agent_cd -- 代理编号
            ,mcht_no -- 商户号
            ,settle_mode -- 商户本金清算模式
            ,settle_type -- 商户结算方式
            ,settle_bank_no -- 商户结算帐户开户行
            ,settle_bank_nm -- 商户结算帐户开户行名称
            ,settle_acct_nm -- 商户结算帐户户名
            ,settle_acct -- 商户结算帐户号
            ,acct_type -- 账户类型
            ,open_acct_area -- 开户地区
            ,open_acct_addr -- 开户地址
            ,t0_algo_id -- t1打款成本算法id
            ,t1_algo_id -- d0打款成本算法id
            ,rec_upd_ts -- 记录更新时间
            ,rec_crt_ts -- 记录创建时间
            ,misc_1 -- 保留字段1
            ,misc_2 -- 保留字段2
            ,misc_3 -- 保留字段3
            ,misc_flag -- 保留标识1
            ,reserved -- 保留
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agent_cd, o.agent_cd) as agent_cd -- 代理编号
    ,nvl(n.mcht_no, o.mcht_no) as mcht_no -- 商户号
    ,nvl(n.settle_mode, o.settle_mode) as settle_mode -- 商户本金清算模式
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 商户结算方式
    ,nvl(n.settle_bank_no, o.settle_bank_no) as settle_bank_no -- 商户结算帐户开户行
    ,nvl(n.settle_bank_nm, o.settle_bank_nm) as settle_bank_nm -- 商户结算帐户开户行名称
    ,nvl(n.settle_acct_nm, o.settle_acct_nm) as settle_acct_nm -- 商户结算帐户户名
    ,nvl(n.settle_acct, o.settle_acct) as settle_acct -- 商户结算帐户号
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.open_acct_area, o.open_acct_area) as open_acct_area -- 开户地区
    ,nvl(n.open_acct_addr, o.open_acct_addr) as open_acct_addr -- 开户地址
    ,nvl(n.t0_algo_id, o.t0_algo_id) as t0_algo_id -- t1打款成本算法id
    ,nvl(n.t1_algo_id, o.t1_algo_id) as t1_algo_id -- d0打款成本算法id
    ,nvl(n.rec_upd_ts, o.rec_upd_ts) as rec_upd_ts -- 记录更新时间
    ,nvl(n.rec_crt_ts, o.rec_crt_ts) as rec_crt_ts -- 记录创建时间
    ,nvl(n.misc_1, o.misc_1) as misc_1 -- 保留字段1
    ,nvl(n.misc_2, o.misc_2) as misc_2 -- 保留字段2
    ,nvl(n.misc_3, o.misc_3) as misc_3 -- 保留字段3
    ,nvl(n.misc_flag, o.misc_flag) as misc_flag -- 保留标识1
    ,nvl(n.reserved, o.reserved) as reserved -- 保留
    ,case when
            n.mcht_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mcht_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mcht_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_jh_mcht_settle_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mcht_no = n.mcht_no
where (
        o.mcht_no is null
    )
    or (
        n.mcht_no is null
    )
    or (
        o.agent_cd <> n.agent_cd
        or o.settle_mode <> n.settle_mode
        or o.settle_type <> n.settle_type
        or o.settle_bank_no <> n.settle_bank_no
        or o.settle_bank_nm <> n.settle_bank_nm
        or o.settle_acct_nm <> n.settle_acct_nm
        or o.settle_acct <> n.settle_acct
        or o.acct_type <> n.acct_type
        or o.open_acct_area <> n.open_acct_area
        or o.open_acct_addr <> n.open_acct_addr
        or o.t0_algo_id <> n.t0_algo_id
        or o.t1_algo_id <> n.t1_algo_id
        or o.rec_upd_ts <> n.rec_upd_ts
        or o.rec_crt_ts <> n.rec_crt_ts
        or o.misc_1 <> n.misc_1
        or o.misc_2 <> n.misc_2
        or o.misc_3 <> n.misc_3
        or o.misc_flag <> n.misc_flag
        or o.reserved <> n.reserved
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_cl(
            agent_cd -- 代理编号
            ,mcht_no -- 商户号
            ,settle_mode -- 商户本金清算模式
            ,settle_type -- 商户结算方式
            ,settle_bank_no -- 商户结算帐户开户行
            ,settle_bank_nm -- 商户结算帐户开户行名称
            ,settle_acct_nm -- 商户结算帐户户名
            ,settle_acct -- 商户结算帐户号
            ,acct_type -- 账户类型
            ,open_acct_area -- 开户地区
            ,open_acct_addr -- 开户地址
            ,t0_algo_id -- t1打款成本算法id
            ,t1_algo_id -- d0打款成本算法id
            ,rec_upd_ts -- 记录更新时间
            ,rec_crt_ts -- 记录创建时间
            ,misc_1 -- 保留字段1
            ,misc_2 -- 保留字段2
            ,misc_3 -- 保留字段3
            ,misc_flag -- 保留标识1
            ,reserved -- 保留
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_op(
            agent_cd -- 代理编号
            ,mcht_no -- 商户号
            ,settle_mode -- 商户本金清算模式
            ,settle_type -- 商户结算方式
            ,settle_bank_no -- 商户结算帐户开户行
            ,settle_bank_nm -- 商户结算帐户开户行名称
            ,settle_acct_nm -- 商户结算帐户户名
            ,settle_acct -- 商户结算帐户号
            ,acct_type -- 账户类型
            ,open_acct_area -- 开户地区
            ,open_acct_addr -- 开户地址
            ,t0_algo_id -- t1打款成本算法id
            ,t1_algo_id -- d0打款成本算法id
            ,rec_upd_ts -- 记录更新时间
            ,rec_crt_ts -- 记录创建时间
            ,misc_1 -- 保留字段1
            ,misc_2 -- 保留字段2
            ,misc_3 -- 保留字段3
            ,misc_flag -- 保留标识1
            ,reserved -- 保留
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agent_cd -- 代理编号
    ,o.mcht_no -- 商户号
    ,o.settle_mode -- 商户本金清算模式
    ,o.settle_type -- 商户结算方式
    ,o.settle_bank_no -- 商户结算帐户开户行
    ,o.settle_bank_nm -- 商户结算帐户开户行名称
    ,o.settle_acct_nm -- 商户结算帐户户名
    ,o.settle_acct -- 商户结算帐户号
    ,o.acct_type -- 账户类型
    ,o.open_acct_area -- 开户地区
    ,o.open_acct_addr -- 开户地址
    ,o.t0_algo_id -- t1打款成本算法id
    ,o.t1_algo_id -- d0打款成本算法id
    ,o.rec_upd_ts -- 记录更新时间
    ,o.rec_crt_ts -- 记录创建时间
    ,o.misc_1 -- 保留字段1
    ,o.misc_2 -- 保留字段2
    ,o.misc_3 -- 保留字段3
    ,o.misc_flag -- 保留标识1
    ,o.reserved -- 保留
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_bk o
    left join ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_op n
        on
            o.mcht_no = n.mcht_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_cl d
        on
            o.mcht_no = d.mcht_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf;

-- 4.2 exchange partition
alter table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf exchange partition p_19000101 with table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_cl;
alter table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_jh_mcht_settle_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_op purge;
drop table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_jh_mcht_settle_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
