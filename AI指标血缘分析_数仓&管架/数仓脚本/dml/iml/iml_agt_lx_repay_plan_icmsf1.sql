/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lx_repay_plan_icmsf1
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
alter table ${iml_schema}.agt_lx_repay_plan add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lx_repay_plan_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_repay_plan partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lx_repay_plan_icmsf1_tm purge;
drop table ${iml_schema}.agt_lx_repay_plan_icmsf1_op purge;
drop table ${iml_schema}.agt_lx_repay_plan_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lx_repay_plan_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_appl_flow_num -- 源申请流水号
    ,dubil_id -- 借据编号
    ,curr_perds -- 当前期数
    ,pd_status_cd -- 期次状态代码
    ,tot_perds -- 总期数
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,distr_dt -- 放款日期
    ,value_dt -- 起息日期
    ,repay_dt -- 还款日期
    ,payoff_dt -- 结清日期
    ,grace_period -- 宽限期
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,guar_fee -- 担保费
    ,consul_serv_fee -- 咨询服务费
    ,crdt_estim_fee -- 信用评估费
    ,provi_int -- 计提利息
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lx_repay_plan partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lx_repay_plan_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_repay_plan partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lx_repay_plan_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_repay_plan partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_lx_repayment_plan-1
insert into ${iml_schema}.agt_lx_repay_plan_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_appl_flow_num -- 源申请流水号
    ,dubil_id -- 借据编号
    ,curr_perds -- 当前期数
    ,pd_status_cd -- 期次状态代码
    ,tot_perds -- 总期数
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,distr_dt -- 放款日期
    ,value_dt -- 起息日期
    ,repay_dt -- 还款日期
    ,payoff_dt -- 结清日期
    ,grace_period -- 宽限期
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,guar_fee -- 担保费
    ,consul_serv_fee -- 咨询服务费
    ,crdt_estim_fee -- 信用评估费
    ,provi_int -- 计提利息
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300072'||P1.CAPITALLOANNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ASSETID -- 源申请流水号
    ,P1.CAPITALLOANNO -- 借据编号
    ,P1.CURSTAGENO -- 当前期数
    ,decode(P1.STATUS,' ','-','0','NORMAL','1','CLEAR','2','OVD',P1.STATUS) -- 期次状态代码
    ,to_number(nvl(trim(P1.LOANTERM),0)) -- 总期数
    ,P1.PRODUCTID -- 产品编号
    ,P1.CUSTOMERID -- 客户编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,${iml_schema}.dateformat_max2(P1.PAYDATE) -- 放款日期
    ,${iml_schema}.dateformat_min(P1.INTEDATE) -- 起息日期
    ,${iml_schema}.dateformat_max2(P1.PAYABLEDAY) -- 还款日期
    ,${iml_schema}.dateformat_max2(P1.CLEARDATE) -- 结清日期
    ,to_number(nvl(trim(P1.PERIODPAYDATE),0)) -- 宽限期
    ,to_number(nvl(trim(P1.REPAYPRIAMT),0)) -- 应还本金
    ,to_number(nvl(trim(P1.PAYINT),0)) -- 应还利息
    ,to_number(nvl(trim(P1.PRINBAL),0)) -- 本金余额
    ,to_number(nvl(trim(P1.INTBAL),0)) -- 利息余额
    ,to_number(nvl(trim(P1.GUARANTYFEE),0)) -- 担保费
    ,to_number(nvl(trim(P1.SIMULATIONFEE),0)) -- 咨询服务费
    ,to_number(nvl(trim(P1.CREDITASSESSFEE),0)) -- 信用评估费
    ,to_number(nvl(trim(P1.INTEREST),0)) -- 计提利息
    ,P1.ATTRIBUTE1 -- 备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_lx_repayment_plan' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_lx_repayment_plan p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lx_repay_plan_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,src_appl_flow_num
  	                                        ,dubil_id
  	                                        ,curr_perds
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
        into ${iml_schema}.agt_lx_repay_plan_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_appl_flow_num -- 源申请流水号
    ,dubil_id -- 借据编号
    ,curr_perds -- 当前期数
    ,pd_status_cd -- 期次状态代码
    ,tot_perds -- 总期数
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,distr_dt -- 放款日期
    ,value_dt -- 起息日期
    ,repay_dt -- 还款日期
    ,payoff_dt -- 结清日期
    ,grace_period -- 宽限期
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,guar_fee -- 担保费
    ,consul_serv_fee -- 咨询服务费
    ,crdt_estim_fee -- 信用评估费
    ,provi_int -- 计提利息
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lx_repay_plan_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_appl_flow_num -- 源申请流水号
    ,dubil_id -- 借据编号
    ,curr_perds -- 当前期数
    ,pd_status_cd -- 期次状态代码
    ,tot_perds -- 总期数
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,distr_dt -- 放款日期
    ,value_dt -- 起息日期
    ,repay_dt -- 还款日期
    ,payoff_dt -- 结清日期
    ,grace_period -- 宽限期
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,guar_fee -- 担保费
    ,consul_serv_fee -- 咨询服务费
    ,crdt_estim_fee -- 信用评估费
    ,provi_int -- 计提利息
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
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
    ,nvl(n.src_appl_flow_num, o.src_appl_flow_num) as src_appl_flow_num -- 源申请流水号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.curr_perds, o.curr_perds) as curr_perds -- 当前期数
    ,nvl(n.pd_status_cd, o.pd_status_cd) as pd_status_cd -- 期次状态代码
    ,nvl(n.tot_perds, o.tot_perds) as tot_perds -- 总期数
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 放款日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.repay_dt, o.repay_dt) as repay_dt -- 还款日期
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.grace_period, o.grace_period) as grace_period -- 宽限期
    ,nvl(n.rpbl_pric, o.rpbl_pric) as rpbl_pric -- 应还本金
    ,nvl(n.rpbl_int, o.rpbl_int) as rpbl_int -- 应还利息
    ,nvl(n.pric_bal, o.pric_bal) as pric_bal -- 本金余额
    ,nvl(n.int_bal, o.int_bal) as int_bal -- 利息余额
    ,nvl(n.guar_fee, o.guar_fee) as guar_fee -- 担保费
    ,nvl(n.consul_serv_fee, o.consul_serv_fee) as consul_serv_fee -- 咨询服务费
    ,nvl(n.crdt_estim_fee, o.crdt_estim_fee) as crdt_estim_fee -- 信用评估费
    ,nvl(n.provi_int, o.provi_int) as provi_int -- 计提利息
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_appl_flow_num is null
            and n.dubil_id is null
            and n.curr_perds is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_appl_flow_num is null
            and n.dubil_id is null
            and n.curr_perds is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_appl_flow_num is null
            and n.dubil_id is null
            and n.curr_perds is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lx_repay_plan_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lx_repay_plan_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.src_appl_flow_num = n.src_appl_flow_num
            and o.dubil_id = n.dubil_id
            and o.curr_perds = n.curr_perds
