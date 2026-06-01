/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ic_card_elec_cash_acct_h_ncbsf1
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
alter table ${iml_schema}.agt_ic_card_elec_cash_acct_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ic_card_elec_cash_acct_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,card_ser_num -- 卡序列号
    ,app_idf -- 应用标识符
    ,elec_cash_acct_status_cd -- 电子现金账户状态代码
    ,elec_cash_acct_curr_cd -- 电子现金账户币种代码
    ,elec_cash_acct_bal -- 电子现金账户余额
    ,elec_cash_bal_uplmi -- 电子现金余额上限
    ,elec_cash_sig_tran_lmt -- 电子现金单笔交易限额
    ,acm_load_amt -- 累计圈存金额
    ,app_effect_dt -- 应用生效日期
    ,app_invalid_dt -- 应用失效日期
    ,elec_cash_acct_open_acct_dt -- 电子现金账户开户日期
    ,open_acct_org_id -- 开户机构编号
    ,acct_name -- 账户名称
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ic_card_elec_cash_acct_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ic_card_elec_cash_acct_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ic_card_elec_cash_acct_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_ic_ec_acct_info-1
insert into ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,card_ser_num -- 卡序列号
    ,app_idf -- 应用标识符
    ,elec_cash_acct_status_cd -- 电子现金账户状态代码
    ,elec_cash_acct_curr_cd -- 电子现金账户币种代码
    ,elec_cash_acct_bal -- 电子现金账户余额
    ,elec_cash_bal_uplmi -- 电子现金余额上限
    ,elec_cash_sig_tran_lmt -- 电子现金单笔交易限额
    ,acm_load_amt -- 累计圈存金额
    ,app_effect_dt -- 应用生效日期
    ,app_invalid_dt -- 应用失效日期
    ,elec_cash_acct_open_acct_dt -- 电子现金账户开户日期
    ,open_acct_org_id -- 开户机构编号
    ,acct_name -- 账户名称
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300025'||P1.CARD_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CARD_NO -- 卡号
    ,P1.IC_CARD_SEQ -- 卡序列号
    ,P1.IC_AID -- 应用标识符
    ,P1.EC_ACCT_STAT -- 电子现金账户状态代码
    ,P1.EC_ACCT_CCY -- 电子现金账户币种代码
    ,P1.IC_ACT_BAL -- 电子现金账户余额
    ,P1.EC_BAL_TOP_LIMIT -- 电子现金余额上限
    ,P1.EC_TRAN_LIMIT -- 电子现金单笔交易限额
    ,P1.AGGR_AMT -- 累计圈存金额
    ,${iml_schema}.dateformat_min(P1.IC_APP_START_DATE) -- 应用生效日期
    ,${iml_schema}.dateformat_max2(P1.IC_APP_END_DATE) -- 应用失效日期
    ,P1.OPEN_DATE -- 电子现金账户开户日期
    ,P1.OPEN_ORG_ID -- 开户机构编号
    ,P1.ACCT_NAME -- 账户名称
    ,decode(P1.ACCT_CLOSE_DATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.ACCT_CLOSE_DATE) -- 销户日期
    ,P1.CLOSE_SEQ_NUM -- 销户流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_ic_ec_acct_info' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_ic_ec_acct_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,card_no
  	                                        ,card_ser_num
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
        into ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,card_ser_num -- 卡序列号
    ,app_idf -- 应用标识符
    ,elec_cash_acct_status_cd -- 电子现金账户状态代码
    ,elec_cash_acct_curr_cd -- 电子现金账户币种代码
    ,elec_cash_acct_bal -- 电子现金账户余额
    ,elec_cash_bal_uplmi -- 电子现金余额上限
    ,elec_cash_sig_tran_lmt -- 电子现金单笔交易限额
    ,acm_load_amt -- 累计圈存金额
    ,app_effect_dt -- 应用生效日期
    ,app_invalid_dt -- 应用失效日期
    ,elec_cash_acct_open_acct_dt -- 电子现金账户开户日期
    ,open_acct_org_id -- 开户机构编号
    ,acct_name -- 账户名称
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,card_ser_num -- 卡序列号
    ,app_idf -- 应用标识符
    ,elec_cash_acct_status_cd -- 电子现金账户状态代码
    ,elec_cash_acct_curr_cd -- 电子现金账户币种代码
    ,elec_cash_acct_bal -- 电子现金账户余额
    ,elec_cash_bal_uplmi -- 电子现金余额上限
    ,elec_cash_sig_tran_lmt -- 电子现金单笔交易限额
    ,acm_load_amt -- 累计圈存金额
    ,app_effect_dt -- 应用生效日期
    ,app_invalid_dt -- 应用失效日期
    ,elec_cash_acct_open_acct_dt -- 电子现金账户开户日期
    ,open_acct_org_id -- 开户机构编号
    ,acct_name -- 账户名称
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
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
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.card_ser_num, o.card_ser_num) as card_ser_num -- 卡序列号
    ,nvl(n.app_idf, o.app_idf) as app_idf -- 应用标识符
    ,nvl(n.elec_cash_acct_status_cd, o.elec_cash_acct_status_cd) as elec_cash_acct_status_cd -- 电子现金账户状态代码
    ,nvl(n.elec_cash_acct_curr_cd, o.elec_cash_acct_curr_cd) as elec_cash_acct_curr_cd -- 电子现金账户币种代码
    ,nvl(n.elec_cash_acct_bal, o.elec_cash_acct_bal) as elec_cash_acct_bal -- 电子现金账户余额
    ,nvl(n.elec_cash_bal_uplmi, o.elec_cash_bal_uplmi) as elec_cash_bal_uplmi -- 电子现金余额上限
    ,nvl(n.elec_cash_sig_tran_lmt, o.elec_cash_sig_tran_lmt) as elec_cash_sig_tran_lmt -- 电子现金单笔交易限额
    ,nvl(n.acm_load_amt, o.acm_load_amt) as acm_load_amt -- 累计圈存金额
    ,nvl(n.app_effect_dt, o.app_effect_dt) as app_effect_dt -- 应用生效日期
    ,nvl(n.app_invalid_dt, o.app_invalid_dt) as app_invalid_dt -- 应用失效日期
    ,nvl(n.elec_cash_acct_open_acct_dt, o.elec_cash_acct_open_acct_dt) as elec_cash_acct_open_acct_dt -- 电子现金账户开户日期
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.clos_acct_dt, o.clos_acct_dt) as clos_acct_dt -- 销户日期
    ,nvl(n.clos_acct_flow_num, o.clos_acct_flow_num) as clos_acct_flow_num -- 销户流水号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.card_no is null
            and n.card_ser_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.card_no is null
            and n.card_ser_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.card_no is null
            and n.card_ser_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.card_no = n.card_no
            and o.card_ser_num = n.card_ser_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.card_no is null
        and o.card_ser_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.card_no is null
        and n.card_ser_num is null
    )
    or (
        o.app_idf <> n.app_idf
        or o.elec_cash_acct_status_cd <> n.elec_cash_acct_status_cd
        or o.elec_cash_acct_curr_cd <> n.elec_cash_acct_curr_cd
        or o.elec_cash_acct_bal <> n.elec_cash_acct_bal
        or o.elec_cash_bal_uplmi <> n.elec_cash_bal_uplmi
        or o.elec_cash_sig_tran_lmt <> n.elec_cash_sig_tran_lmt
        or o.acm_load_amt <> n.acm_load_amt
        or o.app_effect_dt <> n.app_effect_dt
        or o.app_invalid_dt <> n.app_invalid_dt
        or o.elec_cash_acct_open_acct_dt <> n.elec_cash_acct_open_acct_dt
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.acct_name <> n.acct_name
        or o.clos_acct_dt <> n.clos_acct_dt
        or o.clos_acct_flow_num <> n.clos_acct_flow_num
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,card_ser_num -- 卡序列号
    ,app_idf -- 应用标识符
    ,elec_cash_acct_status_cd -- 电子现金账户状态代码
    ,elec_cash_acct_curr_cd -- 电子现金账户币种代码
    ,elec_cash_acct_bal -- 电子现金账户余额
    ,elec_cash_bal_uplmi -- 电子现金余额上限
    ,elec_cash_sig_tran_lmt -- 电子现金单笔交易限额
    ,acm_load_amt -- 累计圈存金额
    ,app_effect_dt -- 应用生效日期
    ,app_invalid_dt -- 应用失效日期
    ,elec_cash_acct_open_acct_dt -- 电子现金账户开户日期
    ,open_acct_org_id -- 开户机构编号
    ,acct_name -- 账户名称
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,card_ser_num -- 卡序列号
    ,app_idf -- 应用标识符
    ,elec_cash_acct_status_cd -- 电子现金账户状态代码
    ,elec_cash_acct_curr_cd -- 电子现金账户币种代码
    ,elec_cash_acct_bal -- 电子现金账户余额
    ,elec_cash_bal_uplmi -- 电子现金余额上限
    ,elec_cash_sig_tran_lmt -- 电子现金单笔交易限额
    ,acm_load_amt -- 累计圈存金额
    ,app_effect_dt -- 应用生效日期
    ,app_invalid_dt -- 应用失效日期
    ,elec_cash_acct_open_acct_dt -- 电子现金账户开户日期
    ,open_acct_org_id -- 开户机构编号
    ,acct_name -- 账户名称
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
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
    ,o.card_no -- 卡号
    ,o.card_ser_num -- 卡序列号
    ,o.app_idf -- 应用标识符
    ,o.elec_cash_acct_status_cd -- 电子现金账户状态代码
    ,o.elec_cash_acct_curr_cd -- 电子现金账户币种代码
    ,o.elec_cash_acct_bal -- 电子现金账户余额
    ,o.elec_cash_bal_uplmi -- 电子现金余额上限
    ,o.elec_cash_sig_tran_lmt -- 电子现金单笔交易限额
    ,o.acm_load_amt -- 累计圈存金额
    ,o.app_effect_dt -- 应用生效日期
    ,o.app_invalid_dt -- 应用失效日期
    ,o.elec_cash_acct_open_acct_dt -- 电子现金账户开户日期
    ,o.open_acct_org_id -- 开户机构编号
    ,o.acct_name -- 账户名称
    ,o.clos_acct_dt -- 销户日期
    ,o.clos_acct_flow_num -- 销户流水号
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
from ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_bk o
    left join ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.card_no = n.card_no
            and o.card_ser_num = n.card_ser_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.card_no = d.card_no
            and o.card_ser_num = d.card_ser_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ic_card_elec_cash_acct_h;
--alter table ${iml_schema}.agt_ic_card_elec_cash_acct_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_ic_card_elec_cash_acct_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_ic_card_elec_cash_acct_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ic_card_elec_cash_acct_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_ic_card_elec_cash_acct_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_cl;
alter table ${iml_schema}.agt_ic_card_elec_cash_acct_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ic_card_elec_cash_acct_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ic_card_elec_cash_acct_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ic_card_elec_cash_acct_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
