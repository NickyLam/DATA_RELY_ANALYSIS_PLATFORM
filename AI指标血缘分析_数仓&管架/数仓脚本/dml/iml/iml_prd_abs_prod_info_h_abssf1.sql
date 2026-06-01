/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_abs_prod_info_h_abssf1
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
alter table ${iml_schema}.prd_abs_prod_info_h add partition p_abssf1 values ('abssf1')(
        subpartition p_abssf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_abssf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_abs_prod_info_h_abssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_abs_prod_info_h partition for ('abssf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_abs_prod_info_h_abssf1_tm purge;
drop table ${iml_schema}.prd_abs_prod_info_h_abssf1_op purge;
drop table ${iml_schema}.prd_abs_prod_info_h_abssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_abs_prod_info_h_abssf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,prod_name -- 产品名称
    ,prod_type_cd -- 产品类型代码
    ,prod_status_cd -- 产品状态代码
    ,prod_bus_status_cd -- 产品业务状态代码
    ,prod_mode_cd -- 产品模式代码
    ,pre_issue_tot -- 预发行总额
    ,asset_tot -- 资产总额
    ,cfm_issue_tot -- 确认发行总额
    ,curr_cd -- 币种代码
    ,supt_clearup_repo_flg -- 支持清仓回购标志
    ,asset_pool_id -- 资产池编号
    ,trust_effect_dt -- 信托生效日期
    ,trust_exp_dt -- 信托到期日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,issue_dt -- 发行日期
    ,trust_propty_dlvy_dt -- 信托财产交付日期
    ,turn_pay_drift_days -- 转付偏移天数
    ,ts_flg -- 暂存标志
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,setment_way_cd -- 交收方式代码
    ,deflt_rat -- 违约率
    ,repay_rat -- 早偿率
    ,ovdue_rat -- 逾期率
    ,ten_asset_deflt_rat -- 前十大资产违约率
    ,cashflow_meas_flg -- 现金流测算标志
    ,asset_tran_cosdetn -- 资产转让对价
    ,tran_cosdetn_calc_way_cd -- 转让对价计算方式代码
    ,tran_contr_id -- 转让合同编号
    ,tran_comm_fee -- 转让手续费
    ,repo_int_rat -- 回购利率
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,def_coll_ped_flg -- 自定义归集周期标志
    ,tran_plat_cd -- 交易平台代码
    ,tran_org_type_cd -- 交易机构类型代码
    ,update_fee_plan_flg -- 更新费用计划标志
    ,cntpty_tran_dt -- 交易对手转账日期
    ,cntpty_pay_amt -- 交易对手已支付金额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_abs_prod_info_h partition for ('abssf1')
where 0=1
;

create table ${iml_schema}.prd_abs_prod_info_h_abssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_abs_prod_info_h partition for ('abssf1') where 0=1;

create table ${iml_schema}.prd_abs_prod_info_h_abssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_abs_prod_info_h partition for ('abssf1') where 0=1;

-- 3.1 get new data into table
-- abss_abs_product_info-
insert into ${iml_schema}.prd_abs_prod_info_h_abssf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,prod_name -- 产品名称
    ,prod_type_cd -- 产品类型代码
    ,prod_status_cd -- 产品状态代码
    ,prod_bus_status_cd -- 产品业务状态代码
    ,prod_mode_cd -- 产品模式代码
    ,pre_issue_tot -- 预发行总额
    ,asset_tot -- 资产总额
    ,cfm_issue_tot -- 确认发行总额
    ,curr_cd -- 币种代码
    ,supt_clearup_repo_flg -- 支持清仓回购标志
    ,asset_pool_id -- 资产池编号
    ,trust_effect_dt -- 信托生效日期
    ,trust_exp_dt -- 信托到期日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,issue_dt -- 发行日期
    ,trust_propty_dlvy_dt -- 信托财产交付日期
    ,turn_pay_drift_days -- 转付偏移天数
    ,ts_flg -- 暂存标志
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,setment_way_cd -- 交收方式代码
    ,deflt_rat -- 违约率
    ,repay_rat -- 早偿率
    ,ovdue_rat -- 逾期率
    ,ten_asset_deflt_rat -- 前十大资产违约率
    ,cashflow_meas_flg -- 现金流测算标志
    ,asset_tran_cosdetn -- 资产转让对价
    ,tran_cosdetn_calc_way_cd -- 转让对价计算方式代码
    ,tran_contr_id -- 转让合同编号
    ,tran_comm_fee -- 转让手续费
    ,repo_int_rat -- 回购利率
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,def_coll_ped_flg -- 自定义归集周期标志
    ,tran_plat_cd -- 交易平台代码
    ,tran_org_type_cd -- 交易机构类型代码
    ,update_fee_plan_flg -- 更新费用计划标志
    ,cntpty_tran_dt -- 交易对手转账日期
    ,cntpty_pay_amt -- 交易对手已支付金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223005'||P1.PRODUCTID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.PRODUCTID -- ABS产品编号
    ,P1.PRODUCTNAME -- 产品名称
    ,nvl(trim(P1.PRODUCTTYPE),'00') -- 产品类型代码
    ,nvl(trim(P1.PRODUCTSTATUS),'00') -- 产品状态代码
    ,nvl(trim(P1.BUSINESSSTATUS),'00') -- 产品业务状态代码
    ,nvl(trim(P1.PRODUCTMODEL),'00') -- 产品模式代码
    ,P1.PREAMT -- 预发行总额
    ,P1.ASSETAMT -- 资产总额
    ,P1.CONFIRMAMT -- 确认发行总额
    ,P1.CURRENCY -- 币种代码
    ,DECODE(P1.REPURCHASEFLAG,' ','-','2','0',P1.REPURCHASEFLAG) -- 支持清仓回购标志
    ,P1.ASSETPOOLNO -- 资产池编号
    ,${iml_schema}.dateformat_min(P1.TRUSTDATE) -- 信托生效日期
    ,${iml_schema}.dateformat_max(P1.MATURITY) -- 信托到期日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CREDITMEASURE END -- 增信方式代码
    ,${iml_schema}.dateformat_min(P1.BOOKBUILDINGDATE) -- 发行日期
    ,${iml_schema}.dateformat_min(P1.DELIVERYDATE) -- 信托财产交付日期
    ,P1.PAYGRACEDAYS -- 转付偏移天数
    ,P1.TEMPSAVEFLAG -- 暂存标志
    ,P1.INPUTUSERID -- 登记人编号
    ,P1.INPUTORGID -- 登记机构编号
    ,${iml_schema}.dateformat_min(P1.INPUTTIME) -- 登记时间
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PAYDATERULE END -- 交收方式代码
    ,P1.LOSSRATE -- 违约率
    ,P1.PREPAYRATE -- 早偿率
    ,P1.OVERDUERATE -- 逾期率
    ,P1.PRETENLOSSRATE -- 前十大资产违约率
    ,P1.CASHFLOWFLAG -- 现金流测算标志
    ,P1.ASSETTRANSFERAMT -- 资产转让对价
    ,nvl(trim(P1.ASSETTRANSFERAMTTYPE),'00') -- 转让对价计算方式代码
    ,P1.ZRHTH -- 转让合同编号
    ,P1.ZRSXF -- 转让手续费
    ,P1.HGLL*100 -- 回购利率
    ,${iml_schema}.dateformat_min(P1.ZRHTQSRQ) -- 转让合同起始日期
    ,${iml_schema}.dateformat_max(P1.ZRHTDQRQ) -- 转让合同到期日期
    ,P1.ISDIYCYCLE -- 自定义归集周期标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.PLATFORM END -- 交易平台代码
    ,nvl(trim(P1.TRANSACTIONORGTYPE),'0') -- 交易机构类型代码
    ,DECODE(upper(P1.UPDATEFEEPLAN),' ','-','TRUE','1','0') -- 更新费用计划标志
    ,${iml_schema}.dateformat_min(P1.TRANSFERDATE) -- 交易对手转账日期
    ,P1.PAIDAMT -- 交易对手已支付金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'abss_abs_product_info' -- 源表名称
    ,'abssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.abss_abs_product_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CREDITMEASURE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ABSS'
        AND R1.SRC_TAB_EN_NAME= 'ABSS_ABS_PRODUCT_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'CREDITMEASURE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_ABS_PROD_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INCRE_CRDT_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PAYDATERULE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ABSS'
        AND R2.SRC_TAB_EN_NAME= 'ABSS_ABS_PRODUCT_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'PAYDATERULE'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_ABS_PROD_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'SETMENT_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.PLATFORM = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ABSS'
        AND R3.SRC_TAB_EN_NAME= 'ABSS_ABS_PRODUCT_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'PLATFORM'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_ABS_PROD_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_PLAT_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_abs_prod_info_h_abssf1_tm 
  	                                group by 
  	                                        prod_id
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
        into ${iml_schema}.prd_abs_prod_info_h_abssf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,prod_name -- 产品名称
    ,prod_type_cd -- 产品类型代码
    ,prod_status_cd -- 产品状态代码
    ,prod_bus_status_cd -- 产品业务状态代码
    ,prod_mode_cd -- 产品模式代码
    ,pre_issue_tot -- 预发行总额
    ,asset_tot -- 资产总额
    ,cfm_issue_tot -- 确认发行总额
    ,curr_cd -- 币种代码
    ,supt_clearup_repo_flg -- 支持清仓回购标志
    ,asset_pool_id -- 资产池编号
    ,trust_effect_dt -- 信托生效日期
    ,trust_exp_dt -- 信托到期日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,issue_dt -- 发行日期
    ,trust_propty_dlvy_dt -- 信托财产交付日期
    ,turn_pay_drift_days -- 转付偏移天数
    ,ts_flg -- 暂存标志
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,setment_way_cd -- 交收方式代码
    ,deflt_rat -- 违约率
    ,repay_rat -- 早偿率
    ,ovdue_rat -- 逾期率
    ,ten_asset_deflt_rat -- 前十大资产违约率
    ,cashflow_meas_flg -- 现金流测算标志
    ,asset_tran_cosdetn -- 资产转让对价
    ,tran_cosdetn_calc_way_cd -- 转让对价计算方式代码
    ,tran_contr_id -- 转让合同编号
    ,tran_comm_fee -- 转让手续费
    ,repo_int_rat -- 回购利率
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,def_coll_ped_flg -- 自定义归集周期标志
    ,tran_plat_cd -- 交易平台代码
    ,tran_org_type_cd -- 交易机构类型代码
    ,update_fee_plan_flg -- 更新费用计划标志
   ,cntpty_tran_dt -- 交易对手转账日期
   ,cntpty_pay_amt -- 交易对手已支付金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_abs_prod_info_h_abssf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,prod_name -- 产品名称
    ,prod_type_cd -- 产品类型代码
    ,prod_status_cd -- 产品状态代码
    ,prod_bus_status_cd -- 产品业务状态代码
    ,prod_mode_cd -- 产品模式代码
    ,pre_issue_tot -- 预发行总额
    ,asset_tot -- 资产总额
    ,cfm_issue_tot -- 确认发行总额
    ,curr_cd -- 币种代码
    ,supt_clearup_repo_flg -- 支持清仓回购标志
    ,asset_pool_id -- 资产池编号
    ,trust_effect_dt -- 信托生效日期
    ,trust_exp_dt -- 信托到期日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,issue_dt -- 发行日期
    ,trust_propty_dlvy_dt -- 信托财产交付日期
    ,turn_pay_drift_days -- 转付偏移天数
    ,ts_flg -- 暂存标志
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,setment_way_cd -- 交收方式代码
    ,deflt_rat -- 违约率
    ,repay_rat -- 早偿率
    ,ovdue_rat -- 逾期率
    ,ten_asset_deflt_rat -- 前十大资产违约率
    ,cashflow_meas_flg -- 现金流测算标志
    ,asset_tran_cosdetn -- 资产转让对价
    ,tran_cosdetn_calc_way_cd -- 转让对价计算方式代码
    ,tran_contr_id -- 转让合同编号
    ,tran_comm_fee -- 转让手续费
    ,repo_int_rat -- 回购利率
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,def_coll_ped_flg -- 自定义归集周期标志
    ,tran_plat_cd -- 交易平台代码
    ,tran_org_type_cd -- 交易机构类型代码
    ,update_fee_plan_flg -- 更新费用计划标志
    ,cntpty_tran_dt -- 交易对手转账日期
    ,cntpty_pay_amt -- 交易对手已支付金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.abs_prod_id, o.abs_prod_id) as abs_prod_id -- ABS产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.prod_status_cd, o.prod_status_cd) as prod_status_cd -- 产品状态代码
    ,nvl(n.prod_bus_status_cd, o.prod_bus_status_cd) as prod_bus_status_cd -- 产品业务状态代码
    ,nvl(n.prod_mode_cd, o.prod_mode_cd) as prod_mode_cd -- 产品模式代码
    ,nvl(n.pre_issue_tot, o.pre_issue_tot) as pre_issue_tot -- 预发行总额
    ,nvl(n.asset_tot, o.asset_tot) as asset_tot -- 资产总额
    ,nvl(n.cfm_issue_tot, o.cfm_issue_tot) as cfm_issue_tot -- 确认发行总额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.supt_clearup_repo_flg, o.supt_clearup_repo_flg) as supt_clearup_repo_flg -- 支持清仓回购标志
    ,nvl(n.asset_pool_id, o.asset_pool_id) as asset_pool_id -- 资产池编号
    ,nvl(n.trust_effect_dt, o.trust_effect_dt) as trust_effect_dt -- 信托生效日期
    ,nvl(n.trust_exp_dt, o.trust_exp_dt) as trust_exp_dt -- 信托到期日期
    ,nvl(n.incre_crdt_way_cd, o.incre_crdt_way_cd) as incre_crdt_way_cd -- 增信方式代码
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 发行日期
    ,nvl(n.trust_propty_dlvy_dt, o.trust_propty_dlvy_dt) as trust_propty_dlvy_dt -- 信托财产交付日期
    ,nvl(n.turn_pay_drift_days, o.turn_pay_drift_days) as turn_pay_drift_days -- 转付偏移天数
    ,nvl(n.ts_flg, o.ts_flg) as ts_flg -- 暂存标志
    ,nvl(n.rgstrat_id, o.rgstrat_id) as rgstrat_id -- 登记人编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_tm, o.rgst_tm) as rgst_tm -- 登记时间
    ,nvl(n.setment_way_cd, o.setment_way_cd) as setment_way_cd -- 交收方式代码
    ,nvl(n.deflt_rat, o.deflt_rat) as deflt_rat -- 违约率
    ,nvl(n.repay_rat, o.repay_rat) as repay_rat -- 早偿率
    ,nvl(n.ovdue_rat, o.ovdue_rat) as ovdue_rat -- 逾期率
    ,nvl(n.ten_asset_deflt_rat, o.ten_asset_deflt_rat) as ten_asset_deflt_rat -- 前十大资产违约率
    ,nvl(n.cashflow_meas_flg, o.cashflow_meas_flg) as cashflow_meas_flg -- 现金流测算标志
    ,nvl(n.asset_tran_cosdetn, o.asset_tran_cosdetn) as asset_tran_cosdetn -- 资产转让对价
    ,nvl(n.tran_cosdetn_calc_way_cd, o.tran_cosdetn_calc_way_cd) as tran_cosdetn_calc_way_cd -- 转让对价计算方式代码
    ,nvl(n.tran_contr_id, o.tran_contr_id) as tran_contr_id -- 转让合同编号
    ,nvl(n.tran_comm_fee, o.tran_comm_fee) as tran_comm_fee -- 转让手续费
    ,nvl(n.repo_int_rat, o.repo_int_rat) as repo_int_rat -- 回购利率
    ,nvl(n.tran_cont_begin_dt, o.tran_cont_begin_dt) as tran_cont_begin_dt -- 转让合同起始日期
    ,nvl(n.tran_cont_exp_dt, o.tran_cont_exp_dt) as tran_cont_exp_dt -- 转让合同到期日期
    ,nvl(n.def_coll_ped_flg, o.def_coll_ped_flg) as def_coll_ped_flg -- 自定义归集周期标志
    ,nvl(n.tran_plat_cd, o.tran_plat_cd) as tran_plat_cd -- 交易平台代码
    ,nvl(n.tran_org_type_cd, o.tran_org_type_cd) as tran_org_type_cd -- 交易机构类型代码
    ,nvl(n.update_fee_plan_flg, o.update_fee_plan_flg) as update_fee_plan_flg -- 更新费用计划标志
    ,nvl(n.cntpty_tran_dt, o.cntpty_tran_dt) as cntpty_tran_dt -- 交易对手转账日期
    ,nvl(n.cntpty_pay_amt, o.cntpty_pay_amt) as cntpty_pay_amt -- 交易对手已支付金额
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_abs_prod_info_h_abssf1_tm n
    full join (select * from ${iml_schema}.prd_abs_prod_info_h_abssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
where (
        o.prod_id is null
        and o.lp_id is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
    )
    or (
        o.abs_prod_id <> n.abs_prod_id
        or o.prod_name <> n.prod_name
        or o.prod_type_cd <> n.prod_type_cd
        or o.prod_status_cd <> n.prod_status_cd
        or o.prod_bus_status_cd <> n.prod_bus_status_cd
        or o.prod_mode_cd <> n.prod_mode_cd
        or o.pre_issue_tot <> n.pre_issue_tot
        or o.asset_tot <> n.asset_tot
        or o.cfm_issue_tot <> n.cfm_issue_tot
        or o.curr_cd <> n.curr_cd
        or o.supt_clearup_repo_flg <> n.supt_clearup_repo_flg
        or o.asset_pool_id <> n.asset_pool_id
        or o.trust_effect_dt <> n.trust_effect_dt
        or o.trust_exp_dt <> n.trust_exp_dt
        or o.incre_crdt_way_cd <> n.incre_crdt_way_cd
        or o.issue_dt <> n.issue_dt
        or o.trust_propty_dlvy_dt <> n.trust_propty_dlvy_dt
        or o.turn_pay_drift_days <> n.turn_pay_drift_days
        or o.ts_flg <> n.ts_flg
        or o.rgstrat_id <> n.rgstrat_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_tm <> n.rgst_tm
        or o.setment_way_cd <> n.setment_way_cd
        or o.deflt_rat <> n.deflt_rat
        or o.repay_rat <> n.repay_rat
        or o.ovdue_rat <> n.ovdue_rat
        or o.ten_asset_deflt_rat <> n.ten_asset_deflt_rat
        or o.cashflow_meas_flg <> n.cashflow_meas_flg
        or o.asset_tran_cosdetn <> n.asset_tran_cosdetn
        or o.tran_cosdetn_calc_way_cd <> n.tran_cosdetn_calc_way_cd
        or o.tran_contr_id <> n.tran_contr_id
        or o.tran_comm_fee <> n.tran_comm_fee
        or o.repo_int_rat <> n.repo_int_rat
        or o.tran_cont_begin_dt <> n.tran_cont_begin_dt
        or o.tran_cont_exp_dt <> n.tran_cont_exp_dt
        or o.def_coll_ped_flg <> n.def_coll_ped_flg
        or o.tran_plat_cd <> n.tran_plat_cd
        or o.tran_org_type_cd <> n.tran_org_type_cd
        or o.update_fee_plan_flg <> n.update_fee_plan_flg
        or o.cntpty_tran_dt <> n.cntpty_tran_dt
        or o.cntpty_pay_amt <> n.cntpty_pay_amt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_abs_prod_info_h_abssf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,prod_name -- 产品名称
    ,prod_type_cd -- 产品类型代码
    ,prod_status_cd -- 产品状态代码
    ,prod_bus_status_cd -- 产品业务状态代码
    ,prod_mode_cd -- 产品模式代码
    ,pre_issue_tot -- 预发行总额
    ,asset_tot -- 资产总额
    ,cfm_issue_tot -- 确认发行总额
    ,curr_cd -- 币种代码
    ,supt_clearup_repo_flg -- 支持清仓回购标志
    ,asset_pool_id -- 资产池编号
    ,trust_effect_dt -- 信托生效日期
    ,trust_exp_dt -- 信托到期日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,issue_dt -- 发行日期
    ,trust_propty_dlvy_dt -- 信托财产交付日期
    ,turn_pay_drift_days -- 转付偏移天数
    ,ts_flg -- 暂存标志
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,setment_way_cd -- 交收方式代码
    ,deflt_rat -- 违约率
    ,repay_rat -- 早偿率
    ,ovdue_rat -- 逾期率
    ,ten_asset_deflt_rat -- 前十大资产违约率
    ,cashflow_meas_flg -- 现金流测算标志
    ,asset_tran_cosdetn -- 资产转让对价
    ,tran_cosdetn_calc_way_cd -- 转让对价计算方式代码
    ,tran_contr_id -- 转让合同编号
    ,tran_comm_fee -- 转让手续费
    ,repo_int_rat -- 回购利率
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,def_coll_ped_flg -- 自定义归集周期标志
    ,tran_plat_cd -- 交易平台代码
    ,tran_org_type_cd -- 交易机构类型代码
    ,update_fee_plan_flg -- 更新费用计划标志
    ,cntpty_tran_dt -- 交易对手转账日期
    ,cntpty_pay_amt -- 交易对手已支付金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_abs_prod_info_h_abssf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,prod_name -- 产品名称
    ,prod_type_cd -- 产品类型代码
    ,prod_status_cd -- 产品状态代码
    ,prod_bus_status_cd -- 产品业务状态代码
    ,prod_mode_cd -- 产品模式代码
    ,pre_issue_tot -- 预发行总额
    ,asset_tot -- 资产总额
    ,cfm_issue_tot -- 确认发行总额
    ,curr_cd -- 币种代码
    ,supt_clearup_repo_flg -- 支持清仓回购标志
    ,asset_pool_id -- 资产池编号
    ,trust_effect_dt -- 信托生效日期
    ,trust_exp_dt -- 信托到期日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,issue_dt -- 发行日期
    ,trust_propty_dlvy_dt -- 信托财产交付日期
    ,turn_pay_drift_days -- 转付偏移天数
    ,ts_flg -- 暂存标志
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,setment_way_cd -- 交收方式代码
    ,deflt_rat -- 违约率
    ,repay_rat -- 早偿率
    ,ovdue_rat -- 逾期率
    ,ten_asset_deflt_rat -- 前十大资产违约率
    ,cashflow_meas_flg -- 现金流测算标志
    ,asset_tran_cosdetn -- 资产转让对价
    ,tran_cosdetn_calc_way_cd -- 转让对价计算方式代码
    ,tran_contr_id -- 转让合同编号
    ,tran_comm_fee -- 转让手续费
    ,repo_int_rat -- 回购利率
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,def_coll_ped_flg -- 自定义归集周期标志
    ,tran_plat_cd -- 交易平台代码
    ,tran_org_type_cd -- 交易机构类型代码
    ,update_fee_plan_flg -- 更新费用计划标志
    ,cntpty_tran_dt -- 交易对手转账日期
    ,cntpty_pay_amt -- 交易对手已支付金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.abs_prod_id -- ABS产品编号
    ,o.prod_name -- 产品名称
    ,o.prod_type_cd -- 产品类型代码
    ,o.prod_status_cd -- 产品状态代码
    ,o.prod_bus_status_cd -- 产品业务状态代码
    ,o.prod_mode_cd -- 产品模式代码
    ,o.pre_issue_tot -- 预发行总额
    ,o.asset_tot -- 资产总额
    ,o.cfm_issue_tot -- 确认发行总额
    ,o.curr_cd -- 币种代码
    ,o.supt_clearup_repo_flg -- 支持清仓回购标志
    ,o.asset_pool_id -- 资产池编号
    ,o.trust_effect_dt -- 信托生效日期
    ,o.trust_exp_dt -- 信托到期日期
    ,o.incre_crdt_way_cd -- 增信方式代码
    ,o.issue_dt -- 发行日期
    ,o.trust_propty_dlvy_dt -- 信托财产交付日期
    ,o.turn_pay_drift_days -- 转付偏移天数
    ,o.ts_flg -- 暂存标志
    ,o.rgstrat_id -- 登记人编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_tm -- 登记时间
    ,o.setment_way_cd -- 交收方式代码
    ,o.deflt_rat -- 违约率
    ,o.repay_rat -- 早偿率
    ,o.ovdue_rat -- 逾期率
    ,o.ten_asset_deflt_rat -- 前十大资产违约率
    ,o.cashflow_meas_flg -- 现金流测算标志
    ,o.asset_tran_cosdetn -- 资产转让对价
    ,o.tran_cosdetn_calc_way_cd -- 转让对价计算方式代码
    ,o.tran_contr_id -- 转让合同编号
    ,o.tran_comm_fee -- 转让手续费
    ,o.repo_int_rat -- 回购利率
    ,o.tran_cont_begin_dt -- 转让合同起始日期
    ,o.tran_cont_exp_dt -- 转让合同到期日期
    ,o.def_coll_ped_flg -- 自定义归集周期标志
    ,o.tran_plat_cd -- 交易平台代码
    ,o.tran_org_type_cd -- 交易机构类型代码
    ,o.update_fee_plan_flg -- 更新费用计划标志
    ,o.cntpty_tran_dt -- 交易对手转账日期
    ,o.cntpty_pay_amt -- 交易对手已支付金额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_abs_prod_info_h_abssf1_bk o
    left join ${iml_schema}.prd_abs_prod_info_h_abssf1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_abs_prod_info_h_abssf1_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_abs_prod_info_h;
alter table ${iml_schema}.prd_abs_prod_info_h truncate partition for ('abssf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_abs_prod_info_h exchange subpartition p_abssf1_19000101 with table ${iml_schema}.prd_abs_prod_info_h_abssf1_cl;
alter table ${iml_schema}.prd_abs_prod_info_h exchange subpartition p_abssf1_20991231 with table ${iml_schema}.prd_abs_prod_info_h_abssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_abs_prod_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_abs_prod_info_h_abssf1_tm purge;
drop table ${iml_schema}.prd_abs_prod_info_h_abssf1_op purge;
drop table ${iml_schema}.prd_abs_prod_info_h_abssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_abs_prod_info_h_abssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_abs_prod_info_h', partname => 'p_abssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
