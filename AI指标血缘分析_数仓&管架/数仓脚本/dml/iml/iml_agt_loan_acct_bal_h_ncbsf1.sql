/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_acct_bal_h_ncbsf1
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
alter table ${iml_schema}.agt_loan_acct_bal_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_bal_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,distr_amt -- 发放金额
    ,ld_distr_amt -- 上日发放金额
    ,nomal_pric -- 正常本金
    ,ld_nomal_pric -- 上日正常本金
    ,ovdue_pric -- 逾期本金
    ,ld_ovdue_pric -- 上日逾期本金
    ,ovdue_int -- 逾期利息
    ,ld_ovdue_int -- 上日逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ld_ovdue_pnlt -- 上日逾期罚息
    ,ovdue_comp_int -- 逾期复利
    ,ld_ovdue_comp_int -- 上日逾期复利
    ,grace_period_pric -- 宽限期本金
    ,ld_grace_period_pric -- 上日宽限期本金
    ,grace_period_int -- 宽限期利息
    ,ld_grace_period_int -- 上日宽限期利息
    ,grace_period_pnlt -- 宽限期罚息
    ,ld_grace_period_pnlt -- 上日宽限期罚息
    ,grace_period_comp_int -- 宽限期复利
    ,ld_grace_period_comp_int -- 上日宽限期复利
    ,last_activ_acct_dt -- 上一动户日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,up_ld_distr_amt -- 上上日发放金额
    ,up_ld_unexp_pric -- 上上日未到期本金
    ,up_ld_ovdue_pric -- 上上日逾期本金
    ,up_ld_ovdue_int -- 上上日逾期利息
    ,up_ld_ovdue_pnlt -- 上上日逾期罚息
    ,up_ld_ovdue_comp_int -- 上上日逾期复利
    ,up_ld_grace_period_pric -- 上上日宽限期本金
    ,up_ld_grace_period_int -- 上上日宽限期利息
    ,up_ld_grace_period_pnlt -- 上上日宽限期罚息
    ,up_ld_grace_period_comp_int -- 上上日宽限期复利
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_bal_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_bal_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_bal_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_acct_balance-1
insert into ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,distr_amt -- 发放金额
    ,ld_distr_amt -- 上日发放金额
    ,nomal_pric -- 正常本金
    ,ld_nomal_pric -- 上日正常本金
    ,ovdue_pric -- 逾期本金
    ,ld_ovdue_pric -- 上日逾期本金
    ,ovdue_int -- 逾期利息
    ,ld_ovdue_int -- 上日逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ld_ovdue_pnlt -- 上日逾期罚息
    ,ovdue_comp_int -- 逾期复利
    ,ld_ovdue_comp_int -- 上日逾期复利
    ,grace_period_pric -- 宽限期本金
    ,ld_grace_period_pric -- 上日宽限期本金
    ,grace_period_int -- 宽限期利息
    ,ld_grace_period_int -- 上日宽限期利息
    ,grace_period_pnlt -- 宽限期罚息
    ,ld_grace_period_pnlt -- 上日宽限期罚息
    ,grace_period_comp_int -- 宽限期复利
    ,ld_grace_period_comp_int -- 上日宽限期复利
    ,last_activ_acct_dt -- 上一动户日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,up_ld_distr_amt -- 上上日发放金额
    ,up_ld_unexp_pric -- 上上日未到期本金
    ,up_ld_ovdue_pric -- 上上日逾期本金
    ,up_ld_ovdue_int -- 上上日逾期利息
    ,up_ld_ovdue_pnlt -- 上上日逾期罚息
    ,up_ld_ovdue_comp_int -- 上上日逾期复利
    ,up_ld_grace_period_pric -- 上上日宽限期本金
    ,up_ld_grace_period_int -- 上上日宽限期利息
    ,up_ld_grace_period_pnlt -- 上上日宽限期罚息
    ,up_ld_grace_period_comp_int -- 上上日宽限期复利
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.DD_AMT -- 发放金额
    ,P1.DDA_AMT_PREV -- 上日发放金额
    ,P1.OSL_AMT -- 正常本金
    ,P1.OSL_AMT_PREV -- 上日正常本金
    ,P1.PRD_AMT -- 逾期本金
    ,P1.PRD_AMT_PREV -- 上日逾期本金
    ,P1.INTP_AMT -- 逾期利息
    ,P1.INTP_AMT_PREV -- 上日逾期利息
    ,P1.ODPP_AMT -- 逾期罚息
    ,P1.ODPP_AMT_PREV -- 上日逾期罚息
    ,P1.ODIP_AMT -- 逾期复利
    ,P1.ODIP_AMT_PREV -- 上日逾期复利
    ,P1.GPRD_AMT -- 宽限期本金
    ,P1.GPRD_AMT_PREV -- 上日宽限期本金
    ,P1.GINTP_AMT -- 宽限期利息
    ,P1.GINTP_AMT_PREV -- 上日宽限期利息
    ,P1.GODPP_AMT -- 宽限期罚息
    ,P1.GODPP_AMT_PREV -- 上日宽限期罚息
    ,P1.GODIP_AMT -- 宽限期复利
    ,P1.GODIP_AMT_PREV -- 上日宽限期复利
    ,P1.LAST_BAL_UPD_DATE -- 上一动户日期
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.DD_AMT_LAST_PREV -- 上上日发放金额
    ,P1.OSL_AMT_LAST_PREV -- 上上日未到期本金
    ,P1.PRD_AMT_LAST_PREV -- 上上日逾期本金
    ,P1.INTP_AMT_LAST_PREV -- 上上日逾期利息
    ,P1.ODPP_AMT_LAST_PREV -- 上上日逾期罚息
    ,P1.ODIP_AMT_LAST_PREV -- 上上日逾期复利
    ,P1.GPRD_AMT_LAST_PREV -- 上上日宽限期本金
    ,P1.GINTP_AMT_LAST_PREV -- 上上日宽限期利息
    ,P1.GODPP_AMT_LAST_PREV -- 上上日宽限期罚息
    ,P1.GODIP_AMT_LAST_PREV -- 上上日宽限期复利
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_acct_balance' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_acct_balance p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
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
        into ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,distr_amt -- 发放金额
    ,ld_distr_amt -- 上日发放金额
    ,nomal_pric -- 正常本金
    ,ld_nomal_pric -- 上日正常本金
    ,ovdue_pric -- 逾期本金
    ,ld_ovdue_pric -- 上日逾期本金
    ,ovdue_int -- 逾期利息
    ,ld_ovdue_int -- 上日逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ld_ovdue_pnlt -- 上日逾期罚息
    ,ovdue_comp_int -- 逾期复利
    ,ld_ovdue_comp_int -- 上日逾期复利
    ,grace_period_pric -- 宽限期本金
    ,ld_grace_period_pric -- 上日宽限期本金
    ,grace_period_int -- 宽限期利息
    ,ld_grace_period_int -- 上日宽限期利息
    ,grace_period_pnlt -- 宽限期罚息
    ,ld_grace_period_pnlt -- 上日宽限期罚息
    ,grace_period_comp_int -- 宽限期复利
    ,ld_grace_period_comp_int -- 上日宽限期复利
    ,last_activ_acct_dt -- 上一动户日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,up_ld_distr_amt -- 上上日发放金额
    ,up_ld_unexp_pric -- 上上日未到期本金
    ,up_ld_ovdue_pric -- 上上日逾期本金
    ,up_ld_ovdue_int -- 上上日逾期利息
    ,up_ld_ovdue_pnlt -- 上上日逾期罚息
    ,up_ld_ovdue_comp_int -- 上上日逾期复利
    ,up_ld_grace_period_pric -- 上上日宽限期本金
    ,up_ld_grace_period_int -- 上上日宽限期利息
    ,up_ld_grace_period_pnlt -- 上上日宽限期罚息
    ,up_ld_grace_period_comp_int -- 上上日宽限期复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,distr_amt -- 发放金额
    ,ld_distr_amt -- 上日发放金额
    ,nomal_pric -- 正常本金
    ,ld_nomal_pric -- 上日正常本金
    ,ovdue_pric -- 逾期本金
    ,ld_ovdue_pric -- 上日逾期本金
    ,ovdue_int -- 逾期利息
    ,ld_ovdue_int -- 上日逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ld_ovdue_pnlt -- 上日逾期罚息
    ,ovdue_comp_int -- 逾期复利
    ,ld_ovdue_comp_int -- 上日逾期复利
    ,grace_period_pric -- 宽限期本金
    ,ld_grace_period_pric -- 上日宽限期本金
    ,grace_period_int -- 宽限期利息
    ,ld_grace_period_int -- 上日宽限期利息
    ,grace_period_pnlt -- 宽限期罚息
    ,ld_grace_period_pnlt -- 上日宽限期罚息
    ,grace_period_comp_int -- 宽限期复利
    ,ld_grace_period_comp_int -- 上日宽限期复利
    ,last_activ_acct_dt -- 上一动户日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,up_ld_distr_amt -- 上上日发放金额
    ,up_ld_unexp_pric -- 上上日未到期本金
    ,up_ld_ovdue_pric -- 上上日逾期本金
    ,up_ld_ovdue_int -- 上上日逾期利息
    ,up_ld_ovdue_pnlt -- 上上日逾期罚息
    ,up_ld_ovdue_comp_int -- 上上日逾期复利
    ,up_ld_grace_period_pric -- 上上日宽限期本金
    ,up_ld_grace_period_int -- 上上日宽限期利息
    ,up_ld_grace_period_pnlt -- 上上日宽限期罚息
    ,up_ld_grace_period_comp_int -- 上上日宽限期复利
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
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.distr_amt, o.distr_amt) as distr_amt -- 发放金额
    ,nvl(n.ld_distr_amt, o.ld_distr_amt) as ld_distr_amt -- 上日发放金额
    ,nvl(n.nomal_pric, o.nomal_pric) as nomal_pric -- 正常本金
    ,nvl(n.ld_nomal_pric, o.ld_nomal_pric) as ld_nomal_pric -- 上日正常本金
    ,nvl(n.ovdue_pric, o.ovdue_pric) as ovdue_pric -- 逾期本金
    ,nvl(n.ld_ovdue_pric, o.ld_ovdue_pric) as ld_ovdue_pric -- 上日逾期本金
    ,nvl(n.ovdue_int, o.ovdue_int) as ovdue_int -- 逾期利息
    ,nvl(n.ld_ovdue_int, o.ld_ovdue_int) as ld_ovdue_int -- 上日逾期利息
    ,nvl(n.ovdue_pnlt, o.ovdue_pnlt) as ovdue_pnlt -- 逾期罚息
    ,nvl(n.ld_ovdue_pnlt, o.ld_ovdue_pnlt) as ld_ovdue_pnlt -- 上日逾期罚息
    ,nvl(n.ovdue_comp_int, o.ovdue_comp_int) as ovdue_comp_int -- 逾期复利
    ,nvl(n.ld_ovdue_comp_int, o.ld_ovdue_comp_int) as ld_ovdue_comp_int -- 上日逾期复利
    ,nvl(n.grace_period_pric, o.grace_period_pric) as grace_period_pric -- 宽限期本金
    ,nvl(n.ld_grace_period_pric, o.ld_grace_period_pric) as ld_grace_period_pric -- 上日宽限期本金
    ,nvl(n.grace_period_int, o.grace_period_int) as grace_period_int -- 宽限期利息
    ,nvl(n.ld_grace_period_int, o.ld_grace_period_int) as ld_grace_period_int -- 上日宽限期利息
    ,nvl(n.grace_period_pnlt, o.grace_period_pnlt) as grace_period_pnlt -- 宽限期罚息
    ,nvl(n.ld_grace_period_pnlt, o.ld_grace_period_pnlt) as ld_grace_period_pnlt -- 上日宽限期罚息
    ,nvl(n.grace_period_comp_int, o.grace_period_comp_int) as grace_period_comp_int -- 宽限期复利
    ,nvl(n.ld_grace_period_comp_int, o.ld_grace_period_comp_int) as ld_grace_period_comp_int -- 上日宽限期复利
    ,nvl(n.last_activ_acct_dt, o.last_activ_acct_dt) as last_activ_acct_dt -- 上一动户日期
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.up_ld_distr_amt, o.up_ld_distr_amt) as up_ld_distr_amt -- 上上日发放金额
    ,nvl(n.up_ld_unexp_pric, o.up_ld_unexp_pric) as up_ld_unexp_pric -- 上上日未到期本金
    ,nvl(n.up_ld_ovdue_pric, o.up_ld_ovdue_pric) as up_ld_ovdue_pric -- 上上日逾期本金
    ,nvl(n.up_ld_ovdue_int, o.up_ld_ovdue_int) as up_ld_ovdue_int -- 上上日逾期利息
    ,nvl(n.up_ld_ovdue_pnlt, o.up_ld_ovdue_pnlt) as up_ld_ovdue_pnlt -- 上上日逾期罚息
    ,nvl(n.up_ld_ovdue_comp_int, o.up_ld_ovdue_comp_int) as up_ld_ovdue_comp_int -- 上上日逾期复利
    ,nvl(n.up_ld_grace_period_pric, o.up_ld_grace_period_pric) as up_ld_grace_period_pric -- 上上日宽限期本金
    ,nvl(n.up_ld_grace_period_int, o.up_ld_grace_period_int) as up_ld_grace_period_int -- 上上日宽限期利息
    ,nvl(n.up_ld_grace_period_pnlt, o.up_ld_grace_period_pnlt) as up_ld_grace_period_pnlt -- 上上日宽限期罚息
    ,nvl(n.up_ld_grace_period_comp_int, o.up_ld_grace_period_comp_int) as up_ld_grace_period_comp_int -- 上上日宽限期复利
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.distr_amt <> n.distr_amt
        or o.ld_distr_amt <> n.ld_distr_amt
        or o.nomal_pric <> n.nomal_pric
        or o.ld_nomal_pric <> n.ld_nomal_pric
        or o.ovdue_pric <> n.ovdue_pric
        or o.ld_ovdue_pric <> n.ld_ovdue_pric
        or o.ovdue_int <> n.ovdue_int
        or o.ld_ovdue_int <> n.ld_ovdue_int
        or o.ovdue_pnlt <> n.ovdue_pnlt
        or o.ld_ovdue_pnlt <> n.ld_ovdue_pnlt
        or o.ovdue_comp_int <> n.ovdue_comp_int
        or o.ld_ovdue_comp_int <> n.ld_ovdue_comp_int
        or o.grace_period_pric <> n.grace_period_pric
        or o.ld_grace_period_pric <> n.ld_grace_period_pric
        or o.grace_period_int <> n.grace_period_int
        or o.ld_grace_period_int <> n.ld_grace_period_int
        or o.grace_period_pnlt <> n.grace_period_pnlt
        or o.ld_grace_period_pnlt <> n.ld_grace_period_pnlt
        or o.grace_period_comp_int <> n.grace_period_comp_int
        or o.ld_grace_period_comp_int <> n.ld_grace_period_comp_int
        or o.last_activ_acct_dt <> n.last_activ_acct_dt
        or o.final_modif_teller_id <> n.final_modif_teller_id
        or o.final_modif_dt <> n.final_modif_dt
        or o.up_ld_distr_amt <> n.up_ld_distr_amt
        or o.up_ld_unexp_pric <> n.up_ld_unexp_pric
        or o.up_ld_ovdue_pric <> n.up_ld_ovdue_pric
        or o.up_ld_ovdue_int <> n.up_ld_ovdue_int
        or o.up_ld_ovdue_pnlt <> n.up_ld_ovdue_pnlt
        or o.up_ld_ovdue_comp_int <> n.up_ld_ovdue_comp_int
        or o.up_ld_grace_period_pric <> n.up_ld_grace_period_pric
        or o.up_ld_grace_period_int <> n.up_ld_grace_period_int
        or o.up_ld_grace_period_pnlt <> n.up_ld_grace_period_pnlt
        or o.up_ld_grace_period_comp_int <> n.up_ld_grace_period_comp_int
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,distr_amt -- 发放金额
    ,ld_distr_amt -- 上日发放金额
    ,nomal_pric -- 正常本金
    ,ld_nomal_pric -- 上日正常本金
    ,ovdue_pric -- 逾期本金
    ,ld_ovdue_pric -- 上日逾期本金
    ,ovdue_int -- 逾期利息
    ,ld_ovdue_int -- 上日逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ld_ovdue_pnlt -- 上日逾期罚息
    ,ovdue_comp_int -- 逾期复利
    ,ld_ovdue_comp_int -- 上日逾期复利
    ,grace_period_pric -- 宽限期本金
    ,ld_grace_period_pric -- 上日宽限期本金
    ,grace_period_int -- 宽限期利息
    ,ld_grace_period_int -- 上日宽限期利息
    ,grace_period_pnlt -- 宽限期罚息
    ,ld_grace_period_pnlt -- 上日宽限期罚息
    ,grace_period_comp_int -- 宽限期复利
    ,ld_grace_period_comp_int -- 上日宽限期复利
    ,last_activ_acct_dt -- 上一动户日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,up_ld_distr_amt -- 上上日发放金额
    ,up_ld_unexp_pric -- 上上日未到期本金
    ,up_ld_ovdue_pric -- 上上日逾期本金
    ,up_ld_ovdue_int -- 上上日逾期利息
    ,up_ld_ovdue_pnlt -- 上上日逾期罚息
    ,up_ld_ovdue_comp_int -- 上上日逾期复利
    ,up_ld_grace_period_pric -- 上上日宽限期本金
    ,up_ld_grace_period_int -- 上上日宽限期利息
    ,up_ld_grace_period_pnlt -- 上上日宽限期罚息
    ,up_ld_grace_period_comp_int -- 上上日宽限期复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,distr_amt -- 发放金额
    ,ld_distr_amt -- 上日发放金额
    ,nomal_pric -- 正常本金
    ,ld_nomal_pric -- 上日正常本金
    ,ovdue_pric -- 逾期本金
    ,ld_ovdue_pric -- 上日逾期本金
    ,ovdue_int -- 逾期利息
    ,ld_ovdue_int -- 上日逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ld_ovdue_pnlt -- 上日逾期罚息
    ,ovdue_comp_int -- 逾期复利
    ,ld_ovdue_comp_int -- 上日逾期复利
    ,grace_period_pric -- 宽限期本金
    ,ld_grace_period_pric -- 上日宽限期本金
    ,grace_period_int -- 宽限期利息
    ,ld_grace_period_int -- 上日宽限期利息
    ,grace_period_pnlt -- 宽限期罚息
    ,ld_grace_period_pnlt -- 上日宽限期罚息
    ,grace_period_comp_int -- 宽限期复利
    ,ld_grace_period_comp_int -- 上日宽限期复利
    ,last_activ_acct_dt -- 上一动户日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,up_ld_distr_amt -- 上上日发放金额
    ,up_ld_unexp_pric -- 上上日未到期本金
    ,up_ld_ovdue_pric -- 上上日逾期本金
    ,up_ld_ovdue_int -- 上上日逾期利息
    ,up_ld_ovdue_pnlt -- 上上日逾期罚息
    ,up_ld_ovdue_comp_int -- 上上日逾期复利
    ,up_ld_grace_period_pric -- 上上日宽限期本金
    ,up_ld_grace_period_int -- 上上日宽限期利息
    ,up_ld_grace_period_pnlt -- 上上日宽限期罚息
    ,up_ld_grace_period_comp_int -- 上上日宽限期复利
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
    ,o.cust_id -- 客户编号
    ,o.distr_amt -- 发放金额
    ,o.ld_distr_amt -- 上日发放金额
    ,o.nomal_pric -- 正常本金
    ,o.ld_nomal_pric -- 上日正常本金
    ,o.ovdue_pric -- 逾期本金
    ,o.ld_ovdue_pric -- 上日逾期本金
    ,o.ovdue_int -- 逾期利息
    ,o.ld_ovdue_int -- 上日逾期利息
    ,o.ovdue_pnlt -- 逾期罚息
    ,o.ld_ovdue_pnlt -- 上日逾期罚息
    ,o.ovdue_comp_int -- 逾期复利
    ,o.ld_ovdue_comp_int -- 上日逾期复利
    ,o.grace_period_pric -- 宽限期本金
    ,o.ld_grace_period_pric -- 上日宽限期本金
    ,o.grace_period_int -- 宽限期利息
    ,o.ld_grace_period_int -- 上日宽限期利息
    ,o.grace_period_pnlt -- 宽限期罚息
    ,o.ld_grace_period_pnlt -- 上日宽限期罚息
    ,o.grace_period_comp_int -- 宽限期复利
    ,o.ld_grace_period_comp_int -- 上日宽限期复利
    ,o.last_activ_acct_dt -- 上一动户日期
    ,o.final_modif_teller_id -- 最后修改柜员编号
    ,o.final_modif_dt -- 最后修改日期
    ,o.up_ld_distr_amt -- 上上日发放金额
    ,o.up_ld_unexp_pric -- 上上日未到期本金
    ,o.up_ld_ovdue_pric -- 上上日逾期本金
    ,o.up_ld_ovdue_int -- 上上日逾期利息
    ,o.up_ld_ovdue_pnlt -- 上上日逾期罚息
    ,o.up_ld_ovdue_comp_int -- 上上日逾期复利
    ,o.up_ld_grace_period_pric -- 上上日宽限期本金
    ,o.up_ld_grace_period_int -- 上上日宽限期利息
    ,o.up_ld_grace_period_pnlt -- 上上日宽限期罚息
    ,o.up_ld_grace_period_comp_int -- 上上日宽限期复利
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
from ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_bk o
    left join ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_acct_bal_h;
--alter table ${iml_schema}.agt_loan_acct_bal_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_acct_bal_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_acct_bal_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_acct_bal_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_acct_bal_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_cl;
alter table ${iml_schema}.agt_loan_acct_bal_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_acct_bal_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_acct_bal_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_acct_bal_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
