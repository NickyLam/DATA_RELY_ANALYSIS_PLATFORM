/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_intstl_fee_h_isbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_intstl_fee_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_intstl_fee_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intstl_fee_h partition for ('isbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_intstl_fee_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_intstl_fee_h_isbsf1_op purge;
drop table ${iml_schema}.agt_intstl_fee_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intstl_fee_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    fee_id -- 费用编号
    ,lp_id -- 法人编号
    ,fee_cd -- 费用代码
    ,bus_table_name -- 业务表名称
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,fee_comnt -- 费用说明
    ,fee_coll_begin_dt -- 费用收取起始日期
    ,fee_coll_closing_dt -- 费用收取截止日期
    ,fee_coll_shares -- 费用收取份数
    ,avg_fee -- 平均费用
    ,fee_curr_cd -- 费用币种代码
    ,fee_amt -- 费用金额
    ,fee_convt_curr_cd -- 费用折后币种代码
    ,fee_convt_amt -- 费用折后金额
    ,fee_enter_id -- 费用入账账户编号
    ,party_id -- 当事人编号
    ,init_tran_flow_num -- 初始交易流水号
    ,tran_dt -- 交易日期
    ,stl_tran_flow_num -- 结算交易流水号
    ,stl_dt -- 结算日期
    ,role_type_cd -- 角色类型代码
    ,recvbl_amt -- 应收金额
    ,prefr_amt -- 优惠金额
    ,provi_amort_type_cd -- 计提摊销类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intstl_fee_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_intstl_fee_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intstl_fee_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_intstl_fee_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intstl_fee_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_fep-1
insert into ${iml_schema}.agt_intstl_fee_h_isbsf1_tm(
    fee_id -- 费用编号
    ,lp_id -- 法人编号
    ,fee_cd -- 费用代码
    ,bus_table_name -- 业务表名称
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,fee_comnt -- 费用说明
    ,fee_coll_begin_dt -- 费用收取起始日期
    ,fee_coll_closing_dt -- 费用收取截止日期
    ,fee_coll_shares -- 费用收取份数
    ,avg_fee -- 平均费用
    ,fee_curr_cd -- 费用币种代码
    ,fee_amt -- 费用金额
    ,fee_convt_curr_cd -- 费用折后币种代码
    ,fee_convt_amt -- 费用折后金额
    ,fee_enter_id -- 费用入账账户编号
    ,party_id -- 当事人编号
    ,init_tran_flow_num -- 初始交易流水号
    ,tran_dt -- 交易日期
    ,stl_tran_flow_num -- 结算交易流水号
    ,stl_dt -- 结算日期
    ,role_type_cd -- 角色类型代码
    ,recvbl_amt -- 应收金额
    ,prefr_amt -- 优惠金额
    ,provi_amort_type_cd -- 计提摊销类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.INR -- 费用编号
    ,'9999' -- 法人编号
    ,P1.FEECOD -- 费用代码
    ,P1.OBJTYP -- 业务表名称
    ,P1.OBJINR -- 协议编号
    ,P1.OBJINR -- 源协议编号
    ,P1.NAM -- 费用说明
    ,P1.DAT1 -- 费用收取起始日期
    ,P1.DAT2 -- 费用收取截止日期
    ,P1.UNT -- 费用收取份数
    ,P1.UNTAMT -- 平均费用
    ,P1.CUR -- 费用币种代码
    ,P1.AMT -- 费用金额
    ,P1.XRFCUR -- 费用折后币种代码
    ,P1.XRFAMT -- 费用折后金额
    ,P1.FEEACC -- 费用入账账户编号
    ,P1.PTYINR -- 当事人编号
    ,P1.SRCTRNINR -- 初始交易流水号
    ,P1.SRCDAT -- 交易日期
    ,P1.DONTRNINR -- 结算交易流水号
    ,P1.DONDAT -- 结算日期
    ,P1.ROL -- 角色类型代码
    ,P1.OGIAMT -- 应收金额
    ,P1.DCTAMT -- 优惠金额
    ,NVL(TRIM(P1.AMOFLG),'-') -- 计提摊销类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_fep' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_fep p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_intstl_fee_h_isbsf1_cl(
            fee_id -- 费用编号
    ,lp_id -- 法人编号
    ,fee_cd -- 费用代码
    ,bus_table_name -- 业务表名称
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,fee_comnt -- 费用说明
    ,fee_coll_begin_dt -- 费用收取起始日期
    ,fee_coll_closing_dt -- 费用收取截止日期
    ,fee_coll_shares -- 费用收取份数
    ,avg_fee -- 平均费用
    ,fee_curr_cd -- 费用币种代码
    ,fee_amt -- 费用金额
    ,fee_convt_curr_cd -- 费用折后币种代码
    ,fee_convt_amt -- 费用折后金额
    ,fee_enter_id -- 费用入账账户编号
    ,party_id -- 当事人编号
    ,init_tran_flow_num -- 初始交易流水号
    ,tran_dt -- 交易日期
    ,stl_tran_flow_num -- 结算交易流水号
    ,stl_dt -- 结算日期
    ,role_type_cd -- 角色类型代码
    ,recvbl_amt -- 应收金额
    ,prefr_amt -- 优惠金额
    ,provi_amort_type_cd -- 计提摊销类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_intstl_fee_h_isbsf1_op(
            fee_id -- 费用编号
    ,lp_id -- 法人编号
    ,fee_cd -- 费用代码
    ,bus_table_name -- 业务表名称
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,fee_comnt -- 费用说明
    ,fee_coll_begin_dt -- 费用收取起始日期
    ,fee_coll_closing_dt -- 费用收取截止日期
    ,fee_coll_shares -- 费用收取份数
    ,avg_fee -- 平均费用
    ,fee_curr_cd -- 费用币种代码
    ,fee_amt -- 费用金额
    ,fee_convt_curr_cd -- 费用折后币种代码
    ,fee_convt_amt -- 费用折后金额
    ,fee_enter_id -- 费用入账账户编号
    ,party_id -- 当事人编号
    ,init_tran_flow_num -- 初始交易流水号
    ,tran_dt -- 交易日期
    ,stl_tran_flow_num -- 结算交易流水号
    ,stl_dt -- 结算日期
    ,role_type_cd -- 角色类型代码
    ,recvbl_amt -- 应收金额
    ,prefr_amt -- 优惠金额
    ,provi_amort_type_cd -- 计提摊销类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fee_id, o.fee_id) as fee_id -- 费用编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.fee_cd, o.fee_cd) as fee_cd -- 费用代码
    ,nvl(n.bus_table_name, o.bus_table_name) as bus_table_name -- 业务表名称
    ,nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.fee_comnt, o.fee_comnt) as fee_comnt -- 费用说明
    ,nvl(n.fee_coll_begin_dt, o.fee_coll_begin_dt) as fee_coll_begin_dt -- 费用收取起始日期
    ,nvl(n.fee_coll_closing_dt, o.fee_coll_closing_dt) as fee_coll_closing_dt -- 费用收取截止日期
    ,nvl(n.fee_coll_shares, o.fee_coll_shares) as fee_coll_shares -- 费用收取份数
    ,nvl(n.avg_fee, o.avg_fee) as avg_fee -- 平均费用
    ,nvl(n.fee_curr_cd, o.fee_curr_cd) as fee_curr_cd -- 费用币种代码
    ,nvl(n.fee_amt, o.fee_amt) as fee_amt -- 费用金额
    ,nvl(n.fee_convt_curr_cd, o.fee_convt_curr_cd) as fee_convt_curr_cd -- 费用折后币种代码
    ,nvl(n.fee_convt_amt, o.fee_convt_amt) as fee_convt_amt -- 费用折后金额
    ,nvl(n.fee_enter_id, o.fee_enter_id) as fee_enter_id -- 费用入账账户编号
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.init_tran_flow_num, o.init_tran_flow_num) as init_tran_flow_num -- 初始交易流水号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.stl_tran_flow_num, o.stl_tran_flow_num) as stl_tran_flow_num -- 结算交易流水号
    ,nvl(n.stl_dt, o.stl_dt) as stl_dt -- 结算日期
    ,nvl(n.role_type_cd, o.role_type_cd) as role_type_cd -- 角色类型代码
    ,nvl(n.recvbl_amt, o.recvbl_amt) as recvbl_amt -- 应收金额
    ,nvl(n.prefr_amt, o.prefr_amt) as prefr_amt -- 优惠金额
    ,nvl(n.provi_amort_type_cd, o.provi_amort_type_cd) as provi_amort_type_cd -- 计提摊销类型代码
    ,case when
            n.fee_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fee_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fee_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intstl_fee_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_intstl_fee_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.fee_id = n.fee_id
            and o.lp_id = n.lp_id
