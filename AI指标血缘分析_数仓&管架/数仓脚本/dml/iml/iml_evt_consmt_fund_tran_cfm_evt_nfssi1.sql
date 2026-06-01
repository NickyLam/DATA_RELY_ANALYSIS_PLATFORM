/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_consmt_fund_tran_cfm_evt_nfssi1
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
drop table ${iml_schema}.evt_consmt_fund_tran_cfm_evt_nfssi1_tm purge;
alter table ${iml_schema}.evt_consmt_fund_tran_cfm_evt add partition p_nfssi1 values ('nfssi1')(
        subpartition p_nfssi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_consmt_fund_tran_cfm_evt modify partition p_nfssi1
    add subpartition p_nfssi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_consmt_fund_tran_cfm_evt_nfssi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,intior_cd -- 发起方代码
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,clear_dt -- 清算日期
    ,appl_flow_num -- 申请流水号
    ,tran_code -- 交易码
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,tran_chn_cd -- 交易渠道代码
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,ec_idf_cd -- 钞汇标识代码
    ,finc_prod_id -- 理财产品编号
    ,charge_way_cd -- 收费方式代码
    ,prod_nv -- 产品净值
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,cfm_amt -- 确认金额
    ,tran_lot -- 交易份额
    ,cfm_lot -- 确认份额
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,force_redem_rs_cd -- 强行赎回原因代码
    ,cotin_froz_amt -- 继续冻结金额
    ,lot_accu_accum -- 份额累积积数
    ,dtl_flg -- 明细标志
    ,froz_rs_cd -- 冻结原因代码
    ,tran_dir_cd -- 转换方向代码
    ,divd_way_cd -- 分红方式代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,tran_status_cd -- 交易状态代码
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,tran_post_lot -- 交易后份额
    ,cust_mgr_id -- 客户经理编号
    ,tran_teller_id -- 交易柜员编号
    ,comm_fee -- 手续费
    ,agent_fee -- 代理费
    ,bank_comm_fee -- 银行手续费
    ,target_prod_id -- 目标产品编号
    ,target_prod_nv -- 目标产品净值
    ,target_prod_price -- 目标产品价格
    ,target_prod_cfm_lot -- 目标产品确认份额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_consmt_fund_tran_cfm_evt
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- nfss_tbtranscfm-
insert into ${iml_schema}.evt_consmt_fund_tran_cfm_evt_nfssi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,intior_cd -- 发起方代码
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,clear_dt -- 清算日期
    ,appl_flow_num -- 申请流水号
    ,tran_code -- 交易码
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,tran_chn_cd -- 交易渠道代码
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,ec_idf_cd -- 钞汇标识代码
    ,finc_prod_id -- 理财产品编号
    ,charge_way_cd -- 收费方式代码
    ,prod_nv -- 产品净值
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,cfm_amt -- 确认金额
    ,tran_lot -- 交易份额
    ,cfm_lot -- 确认份额
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,force_redem_rs_cd -- 强行赎回原因代码
    ,cotin_froz_amt -- 继续冻结金额
    ,lot_accu_accum -- 份额累积积数
    ,dtl_flg -- 明细标志
    ,froz_rs_cd -- 冻结原因代码
    ,tran_dir_cd -- 转换方向代码
    ,divd_way_cd -- 分红方式代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,tran_status_cd -- 交易状态代码
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,tran_post_lot -- 交易后份额
    ,cust_mgr_id -- 客户经理编号
    ,tran_teller_id -- 交易柜员编号
    ,comm_fee -- 手续费
    ,agent_fee -- 代理费
    ,bank_comm_fee -- 银行手续费
    ,target_prod_id -- 目标产品编号
    ,target_prod_nv -- 目标产品净值
    ,target_prod_price -- 目标产品价格
    ,target_prod_cfm_lot -- 目标产品确认份额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104023'||P1.TA_CODE||P1.CFM_DATE||P1.CFM_NO -- 事件编号
    ,'9999' -- 法人编号
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,P1.CFM_NO -- TA确认流水号
    ,P1.ORI_CFM_NO -- 原确认流水号
    ,NVL(TRIM(P1.FROM_FLAG),'-') -- 发起方代码
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.TRANS_DATE)) -- 申请日期
    ,${iml_schema}.timeformat_min((TRANS_DATE||lpad(to_char(TRANS_TIME),6,'0'))) -- 申请时间
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.CLEAR_DATE)) -- 清算日期
    ,P1.SERIAL_NO -- 申请流水号
    ,P1.TRANS_CODE -- 交易码
    ,P1.BUSIN_CODE -- 业务代码
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPEN_BRANCH -- 交易所属机构编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.CHANNEL END -- 交易渠道代码
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,NVL(TRIM(P1.TRANS_ACCOUNT_TYPE),'-') -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,NVL(TRIM(P1.CASH_FLAG),'-') -- 钞汇标识代码
    ,P1.PRD_CODE -- 理财产品编号
    ,NVL(TRIM(P1.SHARE_CLASS),'-') -- 收费方式代码
    ,P1.NAV -- 产品净值
    ,P1.PRICE -- 交易价格
    ,P1.AMT -- 交易金额
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,P1.CFM_AMT -- 确认金额
    ,P1.VOL -- 交易份额
    ,P1.CFM_VOL -- 确认份额
    ,NVL(TRIM(P1.LARG_RED_FLAG),'-') -- 巨额赎回处理代码
    ,NVL(TRIM(P1.RED_CAUSE),'-'） -- 强行赎回原因代码
    ,P1.CONT_FROZEN_AMT -- 继续冻结金额
    ,P1.VOL_CUMULATE -- 份额累积积数
    ,P1.DETAIL_FLAG -- 明细标志
    ,P1.FROZEN_CAUSE -- 冻结原因代码
    ,NVL(TRIM(P1.CONV_DIR),'-') -- 转换方向代码
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,P1.ERR_CODE -- 返回码
    ,P1.ERR_MSG -- 返回信息
    ,NVL(TRIM(P1.STATUS),'-') -- 交易状态代码
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.ASSO_DATE)) -- 关联日期
    ,P1.ASSO_SERIAL -- 关联流水号
    ,P1.EX_SERIAL -- 发起方流水号
    ,P1.CONTRACT_NO -- 合约编号
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.HOST_DATE)) -- 主机日期
    ,P1.HOST_SERIAL -- 主机流水号
    ,P1.POST_VOL -- 交易后份额
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,P1.OPER_NO -- 交易柜员编号
    ,P1.CHARGE -- 手续费
    ,P1.AGENCY_FEE -- 代理费
    ,P1.BANK_CHARGE -- 银行手续费
    ,P1.TARG_PRD_CODE -- 目标产品编号
    ,P1.TARG_NAV -- 目标产品净值
    ,P1.TARG_PRICE -- 目标产品价格
    ,P1.TARG_CFM_VOL -- 目标产品确认份额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tbtranscfm' -- 源表名称
    ,'nfssi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tbtranscfm p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_TBTRANSCFM'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_TRAN_CFM_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CURR_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_TBTRANSCFM'
        AND R3.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_TRAN_CFM_EVT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CHANNEL = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'NFSS'
        AND R4.SRC_TAB_EN_NAME= 'NFSS_TBTRANSCFM'
        AND R4.SRC_FIELD_EN_NAME= 'CHANNEL'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_TRAN_CFM_EVT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.cfm_date = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_consmt_fund_tran_cfm_evt truncate subpartition p_nfssi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_consmt_fund_tran_cfm_evt exchange subpartition p_nfssi1_${batch_date} with table ${iml_schema}.evt_consmt_fund_tran_cfm_evt_nfssi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_consmt_fund_tran_cfm_evt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_consmt_fund_tran_cfm_evt_nfssi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_consmt_fund_tran_cfm_evt', partname => 'p_nfssi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);