/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_point_mall_pay_mec_info_amssf1
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
alter table ${iml_schema}.evt_point_mall_pay_mec_info add partition p_amssf1 values ('amssf1')(
        subpartition p_amssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_amssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_point_mall_pay_mec_info partition for ('amssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_tm purge;
drop table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_op purge;
drop table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,merchd_sub_indent_flow_num -- 商品子订单流水号
    ,indent_flow_num -- 订单流水号
    ,mode_pay_cd -- 支付方式代码
    ,provi_name -- 供应商名称
    ,merchd_id -- 商品编号
    ,merchd_name -- 商品名称
    ,merchd_tot_qtty -- 商品总数量
    ,merchd_descb -- 商品描述
    ,single_merchd_comm_fee -- 单个商品手续费
    ,valid_flg -- 有效标志
    ,final_update_dt -- 最后更新日期
    ,create_teller_id -- 创建柜员编号
    ,update_teller_id -- 更新柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_point_mall_pay_mec_info partition for ('amssf1')
where 0=1
;

create table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_point_mall_pay_mec_info partition for ('amssf1') where 0=1;

create table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_point_mall_pay_mec_info partition for ('amssf1') where 0=1;

-- 3.1 get new data into table
-- amss_points_mall_order_mrchd-1
insert into ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,merchd_sub_indent_flow_num -- 商品子订单流水号
    ,indent_flow_num -- 订单流水号
    ,mode_pay_cd -- 支付方式代码
    ,provi_name -- 供应商名称
    ,merchd_id -- 商品编号
    ,merchd_name -- 商品名称
    ,merchd_tot_qtty -- 商品总数量
    ,merchd_descb -- 商品描述
    ,single_merchd_comm_fee -- 单个商品手续费
    ,valid_flg -- 有效标志
    ,final_update_dt -- 最后更新日期
    ,create_teller_id -- 创建柜员编号
    ,update_teller_id -- 更新柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401057'||P1.SERIAL_NUM -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 商品子订单流水号
    ,P1.SERIAL_NUM -- 订单流水号
    ,nvl(trim(P1.CNSM_TYPE),'-') -- 支付方式代码
    ,P1.PROVT_NAME -- 供应商名称
    ,P1.MRCHD_ENCD -- 商品编号
    ,P1.MRCHD_NAME -- 商品名称
    ,P1.MRCHD_QTTY -- 商品总数量
    ,P1.MRCHD_DESC -- 商品描述
    ,P1.FORM_MECHD_FEE -- 单个商品手续费
    ,case when P1.PHYSICS_FLAG = 1 then '1' else '0' end -- 有效标志
    ,P1.UPDATE_TIME -- 最后更新日期
    ,P1.CREATE_EMP -- 创建柜员编号
    ,P1.UPDATE_EMP -- 更新柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'amss_points_mall_order_mrchd' -- 源表名称
    ,'amssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amss_points_mall_order_mrchd p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                                        ,merchd_sub_indent_flow_num
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
        into ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,merchd_sub_indent_flow_num -- 商品子订单流水号
    ,indent_flow_num -- 订单流水号
    ,mode_pay_cd -- 支付方式代码
    ,provi_name -- 供应商名称
    ,merchd_id -- 商品编号
    ,merchd_name -- 商品名称
    ,merchd_tot_qtty -- 商品总数量
    ,merchd_descb -- 商品描述
    ,single_merchd_comm_fee -- 单个商品手续费
    ,valid_flg -- 有效标志
    ,final_update_dt -- 最后更新日期
    ,create_teller_id -- 创建柜员编号
    ,update_teller_id -- 更新柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,merchd_sub_indent_flow_num -- 商品子订单流水号
    ,indent_flow_num -- 订单流水号
    ,mode_pay_cd -- 支付方式代码
    ,provi_name -- 供应商名称
    ,merchd_id -- 商品编号
    ,merchd_name -- 商品名称
    ,merchd_tot_qtty -- 商品总数量
    ,merchd_descb -- 商品描述
    ,single_merchd_comm_fee -- 单个商品手续费
    ,valid_flg -- 有效标志
    ,final_update_dt -- 最后更新日期
    ,create_teller_id -- 创建柜员编号
    ,update_teller_id -- 更新柜员编号
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
    ,nvl(n.merchd_sub_indent_flow_num, o.merchd_sub_indent_flow_num) as merchd_sub_indent_flow_num -- 商品子订单流水号
    ,nvl(n.indent_flow_num, o.indent_flow_num) as indent_flow_num -- 订单流水号
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 支付方式代码
    ,nvl(n.provi_name, o.provi_name) as provi_name -- 供应商名称
    ,nvl(n.merchd_id, o.merchd_id) as merchd_id -- 商品编号
    ,nvl(n.merchd_name, o.merchd_name) as merchd_name -- 商品名称
    ,nvl(n.merchd_tot_qtty, o.merchd_tot_qtty) as merchd_tot_qtty -- 商品总数量
    ,nvl(n.merchd_descb, o.merchd_descb) as merchd_descb -- 商品描述
    ,nvl(n.single_merchd_comm_fee, o.single_merchd_comm_fee) as single_merchd_comm_fee -- 单个商品手续费
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,nvl(n.create_teller_id, o.create_teller_id) as create_teller_id -- 创建柜员编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.merchd_sub_indent_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.merchd_sub_indent_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.merchd_sub_indent_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_tm n
    full join (select * from ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.merchd_sub_indent_flow_num = n.merchd_sub_indent_flow_num
where (
        o.evt_id is null
        and o.lp_id is null
        and o.merchd_sub_indent_flow_num is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.merchd_sub_indent_flow_num is null
    )
    or (
        o.indent_flow_num <> n.indent_flow_num
        or o.mode_pay_cd <> n.mode_pay_cd
        or o.provi_name <> n.provi_name
        or o.merchd_id <> n.merchd_id
        or o.merchd_name <> n.merchd_name
        or o.merchd_tot_qtty <> n.merchd_tot_qtty
        or o.merchd_descb <> n.merchd_descb
        or o.single_merchd_comm_fee <> n.single_merchd_comm_fee
        or o.valid_flg <> n.valid_flg
        or o.final_update_dt <> n.final_update_dt
        or o.create_teller_id <> n.create_teller_id
        or o.update_teller_id <> n.update_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,merchd_sub_indent_flow_num -- 商品子订单流水号
    ,indent_flow_num -- 订单流水号
    ,mode_pay_cd -- 支付方式代码
    ,provi_name -- 供应商名称
    ,merchd_id -- 商品编号
    ,merchd_name -- 商品名称
    ,merchd_tot_qtty -- 商品总数量
    ,merchd_descb -- 商品描述
    ,single_merchd_comm_fee -- 单个商品手续费
    ,valid_flg -- 有效标志
    ,final_update_dt -- 最后更新日期
    ,create_teller_id -- 创建柜员编号
    ,update_teller_id -- 更新柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,merchd_sub_indent_flow_num -- 商品子订单流水号
    ,indent_flow_num -- 订单流水号
    ,mode_pay_cd -- 支付方式代码
    ,provi_name -- 供应商名称
    ,merchd_id -- 商品编号
    ,merchd_name -- 商品名称
    ,merchd_tot_qtty -- 商品总数量
    ,merchd_descb -- 商品描述
    ,single_merchd_comm_fee -- 单个商品手续费
    ,valid_flg -- 有效标志
    ,final_update_dt -- 最后更新日期
    ,create_teller_id -- 创建柜员编号
    ,update_teller_id -- 更新柜员编号
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
    ,o.merchd_sub_indent_flow_num -- 商品子订单流水号
    ,o.indent_flow_num -- 订单流水号
    ,o.mode_pay_cd -- 支付方式代码
    ,o.provi_name -- 供应商名称
    ,o.merchd_id -- 商品编号
    ,o.merchd_name -- 商品名称
    ,o.merchd_tot_qtty -- 商品总数量
    ,o.merchd_descb -- 商品描述
    ,o.single_merchd_comm_fee -- 单个商品手续费
    ,o.valid_flg -- 有效标志
    ,o.final_update_dt -- 最后更新日期
    ,o.create_teller_id -- 创建柜员编号
    ,o.update_teller_id -- 更新柜员编号
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
from ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_bk o
    left join ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.merchd_sub_indent_flow_num = n.merchd_sub_indent_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.merchd_sub_indent_flow_num = d.merchd_sub_indent_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_point_mall_pay_mec_info;
--alter table ${iml_schema}.evt_point_mall_pay_mec_info truncate partition for ('amssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_point_mall_pay_mec_info') 
               and substr(subpartition_name,1,8)=upper('p_amssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_point_mall_pay_mec_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_point_mall_pay_mec_info modify partition p_amssf1 
add subpartition p_amssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_point_mall_pay_mec_info exchange subpartition p_amssf1_${batch_date} with table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_cl;
alter table ${iml_schema}.evt_point_mall_pay_mec_info exchange subpartition p_amssf1_20991231 with table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_point_mall_pay_mec_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_tm purge;
drop table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_op purge;
drop table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_point_mall_pay_mec_info_amssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_point_mall_pay_mec_info', partname => 'p_amssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
