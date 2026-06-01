/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_family_trust_prod_order_h_irvsf1
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
alter table ${iml_schema}.evt_family_trust_prod_order_h add partition p_irvsf1 values ('irvsf1')(
        subpartition p_irvsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_irvsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_family_trust_prod_order_h partition for ('irvsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_tm purge;
drop table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_op purge;
drop table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,prod_id -- 产品编号
    ,party_id -- 当事人编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_acct_num -- 交易账号
    ,tran_tm -- 交易时间
    ,cntpty_name -- 托管行名称
    ,cntpty_acct_id -- 托管账户编号
    ,cntpty_ibank_no -- 托管行联行号
    ,cust_mgr_id -- 客户经理编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_family_trust_prod_order_h partition for ('irvsf1')
where 0=1
;

create table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_family_trust_prod_order_h partition for ('irvsf1') where 0=1;

create table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_family_trust_prod_order_h partition for ('irvsf1') where 0=1;

-- 3.1 get new data into table
-- irvs_ft_orderform-
insert into ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,prod_id -- 产品编号
    ,party_id -- 当事人编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_acct_num -- 交易账号
    ,tran_tm -- 交易时间
    ,cntpty_name -- 托管行名称
    ,cntpty_acct_id -- 托管账户编号
    ,cntpty_ibank_no -- 托管行联行号
    ,cust_mgr_id -- 客户经理编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.order_no -- 事件编号
    ,'9999' -- 法人编号
    ,P1.order_no -- 订单流水号
    ,p2.product_code -- 产品编号
    ,P1.ecif_no -- 当事人编号
    ,'CNY' -- 币种代码
    ,P1.pay_amount -- 交易金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PAY_STATUS END -- 交易状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CHANNEL END -- 交易渠道代码
    ,P1.pay_accno -- 交易账号
    ,to_timestamp(trim(P1.pay_time),'yyyymmddhh24missff6') -- 交易时间
    ,P1.custodian_bank_name -- 托管行名称
    ,P1.custodian_bank_accno -- 托管账户编号
    ,P1.bank_ext_num -- 托管行联行号
    ,P1.customer_manager_no -- 客户经理编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'irvs_ft_orderform' -- 源表名称
    ,'irvsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.irvs_ft_orderform p1
    left join ${iol_schema}.irvs_ft_product p2 on P1.product_id=P2.product_id
        AND P2.START_DT<=to_date('${batch_date}','YYYYMMDD')
        AND P2.END_DT > to_date('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PAY_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IRVS'
        AND R1.SRC_TAB_EN_NAME= 'IRVS_FT_ORDERFORM'
        AND R1.SRC_FIELD_EN_NAME= 'PAY_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_FAMILY_TRUST_PROD_ORDER_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CHANNEL = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IRVS'
        AND R2.SRC_TAB_EN_NAME= 'IRVS_FT_ORDERFORM'
        AND R2.SRC_FIELD_EN_NAME= 'CHANNEL'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_FAMILY_TRUST_PROD_ORDER_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_tm 
  	                                group by 
  	                                        evt_id
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
        into ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,prod_id -- 产品编号
    ,party_id -- 当事人编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_acct_num -- 交易账号
    ,tran_tm -- 交易时间
    ,cntpty_name -- 托管行名称
    ,cntpty_acct_id -- 托管账户编号
    ,cntpty_ibank_no -- 托管行联行号
    ,cust_mgr_id -- 客户经理编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,prod_id -- 产品编号
    ,party_id -- 当事人编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_acct_num -- 交易账号
    ,tran_tm -- 交易时间
    ,cntpty_name -- 托管行名称
    ,cntpty_acct_id -- 托管账户编号
    ,cntpty_ibank_no -- 托管行联行号
    ,cust_mgr_id -- 客户经理编号
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
    ,nvl(n.indent_flow_num, o.indent_flow_num) as indent_flow_num -- 订单流水号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_chn_cd, o.tran_chn_cd) as tran_chn_cd -- 交易渠道代码
    ,nvl(n.tran_acct_num, o.tran_acct_num) as tran_acct_num -- 交易账号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 托管行名称
    ,nvl(n.cntpty_acct_id, o.cntpty_acct_id) as cntpty_acct_id -- 托管账户编号
    ,nvl(n.cntpty_ibank_no, o.cntpty_ibank_no) as cntpty_ibank_no -- 托管行联行号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_tm n
    full join (select * from ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.indent_flow_num <> n.indent_flow_num
        or o.prod_id <> n.prod_id
        or o.party_id <> n.party_id
        or o.curr_cd <> n.curr_cd
        or o.tran_amt <> n.tran_amt
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_chn_cd <> n.tran_chn_cd
        or o.tran_acct_num <> n.tran_acct_num
        or o.tran_tm <> n.tran_tm
        or o.cntpty_name <> n.cntpty_name
        or o.cntpty_acct_id <> n.cntpty_acct_id
        or o.cntpty_ibank_no <> n.cntpty_ibank_no
        or o.cust_mgr_id <> n.cust_mgr_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,prod_id -- 产品编号
    ,party_id -- 当事人编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_acct_num -- 交易账号
    ,tran_tm -- 交易时间
    ,cntpty_name -- 托管行名称
    ,cntpty_acct_id -- 托管账户编号
    ,cntpty_ibank_no -- 托管行联行号
    ,cust_mgr_id -- 客户经理编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,prod_id -- 产品编号
    ,party_id -- 当事人编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_acct_num -- 交易账号
    ,tran_tm -- 交易时间
    ,cntpty_name -- 托管行名称
    ,cntpty_acct_id -- 托管账户编号
    ,cntpty_ibank_no -- 托管行联行号
    ,cust_mgr_id -- 客户经理编号
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
    ,o.indent_flow_num -- 订单流水号
    ,o.prod_id -- 产品编号
    ,o.party_id -- 当事人编号
    ,o.curr_cd -- 币种代码
    ,o.tran_amt -- 交易金额
    ,o.tran_status_cd -- 交易状态代码
    ,o.tran_chn_cd -- 交易渠道代码
    ,o.tran_acct_num -- 交易账号
    ,o.tran_tm -- 交易时间
    ,o.cntpty_name -- 托管行名称
    ,o.cntpty_acct_id -- 托管账户编号
    ,o.cntpty_ibank_no -- 托管行联行号
    ,o.cust_mgr_id -- 客户经理编号
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
from ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_bk o
    left join ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_family_trust_prod_order_h;
--alter table ${iml_schema}.evt_family_trust_prod_order_h truncate partition for ('irvsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_family_trust_prod_order_h') 
               and substr(subpartition_name,1,8)=upper('p_irvsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_family_trust_prod_order_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_family_trust_prod_order_h modify partition p_irvsf1 
add subpartition p_irvsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_family_trust_prod_order_h exchange subpartition p_irvsf1_${batch_date} with table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_cl;
alter table ${iml_schema}.evt_family_trust_prod_order_h exchange subpartition p_irvsf1_20991231 with table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_family_trust_prod_order_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_tm purge;
drop table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_op purge;
drop table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_family_trust_prod_order_h_irvsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_family_trust_prod_order_h', partname => 'p_irvsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
