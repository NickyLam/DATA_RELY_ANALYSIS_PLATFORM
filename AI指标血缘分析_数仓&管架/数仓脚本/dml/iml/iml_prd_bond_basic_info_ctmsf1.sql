/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_bond_basic_info_ctmsf1
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
drop table ${iml_schema}.prd_bond_basic_info_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_basic_info_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_bond_basic_info add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_bond_basic_info modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_bond_basic_info_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_basic_info partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_basic_info_ctmsf1_tm
compress ${option_switch} for query high
as
select
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,bond_abbr -- 债券简称
    ,bond_name -- 债券名称
    ,init_bond_type_cd -- 原债券类型代码
    ,issuer_name -- 发行人名称
    ,guartor_name -- 担保人名称
    ,pric_curr_cd -- 本金币种代码
    ,int_curr_cd -- 利息币种代码
    ,issue_dt -- 发行日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,issue_corp -- 发行单位
    ,int_accr_base_cd -- 计息基准代码
    ,int_rat_type_cd -- 利率类型代码
    ,fac_val_int_rat -- 票面利率
    ,base_rat_id -- 基准利率编号
    ,float_dir_cd -- 浮动方向代码
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_reset_freq -- 利率重置频率
    ,fir_int_rat_reset_dt -- 首次利率重置日期
    ,int_accr_freq -- 计息频率
    ,fir_pay_int_dt -- 首次付息日期
    ,pay_int_freq -- 付息频率
    ,comp_int_freq -- 复利频率
    ,choice_type_cd -- 选择权类型代码
    ,each_issue_rpp_amt -- 每期还本金额
    ,issue_amt -- 发行金额
    ,issue_int_rat -- 发行利率
    ,issue_price -- 发行价格
    ,list_tran_dt -- 上市交易日期
    ,market_type_cd -- 市场类型代码
    ,inpwn_ratio -- 质押比例
    ,tranbl_flg -- 可转换标志
    ,convbl_bond_id -- 可转债编号
    ,discnt_debt_flg -- 贴现债标志
    ,int_rat_float_uplmi -- 利率浮动上限
    ,int_rat_float_lolmi -- 利率浮动下限
    ,int_rat_reset_way_cd -- 利率重置方式代码
    ,stop_tran_dt -- 停止交易日期
    ,guara_type_cd -- 担保品类型代码
    ,init_tenor -- 原始期限
    ,init_tenor_type_cd -- 原期限类型代码
    ,acru_int_flg -- 应计利息标志
    ,bond_type_cd -- 债券类型代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_basic_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_bond_basic_info_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_bond_basic_info partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_v_security-
