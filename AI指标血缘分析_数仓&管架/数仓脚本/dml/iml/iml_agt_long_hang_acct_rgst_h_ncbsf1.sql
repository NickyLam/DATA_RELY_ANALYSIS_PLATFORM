/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_long_hang_acct_rgst_h_ncbsf1
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
alter table ${iml_schema}.agt_long_hang_acct_rgst_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_long_hang_acct_rgst_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_status_cd -- 账户状态代码
    ,acct_name -- 账户名称
    ,bus_tran_dt -- 业务交易日期
    ,tran_org_id -- 交易机构编号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,amt_type_cd -- 金额类型代码
    ,curr_bal -- 当前余额
    ,turn_dormt_acct_dt -- 转不动户日期
    ,turn_long_hang_dt -- 转久悬日期
    ,ex_dt -- 出库日期
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,addit_remark -- 附加备注
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_long_hang_acct_rgst_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_long_hang_acct_rgst_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_long_hang_acct_rgst_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_acct_doss-1
insert into ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_status_cd -- 账户状态代码
    ,acct_name -- 账户名称
    ,bus_tran_dt -- 业务交易日期
    ,tran_org_id -- 交易机构编号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,amt_type_cd -- 金额类型代码
    ,curr_bal -- 当前余额
    ,turn_dormt_acct_dt -- 转不动户日期
    ,turn_long_hang_dt -- 转久悬日期
    ,ex_dt -- 出库日期
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,addit_remark -- 附加备注
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_CCY -- 币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,nvl(trim(P1.ACCT_STATUS),'-') -- 账户状态代码
    ,P1.ACCT_NAME -- 账户名称
    ,P1.TRAN_DATE -- 业务交易日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.DOSS_OPERATE_TYPE -- 转久悬操作类型代码
    ,nvl(trim(P1.AMT_TYPE),'-') -- 金额类型代码
    ,P1.BALANCE -- 当前余额
    ,P1.DORMANT_DATE -- 转不动户日期
    ,P1.DOSS_DATE -- 转久悬日期
    ,P1.OUT_DATE -- 出库日期
    ,P1.INT_AMT -- 利息金额
    ,P1.POR_INT_TOT -- 账户本息合计
    ,P1.TAX_SC -- 账户利息税
    ,P1.REMARK -- 附加备注
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct_doss' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct_doss p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
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
        into ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_status_cd -- 账户状态代码
    ,acct_name -- 账户名称
    ,bus_tran_dt -- 业务交易日期
    ,tran_org_id -- 交易机构编号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,amt_type_cd -- 金额类型代码
    ,curr_bal -- 当前余额
    ,turn_dormt_acct_dt -- 转不动户日期
    ,turn_long_hang_dt -- 转久悬日期
    ,ex_dt -- 出库日期
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,addit_remark -- 附加备注
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_status_cd -- 账户状态代码
    ,acct_name -- 账户名称
    ,bus_tran_dt -- 业务交易日期
    ,tran_org_id -- 交易机构编号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,amt_type_cd -- 金额类型代码
    ,curr_bal -- 当前余额
    ,turn_dormt_acct_dt -- 转不动户日期
    ,turn_long_hang_dt -- 转久悬日期
    ,ex_dt -- 出库日期
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,addit_remark -- 附加备注
    ,tran_teller_id -- 交易柜员编号
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
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.bus_tran_dt, o.bus_tran_dt) as bus_tran_dt -- 业务交易日期
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.turn_long_hang_oper_type_cd, o.turn_long_hang_oper_type_cd) as turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,nvl(n.amt_type_cd, o.amt_type_cd) as amt_type_cd -- 金额类型代码
    ,nvl(n.curr_bal, o.curr_bal) as curr_bal -- 当前余额
    ,nvl(n.turn_dormt_acct_dt, o.turn_dormt_acct_dt) as turn_dormt_acct_dt -- 转不动户日期
    ,nvl(n.turn_long_hang_dt, o.turn_long_hang_dt) as turn_long_hang_dt -- 转久悬日期
    ,nvl(n.ex_dt, o.ex_dt) as ex_dt -- 出库日期
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.acct_pric_int_sum, o.acct_pric_int_sum) as acct_pric_int_sum -- 账户本息合计
    ,nvl(n.acct_int_tax, o.acct_int_tax) as acct_int_tax -- 账户利息税
    ,nvl(n.addit_remark, o.addit_remark) as addit_remark -- 附加备注
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.sub_acct_num <> n.sub_acct_num
        or o.acct_status_cd <> n.acct_status_cd
        or o.acct_name <> n.acct_name
        or o.bus_tran_dt <> n.bus_tran_dt
        or o.tran_org_id <> n.tran_org_id
        or o.turn_long_hang_oper_type_cd <> n.turn_long_hang_oper_type_cd
        or o.amt_type_cd <> n.amt_type_cd
        or o.curr_bal <> n.curr_bal
        or o.turn_dormt_acct_dt <> n.turn_dormt_acct_dt
        or o.turn_long_hang_dt <> n.turn_long_hang_dt
        or o.ex_dt <> n.ex_dt
        or o.int_amt <> n.int_amt
        or o.acct_pric_int_sum <> n.acct_pric_int_sum
        or o.acct_int_tax <> n.acct_int_tax
        or o.addit_remark <> n.addit_remark
        or o.tran_teller_id <> n.tran_teller_id
        or o.tran_tm <> n.tran_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_status_cd -- 账户状态代码
    ,acct_name -- 账户名称
    ,bus_tran_dt -- 业务交易日期
    ,tran_org_id -- 交易机构编号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,amt_type_cd -- 金额类型代码
    ,curr_bal -- 当前余额
    ,turn_dormt_acct_dt -- 转不动户日期
    ,turn_long_hang_dt -- 转久悬日期
    ,ex_dt -- 出库日期
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,addit_remark -- 附加备注
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_status_cd -- 账户状态代码
    ,acct_name -- 账户名称
    ,bus_tran_dt -- 业务交易日期
    ,tran_org_id -- 交易机构编号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,amt_type_cd -- 金额类型代码
    ,curr_bal -- 当前余额
    ,turn_dormt_acct_dt -- 转不动户日期
    ,turn_long_hang_dt -- 转久悬日期
    ,ex_dt -- 出库日期
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,addit_remark -- 附加备注
    ,tran_teller_id -- 交易柜员编号
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
    ,o.acct_id -- 账户编号
    ,o.cust_id -- 客户编号
    ,o.cust_acct_num -- 客户账号
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.sub_acct_num -- 子账号
    ,o.acct_status_cd -- 账户状态代码
    ,o.acct_name -- 账户名称
    ,o.bus_tran_dt -- 业务交易日期
    ,o.tran_org_id -- 交易机构编号
    ,o.turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,o.amt_type_cd -- 金额类型代码
    ,o.curr_bal -- 当前余额
    ,o.turn_dormt_acct_dt -- 转不动户日期
    ,o.turn_long_hang_dt -- 转久悬日期
    ,o.ex_dt -- 出库日期
    ,o.int_amt -- 利息金额
    ,o.acct_pric_int_sum -- 账户本息合计
    ,o.acct_int_tax -- 账户利息税
    ,o.addit_remark -- 附加备注
    ,o.tran_teller_id -- 交易柜员编号
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
from ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_bk o
    left join ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_long_hang_acct_rgst_h;
--alter table ${iml_schema}.agt_long_hang_acct_rgst_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_long_hang_acct_rgst_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_long_hang_acct_rgst_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_long_hang_acct_rgst_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_long_hang_acct_rgst_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_cl;
alter table ${iml_schema}.agt_long_hang_acct_rgst_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_long_hang_acct_rgst_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_long_hang_acct_rgst_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_long_hang_acct_rgst_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
