/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_finc_tran_cfm_ifmsi1
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
drop table ${iml_schema}.evt_finc_tran_cfm_ifmsi1_tm purge;
alter table ${iml_schema}.evt_finc_tran_cfm add partition p_ifmsi1 values ('ifmsi1')(
        subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_finc_tran_cfm modify partition p_ifmsi1
    add subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_tran_cfm_ifmsi1_tm
compress ${option_switch} for query high
as
select
    ta_cd -- TA代码
    ,evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,intior_cd -- 发起方代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,clear_day_term -- 清算日期
    ,flow_num -- 流水号
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,tran_open_acct_org_id -- 交易账户开户机构编号
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,int_party_acct_id -- 内当事人户编号
    ,finc_acct_id -- 理财账户编号
    ,bank_cd -- 银行代码
    ,party_id -- 当事人编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,ec_flg -- 钞汇标志
    ,finc_prod_id -- 理财产品编号
    ,prod_nv -- 产品净值
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,cfm_amt -- 确认金额
    ,tran_lot -- 交易份额
    ,cfm_lot -- 确认份额
    ,huge_redem_proc_flg -- 巨额赎回处理标志
    ,force_redem_rs_cd -- 强行赎回原因代码
    ,cotin_froz_amt -- 继续冻结金额
    ,lot_accu_accum -- 份额累积积数
    ,dtl_flg -- 明细标志
    ,froz_rs_cd -- 冻结原因代码
    ,tran_dir_cd -- 转换方向代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,return_cd -- 返回代码
    ,remark_info -- 备注信息
    ,tran_status_cd -- 交易状态代码
    ,cust_mgr_id -- 客户经理编号
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,cont_id -- 合约编号
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,tran_post_lot -- 交易后份额
    ,rsrv_amt3 -- 预留金额3
    ,resv2 -- 备用2
    ,resv_region3 -- 保留域3
    ,cust_type_cd -- 客户类型代码
    ,target_bank_acct_id -- 目标银行账户编号
    ,tot_cost -- 总费用
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_finc_tran_cfm
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifms_tbtranscfm-
insert into ${iml_schema}.evt_finc_tran_cfm_ifmsi1_tm(
    ta_cd -- TA代码
    ,evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,intior_cd -- 发起方代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,clear_day_term -- 清算日期
    ,flow_num -- 流水号
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,tran_open_acct_org_id -- 交易账户开户机构编号
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,int_party_acct_id -- 内当事人户编号
    ,finc_acct_id -- 理财账户编号
    ,bank_cd -- 银行代码
    ,party_id -- 当事人编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,ec_flg -- 钞汇标志
    ,finc_prod_id -- 理财产品编号
    ,prod_nv -- 产品净值
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,cfm_amt -- 确认金额
    ,tran_lot -- 交易份额
    ,cfm_lot -- 确认份额
    ,huge_redem_proc_flg -- 巨额赎回处理标志
    ,force_redem_rs_cd -- 强行赎回原因代码
    ,cotin_froz_amt -- 继续冻结金额
    ,lot_accu_accum -- 份额累积积数
    ,dtl_flg -- 明细标志
    ,froz_rs_cd -- 冻结原因代码
    ,tran_dir_cd -- 转换方向代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,return_cd -- 返回代码
    ,remark_info -- 备注信息
    ,tran_status_cd -- 交易状态代码
    ,cust_mgr_id -- 客户经理编号
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,cont_id -- 合约编号
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,tran_post_lot -- 交易后份额
    ,rsrv_amt3 -- 预留金额3
    ,resv2 -- 备用2
    ,resv_region3 -- 保留域3
    ,cust_type_cd -- 客户类型代码
    ,target_bank_acct_id -- 目标银行账户编号
    ,tot_cost -- 总费用
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
     P1.TA_CODE -- TA代码
    ,'104004'||P1.TRANS_DATE||P1.CFM_NO||P1.TA_CODE -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,P1.CFM_NO -- TA确认流水号
    ,P1.ORI_CFM_NO -- 原确认流水号
    ,P1.FROM_FLAG -- 发起方代码
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.TRANS_DATE)) -- 交易日期
    ,TO_CHAR(P1.TRANS_TIME) -- 交易时间
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.CLEAR_DATE)) -- 清算日期
    ,P1.SERIAL_NO -- 流水号
    ,P1.TRANS_CODE -- 交易代码
    ,P1.BUSIN_CODE -- 业务代码
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPEN_BRANCH -- 交易账户开户机构编号
    ,nvl(trim(P1.CHANNEL),'-') -- 交易渠道代码
    ,P1.OPER_NO -- 交易柜员编号
    ,P1.IN_CLIENT_NO -- 内当事人户编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.BANK_NO -- 银行代码
    ,P1.CLIENT_NO -- 当事人编号
    ,NVL(P2.BANK_ACC, P1.BANK_ACC) -- 银行账户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.TRANS_ACCOUNT_TYPE -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,P1.CASH_FLAG -- 钞汇标志
    ,P1.PRD_CODE -- 理财产品编号
    ,P1.NAV -- 产品净值
    ,P1.PRICE -- 交易价格
    ,P1.AMT -- 交易金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,P1.CFM_AMT -- 确认金额
    ,P1.VOL -- 交易份额
    ,P1.CFM_VOL -- 确认份额
    ,P1.LARG_RED_FLAG -- 巨额赎回处理标志
    ,NVL(TRIM(P1.RED_CAUSE),'-') -- 强行赎回原因代码
    ,P1.CONT_FROZEN_AMT -- 继续冻结金额
    ,P1.VOL_CUMULATE -- 份额累积积数
    ,P1.DETAIL_FLAG -- 明细标志
    ,P1.FROZEN_CAUSE -- 冻结原因代码
    ,NVL(TRIM(P1.CONV_DIR),'-') -- 转换方向代码
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 默认分红方式代码
    ,P1.ERR_CODE -- 返回代码
    ,P1.ERR_MSG -- 备注信息
    ,NVL(TRIM(P1.STATUS),'-') -- 交易状态代码
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.ASSO_DATE)) -- 关联日期
    ,P1.ASSO_SERIAL -- 关联流水号
    ,P1.CONTRACT_NO -- 合约编号
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.HOST_DATE)) -- 主机日期
    ,P1.HOST_SERIAL -- 主机流水号
    ,P1.POST_VOL -- 交易后份额
    ,P1.AMT3 -- 预留金额3
    ,P1.RESERVE2 -- 备用2
    ,P1.RESERVE3 -- 保留域3
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.TARG_BANK_ACC -- 目标银行账户编号
    ,P1.TOT_FEE -- 总费用
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbtranscfm' -- 源表名称
    ,'ifmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ifms_tbtranscfm p1
  left join ${iol_schema}.ifms_tbvirbankaccmap p2
    on p1.bank_acc = p2.vir_bank_acc
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   left join ${iml_schema}.ref_pub_cd_map r1
    on p1.CURR_TYPE = r1.src_code_val
   and r1.sorc_sys_cd = 'IFMS'
   and r1.src_tab_en_name = 'IFMS_TBTRANSCFM'
   and r1.src_field_en_name = 'CURR_TYPE'
   and r1.target_tab_en_name = 'EVT_FINC_TRAN_CFM'
   and r1.target_tab_field_en_name = 'CURR_CD'
  left join ${iml_schema}.ref_pub_cd_map r2
    on p1.client_type = r2.src_code_val
   and r2.sorc_sys_cd = 'IFMS'
   and r2.src_tab_en_name = 'IFMS_TBTRANSCFM'
   and r2.src_field_en_name = 'CLIENT_TYPE'
   and r2.target_tab_en_name = 'EVT_FINC_TRAN_CFM'
   and r2.target_tab_field_en_name = 'CUST_TYPE_CD'
 where 1 = 1
   and p1.cfm_date = ${batch_date}
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_finc_tran_cfm truncate subpartition p_ifmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_finc_tran_cfm exchange subpartition p_ifmsi1_${batch_date} with table ${iml_schema}.evt_finc_tran_cfm_ifmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_finc_tran_cfm to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_finc_tran_cfm_ifmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_finc_tran_cfm', partname => 'p_ifmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);