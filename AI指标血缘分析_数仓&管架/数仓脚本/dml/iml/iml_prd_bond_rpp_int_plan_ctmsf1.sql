/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_bond_rpp_int_plan_ctmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_bond_rpp_int_plan add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_bond_rpp_int_plan modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_rpp_int_plan partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_tm
compress ${option_switch} for query high
as
select
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,pay_dt -- 支付日期
    ,issuer_redem_dt -- 发行人赎回日期
    ,invtor_put_dt -- 投资人回售日期
    ,int_amt -- 利息金额
    ,pric_amt -- 本金金额
    ,surp_pric_amt -- 剩余本金金额
    ,issuer_redem_price -- 发行人赎回价格
    ,invtor_put_price -- 投资人回售价格
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_rpp_int_plan
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_bond_rpp_int_plan partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_v_security_pymn_schd-
insert into ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_tm(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,pay_dt -- 支付日期
    ,issuer_redem_dt -- 发行人赎回日期
    ,invtor_put_dt -- 投资人回售日期
    ,int_amt -- 利息金额
    ,pric_amt -- 本金金额
    ,surp_pric_amt -- 剩余本金金额
    ,issuer_redem_price -- 发行人赎回价格
    ,invtor_put_price -- 投资人回售价格
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SECURITY_CODE -- 债券编号
    ,'9999' -- 法人编号
    ,P1.SEQ -- 序号
    ,${iml_schema}.DATEFORMAT_MAX(P1.PAYMENT_DATE) -- 支付日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.CALL_DATE) -- 发行人赎回日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.PUT_DATE) -- 投资人回售日期
    ,P1.COUPON_AMT -- 利息金额
    ,P1.BACK_AMT -- 本金金额
    ,P1.LAST_AMT -- 剩余本金金额
    ,P1.CALL_PRICE -- 发行人赎回价格
    ,P1.PUT_PRICE -- 投资人回售价格
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_security_pymn_schd' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_security_pymn_schd p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_tm 
  	                                group by 
  	                                        bond_id
  	                                        ,lp_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_ex(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,pay_dt -- 支付日期
    ,issuer_redem_dt -- 发行人赎回日期
    ,invtor_put_dt -- 投资人回售日期
    ,int_amt -- 利息金额
    ,pric_amt -- 本金金额
    ,surp_pric_amt -- 剩余本金金额
    ,issuer_redem_price -- 发行人赎回价格
    ,invtor_put_price -- 投资人回售价格
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.pay_dt, o.pay_dt) as pay_dt -- 支付日期
    ,nvl(n.issuer_redem_dt, o.issuer_redem_dt) as issuer_redem_dt -- 发行人赎回日期
    ,nvl(n.invtor_put_dt, o.invtor_put_dt) as invtor_put_dt -- 投资人回售日期
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.pric_amt, o.pric_amt) as pric_amt -- 本金金额
    ,nvl(n.surp_pric_amt, o.surp_pric_amt) as surp_pric_amt -- 剩余本金金额
    ,nvl(n.issuer_redem_price, o.issuer_redem_price) as issuer_redem_price -- 发行人赎回价格
    ,nvl(n.invtor_put_price, o.invtor_put_price) as invtor_put_price -- 投资人回售价格
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.bond_id is null
                and o.lp_id is null
                and o.seq_num is null
            ) or (
                o.pay_dt <> n.pay_dt
                or o.issuer_redem_dt <> n.issuer_redem_dt
                or o.invtor_put_dt <> n.invtor_put_dt
                or o.int_amt <> n.int_amt
                or o.pric_amt <> n.pric_amt
                or o.surp_pric_amt <> n.surp_pric_amt
                or o.issuer_redem_price <> n.issuer_redem_price
                or o.invtor_put_price <> n.invtor_put_price
            ) or (
                 case when (
                           n.bond_id is null
                           and n.lp_id is null
                           and n.seq_num is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.bond_id is null
                and n.lp_id is null
                and n.seq_num is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_tm n
    full join ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_bk o
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_bond_rpp_int_plan truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_bond_rpp_int_plan exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_bond_rpp_int_plan drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_bond_rpp_int_plan to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_ex purge;
drop table ${iml_schema}.prd_bond_rpp_int_plan_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_bond_rpp_int_plan', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);