/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_bond_famsf1
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
drop table ${iml_schema}.prd_bond_famsf1_tm purge;
drop table ${iml_schema}.prd_bond_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_bond add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_bond modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_bond_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_famsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,bond_name -- 债券名称
    ,bond_fname -- 债券全称
    ,bond_id -- 债券编号
    ,tran_market_cd -- 交易市场代码
    ,int_accr_base_cd -- 计息基准代码
    ,coupon_breed_cd -- 息票品种代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,pay_int_freq -- 付息频率
    ,fac_val -- 面值
    ,issue_price -- 发行价格
    ,fac_val_int_rat -- 票面利率
    ,issue_tot -- 发行总额
    ,int_assign_way_cd -- 利息分配方式代码
    ,pay_int_intrv_calcu_method_cd -- 付息区间推算方法代码
    ,fir_pay_int_dt -- 首次付息日期
    ,holiday_rule_cd -- 节假日规则代码
    ,hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,float_int_rat_point -- 浮动利率点数
    ,float_coef -- 浮动系数
    ,bond_type_cd -- 债券类型代码
    ,valid_flg -- 有效标志
    ,redembl_flg -- 可赎回标志
    ,putbl_flg -- 可回售标志
    ,brkevn_flg -- 保本标志
    ,issuer_indus_type_cd -- 发行人行业类型代码
    ,issuer_indus_cls_cd -- 发行人行业分类代码
    ,issuer_name -- 发行人名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_bond_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_bond partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_src_secinfo-
