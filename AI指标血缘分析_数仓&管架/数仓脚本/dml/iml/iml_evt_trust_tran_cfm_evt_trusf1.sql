/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_trust_tran_cfm_evt_trusf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_trust_tran_cfm_evt add partition p_trusf1 values ('trusf1')(
        subpartition p_trusf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_trusf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_trust_tran_cfm_evt partition for ('trusf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_tm purge;
drop table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_op purge;
drop table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,intior_type_cd -- 发起方类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,clear_dt -- 清算日期
    ,flow_num -- 流水号
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_chn_cd -- 交易渠道编号
    ,termn_id -- 交易终端编号
    ,tran_teller_id -- 交易柜员编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,prod_nv -- 产品净值
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,stl_curr_cd -- 结算币种代码
    ,cfm_amt -- 确认金额
    ,tran_lot -- 交易份额
    ,cfm_lot -- 确认份额
    ,need_huge_redem_proc_flg -- 需要巨额赎回处理标志
    ,force_redem_rs -- 强行赎回原因
    ,comm_discnt -- 佣金折扣
    ,tot_cost -- 总费用
    ,comm_fee -- 手续费
    ,stamp_tax -- 印花税
    ,int_tax -- 利息税
    ,tran_fee -- 过户费
    ,agent_fee -- 代理费
    ,back_end_charge -- 后端收费
    ,other_fee_1 -- 其他费用1
    ,other_fee_2 -- 其他费用2
    ,cfm_prft -- 确认收益
    ,mgmt_fee -- 管理费
    ,cotin_froz_amt -- 继续冻结金额
    ,dtl_flg -- 明细标志
    ,end_type_cd -- 结束类型代码
    ,froz_rs_cd -- 冻结原因代码
    ,tran_dir_cd -- 转换方向代码
    ,int_amt -- 利息金额
    ,int_turn_lot -- 利息转份额
    ,divd_way_cd -- 分红方式代码
    ,memo_comnt -- 摘要说明
    ,return_code -- 返回码
    ,err_info -- 错误信息
    ,tran_status_cd -- 交易状态代码
    ,cust_mgr_id -- 客户经理编号
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,bank_comm_fee -- 银行手续费
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,host_tran_cd -- 主机交易代码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,tran_post_lot -- 交易后份额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_trust_tran_cfm_evt partition for ('trusf1')
where 0=1
;

create table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_trust_tran_cfm_evt partition for ('trusf1') where 0=1;

create table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_trust_tran_cfm_evt partition for ('trusf1') where 0=1;

-- 3.1 get new data into table
-- nfss_tcs_tbtranscfm-
insert into ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,intior_type_cd -- 发起方类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,clear_dt -- 清算日期
    ,flow_num -- 流水号
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_chn_cd -- 交易渠道编号
    ,termn_id -- 交易终端编号
    ,tran_teller_id -- 交易柜员编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,prod_nv -- 产品净值
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,stl_curr_cd -- 结算币种代码
    ,cfm_amt -- 确认金额
    ,tran_lot -- 交易份额
    ,cfm_lot -- 确认份额
    ,need_huge_redem_proc_flg -- 需要巨额赎回处理标志
    ,force_redem_rs -- 强行赎回原因
    ,comm_discnt -- 佣金折扣
    ,tot_cost -- 总费用
    ,comm_fee -- 手续费
    ,stamp_tax -- 印花税
    ,int_tax -- 利息税
    ,tran_fee -- 过户费
    ,agent_fee -- 代理费
    ,back_end_charge -- 后端收费
    ,other_fee_1 -- 其他费用1
    ,other_fee_2 -- 其他费用2
    ,cfm_prft -- 确认收益
    ,mgmt_fee -- 管理费
    ,cotin_froz_amt -- 继续冻结金额
    ,dtl_flg -- 明细标志
    ,end_type_cd -- 结束类型代码
    ,froz_rs_cd -- 冻结原因代码
    ,tran_dir_cd -- 转换方向代码
    ,int_amt -- 利息金额
    ,int_turn_lot -- 利息转份额
    ,divd_way_cd -- 分红方式代码
    ,memo_comnt -- 摘要说明
    ,return_code -- 返回码
    ,err_info -- 错误信息
    ,tran_status_cd -- 交易状态代码
    ,cust_mgr_id -- 客户经理编号
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,bank_comm_fee -- 银行手续费
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,host_tran_cd -- 主机交易代码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,tran_post_lot -- 交易后份额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102057'||P1.TA_CODE||P1.CFM_DATE||P1.CFM_NO -- 事件编号
    , '9999' -- 法人编号
    ,P1.TA_CODE -- TA代码
    ,${iml_schema}.dateformat_max(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,P1.CFM_NO -- TA确认流水号
    ,P1.ORI_CFM_NO -- 原确认流水号
    ,NVL(TRIM(P1.FROM_FLAG),'-') -- 发起方类型代码
    ,${iml_schema}.dateformat_max(to_char(P1.TRANS_DATE)) -- 交易日期
    ,lpad(to_char(P1.TRANS_TIME),6,'0') -- 交易时间
    ,${iml_schema}.dateformat_max(to_char(P1.CLEAR_DATE)) -- 清算日期
    ,P1.SERIAL_NO -- 流水号
    ,NVL(TRIM(P1.TRANS_CODE),'-') -- 交易代码
    ,NVL(TRIM(P1.BUSIN_CODE),'-') -- 业务代码
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPEN_BRANCH -- 开户机构编号
    ,nvl(trim(P1.CHANNEL),'-') -- 交易渠道编号
    ,P1.TERM_NO -- 交易终端编号
    ,P1.OPER_NO -- 交易柜员编号
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.CLIENT_NO -- 交易客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,NVL(TRIM(P1.TRANS_ACCOUNT_TYPE),'-') -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,NVL(TRIM(P1.CASH_FLAG),'-') -- 钞汇标识代码
    ,P1.PRD_CODE -- 产品编号
    ,NVL(TRIM(P1.SHARE_CLASS),'-') -- 收费方式代码
    ,P1.NAV -- 产品净值
    ,P1.PRICE -- 交易价格
    ,P1.AMT -- 交易金额
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 结算币种代码
    ,P1.CFM_AMT -- 确认金额
    ,P1.VOL -- 交易份额
    ,P1.CFM_VOL -- 确认份额
    ,NVL(TRIM(P1.LARG_RED_FLAG),'-') -- 需要巨额赎回处理标志
    ,NVL(TRIM(P1.RED_CAUSE),'-') -- 强行赎回原因
    ,P1.AGIO -- 佣金折扣
    ,P1.TOT_FEE -- 总费用
    ,P1.CHARGE -- 手续费
    ,P1.STAMP_TAX -- 印花税
    ,P1.INTEREST_TAX -- 利息税
    ,P1.TRANSFER_FEE -- 过户费
    ,P1.AGENCY_FEE -- 代理费
    ,P1.BACK_FEE -- 后端收费
    ,P1.OTHER_FEE1 -- 其他费用1
    ,P1.OTHER_FEE2 -- 其他费用2
    ,P1.CFM_INCOME -- 确认收益
    ,P1.MANAGE_FEE -- 管理费
    ,P1.CONT_FROZEN_AMT -- 继续冻结金额
    ,NVL(TRIM(P1.DETAIL_FLAG),'9') -- 明细标志
    ,NVL(TRIM(P1.FINISH_FLAG),'9') -- 结束类型代码
    ,NVL(TRIM(P1.FROZEN_CAUSE),'-') -- 冻结原因代码
    ,NVL(TRIM(P1.CONV_DIR),'-') -- 转换方向代码
    ,P1.INTEREST -- 利息金额
    ,P1.VOL_OF_INT -- 利息转份额
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,P1.SUMMARY -- 摘要说明
    ,P1.ERR_CODE -- 返回码
    ,P1.ERR_MSG -- 错误信息
    ,NVL(TRIM(P1.STATUS),'-') -- 交易状态代码
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,${iml_schema}.dateformat_max(TO_CHAR(P1.ASSO_DATE)) -- 关联日期
    ,P1.ASSO_SERIAL -- 关联流水号
    ,P1.BANK_CHARGE -- 银行手续费
    ,P1.EX_SERIAL -- 发起方流水号
    ,P1.CONTRACT_NO -- 合约编号
    ,NVL(TRIM(P1.HOST_TRANS_CODE),'-') -- 主机交易代码
    ,${iml_schema}.dateformat_max(TO_CHAR(P1.HOST_DATE)) -- 主机日期
    ,P1.HOST_SERIAL -- 主机流水号
    ,P1.POST_VOL -- 交易后份额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tcs_tbtranscfm' -- 源表名称
    ,'trusf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tcs_tbtranscfm p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CLIENT_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NFSS'
        AND R2.SRC_TAB_EN_NAME= 'NFSS_TCS_TBTRANSCFM'
        AND R2.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_TRUST_TRAN_CFM_EVT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CURR_TYPE= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_TCS_TBTRANSCFM'
        AND R3.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_TRUST_TRAN_CFM_EVT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'STL_CURR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,intior_type_cd -- 发起方类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,clear_dt -- 清算日期
    ,flow_num -- 流水号
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_chn_cd -- 交易渠道编号
    ,termn_id -- 交易终端编号
    ,tran_teller_id -- 交易柜员编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,prod_nv -- 产品净值
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,stl_curr_cd -- 结算币种代码
    ,cfm_amt -- 确认金额
    ,tran_lot -- 交易份额
    ,cfm_lot -- 确认份额
    ,need_huge_redem_proc_flg -- 需要巨额赎回处理标志
    ,force_redem_rs -- 强行赎回原因
    ,comm_discnt -- 佣金折扣
    ,tot_cost -- 总费用
    ,comm_fee -- 手续费
    ,stamp_tax -- 印花税
    ,int_tax -- 利息税
    ,tran_fee -- 过户费
    ,agent_fee -- 代理费
    ,back_end_charge -- 后端收费
    ,other_fee_1 -- 其他费用1
    ,other_fee_2 -- 其他费用2
    ,cfm_prft -- 确认收益
    ,mgmt_fee -- 管理费
    ,cotin_froz_amt -- 继续冻结金额
    ,dtl_flg -- 明细标志
    ,end_type_cd -- 结束类型代码
    ,froz_rs_cd -- 冻结原因代码
    ,tran_dir_cd -- 转换方向代码
    ,int_amt -- 利息金额
    ,int_turn_lot -- 利息转份额
    ,divd_way_cd -- 分红方式代码
    ,memo_comnt -- 摘要说明
    ,return_code -- 返回码
    ,err_info -- 错误信息
    ,tran_status_cd -- 交易状态代码
    ,cust_mgr_id -- 客户经理编号
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,bank_comm_fee -- 银行手续费
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,host_tran_cd -- 主机交易代码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,tran_post_lot -- 交易后份额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,intior_type_cd -- 发起方类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,clear_dt -- 清算日期
    ,flow_num -- 流水号
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_chn_cd -- 交易渠道编号
    ,termn_id -- 交易终端编号
    ,tran_teller_id -- 交易柜员编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,prod_nv -- 产品净值
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,stl_curr_cd -- 结算币种代码
    ,cfm_amt -- 确认金额
    ,tran_lot -- 交易份额
    ,cfm_lot -- 确认份额
    ,need_huge_redem_proc_flg -- 需要巨额赎回处理标志
    ,force_redem_rs -- 强行赎回原因
    ,comm_discnt -- 佣金折扣
    ,tot_cost -- 总费用
    ,comm_fee -- 手续费
    ,stamp_tax -- 印花税
    ,int_tax -- 利息税
    ,tran_fee -- 过户费
    ,agent_fee -- 代理费
    ,back_end_charge -- 后端收费
    ,other_fee_1 -- 其他费用1
    ,other_fee_2 -- 其他费用2
    ,cfm_prft -- 确认收益
    ,mgmt_fee -- 管理费
    ,cotin_froz_amt -- 继续冻结金额
    ,dtl_flg -- 明细标志
    ,end_type_cd -- 结束类型代码
    ,froz_rs_cd -- 冻结原因代码
    ,tran_dir_cd -- 转换方向代码
    ,int_amt -- 利息金额
    ,int_turn_lot -- 利息转份额
    ,divd_way_cd -- 分红方式代码
    ,memo_comnt -- 摘要说明
    ,return_code -- 返回码
    ,err_info -- 错误信息
    ,tran_status_cd -- 交易状态代码
    ,cust_mgr_id -- 客户经理编号
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,bank_comm_fee -- 银行手续费
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,host_tran_cd -- 主机交易代码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,tran_post_lot -- 交易后份额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.cfm_dt, o.cfm_dt) as cfm_dt -- 确认日期
    ,nvl(n.ta_cfm_flow_num, o.ta_cfm_flow_num) as ta_cfm_flow_num -- TA确认流水号
    ,nvl(n.init_cfm_flow_num, o.init_cfm_flow_num) as init_cfm_flow_num -- 原确认流水号
    ,nvl(n.intior_type_cd, o.intior_type_cd) as intior_type_cd -- 发起方类型代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.clear_dt, o.clear_dt) as clear_dt -- 清算日期
    ,nvl(n.flow_num, o.flow_num) as flow_num -- 流水号
    ,nvl(n.tran_cd, o.tran_cd) as tran_cd -- 交易代码
    ,nvl(n.bus_cd, o.bus_cd) as bus_cd -- 业务代码
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.tran_chn_cd, o.tran_chn_cd) as tran_chn_cd -- 交易渠道编号
    ,nvl(n.termn_id, o.termn_id) as termn_id -- 交易终端编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.finc_cust_id, o.finc_cust_id) as finc_cust_id -- 理财客户编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.finc_acct_id, o.finc_acct_id) as finc_acct_id -- 理财账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 交易客户编号
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.ta_tran_acct_id, o.ta_tran_acct_id) as ta_tran_acct_id -- TA交易账户编号
    ,nvl(n.tran_med_type_cd, o.tran_med_type_cd) as tran_med_type_cd -- 交易介质类型代码
    ,nvl(n.tran_med_id, o.tran_med_id) as tran_med_id -- 交易介质编号
    ,nvl(n.ec_idf_cd, o.ec_idf_cd) as ec_idf_cd -- 钞汇标识代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.charge_way_cd, o.charge_way_cd) as charge_way_cd -- 收费方式代码
    ,nvl(n.prod_nv, o.prod_nv) as prod_nv -- 产品净值
    ,nvl(n.tran_price, o.tran_price) as tran_price -- 交易价格
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.stl_curr_cd, o.stl_curr_cd) as stl_curr_cd -- 结算币种代码
    ,nvl(n.cfm_amt, o.cfm_amt) as cfm_amt -- 确认金额
    ,nvl(n.tran_lot, o.tran_lot) as tran_lot -- 交易份额
    ,nvl(n.cfm_lot, o.cfm_lot) as cfm_lot -- 确认份额
    ,nvl(n.need_huge_redem_proc_flg, o.need_huge_redem_proc_flg) as need_huge_redem_proc_flg -- 需要巨额赎回处理标志
    ,nvl(n.force_redem_rs, o.force_redem_rs) as force_redem_rs -- 强行赎回原因
    ,nvl(n.comm_discnt, o.comm_discnt) as comm_discnt -- 佣金折扣
    ,nvl(n.tot_cost, o.tot_cost) as tot_cost -- 总费用
    ,nvl(n.comm_fee, o.comm_fee) as comm_fee -- 手续费
    ,nvl(n.stamp_tax, o.stamp_tax) as stamp_tax -- 印花税
    ,nvl(n.int_tax, o.int_tax) as int_tax -- 利息税
    ,nvl(n.tran_fee, o.tran_fee) as tran_fee -- 过户费
    ,nvl(n.agent_fee, o.agent_fee) as agent_fee -- 代理费
    ,nvl(n.back_end_charge, o.back_end_charge) as back_end_charge -- 后端收费
    ,nvl(n.other_fee_1, o.other_fee_1) as other_fee_1 -- 其他费用1
    ,nvl(n.other_fee_2, o.other_fee_2) as other_fee_2 -- 其他费用2
    ,nvl(n.cfm_prft, o.cfm_prft) as cfm_prft -- 确认收益
    ,nvl(n.mgmt_fee, o.mgmt_fee) as mgmt_fee -- 管理费
    ,nvl(n.cotin_froz_amt, o.cotin_froz_amt) as cotin_froz_amt -- 继续冻结金额
    ,nvl(n.dtl_flg, o.dtl_flg) as dtl_flg -- 明细标志
    ,nvl(n.end_type_cd, o.end_type_cd) as end_type_cd -- 结束类型代码
    ,nvl(n.froz_rs_cd, o.froz_rs_cd) as froz_rs_cd -- 冻结原因代码
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 转换方向代码
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.int_turn_lot, o.int_turn_lot) as int_turn_lot -- 利息转份额
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.memo_comnt, o.memo_comnt) as memo_comnt -- 摘要说明
    ,nvl(n.return_code, o.return_code) as return_code -- 返回码
    ,nvl(n.err_info, o.err_info) as err_info -- 错误信息
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.rela_dt, o.rela_dt) as rela_dt -- 关联日期
    ,nvl(n.rela_flow_num, o.rela_flow_num) as rela_flow_num -- 关联流水号
    ,nvl(n.bank_comm_fee, o.bank_comm_fee) as bank_comm_fee -- 银行手续费
    ,nvl(n.intior_flow_num, o.intior_flow_num) as intior_flow_num -- 发起方流水号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合约编号
    ,nvl(n.host_tran_cd, o.host_tran_cd) as host_tran_cd -- 主机交易代码
    ,nvl(n.host_dt, o.host_dt) as host_dt -- 主机日期
    ,nvl(n.host_flow_num, o.host_flow_num) as host_flow_num -- 主机流水号
    ,nvl(n.tran_post_lot, o.tran_post_lot) as tran_post_lot -- 交易后份额
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_tm n
    full join (select * from ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.ta_cd <> n.ta_cd
        or o.cfm_dt <> n.cfm_dt
        or o.ta_cfm_flow_num <> n.ta_cfm_flow_num
        or o.init_cfm_flow_num <> n.init_cfm_flow_num
        or o.intior_type_cd <> n.intior_type_cd
        or o.tran_dt <> n.tran_dt
        or o.tran_tm <> n.tran_tm
        or o.clear_dt <> n.clear_dt
        or o.flow_num <> n.flow_num
        or o.tran_cd <> n.tran_cd
        or o.bus_cd <> n.bus_cd
        or o.tran_org_id <> n.tran_org_id
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.tran_chn_cd <> n.tran_chn_cd
        or o.termn_id <> n.termn_id
        or o.tran_teller_id <> n.tran_teller_id
        or o.finc_cust_id <> n.finc_cust_id
        or o.cust_type_cd <> n.cust_type_cd
        or o.finc_acct_id <> n.finc_acct_id
        or o.cust_id <> n.cust_id
        or o.bank_acct_id <> n.bank_acct_id
        or o.ta_tran_acct_id <> n.ta_tran_acct_id
        or o.tran_med_type_cd <> n.tran_med_type_cd
        or o.tran_med_id <> n.tran_med_id
        or o.ec_idf_cd <> n.ec_idf_cd
        or o.prod_id <> n.prod_id
        or o.charge_way_cd <> n.charge_way_cd
        or o.prod_nv <> n.prod_nv
        or o.tran_price <> n.tran_price
        or o.tran_amt <> n.tran_amt
        or o.stl_curr_cd <> n.stl_curr_cd
        or o.cfm_amt <> n.cfm_amt
        or o.tran_lot <> n.tran_lot
        or o.cfm_lot <> n.cfm_lot
        or o.need_huge_redem_proc_flg <> n.need_huge_redem_proc_flg
        or o.force_redem_rs <> n.force_redem_rs
        or o.comm_discnt <> n.comm_discnt
        or o.tot_cost <> n.tot_cost
        or o.comm_fee <> n.comm_fee
        or o.stamp_tax <> n.stamp_tax
        or o.int_tax <> n.int_tax
        or o.tran_fee <> n.tran_fee
        or o.agent_fee <> n.agent_fee
        or o.back_end_charge <> n.back_end_charge
        or o.other_fee_1 <> n.other_fee_1
        or o.other_fee_2 <> n.other_fee_2
        or o.cfm_prft <> n.cfm_prft
        or o.mgmt_fee <> n.mgmt_fee
        or o.cotin_froz_amt <> n.cotin_froz_amt
        or o.dtl_flg <> n.dtl_flg
        or o.end_type_cd <> n.end_type_cd
        or o.froz_rs_cd <> n.froz_rs_cd
        or o.tran_dir_cd <> n.tran_dir_cd
        or o.int_amt <> n.int_amt
        or o.int_turn_lot <> n.int_turn_lot
        or o.divd_way_cd <> n.divd_way_cd
        or o.memo_comnt <> n.memo_comnt
        or o.return_code <> n.return_code
        or o.err_info <> n.err_info
        or o.tran_status_cd <> n.tran_status_cd
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.rela_dt <> n.rela_dt
        or o.rela_flow_num <> n.rela_flow_num
        or o.bank_comm_fee <> n.bank_comm_fee
        or o.intior_flow_num <> n.intior_flow_num
        or o.cont_id <> n.cont_id
        or o.host_tran_cd <> n.host_tran_cd
        or o.host_dt <> n.host_dt
        or o.host_flow_num <> n.host_flow_num
        or o.tran_post_lot <> n.tran_post_lot
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,intior_type_cd -- 发起方类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,clear_dt -- 清算日期
    ,flow_num -- 流水号
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_chn_cd -- 交易渠道编号
    ,termn_id -- 交易终端编号
    ,tran_teller_id -- 交易柜员编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,prod_nv -- 产品净值
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,stl_curr_cd -- 结算币种代码
    ,cfm_amt -- 确认金额
    ,tran_lot -- 交易份额
    ,cfm_lot -- 确认份额
    ,need_huge_redem_proc_flg -- 需要巨额赎回处理标志
    ,force_redem_rs -- 强行赎回原因
    ,comm_discnt -- 佣金折扣
    ,tot_cost -- 总费用
    ,comm_fee -- 手续费
    ,stamp_tax -- 印花税
    ,int_tax -- 利息税
    ,tran_fee -- 过户费
    ,agent_fee -- 代理费
    ,back_end_charge -- 后端收费
    ,other_fee_1 -- 其他费用1
    ,other_fee_2 -- 其他费用2
    ,cfm_prft -- 确认收益
    ,mgmt_fee -- 管理费
    ,cotin_froz_amt -- 继续冻结金额
    ,dtl_flg -- 明细标志
    ,end_type_cd -- 结束类型代码
    ,froz_rs_cd -- 冻结原因代码
    ,tran_dir_cd -- 转换方向代码
    ,int_amt -- 利息金额
    ,int_turn_lot -- 利息转份额
    ,divd_way_cd -- 分红方式代码
    ,memo_comnt -- 摘要说明
    ,return_code -- 返回码
    ,err_info -- 错误信息
    ,tran_status_cd -- 交易状态代码
    ,cust_mgr_id -- 客户经理编号
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,bank_comm_fee -- 银行手续费
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,host_tran_cd -- 主机交易代码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,tran_post_lot -- 交易后份额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,intior_type_cd -- 发起方类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,clear_dt -- 清算日期
    ,flow_num -- 流水号
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_chn_cd -- 交易渠道编号
    ,termn_id -- 交易终端编号
    ,tran_teller_id -- 交易柜员编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,prod_nv -- 产品净值
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,stl_curr_cd -- 结算币种代码
    ,cfm_amt -- 确认金额
    ,tran_lot -- 交易份额
    ,cfm_lot -- 确认份额
    ,need_huge_redem_proc_flg -- 需要巨额赎回处理标志
    ,force_redem_rs -- 强行赎回原因
    ,comm_discnt -- 佣金折扣
    ,tot_cost -- 总费用
    ,comm_fee -- 手续费
    ,stamp_tax -- 印花税
    ,int_tax -- 利息税
    ,tran_fee -- 过户费
    ,agent_fee -- 代理费
    ,back_end_charge -- 后端收费
    ,other_fee_1 -- 其他费用1
    ,other_fee_2 -- 其他费用2
    ,cfm_prft -- 确认收益
    ,mgmt_fee -- 管理费
    ,cotin_froz_amt -- 继续冻结金额
    ,dtl_flg -- 明细标志
    ,end_type_cd -- 结束类型代码
    ,froz_rs_cd -- 冻结原因代码
    ,tran_dir_cd -- 转换方向代码
    ,int_amt -- 利息金额
    ,int_turn_lot -- 利息转份额
    ,divd_way_cd -- 分红方式代码
    ,memo_comnt -- 摘要说明
    ,return_code -- 返回码
    ,err_info -- 错误信息
    ,tran_status_cd -- 交易状态代码
    ,cust_mgr_id -- 客户经理编号
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,bank_comm_fee -- 银行手续费
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,host_tran_cd -- 主机交易代码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,tran_post_lot -- 交易后份额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.ta_cd -- TA代码
    ,o.cfm_dt -- 确认日期
    ,o.ta_cfm_flow_num -- TA确认流水号
    ,o.init_cfm_flow_num -- 原确认流水号
    ,o.intior_type_cd -- 发起方类型代码
    ,o.tran_dt -- 交易日期
    ,o.tran_tm -- 交易时间
    ,o.clear_dt -- 清算日期
    ,o.flow_num -- 流水号
    ,o.tran_cd -- 交易代码
    ,o.bus_cd -- 业务代码
    ,o.tran_org_id -- 交易机构编号
    ,o.open_acct_org_id -- 开户机构编号
    ,o.tran_chn_cd -- 交易渠道编号
    ,o.termn_id -- 交易终端编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.finc_cust_id -- 理财客户编号
    ,o.cust_type_cd -- 客户类型代码
    ,o.finc_acct_id -- 理财账户编号
    ,o.cust_id -- 交易客户编号
    ,o.bank_acct_id -- 银行账户编号
    ,o.ta_tran_acct_id -- TA交易账户编号
    ,o.tran_med_type_cd -- 交易介质类型代码
    ,o.tran_med_id -- 交易介质编号
    ,o.ec_idf_cd -- 钞汇标识代码
    ,o.prod_id -- 产品编号
    ,o.charge_way_cd -- 收费方式代码
    ,o.prod_nv -- 产品净值
    ,o.tran_price -- 交易价格
    ,o.tran_amt -- 交易金额
    ,o.stl_curr_cd -- 结算币种代码
    ,o.cfm_amt -- 确认金额
    ,o.tran_lot -- 交易份额
    ,o.cfm_lot -- 确认份额
    ,o.need_huge_redem_proc_flg -- 需要巨额赎回处理标志
    ,o.force_redem_rs -- 强行赎回原因
    ,o.comm_discnt -- 佣金折扣
    ,o.tot_cost -- 总费用
    ,o.comm_fee -- 手续费
    ,o.stamp_tax -- 印花税
    ,o.int_tax -- 利息税
    ,o.tran_fee -- 过户费
    ,o.agent_fee -- 代理费
    ,o.back_end_charge -- 后端收费
    ,o.other_fee_1 -- 其他费用1
    ,o.other_fee_2 -- 其他费用2
    ,o.cfm_prft -- 确认收益
    ,o.mgmt_fee -- 管理费
    ,o.cotin_froz_amt -- 继续冻结金额
    ,o.dtl_flg -- 明细标志
    ,o.end_type_cd -- 结束类型代码
    ,o.froz_rs_cd -- 冻结原因代码
    ,o.tran_dir_cd -- 转换方向代码
    ,o.int_amt -- 利息金额
    ,o.int_turn_lot -- 利息转份额
    ,o.divd_way_cd -- 分红方式代码
    ,o.memo_comnt -- 摘要说明
    ,o.return_code -- 返回码
    ,o.err_info -- 错误信息
    ,o.tran_status_cd -- 交易状态代码
    ,o.cust_mgr_id -- 客户经理编号
    ,o.rela_dt -- 关联日期
    ,o.rela_flow_num -- 关联流水号
    ,o.bank_comm_fee -- 银行手续费
    ,o.intior_flow_num -- 发起方流水号
    ,o.cont_id -- 合约编号
    ,o.host_tran_cd -- 主机交易代码
    ,o.host_dt -- 主机日期
    ,o.host_flow_num -- 主机流水号
    ,o.tran_post_lot -- 交易后份额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_bk o
    left join ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_trust_tran_cfm_evt;
--alter table ${iml_schema}.evt_trust_tran_cfm_evt truncate partition for ('trusf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_trust_tran_cfm_evt') 
               and substr(subpartition_name,1,8)=upper('p_trusf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_trust_tran_cfm_evt drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_trust_tran_cfm_evt modify partition p_trusf1 
add subpartition p_trusf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_trust_tran_cfm_evt exchange subpartition p_trusf1_${batch_date} with table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_cl;
alter table ${iml_schema}.evt_trust_tran_cfm_evt exchange subpartition p_trusf1_20991231 with table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_trust_tran_cfm_evt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_tm purge;
drop table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_op purge;
drop table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_trust_tran_cfm_evt_trusf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_trust_tran_cfm_evt', partname => 'p_trusf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
