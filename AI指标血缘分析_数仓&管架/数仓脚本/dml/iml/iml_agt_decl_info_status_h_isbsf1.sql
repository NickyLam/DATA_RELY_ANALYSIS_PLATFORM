/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_decl_info_status_h_isbsf1
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
alter table ${iml_schema}.agt_decl_info_status_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_decl_info_status_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_decl_info_status_h partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_decl_info_status_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_decl_info_status_h_isbsf1_op purge;
drop table ${iml_schema}.agt_decl_info_status_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_decl_info_status_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,status_id -- 状态编号
    ,edit_id -- 版本编号
    ,temp_decl_flow_num -- 临时申报流水号
    ,init_enty_id -- 原始实体编号
    ,tran_flow_num -- 交易流水号
    ,rela_table_name -- 关联表名称
    ,rela_decl_id -- 关联申报编号
    ,decl_num -- 申报号码
    ,trade_gen_cd -- 贸易大类代码
    ,money_idf_cd -- 款项标识代码
    ,base_info_status_cd -- 基础信息状态代码
    ,decl_info_status_cd -- 申报信息状态代码
    ,wrt_off_info_status_cd -- 核销信息状态代码
    ,yga_e_acct_info_status_cd -- 粤港电子账户信息状态代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,auth_dt -- 授权日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_decl_info_status_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_decl_info_status_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_decl_info_status_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_decl_info_status_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_decl_info_status_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_dbl-1