insert into ${iml_schema}.prd_bond_famsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,bond_name -- 债券名称
    ,bond_fname -- 债券全称
    ,bond_id -- 债券编号
    ,tran_market_cd -- 交易市场代码
    ,int_accr_base_cd -- 计息基准代码
    ,coupon_breed_cd -- 息票品种代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,pay_int_freq -- 付息频率
    ,fac_val -- 面值
    ,issue_price -- 发行价格
    ,fac_val_int_rat -- 票面利率
    ,issue_tot -- 发行总额
    ,int_assign_way_cd -- 利息分配方式代码
    ,pay_int_intrv_calcu_method_cd -- 付息区间推算方法代码
    ,fir_pay_int_dt -- 首次付息日期
    ,holiday_rule_cd -- 节假日规则代码
    ,hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,float_int_rat_point -- 浮动利率点数
    ,float_coef -- 浮动系数
    ,bond_type_cd -- 债券类型代码
    ,valid_flg -- 有效标志
    ,redembl_flg -- 可赎回标志
    ,putbl_flg -- 可回售标志
    ,brkevn_flg -- 保本标志
    ,issuer_indus_type_cd -- 发行人行业类型代码
    ,issuer_indus_cls_cd -- 发行人行业分类代码
    ,issuer_name -- 发行人名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '212001'||P1.SECID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.SECNAME -- 债券名称
    ,P1.SECFULLNAME -- 债券全称
    ,P1.SECCODE -- 债券编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.MARKET END -- 交易市场代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.RATEBASIC END -- 计息基准代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.COUPONSPECIES END -- 息票品种代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.INTERESTRATE END -- 利率调整方式代码
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.VDATE)) -- 起息日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.MDATE)) -- 到期日期
    ,P1.INTERESTFREQUENCY -- 付息频率
    ,P1.FACEVALUE -- 面值
    ,P1.ISSUEPRICE -- 发行价格
    ,P1.PAPERIR*100 -- 票面利率
    ,P1.ISSUEAMT -- 发行总额
    ,nvl(trim(P1.INTPAYRULE),'-') -- 利息分配方式代码
    ,P1.SCHECALRULE -- 付息区间推算方法代码
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.FIRSTRATEDAY)) -- 首次付息日期
    ,P1.WORKDAYRULE -- 节假日规则代码
    ,P1.RATECODE -- 挂钩浮动利率代码
    ,P1.SPREADRATE_8 -- 浮动利率点数
    ,P1.COEFFICIENT -- 浮动系数
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.SECTYPE END -- 债券类型代码
    ,P1.EFFECTFLAG -- 有效标志
    ,P1.CALLOPTION -- 可赎回标志
    ,P1.PUTOPTION -- 可回售标志
    ,P1.VATBREAKEVEN -- 保本标志
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||to_char(P1.INDUSTRY) END -- 发行人行业类型代码
    ,case when to_char(P1.CHECKTYPECODE) = ' ' then '-' when to_char(P1.CHECKTYPECODE) = 'AAA' then '-' else to_char(P1.CHECKTYPECODE) end -- 发行人行业分类代码
    ,P1.ISSUERSHORT -- 发行人名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_src_secinfo' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_src_secinfo p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.MARKET = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_SRC_SECINFO'
        AND R1.SRC_FIELD_EN_NAME= 'MARKET'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_BOND'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_MARKET_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.RATEBASIC = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_SRC_SECINFO'
        AND R3.SRC_FIELD_EN_NAME= 'RATEBASIC'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_BOND'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.COUPONSPECIES = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_SRC_SECINFO'
        AND R2.SRC_FIELD_EN_NAME= 'COUPONSPECIES'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_BOND'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'COUPON_BREED_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.INTERESTRATE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FAMS'
        AND R4.SRC_TAB_EN_NAME= 'FAMS_SRC_SECINFO'
        AND R4.SRC_FIELD_EN_NAME= 'INTERESTRATE'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_BOND'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.SECTYPE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'FAMS'
        AND R6.SRC_TAB_EN_NAME= 'FAMS_SRC_SECINFO'
        AND R6.SRC_FIELD_EN_NAME= 'SECTYPE'
        AND R6.TARGET_TAB_EN_NAME= 'PRD_BOND'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'BOND_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on to_char(P1.INDUSTRY) = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FAMS'
        AND R5.SRC_TAB_EN_NAME= 'FAMS_SRC_SECINFO'
        AND R5.SRC_FIELD_EN_NAME= 'INDUSTRY'
        AND R5.TARGET_TAB_EN_NAME= 'PRD_BOND'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'ISSUER_INDUS_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_bond_famsf1_tm 
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
insert /*+ append */ into ${iml_schema}.prd_bond_famsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,bond_name -- 债券名称
    ,bond_fname -- 债券全称
    ,bond_id -- 债券编号
    ,tran_market_cd -- 交易市场代码
    ,int_accr_base_cd -- 计息基准代码
    ,coupon_breed_cd -- 息票品种代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,pay_int_freq -- 付息频率
    ,fac_val -- 面值
    ,issue_price -- 发行价格
    ,fac_val_int_rat -- 票面利率
    ,issue_tot -- 发行总额
    ,int_assign_way_cd -- 利息分配方式代码
    ,pay_int_intrv_calcu_method_cd -- 付息区间推算方法代码
    ,fir_pay_int_dt -- 首次付息日期
    ,holiday_rule_cd -- 节假日规则代码
    ,hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,float_int_rat_point -- 浮动利率点数
    ,float_coef -- 浮动系数
    ,bond_type_cd -- 债券类型代码
    ,valid_flg -- 有效标志
    ,redembl_flg -- 可赎回标志
    ,putbl_flg -- 可回售标志
    ,brkevn_flg -- 保本标志
    ,issuer_indus_type_cd -- 发行人行业类型代码
    ,issuer_indus_cls_cd -- 发行人行业分类代码
    ,issuer_name -- 发行人名称
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
    ,nvl(n.bond_name, o.bond_name) as bond_name -- 债券名称
    ,nvl(n.bond_fname, o.bond_fname) as bond_fname -- 债券全称
    ,nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.tran_market_cd, o.tran_market_cd) as tran_market_cd -- 交易市场代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.coupon_breed_cd, o.coupon_breed_cd) as coupon_breed_cd -- 息票品种代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.pay_int_freq, o.pay_int_freq) as pay_int_freq -- 付息频率
    ,nvl(n.fac_val, o.fac_val) as fac_val -- 面值
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价格
    ,nvl(n.fac_val_int_rat, o.fac_val_int_rat) as fac_val_int_rat -- 票面利率
    ,nvl(n.issue_tot, o.issue_tot) as issue_tot -- 发行总额
    ,nvl(n.int_assign_way_cd, o.int_assign_way_cd) as int_assign_way_cd -- 利息分配方式代码
    ,nvl(n.pay_int_intrv_calcu_method_cd, o.pay_int_intrv_calcu_method_cd) as pay_int_intrv_calcu_method_cd -- 付息区间推算方法代码
    ,nvl(n.fir_pay_int_dt, o.fir_pay_int_dt) as fir_pay_int_dt -- 首次付息日期
    ,nvl(n.holiday_rule_cd, o.holiday_rule_cd) as holiday_rule_cd -- 节假日规则代码
    ,nvl(n.hook_float_int_rat_cd, o.hook_float_int_rat_cd) as hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,nvl(n.float_int_rat_point, o.float_int_rat_point) as float_int_rat_point -- 浮动利率点数
    ,nvl(n.float_coef, o.float_coef) as float_coef -- 浮动系数
    ,nvl(n.bond_type_cd, o.bond_type_cd) as bond_type_cd -- 债券类型代码
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.redembl_flg, o.redembl_flg) as redembl_flg -- 可赎回标志
    ,nvl(n.putbl_flg, o.putbl_flg) as putbl_flg -- 可回售标志
    ,nvl(n.brkevn_flg, o.brkevn_flg) as brkevn_flg -- 保本标志
    ,nvl(n.issuer_indus_type_cd, o.issuer_indus_type_cd) as issuer_indus_type_cd -- 发行人行业类型代码
    ,nvl(n.issuer_indus_cls_cd, o.issuer_indus_cls_cd) as issuer_indus_cls_cd -- 发行人行业分类代码
    ,nvl(n.issuer_name, o.issuer_name) as issuer_name -- 发行人名称
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.bond_name <> n.bond_name
                or o.bond_fname <> n.bond_fname
                or o.bond_id <> n.bond_id
                or o.tran_market_cd <> n.tran_market_cd
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.coupon_breed_cd <> n.coupon_breed_cd
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.pay_int_freq <> n.pay_int_freq
                or o.fac_val <> n.fac_val
                or o.issue_price <> n.issue_price
                or o.fac_val_int_rat <> n.fac_val_int_rat
                or o.issue_tot <> n.issue_tot
                or o.int_assign_way_cd <> n.int_assign_way_cd
                or o.pay_int_intrv_calcu_method_cd <> n.pay_int_intrv_calcu_method_cd
                or o.fir_pay_int_dt <> n.fir_pay_int_dt
                or o.holiday_rule_cd <> n.holiday_rule_cd
                or o.hook_float_int_rat_cd <> n.hook_float_int_rat_cd
                or o.float_int_rat_point <> n.float_int_rat_point
                or o.float_coef <> n.float_coef
                or o.bond_type_cd <> n.bond_type_cd
                or o.valid_flg <> n.valid_flg
                or o.redembl_flg <> n.redembl_flg
                or o.putbl_flg <> n.putbl_flg
                or o.brkevn_flg <> n.brkevn_flg
                or o.issuer_indus_type_cd <> n.issuer_indus_type_cd
                or o.issuer_indus_cls_cd <> n.issuer_indus_cls_cd
                or o.issuer_name <> n.issuer_name
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
from ${iml_schema}.prd_bond_famsf1_tm n
    full join ${iml_schema}.prd_bond_famsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_bond truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_bond exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.prd_bond_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_bond drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_bond to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_bond_famsf1_tm purge;
drop table ${iml_schema}.prd_bond_famsf1_ex purge;
drop table ${iml_schema}.prd_bond_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_bond', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);