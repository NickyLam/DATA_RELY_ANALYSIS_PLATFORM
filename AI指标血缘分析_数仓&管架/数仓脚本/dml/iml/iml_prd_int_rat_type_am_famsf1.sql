/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_int_rat_type_am_famsf1
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
drop table ${iml_schema}.prd_int_rat_type_am_famsf1_tm purge;
drop table ${iml_schema}.prd_int_rat_type_am_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_int_rat_type_am add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_int_rat_type_am modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_int_rat_type_am_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_int_rat_type_am partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_int_rat_type_am_famsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,user_prod_id -- 用户产品编号
    ,prod_abbr -- 产品简称
    ,prod_name -- 产品名称
    ,prft_type_cd -- 收益类型代码
    ,cap_dir_cd -- 资金投向代码
    ,risk_level_cd -- 风险等级代码
    ,move_way_cd -- 运行方式代码
    ,open_ped -- 开放周期
    ,prft_mode_cd -- 收益模式代码
    ,curr_cd -- 币种代码
    ,sell_chn_cd -- 销售渠道代码
    ,oper_mode_cd -- 运营模式代码
    ,prod_seri_id -- 产品系列编号
    ,coll_uplmi_amt -- 募集上限金额
    ,coll_lolmi_amt -- 募集下限金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,subscr_sp_amt -- 认购起点金额
    ,supp_amt -- 追加金额
    ,redem_sp_amt -- 赎回起点金额
    ,lowt_hold_lot -- 最低持有份额
    ,prod_value_dt -- 产品起息日期
    ,prod_exp_dt -- 产品到期日期
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,pay_int_ped -- 付息周期
    ,pay_int_ped_type_cd -- 付息周期类型代码
    ,pay_int_ped_fea_cd -- 付息周期特征代码
    ,fir_pay_int_dt -- 首次付息日期
    ,bus_day_rule_cd -- 营业日规则代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,quot_way_cd -- 报价方式代码
    ,quot_ped -- 报价周期
    ,quot_ped_type_cd -- 报价周期类型代码
    ,float_int_rat_point -- 浮动利率点数
    ,expe_yld_rat -- 预期收益率
    ,valid_flg -- 有效标志
    ,prod_acct_id -- 产品账户编号
    ,float_int_rat_cd -- 浮动利率代码
    ,coll_way_cd -- 募集方式代码
    ,mgmt_way_cd -- 管理方式代码
    ,bus_mode_cd -- 业务模式代码
    ,redembl_flg -- 可赎回标志
    ,advd_termnt_flg -- 可提前终止标志
    ,sell_rg_name -- 销售地区名称
    ,finc_cust_name -- 理财客户名称
    ,trust_bank_id -- 托管银行编号
    ,finc_mgr_id -- 理财经理编号
    ,prod_cls_cd -- 产品分类代码
    ,expe_invest_yld_rat -- 预期投资收益率
    ,prod_found_dt -- 产品成立日期
    ,crt_way_cd -- 创设方式代码
    ,seri_int_perds -- 系列内期数
    ,year_int_perds -- 年内期数
    ,asset_trf_bk_cd -- 资产出让行代码
    ,found_flg -- 成立标志
    ,cap_pool_acct_id -- 资金池账户编号
    ,prod_rgst_id -- 产品登记编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_int_rat_type_am
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_int_rat_type_am_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_int_rat_type_am partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_prd_baseinfo-
insert into ${iml_schema}.prd_int_rat_type_am_famsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,user_prod_id -- 用户产品编号
    ,prod_abbr -- 产品简称
    ,prod_name -- 产品名称
    ,prft_type_cd -- 收益类型代码
    ,cap_dir_cd -- 资金投向代码
    ,risk_level_cd -- 风险等级代码
    ,move_way_cd -- 运行方式代码
    ,open_ped -- 开放周期
    ,prft_mode_cd -- 收益模式代码
    ,curr_cd -- 币种代码
    ,sell_chn_cd -- 销售渠道代码
    ,oper_mode_cd -- 运营模式代码
    ,prod_seri_id -- 产品系列编号
    ,coll_uplmi_amt -- 募集上限金额
    ,coll_lolmi_amt -- 募集下限金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,subscr_sp_amt -- 认购起点金额
    ,supp_amt -- 追加金额
    ,redem_sp_amt -- 赎回起点金额
    ,lowt_hold_lot -- 最低持有份额
    ,prod_value_dt -- 产品起息日期
    ,prod_exp_dt -- 产品到期日期
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,pay_int_ped -- 付息周期
    ,pay_int_ped_type_cd -- 付息周期类型代码
    ,pay_int_ped_fea_cd -- 付息周期特征代码
    ,fir_pay_int_dt -- 首次付息日期
    ,bus_day_rule_cd -- 营业日规则代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,quot_way_cd -- 报价方式代码
    ,quot_ped -- 报价周期
    ,quot_ped_type_cd -- 报价周期类型代码
    ,float_int_rat_point -- 浮动利率点数
    ,expe_yld_rat -- 预期收益率
    ,valid_flg -- 有效标志
    ,prod_acct_id -- 产品账户编号
    ,float_int_rat_cd -- 浮动利率代码
    ,coll_way_cd -- 募集方式代码
    ,mgmt_way_cd -- 管理方式代码
    ,bus_mode_cd -- 业务模式代码
    ,redembl_flg -- 可赎回标志
    ,advd_termnt_flg -- 可提前终止标志
    ,sell_rg_name -- 销售地区名称
    ,finc_cust_name -- 理财客户名称
    ,trust_bank_id -- 托管银行编号
    ,finc_mgr_id -- 理财经理编号
    ,prod_cls_cd -- 产品分类代码
    ,expe_invest_yld_rat -- 预期投资收益率
    ,prod_found_dt -- 产品成立日期
    ,crt_way_cd -- 创设方式代码
    ,seri_int_perds -- 系列内期数
    ,year_int_perds -- 年内期数
    ,asset_trf_bk_cd -- 资产出让行代码
    ,found_flg -- 成立标志
    ,cap_pool_acct_id -- 资金池账户编号
    ,prod_rgst_id -- 产品登记编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223001'||P1.PRODUUID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.PRODID -- 用户产品编号
    ,P1.PROD_ABBR -- 产品简称
    ,P1.PROD_NAME -- 产品名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PROFITFLAG END -- 收益类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ASSETMARKET END -- 资金投向代码
    ,P1.RISKLEVEL -- 风险等级代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ISSUETYPE END -- 运行方式代码
    ,P1.OPENCYCLE -- 开放周期
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.PROFIT_MODE END -- 收益模式代码
    ,P1.CURRENCY -- 币种代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.SALETARGET END -- 销售渠道代码
    ,nvl(trim(P1.OPERATEMODE),'-') -- 运营模式代码
    ,P1.PRODSERIES -- 产品系列编号
    ,P1.PLANRAISEAMTMAX -- 募集上限金额
    ,P1.PLANRAISEAMTMIN -- 募集下限金额
    ,P1.RAISESTARTDATE -- 募集开始日期
    ,P1.RAISEENDDATE -- 募集结束日期
    ,P1.SUBSTARTAMT -- 认购起点金额
    ,P1.SUBADDAMT -- 追加金额
    ,P1.REDSTARTAMT -- 赎回起点金额
    ,P1.REDPOSTION -- 最低持有份额
    ,P1.VDATE -- 产品起息日期
    ,P1.MDATE -- 产品到期日期
    ,P1.TERM -- 期限
    ,P1.TERMTYPE -- 期限类型代码
    ,P1.INTPAYCYCLE -- 付息周期
    ,P1.INTPAYUNIT -- 付息周期类型代码
    ,P1.CALRULE -- 付息周期特征代码
    ,P1.FIRSTPAYDATE -- 首次付息日期
    ,P1.TRADEDAYRULE -- 营业日规则代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.BASIS END -- 计息基准代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.RATETYPE END -- 利率调整方式代码
    ,nvl(trim(P1.PRICERULE),'0') -- 报价方式代码
    ,P1.QUOTECYCLE -- 报价周期
    ,nvl(trim(P1.QUOTEUNIT),'-') -- 报价周期类型代码
    ,P1.SPREADRATE -- 浮动利率点数
    ,P1.PROPRATE -- 预期收益率
    ,P1.EFFECTFLAG -- 有效标志
    ,P1.ACCOUNT -- 产品账户编号
    ,P1.BASERATETYPEDEL -- 浮动利率代码
    ,P1.RAISETYPE -- 募集方式代码
    ,P1.MANATYPE -- 管理方式代码
    ,P1.BOOKMODEL -- 业务模式代码
    ,P1.REDFLAG -- 可赎回标志
    ,P1.ENDFLAG -- 可提前终止标志
    ,P1.SALEAREA -- 销售地区名称
    ,P1.CUSTOMNAME -- 理财客户名称
    ,P1.TRUBANK -- 托管银行编号
    ,P1.MANAGER -- 理财经理编号
    ,nvl(trim(P1.INNERCLASS1),'-') -- 产品分类代码
    ,P1.INVESTRATE -- 预期投资收益率
    ,P1.BOOKDATE -- 产品成立日期
    ,nvl(trim(P1.CRTTYPE),'-') -- 创设方式代码
    ,P1.SERIESNUM -- 系列内期数
    ,P1.YEARNUM -- 年内期数
    ,P1.AMTBANK -- 资产出让行代码
    ,P1.ISSUEFLAG -- 成立标志
    ,P1.RELPOOL -- 资金池账户编号
    ,P1.REGISTERID -- 产品登记编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_prd_baseinfo' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_prd_baseinfo p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PROFITFLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_PRD_BASEINFO'
        AND R1.SRC_FIELD_EN_NAME= 'PROFITFLAG'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_INT_RAT_TYPE_AM'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PRFT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ASSETMARKET = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_PRD_BASEINFO'
        AND R2.SRC_FIELD_EN_NAME= 'ASSETMARKET'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_INT_RAT_TYPE_AM'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CAP_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ISSUETYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_PRD_BASEINFO'
        AND R3.SRC_FIELD_EN_NAME= 'ISSUETYPE'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_INT_RAT_TYPE_AM'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'MOVE_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.PROFIT_MODE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FAMS'
        AND R4.SRC_TAB_EN_NAME= 'FAMS_PRD_BASEINFO'
        AND R4.SRC_FIELD_EN_NAME= 'PROFIT_MODE'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_INT_RAT_TYPE_AM'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'PRFT_MODE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.SALETARGET = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'FAMS'
        AND R7.SRC_TAB_EN_NAME= 'FAMS_PRD_BASEINFO'
        AND R7.SRC_FIELD_EN_NAME= 'SALETARGET'
        AND R7.TARGET_TAB_EN_NAME= 'PRD_INT_RAT_TYPE_AM'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'SELL_CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.BASIS = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FAMS'
        AND R5.SRC_TAB_EN_NAME= 'FAMS_PRD_BASEINFO'
        AND R5.SRC_FIELD_EN_NAME= 'BASIS'
        AND R5.TARGET_TAB_EN_NAME= 'PRD_INT_RAT_TYPE_AM'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.RATETYPE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'FAMS'
        AND R6.SRC_TAB_EN_NAME= 'FAMS_PRD_BASEINFO'
        AND R6.SRC_FIELD_EN_NAME= 'RATETYPE'
        AND R6.TARGET_TAB_EN_NAME= 'PRD_INT_RAT_TYPE_AM'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_int_rat_type_am_famsf1_tm 
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.prd_int_rat_type_am_famsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,user_prod_id -- 用户产品编号
    ,prod_abbr -- 产品简称
    ,prod_name -- 产品名称
    ,prft_type_cd -- 收益类型代码
    ,cap_dir_cd -- 资金投向代码
    ,risk_level_cd -- 风险等级代码
    ,move_way_cd -- 运行方式代码
    ,open_ped -- 开放周期
    ,prft_mode_cd -- 收益模式代码
    ,curr_cd -- 币种代码
    ,sell_chn_cd -- 销售渠道代码
    ,oper_mode_cd -- 运营模式代码
    ,prod_seri_id -- 产品系列编号
    ,coll_uplmi_amt -- 募集上限金额
    ,coll_lolmi_amt -- 募集下限金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,subscr_sp_amt -- 认购起点金额
    ,supp_amt -- 追加金额
    ,redem_sp_amt -- 赎回起点金额
    ,lowt_hold_lot -- 最低持有份额
    ,prod_value_dt -- 产品起息日期
    ,prod_exp_dt -- 产品到期日期
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,pay_int_ped -- 付息周期
    ,pay_int_ped_type_cd -- 付息周期类型代码
    ,pay_int_ped_fea_cd -- 付息周期特征代码
    ,fir_pay_int_dt -- 首次付息日期
    ,bus_day_rule_cd -- 营业日规则代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,quot_way_cd -- 报价方式代码
    ,quot_ped -- 报价周期
    ,quot_ped_type_cd -- 报价周期类型代码
    ,float_int_rat_point -- 浮动利率点数
    ,expe_yld_rat -- 预期收益率
    ,valid_flg -- 有效标志
    ,prod_acct_id -- 产品账户编号
    ,float_int_rat_cd -- 浮动利率代码
    ,coll_way_cd -- 募集方式代码
    ,mgmt_way_cd -- 管理方式代码
    ,bus_mode_cd -- 业务模式代码
    ,redembl_flg -- 可赎回标志
    ,advd_termnt_flg -- 可提前终止标志
    ,sell_rg_name -- 销售地区名称
    ,finc_cust_name -- 理财客户名称
    ,trust_bank_id -- 托管银行编号
    ,finc_mgr_id -- 理财经理编号
    ,prod_cls_cd -- 产品分类代码
    ,expe_invest_yld_rat -- 预期投资收益率
    ,prod_found_dt -- 产品成立日期
    ,crt_way_cd -- 创设方式代码
    ,seri_int_perds -- 系列内期数
    ,year_int_perds -- 年内期数
    ,asset_trf_bk_cd -- 资产出让行代码
    ,found_flg -- 成立标志
    ,cap_pool_acct_id -- 资金池账户编号
    ,prod_rgst_id -- 产品登记编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.user_prod_id, o.user_prod_id) as user_prod_id -- 用户产品编号
    ,nvl(n.prod_abbr, o.prod_abbr) as prod_abbr -- 产品简称
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.prft_type_cd, o.prft_type_cd) as prft_type_cd -- 收益类型代码
    ,nvl(n.cap_dir_cd, o.cap_dir_cd) as cap_dir_cd -- 资金投向代码
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.move_way_cd, o.move_way_cd) as move_way_cd -- 运行方式代码
    ,nvl(n.open_ped, o.open_ped) as open_ped -- 开放周期
    ,nvl(n.prft_mode_cd, o.prft_mode_cd) as prft_mode_cd -- 收益模式代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sell_chn_cd, o.sell_chn_cd) as sell_chn_cd -- 销售渠道代码
    ,nvl(n.oper_mode_cd, o.oper_mode_cd) as oper_mode_cd -- 运营模式代码
    ,nvl(n.prod_seri_id, o.prod_seri_id) as prod_seri_id -- 产品系列编号
    ,nvl(n.coll_uplmi_amt, o.coll_uplmi_amt) as coll_uplmi_amt -- 募集上限金额
    ,nvl(n.coll_lolmi_amt, o.coll_lolmi_amt) as coll_lolmi_amt -- 募集下限金额
    ,nvl(n.coll_start_dt, o.coll_start_dt) as coll_start_dt -- 募集开始日期
    ,nvl(n.coll_end_dt, o.coll_end_dt) as coll_end_dt -- 募集结束日期
    ,nvl(n.subscr_sp_amt, o.subscr_sp_amt) as subscr_sp_amt -- 认购起点金额
    ,nvl(n.supp_amt, o.supp_amt) as supp_amt -- 追加金额
    ,nvl(n.redem_sp_amt, o.redem_sp_amt) as redem_sp_amt -- 赎回起点金额
    ,nvl(n.lowt_hold_lot, o.lowt_hold_lot) as lowt_hold_lot -- 最低持有份额
    ,nvl(n.prod_value_dt, o.prod_value_dt) as prod_value_dt -- 产品起息日期
    ,nvl(n.prod_exp_dt, o.prod_exp_dt) as prod_exp_dt -- 产品到期日期
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.pay_int_ped, o.pay_int_ped) as pay_int_ped -- 付息周期
    ,nvl(n.pay_int_ped_type_cd, o.pay_int_ped_type_cd) as pay_int_ped_type_cd -- 付息周期类型代码
    ,nvl(n.pay_int_ped_fea_cd, o.pay_int_ped_fea_cd) as pay_int_ped_fea_cd -- 付息周期特征代码
    ,nvl(n.fir_pay_int_dt, o.fir_pay_int_dt) as fir_pay_int_dt -- 首次付息日期
    ,nvl(n.bus_day_rule_cd, o.bus_day_rule_cd) as bus_day_rule_cd -- 营业日规则代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.quot_way_cd, o.quot_way_cd) as quot_way_cd -- 报价方式代码
    ,nvl(n.quot_ped, o.quot_ped) as quot_ped -- 报价周期
    ,nvl(n.quot_ped_type_cd, o.quot_ped_type_cd) as quot_ped_type_cd -- 报价周期类型代码
    ,nvl(n.float_int_rat_point, o.float_int_rat_point) as float_int_rat_point -- 浮动利率点数
    ,nvl(n.expe_yld_rat, o.expe_yld_rat) as expe_yld_rat -- 预期收益率
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.prod_acct_id, o.prod_acct_id) as prod_acct_id -- 产品账户编号
    ,nvl(n.float_int_rat_cd, o.float_int_rat_cd) as float_int_rat_cd -- 浮动利率代码
    ,nvl(n.coll_way_cd, o.coll_way_cd) as coll_way_cd -- 募集方式代码
    ,nvl(n.mgmt_way_cd, o.mgmt_way_cd) as mgmt_way_cd -- 管理方式代码
    ,nvl(n.bus_mode_cd, o.bus_mode_cd) as bus_mode_cd -- 业务模式代码
    ,nvl(n.redembl_flg, o.redembl_flg) as redembl_flg -- 可赎回标志
    ,nvl(n.advd_termnt_flg, o.advd_termnt_flg) as advd_termnt_flg -- 可提前终止标志
    ,nvl(n.sell_rg_name, o.sell_rg_name) as sell_rg_name -- 销售地区名称
    ,nvl(n.finc_cust_name, o.finc_cust_name) as finc_cust_name -- 理财客户名称
    ,nvl(n.trust_bank_id, o.trust_bank_id) as trust_bank_id -- 托管银行编号
    ,nvl(n.finc_mgr_id, o.finc_mgr_id) as finc_mgr_id -- 理财经理编号
    ,nvl(n.prod_cls_cd, o.prod_cls_cd) as prod_cls_cd -- 产品分类代码
    ,nvl(n.expe_invest_yld_rat, o.expe_invest_yld_rat) as expe_invest_yld_rat -- 预期投资收益率
    ,nvl(n.prod_found_dt, o.prod_found_dt) as prod_found_dt -- 产品成立日期
    ,nvl(n.crt_way_cd, o.crt_way_cd) as crt_way_cd -- 创设方式代码
    ,nvl(n.seri_int_perds, o.seri_int_perds) as seri_int_perds -- 系列内期数
    ,nvl(n.year_int_perds, o.year_int_perds) as year_int_perds -- 年内期数
    ,nvl(n.asset_trf_bk_cd, o.asset_trf_bk_cd) as asset_trf_bk_cd -- 资产出让行代码
    ,nvl(n.found_flg, o.found_flg) as found_flg -- 成立标志
    ,nvl(n.cap_pool_acct_id, o.cap_pool_acct_id) as cap_pool_acct_id -- 资金池账户编号
    ,nvl(n.prod_rgst_id, o.prod_rgst_id) as prod_rgst_id -- 产品登记编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.user_prod_id <> n.user_prod_id
                or o.prod_abbr <> n.prod_abbr
                or o.prod_name <> n.prod_name
                or o.prft_type_cd <> n.prft_type_cd
                or o.cap_dir_cd <> n.cap_dir_cd
                or o.risk_level_cd <> n.risk_level_cd
                or o.move_way_cd <> n.move_way_cd
                or o.open_ped <> n.open_ped
                or o.prft_mode_cd <> n.prft_mode_cd
                or o.curr_cd <> n.curr_cd
                or o.sell_chn_cd <> n.sell_chn_cd
                or o.oper_mode_cd <> n.oper_mode_cd
                or o.prod_seri_id <> n.prod_seri_id
                or o.coll_uplmi_amt <> n.coll_uplmi_amt
                or o.coll_lolmi_amt <> n.coll_lolmi_amt
                or o.coll_start_dt <> n.coll_start_dt
                or o.coll_end_dt <> n.coll_end_dt
                or o.subscr_sp_amt <> n.subscr_sp_amt
                or o.supp_amt <> n.supp_amt
                or o.redem_sp_amt <> n.redem_sp_amt
                or o.lowt_hold_lot <> n.lowt_hold_lot
                or o.prod_value_dt <> n.prod_value_dt
                or o.prod_exp_dt <> n.prod_exp_dt
                or o.tenor <> n.tenor
                or o.tenor_type_cd <> n.tenor_type_cd
                or o.pay_int_ped <> n.pay_int_ped
                or o.pay_int_ped_type_cd <> n.pay_int_ped_type_cd
                or o.pay_int_ped_fea_cd <> n.pay_int_ped_fea_cd
                or o.fir_pay_int_dt <> n.fir_pay_int_dt
                or o.bus_day_rule_cd <> n.bus_day_rule_cd
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.quot_way_cd <> n.quot_way_cd
                or o.quot_ped <> n.quot_ped
                or o.quot_ped_type_cd <> n.quot_ped_type_cd
                or o.float_int_rat_point <> n.float_int_rat_point
                or o.expe_yld_rat <> n.expe_yld_rat
                or o.valid_flg <> n.valid_flg
                or o.prod_acct_id <> n.prod_acct_id
                or o.float_int_rat_cd <> n.float_int_rat_cd
                or o.coll_way_cd <> n.coll_way_cd
                or o.mgmt_way_cd <> n.mgmt_way_cd
                or o.bus_mode_cd <> n.bus_mode_cd
                or o.redembl_flg <> n.redembl_flg
                or o.advd_termnt_flg <> n.advd_termnt_flg
                or o.sell_rg_name <> n.sell_rg_name
                or o.finc_cust_name <> n.finc_cust_name
                or o.trust_bank_id <> n.trust_bank_id
                or o.finc_mgr_id <> n.finc_mgr_id
                or o.prod_cls_cd <> n.prod_cls_cd
                or o.expe_invest_yld_rat <> n.expe_invest_yld_rat
                or o.prod_found_dt <> n.prod_found_dt
                or o.crt_way_cd <> n.crt_way_cd
                or o.seri_int_perds <> n.seri_int_perds
                or o.year_int_perds <> n.year_int_perds
                or o.asset_trf_bk_cd <> n.asset_trf_bk_cd
                or o.found_flg <> n.found_flg
                or o.cap_pool_acct_id <> n.cap_pool_acct_id
                or o.prod_rgst_id <> n.prod_rgst_id
            ) or (
                 case when (
                           n.prod_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.prod_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_int_rat_type_am_famsf1_tm n
    full join ${iml_schema}.prd_int_rat_type_am_famsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_int_rat_type_am truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_int_rat_type_am exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.prd_int_rat_type_am_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_int_rat_type_am drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_int_rat_type_am to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_int_rat_type_am_famsf1_tm purge;
drop table ${iml_schema}.prd_int_rat_type_am_famsf1_ex purge;
drop table ${iml_schema}.prd_int_rat_type_am_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_int_rat_type_am', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);