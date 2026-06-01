/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_am_tran_class_fin_prod_famsi2
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
drop table ${iml_schema}.prd_am_tran_class_fin_prod_famsi2_tm purge;
alter table ${iml_schema}.prd_am_tran_class_fin_prod add partition p_famsi2 values ('famsi2')(
        subpartition p_famsi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_am_tran_class_fin_prod modify partition p_famsi2
    add subpartition p_famsi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_tran_class_fin_prod_famsi2_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,prod_cate_cd -- 产品类别代码
    ,prft_mode_cd -- 收益模式代码
    ,brch_type_cd -- 分支类型代码
    ,pass_id -- 通道编号
    ,nati_pric -- 名义本金
    ,pric_curr_cd -- 本金币种代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,tenor_days -- 期限天数
    ,int_rat_type_cd -- 利率类型代码
    ,fix_int_rat -- 固定利率
    ,float_int_rat_base_id -- 浮动利率基准编号
    ,int_accr_base_cd -- 计息基础代码
    ,exp_pric -- 到期本金
    ,exp_int -- 到期利息
    ,exp_amt -- 到期金额
    ,brkevn_flg -- 保本标志
    ,init_prod_id -- 原产品编号
    ,tran_site_cd -- 交易场所代码
    ,tran_caln_cd -- 交易日历代码
    ,tenor_breed_cd -- 期限品种代码
    ,cntpty_id -- 交易对手编号
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,exp_corp_net_price -- 到期单位净价
    ,exp_corp_int -- 到期单位利息
    ,exp_corp_full_price -- 到期单位全价
    ,exp_prft -- 到期收益
    ,exp_stl_way_cd -- 到期结算方式代码
    ,fst_dlvy_dt -- 首期交付日期
    ,exp_dlvy_dt -- 到期交付日期
    ,cont_id -- 合同编号
    ,actl_poses_acct_days -- 实际占款天数
    ,pd_id -- 期次编号
    ,cont_name -- 合同名称
    ,rgst_trust_org_cd -- 登记托管机构代码
    ,col_cnt -- 押品数
    ,attach_claus -- 补充条款
    ,provi_pnlt_flg -- 计提罚息标志
    ,pnlt_provi_base -- 罚息计提基数
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_tran_class_fin_prod
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fams_fin_trade_product-1
insert into ${iml_schema}.prd_am_tran_class_fin_prod_famsi2_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,prod_cate_cd -- 产品类别代码
    ,prft_mode_cd -- 收益模式代码
    ,brch_type_cd -- 分支类型代码
    ,pass_id -- 通道编号
    ,nati_pric -- 名义本金
    ,pric_curr_cd -- 本金币种代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,tenor_days -- 期限天数
    ,int_rat_type_cd -- 利率类型代码
    ,fix_int_rat -- 固定利率
    ,float_int_rat_base_id -- 浮动利率基准编号
    ,int_accr_base_cd -- 计息基础代码
    ,exp_pric -- 到期本金
    ,exp_int -- 到期利息
    ,exp_amt -- 到期金额
    ,brkevn_flg -- 保本标志
    ,init_prod_id -- 原产品编号
    ,tran_site_cd -- 交易场所代码
    ,tran_caln_cd -- 交易日历代码
    ,tenor_breed_cd -- 期限品种代码
    ,cntpty_id -- 交易对手编号
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,exp_corp_net_price -- 到期单位净价
    ,exp_corp_int -- 到期单位利息
    ,exp_corp_full_price -- 到期单位全价
    ,exp_prft -- 到期收益
    ,exp_stl_way_cd -- 到期结算方式代码
    ,fst_dlvy_dt -- 首期交付日期
    ,exp_dlvy_dt -- 到期交付日期
    ,cont_id -- 合同编号
    ,actl_poses_acct_days -- 实际占款天数
    ,pd_id -- 期次编号
    ,cont_name -- 合同名称
    ,rgst_trust_org_cd -- 登记托管机构代码
    ,col_cnt -- 押品数
    ,attach_claus -- 补充条款
    ,provi_pnlt_flg -- 计提罚息标志
    ,pnlt_provi_base -- 罚息计提基数
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    case when p1.finprod_type2 in ('F16','F24','F26') then '223002'||P1.FINPROD_ID else '223003'||P1.FINPROD_ID end -- 产品编号
    ,'9999' -- 法人编号
    ,p1.FINPROD_ID -- 金融产品编号
    ,p1.BRANCH -- 分支序号
    ,NVL(TRIM(P1.FINPROD_TYPE2),'-') -- 产品类别代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.PROFIT_TYPE END -- 收益模式代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||p1.BRANCH_TYPE END -- 分支类型代码
    ,p1.CHL_AGRT_ID -- 通道编号
    ,p1.PRIN -- 名义本金
    ,NVL(TRIM(P1.CCY),'-') -- 本金币种代码
    ,p1.VDATE -- 起息日期
    ,p1.MDATE -- 到期日期
    ,p1.TERM -- 期限天数
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||p1.INT_TYPE END -- 利率类型代码
    ,p1.INT_RATE -- 固定利率
    ,p1.INT_RATE_ID -- 浮动利率基准编号
    ,nvl(trim(p1.BASIS),'-') -- 计息基础代码
    ,p1.M_PRIN_AMT -- 到期本金
    ,p1.M_INT_AMT -- 到期利息
    ,p1.M_TRADE_AMT -- 到期金额
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||p1.CAPI_INCOME_FEATURE END -- 保本标志
    ,p1.O_FINPROD_ID -- 原产品编号
    ,NVL(TRIM(P1.TRADE_MARKET),'-') -- 交易场所代码
    ,NVL(TRIM(P1.CALENDAR_ID),'-') -- 交易日历代码
    ,p1.TERM_TYPE -- 期限品种代码
    ,p1.COUNTER_ID -- 交易对手编号
    ,p1.CREATE_TIME -- 创建时间
    ,p1.UPDATE_TIME -- 更新时间
    ,p1.M_UNIT_CPRICE -- 到期单位净价
    ,p1.M_UNIT_INT -- 到期单位利息
    ,p1.M_UNIT_FPRICE -- 到期单位全价
    ,p1.M_YIELD -- 到期收益
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||p1.M_DELIVERY_TYPE END -- 到期结算方式代码
    ,p1.VPAY_DATE -- 首期交付日期
    ,p1.MPAY_DATE -- 到期交付日期
    ,p1.CONTRACT_NO -- 合同编号
    ,p1.ACT_CAP_DAYS -- 实际占款天数
    ,p1.PERIOD_ID -- 期次编号
    ,p1.CONTRACT_NAME -- 合同名称
    ,p2.REGIST_ORG -- 登记托管机构代码
    ,p2.PLEDGE_SEC_NUM -- 押品数
    ,p2.SUPPLY_CLAUSE -- 补充条款
    ,p2.IS_ACCR_PENALTY_INT -- 计提罚息标志
    ,p2.PENALTY_BASE_TYPE -- 罚息计提基数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_fin_trade_product' -- 源表名称
    ,'famsi2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_trade_product p1
    left join ${iol_schema}.fams_fin_trade_product_add p2 on p1.FINPROD_ID=p2.FINPROD_ID 
   and p1.BRANCH=p2.BRANCH
   and p2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND p2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PROFIT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_FIN_TRADE_PRODUCT'
        AND R1.SRC_FIELD_EN_NAME= 'PROFIT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_AM_TRAN_CLASS_FIN_PROD'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PRFT_MODE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.BRANCH_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_FIN_TRADE_PRODUCT'
        AND R2.SRC_FIELD_EN_NAME= 'BRANCH_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_AM_TRAN_CLASS_FIN_PROD'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BRCH_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.INT_TYPE= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_FIN_TRADE_PRODUCT'
        AND R3.SRC_FIELD_EN_NAME= 'INT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_AM_TRAN_CLASS_FIN_PROD'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CAPI_INCOME_FEATURE= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FAMS'
        AND R5.SRC_TAB_EN_NAME= 'FAMS_FIN_TRADE_PRODUCT'
        AND R5.SRC_FIELD_EN_NAME= 'CAPI_INCOME_FEATURE'
        AND R5.TARGET_TAB_EN_NAME= 'PRD_AM_TRAN_CLASS_FIN_PROD'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'BRKEVN_FLG'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.M_DELIVERY_TYPE= R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'FAMS'
        AND R6.SRC_TAB_EN_NAME= 'FAMS_FIN_TRADE_PRODUCT'
        AND R6.SRC_FIELD_EN_NAME= 'M_DELIVERY_TYPE'
        AND R6.TARGET_TAB_EN_NAME= 'PRD_AM_TRAN_CLASS_FIN_PROD'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'EXP_STL_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and to_char(p1.UPDATE_TIME,'yyyymmdd')='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.prd_am_tran_class_fin_prod truncate subpartition p_famsi2_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.prd_am_tran_class_fin_prod exchange subpartition p_famsi2_${batch_date} with table ${iml_schema}.prd_am_tran_class_fin_prod_famsi2_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_am_tran_class_fin_prod to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_am_tran_class_fin_prod_famsi2_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_am_tran_class_fin_prod', partname => 'p_famsi2_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);