/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_auto_redt_agt_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_acct_auto_redt_agt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_auto_redt_agt_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,seq_num -- 序号
    ,plan_id -- 计划编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_name -- 账户名称
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,lowt_redt_amt -- 最低转存金额
    ,redt_by_agt_way_cd -- 约定转存方式代码
    ,redt_mode_cd -- 转存方式代码
    ,tran_acct_mult -- 转账倍数
    ,tran_amt -- 交易金额
    ,bal_ratio -- 余额比例
    ,acm_tran_acct_amt -- 累计转账金额
    ,tran_acct_base -- 转账基数
    ,mini_guart_amt -- 保底金额
    ,redt_acct_type_cd -- 转存账户类型代码
    ,finc_fix_amt -- 理财固定金额
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_prod_id -- 对手账户产品编号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_acct_sub_acct_num -- 对手账户子账号
    ,cntpty_bank_no -- 对手银行行号
    ,cntpty_acct_name -- 对手账户名称
    ,cntpty_acct_type_cd -- 对手账户类型代码
    ,pric_int_enter_sub_acct_num -- 本息入账账户子账号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_prod_id -- 结算账户产品编号
    ,loan_rs_cd -- 贷款原因代码
    ,prior_level -- 优先等级
    ,acm_track_cnt -- 累计追踪次数
    ,acm_tran_acct_cnt -- 累计转账次数
    ,subtn_tran_cnt -- 持续划款次数
    ,tran_teller_id -- 交易柜员编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,auto_payoff_flg -- 自动结清标志
    ,open_cnt_type_cd -- 开立笔数类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_auto_redt_agt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_auto_redt_agt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_auto_redt_agt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_agreement_sweep
