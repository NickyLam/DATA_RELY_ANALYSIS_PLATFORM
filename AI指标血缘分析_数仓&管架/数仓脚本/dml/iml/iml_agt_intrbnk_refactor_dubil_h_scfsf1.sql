/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_intrbnk_refactor_dubil_h_scfsf1
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
alter table ${iml_schema}.agt_intrbnk_refactor_dubil_h add partition p_scfsf1 values ('scfsf1')(
        subpartition p_scfsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_scfsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intrbnk_refactor_dubil_h partition for ('scfsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_tm purge;
drop table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_op purge;
drop table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,fin_appl_id -- 融资申请编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,fin_amt -- 融资金额
    ,fin_start_dt -- 融资开始日期
    ,fin_exp_dt -- 融资到期日期
    ,effect_flg -- 生效标志
    ,tran_net_price -- 转让净价
    ,sell_int -- 卖出利息
    ,sell_comm_fee -- 卖出手续费
    ,tran_cosdetn -- 转让对价
    ,tran_org_id -- 转让机构编号
    ,cont_exp_dt -- 合同到期日期
    ,sys_del_flg -- 系统内删除标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intrbnk_refactor_dubil_h partition for ('scfsf1')
where 0=1
;

create table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intrbnk_refactor_dubil_h partition for ('scfsf1') where 0=1;

create table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intrbnk_refactor_dubil_h partition for ('scfsf1') where 0=1;

-- 3.1 get new data into table
-- scfs_biz_inter_bank_fact_iou-1
insert into ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,fin_appl_id -- 融资申请编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,fin_amt -- 融资金额
    ,fin_start_dt -- 融资开始日期
    ,fin_exp_dt -- 融资到期日期
    ,effect_flg -- 生效标志
    ,tran_net_price -- 转让净价
    ,sell_int -- 卖出利息
    ,sell_comm_fee -- 卖出手续费
    ,tran_cosdetn -- 转让对价
    ,tran_org_id -- 转让机构编号
    ,cont_exp_dt -- 合同到期日期
    ,sys_del_flg -- 系统内删除标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300046'||to_char(P1.ID)||P1.VERSION -- 协议编号
    ,'9999' -- 法人编号
    ,to_char(P1.ID) -- ID
    ,P1.BANK_FACT_ID -- 跨行再保理编号
    ,P1.FNC_JRNL_ID -- 融资申请编号
    ,P1.IOU_ID -- 借据编号
    ,P1.PD_ID -- 产品编号
    ,P1.PD_NM -- 产品名称
    ,P1.THS_FNC_AMT -- 融资金额
    ,P1.FNC_BG_DT -- 融资开始日期
    ,P1.FNC_EX_DT -- 融资到期日期
    ,nvl(trim(P1.ST_CD),'-') -- 生效标志
    ,P1.IOU_BAY_OUT_NET_AMT -- 转让净价
    ,P1.IOU_SELL_INTEREST -- 卖出利息
    ,P1.IOU_FEE_AMT -- 卖出手续费
    ,P1.IOU_EXCHANGE_AMT -- 转让对价
    ,P1.IOU_SELL_ORG -- 转让机构编号
    ,P1.MATURITY -- 合同到期日期
    ,nvl(trim(P1.DEL_IND),'-') -- 系统内删除标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'scfs_biz_inter_bank_fact_iou' -- 源表名称
    ,'scfsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.scfs_biz_inter_bank_fact_iou p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_tm 
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
        into ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,fin_appl_id -- 融资申请编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,fin_amt -- 融资金额
    ,fin_start_dt -- 融资开始日期
    ,fin_exp_dt -- 融资到期日期
    ,effect_flg -- 生效标志
    ,tran_net_price -- 转让净价
    ,sell_int -- 卖出利息
    ,sell_comm_fee -- 卖出手续费
    ,tran_cosdetn -- 转让对价
    ,tran_org_id -- 转让机构编号
    ,cont_exp_dt -- 合同到期日期
    ,sys_del_flg -- 系统内删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,fin_appl_id -- 融资申请编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,fin_amt -- 融资金额
    ,fin_start_dt -- 融资开始日期
    ,fin_exp_dt -- 融资到期日期
    ,effect_flg -- 生效标志
    ,tran_net_price -- 转让净价
    ,sell_int -- 卖出利息
    ,sell_comm_fee -- 卖出手续费
    ,tran_cosdetn -- 转让对价
    ,tran_org_id -- 转让机构编号
    ,cont_exp_dt -- 合同到期日期
    ,sys_del_flg -- 系统内删除标志
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
    ,nvl(n.id, o.id) as id -- ID
    ,nvl(n.intrbnk_refactor_id, o.intrbnk_refactor_id) as intrbnk_refactor_id -- 跨行再保理编号
    ,nvl(n.fin_appl_id, o.fin_appl_id) as fin_appl_id -- 融资申请编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.fin_amt, o.fin_amt) as fin_amt -- 融资金额
    ,nvl(n.fin_start_dt, o.fin_start_dt) as fin_start_dt -- 融资开始日期
    ,nvl(n.fin_exp_dt, o.fin_exp_dt) as fin_exp_dt -- 融资到期日期
    ,nvl(n.effect_flg, o.effect_flg) as effect_flg -- 生效标志
    ,nvl(n.tran_net_price, o.tran_net_price) as tran_net_price -- 转让净价
    ,nvl(n.sell_int, o.sell_int) as sell_int -- 卖出利息
    ,nvl(n.sell_comm_fee, o.sell_comm_fee) as sell_comm_fee -- 卖出手续费
    ,nvl(n.tran_cosdetn, o.tran_cosdetn) as tran_cosdetn -- 转让对价
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 转让机构编号
    ,nvl(n.cont_exp_dt, o.cont_exp_dt) as cont_exp_dt -- 合同到期日期
    ,nvl(n.sys_del_flg, o.sys_del_flg) as sys_del_flg -- 系统内删除标志
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
from ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_tm n
    full join (select * from ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.id <> n.id
        or o.intrbnk_refactor_id <> n.intrbnk_refactor_id
        or o.fin_appl_id <> n.fin_appl_id
        or o.dubil_id <> n.dubil_id
        or o.prod_id <> n.prod_id
        or o.prod_name <> n.prod_name
        or o.fin_amt <> n.fin_amt
        or o.fin_start_dt <> n.fin_start_dt
        or o.fin_exp_dt <> n.fin_exp_dt
        or o.effect_flg <> n.effect_flg
        or o.tran_net_price <> n.tran_net_price
        or o.sell_int <> n.sell_int
        or o.sell_comm_fee <> n.sell_comm_fee
        or o.tran_cosdetn <> n.tran_cosdetn
        or o.tran_org_id <> n.tran_org_id
        or o.cont_exp_dt <> n.cont_exp_dt
        or o.sys_del_flg <> n.sys_del_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,fin_appl_id -- 融资申请编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,fin_amt -- 融资金额
    ,fin_start_dt -- 融资开始日期
    ,fin_exp_dt -- 融资到期日期
    ,effect_flg -- 生效标志
    ,tran_net_price -- 转让净价
    ,sell_int -- 卖出利息
    ,sell_comm_fee -- 卖出手续费
    ,tran_cosdetn -- 转让对价
    ,tran_org_id -- 转让机构编号
    ,cont_exp_dt -- 合同到期日期
    ,sys_del_flg -- 系统内删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,fin_appl_id -- 融资申请编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,fin_amt -- 融资金额
    ,fin_start_dt -- 融资开始日期
    ,fin_exp_dt -- 融资到期日期
    ,effect_flg -- 生效标志
    ,tran_net_price -- 转让净价
    ,sell_int -- 卖出利息
    ,sell_comm_fee -- 卖出手续费
    ,tran_cosdetn -- 转让对价
    ,tran_org_id -- 转让机构编号
    ,cont_exp_dt -- 合同到期日期
    ,sys_del_flg -- 系统内删除标志
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
    ,o.id -- ID
    ,o.intrbnk_refactor_id -- 跨行再保理编号
    ,o.fin_appl_id -- 融资申请编号
    ,o.dubil_id -- 借据编号
    ,o.prod_id -- 产品编号
    ,o.prod_name -- 产品名称
    ,o.fin_amt -- 融资金额
    ,o.fin_start_dt -- 融资开始日期
    ,o.fin_exp_dt -- 融资到期日期
    ,o.effect_flg -- 生效标志
    ,o.tran_net_price -- 转让净价
    ,o.sell_int -- 卖出利息
    ,o.sell_comm_fee -- 卖出手续费
    ,o.tran_cosdetn -- 转让对价
    ,o.tran_org_id -- 转让机构编号
    ,o.cont_exp_dt -- 合同到期日期
    ,o.sys_del_flg -- 系统内删除标志
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
from ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_bk o
    left join ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_cl d
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
--truncate table ${iml_schema}.agt_intrbnk_refactor_dubil_h;
--alter table ${iml_schema}.agt_intrbnk_refactor_dubil_h truncate partition for ('scfsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_intrbnk_refactor_dubil_h') 
               and substr(subpartition_name,1,8)=upper('p_scfsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_intrbnk_refactor_dubil_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_intrbnk_refactor_dubil_h modify partition p_scfsf1 
add subpartition p_scfsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_intrbnk_refactor_dubil_h exchange subpartition p_scfsf1_${batch_date} with table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_cl;
alter table ${iml_schema}.agt_intrbnk_refactor_dubil_h exchange subpartition p_scfsf1_20991231 with table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_intrbnk_refactor_dubil_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_tm purge;
drop table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_op purge;
drop table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_intrbnk_refactor_dubil_h_scfsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_intrbnk_refactor_dubil_h', partname => 'p_scfsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
