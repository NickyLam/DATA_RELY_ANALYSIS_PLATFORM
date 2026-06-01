/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_fft_tran_dtl_icmsf1
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
alter table ${iml_schema}.agt_fft_tran_dtl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_fft_tran_dtl_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fft_tran_dtl partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_fft_tran_dtl_icmsf1_tm purge;
drop table ${iml_schema}.agt_fft_tran_dtl_icmsf1_op purge;
drop table ${iml_schema}.agt_fft_tran_dtl_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fft_tran_dtl_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tot_flow_num -- 汇总流水号
    ,dubil_id -- 借据编号
    ,sell_int_rat -- 卖出利率
    ,tran_sell_recvbl_amt -- 转卖收款金额
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,tran_sell_exp_dt -- 转卖到期日期
    ,amorted_amt -- 待摊金额
    ,inter_bus_inco_amt -- 中间业务收入金额
    ,issue_bank_bank_no -- 开证行行号
    ,acpt_bank_bank_no -- 承兑行行号
    ,lc_benefc_indus_type_cd -- 信用证受益人行业类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fft_tran_dtl partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_fft_tran_dtl_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fft_tran_dtl partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_fft_tran_dtl_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fft_tran_dtl partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_acct_trans_fft_detail-1
insert into ${iml_schema}.agt_fft_tran_dtl_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tot_flow_num -- 汇总流水号
    ,dubil_id -- 借据编号
    ,sell_int_rat -- 卖出利率
    ,tran_sell_recvbl_amt -- 转卖收款金额
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,tran_sell_exp_dt -- 转卖到期日期
    ,amorted_amt -- 待摊金额
    ,inter_bus_inco_amt -- 中间业务收入金额
    ,issue_bank_bank_no -- 开证行行号
    ,acpt_bank_bank_no -- 承兑行行号
    ,lc_benefc_indus_type_cd -- 信用证受益人行业类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300033'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 流水号
    ,P1.OBJECTNO -- 汇总流水号
    ,P1.BDSERIALNO -- 借据编号
    ,P1.SALERATE -- 卖出利率
    ,P1.RESALEGATHER -- 转卖收款金额
    ,P1.REMITCOMEXPENSE -- 汇入手续费金额
    ,P1.RESALEMATURITY -- 转卖到期日期
    ,P1.PREPAIDAMOUNT -- 待摊金额
    ,P1.INTERBUSINESSREVE -- 中间业务收入金额
    ,P1.ISSUEBANK -- 开证行行号
    ,P1.ACCEPTBANK -- 承兑行行号
    ,nvl(trim(P1.CLASSOFBENETRADE),'-') -- 信用证受益人行业类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_acct_trans_fft_detail' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_acct_trans_fft_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_fft_tran_dtl_icmsf1_tm 
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
        into ${iml_schema}.agt_fft_tran_dtl_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tot_flow_num -- 汇总流水号
    ,dubil_id -- 借据编号
    ,sell_int_rat -- 卖出利率
    ,tran_sell_recvbl_amt -- 转卖收款金额
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,tran_sell_exp_dt -- 转卖到期日期
    ,amorted_amt -- 待摊金额
    ,inter_bus_inco_amt -- 中间业务收入金额
    ,issue_bank_bank_no -- 开证行行号
    ,acpt_bank_bank_no -- 承兑行行号
    ,lc_benefc_indus_type_cd -- 信用证受益人行业类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_fft_tran_dtl_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tot_flow_num -- 汇总流水号
    ,dubil_id -- 借据编号
    ,sell_int_rat -- 卖出利率
    ,tran_sell_recvbl_amt -- 转卖收款金额
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,tran_sell_exp_dt -- 转卖到期日期
    ,amorted_amt -- 待摊金额
    ,inter_bus_inco_amt -- 中间业务收入金额
    ,issue_bank_bank_no -- 开证行行号
    ,acpt_bank_bank_no -- 承兑行行号
    ,lc_benefc_indus_type_cd -- 信用证受益人行业类型代码
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
    ,nvl(n.flow_num, o.flow_num) as flow_num -- 流水号
    ,nvl(n.tot_flow_num, o.tot_flow_num) as tot_flow_num -- 汇总流水号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.sell_int_rat, o.sell_int_rat) as sell_int_rat -- 卖出利率
    ,nvl(n.tran_sell_recvbl_amt, o.tran_sell_recvbl_amt) as tran_sell_recvbl_amt -- 转卖收款金额
    ,nvl(n.abmt_comm_fee_amt, o.abmt_comm_fee_amt) as abmt_comm_fee_amt -- 汇入手续费金额
    ,nvl(n.tran_sell_exp_dt, o.tran_sell_exp_dt) as tran_sell_exp_dt -- 转卖到期日期
    ,nvl(n.amorted_amt, o.amorted_amt) as amorted_amt -- 待摊金额
    ,nvl(n.inter_bus_inco_amt, o.inter_bus_inco_amt) as inter_bus_inco_amt -- 中间业务收入金额
    ,nvl(n.issue_bank_bank_no, o.issue_bank_bank_no) as issue_bank_bank_no -- 开证行行号
    ,nvl(n.acpt_bank_bank_no, o.acpt_bank_bank_no) as acpt_bank_bank_no -- 承兑行行号
    ,nvl(n.lc_benefc_indus_type_cd, o.lc_benefc_indus_type_cd) as lc_benefc_indus_type_cd -- 信用证受益人行业类型代码
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
from ${iml_schema}.agt_fft_tran_dtl_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_fft_tran_dtl_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.flow_num <> n.flow_num
        or o.tot_flow_num <> n.tot_flow_num
        or o.dubil_id <> n.dubil_id
        or o.sell_int_rat <> n.sell_int_rat
        or o.tran_sell_recvbl_amt <> n.tran_sell_recvbl_amt
        or o.abmt_comm_fee_amt <> n.abmt_comm_fee_amt
        or o.tran_sell_exp_dt <> n.tran_sell_exp_dt
        or o.amorted_amt <> n.amorted_amt
        or o.inter_bus_inco_amt <> n.inter_bus_inco_amt
        or o.issue_bank_bank_no <> n.issue_bank_bank_no
        or o.acpt_bank_bank_no <> n.acpt_bank_bank_no
        or o.lc_benefc_indus_type_cd <> n.lc_benefc_indus_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_fft_tran_dtl_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tot_flow_num -- 汇总流水号
    ,dubil_id -- 借据编号
    ,sell_int_rat -- 卖出利率
    ,tran_sell_recvbl_amt -- 转卖收款金额
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,tran_sell_exp_dt -- 转卖到期日期
    ,amorted_amt -- 待摊金额
    ,inter_bus_inco_amt -- 中间业务收入金额
    ,issue_bank_bank_no -- 开证行行号
    ,acpt_bank_bank_no -- 承兑行行号
    ,lc_benefc_indus_type_cd -- 信用证受益人行业类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_fft_tran_dtl_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tot_flow_num -- 汇总流水号
    ,dubil_id -- 借据编号
    ,sell_int_rat -- 卖出利率
    ,tran_sell_recvbl_amt -- 转卖收款金额
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,tran_sell_exp_dt -- 转卖到期日期
    ,amorted_amt -- 待摊金额
    ,inter_bus_inco_amt -- 中间业务收入金额
    ,issue_bank_bank_no -- 开证行行号
    ,acpt_bank_bank_no -- 承兑行行号
    ,lc_benefc_indus_type_cd -- 信用证受益人行业类型代码
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
    ,o.flow_num -- 流水号
    ,o.tot_flow_num -- 汇总流水号
    ,o.dubil_id -- 借据编号
    ,o.sell_int_rat -- 卖出利率
    ,o.tran_sell_recvbl_amt -- 转卖收款金额
    ,o.abmt_comm_fee_amt -- 汇入手续费金额
    ,o.tran_sell_exp_dt -- 转卖到期日期
    ,o.amorted_amt -- 待摊金额
    ,o.inter_bus_inco_amt -- 中间业务收入金额
    ,o.issue_bank_bank_no -- 开证行行号
    ,o.acpt_bank_bank_no -- 承兑行行号
    ,o.lc_benefc_indus_type_cd -- 信用证受益人行业类型代码
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
from ${iml_schema}.agt_fft_tran_dtl_icmsf1_bk o
    left join ${iml_schema}.agt_fft_tran_dtl_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_fft_tran_dtl_icmsf1_cl d
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
--truncate table ${iml_schema}.agt_fft_tran_dtl;
--alter table ${iml_schema}.agt_fft_tran_dtl truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_fft_tran_dtl') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_fft_tran_dtl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_fft_tran_dtl modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_fft_tran_dtl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_fft_tran_dtl_icmsf1_cl;
alter table ${iml_schema}.agt_fft_tran_dtl exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_fft_tran_dtl_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_fft_tran_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_fft_tran_dtl_icmsf1_tm purge;
drop table ${iml_schema}.agt_fft_tran_dtl_icmsf1_op purge;
drop table ${iml_schema}.agt_fft_tran_dtl_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_fft_tran_dtl_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_fft_tran_dtl', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
