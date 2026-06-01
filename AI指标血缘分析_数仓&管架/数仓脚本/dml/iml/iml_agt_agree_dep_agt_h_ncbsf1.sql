/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_agree_dep_agt_h_ncbsf1
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
alter table ${iml_schema}.agt_agree_dep_agt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_agree_dep_agt_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,sign_seq_num -- 签约序号
    ,prod_id -- 产品编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_apv_form_num -- 利率审批单号
    ,int_rat_type_cd -- 利率类型代码
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,file_amt -- 靠档金额
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,last_effect_dt -- 上一生效日期
    ,last_invalid_dt -- 上一失效日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_agree_dep_agt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_agree_dep_agt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_agree_dep_agt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_agreement_accord-1
insert into ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,sign_seq_num -- 签约序号
    ,prod_id -- 产品编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_apv_form_num -- 利率审批单号
    ,int_rat_type_cd -- 利率类型代码
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,file_amt -- 靠档金额
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,last_effect_dt -- 上一生效日期
    ,last_invalid_dt -- 上一失效日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300003'||P1.AGREEMENT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.AGREEMENT_ID -- 存款协议编号
    ,P1.SEQ_NO -- 签约序号
    ,P1.ACCORD_PROD_TYPE -- 产品编号
    ,P1.START_DATE -- 生效日期
    ,P1.END_DATE -- 失效日期
    ,nvl(trim(P1.INT_CLASS),'-') -- 利息分类代码
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.AGREEMENT_STATUS -- 签约协议状态代码
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.PROD_TYPE -- 账户产品编号
    ,nvl(trim(P1.ACCT_CCY),'0000') -- 账户币种代码
    ,NVL(TRIM(P1.TERM),0) -- 存款期限
    ,nvl(trim(P1.TERM_TYPE),'-') -- 期限类型代码
    ,P1.INT_RATE_FORM_NO -- 利率审批单号
    ,nvl(trim(P1.INT_TYPE),'-') -- 利率类型代码
    ,P1.ACCT_FIXED_RATE -- 分户级固定利率
    ,P1.ACCT_PERCENT_RATE -- 分户级利率浮动比例
    ,P1.ACCT_SPREAD_RATE -- 分户级利率浮动点数
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.FLOAT_RATE -- 浮动利率
    ,P1.NEAR_AMT -- 靠档金额
    ,nvl(trim(P1.MONTH_BASIS),'-') -- 月计息基准代码
    ,nvl(trim(P1.YEAR_BASIS),'-') -- 年计息基准代码
    ,case when p1.MONTH_BASIS='ACT' and p1.YEAR_BASIS='360'  then 'A/360'
     when p1.MONTH_BASIS='D30' and p1.YEAR_BASIS='360'  then '30/360'
     when p1.MONTH_BASIS='ACT' and p1.YEAR_BASIS='365'  then 'A/365'
     when p1.MONTH_BASIS='D30' and p1.YEAR_BASIS='365'  then '30/365'
     when p1.MONTH_BASIS='ACT' and p1.YEAR_BASIS='366'  then  'A/366'
     else '-'  end -- 计息基准代码
    ,P1.LAST_START_DATE -- 上一生效日期
    ,P1.LAST_END_DATE -- 上一失效日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agreement_accord' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_accord p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dep_agt_id
  	                                        ,sign_seq_num
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
        into ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,sign_seq_num -- 签约序号
    ,prod_id -- 产品编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_apv_form_num -- 利率审批单号
    ,int_rat_type_cd -- 利率类型代码
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,file_amt -- 靠档金额
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,last_effect_dt -- 上一生效日期
    ,last_invalid_dt -- 上一失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,sign_seq_num -- 签约序号
    ,prod_id -- 产品编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_apv_form_num -- 利率审批单号
    ,int_rat_type_cd -- 利率类型代码
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,file_amt -- 靠档金额
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,last_effect_dt -- 上一生效日期
    ,last_invalid_dt -- 上一失效日期
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
    ,nvl(n.sign_seq_num, o.sign_seq_num) as sign_seq_num -- 签约序号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.int_cls_cd, o.int_cls_cd) as int_cls_cd -- 利息分类代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.sign_agt_status_cd, o.sign_agt_status_cd) as sign_agt_status_cd -- 签约协议状态代码
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_prod_id, o.acct_prod_id) as acct_prod_id -- 账户产品编号
    ,nvl(n.acct_curr_cd, o.acct_curr_cd) as acct_curr_cd -- 账户币种代码
    ,nvl(n.dep_tenor, o.dep_tenor) as dep_tenor -- 存款期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.int_rat_apv_form_num, o.int_rat_apv_form_num) as int_rat_apv_form_num -- 利率审批单号
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.sub_acct_fix_int_rat, o.sub_acct_fix_int_rat) as sub_acct_fix_int_rat -- 分户级固定利率
    ,nvl(n.sub_acct_int_rat_float_ratio, o.sub_acct_int_rat_float_ratio) as sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,nvl(n.sub_acct_int_rat_float_point, o.sub_acct_int_rat_float_point) as sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,nvl(n.bank_int_int_rat, o.bank_int_int_rat) as bank_int_int_rat -- 行内利率
    ,nvl(n.float_int_rat, o.float_int_rat) as float_int_rat -- 浮动利率
    ,nvl(n.file_amt, o.file_amt) as file_amt -- 靠档金额
    ,nvl(n.mon_int_accr_base_cd, o.mon_int_accr_base_cd) as mon_int_accr_base_cd -- 月计息基准代码
    ,nvl(n.year_int_accr_base_cd, o.year_int_accr_base_cd) as year_int_accr_base_cd -- 年计息基准代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.last_effect_dt, o.last_effect_dt) as last_effect_dt -- 上一生效日期
    ,nvl(n.last_invalid_dt, o.last_invalid_dt) as last_invalid_dt -- 上一失效日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
            and n.sign_seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
            and n.sign_seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
            and n.sign_seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dep_agt_id = n.dep_agt_id
            and o.sign_seq_num = n.sign_seq_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dep_agt_id is null
        and o.sign_seq_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dep_agt_id is null
        and n.sign_seq_num is null
    )
    or (
        o.prod_id <> n.prod_id
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.int_cls_cd <> n.int_cls_cd
        or o.cust_id <> n.cust_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.sub_acct_num <> n.sub_acct_num
        or o.sign_agt_status_cd <> n.sign_agt_status_cd
        or o.acct_id <> n.acct_id
        or o.acct_prod_id <> n.acct_prod_id
        or o.acct_curr_cd <> n.acct_curr_cd
        or o.dep_tenor <> n.dep_tenor
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.int_rat_apv_form_num <> n.int_rat_apv_form_num
        or o.int_rat_type_cd <> n.int_rat_type_cd
        or o.sub_acct_fix_int_rat <> n.sub_acct_fix_int_rat
        or o.sub_acct_int_rat_float_ratio <> n.sub_acct_int_rat_float_ratio
        or o.sub_acct_int_rat_float_point <> n.sub_acct_int_rat_float_point
        or o.bank_int_int_rat <> n.bank_int_int_rat
        or o.float_int_rat <> n.float_int_rat
        or o.file_amt <> n.file_amt
        or o.mon_int_accr_base_cd <> n.mon_int_accr_base_cd
        or o.year_int_accr_base_cd <> n.year_int_accr_base_cd
        or o.int_accr_base_cd <> n.int_accr_base_cd
        or o.last_effect_dt <> n.last_effect_dt
        or o.last_invalid_dt <> n.last_invalid_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,sign_seq_num -- 签约序号
    ,prod_id -- 产品编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_apv_form_num -- 利率审批单号
    ,int_rat_type_cd -- 利率类型代码
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,file_amt -- 靠档金额
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,last_effect_dt -- 上一生效日期
    ,last_invalid_dt -- 上一失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,sign_seq_num -- 签约序号
    ,prod_id -- 产品编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,acct_id -- 账户编号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_apv_form_num -- 利率审批单号
    ,int_rat_type_cd -- 利率类型代码
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,file_amt -- 靠档金额
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,last_effect_dt -- 上一生效日期
    ,last_invalid_dt -- 上一失效日期
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
    ,o.sign_seq_num -- 签约序号
    ,o.prod_id -- 产品编号
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.int_cls_cd -- 利息分类代码
    ,o.cust_id -- 客户编号
    ,o.cust_acct_num -- 客户账号
    ,o.sub_acct_num -- 子账号
    ,o.sign_agt_status_cd -- 签约协议状态代码
    ,o.acct_id -- 账户编号
    ,o.acct_prod_id -- 账户产品编号
    ,o.acct_curr_cd -- 账户币种代码
    ,o.dep_tenor -- 存款期限
    ,o.tenor_type_cd -- 期限类型代码
    ,o.int_rat_apv_form_num -- 利率审批单号
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.sub_acct_fix_int_rat -- 分户级固定利率
    ,o.sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,o.sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,o.bank_int_int_rat -- 行内利率
    ,o.float_int_rat -- 浮动利率
    ,o.file_amt -- 靠档金额
    ,o.mon_int_accr_base_cd -- 月计息基准代码
    ,o.year_int_accr_base_cd -- 年计息基准代码
    ,o.int_accr_base_cd -- 计息基准代码
    ,o.last_effect_dt -- 上一生效日期
    ,o.last_invalid_dt -- 上一失效日期
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
from ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dep_agt_id = n.dep_agt_id
            and o.sign_seq_num = n.sign_seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dep_agt_id = d.dep_agt_id
            and o.sign_seq_num = d.sign_seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_agree_dep_agt_h;
--alter table ${iml_schema}.agt_agree_dep_agt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_agree_dep_agt_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_agree_dep_agt_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_agree_dep_agt_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_agree_dep_agt_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_agree_dep_agt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_agree_dep_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_agree_dep_agt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_agree_dep_agt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
