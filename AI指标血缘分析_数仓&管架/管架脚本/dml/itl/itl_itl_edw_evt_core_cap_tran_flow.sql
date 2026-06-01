/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_core_cap_tran_flow
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_evt_core_cap_tran_flow drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_core_cap_tran_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_core_cap_tran_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_core_cap_tran_flow partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,tran_dt  -- 交易日期
    ,tran_flow_num  -- 交易流水号
    ,tran_curr_cd  -- 交易币种代码
    ,tran_amt  -- 交易金额
    ,tran_acct_id  -- 交易账户编号
    ,tran_sub_acct_id  -- 交易子账户编号
    ,tran_acct_name  -- 交易账户户名
    ,tran_acct_open_bank_id  -- 交易账户开户行编号
    ,open_acct_vouch_kind_cd  -- 开户凭证种类代码
    ,open_acct_vouch_id  -- 开户凭证编号
    ,tran_vouch_kind_cd  -- 交易凭证种类代码
    ,tran_vouch_id  -- 交易凭证编号
    ,draw_dt  -- 出票日期
    ,cntpty_acct_id  -- 交易对手账户编号
    ,cntpty_sub_acct_id  -- 交易对手子账户编号
    ,cntpty_acct_name  -- 交易对手账户户名
    ,cntpty_acct_open_bank_id  -- 交易对手账户开户行编号
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,t1.tran_dt  -- 交易日期
    ,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'')  -- 交易流水号
    ,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'')  -- 交易币种代码
    ,t1.tran_amt  -- 交易金额
    ,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'')  -- 交易账户编号
    ,replace(replace(t1.tran_sub_acct_id,chr(13),''),chr(10),'')  -- 交易子账户编号
    ,replace(replace(t1.tran_acct_name,chr(13),''),chr(10),'')  -- 交易账户户名
    ,replace(replace(t1.tran_acct_open_bank_id,chr(13),''),chr(10),'')  -- 交易账户开户行编号
    ,replace(replace(t1.open_acct_vouch_kind_cd,chr(13),''),chr(10),'')  -- 开户凭证种类代码
    ,replace(replace(t1.open_acct_vouch_id,chr(13),''),chr(10),'')  -- 开户凭证编号
    ,replace(replace(t1.tran_vouch_kind_cd,chr(13),''),chr(10),'')  -- 交易凭证种类代码
    ,replace(replace(t1.tran_vouch_id,chr(13),''),chr(10),'')  -- 交易凭证编号
    ,t1.draw_dt  -- 出票日期
    ,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'')  -- 交易对手账户编号
    ,replace(replace(t1.cntpty_sub_acct_id,chr(13),''),chr(10),'')  -- 交易对手子账户编号
    ,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'')  -- 交易对手账户户名
    ,replace(replace(t1.cntpty_acct_open_bank_id,chr(13),''),chr(10),'')  -- 交易对手账户开户行编号
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iml.v_evt_core_cap_tran_flow t1    --核心资金交易流水
where 1=1 ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_core_cap_tran_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);