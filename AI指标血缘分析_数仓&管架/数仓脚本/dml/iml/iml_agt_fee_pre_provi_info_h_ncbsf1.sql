/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_fee_pre_provi_info_h_ncbsf1
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
alter table ${iml_schema}.agt_fee_pre_provi_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fee_pre_provi_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pre_provi_amort_id -- 预提摊销编号
    ,pre_provi_dt -- 预提日期
    ,pre_provi_status_cd -- 预提状态代码
    ,subj_id -- 科目编号
    ,fee_rat_cd -- 费率代码
    ,td_pre_provi_amt -- 当日预提金额
    ,pre_provi_tot_amt -- 预提总金额
    ,acm_aldy_pre_provi_amt -- 累计已预提金额
    ,expns_amt -- 可支出金额
    ,aldy_expns_amt -- 已支出金额
    ,provi_amt_bal -- 计提金额差额
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_day -- 摊销日
    ,amort_mon -- 摊销月
    ,add_acct_dt -- 补账日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,oper_dt -- 操作日期
    ,oper_teller_id -- 操作柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,org_id -- 机构编号
    ,init_bus_id -- 原业务编号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,int_heavy_begin_dt -- 利息重算起始日期
    ,heavy_int_tot_amt -- 重算利息总金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cntpty_bus_id -- 对手业务编号
    ,CNTPTY_TYPE_CD -- 交易对手客户类型代码
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fee_pre_provi_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fee_pre_provi_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fee_pre_provi_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_serv_pre_accr-1
insert into ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pre_provi_amort_id -- 预提摊销编号
    ,pre_provi_dt -- 预提日期
    ,pre_provi_status_cd -- 预提状态代码
    ,subj_id -- 科目编号
    ,fee_rat_cd -- 费率代码
    ,td_pre_provi_amt -- 当日预提金额
    ,pre_provi_tot_amt -- 预提总金额
    ,acm_aldy_pre_provi_amt -- 累计已预提金额
    ,expns_amt -- 可支出金额
    ,aldy_expns_amt -- 已支出金额
    ,provi_amt_bal -- 计提金额差额
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_day -- 摊销日
    ,amort_mon -- 摊销月
    ,add_acct_dt -- 补账日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,oper_dt -- 操作日期
    ,oper_teller_id -- 操作柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,org_id -- 机构编号
    ,init_bus_id -- 原业务编号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,int_heavy_begin_dt -- 利息重算起始日期
    ,heavy_int_tot_amt -- 重算利息总金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cntpty_bus_id -- 对手业务编号
    ,CNTPTY_TYPE_CD -- 交易对手客户类型代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300060'||P1.PRE_ACCR_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PRE_ACCR_NO -- 预提摊销编号
    ,P1.PRE_ACCR_DATE -- 预提日期
    ,nvl(trim(P1.PRE_ACCR_STATUS),'-') -- 预提状态代码
    ,P1.GL_CODE -- 科目编号
    ,nvl(trim(P1.FEE_TYPE),'-') -- 费率代码
    ,P1.CUR_PRE_ACCR_AMT -- 当日预提金额
    ,P1.TOTAL_PRE_ACCR_AMT -- 预提总金额
    ,P1.AGG_PRE_ACCR_AMT -- 累计已预提金额
    ,P1.CAN_PAY_ACCR_AMT -- 可支出金额
    ,P1.PAID_PRE_ACCR_AMT -- 已支出金额
    ,P1.INT_ACCRUED_DIFF -- 计提金额差额
    ,nvl(trim(P1.AMORTIZE_PERIOD_TYPE),'-') -- 摊销期限类型代码
    ,to_number(nvl(trim(P1.AMORTIZE_DAY),'0')) -- 摊销日
    ,to_number(nvl(trim(P1.AMORTIZE_MONTH),'0')) -- 摊销月
    ,P1.SUPPLEMENT_DATE -- 补账日期
    ,P1.START_DATE -- 生效日期
    ,P1.END_DATE -- 失效日期
    ,P1.OPER_DATE -- 操作日期
    ,P1.OPER_USER_ID -- 操作柜员编号
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.BRANCH -- 机构编号
    ,P1.EXT_TRADE_NO -- 原业务编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.REFERENCE -- 交易参考号
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,P1.RECALC_START_DATE -- 利息重算起始日期
    ,P1.RECALC_INT_AMT -- 重算利息总金额
    ,P1.ACCT_EXEC -- 客户经理编号
    ,P1.ACCT_EXEC_NAME -- 客户经理姓名
    ,P1.OTH_CLIENT_NO -- 对手客户编号
    ,P1.OTH_CLIENT_NAME -- 对手客户名称
    ,P1.OTH_BUSINESS_NO -- 对手业务编号
    ,nvl(trim(P1.OTH_CLIENT_TYPE),'-') -- 交易对手客户类型代码
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_serv_pre_accr' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_serv_pre_accr p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_tm 
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
        into ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pre_provi_amort_id -- 预提摊销编号
    ,pre_provi_dt -- 预提日期
    ,pre_provi_status_cd -- 预提状态代码
    ,subj_id -- 科目编号
    ,fee_rat_cd -- 费率代码
    ,td_pre_provi_amt -- 当日预提金额
    ,pre_provi_tot_amt -- 预提总金额
    ,acm_aldy_pre_provi_amt -- 累计已预提金额
    ,expns_amt -- 可支出金额
    ,aldy_expns_amt -- 已支出金额
    ,provi_amt_bal -- 计提金额差额
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_day -- 摊销日
    ,amort_mon -- 摊销月
    ,add_acct_dt -- 补账日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,oper_dt -- 操作日期
    ,oper_teller_id -- 操作柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,org_id -- 机构编号
    ,init_bus_id -- 原业务编号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,int_heavy_begin_dt -- 利息重算起始日期
    ,heavy_int_tot_amt -- 重算利息总金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cntpty_bus_id -- 对手业务编号
    ,CNTPTY_TYPE_CD -- 交易对手客户类型代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pre_provi_amort_id -- 预提摊销编号
    ,pre_provi_dt -- 预提日期
    ,pre_provi_status_cd -- 预提状态代码
    ,subj_id -- 科目编号
    ,fee_rat_cd -- 费率代码
    ,td_pre_provi_amt -- 当日预提金额
    ,pre_provi_tot_amt -- 预提总金额
    ,acm_aldy_pre_provi_amt -- 累计已预提金额
    ,expns_amt -- 可支出金额
    ,aldy_expns_amt -- 已支出金额
    ,provi_amt_bal -- 计提金额差额
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_day -- 摊销日
    ,amort_mon -- 摊销月
    ,add_acct_dt -- 补账日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,oper_dt -- 操作日期
    ,oper_teller_id -- 操作柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,org_id -- 机构编号
    ,init_bus_id -- 原业务编号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,int_heavy_begin_dt -- 利息重算起始日期
    ,heavy_int_tot_amt -- 重算利息总金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cntpty_bus_id -- 对手业务编号
    ,CNTPTY_TYPE_CD -- 交易对手客户类型代码
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
    ,nvl(n.pre_provi_amort_id, o.pre_provi_amort_id) as pre_provi_amort_id -- 预提摊销编号
    ,nvl(n.pre_provi_dt, o.pre_provi_dt) as pre_provi_dt -- 预提日期
    ,nvl(n.pre_provi_status_cd, o.pre_provi_status_cd) as pre_provi_status_cd -- 预提状态代码
    ,nvl(n.subj_id, o.subj_id) as subj_id -- 科目编号
    ,nvl(n.fee_rat_cd, o.fee_rat_cd) as fee_rat_cd -- 费率代码
    ,nvl(n.td_pre_provi_amt, o.td_pre_provi_amt) as td_pre_provi_amt -- 当日预提金额
    ,nvl(n.pre_provi_tot_amt, o.pre_provi_tot_amt) as pre_provi_tot_amt -- 预提总金额
    ,nvl(n.acm_aldy_pre_provi_amt, o.acm_aldy_pre_provi_amt) as acm_aldy_pre_provi_amt -- 累计已预提金额
    ,nvl(n.expns_amt, o.expns_amt) as expns_amt -- 可支出金额
    ,nvl(n.aldy_expns_amt, o.aldy_expns_amt) as aldy_expns_amt -- 已支出金额
    ,nvl(n.provi_amt_bal, o.provi_amt_bal) as provi_amt_bal -- 计提金额差额
    ,nvl(n.amort_tenor_type_cd, o.amort_tenor_type_cd) as amort_tenor_type_cd -- 摊销期限类型代码
    ,nvl(n.amort_day, o.amort_day) as amort_day -- 摊销日
    ,nvl(n.amort_mon, o.amort_mon) as amort_mon -- 摊销月
    ,nvl(n.add_acct_dt, o.add_acct_dt) as add_acct_dt -- 补账日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 操作日期
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 操作柜员编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.init_bus_id, o.init_bus_id) as init_bus_id -- 原业务编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.int_heavy_begin_dt, o.int_heavy_begin_dt) as int_heavy_begin_dt -- 利息重算起始日期
    ,nvl(n.heavy_int_tot_amt, o.heavy_int_tot_amt) as heavy_int_tot_amt -- 重算利息总金额
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.cust_mgr_name, o.cust_mgr_name) as cust_mgr_name -- 客户经理姓名
    ,nvl(n.cntpty_cust_id, o.cntpty_cust_id) as cntpty_cust_id -- 对手客户编号
    ,nvl(n.cntpty_cust_name, o.cntpty_cust_name) as cntpty_cust_name -- 对手客户名称
    ,nvl(n.cntpty_bus_id, o.cntpty_bus_id) as cntpty_bus_id -- 对手业务编号
    ,nvl(n.CNTPTY_TYPE_CD, o.CNTPTY_TYPE_CD) as CNTPTY_TYPE_CD -- 交易对手客户类型代码
    ,nvl(n.remark, o.remark) as remark -- 备注
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
from ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.pre_provi_amort_id <> n.pre_provi_amort_id
        or o.pre_provi_dt <> n.pre_provi_dt
        or o.pre_provi_status_cd <> n.pre_provi_status_cd
        or o.subj_id <> n.subj_id
        or o.fee_rat_cd <> n.fee_rat_cd
        or o.td_pre_provi_amt <> n.td_pre_provi_amt
        or o.pre_provi_tot_amt <> n.pre_provi_tot_amt
        or o.acm_aldy_pre_provi_amt <> n.acm_aldy_pre_provi_amt
        or o.expns_amt <> n.expns_amt
        or o.aldy_expns_amt <> n.aldy_expns_amt
        or o.provi_amt_bal <> n.provi_amt_bal
        or o.amort_tenor_type_cd <> n.amort_tenor_type_cd
        or o.amort_day <> n.amort_day
        or o.amort_mon <> n.amort_mon
        or o.add_acct_dt <> n.add_acct_dt
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.oper_dt <> n.oper_dt
        or o.oper_teller_id <> n.oper_teller_id
        or o.auth_teller_id <> n.auth_teller_id
        or o.org_id <> n.org_id
        or o.init_bus_id <> n.init_bus_id
        or o.cust_id <> n.cust_id
        or o.tran_ref_no <> n.tran_ref_no
        or o.curr_cd <> n.curr_cd
        or o.int_heavy_begin_dt <> n.int_heavy_begin_dt
        or o.heavy_int_tot_amt <> n.heavy_int_tot_amt
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.cust_mgr_name <> n.cust_mgr_name
        or o.cntpty_cust_id <> n.cntpty_cust_id
        or o.cntpty_cust_name <> n.cntpty_cust_name
        or o.cntpty_bus_id <> n.cntpty_bus_id
        or o.CNTPTY_TYPE_CD <> n.CNTPTY_TYPE_CD
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pre_provi_amort_id -- 预提摊销编号
    ,pre_provi_dt -- 预提日期
    ,pre_provi_status_cd -- 预提状态代码
    ,subj_id -- 科目编号
    ,fee_rat_cd -- 费率代码
    ,td_pre_provi_amt -- 当日预提金额
    ,pre_provi_tot_amt -- 预提总金额
    ,acm_aldy_pre_provi_amt -- 累计已预提金额
    ,expns_amt -- 可支出金额
    ,aldy_expns_amt -- 已支出金额
    ,provi_amt_bal -- 计提金额差额
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_day -- 摊销日
    ,amort_mon -- 摊销月
    ,add_acct_dt -- 补账日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,oper_dt -- 操作日期
    ,oper_teller_id -- 操作柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,org_id -- 机构编号
    ,init_bus_id -- 原业务编号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,int_heavy_begin_dt -- 利息重算起始日期
    ,heavy_int_tot_amt -- 重算利息总金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cntpty_bus_id -- 对手业务编号
    ,CNTPTY_TYPE_CD -- 交易对手客户类型代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pre_provi_amort_id -- 预提摊销编号
    ,pre_provi_dt -- 预提日期
    ,pre_provi_status_cd -- 预提状态代码
    ,subj_id -- 科目编号
    ,fee_rat_cd -- 费率代码
    ,td_pre_provi_amt -- 当日预提金额
    ,pre_provi_tot_amt -- 预提总金额
    ,acm_aldy_pre_provi_amt -- 累计已预提金额
    ,expns_amt -- 可支出金额
    ,aldy_expns_amt -- 已支出金额
    ,provi_amt_bal -- 计提金额差额
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_day -- 摊销日
    ,amort_mon -- 摊销月
    ,add_acct_dt -- 补账日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,oper_dt -- 操作日期
    ,oper_teller_id -- 操作柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,org_id -- 机构编号
    ,init_bus_id -- 原业务编号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,int_heavy_begin_dt -- 利息重算起始日期
    ,heavy_int_tot_amt -- 重算利息总金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cntpty_bus_id -- 对手业务编号
    ,CNTPTY_TYPE_CD -- 交易对手客户类型代码
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
    ,o.pre_provi_amort_id -- 预提摊销编号
    ,o.pre_provi_dt -- 预提日期
    ,o.pre_provi_status_cd -- 预提状态代码
    ,o.subj_id -- 科目编号
    ,o.fee_rat_cd -- 费率代码
    ,o.td_pre_provi_amt -- 当日预提金额
    ,o.pre_provi_tot_amt -- 预提总金额
    ,o.acm_aldy_pre_provi_amt -- 累计已预提金额
    ,o.expns_amt -- 可支出金额
    ,o.aldy_expns_amt -- 已支出金额
    ,o.provi_amt_bal -- 计提金额差额
    ,o.amort_tenor_type_cd -- 摊销期限类型代码
    ,o.amort_day -- 摊销日
    ,o.amort_mon -- 摊销月
    ,o.add_acct_dt -- 补账日期
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.oper_dt -- 操作日期
    ,o.oper_teller_id -- 操作柜员编号
    ,o.auth_teller_id -- 授权柜员编号
    ,o.org_id -- 机构编号
    ,o.init_bus_id -- 原业务编号
    ,o.cust_id -- 客户编号
    ,o.tran_ref_no -- 交易参考号
    ,o.curr_cd -- 币种代码
    ,o.int_heavy_begin_dt -- 利息重算起始日期
    ,o.heavy_int_tot_amt -- 重算利息总金额
    ,o.cust_mgr_id -- 客户经理编号
    ,o.cust_mgr_name -- 客户经理姓名
    ,o.cntpty_cust_id -- 对手客户编号
    ,o.cntpty_cust_name -- 对手客户名称
    ,o.cntpty_bus_id -- 对手业务编号
    ,o.CNTPTY_TYPE_CD -- 交易对手客户类型代码
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
from ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_cl d
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
--truncate table ${iml_schema}.agt_fee_pre_provi_info_h;
--alter table ${iml_schema}.agt_fee_pre_provi_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_fee_pre_provi_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_fee_pre_provi_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_fee_pre_provi_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_fee_pre_provi_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_fee_pre_provi_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_fee_pre_provi_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_fee_pre_provi_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_fee_pre_provi_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
