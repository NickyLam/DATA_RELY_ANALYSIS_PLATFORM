/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_finc_acct_unpaid_prft_h_ifmsf1
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
alter table ${iml_schema}.agt_finc_acct_unpaid_prft_h add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ifmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_acct_unpaid_prft_h partition for ('ifmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_tm purge;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_op purge;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,seller_id -- 销售商编号
    ,cfm_dt -- 确认日期
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,lot_bal -- 份额余额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_acct_unpaid_prft_h partition for ('ifmsf1')
where 0=1
;

create table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_acct_unpaid_prft_h partition for ('ifmsf1') where 0=1;

create table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_acct_unpaid_prft_h partition for ('ifmsf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbincome-
insert into ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,seller_id -- 销售商编号
    ,cfm_dt -- 确认日期
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,lot_bal -- 份额余额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160010'||P2.IN_CLIENT_NO||P2.TA_CODE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.PRD_CODE -- 产品编号
    ,NVL(TRIM(P1.SHARE_CLASS),'-') -- 收费方式代码
    ,P1.SELLER_CODE -- 销售商编号
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,P1.INCOME -- 未付收益
    ,P1.FROZEN_INCOME -- 冻结未付收益
    ,P1.INCOME_NEW -- 当天新增未付收益
    ,P1.REAL_VOL -- 份额余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbincome' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbincome p1
    left join ${iol_schema}.ifms_tbassetacc p2 on P1.asset_acc=P2.ASSET_ACC
and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,finc_acct_id
  	                                        ,ta_tran_acct_id
  	                                        ,prod_id
  	                                        ,charge_way_cd
  	                                        ,seller_id
  	                                        ,cfm_dt
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
        into ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,seller_id -- 销售商编号
    ,cfm_dt -- 确认日期
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,lot_bal -- 份额余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,seller_id -- 销售商编号
    ,cfm_dt -- 确认日期
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,lot_bal -- 份额余额
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
    ,nvl(n.finc_acct_id, o.finc_acct_id) as finc_acct_id -- 理财账户编号
    ,nvl(n.ta_tran_acct_id, o.ta_tran_acct_id) as ta_tran_acct_id -- TA交易账户编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.charge_way_cd, o.charge_way_cd) as charge_way_cd -- 收费方式代码
    ,nvl(n.seller_id, o.seller_id) as seller_id -- 销售商编号
    ,nvl(n.cfm_dt, o.cfm_dt) as cfm_dt -- 确认日期
    ,nvl(n.unpaid_prft, o.unpaid_prft) as unpaid_prft -- 未付收益
    ,nvl(n.froz_unpaid_prft, o.froz_unpaid_prft) as froz_unpaid_prft -- 冻结未付收益
    ,nvl(n.td_add_unpaid_prft, o.td_add_unpaid_prft) as td_add_unpaid_prft -- 当天新增未付收益
    ,nvl(n.lot_bal, o.lot_bal) as lot_bal -- 份额余额
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.finc_acct_id is null
            and n.ta_tran_acct_id is null
            and n.prod_id is null
            and n.charge_way_cd is null
            and n.seller_id is null
            and n.cfm_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.finc_acct_id is null
            and n.ta_tran_acct_id is null
            and n.prod_id is null
            and n.charge_way_cd is null
            and n.seller_id is null
            and n.cfm_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.finc_acct_id is null
            and n.ta_tran_acct_id is null
            and n.prod_id is null
            and n.charge_way_cd is null
            and n.seller_id is null
            and n.cfm_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_tm n
    full join (select * from ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.finc_acct_id = n.finc_acct_id
            and o.ta_tran_acct_id = n.ta_tran_acct_id
            and o.prod_id = n.prod_id
            and o.charge_way_cd = n.charge_way_cd
            and o.seller_id = n.seller_id
            and o.cfm_dt = n.cfm_dt
where (
        o.agt_id is null
        and o.lp_id is null
        and o.finc_acct_id is null
        and o.ta_tran_acct_id is null
        and o.prod_id is null
        and o.charge_way_cd is null
        and o.seller_id is null
        and o.cfm_dt is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.finc_acct_id is null
        and n.ta_tran_acct_id is null
        and n.prod_id is null
        and n.charge_way_cd is null
        and n.seller_id is null
        and n.cfm_dt is null
    )
    or (
        o.unpaid_prft <> n.unpaid_prft
        or o.froz_unpaid_prft <> n.froz_unpaid_prft
        or o.td_add_unpaid_prft <> n.td_add_unpaid_prft
        or o.lot_bal <> n.lot_bal
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,seller_id -- 销售商编号
    ,cfm_dt -- 确认日期
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,lot_bal -- 份额余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,seller_id -- 销售商编号
    ,cfm_dt -- 确认日期
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,td_add_unpaid_prft -- 当天新增未付收益
    ,lot_bal -- 份额余额
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
    ,o.finc_acct_id -- 理财账户编号
    ,o.ta_tran_acct_id -- TA交易账户编号
    ,o.prod_id -- 产品编号
    ,o.charge_way_cd -- 收费方式代码
    ,o.seller_id -- 销售商编号
    ,o.cfm_dt -- 确认日期
    ,o.unpaid_prft -- 未付收益
    ,o.froz_unpaid_prft -- 冻结未付收益
    ,o.td_add_unpaid_prft -- 当天新增未付收益
    ,o.lot_bal -- 份额余额
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
from ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_bk o
    left join ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.finc_acct_id = n.finc_acct_id
            and o.ta_tran_acct_id = n.ta_tran_acct_id
            and o.prod_id = n.prod_id
            and o.charge_way_cd = n.charge_way_cd
            and o.seller_id = n.seller_id
            and o.cfm_dt = n.cfm_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.finc_acct_id = d.finc_acct_id
            and o.ta_tran_acct_id = d.ta_tran_acct_id
            and o.prod_id = d.prod_id
            and o.charge_way_cd = d.charge_way_cd
            and o.seller_id = d.seller_id
            and o.cfm_dt = d.cfm_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_finc_acct_unpaid_prft_h;
--alter table ${iml_schema}.agt_finc_acct_unpaid_prft_h truncate partition for ('ifmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_finc_acct_unpaid_prft_h') 
               and substr(subpartition_name,1,8)=upper('p_ifmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_finc_acct_unpaid_prft_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_finc_acct_unpaid_prft_h modify partition p_ifmsf1 
add subpartition p_ifmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_finc_acct_unpaid_prft_h exchange subpartition p_ifmsf1_${batch_date} with table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_cl;
alter table ${iml_schema}.agt_finc_acct_unpaid_prft_h exchange subpartition p_ifmsf1_20991231 with table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_finc_acct_unpaid_prft_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_tm purge;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_op purge;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h_ifmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_finc_acct_unpaid_prft_h', partname => 'p_ifmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