where (
        o.agt_id is null
        and o.lp_id is null
        and o.src_appl_flow_num is null
        and o.dubil_id is null
        and o.curr_perds is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.src_appl_flow_num is null
        and n.dubil_id is null
        and n.curr_perds is null
    )
    or (
        o.pd_status_cd <> n.pd_status_cd
        or o.tot_perds <> n.tot_perds
        or o.prod_id <> n.prod_id
        or o.cust_id <> n.cust_id
        or o.curr_cd <> n.curr_cd
        or o.distr_dt <> n.distr_dt
        or o.value_dt <> n.value_dt
        or o.repay_dt <> n.repay_dt
        or o.payoff_dt <> n.payoff_dt
        or o.grace_period <> n.grace_period
        or o.rpbl_pric <> n.rpbl_pric
        or o.rpbl_int <> n.rpbl_int
        or o.pric_bal <> n.pric_bal
        or o.int_bal <> n.int_bal
        or o.guar_fee <> n.guar_fee
        or o.consul_serv_fee <> n.consul_serv_fee
        or o.crdt_estim_fee <> n.crdt_estim_fee
        or o.provi_int <> n.provi_int
        or o.remark <> n.remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lx_repay_plan_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_appl_flow_num -- 源申请流水号
    ,dubil_id -- 借据编号
    ,curr_perds -- 当前期数
    ,pd_status_cd -- 期次状态代码
    ,tot_perds -- 总期数
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,distr_dt -- 放款日期
    ,value_dt -- 起息日期
    ,repay_dt -- 还款日期
    ,payoff_dt -- 结清日期
    ,grace_period -- 宽限期
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,guar_fee -- 担保费
    ,consul_serv_fee -- 咨询服务费
    ,crdt_estim_fee -- 信用评估费
    ,provi_int -- 计提利息
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lx_repay_plan_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_appl_flow_num -- 源申请流水号
    ,dubil_id -- 借据编号
    ,curr_perds -- 当前期数
    ,pd_status_cd -- 期次状态代码
    ,tot_perds -- 总期数
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,distr_dt -- 放款日期
    ,value_dt -- 起息日期
    ,repay_dt -- 还款日期
    ,payoff_dt -- 结清日期
    ,grace_period -- 宽限期
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,guar_fee -- 担保费
    ,consul_serv_fee -- 咨询服务费
    ,crdt_estim_fee -- 信用评估费
    ,provi_int -- 计提利息
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
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
    ,o.src_appl_flow_num -- 源申请流水号
    ,o.dubil_id -- 借据编号
    ,o.curr_perds -- 当前期数
    ,o.pd_status_cd -- 期次状态代码
    ,o.tot_perds -- 总期数
    ,o.prod_id -- 产品编号
    ,o.cust_id -- 客户编号
    ,o.curr_cd -- 币种代码
    ,o.distr_dt -- 放款日期
    ,o.value_dt -- 起息日期
    ,o.repay_dt -- 还款日期
    ,o.payoff_dt -- 结清日期
    ,o.grace_period -- 宽限期
    ,o.rpbl_pric -- 应还本金
    ,o.rpbl_int -- 应还利息
    ,o.pric_bal -- 本金余额
    ,o.int_bal -- 利息余额
    ,o.guar_fee -- 担保费
    ,o.consul_serv_fee -- 咨询服务费
    ,o.crdt_estim_fee -- 信用评估费
    ,o.provi_int -- 计提利息
    ,o.remark -- 备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_lx_repay_plan_icmsf1_bk o
    left join ${iml_schema}.agt_lx_repay_plan_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.src_appl_flow_num = n.src_appl_flow_num
            and o.dubil_id = n.dubil_id
            and o.curr_perds = n.curr_perds
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lx_repay_plan_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.src_appl_flow_num = d.src_appl_flow_num
            and o.dubil_id = d.dubil_id
            and o.curr_perds = d.curr_perds
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lx_repay_plan;
--alter table ${iml_schema}.agt_lx_repay_plan truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lx_repay_plan') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lx_repay_plan drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lx_repay_plan modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lx_repay_plan exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lx_repay_plan_icmsf1_cl;
alter table ${iml_schema}.agt_lx_repay_plan exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lx_repay_plan_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lx_repay_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lx_repay_plan_icmsf1_tm purge;
drop table ${iml_schema}.agt_lx_repay_plan_icmsf1_op purge;
drop table ${iml_schema}.agt_lx_repay_plan_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lx_repay_plan_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lx_repay_plan', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