insert into ${iml_schema}.agt_decl_info_status_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,status_id -- 状态编号
    ,edit_id -- 版本编号
    ,temp_decl_flow_num -- 临时申报流水号
    ,init_enty_id -- 原始实体编号
    ,tran_flow_num -- 交易流水号
    ,rela_table_name -- 关联表名称
    ,rela_decl_id -- 关联申报编号
    ,decl_num -- 申报号码
    ,trade_gen_cd -- 贸易大类代码
    ,money_idf_cd -- 款项标识代码
    ,base_info_status_cd -- 基础信息状态代码
    ,decl_info_status_cd -- 申报信息状态代码
    ,wrt_off_info_status_cd -- 核销信息状态代码
    ,yga_e_acct_info_status_cd -- 粤港电子账户信息状态代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,auth_dt -- 授权日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300016'||P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 状态编号
    ,P1.VER -- 版本编号
    ,P1.TMPREF -- 临时申报流水号
    ,P1.OWNEXTKEY -- 原始实体编号
    ,P1.TRNINR -- 交易流水号
    ,P1.OBJTYP -- 关联表名称
    ,P1.OBJINR -- 关联申报编号
    ,P1.RPTNO -- 申报号码
    ,case when R1.TARGET_CD_VAL is not null then R1.TARGET_CD_VAL else '@'||P1.TRDTYP end -- 贸易大类代码
    ,nvl(trim(P1.ACTTYP),'-') -- 款项标识代码
    ,nvl(trim(P1.BASSTA),'-') -- 基础信息状态代码
    ,nvl(trim(P1.DCLSTA),'-') -- 申报信息状态代码
    ,nvl(trim(P1.VRFSTA),'-') -- 核销信息状态代码
    ,nvl(trim(P1.YGASTA),'-') -- 粤港电子账户信息状态代码
    ,P1.OWNUSR -- 业务经办柜员编号
    ,P1.RELDAT -- 授权日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_dbl' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_dbl p1
  LEFT JOIN ${iml_schema}.ref_pub_cd_map r1 on P1.TRDTYP= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ISBS'
        AND R1.SRC_TAB_EN_NAME= 'ISBS_DBL'
        AND R1.SRC_FIELD_EN_NAME= 'TRDTYP'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_DECL_INFO_STATUS_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRADE_GEN_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_decl_info_status_h_isbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,status_id
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
        into ${iml_schema}.agt_decl_info_status_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,status_id -- 状态编号
    ,edit_id -- 版本编号
    ,temp_decl_flow_num -- 临时申报流水号
    ,init_enty_id -- 原始实体编号
    ,tran_flow_num -- 交易流水号
    ,rela_table_name -- 关联表名称
    ,rela_decl_id -- 关联申报编号
    ,decl_num -- 申报号码
    ,trade_gen_cd -- 贸易大类代码
    ,money_idf_cd -- 款项标识代码
    ,base_info_status_cd -- 基础信息状态代码
    ,decl_info_status_cd -- 申报信息状态代码
    ,wrt_off_info_status_cd -- 核销信息状态代码
    ,yga_e_acct_info_status_cd -- 粤港电子账户信息状态代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,auth_dt -- 授权日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_decl_info_status_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,status_id -- 状态编号
    ,edit_id -- 版本编号
    ,temp_decl_flow_num -- 临时申报流水号
    ,init_enty_id -- 原始实体编号
    ,tran_flow_num -- 交易流水号
    ,rela_table_name -- 关联表名称
    ,rela_decl_id -- 关联申报编号
    ,decl_num -- 申报号码
    ,trade_gen_cd -- 贸易大类代码
    ,money_idf_cd -- 款项标识代码
    ,base_info_status_cd -- 基础信息状态代码
    ,decl_info_status_cd -- 申报信息状态代码
    ,wrt_off_info_status_cd -- 核销信息状态代码
    ,yga_e_acct_info_status_cd -- 粤港电子账户信息状态代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,auth_dt -- 授权日期
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
    ,nvl(n.status_id, o.status_id) as status_id -- 状态编号
    ,nvl(n.edit_id, o.edit_id) as edit_id -- 版本编号
    ,nvl(n.temp_decl_flow_num, o.temp_decl_flow_num) as temp_decl_flow_num -- 临时申报流水号
    ,nvl(n.init_enty_id, o.init_enty_id) as init_enty_id -- 原始实体编号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.rela_table_name, o.rela_table_name) as rela_table_name -- 关联表名称
    ,nvl(n.rela_decl_id, o.rela_decl_id) as rela_decl_id -- 关联申报编号
    ,nvl(n.decl_num, o.decl_num) as decl_num -- 申报号码
    ,nvl(n.trade_gen_cd, o.trade_gen_cd) as trade_gen_cd -- 贸易大类代码
    ,nvl(n.money_idf_cd, o.money_idf_cd) as money_idf_cd -- 款项标识代码
    ,nvl(n.base_info_status_cd, o.base_info_status_cd) as base_info_status_cd -- 基础信息状态代码
    ,nvl(n.decl_info_status_cd, o.decl_info_status_cd) as decl_info_status_cd -- 申报信息状态代码
    ,nvl(n.wrt_off_info_status_cd, o.wrt_off_info_status_cd) as wrt_off_info_status_cd -- 核销信息状态代码
    ,nvl(n.yga_e_acct_info_status_cd, o.yga_e_acct_info_status_cd) as yga_e_acct_info_status_cd -- 粤港电子账户信息状态代码
    ,nvl(n.bus_oper_teller_id, o.bus_oper_teller_id) as bus_oper_teller_id -- 业务经办柜员编号
    ,nvl(n.auth_dt, o.auth_dt) as auth_dt -- 授权日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.status_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.status_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.status_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_decl_info_status_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_decl_info_status_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.status_id = n.status_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.status_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.status_id is null
    )
    or (
        o.edit_id <> n.edit_id
        or o.temp_decl_flow_num <> n.temp_decl_flow_num
        or o.init_enty_id <> n.init_enty_id
        or o.tran_flow_num <> n.tran_flow_num
        or o.rela_table_name <> n.rela_table_name
        or o.rela_decl_id <> n.rela_decl_id
        or o.decl_num <> n.decl_num
        or o.trade_gen_cd <> n.trade_gen_cd
        or o.money_idf_cd <> n.money_idf_cd
        or o.base_info_status_cd <> n.base_info_status_cd
        or o.decl_info_status_cd <> n.decl_info_status_cd
        or o.wrt_off_info_status_cd <> n.wrt_off_info_status_cd
        or o.yga_e_acct_info_status_cd <> n.yga_e_acct_info_status_cd
        or o.bus_oper_teller_id <> n.bus_oper_teller_id
        or o.auth_dt <> n.auth_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_decl_info_status_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,status_id -- 状态编号
    ,edit_id -- 版本编号
    ,temp_decl_flow_num -- 临时申报流水号
    ,init_enty_id -- 原始实体编号
    ,tran_flow_num -- 交易流水号
    ,rela_table_name -- 关联表名称
    ,rela_decl_id -- 关联申报编号
    ,decl_num -- 申报号码
    ,trade_gen_cd -- 贸易大类代码
    ,money_idf_cd -- 款项标识代码
    ,base_info_status_cd -- 基础信息状态代码
    ,decl_info_status_cd -- 申报信息状态代码
    ,wrt_off_info_status_cd -- 核销信息状态代码
    ,yga_e_acct_info_status_cd -- 粤港电子账户信息状态代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,auth_dt -- 授权日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_decl_info_status_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,status_id -- 状态编号
    ,edit_id -- 版本编号
    ,temp_decl_flow_num -- 临时申报流水号
    ,init_enty_id -- 原始实体编号
    ,tran_flow_num -- 交易流水号
    ,rela_table_name -- 关联表名称
    ,rela_decl_id -- 关联申报编号
    ,decl_num -- 申报号码
    ,trade_gen_cd -- 贸易大类代码
    ,money_idf_cd -- 款项标识代码
    ,base_info_status_cd -- 基础信息状态代码
    ,decl_info_status_cd -- 申报信息状态代码
    ,wrt_off_info_status_cd -- 核销信息状态代码
    ,yga_e_acct_info_status_cd -- 粤港电子账户信息状态代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,auth_dt -- 授权日期
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
    ,o.status_id -- 状态编号
    ,o.edit_id -- 版本编号
    ,o.temp_decl_flow_num -- 临时申报流水号
    ,o.init_enty_id -- 原始实体编号
    ,o.tran_flow_num -- 交易流水号
    ,o.rela_table_name -- 关联表名称
    ,o.rela_decl_id -- 关联申报编号
    ,o.decl_num -- 申报号码
    ,o.trade_gen_cd -- 贸易大类代码
    ,o.money_idf_cd -- 款项标识代码
    ,o.base_info_status_cd -- 基础信息状态代码
    ,o.decl_info_status_cd -- 申报信息状态代码
    ,o.wrt_off_info_status_cd -- 核销信息状态代码
    ,o.yga_e_acct_info_status_cd -- 粤港电子账户信息状态代码
    ,o.bus_oper_teller_id -- 业务经办柜员编号
    ,o.auth_dt -- 授权日期
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
from ${iml_schema}.agt_decl_info_status_h_isbsf1_bk o
    left join ${iml_schema}.agt_decl_info_status_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.status_id = n.status_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_decl_info_status_h_isbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.status_id = d.status_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_decl_info_status_h;
--alter table ${iml_schema}.agt_decl_info_status_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_decl_info_status_h') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_decl_info_status_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_decl_info_status_h modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_decl_info_status_h exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.agt_decl_info_status_h_isbsf1_cl;
alter table ${iml_schema}.agt_decl_info_status_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_decl_info_status_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_decl_info_status_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_decl_info_status_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_decl_info_status_h_isbsf1_op purge;
drop table ${iml_schema}.agt_decl_info_status_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_decl_info_status_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_decl_info_status_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
