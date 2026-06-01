/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_coll_dtl_bdmsf1
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
alter table ${iml_schema}.agt_bill_coll_dtl add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_coll_dtl partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,coll_dtl_id -- 托收明细编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,entry_status_cd -- 记账状态代码
    ,acpt_bank_addr -- 承兑行地址
    ,core_entry_acct_num -- 核心记账账号
    ,entry_dt -- 记账日期
    ,in_acct_dt -- 来账日期
    ,in_acct_info_src_name -- 来账信息来源名称
    ,in_acct_que_flow_num -- 来账查询流水号
    ,valet_coll_flg -- 代客托收标志
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_num -- 提示付款人账号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,send_out_coll_dt -- 发出托收日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,coll_dtl_status_cd -- 托收明细状态代码
    ,bill_amt -- 票据金额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_coll_dtl partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_coll_dtl partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_coll_dtl partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_bms_send_coll_details-
insert into ${iml_schema}.agt_bill_coll_dtl_bdmsf1_tm(
    agt_id -- 协议编号
    ,coll_dtl_id -- 托收明细编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,entry_status_cd -- 记账状态代码
    ,acpt_bank_addr -- 承兑行地址
    ,core_entry_acct_num -- 核心记账账号
    ,entry_dt -- 记账日期
    ,in_acct_dt -- 来账日期
    ,in_acct_info_src_name -- 来账信息来源名称
    ,in_acct_que_flow_num -- 来账查询流水号
    ,valet_coll_flg -- 代客托收标志
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_num -- 提示付款人账号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,send_out_coll_dt -- 发出托收日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,coll_dtl_status_cd -- 托收明细状态代码
    ,bill_amt -- 票据金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223105'||P1.ID -- 协议编号
    ,P1.ID -- 托收明细编号
    ,'9999' -- 法人编号
    ,P1.CONTRACT_ID -- 批次编号
    ,P1.DRAFT_ID -- 票据编号
    ,nvl(trim(P1.ACCOUNT_STATUS),'-') -- 记账状态代码
    ,P1.RECEIVER_ADDRESS -- 承兑行地址
    ,P1.CORE_ACCOUNT -- 核心记账账号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.TXN_DATE) -- 记账日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.TRANDATE) -- 来账日期
    ,P1.PAYMSGSRC -- 来账信息来源名称
    ,P1.TRANNUMBER -- 来账查询流水号
    ,NVL(TRIM(P1.VALET_FLAG),'-') -- 代客托收标志
    ,P1.DRFT_HLDR_NAME -- 提示付款人名称
    ,P1.DRFT_HLDR_ACCOUNT -- 提示付款人账号
    ,P1.DRFT_HLDR_BANK_NO -- 提示付款人开户行行号
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_DATE) -- 发出托收日期
    ,NVL(TRIM(P1.APPLY_CURCD),'-') -- 提示付款币种代码
    ,P1.LAST_OPERATOR_NO -- 最后修改操作员编号
    ,P1.LAST_TXN_DATE -- 最后修改时间
    ,NVL(TRIM(P1.SEND_COLL_STATUS),'-') -- 托收明细状态代码
    ,P1.DRAFT_AMOUNT -- 票据金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_send_coll_details' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_send_coll_details p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_coll_dtl_bdmsf1_tm 
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
        into ${iml_schema}.agt_bill_coll_dtl_bdmsf1_cl(
            agt_id -- 协议编号
    ,coll_dtl_id -- 托收明细编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,entry_status_cd -- 记账状态代码
    ,acpt_bank_addr -- 承兑行地址
    ,core_entry_acct_num -- 核心记账账号
    ,entry_dt -- 记账日期
    ,in_acct_dt -- 来账日期
    ,in_acct_info_src_name -- 来账信息来源名称
    ,in_acct_que_flow_num -- 来账查询流水号
    ,valet_coll_flg -- 代客托收标志
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_num -- 提示付款人账号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,send_out_coll_dt -- 发出托收日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,coll_dtl_status_cd -- 托收明细状态代码
    ,bill_amt -- 票据金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_coll_dtl_bdmsf1_op(
            agt_id -- 协议编号
    ,coll_dtl_id -- 托收明细编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,entry_status_cd -- 记账状态代码
    ,acpt_bank_addr -- 承兑行地址
    ,core_entry_acct_num -- 核心记账账号
    ,entry_dt -- 记账日期
    ,in_acct_dt -- 来账日期
    ,in_acct_info_src_name -- 来账信息来源名称
    ,in_acct_que_flow_num -- 来账查询流水号
    ,valet_coll_flg -- 代客托收标志
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_num -- 提示付款人账号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,send_out_coll_dt -- 发出托收日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,coll_dtl_status_cd -- 托收明细状态代码
    ,bill_amt -- 票据金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.coll_dtl_id, o.coll_dtl_id) as coll_dtl_id -- 托收明细编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.acpt_bank_addr, o.acpt_bank_addr) as acpt_bank_addr -- 承兑行地址
    ,nvl(n.core_entry_acct_num, o.core_entry_acct_num) as core_entry_acct_num -- 核心记账账号
    ,nvl(n.entry_dt, o.entry_dt) as entry_dt -- 记账日期
    ,nvl(n.in_acct_dt, o.in_acct_dt) as in_acct_dt -- 来账日期
    ,nvl(n.in_acct_info_src_name, o.in_acct_info_src_name) as in_acct_info_src_name -- 来账信息来源名称
    ,nvl(n.in_acct_que_flow_num, o.in_acct_que_flow_num) as in_acct_que_flow_num -- 来账查询流水号
    ,nvl(n.valet_coll_flg, o.valet_coll_flg) as valet_coll_flg -- 代客托收标志
    ,nvl(n.sugst_payer_name, o.sugst_payer_name) as sugst_payer_name -- 提示付款人名称
    ,nvl(n.sugst_payer_acct_num, o.sugst_payer_acct_num) as sugst_payer_acct_num -- 提示付款人账号
    ,nvl(n.sugst_payer_open_bank_no, o.sugst_payer_open_bank_no) as sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,nvl(n.send_out_coll_dt, o.send_out_coll_dt) as send_out_coll_dt -- 发出托收日期
    ,nvl(n.sugst_pay_curr_cd, o.sugst_pay_curr_cd) as sugst_pay_curr_cd -- 提示付款币种代码
    ,nvl(n.final_modif_operr_id, o.final_modif_operr_id) as final_modif_operr_id -- 最后修改操作员编号
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.coll_dtl_status_cd, o.coll_dtl_status_cd) as coll_dtl_status_cd -- 托收明细状态代码
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 票据金额
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
from ${iml_schema}.agt_bill_coll_dtl_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_bill_coll_dtl_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.coll_dtl_id <> n.coll_dtl_id
        or o.batch_id <> n.batch_id
        or o.bill_id <> n.bill_id
        or o.entry_status_cd <> n.entry_status_cd
        or o.acpt_bank_addr <> n.acpt_bank_addr
        or o.core_entry_acct_num <> n.core_entry_acct_num
        or o.entry_dt <> n.entry_dt
        or o.in_acct_dt <> n.in_acct_dt
        or o.in_acct_info_src_name <> n.in_acct_info_src_name
        or o.in_acct_que_flow_num <> n.in_acct_que_flow_num
        or o.valet_coll_flg <> n.valet_coll_flg
        or o.sugst_payer_name <> n.sugst_payer_name
        or o.sugst_payer_acct_num <> n.sugst_payer_acct_num
        or o.sugst_payer_open_bank_no <> n.sugst_payer_open_bank_no
        or o.send_out_coll_dt <> n.send_out_coll_dt
        or o.sugst_pay_curr_cd <> n.sugst_pay_curr_cd
        or o.final_modif_operr_id <> n.final_modif_operr_id
        or o.final_modif_tm <> n.final_modif_tm
        or o.coll_dtl_status_cd <> n.coll_dtl_status_cd
        or o.bill_amt <> n.bill_amt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_bill_coll_dtl_bdmsf1_cl(
            agt_id -- 协议编号
    ,coll_dtl_id -- 托收明细编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,entry_status_cd -- 记账状态代码
    ,acpt_bank_addr -- 承兑行地址
    ,core_entry_acct_num -- 核心记账账号
    ,entry_dt -- 记账日期
    ,in_acct_dt -- 来账日期
    ,in_acct_info_src_name -- 来账信息来源名称
    ,in_acct_que_flow_num -- 来账查询流水号
    ,valet_coll_flg -- 代客托收标志
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_num -- 提示付款人账号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,send_out_coll_dt -- 发出托收日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,coll_dtl_status_cd -- 托收明细状态代码
    ,bill_amt -- 票据金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_coll_dtl_bdmsf1_op(
            agt_id -- 协议编号
    ,coll_dtl_id -- 托收明细编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,entry_status_cd -- 记账状态代码
    ,acpt_bank_addr -- 承兑行地址
    ,core_entry_acct_num -- 核心记账账号
    ,entry_dt -- 记账日期
    ,in_acct_dt -- 来账日期
    ,in_acct_info_src_name -- 来账信息来源名称
    ,in_acct_que_flow_num -- 来账查询流水号
    ,valet_coll_flg -- 代客托收标志
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_num -- 提示付款人账号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,send_out_coll_dt -- 发出托收日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,coll_dtl_status_cd -- 托收明细状态代码
    ,bill_amt -- 票据金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.coll_dtl_id -- 托收明细编号
    ,o.lp_id -- 法人编号
    ,o.batch_id -- 批次编号
    ,o.bill_id -- 票据编号
    ,o.entry_status_cd -- 记账状态代码
    ,o.acpt_bank_addr -- 承兑行地址
    ,o.core_entry_acct_num -- 核心记账账号
    ,o.entry_dt -- 记账日期
    ,o.in_acct_dt -- 来账日期
    ,o.in_acct_info_src_name -- 来账信息来源名称
    ,o.in_acct_que_flow_num -- 来账查询流水号
    ,o.valet_coll_flg -- 代客托收标志
    ,o.sugst_payer_name -- 提示付款人名称
    ,o.sugst_payer_acct_num -- 提示付款人账号
    ,o.sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,o.send_out_coll_dt -- 发出托收日期
    ,o.sugst_pay_curr_cd -- 提示付款币种代码
    ,o.final_modif_operr_id -- 最后修改操作员编号
    ,o.final_modif_tm -- 最后修改时间
    ,o.coll_dtl_status_cd -- 托收明细状态代码
    ,o.bill_amt -- 票据金额
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
from ${iml_schema}.agt_bill_coll_dtl_bdmsf1_bk o
    left join ${iml_schema}.agt_bill_coll_dtl_bdmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_bill_coll_dtl_bdmsf1_cl d
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
--truncate table ${iml_schema}.agt_bill_coll_dtl;
--alter table ${iml_schema}.agt_bill_coll_dtl truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_bill_coll_dtl') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_bill_coll_dtl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_bill_coll_dtl modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_bill_coll_dtl exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_cl;
alter table ${iml_schema}.agt_bill_coll_dtl exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_coll_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_bill_coll_dtl_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_coll_dtl', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
