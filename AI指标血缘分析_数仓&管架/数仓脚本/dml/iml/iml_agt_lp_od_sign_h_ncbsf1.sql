/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lp_od_sign_h_ncbsf1
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
alter table ${iml_schema}.agt_lp_od_sign_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lp_od_sign_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,agt_status_cd -- 协议状态代码
    ,sign_agt_type_cd -- 签约协议类型代码
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,od_way_cd -- 透支方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,curr_cd -- 币种代码
    ,fee_rat -- 费率
    ,loan_acct_curr_cd -- 贷款账户币种代码
    ,loan_num -- 贷款号
    ,loan_acct_id -- 贷款账户编号
    ,loan_prod_id -- 贷款产品编号
    ,loan_acct_seq_num -- 贷款账户序号
    ,od_lmt -- 透支额度
    ,od_curr_cd -- 透支币种代码
    ,od_free_int_tenor -- 透支免息期限
    ,od_tenor -- 透支期限
    ,od_tenor_type_cd -- 透支期限类型代码
    ,start_od_amt -- 起透金额
    ,charge_day -- 收费日
    ,charge_freq_cd -- 收费频率代码
    ,fee_coll_way_cd -- 费用收取方式代码
    ,charge_ratio -- 收费比例
    ,file_acrs_mon_idf_cd -- 靠档跨月标识代码
    ,lp_od_exp_day_calc_rule_cd -- 法透到期日计算规则代码
    ,lp_od_repay_way_cd -- 法透还款方式代码
    ,need_amort_flg -- 需要摊销标志
    ,white_list_cust_info_remark -- 白名单客户信息备注
    ,remark -- 备注
    ,fee_prod_id -- 费用产品编号
    ,base_int_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,email_addr -- 邮箱地址
    ,file_int_accr_flg -- 靠档计息标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lp_od_sign_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lp_od_sign_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lp_od_sign_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_agreement_overdraft-1
