/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_non_std_famsf1
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
drop table ${iml_schema}.prd_non_std_famsf1_tm purge;
drop table ${iml_schema}.prd_non_std_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_non_std add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_non_std modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_non_std_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_non_std partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_non_std_famsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,asset_plan_id -- 资产计划编号
    ,asset_plan_cd -- 资产计划代码
    ,asset_plan_name -- 资产计划名称
    ,cont_id -- 合同编号
    ,co_corp_id -- 合作公司编号
    ,asset_plan_kind_cd -- 资产计划种类代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,actl_cont_amt -- 实际合同金额
    ,curr_cd -- 币种代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,holiday_rule_cd -- 节假日规则代码
    ,pay_int_create_rule_cd -- 付息生成规则代码
    ,fir_pay_int_dt -- 首次付息日期
    ,pay_int_freq -- 付息频率
    ,fac_val_int_rat -- 票面利率
    ,hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,float_int_rat_point -- 浮动利率点数
    ,rpp_freq -- 还本频率
    ,fin_corp_id -- 融资企业编号
    ,indus_cls_cd -- 行业分类代码
    ,gover_fin_plat_flg -- 政府融资平台标志
    ,fir_rpp_dt -- 首次还本日期
    ,valid_flg -- 有效标志
    ,invtor_cd -- 投资方代码
    ,non_std_asset_cls_cd -- 非标资产分类代码
    ,non_std_asset_level2_cd -- 非标资产二级分类代码
    ,non_std_asset_flg -- 非标资产标志
    ,accting_cls_cd -- 会计核算分类代码
    ,init_asset_value_dt -- 原始资产起息日期
    ,init_asset_matu_dt -- 原始资产到期日期
    ,back_end_prft_flg -- 后端收益标志
    ,accti_type_cd -- 核算类型代码
    ,risk_level_cd -- 风险等级代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_non_std
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_non_std_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_non_std partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_tru_info-
insert into ${iml_schema}.prd_non_std_famsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,asset_plan_id -- 资产计划编号
    ,asset_plan_cd -- 资产计划代码
    ,asset_plan_name -- 资产计划名称
    ,cont_id -- 合同编号
    ,co_corp_id -- 合作公司编号
    ,asset_plan_kind_cd -- 资产计划种类代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,actl_cont_amt -- 实际合同金额
    ,curr_cd -- 币种代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,holiday_rule_cd -- 节假日规则代码
    ,pay_int_create_rule_cd -- 付息生成规则代码
    ,fir_pay_int_dt -- 首次付息日期
    ,pay_int_freq -- 付息频率
    ,fac_val_int_rat -- 票面利率
    ,hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,float_int_rat_point -- 浮动利率点数
    ,rpp_freq -- 还本频率
    ,fin_corp_id -- 融资企业编号
    ,indus_cls_cd -- 行业分类代码
    ,gover_fin_plat_flg -- 政府融资平台标志
    ,fir_rpp_dt -- 首次还本日期
    ,valid_flg -- 有效标志
    ,invtor_cd -- 投资方代码
    ,non_std_asset_cls_cd -- 非标资产分类代码
    ,non_std_asset_level2_cd -- 非标资产二级分类代码
    ,non_std_asset_flg -- 非标资产标志
    ,accting_cls_cd -- 会计核算分类代码
    ,init_asset_value_dt -- 原始资产起息日期
    ,init_asset_matu_dt -- 原始资产到期日期
    ,back_end_prft_flg -- 后端收益标志
    ,accti_type_cd -- 核算类型代码
    ,risk_level_cd -- 风险等级代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '211001'||P1.TRUSTUUID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.TRUSTUUID -- 资产计划编号
    ,P1.TRUSTID -- 资产计划代码
    ,P1.TRUSTNAME -- 资产计划名称
    ,P1.CONTRACTNO -- 合同编号
    ,P1.COMPANY -- 合作公司编号
    ,P1.TRUSTTYPE -- 资产计划种类代码
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.VDATE)) -- 起息日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.MDATE)) -- 到期日期
    ,P1.CONTACTAMT -- 实际合同金额
    ,nvl(trim(P1.CCY),'CNY') -- 币种代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BASIS END -- 计息基准代码
    ,P1.INTCALRULE -- 计息方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.INTTYPE END -- 利率调整方式代码
    ,P1.RATE_8 * 100 -- 执行利率
    ,P1.WORKDAYRULE -- 节假日规则代码
    ,P1.SCHECALRULE -- 付息生成规则代码
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.FIRSTPAYDATE)) -- 首次付息日期
    ,P1.PAYCYCLE -- 付息频率
    ,P1.FIRSTRATE * 100 -- 票面利率
    ,P1.RATECODE -- 挂钩浮动利率代码
    ,P1.SPREADRATE -- 浮动利率点数
    ,P1.PRINCYCLE -- 还本频率
    ,P1.FINAENTER -- 融资企业编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.BUSSTYPE END -- 行业分类代码
    ,P1.GOVPLATFLAG -- 政府融资平台标志
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.FIRSTPRINDATE)) -- 首次还本日期
    ,P1.EFFECTFLAG -- 有效标志
    ,nvl(trim(P1.INVESTTYPE),'0') -- 投资方代码
    ,nvl(trim(P1.DEFINEASSETTYPE),'000') -- 非标资产分类代码
    ,nvl(trim(P1.DEFINEASSETTYPE2),'0000') -- 非标资产二级分类代码
    ,P1.ISSTANDARD -- 非标资产标志
    ,nvl(trim(P1.BOOKTYPE),'0') -- 会计核算分类代码
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.ORIVDATE)) -- 原始资产起息日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.ORIMDATE)) -- 原始资产到期日期
    ,P1.BACKENDEARNINGS -- 后端收益标志
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.BOOKTYPE2 END -- 核算类型代码
    ,nvl(trim(P1.RISKLEVEL),'-') -- 风险等级代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_tru_info' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_tru_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BASIS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_TRU_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'BASIS'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_NON_STD'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.INTTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_TRU_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'INTTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_NON_STD'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.BUSSTYPE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FAMS'
        AND R4.SRC_TAB_EN_NAME= 'FAMS_TRU_INFO'
        AND R4.SRC_FIELD_EN_NAME= 'BUSSTYPE'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_NON_STD'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'INDUS_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.BOOKTYPE2 = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_TRU_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'BOOKTYPE2'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_NON_STD'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ACCTI_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_non_std_famsf1_tm 
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
insert /*+ append */ into ${iml_schema}.prd_non_std_famsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,asset_plan_id -- 资产计划编号
    ,asset_plan_cd -- 资产计划代码
    ,asset_plan_name -- 资产计划名称
    ,cont_id -- 合同编号
    ,co_corp_id -- 合作公司编号
    ,asset_plan_kind_cd -- 资产计划种类代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,actl_cont_amt -- 实际合同金额
    ,curr_cd -- 币种代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,holiday_rule_cd -- 节假日规则代码
    ,pay_int_create_rule_cd -- 付息生成规则代码
    ,fir_pay_int_dt -- 首次付息日期
    ,pay_int_freq -- 付息频率
    ,fac_val_int_rat -- 票面利率
    ,hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,float_int_rat_point -- 浮动利率点数
    ,rpp_freq -- 还本频率
    ,fin_corp_id -- 融资企业编号
    ,indus_cls_cd -- 行业分类代码
    ,gover_fin_plat_flg -- 政府融资平台标志
    ,fir_rpp_dt -- 首次还本日期
    ,valid_flg -- 有效标志
    ,invtor_cd -- 投资方代码
    ,non_std_asset_cls_cd -- 非标资产分类代码
    ,non_std_asset_level2_cd -- 非标资产二级分类代码
    ,non_std_asset_flg -- 非标资产标志
    ,accting_cls_cd -- 会计核算分类代码
    ,init_asset_value_dt -- 原始资产起息日期
    ,init_asset_matu_dt -- 原始资产到期日期
    ,back_end_prft_flg -- 后端收益标志
    ,accti_type_cd -- 核算类型代码
    ,risk_level_cd -- 风险等级代码
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
    ,nvl(n.asset_plan_id, o.asset_plan_id) as asset_plan_id -- 资产计划编号
    ,nvl(n.asset_plan_cd, o.asset_plan_cd) as asset_plan_cd -- 资产计划代码
    ,nvl(n.asset_plan_name, o.asset_plan_name) as asset_plan_name -- 资产计划名称
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.co_corp_id, o.co_corp_id) as co_corp_id -- 合作公司编号
    ,nvl(n.asset_plan_kind_cd, o.asset_plan_kind_cd) as asset_plan_kind_cd -- 资产计划种类代码
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.actl_cont_amt, o.actl_cont_amt) as actl_cont_amt -- 实际合同金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.int_accr_way_cd, o.int_accr_way_cd) as int_accr_way_cd -- 计息方式代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.holiday_rule_cd, o.holiday_rule_cd) as holiday_rule_cd -- 节假日规则代码
    ,nvl(n.pay_int_create_rule_cd, o.pay_int_create_rule_cd) as pay_int_create_rule_cd -- 付息生成规则代码
    ,nvl(n.fir_pay_int_dt, o.fir_pay_int_dt) as fir_pay_int_dt -- 首次付息日期
    ,nvl(n.pay_int_freq, o.pay_int_freq) as pay_int_freq -- 付息频率
    ,nvl(n.fac_val_int_rat, o.fac_val_int_rat) as fac_val_int_rat -- 票面利率
    ,nvl(n.hook_float_int_rat_cd, o.hook_float_int_rat_cd) as hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,nvl(n.float_int_rat_point, o.float_int_rat_point) as float_int_rat_point -- 浮动利率点数
    ,nvl(n.rpp_freq, o.rpp_freq) as rpp_freq -- 还本频率
    ,nvl(n.fin_corp_id, o.fin_corp_id) as fin_corp_id -- 融资企业编号
    ,nvl(n.indus_cls_cd, o.indus_cls_cd) as indus_cls_cd -- 行业分类代码
    ,nvl(n.gover_fin_plat_flg, o.gover_fin_plat_flg) as gover_fin_plat_flg -- 政府融资平台标志
    ,nvl(n.fir_rpp_dt, o.fir_rpp_dt) as fir_rpp_dt -- 首次还本日期
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.invtor_cd, o.invtor_cd) as invtor_cd -- 投资方代码
    ,nvl(n.non_std_asset_cls_cd, o.non_std_asset_cls_cd) as non_std_asset_cls_cd -- 非标资产分类代码
    ,nvl(n.non_std_asset_level2_cd, o.non_std_asset_level2_cd) as non_std_asset_level2_cd -- 非标资产二级分类代码
    ,nvl(n.non_std_asset_flg, o.non_std_asset_flg) as non_std_asset_flg -- 非标资产标志
    ,nvl(n.accting_cls_cd, o.accting_cls_cd) as accting_cls_cd -- 会计核算分类代码
    ,nvl(n.init_asset_value_dt, o.init_asset_value_dt) as init_asset_value_dt -- 原始资产起息日期
    ,nvl(n.init_asset_matu_dt, o.init_asset_matu_dt) as init_asset_matu_dt -- 原始资产到期日期
    ,nvl(n.back_end_prft_flg, o.back_end_prft_flg) as back_end_prft_flg -- 后端收益标志
    ,nvl(n.accti_type_cd, o.accti_type_cd) as accti_type_cd -- 核算类型代码
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.asset_plan_id <> n.asset_plan_id
                or o.asset_plan_cd <> n.asset_plan_cd
                or o.asset_plan_name <> n.asset_plan_name
                or o.cont_id <> n.cont_id
                or o.co_corp_id <> n.co_corp_id
                or o.asset_plan_kind_cd <> n.asset_plan_kind_cd
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.actl_cont_amt <> n.actl_cont_amt
                or o.curr_cd <> n.curr_cd
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.int_accr_way_cd <> n.int_accr_way_cd
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.exec_int_rat <> n.exec_int_rat
                or o.holiday_rule_cd <> n.holiday_rule_cd
                or o.pay_int_create_rule_cd <> n.pay_int_create_rule_cd
                or o.fir_pay_int_dt <> n.fir_pay_int_dt
                or o.pay_int_freq <> n.pay_int_freq
                or o.fac_val_int_rat <> n.fac_val_int_rat
                or o.hook_float_int_rat_cd <> n.hook_float_int_rat_cd
                or o.float_int_rat_point <> n.float_int_rat_point
                or o.rpp_freq <> n.rpp_freq
                or o.fin_corp_id <> n.fin_corp_id
                or o.indus_cls_cd <> n.indus_cls_cd
                or o.gover_fin_plat_flg <> n.gover_fin_plat_flg
                or o.fir_rpp_dt <> n.fir_rpp_dt
                or o.valid_flg <> n.valid_flg
                or o.invtor_cd <> n.invtor_cd
                or o.non_std_asset_cls_cd <> n.non_std_asset_cls_cd
                or o.non_std_asset_level2_cd <> n.non_std_asset_level2_cd
                or o.non_std_asset_flg <> n.non_std_asset_flg
                or o.accting_cls_cd <> n.accting_cls_cd
                or o.init_asset_value_dt <> n.init_asset_value_dt
                or o.init_asset_matu_dt <> n.init_asset_matu_dt
                or o.back_end_prft_flg <> n.back_end_prft_flg
                or o.accti_type_cd <> n.accti_type_cd
                or o.risk_level_cd <> n.risk_level_cd
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
from ${iml_schema}.prd_non_std_famsf1_tm n
    full join ${iml_schema}.prd_non_std_famsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_non_std truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_non_std exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.prd_non_std_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_non_std drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_non_std to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_non_std_famsf1_tm purge;
drop table ${iml_schema}.prd_non_std_famsf1_ex purge;
drop table ${iml_schema}.prd_non_std_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_non_std', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);