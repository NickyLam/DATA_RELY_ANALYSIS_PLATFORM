/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wld_dubil_attach_info_icmsf1
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
alter table ${iml_schema}.agt_wld_dubil_attach_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_dubil_attach_info partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_tm purge;
drop table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_op purge;
drop table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,batch_dt -- 批量日期
    ,logic_card_no -- 逻辑卡号
    ,dubil_id -- 借据编号
    ,tran_plan_id -- 转让计划编号
    ,tran_bf_init_syn_id -- 转让前初始银团编号
    ,tran_ref_no -- 交易参考号
    ,exec_year_int_rat -- 执行年利率
    ,currt_lpr_val -- 当期LPR值
    ,lpr_pub_dt -- LPR公布日期
    ,conti_owe_this_days -- 连续欠本天数
    ,conti_over_int_days -- 连续欠息天数
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_dubil_attach_info partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_dubil_attach_info partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_dubil_attach_info partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_report_ds_loan_receipt_additional_info_day-1
insert into ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,batch_dt -- 批量日期
    ,logic_card_no -- 逻辑卡号
    ,dubil_id -- 借据编号
    ,tran_plan_id -- 转让计划编号
    ,tran_bf_init_syn_id -- 转让前初始银团编号
    ,tran_ref_no -- 交易参考号
    ,exec_year_int_rat -- 执行年利率
    ,currt_lpr_val -- 当期LPR值
    ,lpr_pub_dt -- LPR公布日期
    ,conti_owe_this_days -- 连续欠本天数
    ,conti_over_int_days -- 连续欠息天数
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222650'||TO_CHAR(P2.LOANID) -- 协议编号
    ,'9999' -- 法人编号
    ,' ' -- 批量文件名称
    ,' ' -- 序列号
    ,${iml_schema}.dateformat_max2(P1.PARTITIONDATE) -- 批量日期
    ,P1.LOGICALCARDNO -- 逻辑卡号
    ,P1.LOANRECEIPTNBR -- 借据编号
    ,P1.ASSETPLANNO -- 转让计划编号
    ,P1.LASTBANKGROUPID -- 转让前初始银团编号
    ,P1.REFNBR -- 交易参考号
    ,P1.INTEGERERESTRATE*100 -- 执行年利率
    ,P1.LPR*100 -- 当期LPR值
    ,P1.LPRDATE -- LPR公布日期
    ,to_number(nvl(P1.RESERVE34,'0')) -- 连续欠本天数
    ,to_number(nvl(P1.RESERVE35,'0')) -- 连续欠息天数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_report_ds_loan_receipt_additional_info_day' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day p1
    inner join ${iol_schema}.icms_wld_tm_loan p2 on P1.REFNBR = P2.REFNBR and p2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND p2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND P1.LASTBANKGROUPID in ('GHB06','GHB07')
    AND P1.PARTITIONDATE = '${batch_date}'
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_tm 
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
        into ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,batch_dt -- 批量日期
    ,logic_card_no -- 逻辑卡号
    ,dubil_id -- 借据编号
    ,tran_plan_id -- 转让计划编号
    ,tran_bf_init_syn_id -- 转让前初始银团编号
    ,tran_ref_no -- 交易参考号
    ,exec_year_int_rat -- 执行年利率
    ,currt_lpr_val -- 当期LPR值
    ,lpr_pub_dt -- LPR公布日期
    ,conti_owe_this_days -- 连续欠本天数
    ,conti_over_int_days -- 连续欠息天数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,batch_dt -- 批量日期
    ,logic_card_no -- 逻辑卡号
    ,dubil_id -- 借据编号
    ,tran_plan_id -- 转让计划编号
    ,tran_bf_init_syn_id -- 转让前初始银团编号
    ,tran_ref_no -- 交易参考号
    ,exec_year_int_rat -- 执行年利率
    ,currt_lpr_val -- 当期LPR值
    ,lpr_pub_dt -- LPR公布日期
    ,conti_owe_this_days -- 连续欠本天数
    ,conti_over_int_days -- 连续欠息天数
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
    ,nvl(n.batch_doc_name, o.batch_doc_name) as batch_doc_name -- 批量文件名称
    ,nvl(n.ser_num, o.ser_num) as ser_num -- 序列号
    ,nvl(n.batch_dt, o.batch_dt) as batch_dt -- 批量日期
    ,nvl(n.logic_card_no, o.logic_card_no) as logic_card_no -- 逻辑卡号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.tran_plan_id, o.tran_plan_id) as tran_plan_id -- 转让计划编号
    ,nvl(n.tran_bf_init_syn_id, o.tran_bf_init_syn_id) as tran_bf_init_syn_id -- 转让前初始银团编号
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.exec_year_int_rat, o.exec_year_int_rat) as exec_year_int_rat -- 执行年利率
    ,nvl(n.currt_lpr_val, o.currt_lpr_val) as currt_lpr_val -- 当期LPR值
    ,nvl(n.lpr_pub_dt, o.lpr_pub_dt) as lpr_pub_dt -- LPR公布日期
    ,nvl(n.conti_owe_this_days, o.conti_owe_this_days) as conti_owe_this_days -- 连续欠本天数
    ,nvl(n.conti_over_int_days, o.conti_over_int_days) as conti_over_int_days -- 连续欠息天数
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
from ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.batch_doc_name <> n.batch_doc_name
        or o.ser_num <> n.ser_num
        or o.batch_dt <> n.batch_dt
        or o.logic_card_no <> n.logic_card_no
        or o.dubil_id <> n.dubil_id
        or o.tran_plan_id <> n.tran_plan_id
        or o.tran_bf_init_syn_id <> n.tran_bf_init_syn_id
        or o.tran_ref_no <> n.tran_ref_no
        or o.exec_year_int_rat <> n.exec_year_int_rat
        or o.currt_lpr_val <> n.currt_lpr_val
        or o.lpr_pub_dt <> n.lpr_pub_dt
        or o.conti_owe_this_days <> n.conti_owe_this_days
        or o.conti_over_int_days <> n.conti_over_int_days
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,batch_dt -- 批量日期
    ,logic_card_no -- 逻辑卡号
    ,dubil_id -- 借据编号
    ,tran_plan_id -- 转让计划编号
    ,tran_bf_init_syn_id -- 转让前初始银团编号
    ,tran_ref_no -- 交易参考号
    ,exec_year_int_rat -- 执行年利率
    ,currt_lpr_val -- 当期LPR值
    ,lpr_pub_dt -- LPR公布日期
    ,conti_owe_this_days -- 连续欠本天数
    ,conti_over_int_days -- 连续欠息天数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,batch_dt -- 批量日期
    ,logic_card_no -- 逻辑卡号
    ,dubil_id -- 借据编号
    ,tran_plan_id -- 转让计划编号
    ,tran_bf_init_syn_id -- 转让前初始银团编号
    ,tran_ref_no -- 交易参考号
    ,exec_year_int_rat -- 执行年利率
    ,currt_lpr_val -- 当期LPR值
    ,lpr_pub_dt -- LPR公布日期
    ,conti_owe_this_days -- 连续欠本天数
    ,conti_over_int_days -- 连续欠息天数
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
    ,o.batch_doc_name -- 批量文件名称
    ,o.ser_num -- 序列号
    ,o.batch_dt -- 批量日期
    ,o.logic_card_no -- 逻辑卡号
    ,o.dubil_id -- 借据编号
    ,o.tran_plan_id -- 转让计划编号
    ,o.tran_bf_init_syn_id -- 转让前初始银团编号
    ,o.tran_ref_no -- 交易参考号
    ,o.exec_year_int_rat -- 执行年利率
    ,o.currt_lpr_val -- 当期LPR值
    ,o.lpr_pub_dt -- LPR公布日期
    ,o.conti_owe_this_days -- 连续欠本天数
    ,o.conti_over_int_days -- 连续欠息天数
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
from ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_bk o
    left join ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_cl d
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
--truncate table ${iml_schema}.agt_wld_dubil_attach_info;
--alter table ${iml_schema}.agt_wld_dubil_attach_info truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wld_dubil_attach_info') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wld_dubil_attach_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_wld_dubil_attach_info modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wld_dubil_attach_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_cl;
alter table ${iml_schema}.agt_wld_dubil_attach_info exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wld_dubil_attach_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_tm purge;
drop table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_op purge;
drop table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wld_dubil_attach_info_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wld_dubil_attach_info', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
