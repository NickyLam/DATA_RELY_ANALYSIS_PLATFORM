/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_exp_auto_cash_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_acct_exp_auto_cash_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_exp_auto_cash_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,seq_num -- 序号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,int_amt -- 利息金额
    ,pric_amt -- 本金金额
    ,cash_redem_amt -- 兑付赎回金额
    ,exec_year_int_rat -- 执行年利率
    ,proc_cate_cd -- 处理类别代码
    ,pric_int_enter_acct_cust_id -- 本息入账客户编号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_acct_sub_acct_num -- 本息入账子账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,int_enter_name -- 利息入账账户名称
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,rest_cd -- 处理结果代码
    ,fail_rs_descb -- 失败原因描述
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_exp_auto_cash_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_exp_auto_cash_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_exp_auto_cash_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_dc_tohonor_rec_info-1
insert into ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,seq_num -- 序号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,int_amt -- 利息金额
    ,pric_amt -- 本金金额
    ,cash_redem_amt -- 兑付赎回金额
    ,exec_year_int_rat -- 执行年利率
    ,proc_cate_cd -- 处理类别代码
    ,pric_int_enter_acct_cust_id -- 本息入账客户编号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_acct_sub_acct_num -- 本息入账子账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,int_enter_name -- 利息入账账户名称
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,rest_cd -- 处理结果代码
    ,fail_rs_descb -- 失败原因描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,'9999' -- 法人编号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.SEQ_NO -- 序号
    ,P1.CCY -- 币种代码
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.ACCT_OPEN_DATE -- 开户日期
    ,P1.MATURITY_DATE -- 到期日期
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_BRANCH -- 核心交易机构编号
    ,P1.INT_AMT -- 利息金额
    ,P1.PRI_AMT -- 本金金额
    ,P1.TOHONOR_REC_AMT -- 兑付赎回金额
    ,P1.YEAR_RATE -- 执行年利率
    ,P1.DEAL_TYPE -- 处理类别代码
    ,P1.PRIINT_INTERNAL_KEY -- 本息入账客户编号
    ,nvl(trim(p9.card_no),p1.PRIINT_BASE_ACCT_NO) -- 本息入账客户账号
    ,P1.PRIINT_ACCT_SEQ_NO -- 本息入账子账号
    ,nvl(trim(P1.PRIINT_CCY),'0000') -- 本息入账账户币种代码
    ,P1.PRIINT_PROD_TYPE -- 本息入账账户产品编号
    ,P1.PRIINT_ACCT_NAME -- 利息入账账户名称
    ,P1.STAGE_CODE -- 期次编号
    ,nvl(trim(P1.STAGE_PROD_CLASS),'-') -- 期次产品类别代码
    ,P1.TOHONOR_RESULT -- 处理结果代码
    ,P1.FAILURE_REASON -- 失败原因描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_dc_tohonor_rec_info' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_dc_tohonor_rec_info p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO = p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p9 on p1.PRIINT_BASE_ACCT_NO = p9.BASE_ACCT_NO and p9.BASE_ACCT_NO LIKE '0%'
where  1 = 1 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,acct_id
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
        into ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,seq_num -- 序号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,int_amt -- 利息金额
    ,pric_amt -- 本金金额
    ,cash_redem_amt -- 兑付赎回金额
    ,exec_year_int_rat -- 执行年利率
    ,proc_cate_cd -- 处理类别代码
    ,pric_int_enter_acct_cust_id -- 本息入账客户编号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_acct_sub_acct_num -- 本息入账子账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,int_enter_name -- 利息入账账户名称
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,rest_cd -- 处理结果代码
    ,fail_rs_descb -- 失败原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_op(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,seq_num -- 序号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,int_amt -- 利息金额
    ,pric_amt -- 本金金额
    ,cash_redem_amt -- 兑付赎回金额
    ,exec_year_int_rat -- 执行年利率
    ,proc_cate_cd -- 处理类别代码
    ,pric_int_enter_acct_cust_id -- 本息入账客户编号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_acct_sub_acct_num -- 本息入账子账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,int_enter_name -- 利息入账账户名称
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,rest_cd -- 处理结果代码
    ,fail_rs_descb -- 失败原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.core_tran_org_id, o.core_tran_org_id) as core_tran_org_id -- 核心交易机构编号
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.pric_amt, o.pric_amt) as pric_amt -- 本金金额
    ,nvl(n.cash_redem_amt, o.cash_redem_amt) as cash_redem_amt -- 兑付赎回金额
    ,nvl(n.exec_year_int_rat, o.exec_year_int_rat) as exec_year_int_rat -- 执行年利率
    ,nvl(n.proc_cate_cd, o.proc_cate_cd) as proc_cate_cd -- 处理类别代码
    ,nvl(n.pric_int_enter_acct_cust_id, o.pric_int_enter_acct_cust_id) as pric_int_enter_acct_cust_id -- 本息入账客户编号
    ,nvl(n.pric_int_enter_acct_cust_acct_num, o.pric_int_enter_acct_cust_acct_num) as pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,nvl(n.pric_int_enter_acct_sub_acct_num, o.pric_int_enter_acct_sub_acct_num) as pric_int_enter_acct_sub_acct_num -- 本息入账子账号
    ,nvl(n.pric_int_enter_curr_cd, o.pric_int_enter_curr_cd) as pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,nvl(n.pric_int_enter_prod_id, o.pric_int_enter_prod_id) as pric_int_enter_prod_id -- 本息入账账户产品编号
    ,nvl(n.int_enter_name, o.int_enter_name) as int_enter_name -- 利息入账账户名称
    ,nvl(n.pd_cd, o.pd_cd) as pd_cd -- 期次编号
    ,nvl(n.pd_prod_cate_cd, o.pd_prod_cate_cd) as pd_prod_cate_cd -- 期次产品类别代码
    ,nvl(n.rest_cd, o.rest_cd) as rest_cd -- 处理结果代码
    ,nvl(n.fail_rs_descb, o.fail_rs_descb) as fail_rs_descb -- 失败原因描述
    ,case when
            n.agt_id is null
            and n.acct_id is null
            and n.lp_id is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.acct_id is null
            and n.lp_id is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.acct_id is null
            and n.lp_id is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.acct_id = n.acct_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
