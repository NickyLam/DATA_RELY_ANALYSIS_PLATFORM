/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_tran_code_para_ncbsf1
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
alter table ${iml_schema}.ref_tran_code_para add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_tran_code_para_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tran_code_para partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_tran_code_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_tran_code_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_tran_code_para_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tran_code_para_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    tran_code -- 交易码
    ,bus_cls_cd -- 业务分类代码
    ,a_calc_bal_stop_pay_flg -- 重新计算余额止付标志
    ,revs_tran_code -- 冲正交易码
    ,tran_code_descb -- 交易码描述
    ,cntpty_tran_code -- 对方交易码
    ,a_calc_lmt_amt_flg -- 重新计算限制金额标志
    ,revs_flg -- 冲正标志
    ,chn_id -- 渠道编号
    ,aval_bal_calc_type_cd -- 可用余额计算类型代码
    ,multi_revs_way_flg -- 多种冲正方式标志
    ,cash_tran_flg -- 现金交易标志
    ,cor_tran_flg -- 更正交易标志
    ,tran_cls_cd -- 交易分类代码
    ,debit_crdt_flg -- 借贷标志
    ,lp_id -- 法人编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tran_code_para partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_tran_code_para_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tran_code_para partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_tran_code_para_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tran_code_para partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_tran_def-1