where (
        o.fee_id is null
        and o.lp_id is null
    )
    or (
        n.fee_id is null
        and n.lp_id is null
    )
    or (
        o.fee_cd <> n.fee_cd
        or o.bus_table_name <> n.bus_table_name
        or o.agt_id <> n.agt_id
        or o.src_agt_id <> n.src_agt_id
        or o.fee_comnt <> n.fee_comnt
        or o.fee_coll_begin_dt <> n.fee_coll_begin_dt
        or o.fee_coll_closing_dt <> n.fee_coll_closing_dt
        or o.fee_coll_shares <> n.fee_coll_shares
        or o.avg_fee <> n.avg_fee
        or o.fee_curr_cd <> n.fee_curr_cd
        or o.fee_amt <> n.fee_amt
        or o.fee_convt_curr_cd <> n.fee_convt_curr_cd
        or o.fee_convt_amt <> n.fee_convt_amt
        or o.fee_enter_id <> n.fee_enter_id
        or o.party_id <> n.party_id
        or o.init_tran_flow_num <> n.init_tran_flow_num
        or o.tran_dt <> n.tran_dt
        or o.stl_tran_flow_num <> n.stl_tran_flow_num
        or o.stl_dt <> n.stl_dt
        or o.role_type_cd <> n.role_type_cd
        or o.recvbl_amt <> n.recvbl_amt
        or o.prefr_amt <> n.prefr_amt
        or o.provi_amort_type_cd <> n.provi_amort_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_intstl_fee_h_isbsf1_cl(
            fee_id -- 费用编号
    ,lp_id -- 法人编号
    ,fee_cd -- 费用代码
    ,bus_table_name -- 业务表名称
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,fee_comnt -- 费用说明
    ,fee_coll_begin_dt -- 费用收取起始日期
    ,fee_coll_closing_dt -- 费用收取截止日期
    ,fee_coll_shares -- 费用收取份数
    ,avg_fee -- 平均费用
    ,fee_curr_cd -- 费用币种代码
    ,fee_amt -- 费用金额
    ,fee_convt_curr_cd -- 费用折后币种代码
    ,fee_convt_amt -- 费用折后金额
    ,fee_enter_id -- 费用入账账户编号
    ,party_id -- 当事人编号
    ,init_tran_flow_num -- 初始交易流水号
    ,tran_dt -- 交易日期
    ,stl_tran_flow_num -- 结算交易流水号
    ,stl_dt -- 结算日期
    ,role_type_cd -- 角色类型代码
    ,recvbl_amt -- 应收金额
    ,prefr_amt -- 优惠金额
    ,provi_amort_type_cd -- 计提摊销类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_intstl_fee_h_isbsf1_op(
            fee_id -- 费用编号
    ,lp_id -- 法人编号
    ,fee_cd -- 费用代码
    ,bus_table_name -- 业务表名称
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,fee_comnt -- 费用说明
    ,fee_coll_begin_dt -- 费用收取起始日期
    ,fee_coll_closing_dt -- 费用收取截止日期
    ,fee_coll_shares -- 费用收取份数
    ,avg_fee -- 平均费用
    ,fee_curr_cd -- 费用币种代码
    ,fee_amt -- 费用金额
    ,fee_convt_curr_cd -- 费用折后币种代码
    ,fee_convt_amt -- 费用折后金额
    ,fee_enter_id -- 费用入账账户编号
    ,party_id -- 当事人编号
    ,init_tran_flow_num -- 初始交易流水号
    ,tran_dt -- 交易日期
    ,stl_tran_flow_num -- 结算交易流水号
    ,stl_dt -- 结算日期
    ,role_type_cd -- 角色类型代码
    ,recvbl_amt -- 应收金额
    ,prefr_amt -- 优惠金额
    ,provi_amort_type_cd -- 计提摊销类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fee_id -- 费用编号
    ,o.lp_id -- 法人编号
    ,o.fee_cd -- 费用代码
    ,o.bus_table_name -- 业务表名称
    ,o.agt_id -- 协议编号
    ,o.src_agt_id -- 源协议编号
    ,o.fee_comnt -- 费用说明
    ,o.fee_coll_begin_dt -- 费用收取起始日期
    ,o.fee_coll_closing_dt -- 费用收取截止日期
    ,o.fee_coll_shares -- 费用收取份数
    ,o.avg_fee -- 平均费用
    ,o.fee_curr_cd -- 费用币种代码
    ,o.fee_amt -- 费用金额
    ,o.fee_convt_curr_cd -- 费用折后币种代码
    ,o.fee_convt_amt -- 费用折后金额
    ,o.fee_enter_id -- 费用入账账户编号
    ,o.party_id -- 当事人编号
    ,o.init_tran_flow_num -- 初始交易流水号
    ,o.tran_dt -- 交易日期
    ,o.stl_tran_flow_num -- 结算交易流水号
    ,o.stl_dt -- 结算日期
    ,o.role_type_cd -- 角色类型代码
    ,o.recvbl_amt -- 应收金额
    ,o.prefr_amt -- 优惠金额
    ,o.provi_amort_type_cd -- 计提摊销类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intstl_fee_h_isbsf1_bk o
    left join ${iml_schema}.agt_intstl_fee_h_isbsf1_op n
        on
            o.fee_id = n.fee_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_intstl_fee_h_isbsf1_cl d
        on
            o.fee_id = d.fee_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_intstl_fee_h;
alter table ${iml_schema}.agt_intstl_fee_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_intstl_fee_h exchange subpartition p_isbsf1_19000101 with table ${iml_schema}.agt_intstl_fee_h_isbsf1_cl;
alter table ${iml_schema}.agt_intstl_fee_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_intstl_fee_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_intstl_fee_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_intstl_fee_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_intstl_fee_h_isbsf1_op purge;
drop table ${iml_schema}.agt_intstl_fee_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_intstl_fee_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_intstl_fee_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
