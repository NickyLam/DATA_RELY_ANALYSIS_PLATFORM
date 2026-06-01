/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_distr_finc_tran_cfm_dtl_ifdsi1
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
drop table ${iml_schema}.evt_distr_finc_tran_cfm_dtl_ifdsi1_tm purge;
alter table ${iml_schema}.evt_distr_finc_tran_cfm_dtl add partition p_ifdsi1 values ('ifdsi1')(
        subpartition p_ifdsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_distr_finc_tran_cfm_dtl modify partition p_ifdsi1
    add subpartition p_ifdsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_distr_finc_tran_cfm_dtl_ifdsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_cd -- 业务代码
    ,ta_cfm_flow_num -- TA确认流水号
    ,appl_flow_num -- 申请流水号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,brch_id -- 分行编号
    ,cfm_dt -- 确认日期
    ,appl_dt -- 申请日期
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,finc_prod_id -- 理财产品编号
    ,charge_way_cd -- 收费方式代码
    ,cfm_amt -- 确认金额
    ,cfm_lot -- 确认份额
    ,prod_nv -- 产品净值
    ,cfm_froz_amt -- 确认冻结金额
    ,cfm_unfrz_amt -- 确认解冻金额
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,invest_prft -- 投资收益
    ,unpaid_prft -- 未付收益
    ,bank_prft -- 银行收益
    ,appl_amt -- 申请金额
    ,appl_lot -- 申请份额
    ,tran_post_lot -- 交易后份额
    ,ta_init_flg -- TA发起标志
    ,proc_sucs_flg -- 处理成功标志
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_distr_finc_tran_cfm_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifms_fds_tbtatranscfm-
insert into ${iml_schema}.evt_distr_finc_tran_cfm_dtl_ifdsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_cd -- 业务代码
    ,ta_cfm_flow_num -- TA确认流水号
    ,appl_flow_num -- 申请流水号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,brch_id -- 分行编号
    ,cfm_dt -- 确认日期
    ,appl_dt -- 申请日期
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,finc_prod_id -- 理财产品编号
    ,charge_way_cd -- 收费方式代码
    ,cfm_amt -- 确认金额
    ,cfm_lot -- 确认份额
    ,prod_nv -- 产品净值
    ,cfm_froz_amt -- 确认冻结金额
    ,cfm_unfrz_amt -- 确认解冻金额
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,invest_prft -- 投资收益
    ,unpaid_prft -- 未付收益
    ,bank_prft -- 银行收益
    ,appl_amt -- 申请金额
    ,appl_lot -- 申请份额
    ,tran_post_lot -- 交易后份额
    ,ta_init_flg -- TA发起标志
    ,proc_sucs_flg -- 处理成功标志
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104024'||P1.CFM_NO||P1.SELLER_CODE||P1.SERIAL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BUSIN_CODE END -- 业务代码
    ,P1.CFM_NO -- TA确认流水号
    ,P1.SERIAL_NO -- 申请流水号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.BANK_NO -- 银行编号
    ,P1.BRANCH_NO -- 分行编号
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.TRANS_DATE)) -- 申请日期
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.PRD_CODE -- 源产品编号
    ,P1.REAL_PRD_CODE -- 理财产品编号
    ,NVL(TRIM(P1.SHARE_CLASS),'-') -- 收费方式代码
    ,P1.CFM_AMT -- 确认金额
    ,P1.CFM_VOL -- 确认份额
    ,P1.NAV -- 产品净值
    ,P1.FROZEN_AMT -- 确认冻结金额
    ,P1.UNFROZEN_AMT -- 确认解冻金额
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,P1.GAIN_INCOME -- 投资收益
    ,P1.CLIENT_INCOME -- 未付收益
    ,P1.BRANCH_INCOME -- 银行收益
    ,P1.AMT -- 申请金额
    ,P1.VOL -- 申请份额
    ,P1.LAST_VOL -- 交易后份额
    ,P1.TA_FLAG -- TA发起标志
    ,DECODE(P1.STATUS,'2','0',P1.STATUS) -- 处理成功标志
    ,P1.ERR_CODE -- 返回码
    ,P1.ERR_MSG -- 返回信息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_fds_tbtatranscfm' -- 源表名称
    ,'ifdsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_fds_tbtatranscfm p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUSIN_CODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_FDS_TBTATRANSCFM'
        AND R1.SRC_FIELD_EN_NAME= 'BUSIN_CODE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_DISTR_FINC_TRAN_CFM_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CLIENT_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_FDS_TBTATRANSCFM'
        AND R2.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_DISTR_FINC_TRAN_CFM_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and cfm_date='${batch_date}'
;
commit;




-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_distr_finc_tran_cfm_dtl truncate subpartition p_ifdsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_distr_finc_tran_cfm_dtl exchange subpartition p_ifdsi1_${batch_date} with table ${iml_schema}.evt_distr_finc_tran_cfm_dtl_ifdsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_distr_finc_tran_cfm_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_distr_finc_tran_cfm_dtl_ifdsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_distr_finc_tran_cfm_dtl', partname => 'p_ifdsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);