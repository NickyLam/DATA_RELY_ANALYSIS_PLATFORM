/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_addit_tran_flow_inssi1
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
drop table ${iml_schema}.evt_addit_tran_flow_inssi1_tm purge;
alter table ${iml_schema}.evt_addit_tran_flow add partition p_inssi1 values ('inssi1')(
        subpartition p_inssi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_addit_tran_flow modify partition p_inssi1
    add subpartition p_inssi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_addit_tran_flow_inssi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,addit_prod_id -- 附加险产品编号
    ,bank_id -- 银行编号
    ,ta_cd -- TA代码
    ,main_prod_id -- 主险产品编号
    ,insure_shares -- 投保份数
    ,insure_amt -- 投保金额
    ,insu_benef_lmt -- 保险金额
    ,insure_mode_pay_cd -- 保险支付方式代码
    ,pay_years -- 缴费年限
    ,guar_tenor_type_cd -- 保障期限类型代码
    ,guar_year_term -- 保障年期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_addit_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifms_tbinsureaddreq-1
insert into ${iml_schema}.evt_addit_tran_flow_inssi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,addit_prod_id -- 附加险产品编号
    ,bank_id -- 银行编号
    ,ta_cd -- TA代码
    ,main_prod_id -- 主险产品编号
    ,insure_shares -- 投保份数
    ,insure_amt -- 投保金额
    ,insu_benef_lmt -- 保险金额
    ,insure_mode_pay_cd -- 保险支付方式代码
    ,pay_years -- 缴费年限
    ,guar_tenor_type_cd -- 保障期限类型代码
    ,guar_year_term -- 保障年期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104049'||TO_CHAR(P1.TRANS_DATE)||P1.SERIAL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_min(to_char(P1.TRANS_DATE)) -- 交易日期
    ,P1.SERIAL_NO -- 交易流水号
    ,P1.PRD_ADD_CODE -- 附加险产品编号
    ,P1.BANK_NO -- 银行编号
    ,P1.TA_CODE -- TA代码
    ,P1.PRD_CODE -- 主险产品编号
    ,P1.INSURE_VOL -- 投保份数
    ,P1.INSURE_FEE -- 投保金额
    ,P1.AMT -- 保险金额
    ,NVL(TRIM(P1.PAY_TYPE),'-') -- 保险支付方式代码
    ,P1.PAY_YEAR -- 缴费年限
    ,NVL(TRIM(P1.INSURE_YEAR_TYPE),'-') -- 保障期限类型代码
    ,P1.INSURE_YEAR -- 保障年期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbinsureaddreq' -- 源表名称
    ,'inssi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbinsureaddreq p1
where  1 = 1 
    and P1.trans_date='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_addit_tran_flow truncate subpartition p_inssi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_addit_tran_flow exchange subpartition p_inssi1_${batch_date} with table ${iml_schema}.evt_addit_tran_flow_inssi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_addit_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_addit_tran_flow_inssi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_addit_tran_flow', partname => 'p_inssi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);