/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_finc_hold_period_lot_dtl_h_ifmsf1
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
alter table ${iml_schema}.agt_finc_hold_period_lot_dtl_h add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ifmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_hold_period_lot_dtl_h partition for ('ifmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_tm purge;
drop table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_op purge;
drop table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ta_acct_id -- TA账户编号
    ,prod_id -- 产品编号
    ,cfm_dt -- 确认日期
    ,cfm_flow_num -- 确认流水号
    ,lot_rgst_dt -- 份额注册日期
    ,forward_dt -- 下发日期
    ,intnal_cust_id -- 内部客户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,froz_lot -- 冻结份额
    ,last_redembl_dt -- 上一次可赎回日期
    ,ta_tot_lot -- TA端总份额
    ,ta_aval_lot -- TA端可用份额
    ,ta_froz_lot -- TA端冻结份额
    ,lot_dtl_flg -- 份额明细标志
    ,redembl_dt -- 可赎回日期
    ,acct_status_cd -- 账户状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_hold_period_lot_dtl_h partition for ('ifmsf1')
where 0=1
;

create table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_hold_period_lot_dtl_h partition for ('ifmsf1') where 0=1;

create table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_hold_period_lot_dtl_h partition for ('ifmsf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbsharedtlfund-
insert into ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ta_acct_id -- TA账户编号
    ,prod_id -- 产品编号
    ,cfm_dt -- 确认日期
    ,cfm_flow_num -- 确认流水号
    ,lot_rgst_dt -- 份额注册日期
    ,forward_dt -- 下发日期
    ,intnal_cust_id -- 内部客户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,froz_lot -- 冻结份额
    ,last_redembl_dt -- 上一次可赎回日期
    ,ta_tot_lot -- TA端总份额
    ,ta_aval_lot -- TA端可用份额
    ,ta_froz_lot -- TA端冻结份额
    ,lot_dtl_flg -- 份额明细标志
    ,redembl_dt -- 可赎回日期
    ,acct_status_cd -- 账户状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160103'||P1.TA_CLIENT||P1.PRD_CODE||TO_CHAR(P1.CFM_DATE)||P1.CFM_NO||TO_CHAR(P1.CFM_DATE) -- 协议编号
    ,'9999' -- 法人编号
    ,P1.TA_CLIENT -- TA账户编号
    ,P1.PRD_CODE -- 产品编号
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,P1.CFM_NO -- 确认流水号
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.REGISTER_DATE)) -- 份额注册日期
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.COMP_DATE)) -- 下发日期
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,P1.TA_CODE -- TA代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.FROZEN_VOL -- 冻结份额
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.PRE_RED_DATE)) -- 上一次可赎回日期
    ,P1.TA_VOL -- TA端总份额
    ,P1.TA_AVAILABLE_VOL -- TA端可用份额
    ,P1.TA_FROZEN_VOL -- TA端冻结份额
    ,NVL(TRIM(P1.DETAIL_FLAG),'-') -- 份额明细标志
    ,${iml_schema}.DATEFORMAT_MAX2(TO_CHAR(P1.ALLOW_RED_DATE)) -- 可赎回日期
    ,NVL(TRIM(P1.ACCOUNT_STATUS),'-') -- 账户状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbsharedtlfund' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbsharedtlfund p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_tm 
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
        into ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ta_acct_id -- TA账户编号
    ,prod_id -- 产品编号
    ,cfm_dt -- 确认日期
    ,cfm_flow_num -- 确认流水号
    ,lot_rgst_dt -- 份额注册日期
    ,forward_dt -- 下发日期
    ,intnal_cust_id -- 内部客户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,froz_lot -- 冻结份额
    ,last_redembl_dt -- 上一次可赎回日期
    ,ta_tot_lot -- TA端总份额
    ,ta_aval_lot -- TA端可用份额
    ,ta_froz_lot -- TA端冻结份额
    ,lot_dtl_flg -- 份额明细标志
    ,redembl_dt -- 可赎回日期
    ,acct_status_cd -- 账户状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ta_acct_id -- TA账户编号
    ,prod_id -- 产品编号
    ,cfm_dt -- 确认日期
    ,cfm_flow_num -- 确认流水号
    ,lot_rgst_dt -- 份额注册日期
    ,forward_dt -- 下发日期
    ,intnal_cust_id -- 内部客户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,froz_lot -- 冻结份额
    ,last_redembl_dt -- 上一次可赎回日期
    ,ta_tot_lot -- TA端总份额
    ,ta_aval_lot -- TA端可用份额
    ,ta_froz_lot -- TA端冻结份额
    ,lot_dtl_flg -- 份额明细标志
    ,redembl_dt -- 可赎回日期
    ,acct_status_cd -- 账户状态代码
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
    ,nvl(n.ta_acct_id, o.ta_acct_id) as ta_acct_id -- TA账户编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.cfm_dt, o.cfm_dt) as cfm_dt -- 确认日期
    ,nvl(n.cfm_flow_num, o.cfm_flow_num) as cfm_flow_num -- 确认流水号
    ,nvl(n.lot_rgst_dt, o.lot_rgst_dt) as lot_rgst_dt -- 份额注册日期
    ,nvl(n.forward_dt, o.forward_dt) as forward_dt -- 下发日期
    ,nvl(n.intnal_cust_id, o.intnal_cust_id) as intnal_cust_id -- 内部客户编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.finc_acct_id, o.finc_acct_id) as finc_acct_id -- 理财账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.froz_lot, o.froz_lot) as froz_lot -- 冻结份额
    ,nvl(n.last_redembl_dt, o.last_redembl_dt) as last_redembl_dt -- 上一次可赎回日期
    ,nvl(n.ta_tot_lot, o.ta_tot_lot) as ta_tot_lot -- TA端总份额
    ,nvl(n.ta_aval_lot, o.ta_aval_lot) as ta_aval_lot -- TA端可用份额
    ,nvl(n.ta_froz_lot, o.ta_froz_lot) as ta_froz_lot -- TA端冻结份额
    ,nvl(n.lot_dtl_flg, o.lot_dtl_flg) as lot_dtl_flg -- 份额明细标志
    ,nvl(n.redembl_dt, o.redembl_dt) as redembl_dt -- 可赎回日期
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
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
from ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_tm n
    full join (select * from ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.ta_acct_id <> n.ta_acct_id
        or o.prod_id <> n.prod_id
        or o.cfm_dt <> n.cfm_dt
        or o.cfm_flow_num <> n.cfm_flow_num
        or o.lot_rgst_dt <> n.lot_rgst_dt
        or o.forward_dt <> n.forward_dt
        or o.intnal_cust_id <> n.intnal_cust_id
        or o.ta_cd <> n.ta_cd
        or o.finc_acct_id <> n.finc_acct_id
        or o.cust_id <> n.cust_id
        or o.bank_acct_id <> n.bank_acct_id
        or o.froz_lot <> n.froz_lot
        or o.last_redembl_dt <> n.last_redembl_dt
        or o.ta_tot_lot <> n.ta_tot_lot
        or o.ta_aval_lot <> n.ta_aval_lot
        or o.ta_froz_lot <> n.ta_froz_lot
        or o.lot_dtl_flg <> n.lot_dtl_flg
        or o.redembl_dt <> n.redembl_dt
        or o.acct_status_cd <> n.acct_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ta_acct_id -- TA账户编号
    ,prod_id -- 产品编号
    ,cfm_dt -- 确认日期
    ,cfm_flow_num -- 确认流水号
    ,lot_rgst_dt -- 份额注册日期
    ,forward_dt -- 下发日期
    ,intnal_cust_id -- 内部客户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,froz_lot -- 冻结份额
    ,last_redembl_dt -- 上一次可赎回日期
    ,ta_tot_lot -- TA端总份额
    ,ta_aval_lot -- TA端可用份额
    ,ta_froz_lot -- TA端冻结份额
    ,lot_dtl_flg -- 份额明细标志
    ,redembl_dt -- 可赎回日期
    ,acct_status_cd -- 账户状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ta_acct_id -- TA账户编号
    ,prod_id -- 产品编号
    ,cfm_dt -- 确认日期
    ,cfm_flow_num -- 确认流水号
    ,lot_rgst_dt -- 份额注册日期
    ,forward_dt -- 下发日期
    ,intnal_cust_id -- 内部客户编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,froz_lot -- 冻结份额
    ,last_redembl_dt -- 上一次可赎回日期
    ,ta_tot_lot -- TA端总份额
    ,ta_aval_lot -- TA端可用份额
    ,ta_froz_lot -- TA端冻结份额
    ,lot_dtl_flg -- 份额明细标志
    ,redembl_dt -- 可赎回日期
    ,acct_status_cd -- 账户状态代码
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
    ,o.ta_acct_id -- TA账户编号
    ,o.prod_id -- 产品编号
    ,o.cfm_dt -- 确认日期
    ,o.cfm_flow_num -- 确认流水号
    ,o.lot_rgst_dt -- 份额注册日期
    ,o.forward_dt -- 下发日期
    ,o.intnal_cust_id -- 内部客户编号
    ,o.ta_cd -- TA代码
    ,o.finc_acct_id -- 理财账户编号
    ,o.cust_id -- 客户编号
    ,o.bank_acct_id -- 银行账户编号
    ,o.froz_lot -- 冻结份额
    ,o.last_redembl_dt -- 上一次可赎回日期
    ,o.ta_tot_lot -- TA端总份额
    ,o.ta_aval_lot -- TA端可用份额
    ,o.ta_froz_lot -- TA端冻结份额
    ,o.lot_dtl_flg -- 份额明细标志
    ,o.redembl_dt -- 可赎回日期
    ,o.acct_status_cd -- 账户状态代码
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
from ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_bk o
    left join ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_cl d
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
--truncate table ${iml_schema}.agt_finc_hold_period_lot_dtl_h;
--alter table ${iml_schema}.agt_finc_hold_period_lot_dtl_h truncate partition for ('ifmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_finc_hold_period_lot_dtl_h') 
               and substr(subpartition_name,1,8)=upper('p_ifmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_finc_hold_period_lot_dtl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_finc_hold_period_lot_dtl_h modify partition p_ifmsf1 
add subpartition p_ifmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_finc_hold_period_lot_dtl_h exchange subpartition p_ifmsf1_${batch_date} with table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_cl;
alter table ${iml_schema}.agt_finc_hold_period_lot_dtl_h exchange subpartition p_ifmsf1_20991231 with table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_finc_hold_period_lot_dtl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_tm purge;
drop table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_op purge;
drop table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_finc_hold_period_lot_dtl_h_ifmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_finc_hold_period_lot_dtl_h', partname => 'p_ifmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
