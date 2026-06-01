/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cust_prefr_exch_rat_info_h_ncbsf1
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
alter table ${iml_schema}.agt_cust_prefr_exch_rat_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cust_prefr_exch_rat_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,prefr_exch_rat_type_cd -- 优惠汇率类型代码
    ,cust_id -- 客户编号
    ,appl_org_id -- 申请机构编号
    ,curr_cd -- 币种代码
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_dt -- 交易日期
    ,offset_prefr_val -- 平盘优惠值
    ,prefr_begin_dt -- 优惠起始日期
    ,prefr_exp_dt -- 优惠到期日期
    ,prefr_days -- 优惠天数
    ,prefr_status_cd -- 优惠状态代码
    ,exch_rat_prefr_way_cd -- 汇率优惠方式代码
    ,single_acct_prefr_val -- 单户优惠值
    ,wrt_guat_type_cd -- 结售汇类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cust_prefr_exch_rat_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cust_prefr_exch_rat_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cust_prefr_exch_rat_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_client_exchange_rate_discount-1
insert into ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,prefr_exch_rat_type_cd -- 优惠汇率类型代码
    ,cust_id -- 客户编号
    ,appl_org_id -- 申请机构编号
    ,curr_cd -- 币种代码
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_dt -- 交易日期
    ,offset_prefr_val -- 平盘优惠值
    ,prefr_begin_dt -- 优惠起始日期
    ,prefr_exp_dt -- 优惠到期日期
    ,prefr_days -- 优惠天数
    ,prefr_status_cd -- 优惠状态代码
    ,exch_rat_prefr_way_cd -- 汇率优惠方式代码
    ,single_acct_prefr_val -- 单户优惠值
    ,wrt_guat_type_cd -- 结售汇类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300020'||P1.INT_RATE_FORM_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INT_RATE_FORM_NO -- 利率审批单编号
    ,P1.COUPON_RATE_TYPE -- 优惠汇率类型代码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.APPLY_BRANCH -- 申请机构编号
    ,P1.CCY -- 币种代码
    ,P1.BRANCH -- 交易机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.UNC_DISCOUNT_VALUE -- 平盘优惠值
    ,P1.INT_VALID_FROM_DATE -- 优惠起始日期
    ,P1.INT_VALID_THRU_DATE -- 优惠到期日期
    ,P1.DISCOUNT_TERM -- 优惠天数
    ,P1.DISCOUNT_STATUS -- 优惠状态代码
    ,P1.EXCHANGE_DISCOUNT_TYPE -- 汇率优惠方式代码
    ,P1.DISCOUNT_VALUE -- 单户优惠值
    ,P1.EXCHANGE_TYPE -- 结售汇类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_client_exchange_rate_discount' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_client_exchange_rate_discount p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,int_rat_apv_form_id
  	                                        ,prefr_exch_rat_type_cd
  	                                        ,cust_id
  	                                        ,appl_org_id
  	                                        ,curr_cd
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
        into ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,prefr_exch_rat_type_cd -- 优惠汇率类型代码
    ,cust_id -- 客户编号
    ,appl_org_id -- 申请机构编号
    ,curr_cd -- 币种代码
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_dt -- 交易日期
    ,offset_prefr_val -- 平盘优惠值
    ,prefr_begin_dt -- 优惠起始日期
    ,prefr_exp_dt -- 优惠到期日期
    ,prefr_days -- 优惠天数
    ,prefr_status_cd -- 优惠状态代码
    ,exch_rat_prefr_way_cd -- 汇率优惠方式代码
    ,single_acct_prefr_val -- 单户优惠值
    ,wrt_guat_type_cd -- 结售汇类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,prefr_exch_rat_type_cd -- 优惠汇率类型代码
    ,cust_id -- 客户编号
    ,appl_org_id -- 申请机构编号
    ,curr_cd -- 币种代码
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_dt -- 交易日期
    ,offset_prefr_val -- 平盘优惠值
    ,prefr_begin_dt -- 优惠起始日期
    ,prefr_exp_dt -- 优惠到期日期
    ,prefr_days -- 优惠天数
    ,prefr_status_cd -- 优惠状态代码
    ,exch_rat_prefr_way_cd -- 汇率优惠方式代码
    ,single_acct_prefr_val -- 单户优惠值
    ,wrt_guat_type_cd -- 结售汇类型代码
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
    ,nvl(n.int_rat_apv_form_id, o.int_rat_apv_form_id) as int_rat_apv_form_id -- 利率审批单编号
    ,nvl(n.prefr_exch_rat_type_cd, o.prefr_exch_rat_type_cd) as prefr_exch_rat_type_cd -- 优惠汇率类型代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.appl_org_id, o.appl_org_id) as appl_org_id -- 申请机构编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.offset_prefr_val, o.offset_prefr_val) as offset_prefr_val -- 平盘优惠值
    ,nvl(n.prefr_begin_dt, o.prefr_begin_dt) as prefr_begin_dt -- 优惠起始日期
    ,nvl(n.prefr_exp_dt, o.prefr_exp_dt) as prefr_exp_dt -- 优惠到期日期
    ,nvl(n.prefr_days, o.prefr_days) as prefr_days -- 优惠天数
    ,nvl(n.prefr_status_cd, o.prefr_status_cd) as prefr_status_cd -- 优惠状态代码
    ,nvl(n.exch_rat_prefr_way_cd, o.exch_rat_prefr_way_cd) as exch_rat_prefr_way_cd -- 汇率优惠方式代码
    ,nvl(n.single_acct_prefr_val, o.single_acct_prefr_val) as single_acct_prefr_val -- 单户优惠值
    ,nvl(n.wrt_guat_type_cd, o.wrt_guat_type_cd) as wrt_guat_type_cd -- 结售汇类型代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.int_rat_apv_form_id is null
            and n.prefr_exch_rat_type_cd is null
            and n.cust_id is null
            and n.appl_org_id is null
            and n.curr_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.int_rat_apv_form_id is null
            and n.prefr_exch_rat_type_cd is null
            and n.cust_id is null
            and n.appl_org_id is null
            and n.curr_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.int_rat_apv_form_id is null
            and n.prefr_exch_rat_type_cd is null
            and n.cust_id is null
            and n.appl_org_id is null
            and n.curr_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.int_rat_apv_form_id = n.int_rat_apv_form_id
            and o.prefr_exch_rat_type_cd = n.prefr_exch_rat_type_cd
            and o.cust_id = n.cust_id
            and o.appl_org_id = n.appl_org_id
            and o.curr_cd = n.curr_cd