insert into ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,seq_num -- 序号
    ,plan_id -- 计划编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_name -- 账户名称
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,lowt_redt_amt -- 最低转存金额
    ,redt_by_agt_way_cd -- 约定转存方式代码
    ,redt_mode_cd -- 转存方式代码
    ,tran_acct_mult -- 转账倍数
    ,tran_amt -- 交易金额
    ,bal_ratio -- 余额比例
    ,acm_tran_acct_amt -- 累计转账金额
    ,tran_acct_base -- 转账基数
    ,mini_guart_amt -- 保底金额
    ,redt_acct_type_cd -- 转存账户类型代码
    ,finc_fix_amt -- 理财固定金额
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_prod_id -- 对手账户产品编号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_acct_sub_acct_num -- 对手账户子账号
    ,cntpty_bank_no -- 对手银行行号
    ,cntpty_acct_name -- 对手账户名称
    ,cntpty_acct_type_cd -- 对手账户类型代码
    ,pric_int_enter_sub_acct_num -- 本息入账账户子账号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_prod_id -- 结算账户产品编号
    ,loan_rs_cd -- 贷款原因代码
    ,prior_level -- 优先等级
    ,acm_track_cnt -- 累计追踪次数
    ,acm_tran_acct_cnt -- 累计转账次数
    ,subtn_tran_cnt -- 持续划款次数
    ,tran_teller_id -- 交易柜员编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,auto_payoff_flg -- 自动结清标志
    ,open_cnt_type_cd -- 开立笔数类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300003'||P1.AGREEMENT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.AGREEMENT_ID -- 存款协议编号
    ,P1.SEQ_NO -- 序号
    ,P1.SCHED_NO -- 计划编号
    ,P1.AGREEMENT_TYPE -- 签约协议类型代码
    ,P1.AGREEMENT_STATUS -- 签约协议状态代码
    ,P1.INTERNAL_KEY -- 账户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.PROD_TYPE -- 账户产品编号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 账户子账号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.ACCT_FIXED_RATE -- 分户级固定利率
    ,P1.ACCT_PERCENT_RATE -- 分户级利率浮动比例
    ,P1.ACCT_SPREAD_RATE -- 分户级利率浮动点数
    ,P1.TERM -- 存期期限
    ,nvl(trim(P1.TERM_TYPE),'-') -- 期限类型代码
    ,P1.RENEW_MIN_AMT -- 最低转存金额
    ,nvl(trim(P1.RENEW_TYPE),'-') -- 约定转存方式代码
    ,nvl(trim(P1.RENEW_METHOD),'-') -- 转存方式代码
    ,P1.RENEW_MULTIPLE -- 转账倍数
    ,P1.TRAN_AMT -- 交易金额
    ,P1.BAL_RATIO -- 余额比例
    ,P1.SUM_AMT -- 累计转账金额
    ,P1.TRAN_BASE_AMT -- 转账基数
    ,P1.LOWEST_AMT -- 保底金额
    ,nvl(trim(P1.RENEW_ACCT_TYPE),'-') -- 转存账户类型代码
    ,P1.FIN_FIXED_AMT -- 理财固定金额
    ,P1.OTH_INTERNAL_KEY -- 对手账户编号
    ,nvl(trim(p9.card_no),p1.OTH_BASE_ACCT_NO) -- 对手客户账号
    ,P1.OTH_PROD_TYPE -- 对手账户产品编号
    ,nvl(trim(P1.OTH_ACCT_CCY),'-') -- 对手账户币种代码
    ,P1.OTH_ACCT_SEQ_NO -- 对手账户子账号
    ,P1.OTH_BANK_CODE -- 对手银行行号
    ,P1.OTH_ACCT_DESC -- 对手账户名称
    ,nvl(trim(P1.OTH_ACCT_SORT),'-') -- 对手账户类型代码
    ,P1.PRIINT_ACCT_SEQ_NO -- 本息入账账户子账号
    ,nvl(trim(p10.card_no),p1.PRIINT_BASE_ACCT_NO) -- 本息入账客户账号
    ,nvl(trim(P1.PRIINT_CCY),'-') -- 本息入账账户币种代码
    ,P1.PRIINT_PROD_TYPE -- 本息入账账户产品编号
    ,nvl(trim(P1.SETTLE_ACCT_CCY),'-') -- 结算账户币种代码
    ,P1.SETTLE_ACCT_SEQ_NO -- 结算账户子账号
    ,nvl(trim(p11.card_no),p1.SETTLE_BASE_ACCT_NO) -- 结算客户账号
    ,P1.SETTLE_PROD_TYPE -- 结算账户产品编号
    ,nvl(trim(P1.REASON_CODE),'-') -- 贷款原因代码
    ,P1.PRIORITY -- 优先等级
    ,P1.SUM_CON_COUNT -- 累计追踪次数
    ,P1.SUM_COUNT -- 累计转账次数
    ,P1.CON_TRANSFER_COUNT -- 持续划款次数
    ,P1.USER_ID -- 交易柜员编号
    ,P1.SIGN_DATE -- 签约日期
    ,P1.START_DATE -- 生效日期
    ,P1.END_DATE -- 失效日期
    ,DECODE(P1.AUTO_SETTLE_FLAG,'Y','1','N','0') -- 自动结清标志
    ,nvl(trim(P1.OPEN_NUM_TYPE),'-') -- 开立笔数类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agreement_sweep' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_sweep p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p9 on p1.OTH_BASE_ACCT_NO=p9.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'and p9.BASE_ACCT_NO LIKE '0%'
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p10 on p1.PRIINT_BASE_ACCT_NO=p10.BASE_ACCT_NO and p10.BASE_ACCT_NO LIKE '0%'
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p11 on p1.SETTLE_BASE_ACCT_NO=p11.BASE_ACCT_NO and p11.BASE_ACCT_NO LIKE '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dep_agt_id
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
        into ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,seq_num -- 序号
    ,plan_id -- 计划编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_name -- 账户名称
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,lowt_redt_amt -- 最低转存金额
    ,redt_by_agt_way_cd -- 约定转存方式代码
    ,redt_mode_cd -- 转存方式代码
    ,tran_acct_mult -- 转账倍数
    ,tran_amt -- 交易金额
    ,bal_ratio -- 余额比例
    ,acm_tran_acct_amt -- 累计转账金额
    ,tran_acct_base -- 转账基数
    ,mini_guart_amt -- 保底金额
    ,redt_acct_type_cd -- 转存账户类型代码
    ,finc_fix_amt -- 理财固定金额
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_prod_id -- 对手账户产品编号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_acct_sub_acct_num -- 对手账户子账号
    ,cntpty_bank_no -- 对手银行行号
    ,cntpty_acct_name -- 对手账户名称
    ,cntpty_acct_type_cd -- 对手账户类型代码
    ,pric_int_enter_sub_acct_num -- 本息入账账户子账号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_prod_id -- 结算账户产品编号
    ,loan_rs_cd -- 贷款原因代码
    ,prior_level -- 优先等级
    ,acm_track_cnt -- 累计追踪次数
    ,acm_tran_acct_cnt -- 累计转账次数
    ,subtn_tran_cnt -- 持续划款次数
    ,tran_teller_id -- 交易柜员编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,auto_payoff_flg -- 自动结清标志
    ,open_cnt_type_cd -- 开立笔数类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,seq_num -- 序号
    ,plan_id -- 计划编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_name -- 账户名称
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,lowt_redt_amt -- 最低转存金额
    ,redt_by_agt_way_cd -- 约定转存方式代码
    ,redt_mode_cd -- 转存方式代码
    ,tran_acct_mult -- 转账倍数
    ,tran_amt -- 交易金额
    ,bal_ratio -- 余额比例
    ,acm_tran_acct_amt -- 累计转账金额
    ,tran_acct_base -- 转账基数
    ,mini_guart_amt -- 保底金额
    ,redt_acct_type_cd -- 转存账户类型代码
    ,finc_fix_amt -- 理财固定金额
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_prod_id -- 对手账户产品编号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_acct_sub_acct_num -- 对手账户子账号
    ,cntpty_bank_no -- 对手银行行号
    ,cntpty_acct_name -- 对手账户名称
    ,cntpty_acct_type_cd -- 对手账户类型代码
    ,pric_int_enter_sub_acct_num -- 本息入账账户子账号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_prod_id -- 结算账户产品编号
    ,loan_rs_cd -- 贷款原因代码
    ,prior_level -- 优先等级
    ,acm_track_cnt -- 累计追踪次数
    ,acm_tran_acct_cnt -- 累计转账次数
    ,subtn_tran_cnt -- 持续划款次数
    ,tran_teller_id -- 交易柜员编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,auto_payoff_flg -- 自动结清标志
    ,open_cnt_type_cd -- 开立笔数类型代码
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
    ,nvl(n.dep_agt_id, o.dep_agt_id) as dep_agt_id -- 存款协议编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.plan_id, o.plan_id) as plan_id -- 计划编号
    ,nvl(n.sign_agt_type_cd, o.sign_agt_type_cd) as sign_agt_type_cd -- 签约协议类型代码
    ,nvl(n.sign_agt_status_cd, o.sign_agt_status_cd) as sign_agt_status_cd -- 签约协议状态代码
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_prod_id, o.acct_prod_id) as acct_prod_id -- 账户产品编号
    ,nvl(n.acct_curr_cd, o.acct_curr_cd) as acct_curr_cd -- 账户币种代码
    ,nvl(n.acct_sub_acct_num, o.acct_sub_acct_num) as acct_sub_acct_num -- 账户子账号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.sub_acct_fix_int_rat, o.sub_acct_fix_int_rat) as sub_acct_fix_int_rat -- 分户级固定利率
    ,nvl(n.sub_acct_int_rat_float_ratio, o.sub_acct_int_rat_float_ratio) as sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,nvl(n.sub_acct_int_rat_float_point, o.sub_acct_int_rat_float_point) as sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,nvl(n.dep_term_tenor, o.dep_term_tenor) as dep_term_tenor -- 存期期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.lowt_redt_amt, o.lowt_redt_amt) as lowt_redt_amt -- 最低转存金额
    ,nvl(n.redt_by_agt_way_cd, o.redt_by_agt_way_cd) as redt_by_agt_way_cd -- 约定转存方式代码
    ,nvl(n.redt_mode_cd, o.redt_mode_cd) as redt_mode_cd -- 转存方式代码
    ,nvl(n.tran_acct_mult, o.tran_acct_mult) as tran_acct_mult -- 转账倍数
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.bal_ratio, o.bal_ratio) as bal_ratio -- 余额比例
    ,nvl(n.acm_tran_acct_amt, o.acm_tran_acct_amt) as acm_tran_acct_amt -- 累计转账金额
    ,nvl(n.tran_acct_base, o.tran_acct_base) as tran_acct_base -- 转账基数
    ,nvl(n.mini_guart_amt, o.mini_guart_amt) as mini_guart_amt -- 保底金额
    ,nvl(n.redt_acct_type_cd, o.redt_acct_type_cd) as redt_acct_type_cd -- 转存账户类型代码
    ,nvl(n.finc_fix_amt, o.finc_fix_amt) as finc_fix_amt -- 理财固定金额
    ,nvl(n.cntpty_acct_id, o.cntpty_acct_id) as cntpty_acct_id -- 对手账户编号
    ,nvl(n.cntpty_cust_acct_num, o.cntpty_cust_acct_num) as cntpty_cust_acct_num -- 对手客户账号
    ,nvl(n.cntpty_acct_prod_id, o.cntpty_acct_prod_id) as cntpty_acct_prod_id -- 对手账户产品编号
    ,nvl(n.cntpty_acct_curr_cd, o.cntpty_acct_curr_cd) as cntpty_acct_curr_cd -- 对手账户币种代码
    ,nvl(n.cntpty_acct_sub_acct_num, o.cntpty_acct_sub_acct_num) as cntpty_acct_sub_acct_num -- 对手账户子账号
    ,nvl(n.cntpty_bank_no, o.cntpty_bank_no) as cntpty_bank_no -- 对手银行行号
    ,nvl(n.cntpty_acct_name, o.cntpty_acct_name) as cntpty_acct_name -- 对手账户名称
    ,nvl(n.cntpty_acct_type_cd, o.cntpty_acct_type_cd) as cntpty_acct_type_cd -- 对手账户类型代码
    ,nvl(n.pric_int_enter_sub_acct_num, o.pric_int_enter_sub_acct_num) as pric_int_enter_sub_acct_num -- 本息入账账户子账号
    ,nvl(n.pric_int_enter_acct_cust_acct_num, o.pric_int_enter_acct_cust_acct_num) as pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,nvl(n.pric_int_enter_curr_cd, o.pric_int_enter_curr_cd) as pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,nvl(n.pric_int_enter_prod_id, o.pric_int_enter_prod_id) as pric_int_enter_prod_id -- 本息入账账户产品编号
    ,nvl(n.stl_acct_curr_cd, o.stl_acct_curr_cd) as stl_acct_curr_cd -- 结算账户币种代码
    ,nvl(n.stl_acct_sub_acct_num, o.stl_acct_sub_acct_num) as stl_acct_sub_acct_num -- 结算账户子账号
    ,nvl(n.stl_cust_acct_num, o.stl_cust_acct_num) as stl_cust_acct_num -- 结算客户账号
    ,nvl(n.stl_acct_prod_id, o.stl_acct_prod_id) as stl_acct_prod_id -- 结算账户产品编号
    ,nvl(n.loan_rs_cd, o.loan_rs_cd) as loan_rs_cd -- 贷款原因代码
    ,nvl(n.prior_level, o.prior_level) as prior_level -- 优先等级
    ,nvl(n.acm_track_cnt, o.acm_track_cnt) as acm_track_cnt -- 累计追踪次数
    ,nvl(n.acm_tran_acct_cnt, o.acm_tran_acct_cnt) as acm_tran_acct_cnt -- 累计转账次数
    ,nvl(n.subtn_tran_cnt, o.subtn_tran_cnt) as subtn_tran_cnt -- 持续划款次数
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.auto_payoff_flg, o.auto_payoff_flg) as auto_payoff_flg -- 自动结清标志
    ,nvl(n.open_cnt_type_cd, o.open_cnt_type_cd) as open_cnt_type_cd -- 开立笔数类型代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dep_agt_id = n.dep_agt_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dep_agt_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dep_agt_id is null
    )
    or (
        o.seq_num <> n.seq_num
        or o.plan_id <> n.plan_id
        or o.sign_agt_type_cd <> n.sign_agt_type_cd
        or o.sign_agt_status_cd <> n.sign_agt_status_cd
        or o.acct_id <> n.acct_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.cust_id <> n.cust_id
        or o.acct_prod_id <> n.acct_prod_id
        or o.acct_curr_cd <> n.acct_curr_cd
        or o.acct_sub_acct_num <> n.acct_sub_acct_num
        or o.acct_name <> n.acct_name
        or o.sub_acct_fix_int_rat <> n.sub_acct_fix_int_rat
        or o.sub_acct_int_rat_float_ratio <> n.sub_acct_int_rat_float_ratio
        or o.sub_acct_int_rat_float_point <> n.sub_acct_int_rat_float_point
        or o.dep_term_tenor <> n.dep_term_tenor
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.lowt_redt_amt <> n.lowt_redt_amt
        or o.redt_by_agt_way_cd <> n.redt_by_agt_way_cd
        or o.redt_mode_cd <> n.redt_mode_cd
        or o.tran_acct_mult <> n.tran_acct_mult
        or o.tran_amt <> n.tran_amt
        or o.bal_ratio <> n.bal_ratio
        or o.acm_tran_acct_amt <> n.acm_tran_acct_amt
        or o.tran_acct_base <> n.tran_acct_base
        or o.mini_guart_amt <> n.mini_guart_amt
        or o.redt_acct_type_cd <> n.redt_acct_type_cd
        or o.finc_fix_amt <> n.finc_fix_amt
        or o.cntpty_acct_id <> n.cntpty_acct_id
        or o.cntpty_cust_acct_num <> n.cntpty_cust_acct_num
        or o.cntpty_acct_prod_id <> n.cntpty_acct_prod_id
        or o.cntpty_acct_curr_cd <> n.cntpty_acct_curr_cd
        or o.cntpty_acct_sub_acct_num <> n.cntpty_acct_sub_acct_num
        or o.cntpty_bank_no <> n.cntpty_bank_no
        or o.cntpty_acct_name <> n.cntpty_acct_name
        or o.cntpty_acct_type_cd <> n.cntpty_acct_type_cd
        or o.pric_int_enter_sub_acct_num <> n.pric_int_enter_sub_acct_num
        or o.pric_int_enter_acct_cust_acct_num <> n.pric_int_enter_acct_cust_acct_num
        or o.pric_int_enter_curr_cd <> n.pric_int_enter_curr_cd
        or o.pric_int_enter_prod_id <> n.pric_int_enter_prod_id
        or o.stl_acct_curr_cd <> n.stl_acct_curr_cd
        or o.stl_acct_sub_acct_num <> n.stl_acct_sub_acct_num
        or o.stl_cust_acct_num <> n.stl_cust_acct_num
        or o.stl_acct_prod_id <> n.stl_acct_prod_id
        or o.loan_rs_cd <> n.loan_rs_cd
        or o.prior_level <> n.prior_level
        or o.acm_track_cnt <> n.acm_track_cnt
        or o.acm_tran_acct_cnt <> n.acm_tran_acct_cnt
        or o.subtn_tran_cnt <> n.subtn_tran_cnt
        or o.tran_teller_id <> n.tran_teller_id
        or o.sign_dt <> n.sign_dt
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.auto_payoff_flg <> n.auto_payoff_flg
        or o.open_cnt_type_cd <> n.open_cnt_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,seq_num -- 序号
    ,plan_id -- 计划编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_name -- 账户名称
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,lowt_redt_amt -- 最低转存金额
    ,redt_by_agt_way_cd -- 约定转存方式代码
    ,redt_mode_cd -- 转存方式代码
    ,tran_acct_mult -- 转账倍数
    ,tran_amt -- 交易金额
    ,bal_ratio -- 余额比例
    ,acm_tran_acct_amt -- 累计转账金额
    ,tran_acct_base -- 转账基数
    ,mini_guart_amt -- 保底金额
    ,redt_acct_type_cd -- 转存账户类型代码
    ,finc_fix_amt -- 理财固定金额
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_prod_id -- 对手账户产品编号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_acct_sub_acct_num -- 对手账户子账号
    ,cntpty_bank_no -- 对手银行行号
    ,cntpty_acct_name -- 对手账户名称
    ,cntpty_acct_type_cd -- 对手账户类型代码
    ,pric_int_enter_sub_acct_num -- 本息入账账户子账号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_prod_id -- 结算账户产品编号
    ,loan_rs_cd -- 贷款原因代码
    ,prior_level -- 优先等级
    ,acm_track_cnt -- 累计追踪次数
    ,acm_tran_acct_cnt -- 累计转账次数
    ,subtn_tran_cnt -- 持续划款次数
    ,tran_teller_id -- 交易柜员编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,auto_payoff_flg -- 自动结清标志
    ,open_cnt_type_cd -- 开立笔数类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,seq_num -- 序号
    ,plan_id -- 计划编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_name -- 账户名称
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,lowt_redt_amt -- 最低转存金额
    ,redt_by_agt_way_cd -- 约定转存方式代码
    ,redt_mode_cd -- 转存方式代码
    ,tran_acct_mult -- 转账倍数
    ,tran_amt -- 交易金额
    ,bal_ratio -- 余额比例
    ,acm_tran_acct_amt -- 累计转账金额
    ,tran_acct_base -- 转账基数
    ,mini_guart_amt -- 保底金额
    ,redt_acct_type_cd -- 转存账户类型代码
    ,finc_fix_amt -- 理财固定金额
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_prod_id -- 对手账户产品编号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_acct_sub_acct_num -- 对手账户子账号
    ,cntpty_bank_no -- 对手银行行号
    ,cntpty_acct_name -- 对手账户名称
    ,cntpty_acct_type_cd -- 对手账户类型代码
    ,pric_int_enter_sub_acct_num -- 本息入账账户子账号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_prod_id -- 结算账户产品编号
    ,loan_rs_cd -- 贷款原因代码
    ,prior_level -- 优先等级
    ,acm_track_cnt -- 累计追踪次数
    ,acm_tran_acct_cnt -- 累计转账次数
    ,subtn_tran_cnt -- 持续划款次数
    ,tran_teller_id -- 交易柜员编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,auto_payoff_flg -- 自动结清标志
    ,open_cnt_type_cd -- 开立笔数类型代码
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
    ,o.dep_agt_id -- 存款协议编号
    ,o.seq_num -- 序号
    ,o.plan_id -- 计划编号
    ,o.sign_agt_type_cd -- 签约协议类型代码
    ,o.sign_agt_status_cd -- 签约协议状态代码
    ,o.acct_id -- 账户编号
    ,o.cust_acct_num -- 客户账号
    ,o.cust_id -- 客户编号
    ,o.acct_prod_id -- 账户产品编号
    ,o.acct_curr_cd -- 账户币种代码
    ,o.acct_sub_acct_num -- 账户子账号
    ,o.acct_name -- 账户名称
    ,o.sub_acct_fix_int_rat -- 分户级固定利率
    ,o.sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,o.sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,o.dep_term_tenor -- 存期期限
    ,o.tenor_type_cd -- 期限类型代码
    ,o.lowt_redt_amt -- 最低转存金额
    ,o.redt_by_agt_way_cd -- 约定转存方式代码
    ,o.redt_mode_cd -- 转存方式代码
    ,o.tran_acct_mult -- 转账倍数
    ,o.tran_amt -- 交易金额
    ,o.bal_ratio -- 余额比例
    ,o.acm_tran_acct_amt -- 累计转账金额
    ,o.tran_acct_base -- 转账基数
    ,o.mini_guart_amt -- 保底金额
    ,o.redt_acct_type_cd -- 转存账户类型代码
    ,o.finc_fix_amt -- 理财固定金额
    ,o.cntpty_acct_id -- 对手账户编号
    ,o.cntpty_cust_acct_num -- 对手客户账号
    ,o.cntpty_acct_prod_id -- 对手账户产品编号
    ,o.cntpty_acct_curr_cd -- 对手账户币种代码
    ,o.cntpty_acct_sub_acct_num -- 对手账户子账号
    ,o.cntpty_bank_no -- 对手银行行号
    ,o.cntpty_acct_name -- 对手账户名称
    ,o.cntpty_acct_type_cd -- 对手账户类型代码
    ,o.pric_int_enter_sub_acct_num -- 本息入账账户子账号
    ,o.pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,o.pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,o.pric_int_enter_prod_id -- 本息入账账户产品编号
    ,o.stl_acct_curr_cd -- 结算账户币种代码
    ,o.stl_acct_sub_acct_num -- 结算账户子账号
    ,o.stl_cust_acct_num -- 结算客户账号
    ,o.stl_acct_prod_id -- 结算账户产品编号
    ,o.loan_rs_cd -- 贷款原因代码
    ,o.prior_level -- 优先等级
    ,o.acm_track_cnt -- 累计追踪次数
    ,o.acm_tran_acct_cnt -- 累计转账次数
    ,o.subtn_tran_cnt -- 持续划款次数
    ,o.tran_teller_id -- 交易柜员编号
    ,o.sign_dt -- 签约日期
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.auto_payoff_flg -- 自动结清标志
    ,o.open_cnt_type_cd -- 开立笔数类型代码
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
from ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dep_agt_id = n.dep_agt_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dep_agt_id = d.dep_agt_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_acct_auto_redt_agt_h;
--alter table ${iml_schema}.agt_dep_acct_auto_redt_agt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_acct_auto_redt_agt_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_acct_auto_redt_agt_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_dep_acct_auto_redt_agt_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_acct_auto_redt_agt_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_acct_auto_redt_agt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_auto_redt_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_acct_auto_redt_agt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_auto_redt_agt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
