/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_finc_tran_cfm_dtl_ifmsi1
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
drop table ${iml_schema}.evt_finc_tran_cfm_dtl_ifmsi1_tm purge;
alter table ${iml_schema}.evt_finc_tran_cfm_dtl add partition p_ifmsi1 values ('ifmsi1')(
        subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_finc_tran_cfm_dtl modify partition p_ifmsi1
    add subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_tran_cfm_dtl_ifmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dtl_cfm_flow_num -- 明细确认流水号
    ,ta_cfm_flow_num -- TA确认流水号
    ,seller_id -- 销售商编号
    ,bus_cd -- 业务代码
    ,cfm_dt -- 确认日期
    ,finc_acct_id -- 理财账户编号
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
    ,appl_flow_num -- 申请流水号
    ,init_lot_cfm_dt -- 原份额确认日期
    ,init_lot_cfm_flow_num -- 原份额确认流水号
    ,cfm_amt -- 确认金额
    ,cfm_lot -- 确认份额
    ,invest_prft -- 投资收益
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_finc_tran_cfm_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifms_tbtacfmdetail-
insert into ${iml_schema}.evt_finc_tran_cfm_dtl_ifmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dtl_cfm_flow_num -- 明细确认流水号
    ,ta_cfm_flow_num -- TA确认流水号
    ,seller_id -- 销售商编号
    ,bus_cd -- 业务代码
    ,cfm_dt -- 确认日期
    ,finc_acct_id -- 理财账户编号
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
    ,appl_flow_num -- 申请流水号
    ,init_lot_cfm_dt -- 原份额确认日期
    ,init_lot_cfm_flow_num -- 原份额确认流水号
    ,cfm_amt -- 确认金额
    ,cfm_lot -- 确认份额
    ,invest_prft -- 投资收益
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104020'||P1.CFM_NO||P1.SELLER_CODE||P1.SERIAL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.DETAIL_CFM_NO -- 明细确认流水号
    ,P1.CFM_NO -- TA确认流水号
    ,P1.SELLER_CODE -- 销售商编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.busin_code END -- 业务代码
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.PRD_CODE -- 产品编号
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.TRANS_DATE)) -- 申请日期
    ,P1.SERIAL_NO -- 申请流水号
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.ORI_CFM_DATE)) -- 原份额确认日期
    ,P1.ORI_CFM_NO -- 原份额确认流水号
    ,P1.CFM_AMT -- 确认金额
    ,P1.CFM_VOL -- 确认份额
    ,P1.GAIN_INCOME -- 投资收益
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbtacfmdetail' -- 源表名称
    ,'ifmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbtacfmdetail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.busin_code = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBTACFMDETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'BUSIN_CODE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_FINC_TRAN_CFM_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and to_char(to_date(p1.cfm_date,'yyyymmdd'),'yyyymmdd') = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_finc_tran_cfm_dtl truncate subpartition p_ifmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_finc_tran_cfm_dtl exchange subpartition p_ifmsi1_${batch_date} with table ${iml_schema}.evt_finc_tran_cfm_dtl_ifmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_finc_tran_cfm_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_finc_tran_cfm_dtl_ifmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_finc_tran_cfm_dtl', partname => 'p_ifmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);