where (
        o.agt_id is null
        and o.lp_id is null
        and o.int_rat_apv_form_id is null
        and o.prefr_exch_rat_type_cd is null
        and o.cust_id is null
        and o.appl_org_id is null
        and o.curr_cd is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.int_rat_apv_form_id is null
        and n.prefr_exch_rat_type_cd is null
        and n.cust_id is null
        and n.appl_org_id is null
        and n.curr_cd is null
    )
    or (
        o.tran_org_id <> n.tran_org_id
        or o.tran_teller_id <> n.tran_teller_id
        or o.tran_dt <> n.tran_dt
        or o.offset_prefr_val <> n.offset_prefr_val
        or o.prefr_begin_dt <> n.prefr_begin_dt
        or o.prefr_exp_dt <> n.prefr_exp_dt
        or o.prefr_days <> n.prefr_days
        or o.prefr_status_cd <> n.prefr_status_cd
        or o.exch_rat_prefr_way_cd <> n.exch_rat_prefr_way_cd
        or o.single_acct_prefr_val <> n.single_acct_prefr_val
        or o.wrt_guat_type_cd <> n.wrt_guat_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,prefr_exch_rat_type_cd -- 优惠汇率类型代码
    ,cust_id -- 客户编号
    ,appl_org_id -- 申请机构编号
    ,curr_cd -- 币种代码
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_dt -- 交易日期
    ,offset_prefr_val -- 平盘优惠值
    ,prefr_begin_dt -- 优惠起始日期
    ,prefr_exp_dt -- 优惠到期日期
    ,prefr_days -- 优惠天数
    ,prefr_status_cd -- 优惠状态代码
    ,exch_rat_prefr_way_cd -- 汇率优惠方式代码
    ,single_acct_prefr_val -- 单户优惠值
    ,wrt_guat_type_cd -- 结售汇类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,prefr_exch_rat_type_cd -- 优惠汇率类型代码
    ,cust_id -- 客户编号
    ,appl_org_id -- 申请机构编号
    ,curr_cd -- 币种代码
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_dt -- 交易日期
    ,offset_prefr_val -- 平盘优惠值
    ,prefr_begin_dt -- 优惠起始日期
    ,prefr_exp_dt -- 优惠到期日期
    ,prefr_days -- 优惠天数
    ,prefr_status_cd -- 优惠状态代码
    ,exch_rat_prefr_way_cd -- 汇率优惠方式代码
    ,single_acct_prefr_val -- 单户优惠值
    ,wrt_guat_type_cd -- 结售汇类型代码
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
    ,o.int_rat_apv_form_id -- 利率审批单编号
    ,o.prefr_exch_rat_type_cd -- 优惠汇率类型代码
    ,o.cust_id -- 客户编号
    ,o.appl_org_id -- 申请机构编号
    ,o.curr_cd -- 币种代码
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.tran_dt -- 交易日期
    ,o.offset_prefr_val -- 平盘优惠值
    ,o.prefr_begin_dt -- 优惠起始日期
    ,o.prefr_exp_dt -- 优惠到期日期
    ,o.prefr_days -- 优惠天数
    ,o.prefr_status_cd -- 优惠状态代码
    ,o.exch_rat_prefr_way_cd -- 汇率优惠方式代码
    ,o.single_acct_prefr_val -- 单户优惠值
    ,o.wrt_guat_type_cd -- 结售汇类型代码
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
from ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.int_rat_apv_form_id = n.int_rat_apv_form_id
            and o.prefr_exch_rat_type_cd = n.prefr_exch_rat_type_cd
            and o.cust_id = n.cust_id
            and o.appl_org_id = n.appl_org_id
            and o.curr_cd = n.curr_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.int_rat_apv_form_id = d.int_rat_apv_form_id
            and o.prefr_exch_rat_type_cd = d.prefr_exch_rat_type_cd
            and o.cust_id = d.cust_id
            and o.appl_org_id = d.appl_org_id
            and o.curr_cd = d.curr_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cust_prefr_exch_rat_info_h;
--alter table ${iml_schema}.agt_cust_prefr_exch_rat_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_cust_prefr_exch_rat_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_cust_prefr_exch_rat_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_cust_prefr_exch_rat_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_cust_prefr_exch_rat_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_cust_prefr_exch_rat_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cust_prefr_exch_rat_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cust_prefr_exch_rat_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cust_prefr_exch_rat_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
