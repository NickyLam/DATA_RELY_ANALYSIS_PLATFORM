/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_abs_amt_dtl_splt_h_ncbsf1
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
alter table ${iml_schema}.agt_abs_amt_dtl_splt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_abs_amt_dtl_splt_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_amt_dtl_seq_num -- 资产金额明细序号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,paybl_bank_int_amt -- 应付行内金额
    ,loan_surp_amt -- 贷款剩余金额
    ,redem_paybl_cntpty_int -- 赎回应付对手利息
    ,redem_surp_cntpty_int -- 赎回剩余对手利息
    ,pkg_tran_in_suspd_crdt_acct_amt -- 封包转入暂收款账户金额
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_abs_amt_dtl_splt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_abs_amt_dtl_splt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_abs_amt_dtl_splt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_transfer_amt_detail-1
insert into ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_amt_dtl_seq_num -- 资产金额明细序号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,paybl_bank_int_amt -- 应付行内金额
    ,loan_surp_amt -- 贷款剩余金额
    ,redem_paybl_cntpty_int -- 赎回应付对手利息
    ,redem_surp_cntpty_int -- 赎回剩余对手利息
    ,pkg_tran_in_suspd_crdt_acct_amt -- 封包转入暂收款账户金额
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300015'||P1.ASSET_AMT_SEQ_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ASSET_AMT_SEQ_NO -- 资产金额明细序号
    ,P1.ASSET_DETAIL_SEQ_NO -- 资产包合同明细序号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.AMT_TYPE -- 金额类型代码
    ,P1.COPE_AMOUNT -- 应付行内金额
    ,P1.OVER_AMOUNT -- 贷款剩余金额
    ,P1.COPE_REDEEM_AMT -- 赎回应付对手利息
    ,P1.OVER_REDEEM_AMT -- 赎回剩余对手利息
    ,P1.PACK_TRAN_REC_AMT -- 封包转入暂收款账户金额
    ,${iml_schema}.dateformat_max2(P1.LAST_CHANGE_DATE) -- 最后修改日期
    ,to_timestamp(P1.TRAN_TIMESTAMP,'yyyy-mm-dd hh24:mi:ss.ff6') -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_transfer_amt_detail' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_transfer_amt_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,asset_amt_dtl_seq_num
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
        into ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_amt_dtl_seq_num -- 资产金额明细序号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,paybl_bank_int_amt -- 应付行内金额
    ,loan_surp_amt -- 贷款剩余金额
    ,redem_paybl_cntpty_int -- 赎回应付对手利息
    ,redem_surp_cntpty_int -- 赎回剩余对手利息
    ,pkg_tran_in_suspd_crdt_acct_amt -- 封包转入暂收款账户金额
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_amt_dtl_seq_num -- 资产金额明细序号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,paybl_bank_int_amt -- 应付行内金额
    ,loan_surp_amt -- 贷款剩余金额
    ,redem_paybl_cntpty_int -- 赎回应付对手利息
    ,redem_surp_cntpty_int -- 赎回剩余对手利息
    ,pkg_tran_in_suspd_crdt_acct_amt -- 封包转入暂收款账户金额
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
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
    ,nvl(n.asset_amt_dtl_seq_num, o.asset_amt_dtl_seq_num) as asset_amt_dtl_seq_num -- 资产金额明细序号
    ,nvl(n.asset_bag_cont_dtl_seq_num, o.asset_bag_cont_dtl_seq_num) as asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.amt_type_cd, o.amt_type_cd) as amt_type_cd -- 金额类型代码
    ,nvl(n.paybl_bank_int_amt, o.paybl_bank_int_amt) as paybl_bank_int_amt -- 应付行内金额
    ,nvl(n.loan_surp_amt, o.loan_surp_amt) as loan_surp_amt -- 贷款剩余金额
    ,nvl(n.redem_paybl_cntpty_int, o.redem_paybl_cntpty_int) as redem_paybl_cntpty_int -- 赎回应付对手利息
    ,nvl(n.redem_surp_cntpty_int, o.redem_surp_cntpty_int) as redem_surp_cntpty_int -- 赎回剩余对手利息
    ,nvl(n.pkg_tran_in_suspd_crdt_acct_amt, o.pkg_tran_in_suspd_crdt_acct_amt) as pkg_tran_in_suspd_crdt_acct_amt -- 封包转入暂收款账户金额
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.asset_amt_dtl_seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.asset_amt_dtl_seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.asset_amt_dtl_seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.asset_amt_dtl_seq_num = n.asset_amt_dtl_seq_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.asset_amt_dtl_seq_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.asset_amt_dtl_seq_num is null
    )
    or (
        o.asset_bag_cont_dtl_seq_num <> n.asset_bag_cont_dtl_seq_num
        or o.cust_id <> n.cust_id
        or o.amt_type_cd <> n.amt_type_cd
        or o.paybl_bank_int_amt <> n.paybl_bank_int_amt
        or o.loan_surp_amt <> n.loan_surp_amt
        or o.redem_paybl_cntpty_int <> n.redem_paybl_cntpty_int
        or o.redem_surp_cntpty_int <> n.redem_surp_cntpty_int
        or o.pkg_tran_in_suspd_crdt_acct_amt <> n.pkg_tran_in_suspd_crdt_acct_amt
        or o.final_modif_dt <> n.final_modif_dt
        or o.tran_tm <> n.tran_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_amt_dtl_seq_num -- 资产金额明细序号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,paybl_bank_int_amt -- 应付行内金额
    ,loan_surp_amt -- 贷款剩余金额
    ,redem_paybl_cntpty_int -- 赎回应付对手利息
    ,redem_surp_cntpty_int -- 赎回剩余对手利息
    ,pkg_tran_in_suspd_crdt_acct_amt -- 封包转入暂收款账户金额
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_amt_dtl_seq_num -- 资产金额明细序号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,paybl_bank_int_amt -- 应付行内金额
    ,loan_surp_amt -- 贷款剩余金额
    ,redem_paybl_cntpty_int -- 赎回应付对手利息
    ,redem_surp_cntpty_int -- 赎回剩余对手利息
    ,pkg_tran_in_suspd_crdt_acct_amt -- 封包转入暂收款账户金额
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
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
    ,o.asset_amt_dtl_seq_num -- 资产金额明细序号
    ,o.asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,o.cust_id -- 客户编号
    ,o.amt_type_cd -- 金额类型代码
    ,o.paybl_bank_int_amt -- 应付行内金额
    ,o.loan_surp_amt -- 贷款剩余金额
    ,o.redem_paybl_cntpty_int -- 赎回应付对手利息
    ,o.redem_surp_cntpty_int -- 赎回剩余对手利息
    ,o.pkg_tran_in_suspd_crdt_acct_amt -- 封包转入暂收款账户金额
    ,o.final_modif_dt -- 最后修改日期
    ,o.tran_tm -- 交易时间
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
from ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.asset_amt_dtl_seq_num = n.asset_amt_dtl_seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.asset_amt_dtl_seq_num = d.asset_amt_dtl_seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_abs_amt_dtl_splt_h;
--alter table ${iml_schema}.agt_abs_amt_dtl_splt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_abs_amt_dtl_splt_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_abs_amt_dtl_splt_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_abs_amt_dtl_splt_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_abs_amt_dtl_splt_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_abs_amt_dtl_splt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_abs_amt_dtl_splt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_abs_amt_dtl_splt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_abs_amt_dtl_splt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
