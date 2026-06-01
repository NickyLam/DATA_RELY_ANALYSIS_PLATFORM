/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_finc_acct_unpaid_prft_h_ifmsi1
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
alter table ${iml_schema}.agt_finc_acct_unpaid_prft_h add partition p_ifmsi1 values ('ifmsi1')(
        subpartition p_ifmsi1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ifmsi1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_acct_unpaid_prft_h partition for ('ifmsi1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_tm purge;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_op purge;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,seller_id -- 销售商编号
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,lot_bal -- 份额余额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_acct_unpaid_prft_h partition for ('ifmsi1')
where 0=1
;

create table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_acct_unpaid_prft_h partition for ('ifmsi1') where 0=1;

create table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_acct_unpaid_prft_h partition for ('ifmsi1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbincome-
insert into ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,seller_id -- 销售商编号
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,lot_bal -- 份额余额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160010'||P2.IN_CLIENT_NO||P2.TA_CODE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.PRD_CODE -- 产品编号
    ,NVL(TRIM(P1.SHARE_CLASS),'-') -- 收费方式代码
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.INCOME -- 未付收益
    ,P1.FROZEN_INCOME -- 冻结未付收益
    ,P1.INCOME_NEW -- 当天新增未付收益
    ,P1.REAL_VOL -- 份额余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbincome' -- 源表名称
    ,'ifmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbincome p1
    left join ${iol_schema}.ifms_tbassetacc p2 on P1.asset_acc=P2.ASSET_ACC
      and P2.start_dt<=to_date('${batch_date}','YYYYMMDD') and P2.end_dt>to_date('${batch_date}','YYYYMMDD')
where  1 = 1 
    and cfm_date='${batch_date}'
;
commit;


commit;

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_op(
        agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,seller_id -- 销售商编号
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,lot_bal -- 份额余额
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.agt_id -- 协议编号
    ,n.lp_id -- 法人编号
    ,n.finc_acct_id -- 理财账户编号
    ,n.ta_tran_acct_id -- TA交易账户编号
    ,n.prod_id -- 产品编号
    ,n.charge_way_cd -- 收费方式代码
    ,n.seller_id -- 销售商编号
    ,n.unpaid_prft -- 未付收益
    ,n.froz_unpaid_prft -- 冻结未付收益
    ,n.td_add_unpaid_prft -- 当天新增未付收益
    ,n.lot_bal -- 份额余额
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'ifmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_tm n
    left join (select * from ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.finc_acct_id = n.finc_acct_id
            and o.ta_tran_acct_id = n.ta_tran_acct_id
            and o.prod_id = n.prod_id
            and o.charge_way_cd = n.charge_way_cd
            and o.seller_id = n.seller_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.finc_acct_id is null
        and o.ta_tran_acct_id is null
        and o.prod_id is null
        and o.charge_way_cd is null
        and o.seller_id is null
    )
    or (
        o.unpaid_prft <> n.unpaid_prft
        or o.froz_unpaid_prft <> n.froz_unpaid_prft
        or o.td_add_unpaid_prft <> n.td_add_unpaid_prft
        or o.lot_bal <> n.lot_bal
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,seller_id -- 销售商编号
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,lot_bal -- 份额余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,seller_id -- 销售商编号
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,lot_bal -- 份额余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.finc_acct_id -- 理财账户编号
    ,o.ta_tran_acct_id -- TA交易账户编号
    ,o.prod_id -- 产品编号
    ,o.charge_way_cd -- 收费方式代码
    ,o.seller_id -- 销售商编号
    ,o.unpaid_prft -- 未付收益
    ,o.froz_unpaid_prft -- 冻结未付收益
    ,o.td_add_unpaid_prft -- 当天新增未付收益
    ,o.lot_bal -- 份额余额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_bk o
    left join ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.finc_acct_id = n.finc_acct_id
            and o.ta_tran_acct_id = n.ta_tran_acct_id
            and o.prod_id = n.prod_id
            and o.charge_way_cd = n.charge_way_cd
            and o.seller_id = n.seller_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_finc_acct_unpaid_prft_h;
alter table ${iml_schema}.agt_finc_acct_unpaid_prft_h truncate partition for ('ifmsi1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_finc_acct_unpaid_prft_h exchange subpartition p_ifmsi1_19000101 with table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_cl;
alter table ${iml_schema}.agt_finc_acct_unpaid_prft_h exchange subpartition p_ifmsi1_20991231 with table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_finc_acct_unpaid_prft_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_tm purge;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_op purge;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_finc_acct_unpaid_prft_h', partname => 'p_ifmsi1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
