/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_finc_tran_entr_ifmsi1
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
drop table ${iml_schema}.evt_finc_tran_entr_ifmsi1_tm purge;
alter table ${iml_schema}.evt_finc_tran_entr add partition p_ifmsi1 values ('ifmsi1')(
        subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_finc_tran_entr modify partition p_ifmsi1
    add subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_tran_entr_ifmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entr_flow_num -- 委托流水号
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_sys_dt -- 交易系统日期
    ,seller_cd -- 销售商代码
    ,tran_cd -- 交易代码
    ,tran_org_id -- 交易机构编号
    ,tran_open_acct_org_id -- 交易账户开户机构编号
    ,ta_cd -- TA代码
    ,finc_acct_num -- 理财账号
    ,intnal_party_id -- 内部当事人编号
    ,party_id -- 当事人编号
    ,bank_acct_id -- 银行账户编号
    ,ec_flg -- 钞汇标志
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,prod_cd -- 产品代码
    ,curr_cd -- 币种代码
    ,prod_cate_cd -- 产品类别代码
    ,prod_way_cd -- 产品方式代码
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,tran_amt -- 交易金额
    ,cust_grouping_cd -- 客户分组代码
    ,acct_status_cd -- 账务状态代码
    ,tran_lot -- 交易份额
    ,huge_redem_proc_flg -- 巨额赎回处理标志
    ,redem_mode_cd -- 赎回模式代码
    ,divd_way_cd -- 分红方式代码
    ,froz_rs_cd -- 冻结原因代码
    ,target_bank_acct_id -- 目标银行账户编号
    ,host_dt -- 主机日期
    ,host_flow_id -- 主机流水编号
    ,supv_flg -- 监管标志
    ,cust_mgr_id -- 客户经理编号
    ,err_descb -- 错误描述
    ,tran_status_cd -- 交易状态代码
    ,accpt_way_cd -- 受理方式代码
    ,memo_descb -- 摘要描述
    ,buy_acct_id -- 购买账户编号
    ,stdby_amt1 -- 备用金额1
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_finc_tran_entr
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifms_tbtransreq-
insert into ${iml_schema}.evt_finc_tran_entr_ifmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entr_flow_num -- 委托流水号
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_sys_dt -- 交易系统日期
    ,seller_cd -- 销售商代码
    ,tran_cd -- 交易代码
    ,tran_org_id -- 交易机构编号
    ,tran_open_acct_org_id -- 交易账户开户机构编号
    ,ta_cd -- TA代码
    ,finc_acct_num -- 理财账号
    ,intnal_party_id -- 内部当事人编号
    ,party_id -- 当事人编号
    ,bank_acct_id -- 银行账户编号
    ,ec_flg -- 钞汇标志
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,prod_cd -- 产品代码
    ,curr_cd -- 币种代码
    ,prod_cate_cd -- 产品类别代码
    ,prod_way_cd -- 产品方式代码
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,tran_amt -- 交易金额
    ,cust_grouping_cd -- 客户分组代码
    ,acct_status_cd -- 账务状态代码
    ,tran_lot -- 交易份额
    ,huge_redem_proc_flg -- 巨额赎回处理标志
    ,redem_mode_cd -- 赎回模式代码
    ,divd_way_cd -- 分红方式代码
    ,froz_rs_cd -- 冻结原因代码
    ,target_bank_acct_id -- 目标银行账户编号
    ,host_dt -- 主机日期
    ,host_flow_id -- 主机流水编号
    ,supv_flg -- 监管标志
    ,cust_mgr_id -- 客户经理编号
    ,err_descb -- 错误描述
    ,tran_status_cd -- 交易状态代码
    ,accpt_way_cd -- 受理方式代码
    ,memo_descb -- 摘要描述
    ,buy_acct_id -- 购买账户编号
    ,stdby_amt1 -- 备用金额1
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104014'||to_char(P1.TRANS_DATE)||P1.SERIAL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIAL_NO -- 委托流水号
    ,P1.EX_SERIAL -- 发起方流水号
    ,P1.CONTRACT_NO -- 合约编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANS_DATE) -- 交易日期
    ,P1.TRANS_TIME -- 交易时间
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.OCCUR_INIT_DATE)) -- 交易系统日期
    ,P1.SELLER_CODE -- 销售商代码
    ,P1.TRANS_CODE -- 交易代码
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPEN_BRANCH -- 交易账户开户机构编号
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.ASSET_ACC -- 理财账号
    ,P1.IN_CLIENT_NO -- 内部当事人编号
    ,P1.CLIENT_NO -- 当事人编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.CASH_FLAG -- 钞汇标志
    ,NVL(TRIM(P1.TRANS_ACCOUNT_TYPE),'-') -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,NVL(TRIM(P1.CHANNEL),'-') -- 交易渠道代码
    ,P1.OPER_NO -- 交易柜员编号
    ,P1.PRD_CODE -- 产品代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,NVL(TRIM(P1.PRD_TYPE),'-') -- 产品类别代码
    ,NVL(TRIM(P1.SHARE_CLASS),'-') -- 产品方式代码
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.ASSO_DATE)) -- 关联日期
    ,P1.ASSO_SERIAL -- 关联流水号
    ,P1.AMT -- 交易金额
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CLIENT_GROUP END -- 客户分组代码
    ,NVL(TRIM(P1.LIQU_STATUS),'-') -- 账务状态代码
    ,P1.VOL -- 交易份额
    ,P1.LARG_RED_FLAG -- 巨额赎回处理标志
    ,NVL(TRIM(P1.RED_MODE),'2') -- 赎回模式代码
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,P1.FROZEN_CAUSE -- 冻结原因代码
    ,P1.TARG_BANK_ACC -- 目标银行账户编号
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.HOST_DATE)) -- 主机日期
    ,P1.HOST_SERIAL -- 主机流水编号
    ,P1.MONITOR_FLAG -- 监管标志
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,P1.ERR_MSG -- 错误描述
    ,P1.STATUS -- 交易状态代码
    ,NVL(TRIM(P1.DEAL_MODE),'-') -- 受理方式代码
    ,P1.SUMMARY -- 摘要描述
    ,P1.DEBIT_ACCOUNT -- 购买账户编号
    ,P1.AMT1 -- 备用金额1
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbtransreq' -- 源表名称
    ,'ifmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbtransreq p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CURR_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBTRANSREQ'
        AND R1.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_FINC_TRAN_ENTR'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CLIENT_GROUP = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_TBTRANSREQ'
        AND R2.SRC_FIELD_EN_NAME= 'CLIENT_GROUP'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_FINC_TRAN_ENTR'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
where  1 = 1 
    AND P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_finc_tran_entr truncate subpartition p_ifmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_finc_tran_entr exchange subpartition p_ifmsi1_${batch_date} with table ${iml_schema}.evt_finc_tran_entr_ifmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_finc_tran_entr to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_finc_tran_entr_ifmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_finc_tran_entr', partname => 'p_ifmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);