insert into ${iml_schema}.agt_lp_od_sign_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,agt_status_cd -- 协议状态代码
    ,sign_agt_type_cd -- 签约协议类型代码
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,od_way_cd -- 透支方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,curr_cd -- 币种代码
    ,fee_rat -- 费率
    ,loan_acct_curr_cd -- 贷款账户币种代码
    ,loan_num -- 贷款号
    ,loan_acct_id -- 贷款账户编号
    ,loan_prod_id -- 贷款产品编号
    ,loan_acct_seq_num -- 贷款账户序号
    ,od_lmt -- 透支额度
    ,od_curr_cd -- 透支币种代码
    ,od_free_int_tenor -- 透支免息期限
    ,od_tenor -- 透支期限
    ,od_tenor_type_cd -- 透支期限类型代码
    ,start_od_amt -- 起透金额
    ,charge_day -- 收费日
    ,charge_freq_cd -- 收费频率代码
    ,fee_coll_way_cd -- 费用收取方式代码
    ,charge_ratio -- 收费比例
    ,file_acrs_mon_idf_cd -- 靠档跨月标识代码
    ,lp_od_exp_day_calc_rule_cd -- 法透到期日计算规则代码
    ,lp_od_repay_way_cd -- 法透还款方式代码
    ,need_amort_flg -- 需要摊销标志
    ,white_list_cust_info_remark -- 白名单客户信息备注
    ,remark -- 备注
    ,fee_prod_id -- 费用产品编号
    ,base_int_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,email_addr -- 邮箱地址
    ,file_int_accr_flg -- 靠档计息标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300003'||P1.AGREEMENT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.AGREEMENT_ID -- 源协议编号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.PROD_TYPE -- 产品编号
    ,nvl(trim(P1.AGREEMENT_STATUS),'-') -- 协议状态代码
    ,P1.AGREEMENT_TYPE -- 签约协议类型代码
    ,CASE WHEN TRIM(R1.TARGET_CD_VAL) IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.FEE_TAKEN_MODE END -- 手续费收取方式代码
    ,nvl(trim(P1.OD_METHOD),'-') -- 透支方式代码
    ,P1.START_DATE -- 生效日期
    ,P1.END_DATE -- 失效日期
    ,P1.ACCT_CCY -- 币种代码
    ,P1.FEE_RATE -- 费率
    ,P1.LOAN_ACCT_CCY -- 贷款账户币种代码
    ,nvl(trim(p9.card_no),p1.LOAN_BASE_ACCT_NO) -- 贷款号
    ,P1.LOAN_INTERNAL_KEY -- 贷款账户编号
    ,P1.LOAN_PROD_TYPE -- 贷款产品编号
    ,P1.LOAN_SEQ_NO -- 贷款账户序号
    ,P1.OD_AMT -- 透支额度
    ,P1.OD_CCY -- 透支币种代码
    ,nvl(trim(P1.OD_GRACE_PERIOD),0) -- 透支免息期限
    ,nvl(trim(P1.OD_TERM),0) -- 透支期限
    ,P1.OD_TERM_TYPE -- 透支期限类型代码
    ,P1.OD_START_AMT -- 起透金额
    ,P1.CHARGE_DAY -- 收费日
    ,nvl(trim(P1.CHARGE_PERIOD_FREQ),'-') -- 收费频率代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.FEE_CHARGE_TYPE END -- 费用收取方式代码
    ,P1.FEE_PERCENT -- 收费比例
    ,nvl(trim(P1.IS_OVER_MONTH_SEASON_OD),'-') -- 靠档跨月标识代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.OD_MATURITY_RULE END -- 法透到期日计算规则代码
    ,nvl(trim(P1.OD_PAY_METHOD),'-') -- 法透还款方式代码
    ,decode(P1.PROFIT_AMORTIZE_FLAG,'Y','1','N','0',' ','-',P1.PROFIT_AMORTIZE_FLAG) -- 需要摊销标志
    ,P1.WHITE_CLIENT_NAME -- 白名单客户信息备注
    ,P1.REMARK -- 备注
    ,P1.FEE_TYPE -- 费用产品编号
    ,P1.INT_BASIS_RATE -- 基准利率
    ,P1.REAL_RATE -- 执行利率
    ,P1.PAST_DUE_RATE -- 逾期利率
    ,P1.EMAIL_BOX -- 邮箱地址
    ,decode(P1.GEAR_PROD_FLAG,'Y','1','N','0',' ','-',P1.GEAR_PROD_FLAG) -- 靠档计息标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agreement_overdraft' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_overdraft p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p9 on p1.LOAN_BASE_ACCT_NO=p9.BASE_ACCT_NO and p9.BASE_ACCT_NO LIKE '0%'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.FEE_TAKEN_MODE=R1.SRC_CODE_VAL
           AND R1.SORC_SYS_CD= 'NCBS'
           AND R1.SRC_TAB_EN_NAME ='NCBS_RB_AGREEMENT_OVERDRAFT'
           AND R1.SRC_FIELD_EN_NAME ='FEE_TAKEN_MODE'
           AND R1.TARGET_TAB_EN_NAME='AGT_LP_OD_SIGN_H'
           AND R1.TARGET_TAB_FIELD_EN_NAME='COMM_FEE_COLL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.FEE_CHARGE_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NCBS'
        AND R2.SRC_TAB_EN_NAME= 'NCBS_RB_AGREEMENT_OVERDRAFT'
        AND R2.SRC_FIELD_EN_NAME= 'FEE_CHARGE_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_LP_OD_SIGN_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'FEE_COLL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.OD_MATURITY_RULE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NCBS'
        AND R3.SRC_TAB_EN_NAME= 'NCBS_RB_AGREEMENT_OVERDRAFT'
        AND R3.SRC_FIELD_EN_NAME= 'OD_MATURITY_RULE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_LP_OD_SIGN_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'LP_OD_EXP_DAY_CALC_RULE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lp_od_sign_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,src_agt_id
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
        into ${iml_schema}.agt_lp_od_sign_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,agt_status_cd -- 协议状态代码
    ,sign_agt_type_cd -- 签约协议类型代码
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,od_way_cd -- 透支方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,curr_cd -- 币种代码
    ,fee_rat -- 费率
    ,loan_acct_curr_cd -- 贷款账户币种代码
    ,loan_num -- 贷款号
    ,loan_acct_id -- 贷款账户编号
    ,loan_prod_id -- 贷款产品编号
    ,loan_acct_seq_num -- 贷款账户序号
    ,od_lmt -- 透支额度
    ,od_curr_cd -- 透支币种代码
    ,od_free_int_tenor -- 透支免息期限
    ,od_tenor -- 透支期限
    ,od_tenor_type_cd -- 透支期限类型代码
    ,start_od_amt -- 起透金额
    ,charge_day -- 收费日
    ,charge_freq_cd -- 收费频率代码
    ,fee_coll_way_cd -- 费用收取方式代码
    ,charge_ratio -- 收费比例
    ,file_acrs_mon_idf_cd -- 靠档跨月标识代码
    ,lp_od_exp_day_calc_rule_cd -- 法透到期日计算规则代码
    ,lp_od_repay_way_cd -- 法透还款方式代码
    ,need_amort_flg -- 需要摊销标志
    ,white_list_cust_info_remark -- 白名单客户信息备注
    ,remark -- 备注
    ,fee_prod_id -- 费用产品编号
    ,base_int_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,email_addr -- 邮箱地址
    ,file_int_accr_flg -- 靠档计息标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lp_od_sign_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,agt_status_cd -- 协议状态代码
    ,sign_agt_type_cd -- 签约协议类型代码
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,od_way_cd -- 透支方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,curr_cd -- 币种代码
    ,fee_rat -- 费率
    ,loan_acct_curr_cd -- 贷款账户币种代码
    ,loan_num -- 贷款号
    ,loan_acct_id -- 贷款账户编号
    ,loan_prod_id -- 贷款产品编号
    ,loan_acct_seq_num -- 贷款账户序号
    ,od_lmt -- 透支额度
    ,od_curr_cd -- 透支币种代码
    ,od_free_int_tenor -- 透支免息期限
    ,od_tenor -- 透支期限
    ,od_tenor_type_cd -- 透支期限类型代码
    ,start_od_amt -- 起透金额
    ,charge_day -- 收费日
    ,charge_freq_cd -- 收费频率代码
    ,fee_coll_way_cd -- 费用收取方式代码
    ,charge_ratio -- 收费比例
    ,file_acrs_mon_idf_cd -- 靠档跨月标识代码
    ,lp_od_exp_day_calc_rule_cd -- 法透到期日计算规则代码
    ,lp_od_repay_way_cd -- 法透还款方式代码
    ,need_amort_flg -- 需要摊销标志
    ,white_list_cust_info_remark -- 白名单客户信息备注
    ,remark -- 备注
    ,fee_prod_id -- 费用产品编号
    ,base_int_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,email_addr -- 邮箱地址
    ,file_int_accr_flg -- 靠档计息标志
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
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.agt_status_cd, o.agt_status_cd) as agt_status_cd -- 协议状态代码
    ,nvl(n.sign_agt_type_cd, o.sign_agt_type_cd) as sign_agt_type_cd -- 签约协议类型代码
    ,nvl(n.comm_fee_coll_way_cd, o.comm_fee_coll_way_cd) as comm_fee_coll_way_cd -- 手续费收取方式代码
    ,nvl(n.od_way_cd, o.od_way_cd) as od_way_cd -- 透支方式代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.fee_rat, o.fee_rat) as fee_rat -- 费率
    ,nvl(n.loan_acct_curr_cd, o.loan_acct_curr_cd) as loan_acct_curr_cd -- 贷款账户币种代码
    ,nvl(n.loan_num, o.loan_num) as loan_num -- 贷款号
    ,nvl(n.loan_acct_id, o.loan_acct_id) as loan_acct_id -- 贷款账户编号
    ,nvl(n.loan_prod_id, o.loan_prod_id) as loan_prod_id -- 贷款产品编号
    ,nvl(n.loan_acct_seq_num, o.loan_acct_seq_num) as loan_acct_seq_num -- 贷款账户序号
    ,nvl(n.od_lmt, o.od_lmt) as od_lmt -- 透支额度
    ,nvl(n.od_curr_cd, o.od_curr_cd) as od_curr_cd -- 透支币种代码
    ,nvl(n.od_free_int_tenor, o.od_free_int_tenor) as od_free_int_tenor -- 透支免息期限
    ,nvl(n.od_tenor, o.od_tenor) as od_tenor -- 透支期限
    ,nvl(n.od_tenor_type_cd, o.od_tenor_type_cd) as od_tenor_type_cd -- 透支期限类型代码
    ,nvl(n.start_od_amt, o.start_od_amt) as start_od_amt -- 起透金额
    ,nvl(n.charge_day, o.charge_day) as charge_day -- 收费日
    ,nvl(n.charge_freq_cd, o.charge_freq_cd) as charge_freq_cd -- 收费频率代码
    ,nvl(n.fee_coll_way_cd, o.fee_coll_way_cd) as fee_coll_way_cd -- 费用收取方式代码
    ,nvl(n.charge_ratio, o.charge_ratio) as charge_ratio -- 收费比例
    ,nvl(n.file_acrs_mon_idf_cd, o.file_acrs_mon_idf_cd) as file_acrs_mon_idf_cd -- 靠档跨月标识代码
    ,nvl(n.lp_od_exp_day_calc_rule_cd, o.lp_od_exp_day_calc_rule_cd) as lp_od_exp_day_calc_rule_cd -- 法透到期日计算规则代码
    ,nvl(n.lp_od_repay_way_cd, o.lp_od_repay_way_cd) as lp_od_repay_way_cd -- 法透还款方式代码
    ,nvl(n.need_amort_flg, o.need_amort_flg) as need_amort_flg -- 需要摊销标志
    ,nvl(n.white_list_cust_info_remark, o.white_list_cust_info_remark) as white_list_cust_info_remark -- 白名单客户信息备注
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.fee_prod_id, o.fee_prod_id) as fee_prod_id -- 费用产品编号
    ,nvl(n.base_int_rat, o.base_int_rat) as base_int_rat -- 基准利率
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.ovdue_int_rat, o.ovdue_int_rat) as ovdue_int_rat -- 逾期利率
    ,nvl(n.email_addr, o.email_addr) as email_addr -- 邮箱地址
    ,nvl(n.file_int_accr_flg, o.file_int_accr_flg) as file_int_accr_flg -- 靠档计息标志
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_agt_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_agt_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_agt_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lp_od_sign_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_lp_od_sign_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.src_agt_id = n.src_agt_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.src_agt_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.src_agt_id is null
    )
    or (
        o.sub_acct_num <> n.sub_acct_num
        or o.cust_acct_num <> n.cust_acct_num
        or o.cust_id <> n.cust_id
        or o.prod_id <> n.prod_id
        or o.agt_status_cd <> n.agt_status_cd
        or o.sign_agt_type_cd <> n.sign_agt_type_cd
        or o.comm_fee_coll_way_cd <> n.comm_fee_coll_way_cd
        or o.od_way_cd <> n.od_way_cd
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.curr_cd <> n.curr_cd
        or o.fee_rat <> n.fee_rat
        or o.loan_acct_curr_cd <> n.loan_acct_curr_cd
        or o.loan_num <> n.loan_num
        or o.loan_acct_id <> n.loan_acct_id
        or o.loan_prod_id <> n.loan_prod_id
        or o.loan_acct_seq_num <> n.loan_acct_seq_num
        or o.od_lmt <> n.od_lmt
        or o.od_curr_cd <> n.od_curr_cd
        or o.od_free_int_tenor <> n.od_free_int_tenor
        or o.od_tenor <> n.od_tenor
        or o.od_tenor_type_cd <> n.od_tenor_type_cd
        or o.start_od_amt <> n.start_od_amt
        or o.charge_day <> n.charge_day
        or o.charge_freq_cd <> n.charge_freq_cd
        or o.fee_coll_way_cd <> n.fee_coll_way_cd
        or o.charge_ratio <> n.charge_ratio
        or o.file_acrs_mon_idf_cd <> n.file_acrs_mon_idf_cd
        or o.lp_od_exp_day_calc_rule_cd <> n.lp_od_exp_day_calc_rule_cd
        or o.lp_od_repay_way_cd <> n.lp_od_repay_way_cd
        or o.need_amort_flg <> n.need_amort_flg
        or o.white_list_cust_info_remark <> n.white_list_cust_info_remark
        or o.remark <> n.remark
        or o.fee_prod_id <> n.fee_prod_id
        or o.base_int_rat <> n.base_int_rat
        or o.exec_int_rat <> n.exec_int_rat
        or o.ovdue_int_rat <> n.ovdue_int_rat
        or o.email_addr <> n.email_addr
        or o.file_int_accr_flg <> n.file_int_accr_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lp_od_sign_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,agt_status_cd -- 协议状态代码
    ,sign_agt_type_cd -- 签约协议类型代码
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,od_way_cd -- 透支方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,curr_cd -- 币种代码
    ,fee_rat -- 费率
    ,loan_acct_curr_cd -- 贷款账户币种代码
    ,loan_num -- 贷款号
    ,loan_acct_id -- 贷款账户编号
    ,loan_prod_id -- 贷款产品编号
    ,loan_acct_seq_num -- 贷款账户序号
    ,od_lmt -- 透支额度
    ,od_curr_cd -- 透支币种代码
    ,od_free_int_tenor -- 透支免息期限
    ,od_tenor -- 透支期限
    ,od_tenor_type_cd -- 透支期限类型代码
    ,start_od_amt -- 起透金额
    ,charge_day -- 收费日
    ,charge_freq_cd -- 收费频率代码
    ,fee_coll_way_cd -- 费用收取方式代码
    ,charge_ratio -- 收费比例
    ,file_acrs_mon_idf_cd -- 靠档跨月标识代码
    ,lp_od_exp_day_calc_rule_cd -- 法透到期日计算规则代码
    ,lp_od_repay_way_cd -- 法透还款方式代码
    ,need_amort_flg -- 需要摊销标志
    ,white_list_cust_info_remark -- 白名单客户信息备注
    ,remark -- 备注
    ,fee_prod_id -- 费用产品编号
    ,base_int_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,email_addr -- 邮箱地址
    ,file_int_accr_flg -- 靠档计息标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lp_od_sign_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,agt_status_cd -- 协议状态代码
    ,sign_agt_type_cd -- 签约协议类型代码
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,od_way_cd -- 透支方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,curr_cd -- 币种代码
    ,fee_rat -- 费率
    ,loan_acct_curr_cd -- 贷款账户币种代码
    ,loan_num -- 贷款号
    ,loan_acct_id -- 贷款账户编号
    ,loan_prod_id -- 贷款产品编号
    ,loan_acct_seq_num -- 贷款账户序号
    ,od_lmt -- 透支额度
    ,od_curr_cd -- 透支币种代码
    ,od_free_int_tenor -- 透支免息期限
    ,od_tenor -- 透支期限
    ,od_tenor_type_cd -- 透支期限类型代码
    ,start_od_amt -- 起透金额
    ,charge_day -- 收费日
    ,charge_freq_cd -- 收费频率代码
    ,fee_coll_way_cd -- 费用收取方式代码
    ,charge_ratio -- 收费比例
    ,file_acrs_mon_idf_cd -- 靠档跨月标识代码
    ,lp_od_exp_day_calc_rule_cd -- 法透到期日计算规则代码
    ,lp_od_repay_way_cd -- 法透还款方式代码
    ,need_amort_flg -- 需要摊销标志
    ,white_list_cust_info_remark -- 白名单客户信息备注
    ,remark -- 备注
    ,fee_prod_id -- 费用产品编号
    ,base_int_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,email_addr -- 邮箱地址
    ,file_int_accr_flg -- 靠档计息标志
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
    ,o.src_agt_id -- 源协议编号
    ,o.sub_acct_num -- 子账号
    ,o.cust_acct_num -- 客户账号
    ,o.cust_id -- 客户编号
    ,o.prod_id -- 产品编号
    ,o.agt_status_cd -- 协议状态代码
    ,o.sign_agt_type_cd -- 签约协议类型代码
    ,o.comm_fee_coll_way_cd -- 手续费收取方式代码
    ,o.od_way_cd -- 透支方式代码
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.curr_cd -- 币种代码
    ,o.fee_rat -- 费率
    ,o.loan_acct_curr_cd -- 贷款账户币种代码
    ,o.loan_num -- 贷款号
    ,o.loan_acct_id -- 贷款账户编号
    ,o.loan_prod_id -- 贷款产品编号
    ,o.loan_acct_seq_num -- 贷款账户序号
    ,o.od_lmt -- 透支额度
    ,o.od_curr_cd -- 透支币种代码
    ,o.od_free_int_tenor -- 透支免息期限
    ,o.od_tenor -- 透支期限
    ,o.od_tenor_type_cd -- 透支期限类型代码
    ,o.start_od_amt -- 起透金额
    ,o.charge_day -- 收费日
    ,o.charge_freq_cd -- 收费频率代码
    ,o.fee_coll_way_cd -- 费用收取方式代码
    ,o.charge_ratio -- 收费比例
    ,o.file_acrs_mon_idf_cd -- 靠档跨月标识代码
    ,o.lp_od_exp_day_calc_rule_cd -- 法透到期日计算规则代码
    ,o.lp_od_repay_way_cd -- 法透还款方式代码
    ,o.need_amort_flg -- 需要摊销标志
    ,o.white_list_cust_info_remark -- 白名单客户信息备注
    ,o.remark -- 备注
    ,o.fee_prod_id -- 费用产品编号
    ,o.base_int_rat -- 基准利率
    ,o.exec_int_rat -- 执行利率
    ,o.ovdue_int_rat -- 逾期利率
    ,o.email_addr -- 邮箱地址
    ,o.file_int_accr_flg -- 靠档计息标志
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
from ${iml_schema}.agt_lp_od_sign_h_ncbsf1_bk o
    left join ${iml_schema}.agt_lp_od_sign_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.src_agt_id = n.src_agt_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lp_od_sign_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.src_agt_id = d.src_agt_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lp_od_sign_h;
--alter table ${iml_schema}.agt_lp_od_sign_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lp_od_sign_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lp_od_sign_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lp_od_sign_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lp_od_sign_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_cl;
alter table ${iml_schema}.agt_lp_od_sign_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lp_od_sign_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lp_od_sign_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lp_od_sign_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
