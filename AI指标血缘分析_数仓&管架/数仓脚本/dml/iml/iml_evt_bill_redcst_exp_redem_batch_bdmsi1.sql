/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bill_redcst_exp_redem_batch_bdmsi1
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
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_bill_redcst_exp_redem_batch add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

create table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_redcst_exp_redem_batch partition for ('bdmsi1') 
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_tm purge;
drop table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_op purge;
drop table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,exp_redem_batch_ser_num -- 到期赎回批次序列号
    ,bill_redcst_ser_num -- 票据再贴现序列号
    ,batch_id -- 批次编号
    ,bus_dt -- 业务日期
    ,bus_type_cd -- 业务类型代码
    ,clear_bus_type_cd -- 清算业务类型代码
    ,prod_id -- 产品编号
    ,ctr_nt_id -- 成交单编号
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,cap_acct_id -- 资金账户编号
    ,acct_instit_id -- 账务机构编号
    ,dealer_id -- 交易员编号
    ,actl_stl_amt -- 实际结算金额
    ,stl_bill_cnt -- 结算票据张数
    ,stl_int_paybl -- 结算应付利息
    ,entry_status_cd -- 记账状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_redcst_exp_redem_batch partition for ('bdmsi1')
where 0=1
;

create table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_redcst_exp_redem_batch partition for ('bdmsi1') where 0=1;

create table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_redcst_exp_redem_batch partition for ('bdmsi1') where 0=1;

-- 3.1 get new data into table
-- bdms_cpes_redsct_due-
insert into ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,exp_redem_batch_ser_num -- 到期赎回批次序列号
    ,bill_redcst_ser_num -- 票据再贴现序列号
    ,batch_id -- 批次编号
    ,bus_dt -- 业务日期
    ,bus_type_cd -- 业务类型代码
    ,clear_bus_type_cd -- 清算业务类型代码
    ,prod_id -- 产品编号
    ,ctr_nt_id -- 成交单编号
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,cap_acct_id -- 资金账户编号
    ,acct_instit_id -- 账务机构编号
    ,dealer_id -- 交易员编号
    ,actl_stl_amt -- 实际结算金额
    ,stl_bill_cnt -- 结算票据张数
    ,stl_int_paybl -- 结算应付利息
    ,entry_status_cd -- 记账状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102018'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,p1.id -- 到期赎回批次序列号
    ,p1.org_contract_id -- 票据再贴现序列号
    ,p1.contract_no -- 批次编号
    ,${iml_schema}.DATEFORMAT_MIN(p1.busi_date) -- 业务日期
    ,nvl(trim(p1.busi_type),'RBT00') -- 业务类型代码
    ,nvl(trim(P1.settle_type),'-') -- 清算业务类型代码
    ,p1.product_no -- 产品编号
    ,p1.deal_no -- 成交单编号
    ,p1.busi_branch_no -- 业务机构编号
    ,p1.top_branch_no -- 总行机构编号
    ,p1.facct_no -- 资金账户编号
    ,p1.acct_branch_no -- 账务机构编号
    ,p1.user_id -- 交易员编号
    ,P1.real_settle_amount -- 实际结算金额
    ,P1.settle_draft_num -- 结算票据张数
    ,P1.settle_pay_interest -- 结算应付利息
    ,case when R1.target_cd_val is not null then R1.target_cd_val else '@'||p1.account_status end -- 记账状态代码
    ,nvl(trim(P1.settle_status),'-') -- 清算状态代码
    ,p1.last_upd_opr -- 最后修改操作员编号
    ,${iml_schema}.timeformat_min(p1.last_upd_time) -- 最后修改时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_redsct_due' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_redsct_due p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCOUNT_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CPES_REDSCT_DUE'
        AND R1.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BILL_REDCST_EXP_REDEM_BATCH'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND substr(trim(P1.last_upd_time),1,8)='${batch_date}'
;
commit;


commit;


whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_tm 
  	                                group by 
  	                                        evt_id
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

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_op(
        evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,exp_redem_batch_ser_num -- 到期赎回批次序列号
    ,bill_redcst_ser_num -- 票据再贴现序列号
    ,batch_id -- 批次编号
    ,bus_dt -- 业务日期
    ,bus_type_cd -- 业务类型代码
    ,clear_bus_type_cd -- 清算业务类型代码
    ,prod_id -- 产品编号
    ,ctr_nt_id -- 成交单编号
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,cap_acct_id -- 资金账户编号
    ,acct_instit_id -- 账务机构编号
    ,dealer_id -- 交易员编号
    ,actl_stl_amt -- 实际结算金额
    ,stl_bill_cnt -- 结算票据张数
    ,stl_int_paybl -- 结算应付利息
    ,entry_status_cd -- 记账状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.evt_id -- 事件编号
    ,n.lp_id -- 法人编号
    ,n.exp_redem_batch_ser_num -- 到期赎回批次序列号
    ,n.bill_redcst_ser_num -- 票据再贴现序列号
    ,n.batch_id -- 批次编号
    ,n.bus_dt -- 业务日期
    ,n.bus_type_cd -- 业务类型代码
    ,n.clear_bus_type_cd -- 清算业务类型代码
    ,n.prod_id -- 产品编号
    ,n.ctr_nt_id -- 成交单编号
    ,n.bus_org_id -- 业务机构编号
    ,n.hq_org_id -- 总行机构编号
    ,n.cap_acct_id -- 资金账户编号
    ,n.acct_instit_id -- 账务机构编号
    ,n.dealer_id -- 交易员编号
    ,n.actl_stl_amt -- 实际结算金额
    ,n.stl_bill_cnt -- 结算票据张数
    ,n.stl_int_paybl -- 结算应付利息
    ,n.entry_status_cd -- 记账状态代码
    ,n.clear_status_cd -- 清算状态代码
    ,n.final_modif_operr_id -- 最后修改操作员编号
    ,n.final_modif_tm -- 最后修改时间
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'bdmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_tm n
    left join ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_bk o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        o.exp_redem_batch_ser_num <> n.exp_redem_batch_ser_num
        or o.bill_redcst_ser_num <> n.bill_redcst_ser_num
        or o.batch_id <> n.batch_id
        or o.bus_dt <> n.bus_dt
        or o.bus_type_cd <> n.bus_type_cd
        or o.clear_bus_type_cd <> n.clear_bus_type_cd
        or o.prod_id <> n.prod_id
        or o.ctr_nt_id <> n.ctr_nt_id
        or o.bus_org_id <> n.bus_org_id
        or o.hq_org_id <> n.hq_org_id
        or o.cap_acct_id <> n.cap_acct_id
        or o.acct_instit_id <> n.acct_instit_id
        or o.dealer_id <> n.dealer_id
        or o.actl_stl_amt <> n.actl_stl_amt
        or o.stl_bill_cnt <> n.stl_bill_cnt
        or o.stl_int_paybl <> n.stl_int_paybl
        or o.entry_status_cd <> n.entry_status_cd
        or o.clear_status_cd <> n.clear_status_cd
        or o.final_modif_operr_id <> n.final_modif_operr_id
        or o.final_modif_tm <> n.final_modif_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,exp_redem_batch_ser_num -- 到期赎回批次序列号
    ,bill_redcst_ser_num -- 票据再贴现序列号
    ,batch_id -- 批次编号
    ,bus_dt -- 业务日期
    ,bus_type_cd -- 业务类型代码
    ,clear_bus_type_cd -- 清算业务类型代码
    ,prod_id -- 产品编号
    ,ctr_nt_id -- 成交单编号
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,cap_acct_id -- 资金账户编号
    ,acct_instit_id -- 账务机构编号
    ,dealer_id -- 交易员编号
    ,actl_stl_amt -- 实际结算金额
    ,stl_bill_cnt -- 结算票据张数
    ,stl_int_paybl -- 结算应付利息
    ,entry_status_cd -- 记账状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,exp_redem_batch_ser_num -- 到期赎回批次序列号
    ,bill_redcst_ser_num -- 票据再贴现序列号
    ,batch_id -- 批次编号
    ,bus_dt -- 业务日期
    ,bus_type_cd -- 业务类型代码
    ,clear_bus_type_cd -- 清算业务类型代码
    ,prod_id -- 产品编号
    ,ctr_nt_id -- 成交单编号
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,cap_acct_id -- 资金账户编号
    ,acct_instit_id -- 账务机构编号
    ,dealer_id -- 交易员编号
    ,actl_stl_amt -- 实际结算金额
    ,stl_bill_cnt -- 结算票据张数
    ,stl_int_paybl -- 结算应付利息
    ,entry_status_cd -- 记账状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.exp_redem_batch_ser_num -- 到期赎回批次序列号
    ,o.bill_redcst_ser_num -- 票据再贴现序列号
    ,o.batch_id -- 批次编号
    ,o.bus_dt -- 业务日期
    ,o.bus_type_cd -- 业务类型代码
    ,o.clear_bus_type_cd -- 清算业务类型代码
    ,o.prod_id -- 产品编号
    ,o.ctr_nt_id -- 成交单编号
    ,o.bus_org_id -- 业务机构编号
    ,o.hq_org_id -- 总行机构编号
    ,o.cap_acct_id -- 资金账户编号
    ,o.acct_instit_id -- 账务机构编号
    ,o.dealer_id -- 交易员编号
    ,o.actl_stl_amt -- 实际结算金额
    ,o.stl_bill_cnt -- 结算票据张数
    ,o.stl_int_paybl -- 结算应付利息
    ,o.entry_status_cd -- 记账状态代码
    ,o.clear_status_cd -- 清算状态代码
    ,o.final_modif_operr_id -- 最后修改操作员编号
    ,o.final_modif_tm -- 最后修改时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_bk o
    left join ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;


-- 4.1 rebuild partition
whenever sqlerror continue none;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_bill_redcst_exp_redem_batch') 
               and substr(subpartition_name,1,8)=upper('p_bdmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_bill_redcst_exp_redem_batch drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_bill_redcst_exp_redem_batch modify partition p_bdmsi1 
add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','YYYYMMDD'));
  
-- 4.2 exchange partition
alter table ${iml_schema}.evt_bill_redcst_exp_redem_batch exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_cl;
alter table ${iml_schema}.evt_bill_redcst_exp_redem_batch exchange subpartition p_bdmsi1_20991231 with table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bill_redcst_exp_redem_batch to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_tm purge;
drop table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_op purge;
drop table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_bill_redcst_exp_redem_batch_bdmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bill_redcst_exp_redem_batch', partname => 'p_bdmsi1_20991231', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1', no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
