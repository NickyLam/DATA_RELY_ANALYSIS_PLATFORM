/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_crdt_loan_repay_plan_icmsf1
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
alter table ${iml_schema}.agt_crdt_loan_repay_plan add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_loan_repay_plan partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_tm purge;
drop table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_op purge;
drop table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,perds -- 期数
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,exec_int_rat -- 执行利率
    ,nomal_pric -- 正常本金
    ,dubil_surp_loan_pric -- 借据剩余贷款本金
    ,eh_issue_repay_tot -- 每期还款总额
    ,surp_rpbl_int -- 剩余应还利息
    ,repay_way_cd -- 还款方式代码
    ,curr_issue_recvbl_pric -- 本期应收本金
    ,curr_issue_int_recvbl -- 本期应收利息
    ,curr_issue_surp_pric -- 本期剩余本金
    ,thrinto_int_sub_amt -- 其中贴息金额
    ,aldy_proc_flg -- 已处理标志
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复息
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复利
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,recvbl_over_int -- 应收欠息
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_loan_repay_plan partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_loan_repay_plan partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_loan_repay_plan partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_repayment_plan_info-1
insert into ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,perds -- 期数
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,exec_int_rat -- 执行利率
    ,nomal_pric -- 正常本金
    ,dubil_surp_loan_pric -- 借据剩余贷款本金
    ,eh_issue_repay_tot -- 每期还款总额
    ,surp_rpbl_int -- 剩余应还利息
    ,repay_way_cd -- 还款方式代码
    ,curr_issue_recvbl_pric -- 本期应收本金
    ,curr_issue_int_recvbl -- 本期应收利息
    ,curr_issue_surp_pric -- 本期剩余本金
    ,thrinto_int_sub_amt -- 其中贴息金额
    ,aldy_proc_flg -- 已处理标志
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复息
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复利
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,recvbl_over_int -- 应收欠息
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300004'||P1.DUEBILLSERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.DUEBILLSERIALNO -- 借据编号
    ,P1.DATENO -- 期数
    ,P1.STARTDATE -- 起始日期
    ,P1.ENDDATE -- 到期日期
    ,P1.GRACEDATE -- 宽限日期
    ,P1.EXECUTIONDATE -- 结清日期
    ,nvl(trim(P1.BUSINESSCURRENCY),'-') -- 币种代码
    ,P1.BUSINESSRATE -- 执行利率
    ,P1.NORMALSUM -- 正常本金
    ,P1.PUTOUTUNPAIDSUM -- 借据剩余贷款本金
    ,P1.SCHEDAMT -- 每期还款总额
    ,P1.RESPAIDINTAMT -- 剩余应还利息
    ,nvl(trim(P1.PAYMENTTYPE),'-') -- 还款方式代码
    ,P1.PERIODSUM -- 本期应收本金
    ,P1.PERIODINTERESTSUM -- 本期应收利息
    ,P1.UNPAIDSUM -- 本期剩余本金
    ,P1.DISCOUNTSUM -- 其中贴息金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.FLAG END -- 已处理标志
    ,P1.ACTUALSUM -- 实还本金
    ,P1.ACTUALINTEREST -- 实还利息
    ,P1.PENALTYINTEREST -- 实还罚息
    ,P1.COMPOUNDINTEREST -- 实还复息
    ,P1.INTACCRUED -- 应计利息
    ,P1.ODPACCRUED -- 应计罚息
    ,P1.ODIACCRUED -- 应计复利
    ,P1.ODPOUTSTANDING -- 应收罚息
    ,P1.ODIOUTSTANDING -- 应收复利
    ,P1.YSINTAMT -- 应收欠息
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_repayment_plan_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_repayment_plan_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.FLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_REPAYMENT_PLAN_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'FLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_CRDT_LOAN_REPAY_PLAN'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ALDY_PROC_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dubil_id
  	                                        ,perds
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
        into ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,perds -- 期数
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,exec_int_rat -- 执行利率
    ,nomal_pric -- 正常本金
    ,dubil_surp_loan_pric -- 借据剩余贷款本金
    ,eh_issue_repay_tot -- 每期还款总额
    ,surp_rpbl_int -- 剩余应还利息
    ,repay_way_cd -- 还款方式代码
    ,curr_issue_recvbl_pric -- 本期应收本金
    ,curr_issue_int_recvbl -- 本期应收利息
    ,curr_issue_surp_pric -- 本期剩余本金
    ,thrinto_int_sub_amt -- 其中贴息金额
    ,aldy_proc_flg -- 已处理标志
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复息
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复利
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,recvbl_over_int -- 应收欠息
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,perds -- 期数
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,exec_int_rat -- 执行利率
    ,nomal_pric -- 正常本金
    ,dubil_surp_loan_pric -- 借据剩余贷款本金
    ,eh_issue_repay_tot -- 每期还款总额
    ,surp_rpbl_int -- 剩余应还利息
    ,repay_way_cd -- 还款方式代码
    ,curr_issue_recvbl_pric -- 本期应收本金
    ,curr_issue_int_recvbl -- 本期应收利息
    ,curr_issue_surp_pric -- 本期剩余本金
    ,thrinto_int_sub_amt -- 其中贴息金额
    ,aldy_proc_flg -- 已处理标志
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复息
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复利
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,recvbl_over_int -- 应收欠息
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
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.perds, o.perds) as perds -- 期数
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.grace_dt_term, o.grace_dt_term) as grace_dt_term -- 宽限日期
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.nomal_pric, o.nomal_pric) as nomal_pric -- 正常本金
    ,nvl(n.dubil_surp_loan_pric, o.dubil_surp_loan_pric) as dubil_surp_loan_pric -- 借据剩余贷款本金
    ,nvl(n.eh_issue_repay_tot, o.eh_issue_repay_tot) as eh_issue_repay_tot -- 每期还款总额
    ,nvl(n.surp_rpbl_int, o.surp_rpbl_int) as surp_rpbl_int -- 剩余应还利息
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.curr_issue_recvbl_pric, o.curr_issue_recvbl_pric) as curr_issue_recvbl_pric -- 本期应收本金
    ,nvl(n.curr_issue_int_recvbl, o.curr_issue_int_recvbl) as curr_issue_int_recvbl -- 本期应收利息
    ,nvl(n.curr_issue_surp_pric, o.curr_issue_surp_pric) as curr_issue_surp_pric -- 本期剩余本金
    ,nvl(n.thrinto_int_sub_amt, o.thrinto_int_sub_amt) as thrinto_int_sub_amt -- 其中贴息金额
    ,nvl(n.aldy_proc_flg, o.aldy_proc_flg) as aldy_proc_flg -- 已处理标志
    ,nvl(n.paid_pric, o.paid_pric) as paid_pric -- 实还本金
    ,nvl(n.paid_int, o.paid_int) as paid_int -- 实还利息
    ,nvl(n.paid_pnlt, o.paid_pnlt) as paid_pnlt -- 实还罚息
    ,nvl(n.paid_comp_int, o.paid_comp_int) as paid_comp_int -- 实还复息
    ,nvl(n.acru_int, o.acru_int) as acru_int -- 应计利息
    ,nvl(n.acru_pnlt, o.acru_pnlt) as acru_pnlt -- 应计罚息
    ,nvl(n.acru_comp_int, o.acru_comp_int) as acru_comp_int -- 应计复利
    ,nvl(n.recvbl_pnlt, o.recvbl_pnlt) as recvbl_pnlt -- 应收罚息
    ,nvl(n.recvbl_comp_int, o.recvbl_comp_int) as recvbl_comp_int -- 应收复利
    ,nvl(n.recvbl_over_int, o.recvbl_over_int) as recvbl_over_int -- 应收欠息
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.perds is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.perds is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.perds is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.perds = n.perds
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dubil_id is null
        and o.perds is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dubil_id is null
        and n.perds is null
    )
    or (
        o.begin_dt <> n.begin_dt
        or o.exp_dt <> n.exp_dt
        or o.grace_dt_term <> n.grace_dt_term
        or o.payoff_dt <> n.payoff_dt
        or o.curr_cd <> n.curr_cd
        or o.exec_int_rat <> n.exec_int_rat
        or o.nomal_pric <> n.nomal_pric
        or o.dubil_surp_loan_pric <> n.dubil_surp_loan_pric
        or o.eh_issue_repay_tot <> n.eh_issue_repay_tot
        or o.surp_rpbl_int <> n.surp_rpbl_int
        or o.repay_way_cd <> n.repay_way_cd
        or o.curr_issue_recvbl_pric <> n.curr_issue_recvbl_pric
        or o.curr_issue_int_recvbl <> n.curr_issue_int_recvbl
        or o.curr_issue_surp_pric <> n.curr_issue_surp_pric
        or o.thrinto_int_sub_amt <> n.thrinto_int_sub_amt
        or o.aldy_proc_flg <> n.aldy_proc_flg
        or o.paid_pric <> n.paid_pric
        or o.paid_int <> n.paid_int
        or o.paid_pnlt <> n.paid_pnlt
        or o.paid_comp_int <> n.paid_comp_int
        or o.acru_int <> n.acru_int
        or o.acru_pnlt <> n.acru_pnlt
        or o.acru_comp_int <> n.acru_comp_int
        or o.recvbl_pnlt <> n.recvbl_pnlt
        or o.recvbl_comp_int <> n.recvbl_comp_int
        or o.recvbl_over_int <> n.recvbl_over_int
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,perds -- 期数
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,exec_int_rat -- 执行利率
    ,nomal_pric -- 正常本金
    ,dubil_surp_loan_pric -- 借据剩余贷款本金
    ,eh_issue_repay_tot -- 每期还款总额
    ,surp_rpbl_int -- 剩余应还利息
    ,repay_way_cd -- 还款方式代码
    ,curr_issue_recvbl_pric -- 本期应收本金
    ,curr_issue_int_recvbl -- 本期应收利息
    ,curr_issue_surp_pric -- 本期剩余本金
    ,thrinto_int_sub_amt -- 其中贴息金额
    ,aldy_proc_flg -- 已处理标志
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复息
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复利
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,recvbl_over_int -- 应收欠息
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,perds -- 期数
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,exec_int_rat -- 执行利率
    ,nomal_pric -- 正常本金
    ,dubil_surp_loan_pric -- 借据剩余贷款本金
    ,eh_issue_repay_tot -- 每期还款总额
    ,surp_rpbl_int -- 剩余应还利息
    ,repay_way_cd -- 还款方式代码
    ,curr_issue_recvbl_pric -- 本期应收本金
    ,curr_issue_int_recvbl -- 本期应收利息
    ,curr_issue_surp_pric -- 本期剩余本金
    ,thrinto_int_sub_amt -- 其中贴息金额
    ,aldy_proc_flg -- 已处理标志
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复息
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复利
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,recvbl_over_int -- 应收欠息
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
    ,o.dubil_id -- 借据编号
    ,o.perds -- 期数
    ,o.begin_dt -- 起始日期
    ,o.exp_dt -- 到期日期
    ,o.grace_dt_term -- 宽限日期
    ,o.payoff_dt -- 结清日期
    ,o.curr_cd -- 币种代码
    ,o.exec_int_rat -- 执行利率
    ,o.nomal_pric -- 正常本金
    ,o.dubil_surp_loan_pric -- 借据剩余贷款本金
    ,o.eh_issue_repay_tot -- 每期还款总额
    ,o.surp_rpbl_int -- 剩余应还利息
    ,o.repay_way_cd -- 还款方式代码
    ,o.curr_issue_recvbl_pric -- 本期应收本金
    ,o.curr_issue_int_recvbl -- 本期应收利息
    ,o.curr_issue_surp_pric -- 本期剩余本金
    ,o.thrinto_int_sub_amt -- 其中贴息金额
    ,o.aldy_proc_flg -- 已处理标志
    ,o.paid_pric -- 实还本金
    ,o.paid_int -- 实还利息
    ,o.paid_pnlt -- 实还罚息
    ,o.paid_comp_int -- 实还复息
    ,o.acru_int -- 应计利息
    ,o.acru_pnlt -- 应计罚息
    ,o.acru_comp_int -- 应计复利
    ,o.recvbl_pnlt -- 应收罚息
    ,o.recvbl_comp_int -- 应收复利
    ,o.recvbl_over_int -- 应收欠息
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
from ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_bk o
    left join ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.perds = n.perds
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dubil_id = d.dubil_id
            and o.perds = d.perds
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_crdt_loan_repay_plan;
--alter table ${iml_schema}.agt_crdt_loan_repay_plan truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_crdt_loan_repay_plan') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_crdt_loan_repay_plan drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_crdt_loan_repay_plan modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_crdt_loan_repay_plan exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_cl;
alter table ${iml_schema}.agt_crdt_loan_repay_plan exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_crdt_loan_repay_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_tm purge;
drop table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_op purge;
drop table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_crdt_loan_repay_plan_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_crdt_loan_repay_plan', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
