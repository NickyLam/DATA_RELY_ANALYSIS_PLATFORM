/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_jd_repay_plan_h_jdjri1
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
alter table ${iml_schema}.agt_jd_repay_plan_h add partition p_jdjri1 values ('jdjri1')(
        subpartition p_jdjri1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_jdjri1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_jd_repay_plan_h partition for ('jdjri1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_tm purge;
drop table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_op purge;
drop table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,jd_prod_cd -- 京东产品代码
    ,cust_lmt_id -- 客户额度编号
    ,dubil_id -- 借据编号
    ,inst_odd_no -- 分期单号
    ,repay_perds -- 还款期数
    ,init_repay_perds -- 原还款期数
    ,pric_exp_dt -- 本金到期日期
    ,rpbl_pric_bal -- 应还本金
    ,int_exp_dt -- 利息到期日期
    ,rpbl_int_bal -- 应还利息
    ,repay_tot_perds -- 还款总期数
    ,rpbl_pnlt_bal -- 应还罚息
    ,inst_exec_int_rat -- 执行利率
    ,perds_type_cd -- 期数类型代码
    ,ovdue_days -- 贷款逾期天数
    ,last_day_ovdue_days -- 前一天逾期天数
    ,last_day_ovdue_status_cd -- 前一天逾期状态代码
    ,curr_ovdue_days -- 当前逾期天数
    ,curr_ovdue_status_cd -- 当前逾期状态代码
    ,repay_modif_status_cd -- 还款变更状态代码
    ,penalty -- 违约金
    ,prod_id -- 产品编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_jd_repay_plan_h partition for ('jdjri1')
where 0=1
;

create table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_jd_repay_plan_h partition for ('jdjri1') where 0=1;

create table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_jd_repay_plan_h partition for ('jdjri1') where 0=1;

-- 3.1 get new data into table
-- icms_jdjr_repay_plan-
insert into ${iml_schema}.agt_jd_repay_plan_h_jdjri1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,jd_prod_cd -- 京东产品代码
    ,cust_lmt_id -- 客户额度编号
    ,dubil_id -- 借据编号
    ,inst_odd_no -- 分期单号
    ,repay_perds -- 还款期数
    ,init_repay_perds -- 原还款期数
    ,pric_exp_dt -- 本金到期日期
    ,rpbl_pric_bal -- 应还本金
    ,int_exp_dt -- 利息到期日期
    ,rpbl_int_bal -- 应还利息
    ,repay_tot_perds -- 还款总期数
    ,rpbl_pnlt_bal -- 应还罚息
    ,inst_exec_int_rat -- 执行利率
    ,perds_type_cd -- 期数类型代码
    ,ovdue_days -- 贷款逾期天数
    ,last_day_ovdue_days -- 前一天逾期天数
    ,last_day_ovdue_status_cd -- 前一天逾期状态代码
    ,curr_ovdue_days -- 当前逾期天数
    ,curr_ovdue_status_cd -- 当前逾期状态代码
    ,repay_modif_status_cd -- 还款变更状态代码
    ,penalty -- 违约金
    ,prod_id -- 产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222304'||P1.CONTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CONTNO -- 合同编号
    ,P1.PRDNO -- 京东产品代码
    ,P1.LIMITNO -- 客户额度编号
    ,P1.LOANNO -- 借据编号
    ,P1.TERMNO -- 分期单号
    ,case when p1.REPAYCHANGETYPE = '4' then 0 
     else row_number() over(partition by P1.CONTNO,case when p1.REPAYCHANGETYPE = '4' then null else 1 end order by p1.INTREPAYDT)
end -- 还款期数
    ,P1.REPAYTERMNO -- 原还款期数
    ,${iml_schema}.dateformat_max2(trim(P1.PRINREPAYDT)) -- 本金到期日期
    ,P1.PRINREPAYBALANCE -- 应还本金
    ,${iml_schema}.dateformat_max2(trim(P1.INTREPAYDT)) -- 利息到期日期
    ,P1.INTREPAYBALANCE -- 应还利息
    ,P1.REPAYTERMS -- 还款总期数
    ,P1.PNLTREPAYBALANCE -- 应还罚息
    ,P1.REALITYRATE*100 -- 执行利率
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TERMTYPE END -- 期数类型代码
    ,P1.OVDDAYS -- 贷款逾期天数
    ,P1.LASTOVDDAYS -- 前一天逾期天数
    ,P1.LASTOVDSTATUS -- 前一天逾期状态代码
    ,P1.CUROVDDAYS -- 当前逾期天数
    ,P1.CUROVDSTATUS -- 当前逾期状态代码
    ,NVL(TRIM(P1.REPAYCHANGETYPE),'-') -- 还款变更状态代码
    ,P1.VOLFEE -- 违约金
    ,P1.PRDCODE -- 产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_jdjr_repay_plan' -- 源表名称
    ,'jdjri1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_jdjr_repay_plan p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TERMTYPE  = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_JDJR_REPAY_PLAN'
        AND R1.SRC_FIELD_EN_NAME= 'TERMTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_JD_REPAY_PLAN_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PERDS_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_jd_repay_plan_h_jdjri1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,inst_odd_no
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
        into ${iml_schema}.agt_jd_repay_plan_h_jdjri1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,jd_prod_cd -- 京东产品代码
    ,cust_lmt_id -- 客户额度编号
    ,dubil_id -- 借据编号
    ,inst_odd_no -- 分期单号
    ,repay_perds -- 还款期数
    ,init_repay_perds -- 原还款期数
    ,pric_exp_dt -- 本金到期日期
    ,rpbl_pric_bal -- 应还本金
    ,int_exp_dt -- 利息到期日期
    ,rpbl_int_bal -- 应还利息
    ,repay_tot_perds -- 还款总期数
    ,rpbl_pnlt_bal -- 应还罚息
    ,inst_exec_int_rat -- 执行利率
    ,perds_type_cd -- 期数类型代码
    ,ovdue_days -- 贷款逾期天数
    ,last_day_ovdue_days -- 前一天逾期天数
    ,last_day_ovdue_status_cd -- 前一天逾期状态代码
    ,curr_ovdue_days -- 当前逾期天数
    ,curr_ovdue_status_cd -- 当前逾期状态代码
    ,repay_modif_status_cd -- 还款变更状态代码
    ,penalty -- 违约金
    ,prod_id -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_jd_repay_plan_h_jdjri1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,jd_prod_cd -- 京东产品代码
    ,cust_lmt_id -- 客户额度编号
    ,dubil_id -- 借据编号
    ,inst_odd_no -- 分期单号
    ,repay_perds -- 还款期数
    ,init_repay_perds -- 原还款期数
    ,pric_exp_dt -- 本金到期日期
    ,rpbl_pric_bal -- 应还本金
    ,int_exp_dt -- 利息到期日期
    ,rpbl_int_bal -- 应还利息
    ,repay_tot_perds -- 还款总期数
    ,rpbl_pnlt_bal -- 应还罚息
    ,inst_exec_int_rat -- 执行利率
    ,perds_type_cd -- 期数类型代码
    ,ovdue_days -- 贷款逾期天数
    ,last_day_ovdue_days -- 前一天逾期天数
    ,last_day_ovdue_status_cd -- 前一天逾期状态代码
    ,curr_ovdue_days -- 当前逾期天数
    ,curr_ovdue_status_cd -- 当前逾期状态代码
    ,repay_modif_status_cd -- 还款变更状态代码
    ,penalty -- 违约金
    ,prod_id -- 产品编号
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
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.jd_prod_cd, o.jd_prod_cd) as jd_prod_cd -- 京东产品代码
    ,nvl(n.cust_lmt_id, o.cust_lmt_id) as cust_lmt_id -- 客户额度编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.inst_odd_no, o.inst_odd_no) as inst_odd_no -- 分期单号
    ,nvl(n.repay_perds, o.repay_perds) as repay_perds -- 还款期数
    ,nvl(n.init_repay_perds, o.init_repay_perds) as init_repay_perds -- 原还款期数
    ,nvl(n.pric_exp_dt, o.pric_exp_dt) as pric_exp_dt -- 本金到期日期
    ,nvl(n.rpbl_pric_bal, o.rpbl_pric_bal) as rpbl_pric_bal -- 应还本金
    ,nvl(n.int_exp_dt, o.int_exp_dt) as int_exp_dt -- 利息到期日期
    ,nvl(n.rpbl_int_bal, o.rpbl_int_bal) as rpbl_int_bal -- 应还利息
    ,nvl(n.repay_tot_perds, o.repay_tot_perds) as repay_tot_perds -- 还款总期数
    ,nvl(n.rpbl_pnlt_bal, o.rpbl_pnlt_bal) as rpbl_pnlt_bal -- 应还罚息
    ,nvl(n.inst_exec_int_rat, o.inst_exec_int_rat) as inst_exec_int_rat -- 执行利率
    ,nvl(n.perds_type_cd, o.perds_type_cd) as perds_type_cd -- 期数类型代码
    ,nvl(n.ovdue_days, o.ovdue_days) as ovdue_days -- 贷款逾期天数
    ,nvl(n.last_day_ovdue_days, o.last_day_ovdue_days) as last_day_ovdue_days -- 前一天逾期天数
    ,nvl(n.last_day_ovdue_status_cd, o.last_day_ovdue_status_cd) as last_day_ovdue_status_cd -- 前一天逾期状态代码
    ,nvl(n.curr_ovdue_days, o.curr_ovdue_days) as curr_ovdue_days -- 当前逾期天数
    ,nvl(n.curr_ovdue_status_cd, o.curr_ovdue_status_cd) as curr_ovdue_status_cd -- 当前逾期状态代码
    ,nvl(n.repay_modif_status_cd, o.repay_modif_status_cd) as repay_modif_status_cd -- 还款变更状态代码
    ,nvl(n.penalty, o.penalty) as penalty -- 违约金
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.inst_odd_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.inst_odd_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.inst_odd_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_jd_repay_plan_h_jdjri1_tm n
    full join (select * from ${iml_schema}.agt_jd_repay_plan_h_jdjri1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.inst_odd_no = n.inst_odd_no
where (
        o.agt_id is null
        and o.lp_id is null
        and o.inst_odd_no is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.inst_odd_no is null
    )
    or (
        o.cont_id <> n.cont_id
        or o.jd_prod_cd <> n.jd_prod_cd
        or o.cust_lmt_id <> n.cust_lmt_id
        or o.dubil_id <> n.dubil_id
        or o.repay_perds <> n.repay_perds
        or o.init_repay_perds <> n.init_repay_perds
        or o.pric_exp_dt <> n.pric_exp_dt
        or o.rpbl_pric_bal <> n.rpbl_pric_bal
        or o.int_exp_dt <> n.int_exp_dt
        or o.rpbl_int_bal <> n.rpbl_int_bal
        or o.repay_tot_perds <> n.repay_tot_perds
        or o.rpbl_pnlt_bal <> n.rpbl_pnlt_bal
        or o.inst_exec_int_rat <> n.inst_exec_int_rat
        or o.perds_type_cd <> n.perds_type_cd
        or o.ovdue_days <> n.ovdue_days
        or o.last_day_ovdue_days <> n.last_day_ovdue_days
        or o.last_day_ovdue_status_cd <> n.last_day_ovdue_status_cd
        or o.curr_ovdue_days <> n.curr_ovdue_days
        or o.curr_ovdue_status_cd <> n.curr_ovdue_status_cd
        or o.repay_modif_status_cd <> n.repay_modif_status_cd
        or o.penalty <> n.penalty
        or o.prod_id <> n.prod_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_jd_repay_plan_h_jdjri1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,jd_prod_cd -- 京东产品代码
    ,cust_lmt_id -- 客户额度编号
    ,dubil_id -- 借据编号
    ,inst_odd_no -- 分期单号
    ,repay_perds -- 还款期数
    ,init_repay_perds -- 原还款期数
    ,pric_exp_dt -- 本金到期日期
    ,rpbl_pric_bal -- 应还本金
    ,int_exp_dt -- 利息到期日期
    ,rpbl_int_bal -- 应还利息
    ,repay_tot_perds -- 还款总期数
    ,rpbl_pnlt_bal -- 应还罚息
    ,inst_exec_int_rat -- 执行利率
    ,perds_type_cd -- 期数类型代码
    ,ovdue_days -- 贷款逾期天数
    ,last_day_ovdue_days -- 前一天逾期天数
    ,last_day_ovdue_status_cd -- 前一天逾期状态代码
    ,curr_ovdue_days -- 当前逾期天数
    ,curr_ovdue_status_cd -- 当前逾期状态代码
    ,repay_modif_status_cd -- 还款变更状态代码
    ,penalty -- 违约金
    ,prod_id -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_jd_repay_plan_h_jdjri1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,jd_prod_cd -- 京东产品代码
    ,cust_lmt_id -- 客户额度编号
    ,dubil_id -- 借据编号
    ,inst_odd_no -- 分期单号
    ,repay_perds -- 还款期数
    ,init_repay_perds -- 原还款期数
    ,pric_exp_dt -- 本金到期日期
    ,rpbl_pric_bal -- 应还本金
    ,int_exp_dt -- 利息到期日期
    ,rpbl_int_bal -- 应还利息
    ,repay_tot_perds -- 还款总期数
    ,rpbl_pnlt_bal -- 应还罚息
    ,inst_exec_int_rat -- 执行利率
    ,perds_type_cd -- 期数类型代码
    ,ovdue_days -- 贷款逾期天数
    ,last_day_ovdue_days -- 前一天逾期天数
    ,last_day_ovdue_status_cd -- 前一天逾期状态代码
    ,curr_ovdue_days -- 当前逾期天数
    ,curr_ovdue_status_cd -- 当前逾期状态代码
    ,repay_modif_status_cd -- 还款变更状态代码
    ,penalty -- 违约金
    ,prod_id -- 产品编号
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
    ,o.cont_id -- 合同编号
    ,o.jd_prod_cd -- 京东产品代码
    ,o.cust_lmt_id -- 客户额度编号
    ,o.dubil_id -- 借据编号
    ,o.inst_odd_no -- 分期单号
    ,o.repay_perds -- 还款期数
    ,o.init_repay_perds -- 原还款期数
    ,o.pric_exp_dt -- 本金到期日期
    ,o.rpbl_pric_bal -- 应还本金
    ,o.int_exp_dt -- 利息到期日期
    ,o.rpbl_int_bal -- 应还利息
    ,o.repay_tot_perds -- 还款总期数
    ,o.rpbl_pnlt_bal -- 应还罚息
    ,o.inst_exec_int_rat -- 执行利率
    ,o.perds_type_cd -- 期数类型代码
    ,o.ovdue_days -- 贷款逾期天数
    ,o.last_day_ovdue_days -- 前一天逾期天数
    ,o.last_day_ovdue_status_cd -- 前一天逾期状态代码
    ,o.curr_ovdue_days -- 当前逾期天数
    ,o.curr_ovdue_status_cd -- 当前逾期状态代码
    ,o.repay_modif_status_cd -- 还款变更状态代码
    ,o.penalty -- 违约金
    ,o.prod_id -- 产品编号
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
from ${iml_schema}.agt_jd_repay_plan_h_jdjri1_bk o
    left join ${iml_schema}.agt_jd_repay_plan_h_jdjri1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.inst_odd_no = n.inst_odd_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_jd_repay_plan_h_jdjri1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.inst_odd_no = d.inst_odd_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_jd_repay_plan_h;
--alter table ${iml_schema}.agt_jd_repay_plan_h truncate partition for ('jdjri1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_jd_repay_plan_h') 
               and substr(subpartition_name,1,8)=upper('p_jdjri1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_jd_repay_plan_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_jd_repay_plan_h modify partition p_jdjri1 
add subpartition p_jdjri1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_jd_repay_plan_h exchange subpartition p_jdjri1_${batch_date} with table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_cl;
alter table ${iml_schema}.agt_jd_repay_plan_h exchange subpartition p_jdjri1_20991231 with table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_jd_repay_plan_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_tm purge;
drop table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_op purge;
drop table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_jd_repay_plan_h_jdjri1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_jd_repay_plan_h', partname => 'p_jdjri1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