where (
        o.agt_id is null
        and o.acct_id is null
        and o.lp_id is null
        and o.seq_num is null
    )
    or (
        n.agt_id is null
        and n.acct_id is null
        and n.lp_id is null
        and n.seq_num is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.sub_acct_num <> n.sub_acct_num
        or o.curr_cd <> n.curr_cd
        or o.prod_id <> n.prod_id
        or o.acct_name <> n.acct_name
        or o.open_acct_dt <> n.open_acct_dt
        or o.exp_dt <> n.exp_dt
        or o.tran_dt <> n.tran_dt
        or o.core_tran_org_id <> n.core_tran_org_id
        or o.int_amt <> n.int_amt
        or o.pric_amt <> n.pric_amt
        or o.cash_redem_amt <> n.cash_redem_amt
        or o.exec_year_int_rat <> n.exec_year_int_rat
        or o.proc_cate_cd <> n.proc_cate_cd
        or o.pric_int_enter_acct_cust_id <> n.pric_int_enter_acct_cust_id
        or o.pric_int_enter_acct_cust_acct_num <> n.pric_int_enter_acct_cust_acct_num
        or o.pric_int_enter_acct_sub_acct_num <> n.pric_int_enter_acct_sub_acct_num
        or o.pric_int_enter_curr_cd <> n.pric_int_enter_curr_cd
        or o.pric_int_enter_prod_id <> n.pric_int_enter_prod_id
        or o.int_enter_name <> n.int_enter_name
        or o.pd_cd <> n.pd_cd
        or o.pd_prod_cate_cd <> n.pd_prod_cate_cd
        or o.rest_cd <> n.rest_cd
        or o.fail_rs_descb <> n.fail_rs_descb
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,seq_num -- 序号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,int_amt -- 利息金额
    ,pric_amt -- 本金金额
    ,cash_redem_amt -- 兑付赎回金额
    ,exec_year_int_rat -- 执行年利率
    ,proc_cate_cd -- 处理类别代码
    ,pric_int_enter_acct_cust_id -- 本息入账客户编号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_acct_sub_acct_num -- 本息入账子账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,int_enter_name -- 利息入账账户名称
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,rest_cd -- 处理结果代码
    ,fail_rs_descb -- 失败原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_op(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,seq_num -- 序号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,core_tran_org_id -- 核心交易机构编号
    ,int_amt -- 利息金额
    ,pric_amt -- 本金金额
    ,cash_redem_amt -- 兑付赎回金额
    ,exec_year_int_rat -- 执行年利率
    ,proc_cate_cd -- 处理类别代码
    ,pric_int_enter_acct_cust_id -- 本息入账客户编号
    ,pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,pric_int_enter_acct_sub_acct_num -- 本息入账子账号
    ,pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,pric_int_enter_prod_id -- 本息入账账户产品编号
    ,int_enter_name -- 利息入账账户名称
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,rest_cd -- 处理结果代码
    ,fail_rs_descb -- 失败原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.acct_id -- 账户编号
    ,o.lp_id -- 法人编号
    ,o.cust_id -- 客户编号
    ,o.cust_acct_num -- 客户账号
    ,o.sub_acct_num -- 子账号
    ,o.seq_num -- 序号
    ,o.curr_cd -- 币种代码
    ,o.prod_id -- 产品编号
    ,o.acct_name -- 账户名称
    ,o.open_acct_dt -- 开户日期
    ,o.exp_dt -- 到期日期
    ,o.tran_dt -- 交易日期
    ,o.core_tran_org_id -- 核心交易机构编号
    ,o.int_amt -- 利息金额
    ,o.pric_amt -- 本金金额
    ,o.cash_redem_amt -- 兑付赎回金额
    ,o.exec_year_int_rat -- 执行年利率
    ,o.proc_cate_cd -- 处理类别代码
    ,o.pric_int_enter_acct_cust_id -- 本息入账客户编号
    ,o.pric_int_enter_acct_cust_acct_num -- 本息入账客户账号
    ,o.pric_int_enter_acct_sub_acct_num -- 本息入账子账号
    ,o.pric_int_enter_curr_cd -- 本息入账账户币种代码
    ,o.pric_int_enter_prod_id -- 本息入账账户产品编号
    ,o.int_enter_name -- 利息入账账户名称
    ,o.pd_cd -- 期次编号
    ,o.pd_prod_cate_cd -- 期次产品类别代码
    ,o.rest_cd -- 处理结果代码
    ,o.fail_rs_descb -- 失败原因描述
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
from ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.acct_id = n.acct_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.acct_id = d.acct_id
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
--truncate table ${iml_schema}.agt_dep_acct_exp_auto_cash_h;
--alter table ${iml_schema}.agt_dep_acct_exp_auto_cash_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_acct_exp_auto_cash_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_acct_exp_auto_cash_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_dep_acct_exp_auto_cash_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_acct_exp_auto_cash_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_acct_exp_auto_cash_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_exp_auto_cash_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_acct_exp_auto_cash_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_exp_auto_cash_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
