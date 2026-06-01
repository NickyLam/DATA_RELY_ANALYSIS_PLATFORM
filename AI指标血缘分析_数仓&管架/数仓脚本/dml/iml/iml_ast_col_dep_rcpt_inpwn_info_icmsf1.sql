/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_dep_rcpt_inpwn_info_icmsf1
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
alter table ${iml_schema}.ast_col_dep_rcpt_inpwn_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_dep_rcpt_inpwn_info partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_op purge;
drop table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    col_id -- 押品编号
    ,lp_id -- 法人编号
    ,dep_rcpt_type_cd -- 存单类型代码
    ,dep_rcpt_amt -- 存单金额
    ,dep_rcpt_int_rat -- 存单利率
    ,dep_term -- 存期
    ,curr_cd -- 币种代码
    ,subscr_acct_id -- 认购账户编号
    ,stop_pay_acct_id -- 止付账户编号
    ,liab_acct_id -- 负债账户编号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,aval_amt -- 账户可用余额
    ,vouch_no -- 凭证号码
    ,effect_dt -- 生效日期
    ,vouch_type_cd -- 凭证类型代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,cust_id -- 客户编号
    ,other_comnt -- 其他说明
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_dep_rcpt_inpwn_info partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_dep_rcpt_inpwn_info partition for ('icmsf1') where 0=1;

