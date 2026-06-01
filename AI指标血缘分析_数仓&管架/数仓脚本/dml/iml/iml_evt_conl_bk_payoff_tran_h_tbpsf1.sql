/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_conl_bk_payoff_tran_h_tbpsf1
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
alter table ${iml_schema}.evt_conl_bk_payoff_tran_h add partition p_tbpsf1 values ('tbpsf1')(
        subpartition p_tbpsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_tbpsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_conl_bk_payoff_tran_h partition for ('tbpsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_tm purge;
drop table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_op purge;
drop table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,seq_num -- 序号
    ,cust_id -- 交易客户编号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_id -- 付款人账户编号
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,core_tran_dt -- 核心交易日期
    ,core_batch_id -- 核心批次编号
    ,core_flow_num -- 核心流水号
    ,remark -- 备注
    ,recver_ibank_no -- 收款方联行号
    ,recver_open_brac_name -- 收款方开户网点名称
    ,mobile_no -- 手机号码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,err_info -- 错误信息
    ,bank_int_flg -- 行内标志
    ,emply_id -- 员工编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_conl_bk_payoff_tran_h partition for ('tbpsf1')
where 0=1
;

create table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_conl_bk_payoff_tran_h partition for ('tbpsf1') where 0=1;

create table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_conl_bk_payoff_tran_h partition for ('tbpsf1') where 0=1;

-- 3.1 get new data into table
-- tbps_cpr_salary_batch_detail-1
insert into ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,seq_num -- 序号
    ,cust_id -- 交易客户编号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_id -- 付款人账户编号
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,core_tran_dt -- 核心交易日期
    ,core_batch_id -- 核心批次编号
    ,core_flow_num -- 核心流水号
    ,remark -- 备注
    ,recver_ibank_no -- 收款方联行号
    ,recver_open_brac_name -- 收款方开户网点名称
    ,mobile_no -- 手机号码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,err_info -- 错误信息
    ,bank_int_flg -- 行内标志
    ,emply_id -- 员工编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104048'||P1.SBD_BATCHNO||TO_CHAR(P1.SBD_SEQNO) -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SBD_BATCHNO -- 批次编号
    ,TO_CHAR(P1.SBD_SEQNO) -- 序号
    ,P1.SBD_ECIFNO -- 交易客户编号
    ,P1.SBD_PAYEEACNAME -- 收款人名称
    ,P1.SBD_PAYEEACNO -- 收款人账户编号
    ,P1.SBD_PAYERACNAME -- 付款人名称
    ,P1.SBD_PAYERACNO -- 付款人账户编号
    ,P1.SBD_AMOUNT -- 交易金额
    ,P1.SBD_CURRENCY -- 币种代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.SBD_DETAILSTATE  END -- 交易状态代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.SBD_SALARYDATE) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.SBD_HOSTJNLDATE) -- 核心交易日期
    ,P1.SBD_HOSTBATCHNO -- 核心批次编号
    ,P1.SBD_HOSTJNLNO -- 核心流水号
    ,P1.SBD_REMARK -- 备注
    ,P1.SBD_UNIONDEPTID -- 收款方联行号
    ,P1.SBD_UNIONDEPTNAME -- 收款方开户网点名称
    ,P1.SBD_MOBILEPHONE -- 手机号码
    ,P1.SBD_RETURNCODE -- 返回码
    ,P1.SBD_RETURNMSG -- 返回信息
    ,P1.SBD_ERRORMSG -- 错误信息
    ,CASE WHEN P1.SBD_SYSFLAG='0' THEN '1' ELSE '0' END -- 行内标志
    ,P1.SBD_STAFFNO -- 员工编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tbps_cpr_salary_batch_detail' -- 源表名称
    ,'tbpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tbps_cpr_salary_batch_detail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.SBD_DETAILSTATE  = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'TBPS'
        AND R1.SRC_TAB_EN_NAME= 'TBPS_CPR_SALARY_BATCH_DETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'SBD_DETAILSTATE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CONL_BK_PAYOFF_TRAN_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                                        ,batch_id
  	                                        ,seq_num
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
        into ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,seq_num -- 序号
    ,cust_id -- 交易客户编号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_id -- 付款人账户编号
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,core_tran_dt -- 核心交易日期
    ,core_batch_id -- 核心批次编号
    ,core_flow_num -- 核心流水号
    ,remark -- 备注
    ,recver_ibank_no -- 收款方联行号
    ,recver_open_brac_name -- 收款方开户网点名称
    ,mobile_no -- 手机号码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,err_info -- 错误信息
    ,bank_int_flg -- 行内标志
    ,emply_id -- 员工编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,seq_num -- 序号
    ,cust_id -- 交易客户编号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_id -- 付款人账户编号
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,core_tran_dt -- 核心交易日期
    ,core_batch_id -- 核心批次编号
    ,core_flow_num -- 核心流水号
    ,remark -- 备注
    ,recver_ibank_no -- 收款方联行号
    ,recver_open_brac_name -- 收款方开户网点名称
    ,mobile_no -- 手机号码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,err_info -- 错误信息
    ,bank_int_flg -- 行内标志
    ,emply_id -- 员工编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 交易客户编号
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recver_acct_id, o.recver_acct_id) as recver_acct_id -- 收款人账户编号
    ,nvl(n.payer_name, o.payer_name) as payer_name -- 付款人名称
    ,nvl(n.payer_acct_id, o.payer_acct_id) as payer_acct_id -- 付款人账户编号
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.core_tran_dt, o.core_tran_dt) as core_tran_dt -- 核心交易日期
    ,nvl(n.core_batch_id, o.core_batch_id) as core_batch_id -- 核心批次编号
    ,nvl(n.core_flow_num, o.core_flow_num) as core_flow_num -- 核心流水号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.recver_ibank_no, o.recver_ibank_no) as recver_ibank_no -- 收款方联行号
    ,nvl(n.recver_open_brac_name, o.recver_open_brac_name) as recver_open_brac_name -- 收款方开户网点名称
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.return_code, o.return_code) as return_code -- 返回码
    ,nvl(n.return_info, o.return_info) as return_info -- 返回信息
    ,nvl(n.err_info, o.err_info) as err_info -- 错误信息
    ,nvl(n.bank_int_flg, o.bank_int_flg) as bank_int_flg -- 行内标志
    ,nvl(n.emply_id, o.emply_id) as emply_id -- 员工编号
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.batch_id is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.batch_id is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.batch_id is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_tm n
    full join (select * from ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.batch_id = n.batch_id
            and o.seq_num = n.seq_num
where (
        o.evt_id is null
        and o.lp_id is null
        and o.batch_id is null
        and o.seq_num is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.batch_id is null
        and n.seq_num is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.recver_name <> n.recver_name
        or o.recver_acct_id <> n.recver_acct_id
        or o.payer_name <> n.payer_name
        or o.payer_acct_id <> n.payer_acct_id
        or o.tran_amt <> n.tran_amt
        or o.curr_cd <> n.curr_cd
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_dt <> n.tran_dt
        or o.core_tran_dt <> n.core_tran_dt
        or o.core_batch_id <> n.core_batch_id
        or o.core_flow_num <> n.core_flow_num
        or o.remark <> n.remark
        or o.recver_ibank_no <> n.recver_ibank_no
        or o.recver_open_brac_name <> n.recver_open_brac_name
        or o.mobile_no <> n.mobile_no
        or o.return_code <> n.return_code
        or o.return_info <> n.return_info
        or o.err_info <> n.err_info
        or o.bank_int_flg <> n.bank_int_flg
        or o.emply_id <> n.emply_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,seq_num -- 序号
    ,cust_id -- 交易客户编号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_id -- 付款人账户编号
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,core_tran_dt -- 核心交易日期
    ,core_batch_id -- 核心批次编号
    ,core_flow_num -- 核心流水号
    ,remark -- 备注
    ,recver_ibank_no -- 收款方联行号
    ,recver_open_brac_name -- 收款方开户网点名称
    ,mobile_no -- 手机号码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,err_info -- 错误信息
    ,bank_int_flg -- 行内标志
    ,emply_id -- 员工编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,seq_num -- 序号
    ,cust_id -- 交易客户编号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_id -- 付款人账户编号
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,core_tran_dt -- 核心交易日期
    ,core_batch_id -- 核心批次编号
    ,core_flow_num -- 核心流水号
    ,remark -- 备注
    ,recver_ibank_no -- 收款方联行号
    ,recver_open_brac_name -- 收款方开户网点名称
    ,mobile_no -- 手机号码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,err_info -- 错误信息
    ,bank_int_flg -- 行内标志
    ,emply_id -- 员工编号
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
    ,o.batch_id -- 批次编号
    ,o.seq_num -- 序号
    ,o.cust_id -- 交易客户编号
    ,o.recver_name -- 收款人名称
    ,o.recver_acct_id -- 收款人账户编号
    ,o.payer_name -- 付款人名称
    ,o.payer_acct_id -- 付款人账户编号
    ,o.tran_amt -- 交易金额
    ,o.curr_cd -- 币种代码
    ,o.tran_status_cd -- 交易状态代码
    ,o.tran_dt -- 交易日期
    ,o.core_tran_dt -- 核心交易日期
    ,o.core_batch_id -- 核心批次编号
    ,o.core_flow_num -- 核心流水号
    ,o.remark -- 备注
    ,o.recver_ibank_no -- 收款方联行号
    ,o.recver_open_brac_name -- 收款方开户网点名称
    ,o.mobile_no -- 手机号码
    ,o.return_code -- 返回码
    ,o.return_info -- 返回信息
    ,o.err_info -- 错误信息
    ,o.bank_int_flg -- 行内标志
    ,o.emply_id -- 员工编号
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
from ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_bk o
    left join ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.batch_id = n.batch_id
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.batch_id = d.batch_id
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_conl_bk_payoff_tran_h;
--alter table ${iml_schema}.evt_conl_bk_payoff_tran_h truncate partition for ('tbpsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_conl_bk_payoff_tran_h') 
               and substr(subpartition_name,1,8)=upper('p_tbpsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_conl_bk_payoff_tran_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_conl_bk_payoff_tran_h modify partition p_tbpsf1 
add subpartition p_tbpsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_conl_bk_payoff_tran_h exchange subpartition p_tbpsf1_${batch_date} with table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_cl;
alter table ${iml_schema}.evt_conl_bk_payoff_tran_h exchange subpartition p_tbpsf1_20991231 with table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_conl_bk_payoff_tran_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_tm purge;
drop table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_op purge;
drop table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_conl_bk_payoff_tran_h_tbpsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_conl_bk_payoff_tran_h', partname => 'p_tbpsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
