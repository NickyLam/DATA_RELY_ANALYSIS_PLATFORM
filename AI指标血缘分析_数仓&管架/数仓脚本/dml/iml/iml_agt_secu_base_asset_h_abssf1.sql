/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_secu_base_asset_h_abssf1
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
alter table ${iml_schema}.agt_secu_base_asset_h add partition p_abssf1 values ('abssf1')(
        subpartition p_abssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_abssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_secu_base_asset_h_abssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_secu_base_asset_h partition for ('abssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_secu_base_asset_h_abssf1_tm purge;
drop table ${iml_schema}.agt_secu_base_asset_h_abssf1_op purge;
drop table ${iml_schema}.agt_secu_base_asset_h_abssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_secu_base_asset_h_abssf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,base_asset_id -- 基础资产编号
    ,asset_src_cd -- 资产来源代码
    ,dubil_id -- 借据编号
    ,loan_cont_id -- 合同编号
    ,src_cont_id -- 源合同编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,dubil_exp_dt -- 借据到期日期
    ,loan_tot_perds -- 贷款总期数
    ,surp_perds -- 剩余期数
    ,eh_issue_repay_day -- 每期还款日
    ,loan_amt -- 贷款金额
    ,bad_debt_amt -- 坏账金额
    ,ovdue_amt -- 逾期金额
    ,loan_bal -- 贷款余额
    ,idle_amt -- 呆滞金额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,max_expe_days -- 最大预期天数
    ,provi_int -- 计提利息
    ,rpbl_int -- 应还利息
    ,pric_pnlt -- 本金罚息
    ,int_pnlt -- 利息罚息
    ,curr_cd -- 币种代码
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,exec_int_rat -- 执行利率
    ,loan_status_cd -- 贷款状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,cust_id -- 客户编号
    ,src_cust_id -- 源客户编号
    ,asset_status_cd -- 资产状态代码
    ,pkg_dt -- 封包日期
    ,issue_dt -- 发行日期
    ,tran_cosdetn -- 转让对价
    ,ovdue_int_rat -- 逾期利率
    ,pkg_belong_hxb_int -- 封包时归属我行利息
    ,pkg_pric_bal -- 封包时本金余额
    ,pkg_asset_bal -- 封包时资产余额
    ,pkg_belong_hxb_int_rat -- 封包时归属我行利率
    ,redem_belong_hxb_int -- 赎回时归属我行利息
    ,redem_belong_trust_int -- 赎回时归属信托利息
    ,redem_cosdetn -- 赎回对价
    ,redem_belong_trust_pric -- 赎回时归属信托本金
    ,redem_cosdetn_pric -- 赎回对价本金
    ,redem_cosdetn_int -- 赎回对价利息
    ,bf_pkg_int_recvbl_bal -- 封包前应收利息余额
    ,after_pkg_int_recvbl_tot -- 封包后应收利息总额
    ,after_pkg_int_recvbl_bal -- 封包后应收利息余额
    ,after_rtn_pkg_int_recvbl -- 已归还封包后应收利息
    ,tran_loan_int_tot -- 转让贷款利息总额
    ,org_id -- 机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_secu_base_asset_h partition for ('abssf1')
where 0=1
;

create table ${iml_schema}.agt_secu_base_asset_h_abssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_secu_base_asset_h partition for ('abssf1') where 0=1;

create table ${iml_schema}.agt_secu_base_asset_h_abssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_secu_base_asset_h partition for ('abssf1') where 0=1;

-- 3.1 get new data into table
-- abss_abs_asset_info-1
insert into ${iml_schema}.agt_secu_base_asset_h_abssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,base_asset_id -- 基础资产编号
    ,asset_src_cd -- 资产来源代码
    ,dubil_id -- 借据编号
    ,loan_cont_id -- 合同编号
    ,src_cont_id -- 源合同编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,dubil_exp_dt -- 借据到期日期
    ,loan_tot_perds -- 贷款总期数
    ,surp_perds -- 剩余期数
    ,eh_issue_repay_day -- 每期还款日
    ,loan_amt -- 贷款金额
    ,bad_debt_amt -- 坏账金额
    ,ovdue_amt -- 逾期金额
    ,loan_bal -- 贷款余额
    ,idle_amt -- 呆滞金额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,max_expe_days -- 最大预期天数
    ,provi_int -- 计提利息
    ,rpbl_int -- 应还利息
    ,pric_pnlt -- 本金罚息
    ,int_pnlt -- 利息罚息
    ,curr_cd -- 币种代码
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,exec_int_rat -- 执行利率
    ,loan_status_cd -- 贷款状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,cust_id -- 客户编号
    ,src_cust_id -- 源客户编号
    ,asset_status_cd -- 资产状态代码
    ,pkg_dt -- 封包日期
    ,issue_dt -- 发行日期
    ,tran_cosdetn -- 转让对价
    ,ovdue_int_rat -- 逾期利率
    ,pkg_belong_hxb_int -- 封包时归属我行利息
    ,pkg_pric_bal -- 封包时本金余额
    ,pkg_asset_bal -- 封包时资产余额
    ,pkg_belong_hxb_int_rat -- 封包时归属我行利率
    ,redem_belong_hxb_int -- 赎回时归属我行利息
    ,redem_belong_trust_int -- 赎回时归属信托利息
    ,redem_cosdetn -- 赎回对价
    ,redem_belong_trust_pric -- 赎回时归属信托本金
    ,redem_cosdetn_pric -- 赎回对价本金
    ,redem_cosdetn_int -- 赎回对价利息
    ,bf_pkg_int_recvbl_bal -- 封包前应收利息余额
    ,after_pkg_int_recvbl_tot -- 封包后应收利息总额
    ,after_pkg_int_recvbl_bal -- 封包后应收利息余额
    ,after_rtn_pkg_int_recvbl -- 已归还封包后应收利息
    ,tran_loan_int_tot -- 转让贷款利息总额
    ,org_id -- 机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225109'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 基础资产编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ASSETCHANNEL END -- 资产来源代码
    ,P1.ASSETNO -- 借据编号
    ,NVL(substr(CONTRACTSERIALNO,3),' ') -- 合同编号
    ,P1.CONTRACTSERIALNO -- 源合同编号
    ,P1.ASSETTYPE -- 资产类型代码
    ,${iml_schema}.dateformat_min(P1.PUTOUTDATE) -- 放款日期
    ,${iml_schema}.dateformat_min(P1.MATURITYDATE) -- 借据到期日期
    ,P1.LOANTERM -- 贷款总期数
    ,P1.RESIDUALTERM -- 剩余期数
    ,P1.DEFAULTDATE -- 每期还款日
    ,P1.BUSINESSSUM -- 贷款金额
    ,P1.BADBALANCE -- 坏账金额
    ,P1.OVERDUEBALANCE -- 逾期金额
    ,P1.BALANCE -- 贷款余额
    ,P1.DULLBALANCE -- 呆滞金额
    ,${iml_schema}.dateformat_min(P1.OVERDUEDATE) -- 逾期日期
    ,P1.OVERDUEDAYS -- 贷款逾期天数
    ,P1.MAXOVERDUEDAYS -- 最大预期天数
    ,P1.RESERVEINTEREST -- 计提利息
    ,P1.PAYINTERESTAMT -- 应还利息
    ,P1.PAYPRINCIPALPENALTYAMT -- 本金罚息
    ,P1.PAYINTERESTPENALTYAMT -- 利息罚息
    ,NVL(TRIM(P1.CURRENCY),'CNY') -- 币种代码
    ,case when P1.CLASSIFYRESULT='60' or trim(P1.CLASSIFYRESULT) is null or P1.CLASSIFYRESULT = '90' then '99' else P1.CLASSIFYRESULT end -- 贷款五级分类代码
    ,P1.BUSINESSRATE*100 -- 执行利率
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.LOANSTATUS END -- 贷款状态代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.BENCHMARKRATETYPE END -- 基准利率类型代码
    ,P1.BENCHMARKRATE*100 -- 基准利率
    ,case when P1.RATEFLOATWAY='9' or trim(P1.RATEFLOATWAY) is null then '-' else P1.RATEFLOATWAY end -- 利率浮动方式代码
    ,P1.RATEFLOAT -- 浮动值
    ,NVL（substr(p1.CUSTOMERID,3),' ') -- 客户编号
    ,P1.CUSTOMERID -- 源客户编号
    ,P1.ASSETSTATUS -- 资产状态代码
    ,${iml_schema}.dateformat_min(P1.PACKETDATE) -- 封包日期
    ,${iml_schema}.dateformat_min(P1.PUBLISHDATE) -- 发行日期
    ,P1.PUBLISHAMT -- 转让对价
    ,P1.OVERDUERATE -- 逾期利率
    ,TO_NUMBER(nvl(regexp_substr(P1.LNOPIN,'[0-9.]+'),'0')) -- 封包时归属我行利息
    ,TO_NUMBER(nvl(regexp_substr(P1.LNCCST,'[0-9.]+'),'0')) -- 封包时本金余额
    ,P1.PACKETASSETBALANCE -- 封包时资产余额
    ,P1.LNOPINRATE -- 封包时归属我行利率
    ,P1.REDPIN -- 赎回时归属我行利息
    ,P1.REDCST -- 赎回时归属信托利息
    ,P1.FINISHAMT -- 赎回对价
    ,P1.REDXTPIN -- 赎回时归属信托本金
    ,P1.REDEEMPRINCIPLE -- 赎回对价本金
    ,P1.REDEEMINTEREST -- 赎回对价利息
    ,P1.PKG_BEF_RCVA_INT_VAL -- 封包前应收利息余额
    ,P1.PKG_AFTER_RCVA_INT_TOTAL_AMT -- 封包后应收利息总额
    ,P1.PKG_AFTER_RCVA_INT_BAL -- 封包后应收利息余额
    ,P1.HAS_RETN_PKG_AFTER_RCVA_INT -- 已归还封包后应收利息
    ,P1.TFR_LOAN_INT_TOTAL_AMT -- 转让贷款利息总额
    ,P1.OPERATEORGID -- 机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'abss_abs_asset_info' -- 源表名称
    ,'abssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.abss_abs_asset_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ASSETCHANNEL = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ABSS'
        AND R1.SRC_TAB_EN_NAME= 'ABSS_ABS_ASSET_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'ASSETCHANNEL'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_SECU_BASE_ASSET_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ASSET_SRC_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.LOANSTATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ABSS'
        AND R2.SRC_TAB_EN_NAME= 'ABSS_ABS_ASSET_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'LOANSTATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_SECU_BASE_ASSET_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LOAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.BENCHMARKRATETYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ABSS'
        AND R3.SRC_TAB_EN_NAME= 'ABSS_ABS_ASSET_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'BENCHMARKRATETYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_SECU_BASE_ASSET_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BASE_RAT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_secu_base_asset_h_abssf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_secu_base_asset_h_abssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,base_asset_id -- 基础资产编号
    ,asset_src_cd -- 资产来源代码
    ,dubil_id -- 借据编号
    ,loan_cont_id -- 合同编号
    ,src_cont_id -- 源合同编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,dubil_exp_dt -- 借据到期日期
    ,loan_tot_perds -- 贷款总期数
    ,surp_perds -- 剩余期数
    ,eh_issue_repay_day -- 每期还款日
    ,loan_amt -- 贷款金额
    ,bad_debt_amt -- 坏账金额
    ,ovdue_amt -- 逾期金额
    ,loan_bal -- 贷款余额
    ,idle_amt -- 呆滞金额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,max_expe_days -- 最大预期天数
    ,provi_int -- 计提利息
    ,rpbl_int -- 应还利息
    ,pric_pnlt -- 本金罚息
    ,int_pnlt -- 利息罚息
    ,curr_cd -- 币种代码
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,exec_int_rat -- 执行利率
    ,loan_status_cd -- 贷款状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,cust_id -- 客户编号
    ,src_cust_id -- 源客户编号
    ,asset_status_cd -- 资产状态代码
    ,pkg_dt -- 封包日期
    ,issue_dt -- 发行日期
    ,tran_cosdetn -- 转让对价
    ,ovdue_int_rat -- 逾期利率
    ,pkg_belong_hxb_int -- 封包时归属我行利息
    ,pkg_pric_bal -- 封包时本金余额
    ,pkg_asset_bal -- 封包时资产余额
    ,pkg_belong_hxb_int_rat -- 封包时归属我行利率
    ,redem_belong_hxb_int -- 赎回时归属我行利息
    ,redem_belong_trust_int -- 赎回时归属信托利息
    ,redem_cosdetn -- 赎回对价
    ,redem_belong_trust_pric -- 赎回时归属信托本金
    ,redem_cosdetn_pric -- 赎回对价本金
    ,redem_cosdetn_int -- 赎回对价利息
    ,bf_pkg_int_recvbl_bal -- 封包前应收利息余额
    ,after_pkg_int_recvbl_tot -- 封包后应收利息总额
    ,after_pkg_int_recvbl_bal -- 封包后应收利息余额
    ,after_rtn_pkg_int_recvbl -- 已归还封包后应收利息
    ,tran_loan_int_tot -- 转让贷款利息总额
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_secu_base_asset_h_abssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,base_asset_id -- 基础资产编号
    ,asset_src_cd -- 资产来源代码
    ,dubil_id -- 借据编号
    ,loan_cont_id -- 合同编号
    ,src_cont_id -- 源合同编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,dubil_exp_dt -- 借据到期日期
    ,loan_tot_perds -- 贷款总期数
    ,surp_perds -- 剩余期数
    ,eh_issue_repay_day -- 每期还款日
    ,loan_amt -- 贷款金额
    ,bad_debt_amt -- 坏账金额
    ,ovdue_amt -- 逾期金额
    ,loan_bal -- 贷款余额
    ,idle_amt -- 呆滞金额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,max_expe_days -- 最大预期天数
    ,provi_int -- 计提利息
    ,rpbl_int -- 应还利息
    ,pric_pnlt -- 本金罚息
    ,int_pnlt -- 利息罚息
    ,curr_cd -- 币种代码
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,exec_int_rat -- 执行利率
    ,loan_status_cd -- 贷款状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,cust_id -- 客户编号
    ,src_cust_id -- 源客户编号
    ,asset_status_cd -- 资产状态代码
    ,pkg_dt -- 封包日期
    ,issue_dt -- 发行日期
    ,tran_cosdetn -- 转让对价
    ,ovdue_int_rat -- 逾期利率
    ,pkg_belong_hxb_int -- 封包时归属我行利息
    ,pkg_pric_bal -- 封包时本金余额
    ,pkg_asset_bal -- 封包时资产余额
    ,pkg_belong_hxb_int_rat -- 封包时归属我行利率
    ,redem_belong_hxb_int -- 赎回时归属我行利息
    ,redem_belong_trust_int -- 赎回时归属信托利息
    ,redem_cosdetn -- 赎回对价
    ,redem_belong_trust_pric -- 赎回时归属信托本金
    ,redem_cosdetn_pric -- 赎回对价本金
    ,redem_cosdetn_int -- 赎回对价利息
    ,bf_pkg_int_recvbl_bal -- 封包前应收利息余额
    ,after_pkg_int_recvbl_tot -- 封包后应收利息总额
    ,after_pkg_int_recvbl_bal -- 封包后应收利息余额
    ,after_rtn_pkg_int_recvbl -- 已归还封包后应收利息
    ,tran_loan_int_tot -- 转让贷款利息总额
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.base_asset_id, o.base_asset_id) as base_asset_id -- 基础资产编号
    ,nvl(n.asset_src_cd, o.asset_src_cd) as asset_src_cd -- 资产来源代码
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.loan_cont_id, o.loan_cont_id) as loan_cont_id -- 合同编号
    ,nvl(n.src_cont_id, o.src_cont_id) as src_cont_id -- 源合同编号
    ,nvl(n.asset_type_cd, o.asset_type_cd) as asset_type_cd -- 资产类型代码
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 放款日期
    ,nvl(n.dubil_exp_dt, o.dubil_exp_dt) as dubil_exp_dt -- 借据到期日期
    ,nvl(n.loan_tot_perds, o.loan_tot_perds) as loan_tot_perds -- 贷款总期数
    ,nvl(n.surp_perds, o.surp_perds) as surp_perds -- 剩余期数
    ,nvl(n.eh_issue_repay_day, o.eh_issue_repay_day) as eh_issue_repay_day -- 每期还款日
    ,nvl(n.loan_amt, o.loan_amt) as loan_amt -- 贷款金额
    ,nvl(n.bad_debt_amt, o.bad_debt_amt) as bad_debt_amt -- 坏账金额
    ,nvl(n.ovdue_amt, o.ovdue_amt) as ovdue_amt -- 逾期金额
    ,nvl(n.loan_bal, o.loan_bal) as loan_bal -- 贷款余额
    ,nvl(n.idle_amt, o.idle_amt) as idle_amt -- 呆滞金额
    ,nvl(n.ovdue_dt, o.ovdue_dt) as ovdue_dt -- 逾期日期
    ,nvl(n.ovdue_days, o.ovdue_days) as ovdue_days -- 贷款逾期天数
    ,nvl(n.max_expe_days, o.max_expe_days) as max_expe_days -- 最大预期天数
    ,nvl(n.provi_int, o.provi_int) as provi_int -- 计提利息
    ,nvl(n.rpbl_int, o.rpbl_int) as rpbl_int -- 应还利息
    ,nvl(n.pric_pnlt, o.pric_pnlt) as pric_pnlt -- 本金罚息
    ,nvl(n.int_pnlt, o.int_pnlt) as int_pnlt -- 利息罚息
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.loan_level5_cls_cd, o.loan_level5_cls_cd) as loan_level5_cls_cd -- 贷款五级分类代码
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.loan_status_cd, o.loan_status_cd) as loan_status_cd -- 贷款状态代码
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.flo_val, o.flo_val) as flo_val -- 浮动值
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.src_cust_id, o.src_cust_id) as src_cust_id -- 源客户编号
    ,nvl(n.asset_status_cd, o.asset_status_cd) as asset_status_cd -- 资产状态代码
    ,nvl(n.pkg_dt, o.pkg_dt) as pkg_dt -- 封包日期
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 发行日期
    ,nvl(n.tran_cosdetn, o.tran_cosdetn) as tran_cosdetn -- 转让对价
    ,nvl(n.ovdue_int_rat, o.ovdue_int_rat) as ovdue_int_rat -- 逾期利率
    ,nvl(n.pkg_belong_hxb_int, o.pkg_belong_hxb_int) as pkg_belong_hxb_int -- 封包时归属我行利息
    ,nvl(n.pkg_pric_bal, o.pkg_pric_bal) as pkg_pric_bal -- 封包时本金余额
    ,nvl(n.pkg_asset_bal, o.pkg_asset_bal) as pkg_asset_bal -- 封包时资产余额
    ,nvl(n.pkg_belong_hxb_int_rat, o.pkg_belong_hxb_int_rat) as pkg_belong_hxb_int_rat -- 封包时归属我行利率
    ,nvl(n.redem_belong_hxb_int, o.redem_belong_hxb_int) as redem_belong_hxb_int -- 赎回时归属我行利息
    ,nvl(n.redem_belong_trust_int, o.redem_belong_trust_int) as redem_belong_trust_int -- 赎回时归属信托利息
    ,nvl(n.redem_cosdetn, o.redem_cosdetn) as redem_cosdetn -- 赎回对价
    ,nvl(n.redem_belong_trust_pric, o.redem_belong_trust_pric) as redem_belong_trust_pric -- 赎回时归属信托本金
    ,nvl(n.redem_cosdetn_pric, o.redem_cosdetn_pric) as redem_cosdetn_pric -- 赎回对价本金
    ,nvl(n.redem_cosdetn_int, o.redem_cosdetn_int) as redem_cosdetn_int -- 赎回对价利息
    ,nvl(n.bf_pkg_int_recvbl_bal, o.bf_pkg_int_recvbl_bal) as bf_pkg_int_recvbl_bal -- 封包前应收利息余额
    ,nvl(n.after_pkg_int_recvbl_tot, o.after_pkg_int_recvbl_tot) as after_pkg_int_recvbl_tot -- 封包后应收利息总额
    ,nvl(n.after_pkg_int_recvbl_bal, o.after_pkg_int_recvbl_bal) as after_pkg_int_recvbl_bal -- 封包后应收利息余额
    ,nvl(n.after_rtn_pkg_int_recvbl, o.after_rtn_pkg_int_recvbl) as after_rtn_pkg_int_recvbl -- 已归还封包后应收利息
    ,nvl(n.tran_loan_int_tot, o.tran_loan_int_tot) as tran_loan_int_tot -- 转让贷款利息总额
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_secu_base_asset_h_abssf1_tm n
    full join (select * from ${iml_schema}.agt_secu_base_asset_h_abssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.base_asset_id <> n.base_asset_id
        or o.asset_src_cd <> n.asset_src_cd
        or o.dubil_id <> n.dubil_id
        or o.loan_cont_id <> n.loan_cont_id
        or o.src_cont_id <> n.src_cont_id
        or o.asset_type_cd <> n.asset_type_cd
        or o.distr_dt <> n.distr_dt
        or o.dubil_exp_dt <> n.dubil_exp_dt
        or o.loan_tot_perds <> n.loan_tot_perds
        or o.surp_perds <> n.surp_perds
        or o.eh_issue_repay_day <> n.eh_issue_repay_day
        or o.loan_amt <> n.loan_amt
        or o.bad_debt_amt <> n.bad_debt_amt
        or o.ovdue_amt <> n.ovdue_amt
        or o.loan_bal <> n.loan_bal
        or o.idle_amt <> n.idle_amt
        or o.ovdue_dt <> n.ovdue_dt
        or o.ovdue_days <> n.ovdue_days
        or o.max_expe_days <> n.max_expe_days
        or o.provi_int <> n.provi_int
        or o.rpbl_int <> n.rpbl_int
        or o.pric_pnlt <> n.pric_pnlt
        or o.int_pnlt <> n.int_pnlt
        or o.curr_cd <> n.curr_cd
        or o.loan_level5_cls_cd <> n.loan_level5_cls_cd
        or o.exec_int_rat <> n.exec_int_rat
        or o.loan_status_cd <> n.loan_status_cd
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.base_rat <> n.base_rat
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.flo_val <> n.flo_val
        or o.cust_id <> n.cust_id
        or o.src_cust_id <> n.src_cust_id
        or o.asset_status_cd <> n.asset_status_cd
        or o.pkg_dt <> n.pkg_dt
        or o.issue_dt <> n.issue_dt
        or o.tran_cosdetn <> n.tran_cosdetn
        or o.ovdue_int_rat <> n.ovdue_int_rat
        or o.pkg_belong_hxb_int <> n.pkg_belong_hxb_int
        or o.pkg_pric_bal <> n.pkg_pric_bal
        or o.pkg_asset_bal <> n.pkg_asset_bal
        or o.pkg_belong_hxb_int_rat <> n.pkg_belong_hxb_int_rat
        or o.redem_belong_hxb_int <> n.redem_belong_hxb_int
        or o.redem_belong_trust_int <> n.redem_belong_trust_int
        or o.redem_cosdetn <> n.redem_cosdetn
        or o.redem_belong_trust_pric <> n.redem_belong_trust_pric
        or o.redem_cosdetn_pric <> n.redem_cosdetn_pric
        or o.redem_cosdetn_int <> n.redem_cosdetn_int
        or o.bf_pkg_int_recvbl_bal <> n.bf_pkg_int_recvbl_bal
        or o.after_pkg_int_recvbl_tot <> n.after_pkg_int_recvbl_tot
        or o.after_pkg_int_recvbl_bal <> n.after_pkg_int_recvbl_bal
        or o.after_rtn_pkg_int_recvbl <> n.after_rtn_pkg_int_recvbl
        or o.tran_loan_int_tot <> n.tran_loan_int_tot
        or o.org_id <> n.org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_secu_base_asset_h_abssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,base_asset_id -- 基础资产编号
    ,asset_src_cd -- 资产来源代码
    ,dubil_id -- 借据编号
    ,loan_cont_id -- 合同编号
    ,src_cont_id -- 源合同编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,dubil_exp_dt -- 借据到期日期
    ,loan_tot_perds -- 贷款总期数
    ,surp_perds -- 剩余期数
    ,eh_issue_repay_day -- 每期还款日
    ,loan_amt -- 贷款金额
    ,bad_debt_amt -- 坏账金额
    ,ovdue_amt -- 逾期金额
    ,loan_bal -- 贷款余额
    ,idle_amt -- 呆滞金额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,max_expe_days -- 最大预期天数
    ,provi_int -- 计提利息
    ,rpbl_int -- 应还利息
    ,pric_pnlt -- 本金罚息
    ,int_pnlt -- 利息罚息
    ,curr_cd -- 币种代码
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,exec_int_rat -- 执行利率
    ,loan_status_cd -- 贷款状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,cust_id -- 客户编号
    ,src_cust_id -- 源客户编号
    ,asset_status_cd -- 资产状态代码
    ,pkg_dt -- 封包日期
    ,issue_dt -- 发行日期
    ,tran_cosdetn -- 转让对价
    ,ovdue_int_rat -- 逾期利率
    ,pkg_belong_hxb_int -- 封包时归属我行利息
    ,pkg_pric_bal -- 封包时本金余额
    ,pkg_asset_bal -- 封包时资产余额
    ,pkg_belong_hxb_int_rat -- 封包时归属我行利率
    ,redem_belong_hxb_int -- 赎回时归属我行利息
    ,redem_belong_trust_int -- 赎回时归属信托利息
    ,redem_cosdetn -- 赎回对价
    ,redem_belong_trust_pric -- 赎回时归属信托本金
    ,redem_cosdetn_pric -- 赎回对价本金
    ,redem_cosdetn_int -- 赎回对价利息
    ,bf_pkg_int_recvbl_bal -- 封包前应收利息余额
    ,after_pkg_int_recvbl_tot -- 封包后应收利息总额
    ,after_pkg_int_recvbl_bal -- 封包后应收利息余额
    ,after_rtn_pkg_int_recvbl -- 已归还封包后应收利息
    ,tran_loan_int_tot -- 转让贷款利息总额
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_secu_base_asset_h_abssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,base_asset_id -- 基础资产编号
    ,asset_src_cd -- 资产来源代码
    ,dubil_id -- 借据编号
    ,loan_cont_id -- 合同编号
    ,src_cont_id -- 源合同编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,dubil_exp_dt -- 借据到期日期
    ,loan_tot_perds -- 贷款总期数
    ,surp_perds -- 剩余期数
    ,eh_issue_repay_day -- 每期还款日
    ,loan_amt -- 贷款金额
    ,bad_debt_amt -- 坏账金额
    ,ovdue_amt -- 逾期金额
    ,loan_bal -- 贷款余额
    ,idle_amt -- 呆滞金额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,max_expe_days -- 最大预期天数
    ,provi_int -- 计提利息
    ,rpbl_int -- 应还利息
    ,pric_pnlt -- 本金罚息
    ,int_pnlt -- 利息罚息
    ,curr_cd -- 币种代码
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,exec_int_rat -- 执行利率
    ,loan_status_cd -- 贷款状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,cust_id -- 客户编号
    ,src_cust_id -- 源客户编号
    ,asset_status_cd -- 资产状态代码
    ,pkg_dt -- 封包日期
    ,issue_dt -- 发行日期
    ,tran_cosdetn -- 转让对价
    ,ovdue_int_rat -- 逾期利率
    ,pkg_belong_hxb_int -- 封包时归属我行利息
    ,pkg_pric_bal -- 封包时本金余额
    ,pkg_asset_bal -- 封包时资产余额
    ,pkg_belong_hxb_int_rat -- 封包时归属我行利率
    ,redem_belong_hxb_int -- 赎回时归属我行利息
    ,redem_belong_trust_int -- 赎回时归属信托利息
    ,redem_cosdetn -- 赎回对价
    ,redem_belong_trust_pric -- 赎回时归属信托本金
    ,redem_cosdetn_pric -- 赎回对价本金
    ,redem_cosdetn_int -- 赎回对价利息
    ,bf_pkg_int_recvbl_bal -- 封包前应收利息余额
    ,after_pkg_int_recvbl_tot -- 封包后应收利息总额
    ,after_pkg_int_recvbl_bal -- 封包后应收利息余额
    ,after_rtn_pkg_int_recvbl -- 已归还封包后应收利息
    ,tran_loan_int_tot -- 转让贷款利息总额
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.base_asset_id -- 基础资产编号
    ,o.asset_src_cd -- 资产来源代码
    ,o.dubil_id -- 借据编号
    ,o.loan_cont_id -- 合同编号
    ,o.src_cont_id -- 源合同编号
    ,o.asset_type_cd -- 资产类型代码
    ,o.distr_dt -- 放款日期
    ,o.dubil_exp_dt -- 借据到期日期
    ,o.loan_tot_perds -- 贷款总期数
    ,o.surp_perds -- 剩余期数
    ,o.eh_issue_repay_day -- 每期还款日
    ,o.loan_amt -- 贷款金额
    ,o.bad_debt_amt -- 坏账金额
    ,o.ovdue_amt -- 逾期金额
    ,o.loan_bal -- 贷款余额
    ,o.idle_amt -- 呆滞金额
    ,o.ovdue_dt -- 逾期日期
    ,o.ovdue_days -- 贷款逾期天数
    ,o.max_expe_days -- 最大预期天数
    ,o.provi_int -- 计提利息
    ,o.rpbl_int -- 应还利息
    ,o.pric_pnlt -- 本金罚息
    ,o.int_pnlt -- 利息罚息
    ,o.curr_cd -- 币种代码
    ,o.loan_level5_cls_cd -- 贷款五级分类代码
    ,o.exec_int_rat -- 执行利率
    ,o.loan_status_cd -- 贷款状态代码
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.base_rat -- 基准利率
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.flo_val -- 浮动值
    ,o.cust_id -- 客户编号
    ,o.src_cust_id -- 源客户编号
    ,o.asset_status_cd -- 资产状态代码
    ,o.pkg_dt -- 封包日期
    ,o.issue_dt -- 发行日期
    ,o.tran_cosdetn -- 转让对价
    ,o.ovdue_int_rat -- 逾期利率
    ,o.pkg_belong_hxb_int -- 封包时归属我行利息
    ,o.pkg_pric_bal -- 封包时本金余额
    ,o.pkg_asset_bal -- 封包时资产余额
    ,o.pkg_belong_hxb_int_rat -- 封包时归属我行利率
    ,o.redem_belong_hxb_int -- 赎回时归属我行利息
    ,o.redem_belong_trust_int -- 赎回时归属信托利息
    ,o.redem_cosdetn -- 赎回对价
    ,o.redem_belong_trust_pric -- 赎回时归属信托本金
    ,o.redem_cosdetn_pric -- 赎回对价本金
    ,o.redem_cosdetn_int -- 赎回对价利息
    ,o.bf_pkg_int_recvbl_bal -- 封包前应收利息余额
    ,o.after_pkg_int_recvbl_tot -- 封包后应收利息总额
    ,o.after_pkg_int_recvbl_bal -- 封包后应收利息余额
    ,o.after_rtn_pkg_int_recvbl -- 已归还封包后应收利息
    ,o.tran_loan_int_tot -- 转让贷款利息总额
    ,o.org_id -- 机构编号
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
from ${iml_schema}.agt_secu_base_asset_h_abssf1_bk o
    left join ${iml_schema}.agt_secu_base_asset_h_abssf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_secu_base_asset_h_abssf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_secu_base_asset_h;
--alter table ${iml_schema}.agt_secu_base_asset_h truncate partition for ('abssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_secu_base_asset_h') 
               and substr(subpartition_name,1,8)=upper('p_abssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_secu_base_asset_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_secu_base_asset_h modify partition p_abssf1 
add subpartition p_abssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_secu_base_asset_h exchange subpartition p_abssf1_${batch_date} with table ${iml_schema}.agt_secu_base_asset_h_abssf1_cl;
alter table ${iml_schema}.agt_secu_base_asset_h exchange subpartition p_abssf1_20991231 with table ${iml_schema}.agt_secu_base_asset_h_abssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_secu_base_asset_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_secu_base_asset_h_abssf1_tm purge;
drop table ${iml_schema}.agt_secu_base_asset_h_abssf1_op purge;
drop table ${iml_schema}.agt_secu_base_asset_h_abssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_secu_base_asset_h_abssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_secu_base_asset_h', partname => 'p_abssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