insert into ${iml_schema}.ref_tran_code_para_ncbsf1_tm(
    tran_code -- 交易码
    ,bus_cls_cd -- 业务分类代码
    ,a_calc_bal_stop_pay_flg -- 重新计算余额止付标志
    ,revs_tran_code -- 冲正交易码
    ,tran_code_descb -- 交易码描述
    ,cntpty_tran_code -- 对方交易码
    ,a_calc_lmt_amt_flg -- 重新计算限制金额标志
    ,revs_flg -- 冲正标志
    ,chn_id -- 渠道编号
    ,aval_bal_calc_type_cd -- 可用余额计算类型代码
    ,multi_revs_way_flg -- 多种冲正方式标志
    ,cash_tran_flg -- 现金交易标志
    ,cor_tran_flg -- 更正交易标志
    ,tran_cls_cd -- 交易分类代码
    ,debit_crdt_flg -- 借贷标志
    ,lp_id -- 法人编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.TRAN_TYPE -- 交易码
    ,'RB' -- 业务分类代码
    ,decode(trim(p1.RECALC_ACCT_STOP_PAY_FLAG),'','-','Y','1','N','0',p1.RECALC_ACCT_STOP_PAY_FLAG) -- 重新计算余额止付标志
    ,P1.REVERSAL_TRAN_TYPE -- 冲正交易码
    ,P1.TRAN_TYPE_DESC -- 交易码描述
    ,P1.OTH_TRAN_TYPE -- 对方交易码
    ,decode(trim(p1.RECALC_RES_AMT_FLAG),'','-','Y','1','N','0',p1.RECALC_RES_AMT_FLAG) -- 重新计算限制金额标志
    ,decode(trim(p1.REVERSAL),'','-','Y','1','N','0',p1.REVERSAL) -- 冲正标志
    ,P1.SOURCE_TYPE -- 渠道编号
    ,nvl(trim(P1.AVAILBAL_CALC_TYPE),'-') -- 可用余额计算类型代码
    ,decode(trim(p1.MULTI_RVS_TRAN_TYPE_FLAG),'','-','Y','1','N','0',p1.MULTI_RVS_TRAN_TYPE_FLAG) -- 多种冲正方式标志
    ,decode(trim(p1.CASH_TRAN_FLAG),'','-','Y','1','N','0',p1.CASH_TRAN_FLAG) -- 现金交易标志
    ,decode(trim(p1.CORRECT_FLAG),'','-','Y','1','N','0',p1.CORRECT_FLAG) -- 更正交易标志
    ,nvl(trim(P1.TRAN_CLASS),'-') -- 交易分类代码
    ,DECODE(TRIM(P1.CR_DR_IND),'','-','Y','1','N','0',P1.CR_DR_IND)-- 借贷标志
    ,'9999' -- 法人编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_tran_def' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_tran_def p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ncbs_cl_tran_def-1
insert into ${iml_schema}.ref_tran_code_para_ncbsf1_tm(
    tran_code -- 交易码
    ,bus_cls_cd -- 业务分类代码
    ,a_calc_bal_stop_pay_flg -- 重新计算余额止付标志
    ,revs_tran_code -- 冲正交易码
    ,tran_code_descb -- 交易码描述
    ,cntpty_tran_code -- 对方交易码
    ,a_calc_lmt_amt_flg -- 重新计算限制金额标志
    ,revs_flg -- 冲正标志
    ,chn_id -- 渠道编号
    ,aval_bal_calc_type_cd -- 可用余额计算类型代码
    ,multi_revs_way_flg -- 多种冲正方式标志
    ,cash_tran_flg -- 现金交易标志
    ,cor_tran_flg -- 更正交易标志
    ,tran_cls_cd -- 交易分类代码
    ,debit_crdt_flg -- 借贷标志
    ,lp_id -- 法人编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.TRAN_TYPE -- 交易码
    ,'CL' -- 业务分类代码
    ,decode(trim(p1.RECALC_ACCT_STOP_PAY_FLAG),'','-','Y','1','N','0',p1.RECALC_ACCT_STOP_PAY_FLAG) -- 重新计算余额止付标志
    ,P1.REVERSAL_TRAN_TYPE -- 冲正交易码
    ,P1.TRAN_TYPE_DESC -- 交易码描述
    ,P1.OTH_TRAN_TYPE -- 对方交易码
    ,decode(trim(p1.RECALC_RES_AMT_FLAG),'','-','Y','1','N','0',p1.RECALC_RES_AMT_FLAG) -- 重新计算限制金额标志
    ,decode(trim(p1.REVERSAL_TRAN_FLAG),'','-','Y','1','N','0',p1.REVERSAL_TRAN_FLAG) -- 冲正标志
    ,P1.SOURCE_TYPE -- 渠道编号
    ,nvl(trim(P1.AVAILBAL_CALC_TYPE),'-') -- 可用余额计算类型代码
    ,decode(trim(p1.MULTI_RVS_TRAN_TYPE_FLAG),'','-','Y','1','N','0',p1.MULTI_RVS_TRAN_TYPE_FLAG) -- 多种冲正方式标志
    ,decode(trim(p1.CASH_TRAN_FLAG),'','-','Y','1','N','0',p1.CASH_TRAN_FLAG) -- 现金交易标志
    ,decode(trim(p1.CORRECT_FLAG),'','-','Y','1','N','0',p1.CORRECT_FLAG) -- 更正交易标志
    ,nvl(trim(nvl(trim(P1.TRAN_CLASS),'-')),'-') -- 交易分类代码
    ,DECODE(TRIM(P1.CR_DR_MAINT_IND),'','-','Y','1','N','0',P1.CR_DR_MAINT_IND)  -- 借贷标志
    ,'9999' -- 法人编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_tran_def' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_tran_def p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ncbs_tb_tran_def-1
insert into ${iml_schema}.ref_tran_code_para_ncbsf1_tm(
    tran_code -- 交易码
    ,bus_cls_cd -- 业务分类代码
    ,a_calc_bal_stop_pay_flg -- 重新计算余额止付标志
    ,revs_tran_code -- 冲正交易码
    ,tran_code_descb -- 交易码描述
    ,cntpty_tran_code -- 对方交易码
    ,a_calc_lmt_amt_flg -- 重新计算限制金额标志
    ,revs_flg -- 冲正标志
    ,chn_id -- 渠道编号
    ,aval_bal_calc_type_cd -- 可用余额计算类型代码
    ,multi_revs_way_flg -- 多种冲正方式标志
    ,cash_tran_flg -- 现金交易标志
    ,cor_tran_flg -- 更正交易标志
    ,tran_cls_cd -- 交易分类代码
    ,debit_crdt_flg -- 借贷标志
    ,lp_id -- 法人编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.TRAN_TYPE -- 交易码
    ,'TB' -- 业务分类代码
    ,decode(trim(p1.RECALC_ACCT_STOP_PAY_FLAG),'','-','Y','1','N','0',p1.RECALC_ACCT_STOP_PAY_FLAG) -- 重新计算余额止付标志
    ,P1.REVERSAL_TRAN_TYPE -- 冲正交易码
    ,P1.TRAN_TYPE_DESC -- 交易码描述
    ,P1.OTH_TRAN_TYPE -- 对方交易码
    ,decode(trim(p1.RECALC_RES_AMT_FLAG),'','-','Y','1','N','0',p1.RECALC_RES_AMT_FLAG) -- 重新计算限制金额标志
    ,decode(trim(p1.REVERSAL),'','-','Y','1','N','0',p1.REVERSAL) -- 冲正标志
    ,P1.SOURCE_TYPE -- 渠道编号
    ,nvl(trim(P1.AVAILBAL_CALC_TYPE),'-') -- 可用余额计算类型代码
    ,decode(trim(p1.MULTI_RVS_TRAN_TYPE_FLAG),'','-','Y','1','N','0',p1.MULTI_RVS_TRAN_TYPE_FLAG) -- 多种冲正方式标志
    ,decode(trim(p1.CASH_TRAN_FLAG),'','-','Y','1','N','0',p1.CASH_TRAN_FLAG) -- 现金交易标志
    ,decode(trim(p1.CORRECT_FLAG),'','-','Y','1','N','0',p1.CORRECT_FLAG) -- 更正交易标志
    ,nvl(trim(P1.TRAN_CLASS),'-') -- 交易分类代码
    ,DECODE(TRIM(P1.CR_DR_IND),'','-','Y','1','N','0',P1.CR_DR_IND)-- 借贷标志
    ,'9999' -- 法人编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_tb_tran_def' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_tb_tran_def p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_tran_code_para_ncbsf1_tm 
  	                                group by 
  	                                        tran_code
  	                                        ,bus_cls_cd
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
        into ${iml_schema}.ref_tran_code_para_ncbsf1_cl(
            tran_code -- 交易码
    ,bus_cls_cd -- 业务分类代码
    ,a_calc_bal_stop_pay_flg -- 重新计算余额止付标志
    ,revs_tran_code -- 冲正交易码
    ,tran_code_descb -- 交易码描述
    ,cntpty_tran_code -- 对方交易码
    ,a_calc_lmt_amt_flg -- 重新计算限制金额标志
    ,revs_flg -- 冲正标志
    ,chn_id -- 渠道编号
    ,aval_bal_calc_type_cd -- 可用余额计算类型代码
    ,multi_revs_way_flg -- 多种冲正方式标志
    ,cash_tran_flg -- 现金交易标志
    ,cor_tran_flg -- 更正交易标志
    ,tran_cls_cd -- 交易分类代码
    ,debit_crdt_flg -- 借贷标志
    ,lp_id -- 法人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_tran_code_para_ncbsf1_op(
            tran_code -- 交易码
    ,bus_cls_cd -- 业务分类代码
    ,a_calc_bal_stop_pay_flg -- 重新计算余额止付标志
    ,revs_tran_code -- 冲正交易码
    ,tran_code_descb -- 交易码描述
    ,cntpty_tran_code -- 对方交易码
    ,a_calc_lmt_amt_flg -- 重新计算限制金额标志
    ,revs_flg -- 冲正标志
    ,chn_id -- 渠道编号
    ,aval_bal_calc_type_cd -- 可用余额计算类型代码
    ,multi_revs_way_flg -- 多种冲正方式标志
    ,cash_tran_flg -- 现金交易标志
    ,cor_tran_flg -- 更正交易标志
    ,tran_cls_cd -- 交易分类代码
    ,debit_crdt_flg -- 借贷标志
    ,lp_id -- 法人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.bus_cls_cd, o.bus_cls_cd) as bus_cls_cd -- 业务分类代码
    ,nvl(n.a_calc_bal_stop_pay_flg, o.a_calc_bal_stop_pay_flg) as a_calc_bal_stop_pay_flg -- 重新计算余额止付标志
    ,nvl(n.revs_tran_code, o.revs_tran_code) as revs_tran_code -- 冲正交易码
    ,nvl(n.tran_code_descb, o.tran_code_descb) as tran_code_descb -- 交易码描述
    ,nvl(n.cntpty_tran_code, o.cntpty_tran_code) as cntpty_tran_code -- 对方交易码
    ,nvl(n.a_calc_lmt_amt_flg, o.a_calc_lmt_amt_flg) as a_calc_lmt_amt_flg -- 重新计算限制金额标志
    ,nvl(n.revs_flg, o.revs_flg) as revs_flg -- 冲正标志
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.aval_bal_calc_type_cd, o.aval_bal_calc_type_cd) as aval_bal_calc_type_cd -- 可用余额计算类型代码
    ,nvl(n.multi_revs_way_flg, o.multi_revs_way_flg) as multi_revs_way_flg -- 多种冲正方式标志
    ,nvl(n.cash_tran_flg, o.cash_tran_flg) as cash_tran_flg -- 现金交易标志
    ,nvl(n.cor_tran_flg, o.cor_tran_flg) as cor_tran_flg -- 更正交易标志
    ,nvl(n.tran_cls_cd, o.tran_cls_cd) as tran_cls_cd -- 交易分类代码
    ,nvl(n.debit_crdt_flg, o.debit_crdt_flg) as debit_crdt_flg -- 借贷标志
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,case when
            n.tran_code is null
            and n.bus_cls_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tran_code is null
            and n.bus_cls_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tran_code is null
            and n.bus_cls_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tran_code_para_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_tran_code_para_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.tran_code = n.tran_code
            and o.bus_cls_cd = n.bus_cls_cd
where (
        o.tran_code is null
        and o.bus_cls_cd is null
    )
    or (
        n.tran_code is null
        and n.bus_cls_cd is null
    )
    or (
        o.a_calc_bal_stop_pay_flg <> n.a_calc_bal_stop_pay_flg
        or o.revs_tran_code <> n.revs_tran_code
        or o.tran_code_descb <> n.tran_code_descb
        or o.cntpty_tran_code <> n.cntpty_tran_code
        or o.a_calc_lmt_amt_flg <> n.a_calc_lmt_amt_flg
        or o.revs_flg <> n.revs_flg
        or o.chn_id <> n.chn_id
        or o.aval_bal_calc_type_cd <> n.aval_bal_calc_type_cd
        or o.multi_revs_way_flg <> n.multi_revs_way_flg
        or o.cash_tran_flg <> n.cash_tran_flg
        or o.cor_tran_flg <> n.cor_tran_flg
        or o.tran_cls_cd <> n.tran_cls_cd
        or o.debit_crdt_flg <> n.debit_crdt_flg
        or o.lp_id <> n.lp_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_tran_code_para_ncbsf1_cl(
            tran_code -- 交易码
    ,bus_cls_cd -- 业务分类代码
    ,a_calc_bal_stop_pay_flg -- 重新计算余额止付标志
    ,revs_tran_code -- 冲正交易码
    ,tran_code_descb -- 交易码描述
    ,cntpty_tran_code -- 对方交易码
    ,a_calc_lmt_amt_flg -- 重新计算限制金额标志
    ,revs_flg -- 冲正标志
    ,chn_id -- 渠道编号
    ,aval_bal_calc_type_cd -- 可用余额计算类型代码
    ,multi_revs_way_flg -- 多种冲正方式标志
    ,cash_tran_flg -- 现金交易标志
    ,cor_tran_flg -- 更正交易标志
    ,tran_cls_cd -- 交易分类代码
    ,debit_crdt_flg -- 借贷标志
    ,lp_id -- 法人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_tran_code_para_ncbsf1_op(
            tran_code -- 交易码
    ,bus_cls_cd -- 业务分类代码
    ,a_calc_bal_stop_pay_flg -- 重新计算余额止付标志
    ,revs_tran_code -- 冲正交易码
    ,tran_code_descb -- 交易码描述
    ,cntpty_tran_code -- 对方交易码
    ,a_calc_lmt_amt_flg -- 重新计算限制金额标志
    ,revs_flg -- 冲正标志
    ,chn_id -- 渠道编号
    ,aval_bal_calc_type_cd -- 可用余额计算类型代码
    ,multi_revs_way_flg -- 多种冲正方式标志
    ,cash_tran_flg -- 现金交易标志
    ,cor_tran_flg -- 更正交易标志
    ,tran_cls_cd -- 交易分类代码
    ,debit_crdt_flg -- 借贷标志
    ,lp_id -- 法人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tran_code -- 交易码
    ,o.bus_cls_cd -- 业务分类代码
    ,o.a_calc_bal_stop_pay_flg -- 重新计算余额止付标志
    ,o.revs_tran_code -- 冲正交易码
    ,o.tran_code_descb -- 交易码描述
    ,o.cntpty_tran_code -- 对方交易码
    ,o.a_calc_lmt_amt_flg -- 重新计算限制金额标志
    ,o.revs_flg -- 冲正标志
    ,o.chn_id -- 渠道编号
    ,o.aval_bal_calc_type_cd -- 可用余额计算类型代码
    ,o.multi_revs_way_flg -- 多种冲正方式标志
    ,o.cash_tran_flg -- 现金交易标志
    ,o.cor_tran_flg -- 更正交易标志
    ,o.tran_cls_cd -- 交易分类代码
    ,o.debit_crdt_flg -- 借贷标志
    ,o.lp_id -- 法人编号
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
from ${iml_schema}.ref_tran_code_para_ncbsf1_bk o
    left join ${iml_schema}.ref_tran_code_para_ncbsf1_op n
        on
            o.tran_code = n.tran_code
            and o.bus_cls_cd = n.bus_cls_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_tran_code_para_ncbsf1_cl d
        on
            o.tran_code = d.tran_code
            and o.bus_cls_cd = d.bus_cls_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_tran_code_para;
--alter table ${iml_schema}.ref_tran_code_para truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_tran_code_para') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_tran_code_para drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_tran_code_para modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_tran_code_para exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.ref_tran_code_para_ncbsf1_cl;
alter table ${iml_schema}.ref_tran_code_para exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_tran_code_para_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_tran_code_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_tran_code_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_tran_code_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_tran_code_para_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_tran_code_para_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_tran_code_para', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
