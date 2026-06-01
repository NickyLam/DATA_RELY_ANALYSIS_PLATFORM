/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_delay_pay_int_info_h_ncbsf1
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
alter table ${iml_schema}.agt_delay_pay_int_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_delay_pay_int_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,apv_form_id -- 审批单编号
    ,sub_acct_num -- 子账号
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,min_init_amt -- 最小起存金额
    ,min_init_tenor -- 最小起存期限
    ,status_cd -- 状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tm_type_cd -- 时间类型代码
    ,pay_int_spec_day -- 付息指定日
    ,int_accr_days -- 计息天数
    ,max_int_accr_acct_bal -- 最大计息账户余额
    ,delay_pay_int_int -- 延期付息利息
    ,merge_int_set_flg_cd -- 合并结息标志代码
    ,acm_amt -- 累计金额
    ,int_paybl -- 应付利息
    ,acm_paid_int -- 累计已付利息
    ,int_float_point -- 利息浮动点数
    ,yd_today_val_bal -- 昨日今日值差额
    ,td_acm_amt -- 当日累计金额
    ,next_int_set_day -- 下一结息日
    ,last_int_set_day -- 上一结息日
    ,spec_yld_rat -- 指定收益率
    ,int_enter_acct_id -- 利息入账账户编号
    ,int_enter_acct_cust_acct_num -- 利息入账客户账号
    ,int_enter_acct_prod_id -- 利息入账产品编号
    ,int_enter_acct_sub_acct_num -- 利息入账子账号
    ,int_enter_acct_curr_cd -- 利息入账币种代码
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,core_tran_org_id -- 核心交易机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_delay_pay_int_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_delay_pay_int_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_delay_pay_int_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_delay_pay_int-1
insert into ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,apv_form_id -- 审批单编号
    ,sub_acct_num -- 子账号
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,min_init_amt -- 最小起存金额
    ,min_init_tenor -- 最小起存期限
    ,status_cd -- 状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tm_type_cd -- 时间类型代码
    ,pay_int_spec_day -- 付息指定日
    ,int_accr_days -- 计息天数
    ,max_int_accr_acct_bal -- 最大计息账户余额
    ,delay_pay_int_int -- 延期付息利息
    ,merge_int_set_flg_cd -- 合并结息标志代码
    ,acm_amt -- 累计金额
    ,int_paybl -- 应付利息
    ,acm_paid_int -- 累计已付利息
    ,int_float_point -- 利息浮动点数
    ,yd_today_val_bal -- 昨日今日值差额
    ,td_acm_amt -- 当日累计金额
    ,next_int_set_day -- 下一结息日
    ,last_int_set_day -- 上一结息日
    ,spec_yld_rat -- 指定收益率
    ,int_enter_acct_id -- 利息入账账户编号
    ,int_enter_acct_cust_acct_num -- 利息入账客户账号
    ,int_enter_acct_prod_id -- 利息入账产品编号
    ,int_enter_acct_sub_acct_num -- 利息入账子账号
    ,int_enter_acct_curr_cd -- 利息入账币种代码
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,core_tran_org_id -- 核心交易机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300037'||P1.INTERNAL_KEY||P1.APPROVAL_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.APPROVAL_NO -- 审批单编号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,nvl(trim(p1.ACCT_TYPE),'-') -- 账户类型代码
    ,nvl(trim(p1.ACCT_CCY),'-') -- 币种代码
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.MIN_DEPOSIT_AMT -- 最小起存金额
    ,to_number(nvl(trim(P1.MIN_DEPOSIT_TERM),'0')) -- 最小起存期限
    ,nvl(trim(p1.STATUS),'-') -- 状态代码
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.EXPIRE_DATE -- 失效日期
    ,nvl(trim(p1.DELAY_PAY_INT_TYPE),'-') -- 时间类型代码
    ,to_number(nvl(trim(P1.SPEC_DAY),'0')) -- 付息指定日
    ,P1.CALC_DAYS -- 计息天数
    ,P1.MAX_AMT -- 最大计息账户余额
    ,P1.DELAY_PAY_INT_AMT -- 延期付息利息
    ,decode(trim(P1.MERGE_CYCLE_FLAG),'Y','1','N','0','','-',P1.MERGE_CYCLE_FLAG) -- 合并结息标志代码
    ,P1.DELAY_TOTAL_AMT -- 累计金额
    ,P1.PAY_INTEREST -- 应付利息
    ,P1.PAST_INTEREST -- 累计已付利息
    ,P1.INT_FLOAT_POINT -- 利息浮动点数
    ,P1.DELAY_INT_AMT_DIFF -- 昨日今日值差额
    ,P1.CALC_DELAY_INT_AMT -- 当日累计金额
    ,P1.NEXT_CYCLE_DATE -- 下一结息日
    ,P1.LAST_CYCLE_DATE -- 上一结息日
    ,P1.SPEC_RATE -- 指定收益率
    ,P1.OTH_INTERNAL_KEY -- 利息入账账户编号
    ,P1.OTH_BASE_ACCT_NO -- 利息入账客户账号
    ,P1.OTH_PROD_TYPE -- 利息入账产品编号
    ,P1.OTH_ACCT_SEQ_NO -- 利息入账子账号
    ,nvl(trim(p1.OTH_ACCT_CCY),'-') -- 利息入账币种代码
    ,P1.REFERENCE -- 交易参考号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.TRAN_BRANCH -- 核心交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_delay_pay_int' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_delay_pay_int p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_tm 
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
        into ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,apv_form_id -- 审批单编号
    ,sub_acct_num -- 子账号
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,min_init_amt -- 最小起存金额
    ,min_init_tenor -- 最小起存期限
    ,status_cd -- 状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tm_type_cd -- 时间类型代码
    ,pay_int_spec_day -- 付息指定日
    ,int_accr_days -- 计息天数
    ,max_int_accr_acct_bal -- 最大计息账户余额
    ,delay_pay_int_int -- 延期付息利息
    ,merge_int_set_flg_cd -- 合并结息标志代码
    ,acm_amt -- 累计金额
    ,int_paybl -- 应付利息
    ,acm_paid_int -- 累计已付利息
    ,int_float_point -- 利息浮动点数
    ,yd_today_val_bal -- 昨日今日值差额
    ,td_acm_amt -- 当日累计金额
    ,next_int_set_day -- 下一结息日
    ,last_int_set_day -- 上一结息日
    ,spec_yld_rat -- 指定收益率
    ,int_enter_acct_id -- 利息入账账户编号
    ,int_enter_acct_cust_acct_num -- 利息入账客户账号
    ,int_enter_acct_prod_id -- 利息入账产品编号
    ,int_enter_acct_sub_acct_num -- 利息入账子账号
    ,int_enter_acct_curr_cd -- 利息入账币种代码
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,core_tran_org_id -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,apv_form_id -- 审批单编号
    ,sub_acct_num -- 子账号
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,min_init_amt -- 最小起存金额
    ,min_init_tenor -- 最小起存期限
    ,status_cd -- 状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tm_type_cd -- 时间类型代码
    ,pay_int_spec_day -- 付息指定日
    ,int_accr_days -- 计息天数
    ,max_int_accr_acct_bal -- 最大计息账户余额
    ,delay_pay_int_int -- 延期付息利息
    ,merge_int_set_flg_cd -- 合并结息标志代码
    ,acm_amt -- 累计金额
    ,int_paybl -- 应付利息
    ,acm_paid_int -- 累计已付利息
    ,int_float_point -- 利息浮动点数
    ,yd_today_val_bal -- 昨日今日值差额
    ,td_acm_amt -- 当日累计金额
    ,next_int_set_day -- 下一结息日
    ,last_int_set_day -- 上一结息日
    ,spec_yld_rat -- 指定收益率
    ,int_enter_acct_id -- 利息入账账户编号
    ,int_enter_acct_cust_acct_num -- 利息入账客户账号
    ,int_enter_acct_prod_id -- 利息入账产品编号
    ,int_enter_acct_sub_acct_num -- 利息入账子账号
    ,int_enter_acct_curr_cd -- 利息入账币种代码
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,core_tran_org_id -- 核心交易机构编号
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
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.apv_form_id, o.apv_form_id) as apv_form_id -- 审批单编号
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.min_init_amt, o.min_init_amt) as min_init_amt -- 最小起存金额
    ,nvl(n.min_init_tenor, o.min_init_tenor) as min_init_tenor -- 最小起存期限
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.tm_type_cd, o.tm_type_cd) as tm_type_cd -- 时间类型代码
    ,nvl(n.pay_int_spec_day, o.pay_int_spec_day) as pay_int_spec_day -- 付息指定日
    ,nvl(n.int_accr_days, o.int_accr_days) as int_accr_days -- 计息天数
    ,nvl(n.max_int_accr_acct_bal, o.max_int_accr_acct_bal) as max_int_accr_acct_bal -- 最大计息账户余额
    ,nvl(n.delay_pay_int_int, o.delay_pay_int_int) as delay_pay_int_int -- 延期付息利息
    ,nvl(n.merge_int_set_flg_cd, o.merge_int_set_flg_cd) as merge_int_set_flg_cd -- 合并结息标志代码
    ,nvl(n.acm_amt, o.acm_amt) as acm_amt -- 累计金额
    ,nvl(n.int_paybl, o.int_paybl) as int_paybl -- 应付利息
    ,nvl(n.acm_paid_int, o.acm_paid_int) as acm_paid_int -- 累计已付利息
    ,nvl(n.int_float_point, o.int_float_point) as int_float_point -- 利息浮动点数
    ,nvl(n.yd_today_val_bal, o.yd_today_val_bal) as yd_today_val_bal -- 昨日今日值差额
    ,nvl(n.td_acm_amt, o.td_acm_amt) as td_acm_amt -- 当日累计金额
    ,nvl(n.next_int_set_day, o.next_int_set_day) as next_int_set_day -- 下一结息日
    ,nvl(n.last_int_set_day, o.last_int_set_day) as last_int_set_day -- 上一结息日
    ,nvl(n.spec_yld_rat, o.spec_yld_rat) as spec_yld_rat -- 指定收益率
    ,nvl(n.int_enter_acct_id, o.int_enter_acct_id) as int_enter_acct_id -- 利息入账账户编号
    ,nvl(n.int_enter_acct_cust_acct_num, o.int_enter_acct_cust_acct_num) as int_enter_acct_cust_acct_num -- 利息入账客户账号
    ,nvl(n.int_enter_acct_prod_id, o.int_enter_acct_prod_id) as int_enter_acct_prod_id -- 利息入账产品编号
    ,nvl(n.int_enter_acct_sub_acct_num, o.int_enter_acct_sub_acct_num) as int_enter_acct_sub_acct_num -- 利息入账子账号
    ,nvl(n.int_enter_acct_curr_cd, o.int_enter_acct_curr_cd) as int_enter_acct_curr_cd -- 利息入账币种代码
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.core_tran_org_id, o.core_tran_org_id) as core_tran_org_id -- 核心交易机构编号
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
from ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.acct_id <> n.acct_id
        or o.apv_form_id <> n.apv_form_id
        or o.sub_acct_num <> n.sub_acct_num
        or o.acct_type_cd <> n.acct_type_cd
        or o.curr_cd <> n.curr_cd
        or o.cust_acct_num <> n.cust_acct_num
        or o.cust_id <> n.cust_id
        or o.prod_id <> n.prod_id
        or o.min_init_amt <> n.min_init_amt
        or o.min_init_tenor <> n.min_init_tenor
        or o.status_cd <> n.status_cd
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.tm_type_cd <> n.tm_type_cd
        or o.pay_int_spec_day <> n.pay_int_spec_day
        or o.int_accr_days <> n.int_accr_days
        or o.max_int_accr_acct_bal <> n.max_int_accr_acct_bal
        or o.delay_pay_int_int <> n.delay_pay_int_int
        or o.merge_int_set_flg_cd <> n.merge_int_set_flg_cd
        or o.acm_amt <> n.acm_amt
        or o.int_paybl <> n.int_paybl
        or o.acm_paid_int <> n.acm_paid_int
        or o.int_float_point <> n.int_float_point
        or o.yd_today_val_bal <> n.yd_today_val_bal
        or o.td_acm_amt <> n.td_acm_amt
        or o.next_int_set_day <> n.next_int_set_day
        or o.last_int_set_day <> n.last_int_set_day
        or o.spec_yld_rat <> n.spec_yld_rat
        or o.int_enter_acct_id <> n.int_enter_acct_id
        or o.int_enter_acct_cust_acct_num <> n.int_enter_acct_cust_acct_num
        or o.int_enter_acct_prod_id <> n.int_enter_acct_prod_id
        or o.int_enter_acct_sub_acct_num <> n.int_enter_acct_sub_acct_num
        or o.int_enter_acct_curr_cd <> n.int_enter_acct_curr_cd
        or o.tran_ref_no <> n.tran_ref_no
        or o.tran_teller_id <> n.tran_teller_id
        or o.core_tran_org_id <> n.core_tran_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,apv_form_id -- 审批单编号
    ,sub_acct_num -- 子账号
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,min_init_amt -- 最小起存金额
    ,min_init_tenor -- 最小起存期限
    ,status_cd -- 状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tm_type_cd -- 时间类型代码
    ,pay_int_spec_day -- 付息指定日
    ,int_accr_days -- 计息天数
    ,max_int_accr_acct_bal -- 最大计息账户余额
    ,delay_pay_int_int -- 延期付息利息
    ,merge_int_set_flg_cd -- 合并结息标志代码
    ,acm_amt -- 累计金额
    ,int_paybl -- 应付利息
    ,acm_paid_int -- 累计已付利息
    ,int_float_point -- 利息浮动点数
    ,yd_today_val_bal -- 昨日今日值差额
    ,td_acm_amt -- 当日累计金额
    ,next_int_set_day -- 下一结息日
    ,last_int_set_day -- 上一结息日
    ,spec_yld_rat -- 指定收益率
    ,int_enter_acct_id -- 利息入账账户编号
    ,int_enter_acct_cust_acct_num -- 利息入账客户账号
    ,int_enter_acct_prod_id -- 利息入账产品编号
    ,int_enter_acct_sub_acct_num -- 利息入账子账号
    ,int_enter_acct_curr_cd -- 利息入账币种代码
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,core_tran_org_id -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,apv_form_id -- 审批单编号
    ,sub_acct_num -- 子账号
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,min_init_amt -- 最小起存金额
    ,min_init_tenor -- 最小起存期限
    ,status_cd -- 状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tm_type_cd -- 时间类型代码
    ,pay_int_spec_day -- 付息指定日
    ,int_accr_days -- 计息天数
    ,max_int_accr_acct_bal -- 最大计息账户余额
    ,delay_pay_int_int -- 延期付息利息
    ,merge_int_set_flg_cd -- 合并结息标志代码
    ,acm_amt -- 累计金额
    ,int_paybl -- 应付利息
    ,acm_paid_int -- 累计已付利息
    ,int_float_point -- 利息浮动点数
    ,yd_today_val_bal -- 昨日今日值差额
    ,td_acm_amt -- 当日累计金额
    ,next_int_set_day -- 下一结息日
    ,last_int_set_day -- 上一结息日
    ,spec_yld_rat -- 指定收益率
    ,int_enter_acct_id -- 利息入账账户编号
    ,int_enter_acct_cust_acct_num -- 利息入账客户账号
    ,int_enter_acct_prod_id -- 利息入账产品编号
    ,int_enter_acct_sub_acct_num -- 利息入账子账号
    ,int_enter_acct_curr_cd -- 利息入账币种代码
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,core_tran_org_id -- 核心交易机构编号
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
    ,o.acct_id -- 账户编号
    ,o.apv_form_id -- 审批单编号
    ,o.sub_acct_num -- 子账号
    ,o.acct_type_cd -- 账户类型代码
    ,o.curr_cd -- 币种代码
    ,o.cust_acct_num -- 客户账号
    ,o.cust_id -- 客户编号
    ,o.prod_id -- 产品编号
    ,o.min_init_amt -- 最小起存金额
    ,o.min_init_tenor -- 最小起存期限
    ,o.status_cd -- 状态代码
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.tm_type_cd -- 时间类型代码
    ,o.pay_int_spec_day -- 付息指定日
    ,o.int_accr_days -- 计息天数
    ,o.max_int_accr_acct_bal -- 最大计息账户余额
    ,o.delay_pay_int_int -- 延期付息利息
    ,o.merge_int_set_flg_cd -- 合并结息标志代码
    ,o.acm_amt -- 累计金额
    ,o.int_paybl -- 应付利息
    ,o.acm_paid_int -- 累计已付利息
    ,o.int_float_point -- 利息浮动点数
    ,o.yd_today_val_bal -- 昨日今日值差额
    ,o.td_acm_amt -- 当日累计金额
    ,o.next_int_set_day -- 下一结息日
    ,o.last_int_set_day -- 上一结息日
    ,o.spec_yld_rat -- 指定收益率
    ,o.int_enter_acct_id -- 利息入账账户编号
    ,o.int_enter_acct_cust_acct_num -- 利息入账客户账号
    ,o.int_enter_acct_prod_id -- 利息入账产品编号
    ,o.int_enter_acct_sub_acct_num -- 利息入账子账号
    ,o.int_enter_acct_curr_cd -- 利息入账币种代码
    ,o.tran_ref_no -- 交易参考号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.core_tran_org_id -- 核心交易机构编号
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
from ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_cl d
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
--truncate table ${iml_schema}.agt_delay_pay_int_info_h;
--alter table ${iml_schema}.agt_delay_pay_int_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_delay_pay_int_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_delay_pay_int_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_delay_pay_int_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_delay_pay_int_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_delay_pay_int_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_delay_pay_int_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_delay_pay_int_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_delay_pay_int_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