create table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_dep_rcpt_inpwn_info partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_clr_asset_finance_deposit-1
insert into ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_tm(
    col_id -- 押品编号
    ,lp_id -- 法人编号
    ,dep_rcpt_type_cd -- 存单类型代码
    ,dep_rcpt_amt -- 存单金额
    ,dep_rcpt_int_rat -- 存单利率
    ,dep_term -- 存期
    ,curr_cd -- 币种代码
    ,subscr_acct_id -- 认购账户编号
    ,stop_pay_acct_id -- 止付账户编号
    ,liab_acct_id -- 负债账户编号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,aval_amt -- 账户可用余额
    ,vouch_no -- 凭证号码
    ,vouch_type_cd -- 生效日期
    ,effect_dt -- 凭证类型代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,cust_id -- 客户编号
    ,other_comnt -- 其他说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CLRID -- 押品编号
    ,'9999' -- 法人编号
    ,nvl(trim(P1.DEPOSITTYPE),'-') -- 存单类型代码
    ,P1.DEPOSITSUM -- 存单金额
    ,P1.RATE -- 存单利率
    ,P1.DEPOSITDAYS -- 存期
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.BUYACCOUNT -- 认购账户编号
    ,P1.ACCOUNT -- 止付账户编号
    ,P1.LIABACCOUNT -- 负债账户编号
    ,P1.SUBACCOUNT -- 子账号
    ,P1.ACCOUNTNAME -- 账户名称
    ,P1.USEBALANCE -- 账户可用余额
    ,P1.CERTIFICATENO -- 凭证号码
    ,nvl(trim(P1.VOUCHERTYPE),'999') -- 生效日期
    ,P1.STARTDATE -- 凭证类型代码
    ,P1.VALUEDATE -- 起息日期
    ,P1.ENDDATE -- 到期日期
    ,P1.PRODUCTID -- 产品编号
    ,P1.PRODUCTNAME -- 产品名称
    ,P1.CUSTOMERID -- 客户编号
    ,P1.REMARK -- 其他说明
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_clr_asset_finance_deposit' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_clr_asset_finance_deposit p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_tm 
  	                                group by 
  	                                        col_id
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
        into ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_cl(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,dep_rcpt_type_cd -- 存单类型代码
    ,dep_rcpt_amt -- 存单金额
    ,dep_rcpt_int_rat -- 存单利率
    ,dep_term -- 存期
    ,curr_cd -- 币种代码
    ,subscr_acct_id -- 认购账户编号
    ,stop_pay_acct_id -- 止付账户编号
    ,liab_acct_id -- 负债账户编号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,aval_amt -- 账户可用余额
    ,vouch_no -- 凭证号码
    ,effect_dt -- 生效日期
    ,vouch_type_cd -- 凭证类型代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,cust_id -- 客户编号
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_op(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,dep_rcpt_type_cd -- 存单类型代码
    ,dep_rcpt_amt -- 存单金额
    ,dep_rcpt_int_rat -- 存单利率
    ,dep_term -- 存期
    ,curr_cd -- 币种代码
    ,subscr_acct_id -- 认购账户编号
    ,stop_pay_acct_id -- 止付账户编号
    ,liab_acct_id -- 负债账户编号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,aval_amt -- 账户可用余额
    ,vouch_no -- 凭证号码
    ,effect_dt -- 生效日期
    ,vouch_type_cd -- 凭证类型代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,cust_id -- 客户编号
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.col_id, o.col_id) as col_id -- 押品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dep_rcpt_type_cd, o.dep_rcpt_type_cd) as dep_rcpt_type_cd -- 存单类型代码
    ,nvl(n.dep_rcpt_amt, o.dep_rcpt_amt) as dep_rcpt_amt -- 存单金额
    ,nvl(n.dep_rcpt_int_rat, o.dep_rcpt_int_rat) as dep_rcpt_int_rat -- 存单利率
    ,nvl(n.dep_term, o.dep_term) as dep_term -- 存期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.subscr_acct_id, o.subscr_acct_id) as subscr_acct_id -- 认购账户编号
    ,nvl(n.stop_pay_acct_id, o.stop_pay_acct_id) as stop_pay_acct_id -- 止付账户编号
    ,nvl(n.liab_acct_id, o.liab_acct_id) as liab_acct_id -- 负债账户编号
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.aval_amt, o.aval_amt) as aval_amt -- 账户可用余额
    ,nvl(n.vouch_no, o.vouch_no) as vouch_no -- 凭证号码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.vouch_type_cd, o.vouch_type_cd) as vouch_type_cd -- 凭证类型代码
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,case when
            n.col_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.col_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.col_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_tm n
    full join (select * from ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.col_id = n.col_id
            and o.lp_id = n.lp_id
where (
        o.col_id is null
        and o.lp_id is null
    )
    or (
        n.col_id is null
        and n.lp_id is null
    )
    or (
        o.dep_rcpt_type_cd <> n.dep_rcpt_type_cd
        or o.dep_rcpt_amt <> n.dep_rcpt_amt
        or o.dep_rcpt_int_rat <> n.dep_rcpt_int_rat
        or o.dep_term <> n.dep_term
        or o.curr_cd <> n.curr_cd
        or o.subscr_acct_id <> n.subscr_acct_id
        or o.stop_pay_acct_id <> n.stop_pay_acct_id
        or o.liab_acct_id <> n.liab_acct_id
        or o.sub_acct_num <> n.sub_acct_num
        or o.acct_name <> n.acct_name
        or o.aval_amt <> n.aval_amt
        or o.vouch_no <> n.vouch_no
        or o.effect_dt <> n.effect_dt
        or o.vouch_type_cd <> n.vouch_type_cd
        or o.value_dt <> n.value_dt
        or o.exp_dt <> n.exp_dt
        or o.prod_id <> n.prod_id
        or o.prod_name <> n.prod_name
        or o.cust_id <> n.cust_id
        or o.other_comnt <> n.other_comnt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_cl(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,dep_rcpt_type_cd -- 存单类型代码
    ,dep_rcpt_amt -- 存单金额
    ,dep_rcpt_int_rat -- 存单利率
    ,dep_term -- 存期
    ,curr_cd -- 币种代码
    ,subscr_acct_id -- 认购账户编号
    ,stop_pay_acct_id -- 止付账户编号
    ,liab_acct_id -- 负债账户编号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,aval_amt -- 账户可用余额
    ,vouch_no -- 凭证号码
    ,effect_dt -- 生效日期
    ,vouch_type_cd -- 凭证类型代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,cust_id -- 客户编号
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_op(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,dep_rcpt_type_cd -- 存单类型代码
    ,dep_rcpt_amt -- 存单金额
    ,dep_rcpt_int_rat -- 存单利率
    ,dep_term -- 存期
    ,curr_cd -- 币种代码
    ,subscr_acct_id -- 认购账户编号
    ,stop_pay_acct_id -- 止付账户编号
    ,liab_acct_id -- 负债账户编号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,aval_amt -- 账户可用余额
    ,vouch_no -- 凭证号码
    ,effect_dt -- 生效日期
    ,vouch_type_cd -- 凭证类型代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,cust_id -- 客户编号
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.col_id -- 押品编号
    ,o.lp_id -- 法人编号
    ,o.dep_rcpt_type_cd -- 存单类型代码
    ,o.dep_rcpt_amt -- 存单金额
    ,o.dep_rcpt_int_rat -- 存单利率
    ,o.dep_term -- 存期
    ,o.curr_cd -- 币种代码
    ,o.subscr_acct_id -- 认购账户编号
    ,o.stop_pay_acct_id -- 止付账户编号
    ,o.liab_acct_id -- 负债账户编号
    ,o.sub_acct_num -- 子账号
    ,o.acct_name -- 账户名称
    ,o.aval_amt -- 账户可用余额
    ,o.vouch_no -- 凭证号码
    ,o.effect_dt -- 生效日期
    ,o.vouch_type_cd -- 凭证类型代码
    ,o.value_dt -- 起息日期
    ,o.exp_dt -- 到期日期
    ,o.prod_id -- 产品编号
    ,o.prod_name -- 产品名称
    ,o.cust_id -- 客户编号
    ,o.other_comnt -- 其他说明
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
from ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_bk o
    left join ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_op n
        on
            o.col_id = n.col_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_cl d
        on
            o.col_id = d.col_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_col_dep_rcpt_inpwn_info;
--alter table ${iml_schema}.ast_col_dep_rcpt_inpwn_info truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ast_col_dep_rcpt_inpwn_info') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ast_col_dep_rcpt_inpwn_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_dep_rcpt_inpwn_info modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ast_col_dep_rcpt_inpwn_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_cl;
alter table ${iml_schema}.ast_col_dep_rcpt_inpwn_info exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_dep_rcpt_inpwn_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_op purge;
drop table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_col_dep_rcpt_inpwn_info_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_dep_rcpt_inpwn_info', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
