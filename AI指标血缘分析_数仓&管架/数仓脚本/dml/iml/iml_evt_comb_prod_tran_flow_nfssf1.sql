/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_comb_prod_tran_flow_nfssf1
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
drop table ${iml_schema}.evt_comb_prod_tran_flow_nfssf1_tm purge;
alter table ${iml_schema}.evt_comb_prod_tran_flow add partition p_nfssf1 values ('nfssf1')(
        subpartition p_nfssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_comb_prod_tran_flow modify partition p_nfssf1
    add subpartition p_nfssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_comb_prod_tran_flow_nfssf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,cont_id -- 合约编号
    ,comb_prod_id -- 组合产品编号
    ,tran_cd -- 交易代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,sys_tran_dt -- 系统交易日期
    ,vtual_bank_acct_id -- 虚拟银行账户编号
    ,ctrl_flg_comb -- 控制标志组合
    ,cust_type_cd -- 客户类型代码
    ,intnal_cust_id -- 内部客户编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cap_acct_id -- 银行账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,tran_chn_cd -- 交易渠道代码
    ,init_tran_flow_num -- 原交易流水号
    ,init_tran_dt -- 原交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,init_tran_chn_cd -- 原交易渠道代码
    ,init_tran_org_id -- 原交易机构编号
    ,init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,send_finc_plat_flow_num -- 发送理财平台流水号
    ,finc_plat_check_entry_dt -- 理财平台对账日期
    ,finc_plat_flow_num -- 理财平台流水号
    ,finc_plat_tran_code -- 理财平台交易码
    ,finc_plat_dt -- 理财平台日期
    ,send_host_flow_num -- 发送主机流水号
    ,host_check_entry_dt -- 主机对账日期
    ,host_flow_num -- 主机流水号
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,fin_status_cd -- 财务状态代码
    ,target_bank_acct_id -- 目标银行账户编号
    ,sp_acct_id -- 认申购账户编号
    ,huge_redem_flg -- 巨额赎回标志
    ,redem_acct_id -- 赎回账户编号
    ,comb_redem_coll_acct_id -- 组合赎回归集账户编号
    ,cfm_amt -- 确认金额
    ,cfm_dt -- 确认日期
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,memo_comnt -- 摘要说明
    ,brch_org_id -- 分行机构编号
    ,open_acct_belong_org_id -- 所属机构编号
    ,cust_mgr_id -- 客户经理编号
    ,oper_teller_id -- 操作柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_comb_prod_tran_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- nfss_hstctrans1_v_tbhisgrptransreq-1
insert into ${iml_schema}.evt_comb_prod_tran_flow_nfssf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,cont_id -- 合约编号
    ,comb_prod_id -- 组合产品编号
    ,tran_cd -- 交易代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,sys_tran_dt -- 系统交易日期
    ,vtual_bank_acct_id -- 虚拟银行账户编号
    ,ctrl_flg_comb -- 控制标志组合
    ,cust_type_cd -- 客户类型代码
    ,intnal_cust_id -- 内部客户编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cap_acct_id -- 银行账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_acct_id -- 交易账户编号
    ,tran_chn_cd -- 交易渠道代码
    ,init_tran_flow_num -- 原交易流水号
    ,init_tran_dt -- 原交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,init_tran_chn_cd -- 原交易渠道代码
    ,init_tran_org_id -- 原交易机构编号
    ,init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,send_finc_plat_flow_num -- 发送理财平台流水号
    ,finc_plat_check_entry_dt -- 理财平台对账日期
    ,finc_plat_flow_num -- 理财平台流水号
    ,finc_plat_tran_code -- 理财平台交易码
    ,finc_plat_dt -- 理财平台日期
    ,send_host_flow_num -- 发送主机流水号
    ,host_check_entry_dt -- 主机对账日期
    ,host_flow_num -- 主机流水号
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,fin_status_cd -- 财务状态代码
    ,target_bank_acct_id -- 目标银行账户编号
    ,sp_acct_id -- 认申购账户编号
    ,huge_redem_flg -- 巨额赎回标志
    ,redem_acct_id -- 赎回账户编号
    ,comb_redem_coll_acct_id -- 组合赎回归集账户编号
    ,cfm_amt -- 确认金额
    ,cfm_dt -- 确认日期
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,memo_comnt -- 摘要说明
    ,brch_org_id -- 分行机构编号
    ,open_acct_belong_org_id -- 所属机构编号
    ,cust_mgr_id -- 客户经理编号
    ,oper_teller_id -- 操作柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401022'||P1.SERIAL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIAL_NO -- 流水号
    ,P1.CONTRACT_NO -- 合约编号
    ,P1.GROUP_CODE -- 组合产品编号
    ,NVL(TRIM(P1.TRANS_CODE),'-') -- 交易代码
    ,${iml_schema}.dateformat_max2(P1.TRANS_DATE) -- 交易日期
    ,${iml_schema}.timeformat_max(P1.TRANS_DATE||P1.TRANS_TIME) -- 交易时间
    ,${iml_schema}.dateformat_min(P1.OCCUR_INIT_DATE) -- 系统交易日期
    ,P1.VIRTUAL_BANK_ACC -- 虚拟银行账户编号
    ,nvl(trim(P1.CONTROL_FLAG),'-') -- 控制标志组合
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE end -- 客户类型代码
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.BANK_ACC -- 银行账户编号
    ,NVL(TRIM(P1.CASH_FLAG),'-') -- 钞汇标识代码
    ,NVL(TRIM(P1.TRANS_ACCOUNT_TYPE),'-') -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易账户编号
    ,NVL(TRIM(P1.CHANNEL),'-') -- 交易渠道代码
    ,P1.ASSO_SERIAL -- 原交易流水号
    ,${iml_schema}.dateformat_min(P1.ASSO_DATE) -- 原交易日期
    ,P1.AMT -- 交易金额
    ,NVL(TRIM(P1.STATUS),'-') -- 交易状态代码
    ,NVL(TRIM(P1.ORI_CHANNEL),'-') -- 原交易渠道代码
    ,P1.ORI_BRANCH_NO -- 原交易机构编号
    ,${iml_schema}.dateformat_min(P1.ORI_HOST_CHK_DATE) -- 原交易主机对账日期
    ,P1.TO_LCPT_SERIAL -- 发送理财平台流水号
    ,${iml_schema}.dateformat_min(P1.LCPT_CHECK_DATE) -- 理财平台对账日期
    ,P1.LCPT_SERIAL -- 理财平台流水号
    ,P1.LCPT_TRANS_CODE -- 理财平台交易码
    ,${iml_schema}.dateformat_min(P1.LCPT_DATE) -- 理财平台日期
    ,P1.TO_HOST_SERIAL -- 发送主机流水号
    ,${iml_schema}.dateformat_min(P1.HOST_CHECK_DATE) -- 主机对账日期
    ,P1.HOST_SERIAL -- 主机流水号
    ,P1.HOST_TRANS_CODE -- 主机交易码
    ,${iml_schema}.dateformat_min(P1.HOST_DATE) -- 主机日期
    ,NVL(TRIM(P1.LIQU_STATUS),'-') -- 财务状态代码
    ,P1.TARG_BANK_ACC -- 目标银行账户编号
    ,P1.DEBIT_ACCOUNT -- 认申购账户编号
    ,nvl(trim(P1.LARG_RED_FLAG),'-') -- 巨额赎回标志
    ,P1.CREBIT_ACCOUNT -- 赎回账户编号
    ,P1.REDEM_ACCOUNT -- 组合赎回归集账户编号
    ,P1.CFM_AMT -- 确认金额
    ,${iml_schema}.dateformat_max2(P1.CFM_DATE) -- 确认日期
    ,P1.ERR_CODE -- 错误码
    ,P1.ERR_MSG -- 错误信息描述
    ,P1.SUMMARY -- 摘要说明
    ,P1.BRANCH_NO -- 分行机构编号
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,P1.OPER_NO -- 操作柜员编号
    ,P1.AUTH_OPER -- 授权柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_hstctrans1_v_tbhisgrptransreq' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_hstctrans1_v_tbhisgrptransreq p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_HSTCTRANS1_V_TBHISGRPTRANSREQ'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_COMB_PROD_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where  1 = 1 
;
commit;




-- 3.2 truncate target table
alter table ${iml_schema}.evt_comb_prod_tran_flow truncate partition p_nfssf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_comb_prod_tran_flow exchange subpartition p_nfssf1_${batch_date} with table ${iml_schema}.evt_comb_prod_tran_flow_nfssf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_comb_prod_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_comb_prod_tran_flow_nfssf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_comb_prod_tran_flow', partname => 'p_nfssf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);