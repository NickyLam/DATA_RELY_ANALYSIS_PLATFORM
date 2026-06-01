/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_qxb_bal_lot_h_fsmsi1
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
alter table ${iml_schema}.agt_qxb_bal_lot_h add partition p_fsmsi1 values ('fsmsi1')(
        subpartition p_fsmsi1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_fsmsi1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_qxb_bal_lot_h partition for ('fsmsi1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_tm purge;
drop table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_op purge;
drop table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sell_mode_cd -- 销售模式代码
    ,fund_cd_id -- 基金代码编号
    ,ibank_no -- 联行号
    ,fund_cust_id -- 基金客户编号
    ,tran_acct_num -- 交易账号
    ,ta_cd -- TA代码
    ,prod_lot -- 产品份额
    ,uncfm_prod_amt -- 未确认产品金额
    ,uncfm_quick_redem_lot -- 未确认快速赎回份额
    ,tran_froz_lot -- 交易冻结份额
    ,froz_lot -- 冻结份额
    ,bank_froz_lot -- 银行冻结份额
    ,buy_cost -- 买入成本
    ,redem_amt -- 赎回金额
    ,unpay_turn_prft -- 未结转收益
    ,acm_prft -- 累计收益
    ,fir_subscr_dt -- 首次认购日期
    ,lot_type_cd -- 份额类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_qxb_bal_lot_h partition for ('fsmsi1')
where 0=1
;

create table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_qxb_bal_lot_h partition for ('fsmsi1') where 0=1;

create table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_qxb_bal_lot_h partition for ('fsmsi1') where 0=1;

-- 3.1 get new data into table
-- fsms_yeb_bal_his-
insert into ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sell_mode_cd -- 销售模式代码
    ,fund_cd_id -- 基金代码编号
    ,ibank_no -- 联行号
    ,fund_cust_id -- 基金客户编号
    ,tran_acct_num -- 交易账号
    ,ta_cd -- TA代码
    ,prod_lot -- 产品份额
    ,uncfm_prod_amt -- 未确认产品金额
    ,uncfm_quick_redem_lot -- 未确认快速赎回份额
    ,tran_froz_lot -- 交易冻结份额
    ,froz_lot -- 冻结份额
    ,bank_froz_lot -- 银行冻结份额
    ,buy_cost -- 买入成本
    ,redem_amt -- 赎回金额
    ,unpay_turn_prft -- 未结转收益
    ,acm_prft -- 累计收益
    ,fir_subscr_dt -- 首次认购日期
    ,lot_type_cd -- 份额类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '170000'||P1.TANO||P1.CUST_NO -- 协议编号
    ,'9999' -- 法人编号
    ,NVL(TRIM(P1.TASYSMODEL),'-') -- 销售模式代码
    ,P1.FUNDCODE -- 基金代码编号
    ,P1.UNIONCODE -- 联行号
    ,P1.CUST_NO -- 基金客户编号
    ,P1.TRANSACTIONACCOUNTID -- 交易账号
    ,P1.TANO -- TA代码
    ,P1.FUND_VOL -- 产品份额
    ,P1.FUND_AMT -- 未确认产品金额
    ,P1.QUICK_REDEM_VOL -- 未确认快速赎回份额
    ,P1.TRD_FROZEN -- 交易冻结份额
    ,P1.FROZEN_VOL -- 冻结份额
    ,P1.ABNMFROZEN -- 银行冻结份额
    ,P1.BUYMONEY -- 买入成本
    ,P1.REDEEMMONEY -- 赎回金额
    ,P1.INCOME -- 未结转收益
    ,P1.SUM_INTEREST_AMT -- 累计收益
    ,${iml_schema}.DATEFORMAT_MIN(P1.FIRSTSUBDATE) -- 首次认购日期
    ,NVL(TRIM(P1.BALTYPE),'-') -- 份额类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_yeb_bal_his' -- 源表名称
    ,'fsmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_yeb_bal_his p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.INSERTDATE='${batch_date}'
;
commit;


commit;

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_op(
        agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sell_mode_cd -- 销售模式代码
    ,fund_cd_id -- 基金代码编号
    ,ibank_no -- 联行号
    ,fund_cust_id -- 基金客户编号
    ,tran_acct_num -- 交易账号
    ,ta_cd -- TA代码
    ,prod_lot -- 产品份额
    ,uncfm_prod_amt -- 未确认产品金额
    ,uncfm_quick_redem_lot -- 未确认快速赎回份额
    ,tran_froz_lot -- 交易冻结份额
    ,froz_lot -- 冻结份额
    ,bank_froz_lot -- 银行冻结份额
    ,buy_cost -- 买入成本
    ,redem_amt -- 赎回金额
    ,unpay_turn_prft -- 未结转收益
    ,acm_prft -- 累计收益
    ,fir_subscr_dt -- 首次认购日期
    ,lot_type_cd -- 份额类型代码
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
    ,n.sell_mode_cd -- 销售模式代码
    ,n.fund_cd_id -- 基金代码编号
    ,n.ibank_no -- 联行号
    ,n.fund_cust_id -- 基金客户编号
    ,n.tran_acct_num -- 交易账号
    ,n.ta_cd -- TA代码
    ,n.prod_lot -- 产品份额
    ,n.uncfm_prod_amt -- 未确认产品金额
    ,n.uncfm_quick_redem_lot -- 未确认快速赎回份额
    ,n.tran_froz_lot -- 交易冻结份额
    ,n.froz_lot -- 冻结份额
    ,n.bank_froz_lot -- 银行冻结份额
    ,n.buy_cost -- 买入成本
    ,n.redem_amt -- 赎回金额
    ,n.unpay_turn_prft -- 未结转收益
    ,n.acm_prft -- 累计收益
    ,n.fir_subscr_dt -- 首次认购日期
    ,n.lot_type_cd -- 份额类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'fsmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_tm n
    left join (select * from ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.sell_mode_cd = n.sell_mode_cd
            and o.fund_cd_id = n.fund_cd_id
            and o.ibank_no = n.ibank_no
where (
        o.agt_id is null
        and o.lp_id is null
        and o.sell_mode_cd is null
        and o.fund_cd_id is null
        and o.ibank_no is null
    )
    or (
        o.fund_cust_id <> n.fund_cust_id
        or o.tran_acct_num <> n.tran_acct_num
        or o.ta_cd <> n.ta_cd
        or o.prod_lot <> n.prod_lot
        or o.uncfm_prod_amt <> n.uncfm_prod_amt
        or o.uncfm_quick_redem_lot <> n.uncfm_quick_redem_lot
        or o.tran_froz_lot <> n.tran_froz_lot
        or o.froz_lot <> n.froz_lot
        or o.bank_froz_lot <> n.bank_froz_lot
        or o.buy_cost <> n.buy_cost
        or o.redem_amt <> n.redem_amt
        or o.unpay_turn_prft <> n.unpay_turn_prft
        or o.acm_prft <> n.acm_prft
        or o.fir_subscr_dt <> n.fir_subscr_dt
        or o.lot_type_cd <> n.lot_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sell_mode_cd -- 销售模式代码
    ,fund_cd_id -- 基金代码编号
    ,ibank_no -- 联行号
    ,fund_cust_id -- 基金客户编号
    ,tran_acct_num -- 交易账号
    ,ta_cd -- TA代码
    ,prod_lot -- 产品份额
    ,uncfm_prod_amt -- 未确认产品金额
    ,uncfm_quick_redem_lot -- 未确认快速赎回份额
    ,tran_froz_lot -- 交易冻结份额
    ,froz_lot -- 冻结份额
    ,bank_froz_lot -- 银行冻结份额
    ,buy_cost -- 买入成本
    ,redem_amt -- 赎回金额
    ,unpay_turn_prft -- 未结转收益
    ,acm_prft -- 累计收益
    ,fir_subscr_dt -- 首次认购日期
    ,lot_type_cd -- 份额类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sell_mode_cd -- 销售模式代码
    ,fund_cd_id -- 基金代码编号
    ,ibank_no -- 联行号
    ,fund_cust_id -- 基金客户编号
    ,tran_acct_num -- 交易账号
    ,ta_cd -- TA代码
    ,prod_lot -- 产品份额
    ,uncfm_prod_amt -- 未确认产品金额
    ,uncfm_quick_redem_lot -- 未确认快速赎回份额
    ,tran_froz_lot -- 交易冻结份额
    ,froz_lot -- 冻结份额
    ,bank_froz_lot -- 银行冻结份额
    ,buy_cost -- 买入成本
    ,redem_amt -- 赎回金额
    ,unpay_turn_prft -- 未结转收益
    ,acm_prft -- 累计收益
    ,fir_subscr_dt -- 首次认购日期
    ,lot_type_cd -- 份额类型代码
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
    ,o.sell_mode_cd -- 销售模式代码
    ,o.fund_cd_id -- 基金代码编号
    ,o.ibank_no -- 联行号
    ,o.fund_cust_id -- 基金客户编号
    ,o.tran_acct_num -- 交易账号
    ,o.ta_cd -- TA代码
    ,o.prod_lot -- 产品份额
    ,o.uncfm_prod_amt -- 未确认产品金额
    ,o.uncfm_quick_redem_lot -- 未确认快速赎回份额
    ,o.tran_froz_lot -- 交易冻结份额
    ,o.froz_lot -- 冻结份额
    ,o.bank_froz_lot -- 银行冻结份额
    ,o.buy_cost -- 买入成本
    ,o.redem_amt -- 赎回金额
    ,o.unpay_turn_prft -- 未结转收益
    ,o.acm_prft -- 累计收益
    ,o.fir_subscr_dt -- 首次认购日期
    ,o.lot_type_cd -- 份额类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_bk o
    left join ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.sell_mode_cd = n.sell_mode_cd
            and o.fund_cd_id = n.fund_cd_id
            and o.ibank_no = n.ibank_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_qxb_bal_lot_h;
alter table ${iml_schema}.agt_qxb_bal_lot_h truncate partition for ('fsmsi1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_qxb_bal_lot_h exchange subpartition p_fsmsi1_19000101 with table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_cl;
alter table ${iml_schema}.agt_qxb_bal_lot_h exchange subpartition p_fsmsi1_20991231 with table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_qxb_bal_lot_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_tm purge;
drop table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_op purge;
drop table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_qxb_bal_lot_h_fsmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_qxb_bal_lot_h', partname => 'p_fsmsi1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