insert into ${iml_schema}.prd_bond_basic_info_ctmsf1_tm(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,bond_abbr -- 债券简称
    ,bond_name -- 债券名称
    ,init_bond_type_cd -- 原债券类型代码
    ,issuer_name -- 发行人名称
    ,guartor_name -- 担保人名称
    ,pric_curr_cd -- 本金币种代码
    ,int_curr_cd -- 利息币种代码
    ,issue_dt -- 发行日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,issue_corp -- 发行单位
    ,int_accr_base_cd -- 计息基准代码
    ,int_rat_type_cd -- 利率类型代码
    ,fac_val_int_rat -- 票面利率
    ,base_rat_id -- 基准利率编号
    ,float_dir_cd -- 浮动方向代码
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_reset_freq -- 利率重置频率
    ,fir_int_rat_reset_dt -- 首次利率重置日期
    ,int_accr_freq -- 计息频率
    ,fir_pay_int_dt -- 首次付息日期
    ,pay_int_freq -- 付息频率
    ,comp_int_freq -- 复利频率
    ,choice_type_cd -- 选择权类型代码
    ,each_issue_rpp_amt -- 每期还本金额
    ,issue_amt -- 发行金额
    ,issue_int_rat -- 发行利率
    ,issue_price -- 发行价格
    ,list_tran_dt -- 上市交易日期
    ,market_type_cd -- 市场类型代码
    ,inpwn_ratio -- 质押比例
    ,tranbl_flg -- 可转换标志
    ,convbl_bond_id -- 可转债编号
    ,discnt_debt_flg -- 贴现债标志
    ,int_rat_float_uplmi -- 利率浮动上限
    ,int_rat_float_lolmi -- 利率浮动下限
    ,int_rat_reset_way_cd -- 利率重置方式代码
    ,stop_tran_dt -- 停止交易日期
    ,guara_type_cd -- 担保品类型代码
    ,init_tenor -- 原始期限
    ,init_tenor_type_cd -- 原期限类型代码
    ,acru_int_flg -- 应计利息标志
    ,bond_type_cd -- 债券类型代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SECURITY_CODE -- 债券编号
    ,'9999' -- 法人编号
    ,P1.SECURITY_SHORT_NAME -- 债券简称
    ,P1.SECURITY_NAME -- 债券名称
    ,P1.SECURITY_TYPE -- 原债券类型代码
    ,P1.ISSUER -- 发行人名称
    ,P1.GUARANTEE -- 担保人名称
    ,P1.CCY -- 本金币种代码
    ,P1.INT_CCY -- 利息币种代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.ISSUE_DATE) -- 发行日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.START_COUPON_DATE) -- 起息日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITY_DATE) -- 到期日期
    ,P1.LOT_SIZE -- 发行单位
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.DAY_COUNT END -- 计息基准代码
    ,P1.RATE_TYPE -- 利率类型代码
    ,P1.FIXED_RATE -- 票面利率
    ,P1.FLOATING_RATE -- 基准利率编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||to_char(P1.FLOATING_RATE_IND) END -- 浮动方向代码
    ,P1.FLOATING_SPREAD -- 利率浮动点数
    ,P1.FIXING_FREQ -- 利率重置频率
    ,${iml_schema}.DATEFORMAT_MAX(P1.FFIXING_DATE) -- 首次利率重置日期
    ,P1.COUPON_FREQ -- 计息频率
    ,${iml_schema}.DATEFORMAT_MAX(P1.FCOUPON_DATE) -- 首次付息日期
    ,P1.PAYMENT_FREQ -- 付息频率
    ,P1.COMPOUND_FREQ -- 复利频率
    ,P1.OPTION_TYPE -- 选择权类型代码
    ,P1.BACK_AMT -- 每期还本金额
    ,P1.NUMBER_ISSUED -- 发行金额
    ,P1.AUTION_RATE -- 发行利率
    ,P1.AUTION_PRICE -- 发行价格
    ,${iml_schema}.DATEFORMAT_MAX(P1.FIRST_TRADE_DATE) -- 上市交易日期
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.MARKET_TYPE END -- 市场类型代码
    ,P1.REPO_RATIO -- 质押比例
    ,P1.CONVERTABLE -- 可转换标志
    ,P1.CONVERT_SECURITY_CODE -- 可转债编号
    ,P1.DISCOUNT_RATE -- 贴现债标志
    ,P1.CAP -- 利率浮动上限
    ,P1.FLOOR -- 利率浮动下限
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.FIXING_RATE_METHOH END -- 利率重置方式代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.STOP_TRADE_DATE) -- 停止交易日期
    ,P1.COLLATERAL_ID -- 担保品类型代码
    ,P1.ORG_TERM -- 原始期限
    ,P1.ORG_TERM_MULT -- 原期限类型代码
    ,P1.ISJX -- 应计利息标志
    ,P1.SECURITY_TYPE_NEW -- 债券类型代码
    ,P1.NOTE -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_security' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_security p1
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.DAY_COUNT = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'CTMS'
        AND R4.SRC_TAB_EN_NAME= 'CTMS_TBS_V_SECURITY'
        AND R4.SRC_FIELD_EN_NAME= 'DAY_COUNT'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_BOND_BASIC_INFO'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on to_char(P1.FLOATING_RATE_IND) = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'CTMS'
        AND R5.SRC_TAB_EN_NAME= 'CTMS_TBS_V_SECURITY'
        AND R5.SRC_FIELD_EN_NAME= 'FLOATING_RATE_IND'
        AND R5.TARGET_TAB_EN_NAME= 'PRD_BOND_BASIC_INFO'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'FLOAT_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.MARKET_TYPE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'CTMS'
        AND R6.SRC_TAB_EN_NAME= 'CTMS_TBS_V_SECURITY'
        AND R6.SRC_FIELD_EN_NAME= 'MARKET_TYPE'
        AND R6.TARGET_TAB_EN_NAME= 'PRD_BOND_BASIC_INFO'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'MARKET_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.FIXING_RATE_METHOH = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'CTMS'
        AND R8.SRC_TAB_EN_NAME= 'CTMS_TBS_V_SECURITY'
        AND R8.SRC_FIELD_EN_NAME= 'FIXING_RATE_METHOH'
        AND R8.TARGET_TAB_EN_NAME= 'PRD_BOND_BASIC_INFO'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_RESET_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_bond_basic_info_ctmsf1_tm 
  	                                group by 
  	                                        bond_id
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
insert /*+ append */ into ${iml_schema}.prd_bond_basic_info_ctmsf1_ex(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,bond_abbr -- 债券简称
    ,bond_name -- 债券名称
    ,init_bond_type_cd -- 原债券类型代码
    ,issuer_name -- 发行人名称
    ,guartor_name -- 担保人名称
    ,pric_curr_cd -- 本金币种代码
    ,int_curr_cd -- 利息币种代码
    ,issue_dt -- 发行日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,issue_corp -- 发行单位
    ,int_accr_base_cd -- 计息基准代码
    ,int_rat_type_cd -- 利率类型代码
    ,fac_val_int_rat -- 票面利率
    ,base_rat_id -- 基准利率编号
    ,float_dir_cd -- 浮动方向代码
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_reset_freq -- 利率重置频率
    ,fir_int_rat_reset_dt -- 首次利率重置日期
    ,int_accr_freq -- 计息频率
    ,fir_pay_int_dt -- 首次付息日期
    ,pay_int_freq -- 付息频率
    ,comp_int_freq -- 复利频率
    ,choice_type_cd -- 选择权类型代码
    ,each_issue_rpp_amt -- 每期还本金额
    ,issue_amt -- 发行金额
    ,issue_int_rat -- 发行利率
    ,issue_price -- 发行价格
    ,list_tran_dt -- 上市交易日期
    ,market_type_cd -- 市场类型代码
    ,inpwn_ratio -- 质押比例
    ,tranbl_flg -- 可转换标志
    ,convbl_bond_id -- 可转债编号
    ,discnt_debt_flg -- 贴现债标志
    ,int_rat_float_uplmi -- 利率浮动上限
    ,int_rat_float_lolmi -- 利率浮动下限
    ,int_rat_reset_way_cd -- 利率重置方式代码
    ,stop_tran_dt -- 停止交易日期
    ,guara_type_cd -- 担保品类型代码
    ,init_tenor -- 原始期限
    ,init_tenor_type_cd -- 原期限类型代码
    ,acru_int_flg -- 应计利息标志
    ,bond_type_cd -- 债券类型代码
    ,remark -- 备注
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bond_abbr, o.bond_abbr) as bond_abbr -- 债券简称
    ,nvl(n.bond_name, o.bond_name) as bond_name -- 债券名称
    ,nvl(n.init_bond_type_cd, o.init_bond_type_cd) as init_bond_type_cd -- 原债券类型代码
    ,nvl(n.issuer_name, o.issuer_name) as issuer_name -- 发行人名称
    ,nvl(n.guartor_name, o.guartor_name) as guartor_name -- 担保人名称
    ,nvl(n.pric_curr_cd, o.pric_curr_cd) as pric_curr_cd -- 本金币种代码
    ,nvl(n.int_curr_cd, o.int_curr_cd) as int_curr_cd -- 利息币种代码
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 发行日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.issue_corp, o.issue_corp) as issue_corp -- 发行单位
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.fac_val_int_rat, o.fac_val_int_rat) as fac_val_int_rat -- 票面利率
    ,nvl(n.base_rat_id, o.base_rat_id) as base_rat_id -- 基准利率编号
    ,nvl(n.float_dir_cd, o.float_dir_cd) as float_dir_cd -- 浮动方向代码
    ,nvl(n.int_rat_float_point, o.int_rat_float_point) as int_rat_float_point -- 利率浮动点数
    ,nvl(n.int_rat_reset_freq, o.int_rat_reset_freq) as int_rat_reset_freq -- 利率重置频率
    ,nvl(n.fir_int_rat_reset_dt, o.fir_int_rat_reset_dt) as fir_int_rat_reset_dt -- 首次利率重置日期
    ,nvl(n.int_accr_freq, o.int_accr_freq) as int_accr_freq -- 计息频率
    ,nvl(n.fir_pay_int_dt, o.fir_pay_int_dt) as fir_pay_int_dt -- 首次付息日期
    ,nvl(n.pay_int_freq, o.pay_int_freq) as pay_int_freq -- 付息频率
    ,nvl(n.comp_int_freq, o.comp_int_freq) as comp_int_freq -- 复利频率
    ,nvl(n.choice_type_cd, o.choice_type_cd) as choice_type_cd -- 选择权类型代码
    ,nvl(n.each_issue_rpp_amt, o.each_issue_rpp_amt) as each_issue_rpp_amt -- 每期还本金额
    ,nvl(n.issue_amt, o.issue_amt) as issue_amt -- 发行金额
    ,nvl(n.issue_int_rat, o.issue_int_rat) as issue_int_rat -- 发行利率
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价格
    ,nvl(n.list_tran_dt, o.list_tran_dt) as list_tran_dt -- 上市交易日期
    ,nvl(n.market_type_cd, o.market_type_cd) as market_type_cd -- 市场类型代码
    ,nvl(n.inpwn_ratio, o.inpwn_ratio) as inpwn_ratio -- 质押比例
    ,nvl(n.tranbl_flg, o.tranbl_flg) as tranbl_flg -- 可转换标志
    ,nvl(n.convbl_bond_id, o.convbl_bond_id) as convbl_bond_id -- 可转债编号
    ,nvl(n.discnt_debt_flg, o.discnt_debt_flg) as discnt_debt_flg -- 贴现债标志
    ,nvl(n.int_rat_float_uplmi, o.int_rat_float_uplmi) as int_rat_float_uplmi -- 利率浮动上限
    ,nvl(n.int_rat_float_lolmi, o.int_rat_float_lolmi) as int_rat_float_lolmi -- 利率浮动下限
    ,nvl(n.int_rat_reset_way_cd, o.int_rat_reset_way_cd) as int_rat_reset_way_cd -- 利率重置方式代码
    ,nvl(n.stop_tran_dt, o.stop_tran_dt) as stop_tran_dt -- 停止交易日期
    ,nvl(n.guara_type_cd, o.guara_type_cd) as guara_type_cd -- 担保品类型代码
    ,nvl(n.init_tenor, o.init_tenor) as init_tenor -- 原始期限
    ,nvl(n.init_tenor_type_cd, o.init_tenor_type_cd) as init_tenor_type_cd -- 原期限类型代码
    ,nvl(n.acru_int_flg, o.acru_int_flg) as acru_int_flg -- 应计利息标志
    ,nvl(n.bond_type_cd, o.bond_type_cd) as bond_type_cd -- 债券类型代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.bond_id is null
                and o.lp_id is null
            ) or (
                o.bond_abbr <> n.bond_abbr
                or o.bond_name <> n.bond_name
                or o.init_bond_type_cd <> n.init_bond_type_cd
                or o.issuer_name <> n.issuer_name
                or o.guartor_name <> n.guartor_name
                or o.pric_curr_cd <> n.pric_curr_cd
                or o.int_curr_cd <> n.int_curr_cd
                or o.issue_dt <> n.issue_dt
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.issue_corp <> n.issue_corp
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.int_rat_type_cd <> n.int_rat_type_cd
                or o.fac_val_int_rat <> n.fac_val_int_rat
                or o.base_rat_id <> n.base_rat_id
                or o.float_dir_cd <> n.float_dir_cd
                or o.int_rat_float_point <> n.int_rat_float_point
                or o.int_rat_reset_freq <> n.int_rat_reset_freq
                or o.fir_int_rat_reset_dt <> n.fir_int_rat_reset_dt
                or o.int_accr_freq <> n.int_accr_freq
                or o.fir_pay_int_dt <> n.fir_pay_int_dt
                or o.pay_int_freq <> n.pay_int_freq
                or o.comp_int_freq <> n.comp_int_freq
                or o.choice_type_cd <> n.choice_type_cd
                or o.each_issue_rpp_amt <> n.each_issue_rpp_amt
                or o.issue_amt <> n.issue_amt
                or o.issue_int_rat <> n.issue_int_rat
                or o.issue_price <> n.issue_price
                or o.list_tran_dt <> n.list_tran_dt
                or o.market_type_cd <> n.market_type_cd
                or o.inpwn_ratio <> n.inpwn_ratio
                or o.tranbl_flg <> n.tranbl_flg
                or o.convbl_bond_id <> n.convbl_bond_id
                or o.discnt_debt_flg <> n.discnt_debt_flg
                or o.int_rat_float_uplmi <> n.int_rat_float_uplmi
                or o.int_rat_float_lolmi <> n.int_rat_float_lolmi
                or o.int_rat_reset_way_cd <> n.int_rat_reset_way_cd
                or o.stop_tran_dt <> n.stop_tran_dt
                or o.guara_type_cd <> n.guara_type_cd
                or o.init_tenor <> n.init_tenor
                or o.init_tenor_type_cd <> n.init_tenor_type_cd
                or o.acru_int_flg <> n.acru_int_flg
                or o.bond_type_cd <> n.bond_type_cd
                or o.remark <> n.remark
            ) or (
                 case when (
                           n.bond_id is null
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
                n.bond_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_basic_info_ctmsf1_tm n
    full join ${iml_schema}.prd_bond_basic_info_ctmsf1_bk o
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_bond_basic_info truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_bond_basic_info exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.prd_bond_basic_info_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_bond_basic_info drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_bond_basic_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_bond_basic_info_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_basic_info_ctmsf1_ex purge;
drop table ${iml_schema}.prd_bond_basic_info_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_bond_basic_info', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);