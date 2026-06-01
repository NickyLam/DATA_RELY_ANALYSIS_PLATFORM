/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_int_set_h_ncbsf1
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
alter table ${iml_schema}.agt_loan_int_set_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_int_set_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_int_set_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_int_set_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_int_set_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_int_set_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_int_set_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,int_set_dt -- 结息日期
    ,int_cls_cd -- 利息分类代码
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,chn_id -- 渠道编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,int_set_amt -- 结息金额
    ,int_set_day_int_amt -- 结息日利息金额
    ,acm_int_adj_amt -- 累计利息调整金额
    ,acm_provi_int -- 累计计提利息
    ,int_set_day_int_tax -- 结息日利息税
    ,int_tax_acm_amt -- 利息税累计金额
    ,tran_intior_type_cd -- 交易发起方类型代码
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,exec_int_rat -- 执行利率
    ,src_module_type_cd -- 源模块类型代码
    ,sob_type_cd -- 账套类型代码
    ,tran_ref_no -- 交易参考号
    ,revs_flg -- 冲正标志
    ,accti_status_cd -- 核算状态代码
    ,post_flg -- 过账标志
    ,bus_proc_status_cd -- 业务处理状态代码
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_amt -- 利息金额
    ,cust_type_cd -- 客户类型代码
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_int_set_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_int_set_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_int_set_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_loan_int_set_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_int_set_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_capt_info-1
insert into ${iml_schema}.agt_loan_int_set_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,int_set_dt -- 结息日期
    ,int_cls_cd -- 利息分类代码
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,chn_id -- 渠道编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,int_set_amt -- 结息金额
    ,int_set_day_int_amt -- 结息日利息金额
    ,acm_int_adj_amt -- 累计利息调整金额
    ,acm_provi_int -- 累计计提利息
    ,int_set_day_int_tax -- 结息日利息税
    ,int_tax_acm_amt -- 利息税累计金额
    ,tran_intior_type_cd -- 交易发起方类型代码
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,exec_int_rat -- 执行利率
    ,src_module_type_cd -- 源模块类型代码
    ,sob_type_cd -- 账套类型代码
    ,tran_ref_no -- 交易参考号
    ,revs_flg -- 冲正标志
    ,accti_status_cd -- 核算状态代码
    ,post_flg -- 过账标志
    ,bus_proc_status_cd -- 业务处理状态代码
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_amt -- 利息金额
    ,cust_type_cd -- 客户类型代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 序号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CAPT_DATE -- 结息日期
    ,P1.INT_CLASS -- 利息分类代码
    ,P1.LOAN_NO -- 贷款号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.BRANCH -- 机构编号
    ,nvl(trim(P1.SOURCE_TYPE),'-') -- 渠道编号
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.INT_POSTED -- 结息金额
    ,P1.INT_POSTED_CTD -- 结息日利息金额
    ,P1.INT_ADJ -- 累计利息调整金额
    ,P1.INT_ACCRUED -- 累计计提利息
    ,P1.TAX_POSTED_CTD -- 结息日利息税
    ,P1.TAX_POSTED -- 利息税累计金额
    ,P1.TRAN_SOURCE -- 交易发起方类型代码
    ,P1.TAX_TYPE -- 税种代码
    ,P1.TAX_RATE -- 税率
    ,nvl(trim(P1.INT_TYPE),'-') -- 利率类型代码
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.FLOAT_RATE -- 浮动利率
    ,P1.REAL_RATE -- 执行利率
    ,P1.SOURCE_MODULE -- 源模块类型代码
    ,nvl(trim(P1.BUSINESS_UNIT),'-') -- 账套类型代码
    ,P1.REFERENCE -- 交易参考号
    ,decode(trim(p1.REVERSAL),'','-','Y','1','N','0',p1.REVERSAL) -- 冲正标志
    ,nvl(trim(P1.ACCOUNTING_STATUS),'-') -- 核算状态代码
    ,decode(trim(p1.GL_POSTED_FLAG),'','-','Y','1','N','0',p1.GL_POSTED_FLAG) -- 过账标志
    ,nvl(trim(P1.TRAN_STATUS),'-') -- 业务处理状态代码
    ,P1.ACCT_SPREAD_RATE -- 分户级利率浮动点数
    ,P1.ACCT_PERCENT_RATE -- 分户级利率浮动比例
    ,P1.ACCT_FIXED_RATE -- 分户级固定利率
    ,nvl(trim(P1.AGREE_CHANGE_TYPE),'-') -- 协议变动方式代码
    ,P1.AGREE_FIXED_RATE -- 协议固定利率
    ,P1.AGREE_PERCENT_RATE -- 协议浮动比例
    ,P1.AGREE_SPREAD_RATE -- 协议浮动点数
    ,nvl(trim(P1.YEAR_BASIS),'-') -- 年计息基准代码
    ,P1.START_DATE -- 起息日期
    ,P1.INT_AMT -- 利息金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_capt_info' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_capt_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_CL_CAPT_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LOAN_INT_SET_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_int_set_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,seq_num
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
        into ${iml_schema}.agt_loan_int_set_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,int_set_dt -- 结息日期
    ,int_cls_cd -- 利息分类代码
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,chn_id -- 渠道编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,int_set_amt -- 结息金额
    ,int_set_day_int_amt -- 结息日利息金额
    ,acm_int_adj_amt -- 累计利息调整金额
    ,acm_provi_int -- 累计计提利息
    ,int_set_day_int_tax -- 结息日利息税
    ,int_tax_acm_amt -- 利息税累计金额
    ,tran_intior_type_cd -- 交易发起方类型代码
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,exec_int_rat -- 执行利率
    ,src_module_type_cd -- 源模块类型代码
    ,sob_type_cd -- 账套类型代码
    ,tran_ref_no -- 交易参考号
    ,revs_flg -- 冲正标志
    ,accti_status_cd -- 核算状态代码
    ,post_flg -- 过账标志
    ,bus_proc_status_cd -- 业务处理状态代码
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_amt -- 利息金额
    ,cust_type_cd -- 客户类型代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_int_set_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,int_set_dt -- 结息日期
    ,int_cls_cd -- 利息分类代码
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,chn_id -- 渠道编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,int_set_amt -- 结息金额
    ,int_set_day_int_amt -- 结息日利息金额
    ,acm_int_adj_amt -- 累计利息调整金额
    ,acm_provi_int -- 累计计提利息
    ,int_set_day_int_tax -- 结息日利息税
    ,int_tax_acm_amt -- 利息税累计金额
    ,tran_intior_type_cd -- 交易发起方类型代码
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,exec_int_rat -- 执行利率
    ,src_module_type_cd -- 源模块类型代码
    ,sob_type_cd -- 账套类型代码
    ,tran_ref_no -- 交易参考号
    ,revs_flg -- 冲正标志
    ,accti_status_cd -- 核算状态代码
    ,post_flg -- 过账标志
    ,bus_proc_status_cd -- 业务处理状态代码
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_amt -- 利息金额
    ,cust_type_cd -- 客户类型代码
    ,remark -- 备注
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
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.int_set_dt, o.int_set_dt) as int_set_dt -- 结息日期
    ,nvl(n.int_cls_cd, o.int_cls_cd) as int_cls_cd -- 利息分类代码
    ,nvl(n.loan_num, o.loan_num) as loan_num -- 贷款号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.int_set_amt, o.int_set_amt) as int_set_amt -- 结息金额
    ,nvl(n.int_set_day_int_amt, o.int_set_day_int_amt) as int_set_day_int_amt -- 结息日利息金额
    ,nvl(n.acm_int_adj_amt, o.acm_int_adj_amt) as acm_int_adj_amt -- 累计利息调整金额
    ,nvl(n.acm_provi_int, o.acm_provi_int) as acm_provi_int -- 累计计提利息
    ,nvl(n.int_set_day_int_tax, o.int_set_day_int_tax) as int_set_day_int_tax -- 结息日利息税
    ,nvl(n.int_tax_acm_amt, o.int_tax_acm_amt) as int_tax_acm_amt -- 利息税累计金额
    ,nvl(n.tran_intior_type_cd, o.tran_intior_type_cd) as tran_intior_type_cd -- 交易发起方类型代码
    ,nvl(n.tax_category_cd, o.tax_category_cd) as tax_category_cd -- 税种代码
    ,nvl(n.tax_rat, o.tax_rat) as tax_rat -- 税率
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.bank_int_int_rat, o.bank_int_int_rat) as bank_int_int_rat -- 行内利率
    ,nvl(n.float_int_rat, o.float_int_rat) as float_int_rat -- 浮动利率
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.src_module_type_cd, o.src_module_type_cd) as src_module_type_cd -- 源模块类型代码
    ,nvl(n.sob_type_cd, o.sob_type_cd) as sob_type_cd -- 账套类型代码
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.revs_flg, o.revs_flg) as revs_flg -- 冲正标志
    ,nvl(n.accti_status_cd, o.accti_status_cd) as accti_status_cd -- 核算状态代码
    ,nvl(n.post_flg, o.post_flg) as post_flg -- 过账标志
    ,nvl(n.bus_proc_status_cd, o.bus_proc_status_cd) as bus_proc_status_cd -- 业务处理状态代码
    ,nvl(n.sub_acct_int_rat_float_point, o.sub_acct_int_rat_float_point) as sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,nvl(n.sub_acct_int_rat_float_ratio, o.sub_acct_int_rat_float_ratio) as sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,nvl(n.sub_acct_fix_int_rat, o.sub_acct_fix_int_rat) as sub_acct_fix_int_rat -- 分户级固定利率
    ,nvl(n.agt_chg_way_cd, o.agt_chg_way_cd) as agt_chg_way_cd -- 协议变动方式代码
    ,nvl(n.agt_fix_int_rat, o.agt_fix_int_rat) as agt_fix_int_rat -- 协议固定利率
    ,nvl(n.agt_float_ratio, o.agt_float_ratio) as agt_float_ratio -- 协议浮动比例
    ,nvl(n.agt_float_point, o.agt_float_point) as agt_float_point -- 协议浮动点数
    ,nvl(n.year_int_accr_base_cd, o.year_int_accr_base_cd) as year_int_accr_base_cd -- 年计息基准代码
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_int_set_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_int_set_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.seq_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.seq_num is null
    )
    or (
        o.acct_id <> n.acct_id
        or o.int_set_dt <> n.int_set_dt
        or o.int_cls_cd <> n.int_cls_cd
        or o.loan_num <> n.loan_num
        or o.prod_id <> n.prod_id
        or o.org_id <> n.org_id
        or o.chn_id <> n.chn_id
        or o.curr_cd <> n.curr_cd
        or o.cust_id <> n.cust_id
        or o.int_set_amt <> n.int_set_amt
        or o.int_set_day_int_amt <> n.int_set_day_int_amt
        or o.acm_int_adj_amt <> n.acm_int_adj_amt
        or o.acm_provi_int <> n.acm_provi_int
        or o.int_set_day_int_tax <> n.int_set_day_int_tax
        or o.int_tax_acm_amt <> n.int_tax_acm_amt
        or o.tran_intior_type_cd <> n.tran_intior_type_cd
        or o.tax_category_cd <> n.tax_category_cd
        or o.tax_rat <> n.tax_rat
        or o.int_rat_type_cd <> n.int_rat_type_cd
        or o.bank_int_int_rat <> n.bank_int_int_rat
        or o.float_int_rat <> n.float_int_rat
        or o.exec_int_rat <> n.exec_int_rat
        or o.src_module_type_cd <> n.src_module_type_cd
        or o.sob_type_cd <> n.sob_type_cd
        or o.tran_ref_no <> n.tran_ref_no
        or o.revs_flg <> n.revs_flg
        or o.accti_status_cd <> n.accti_status_cd
        or o.post_flg <> n.post_flg
        or o.bus_proc_status_cd <> n.bus_proc_status_cd
        or o.sub_acct_int_rat_float_point <> n.sub_acct_int_rat_float_point
        or o.sub_acct_int_rat_float_ratio <> n.sub_acct_int_rat_float_ratio
        or o.sub_acct_fix_int_rat <> n.sub_acct_fix_int_rat
        or o.agt_chg_way_cd <> n.agt_chg_way_cd
        or o.agt_fix_int_rat <> n.agt_fix_int_rat
        or o.agt_float_ratio <> n.agt_float_ratio
        or o.agt_float_point <> n.agt_float_point
        or o.year_int_accr_base_cd <> n.year_int_accr_base_cd
        or o.value_dt <> n.value_dt
        or o.int_amt <> n.int_amt
        or o.cust_type_cd <> n.cust_type_cd
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_int_set_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,int_set_dt -- 结息日期
    ,int_cls_cd -- 利息分类代码
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,chn_id -- 渠道编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,int_set_amt -- 结息金额
    ,int_set_day_int_amt -- 结息日利息金额
    ,acm_int_adj_amt -- 累计利息调整金额
    ,acm_provi_int -- 累计计提利息
    ,int_set_day_int_tax -- 结息日利息税
    ,int_tax_acm_amt -- 利息税累计金额
    ,tran_intior_type_cd -- 交易发起方类型代码
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,exec_int_rat -- 执行利率
    ,src_module_type_cd -- 源模块类型代码
    ,sob_type_cd -- 账套类型代码
    ,tran_ref_no -- 交易参考号
    ,revs_flg -- 冲正标志
    ,accti_status_cd -- 核算状态代码
    ,post_flg -- 过账标志
    ,bus_proc_status_cd -- 业务处理状态代码
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_amt -- 利息金额
    ,cust_type_cd -- 客户类型代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_int_set_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,int_set_dt -- 结息日期
    ,int_cls_cd -- 利息分类代码
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,chn_id -- 渠道编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,int_set_amt -- 结息金额
    ,int_set_day_int_amt -- 结息日利息金额
    ,acm_int_adj_amt -- 累计利息调整金额
    ,acm_provi_int -- 累计计提利息
    ,int_set_day_int_tax -- 结息日利息税
    ,int_tax_acm_amt -- 利息税累计金额
    ,tran_intior_type_cd -- 交易发起方类型代码
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,exec_int_rat -- 执行利率
    ,src_module_type_cd -- 源模块类型代码
    ,sob_type_cd -- 账套类型代码
    ,tran_ref_no -- 交易参考号
    ,revs_flg -- 冲正标志
    ,accti_status_cd -- 核算状态代码
    ,post_flg -- 过账标志
    ,bus_proc_status_cd -- 业务处理状态代码
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_amt -- 利息金额
    ,cust_type_cd -- 客户类型代码
    ,remark -- 备注
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
    ,o.seq_num -- 序号
    ,o.acct_id -- 账户编号
    ,o.int_set_dt -- 结息日期
    ,o.int_cls_cd -- 利息分类代码
    ,o.loan_num -- 贷款号
    ,o.prod_id -- 产品编号
    ,o.org_id -- 机构编号
    ,o.chn_id -- 渠道编号
    ,o.curr_cd -- 币种代码
    ,o.cust_id -- 客户编号
    ,o.int_set_amt -- 结息金额
    ,o.int_set_day_int_amt -- 结息日利息金额
    ,o.acm_int_adj_amt -- 累计利息调整金额
    ,o.acm_provi_int -- 累计计提利息
    ,o.int_set_day_int_tax -- 结息日利息税
    ,o.int_tax_acm_amt -- 利息税累计金额
    ,o.tran_intior_type_cd -- 交易发起方类型代码
    ,o.tax_category_cd -- 税种代码
    ,o.tax_rat -- 税率
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.bank_int_int_rat -- 行内利率
    ,o.float_int_rat -- 浮动利率
    ,o.exec_int_rat -- 执行利率
    ,o.src_module_type_cd -- 源模块类型代码
    ,o.sob_type_cd -- 账套类型代码
    ,o.tran_ref_no -- 交易参考号
    ,o.revs_flg -- 冲正标志
    ,o.accti_status_cd -- 核算状态代码
    ,o.post_flg -- 过账标志
    ,o.bus_proc_status_cd -- 业务处理状态代码
    ,o.sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,o.sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,o.sub_acct_fix_int_rat -- 分户级固定利率
    ,o.agt_chg_way_cd -- 协议变动方式代码
    ,o.agt_fix_int_rat -- 协议固定利率
    ,o.agt_float_ratio -- 协议浮动比例
    ,o.agt_float_point -- 协议浮动点数
    ,o.year_int_accr_base_cd -- 年计息基准代码
    ,o.value_dt -- 起息日期
    ,o.int_amt -- 利息金额
    ,o.cust_type_cd -- 客户类型代码
    ,o.remark -- 备注
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
from ${iml_schema}.agt_loan_int_set_h_ncbsf1_bk o
    left join ${iml_schema}.agt_loan_int_set_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_int_set_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_int_set_h;
--alter table ${iml_schema}.agt_loan_int_set_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_int_set_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_int_set_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_int_set_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_int_set_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_loan_int_set_h_ncbsf1_cl;
alter table ${iml_schema}.agt_loan_int_set_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_loan_int_set_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_int_set_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_int_set_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_int_set_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_int_set_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_int_set_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_int_set_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
