/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ic_card_offline_tran_flow_ncbsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_ic_card_offline_tran_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_ic_card_offline_tran_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ic_card_offline_tran_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ic_card_offline_tran_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,offline_flow_num -- 脱机流水号
    ,offline_batch_no -- 脱机批次号
    ,acct_id -- 账户编号
    ,card_no -- 卡号
    ,card_ser_num -- 卡序列号
    ,app_idf -- 应用标识符
    ,offline_tran_type_cd -- 脱机交易类型代码
    ,tran_amt -- 交易金额
    ,plat_tran_dt -- 平台交易日期
    ,plat_tran_tm -- 平台交易时间
    ,unionpay_curr_cd -- 银联币种代码
    ,unionpay_clear_dt -- 银联清算日期
    ,mercht_id -- 商户编号
    ,mercht_type_cd -- 商户类型代码
    ,tran_status_cd -- 交易状态代码
    ,serv_status_descb -- 服务状态描述
    ,tran_addr_desc -- 交易地址描述
    ,elec_cash_acct_bal -- 电子现金账户余额
    ,other_amt -- 其他金额
    ,adj_entry_flg -- 调账标志
    ,entry_flg -- 记账标志
    ,enter_acct_dt -- 入账日期
    ,tran_termn_id -- 交易终端编号
    ,termn_flow_num -- 终端流水号
    ,termn_cty_cd -- 终端国家代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ic_card_offline_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_ic_off_tran_detail-1
insert into ${iml_schema}.evt_ic_card_offline_tran_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,offline_flow_num -- 脱机流水号
    ,offline_batch_no -- 脱机批次号
    ,acct_id -- 账户编号
    ,card_no -- 卡号
    ,card_ser_num -- 卡序列号
    ,app_idf -- 应用标识符
    ,offline_tran_type_cd -- 脱机交易类型代码
    ,tran_amt -- 交易金额
    ,plat_tran_dt -- 平台交易日期
    ,plat_tran_tm -- 平台交易时间
    ,unionpay_curr_cd -- 银联币种代码
    ,unionpay_clear_dt -- 银联清算日期
    ,mercht_id -- 商户编号
    ,mercht_type_cd -- 商户类型代码
    ,tran_status_cd -- 交易状态代码
    ,serv_status_descb -- 服务状态描述
    ,tran_addr_desc -- 交易地址描述
    ,elec_cash_acct_bal -- 电子现金账户余额
    ,other_amt -- 其他金额
    ,adj_entry_flg -- 调账标志
    ,entry_flg -- 记账标志
    ,enter_acct_dt -- 入账日期
    ,tran_termn_id -- 交易终端编号
    ,termn_flow_num -- 终端流水号
    ,termn_cty_cd -- 终端国家代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101017'||P1.OFF_TRAN_SEQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.OFF_TRAN_SEQ -- 脱机流水号
    ,P1.BATCH_NO -- 脱机批次号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CARD_NO -- 卡号
    ,P1.IC_CARD_SEQ -- 卡序列号
    ,P1.IC_AID -- 应用标识符
    ,P1.TRAN_TYPE -- 脱机交易类型代码
    ,P1.TRAN_AMT -- 交易金额
    ,P1.TRAN_DATE -- 平台交易日期
    ,P1.TIME_STAMP -- 平台交易时间
    ,P1.CUPS_CCY -- 银联币种代码
    ,P1.CUPS_DATE -- 银联清算日期
    ,P1.MERCH_NO -- 商户编号
    ,P1.MERCH_TYPE -- 商户类型代码
    ,P1.RET_CODE -- 交易状态代码
    ,P1.RET_MSG -- 服务状态描述
    ,P1.TRAN_ADDRESS -- 交易地址描述
    ,P1.IC_ACT_BAL -- 电子现金账户余额
    ,P1.OTHER_AMT -- 其他金额
    ,P1.FLAG -- 调账标志
    ,P1.ACCT_FLAG -- 记账标志
    ,P1.SETTLE_DATE -- 入账日期
    ,P1.TERM_NO -- 交易终端编号
    ,P1.TERM_SEQ -- 终端流水号
    ,P1.TERM_COUN_CODE -- 终端国家代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_ic_off_tran_detail' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_ic_off_tran_detail p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ic_card_offline_tran_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ic_card_offline_tran_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_ic_card_offline_tran_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ic_card_offline_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ic_card_offline_tran_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ic_card_offline_tran_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);