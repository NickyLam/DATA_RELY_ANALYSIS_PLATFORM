/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_qxb_prft_dtl_fsmsi1
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
drop table ${iml_schema}.agt_qxb_prft_dtl_fsmsi1_tm purge;
alter table ${iml_schema}.agt_qxb_prft_dtl add partition p_fsmsi1 values ('fsmsi1')(
        subpartition p_fsmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_qxb_prft_dtl modify partition p_fsmsi1
    add subpartition p_fsmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_qxb_prft_dtl_fsmsi1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,fund_cust_id -- 基金客户编号
    ,fund_cd -- 基金代码
    ,prft_dt -- 收益日期
    ,cust_prft -- 客户收益
    ,adv_lot -- 垫资份额
    ,adv_prft -- 垫资方收益
    ,ta_cd -- TA代码
    ,cust_id -- 客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_qxb_prft_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fsms_yeb_income_his-1
insert into ${iml_schema}.agt_qxb_prft_dtl_fsmsi1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,fund_cust_id -- 基金客户编号
    ,fund_cd -- 基金代码
    ,prft_dt -- 收益日期
    ,cust_prft -- 客户收益
    ,adv_lot -- 垫资份额
    ,adv_prft -- 垫资方收益
    ,ta_cd -- TA代码
    ,cust_id -- 客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '170000'||p1.TANO||p1.CUST_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.UNIONCODE -- 联行号
    ,P1.CUST_NO -- 基金客户编号
    ,P1.FUNDCODE -- 基金代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.INCOMEDATE) -- 收益日期
    ,P1.INCOME -- 客户收益
    ,P1.FUND_VOL -- 垫资份额
    ,P1.LOANINCOME_D -- 垫资方收益
    ,P1.TANO -- TA代码
    ,NVL(TRIM(P2.BANK_CUST_CODE),P1.CUST_NO) -- 客户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_yeb_income_his' -- 源表名称
    ,'fsmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_yeb_income_his p1
    left join ${iol_schema}.fsms_com_cust_info p2 on P1.CUST_NO=P2.CUST_NO
and p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.INSERTDATE='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_qxb_prft_dtl truncate subpartition p_fsmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_qxb_prft_dtl exchange subpartition p_fsmsi1_${batch_date} with table ${iml_schema}.agt_qxb_prft_dtl_fsmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_qxb_prft_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_qxb_prft_dtl_fsmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_qxb_prft_dtl', partname => 'p_fsmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);