/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_fee_provi_dtl_ncbsf1
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
alter table ${iml_schema}.agt_fee_provi_dtl add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fee_provi_dtl partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_tm purge;
drop table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_op purge;
drop table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,provi_flow_num -- 计提流水号
    ,tran_ref_no -- 交易参考号
    ,init_bus_id -- 原业务编号
    ,tran_dt -- 交易日期
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,provi_status_cd -- 计提状态代码
    ,provi_fee_type_cd -- 计提费用类型代码
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,provi_dt -- 计提日期
    ,provi_int -- 计提利息
    ,provi_day_actl_provi_amt -- 计提日实际计提金额
    ,provi_amt_bal -- 计提金额差额
    ,freq_cd -- 频率代码
    ,acm_provi_amt -- 累计计提金额
    ,wrt_off_int -- 核销利息
    ,int_a_calc_start_dt -- 利息重算开始日期
    ,a_calc_int_tot_amt -- 重算利息总金额
    ,next_provi_dt -- 下一计提日期
    ,cntpty_bus_id -- 对手业务编号
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理名称
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,core_tran_org_id -- 核心交易机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fee_provi_dtl partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fee_provi_dtl partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fee_provi_dtl partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_fee_int_detail-1
insert into ${iml_schema}.agt_fee_provi_dtl_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,provi_flow_num -- 计提流水号
    ,tran_ref_no -- 交易参考号
    ,init_bus_id -- 原业务编号
    ,tran_dt -- 交易日期
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,provi_status_cd -- 计提状态代码
    ,provi_fee_type_cd -- 计提费用类型代码
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,provi_dt -- 计提日期
    ,provi_int -- 计提利息
    ,provi_day_actl_provi_amt -- 计提日实际计提金额
    ,provi_amt_bal -- 计提金额差额
    ,freq_cd -- 频率代码
    ,acm_provi_amt -- 累计计提金额
    ,wrt_off_int -- 核销利息
    ,int_a_calc_start_dt -- 利息重算开始日期
    ,a_calc_int_tot_amt -- 重算利息总金额
    ,next_provi_dt -- 下一计提日期
    ,cntpty_bus_id -- 对手业务编号
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理名称
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,core_tran_org_id -- 核心交易机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300057'||P1.FEE_INT_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.FEE_INT_NO -- 计提流水号
    ,P1.REFERENCE -- 交易参考号
    ,P1.EXT_TRADE_NO -- 原业务编号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.CCY -- 币种代码
    ,P1.INT_AMT -- 利息金额
    ,nvl(trim(P1.STATUS),'-') -- 计提状态代码
    ,nvl(trim(P1.FEE_TYPE),'-') -- 计提费用类型代码
    ,P1.START_ACCRUAL_DATE -- 计提开始日期
    ,P1.END_ACCRUAL_DATE -- 计提结束日期
    ,P1.ACCR_DATE -- 计提日期
    ,P1.INT_ACCR -- 计提利息
    ,P1.INT_ACCRUED_CALC_CTD -- 计提日实际计提金额
    ,P1.INT_ACCRUED_DIFF -- 计提金额差额
    ,nvl(trim(P1.FREQ_TYPE),'-') -- 频率代码
    ,P1.INT_ACCRUED -- 累计计提金额
    ,P1.WRITE_OFF_INT_AMT -- 核销利息
    ,P1.RECALC_START_DATE -- 利息重算开始日期
    ,P1.RECALC_INT_AMT -- 重算利息总金额
    ,P1.NEXT_ACCR_DATE -- 下一计提日期
    ,P1.OTH_BUSINESS_NO -- 对手业务编号
    ,P1.OTH_CLIENT_NO -- 对手客户编号
    ,P1.OTH_CLIENT_NAME -- 对手客户名称
    ,P1.ACCT_EXEC -- 客户经理编号
    ,P1.ACCT_EXEC_NAME -- 客户经理名称
    ,${iml_schema}.timeformat_max2(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.USER_ID -- 交易柜员编号
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.TRAN_BRANCH -- 核心交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_fee_int_detail' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_fee_int_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_fee_provi_dtl_ncbsf1_tm 
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
        into ${iml_schema}.agt_fee_provi_dtl_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,provi_flow_num -- 计提流水号
    ,tran_ref_no -- 交易参考号
    ,init_bus_id -- 原业务编号
    ,tran_dt -- 交易日期
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,provi_status_cd -- 计提状态代码
    ,provi_fee_type_cd -- 计提费用类型代码
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,provi_dt -- 计提日期
    ,provi_int -- 计提利息
    ,provi_day_actl_provi_amt -- 计提日实际计提金额
    ,provi_amt_bal -- 计提金额差额
    ,freq_cd -- 频率代码
    ,acm_provi_amt -- 累计计提金额
    ,wrt_off_int -- 核销利息
    ,int_a_calc_start_dt -- 利息重算开始日期
    ,a_calc_int_tot_amt -- 重算利息总金额
    ,next_provi_dt -- 下一计提日期
    ,cntpty_bus_id -- 对手业务编号
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理名称
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,core_tran_org_id -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_fee_provi_dtl_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,provi_flow_num -- 计提流水号
    ,tran_ref_no -- 交易参考号
    ,init_bus_id -- 原业务编号
    ,tran_dt -- 交易日期
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,provi_status_cd -- 计提状态代码
    ,provi_fee_type_cd -- 计提费用类型代码
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,provi_dt -- 计提日期
    ,provi_int -- 计提利息
    ,provi_day_actl_provi_amt -- 计提日实际计提金额
    ,provi_amt_bal -- 计提金额差额
    ,freq_cd -- 频率代码
    ,acm_provi_amt -- 累计计提金额
    ,wrt_off_int -- 核销利息
    ,int_a_calc_start_dt -- 利息重算开始日期
    ,a_calc_int_tot_amt -- 重算利息总金额
    ,next_provi_dt -- 下一计提日期
    ,cntpty_bus_id -- 对手业务编号
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理名称
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
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
    ,nvl(n.provi_flow_num, o.provi_flow_num) as provi_flow_num -- 计提流水号
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.init_bus_id, o.init_bus_id) as init_bus_id -- 原业务编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.provi_status_cd, o.provi_status_cd) as provi_status_cd -- 计提状态代码
    ,nvl(n.provi_fee_type_cd, o.provi_fee_type_cd) as provi_fee_type_cd -- 计提费用类型代码
    ,nvl(n.provi_start_dt, o.provi_start_dt) as provi_start_dt -- 计提开始日期
    ,nvl(n.provi_end_dt, o.provi_end_dt) as provi_end_dt -- 计提结束日期
    ,nvl(n.provi_dt, o.provi_dt) as provi_dt -- 计提日期
    ,nvl(n.provi_int, o.provi_int) as provi_int -- 计提利息
    ,nvl(n.provi_day_actl_provi_amt, o.provi_day_actl_provi_amt) as provi_day_actl_provi_amt -- 计提日实际计提金额
    ,nvl(n.provi_amt_bal, o.provi_amt_bal) as provi_amt_bal -- 计提金额差额
    ,nvl(n.freq_cd, o.freq_cd) as freq_cd -- 频率代码
    ,nvl(n.acm_provi_amt, o.acm_provi_amt) as acm_provi_amt -- 累计计提金额
    ,nvl(n.wrt_off_int, o.wrt_off_int) as wrt_off_int -- 核销利息
    ,nvl(n.int_a_calc_start_dt, o.int_a_calc_start_dt) as int_a_calc_start_dt -- 利息重算开始日期
    ,nvl(n.a_calc_int_tot_amt, o.a_calc_int_tot_amt) as a_calc_int_tot_amt -- 重算利息总金额
    ,nvl(n.next_provi_dt, o.next_provi_dt) as next_provi_dt -- 下一计提日期
    ,nvl(n.cntpty_bus_id, o.cntpty_bus_id) as cntpty_bus_id -- 对手业务编号
    ,nvl(n.cntpty_cust_id, o.cntpty_cust_id) as cntpty_cust_id -- 对手客户编号
    ,nvl(n.cntpty_cust_name, o.cntpty_cust_name) as cntpty_cust_name -- 对手客户名称
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.cust_mgr_name, o.cust_mgr_name) as cust_mgr_name -- 客户经理名称
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
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
from ${iml_schema}.agt_fee_provi_dtl_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_fee_provi_dtl_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.provi_flow_num <> n.provi_flow_num
        or o.tran_ref_no <> n.tran_ref_no
        or o.init_bus_id <> n.init_bus_id
        or o.tran_dt <> n.tran_dt
        or o.curr_cd <> n.curr_cd
        or o.int_amt <> n.int_amt
        or o.provi_status_cd <> n.provi_status_cd
        or o.provi_fee_type_cd <> n.provi_fee_type_cd
        or o.provi_start_dt <> n.provi_start_dt
        or o.provi_end_dt <> n.provi_end_dt
        or o.provi_dt <> n.provi_dt
        or o.provi_int <> n.provi_int
        or o.provi_day_actl_provi_amt <> n.provi_day_actl_provi_amt
        or o.provi_amt_bal <> n.provi_amt_bal
        or o.freq_cd <> n.freq_cd
        or o.acm_provi_amt <> n.acm_provi_amt
        or o.wrt_off_int <> n.wrt_off_int
        or o.int_a_calc_start_dt <> n.int_a_calc_start_dt
        or o.a_calc_int_tot_amt <> n.a_calc_int_tot_amt
        or o.next_provi_dt <> n.next_provi_dt
        or o.cntpty_bus_id <> n.cntpty_bus_id
        or o.cntpty_cust_id <> n.cntpty_cust_id
        or o.cntpty_cust_name <> n.cntpty_cust_name
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.cust_mgr_name <> n.cust_mgr_name
        or o.tran_tm <> n.tran_tm
        or o.tran_teller_id <> n.tran_teller_id
        or o.auth_teller_id <> n.auth_teller_id
        or o.core_tran_org_id <> n.core_tran_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_fee_provi_dtl_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,provi_flow_num -- 计提流水号
    ,tran_ref_no -- 交易参考号
    ,init_bus_id -- 原业务编号
    ,tran_dt -- 交易日期
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,provi_status_cd -- 计提状态代码
    ,provi_fee_type_cd -- 计提费用类型代码
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,provi_dt -- 计提日期
    ,provi_int -- 计提利息
    ,provi_day_actl_provi_amt -- 计提日实际计提金额
    ,provi_amt_bal -- 计提金额差额
    ,freq_cd -- 频率代码
    ,acm_provi_amt -- 累计计提金额
    ,wrt_off_int -- 核销利息
    ,int_a_calc_start_dt -- 利息重算开始日期
    ,a_calc_int_tot_amt -- 重算利息总金额
    ,next_provi_dt -- 下一计提日期
    ,cntpty_bus_id -- 对手业务编号
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理名称
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,core_tran_org_id -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_fee_provi_dtl_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,provi_flow_num -- 计提流水号
    ,tran_ref_no -- 交易参考号
    ,init_bus_id -- 原业务编号
    ,tran_dt -- 交易日期
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,provi_status_cd -- 计提状态代码
    ,provi_fee_type_cd -- 计提费用类型代码
    ,provi_start_dt -- 计提开始日期
    ,provi_end_dt -- 计提结束日期
    ,provi_dt -- 计提日期
    ,provi_int -- 计提利息
    ,provi_day_actl_provi_amt -- 计提日实际计提金额
    ,provi_amt_bal -- 计提金额差额
    ,freq_cd -- 频率代码
    ,acm_provi_amt -- 累计计提金额
    ,wrt_off_int -- 核销利息
    ,int_a_calc_start_dt -- 利息重算开始日期
    ,a_calc_int_tot_amt -- 重算利息总金额
    ,next_provi_dt -- 下一计提日期
    ,cntpty_bus_id -- 对手业务编号
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理名称
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
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
    ,o.provi_flow_num -- 计提流水号
    ,o.tran_ref_no -- 交易参考号
    ,o.init_bus_id -- 原业务编号
    ,o.tran_dt -- 交易日期
    ,o.curr_cd -- 币种代码
    ,o.int_amt -- 利息金额
    ,o.provi_status_cd -- 计提状态代码
    ,o.provi_fee_type_cd -- 计提费用类型代码
    ,o.provi_start_dt -- 计提开始日期
    ,o.provi_end_dt -- 计提结束日期
    ,o.provi_dt -- 计提日期
    ,o.provi_int -- 计提利息
    ,o.provi_day_actl_provi_amt -- 计提日实际计提金额
    ,o.provi_amt_bal -- 计提金额差额
    ,o.freq_cd -- 频率代码
    ,o.acm_provi_amt -- 累计计提金额
    ,o.wrt_off_int -- 核销利息
    ,o.int_a_calc_start_dt -- 利息重算开始日期
    ,o.a_calc_int_tot_amt -- 重算利息总金额
    ,o.next_provi_dt -- 下一计提日期
    ,o.cntpty_bus_id -- 对手业务编号
    ,o.cntpty_cust_id -- 对手客户编号
    ,o.cntpty_cust_name -- 对手客户名称
    ,o.cust_mgr_id -- 客户经理编号
    ,o.cust_mgr_name -- 客户经理名称
    ,o.tran_tm -- 交易时间
    ,o.tran_teller_id -- 交易柜员编号
    ,o.auth_teller_id -- 授权柜员编号
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
from ${iml_schema}.agt_fee_provi_dtl_ncbsf1_bk o
    left join ${iml_schema}.agt_fee_provi_dtl_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_fee_provi_dtl_ncbsf1_cl d
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
--truncate table ${iml_schema}.agt_fee_provi_dtl;
--alter table ${iml_schema}.agt_fee_provi_dtl truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_fee_provi_dtl') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_fee_provi_dtl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_fee_provi_dtl modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_fee_provi_dtl exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_cl;
alter table ${iml_schema}.agt_fee_provi_dtl exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_fee_provi_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_tm purge;
drop table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_op purge;
drop table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_fee_provi_dtl_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_fee_provi_dtl', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
