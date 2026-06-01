/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_acp_repay_plan_h_myhbf1
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
alter table ${iml_schema}.agt_acp_repay_plan_h add partition p_myhbf1 values ('myhbf1')(
        subpartition p_myhbf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_myhbf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

create table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_acp_repay_plan_h partition for ('myhbf1') 
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_tm purge;
drop table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_op purge;
drop table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,pd_num -- 期次号
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,inst_status_cd -- 分期状态代码
    ,payoff_dt -- 结清日期
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,nomal_pric_bal -- 正常本金余额
    ,int_bal -- 利息余额
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,acru_non_acru_flg -- 应计非应计标志
    ,wrt_off_flg -- 核销标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_acp_repay_plan_h partition for ('myhbf1')
where 0=1
;

create table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_acp_repay_plan_h partition for ('myhbf1') where 0=1;

create table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_acp_repay_plan_h partition for ('myhbf1') where 0=1;

-- 3.1 get new data into table
-- icms_myhb_istmnt_daily_init_info-
insert into ${iml_schema}.agt_acp_repay_plan_h_myhbf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,pd_num -- 期次号
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,inst_status_cd -- 分期状态代码
    ,payoff_dt -- 结清日期
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,nomal_pric_bal -- 正常本金余额
    ,int_bal -- 利息余额
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,acru_non_acru_flg -- 应计非应计标志
    ,wrt_off_flg -- 核销标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222610'||P1.CONTRACTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CONTRACTNO -- 借据编号
    ,P1.TERMNO -- 期次号
    ,${iml_schema}.DATEFORMAT_MIN(P1.STARTDATE) -- 分期开始日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 分期结束日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 分期状态代码
    ,${iml_schema}.dateformat_max2(P1.CLEARDATE) -- 结清日期
    ,${iml_schema}.dateformat_max2(P1.PRINOVDDATE) -- 本金转逾期日期
    ,${iml_schema}.dateformat_max2(P1.INTOVDDATE) -- 利息转逾期日期
    ,P1.BEGINPRIN/100 -- 应还本金
    ,P1.BEGININT/100 -- 应还利息
    ,P1.PRINBAL/100 -- 正常本金余额
    ,P1.INTBAL/100 -- 利息余额
    ,P1.OVDPRINPNLTBAL/100 -- 应还逾期本金罚息
    ,P1.OVDINTPNLTBAL/100 -- 应还逾期利息罚息
    ,P1.PRINOVDDAYS -- 本金逾期天数
    ,P1.INTOVDDAYS -- 利息逾期天数
    ,NVL(TRIM(P1.ACCRUEDSTATUS),'-') -- 应计非应计标志
    ,NVL(TRIM(P1.WRITEOFF),'N') -- 核销标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_myhb_istmnt_daily_init_info' -- 源表名称
    ,'myhbf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_myhb_istmnt_daily_init_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_MYHB_ISTMNT_DAILY_INIT_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_ACP_REPAY_PLAN_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INST_STATUS_CD'
where  1 = 1 
    and P1.etl_dt=to_date('${batch_date}','yyyymmdd') 
;
commit;


commit;


whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_acp_repay_plan_h_myhbf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,pd_num
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
insert /*+ append */ into ${iml_schema}.agt_acp_repay_plan_h_myhbf1_op(
        agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,pd_num -- 期次号
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,inst_status_cd -- 分期状态代码
    ,payoff_dt -- 结清日期
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,nomal_pric_bal -- 正常本金余额
    ,int_bal -- 利息余额
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,acru_non_acru_flg -- 应计非应计标志
    ,wrt_off_flg -- 核销标志
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.agt_id -- 协议编号
    ,n.lp_id -- 法人编号
    ,n.dubil_id -- 借据编号
    ,n.pd_num -- 期次号
    ,n.inst_start_dt -- 分期开始日期
    ,n.inst_end_dt -- 分期结束日期
    ,n.inst_status_cd -- 分期状态代码
    ,n.payoff_dt -- 结清日期
    ,n.pric_turn_ovdue_dt -- 本金转逾期日期
    ,n.int_turn_ovdue_dt -- 利息转逾期日期
    ,n.rpbl_pric -- 应还本金
    ,n.rpbl_int -- 应还利息
    ,n.nomal_pric_bal -- 正常本金余额
    ,n.int_bal -- 利息余额
    ,n.rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,n.rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,n.pric_ovdue_days -- 本金逾期天数
    ,n.int_ovdue_days -- 利息逾期天数
    ,n.acru_non_acru_flg -- 应计非应计标志
    ,n.wrt_off_flg -- 核销标志
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'myhbf1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_acp_repay_plan_h_myhbf1_tm n
    left join ${iml_schema}.agt_acp_repay_plan_h_myhbf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.pd_num = n.pd_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.pd_num is null
    )
    or (
        o.dubil_id <> n.dubil_id
        or o.inst_start_dt <> n.inst_start_dt
        or o.inst_end_dt <> n.inst_end_dt
        or o.inst_status_cd <> n.inst_status_cd
        or o.payoff_dt <> n.payoff_dt
        or o.pric_turn_ovdue_dt <> n.pric_turn_ovdue_dt
        or o.int_turn_ovdue_dt <> n.int_turn_ovdue_dt
        or o.rpbl_pric <> n.rpbl_pric
        or o.rpbl_int <> n.rpbl_int
        or o.nomal_pric_bal <> n.nomal_pric_bal
        or o.int_bal <> n.int_bal
        or o.rpbl_ovdue_pric_pnlt <> n.rpbl_ovdue_pric_pnlt
        or o.rpbl_ovdue_int_pnlt <> n.rpbl_ovdue_int_pnlt
        or o.pric_ovdue_days <> n.pric_ovdue_days
        or o.int_ovdue_days <> n.int_ovdue_days
        or o.acru_non_acru_flg <> n.acru_non_acru_flg
        or o.wrt_off_flg <> n.wrt_off_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_acp_repay_plan_h_myhbf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,pd_num -- 期次号
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,inst_status_cd -- 分期状态代码
    ,payoff_dt -- 结清日期
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,nomal_pric_bal -- 正常本金余额
    ,int_bal -- 利息余额
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,acru_non_acru_flg -- 应计非应计标志
    ,wrt_off_flg -- 核销标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_acp_repay_plan_h_myhbf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,pd_num -- 期次号
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,inst_status_cd -- 分期状态代码
    ,payoff_dt -- 结清日期
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,nomal_pric_bal -- 正常本金余额
    ,int_bal -- 利息余额
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,acru_non_acru_flg -- 应计非应计标志
    ,wrt_off_flg -- 核销标志
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
    ,o.pd_num -- 期次号
    ,o.inst_start_dt -- 分期开始日期
    ,o.inst_end_dt -- 分期结束日期
    ,o.inst_status_cd -- 分期状态代码
    ,o.payoff_dt -- 结清日期
    ,o.pric_turn_ovdue_dt -- 本金转逾期日期
    ,o.int_turn_ovdue_dt -- 利息转逾期日期
    ,o.rpbl_pric -- 应还本金
    ,o.rpbl_int -- 应还利息
    ,o.nomal_pric_bal -- 正常本金余额
    ,o.int_bal -- 利息余额
    ,o.rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,o.rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,o.pric_ovdue_days -- 本金逾期天数
    ,o.int_ovdue_days -- 利息逾期天数
    ,o.acru_non_acru_flg -- 应计非应计标志
    ,o.wrt_off_flg -- 核销标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_acp_repay_plan_h_myhbf1_bk o
    left join ${iml_schema}.agt_acp_repay_plan_h_myhbf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.pd_num = n.pd_num
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
               and table_name=upper('agt_acp_repay_plan_h') 
               and substr(subpartition_name,1,8)=upper('p_myhbf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_acp_repay_plan_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_acp_repay_plan_h modify partition p_myhbf1 
add subpartition p_myhbf1_${batch_date} values (to_date('${batch_date}','YYYYMMDD'));
  
-- 4.2 exchange partition
alter table ${iml_schema}.agt_acp_repay_plan_h exchange subpartition p_myhbf1_${batch_date} with table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_cl;
alter table ${iml_schema}.agt_acp_repay_plan_h exchange subpartition p_myhbf1_20991231 with table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_acp_repay_plan_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_tm purge;
drop table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_op purge;
drop table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_acp_repay_plan_h_myhbf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_acp_repay_plan_h', partname => 'p_myhbf1_20991231', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1', no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
