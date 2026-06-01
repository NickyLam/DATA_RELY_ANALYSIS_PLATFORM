/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_forgn_pay_acpt_decl_info_h_isbsf1
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
alter table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_forgn_pay_acpt_decl_info_h partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_comnt -- 变更原因说明
    ,decl_num -- 申报号码
    ,recver_permt_cty_rg_cd -- 收款人常驻国家和地区代码
    ,pay_type_cd -- 付款类型代码
    ,tran_id_1 -- 交易编号1
    ,tran_amt_1 -- 交易金额1
    ,tran_postsc_1 -- 交易附言1
    ,tran_id_2 -- 交易编号2
    ,tran_amt_2 -- 交易金额2
    ,tran_postsc_2 -- 交易附言2
    ,unbond_cargo_inco_flg -- 保税货物项下收入标志
    ,decl_ps_name -- 申报人名称
    ,decl_ps_tel_num -- 申报人电话号码
    ,decl_dt -- 申报日期
    ,bus_id -- 业务编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_forgn_pay_acpt_decl_info_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_forgn_pay_acpt_decl_info_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_forgn_pay_acpt_decl_info_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_dbk-1
insert into ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_comnt -- 变更原因说明
    ,decl_num -- 申报号码
    ,recver_permt_cty_rg_cd -- 收款人常驻国家和地区代码
    ,pay_type_cd -- 付款类型代码
    ,tran_id_1 -- 交易编号1
    ,tran_amt_1 -- 交易金额1
    ,tran_postsc_1 -- 交易附言1
    ,tran_id_2 -- 交易编号2
    ,tran_amt_2 -- 交易金额2
    ,tran_postsc_2 -- 交易附言2
    ,unbond_cargo_inco_flg -- 保税货物项下收入标志
    ,decl_ps_name -- 申报人名称
    ,decl_ps_tel_num -- 申报人电话号码
    ,decl_dt -- 申报日期
    ,bus_id -- 业务编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '226202'||P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 申报编号
    ,P1.TMPREF -- 临时申报流水编号
    ,P1.OWNEXTKEY -- 原始实体编号
    ,nvl(trim(P1.ACTIONTYPE),'-') -- 操作类型代码
    ,P1.ACTIONDESC -- 变更原因说明
    ,P1.RPTNO -- 申报号码
    ,nvl(trim(P1.COUNTRY),'XXX') -- 收款人常驻国家和地区代码
    ,nvl(trim(P1.PAYTYPE),'O') -- 付款类型代码
    ,P1.TXCODE -- 交易编号1
    ,P1.TC1AMT -- 交易金额1
    ,P1.TXREM -- 交易附言1
    ,P1.TXCODE2 -- 交易编号2
    ,P1.TC2AMT -- 交易金额2
    ,P1.TX2REM -- 交易附言2
    ,decode(trim(P1.ISREF),'Y','1','N','0','','-',P1.ISREF) -- 保税货物项下收入标志
    ,P1.CRTUSER -- 申报人名称
    ,P1.INPTELC -- 申报人电话号码
    ,P1.RPTDATE -- 申报日期
    ,P1.REGNO -- 业务编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_dbk' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_dbk p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_tm 
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
        into ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_comnt -- 变更原因说明
    ,decl_num -- 申报号码
    ,recver_permt_cty_rg_cd -- 收款人常驻国家和地区代码
    ,pay_type_cd -- 付款类型代码
    ,tran_id_1 -- 交易编号1
    ,tran_amt_1 -- 交易金额1
    ,tran_postsc_1 -- 交易附言1
    ,tran_id_2 -- 交易编号2
    ,tran_amt_2 -- 交易金额2
    ,tran_postsc_2 -- 交易附言2
    ,unbond_cargo_inco_flg -- 保税货物项下收入标志
    ,decl_ps_name -- 申报人名称
    ,decl_ps_tel_num -- 申报人电话号码
    ,decl_dt -- 申报日期
    ,bus_id -- 业务编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_comnt -- 变更原因说明
    ,decl_num -- 申报号码
    ,recver_permt_cty_rg_cd -- 收款人常驻国家和地区代码
    ,pay_type_cd -- 付款类型代码
    ,tran_id_1 -- 交易编号1
    ,tran_amt_1 -- 交易金额1
    ,tran_postsc_1 -- 交易附言1
    ,tran_id_2 -- 交易编号2
    ,tran_amt_2 -- 交易金额2
    ,tran_postsc_2 -- 交易附言2
    ,unbond_cargo_inco_flg -- 保税货物项下收入标志
    ,decl_ps_name -- 申报人名称
    ,decl_ps_tel_num -- 申报人电话号码
    ,decl_dt -- 申报日期
    ,bus_id -- 业务编号
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
    ,nvl(n.decl_id, o.decl_id) as decl_id -- 申报编号
    ,nvl(n.temp_decl_flow_id, o.temp_decl_flow_id) as temp_decl_flow_id -- 临时申报流水编号
    ,nvl(n.init_enty_id, o.init_enty_id) as init_enty_id -- 原始实体编号
    ,nvl(n.oper_type_cd, o.oper_type_cd) as oper_type_cd -- 操作类型代码
    ,nvl(n.modif_rs_comnt, o.modif_rs_comnt) as modif_rs_comnt -- 变更原因说明
    ,nvl(n.decl_num, o.decl_num) as decl_num -- 申报号码
    ,nvl(n.recver_permt_cty_rg_cd, o.recver_permt_cty_rg_cd) as recver_permt_cty_rg_cd -- 收款人常驻国家和地区代码
    ,nvl(n.pay_type_cd, o.pay_type_cd) as pay_type_cd -- 付款类型代码
    ,nvl(n.tran_id_1, o.tran_id_1) as tran_id_1 -- 交易编号1
    ,nvl(n.tran_amt_1, o.tran_amt_1) as tran_amt_1 -- 交易金额1
    ,nvl(n.tran_postsc_1, o.tran_postsc_1) as tran_postsc_1 -- 交易附言1
    ,nvl(n.tran_id_2, o.tran_id_2) as tran_id_2 -- 交易编号2
    ,nvl(n.tran_amt_2, o.tran_amt_2) as tran_amt_2 -- 交易金额2
    ,nvl(n.tran_postsc_2, o.tran_postsc_2) as tran_postsc_2 -- 交易附言2
    ,nvl(n.unbond_cargo_inco_flg, o.unbond_cargo_inco_flg) as unbond_cargo_inco_flg -- 保税货物项下收入标志
    ,nvl(n.decl_ps_name, o.decl_ps_name) as decl_ps_name -- 申报人名称
    ,nvl(n.decl_ps_tel_num, o.decl_ps_tel_num) as decl_ps_tel_num -- 申报人电话号码
    ,nvl(n.decl_dt, o.decl_dt) as decl_dt -- 申报日期
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
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
from ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.decl_id <> n.decl_id
        or o.temp_decl_flow_id <> n.temp_decl_flow_id
        or o.init_enty_id <> n.init_enty_id
        or o.oper_type_cd <> n.oper_type_cd
        or o.modif_rs_comnt <> n.modif_rs_comnt
        or o.decl_num <> n.decl_num
        or o.recver_permt_cty_rg_cd <> n.recver_permt_cty_rg_cd
        or o.pay_type_cd <> n.pay_type_cd
        or o.tran_id_1 <> n.tran_id_1
        or o.tran_amt_1 <> n.tran_amt_1
        or o.tran_postsc_1 <> n.tran_postsc_1
        or o.tran_id_2 <> n.tran_id_2
        or o.tran_amt_2 <> n.tran_amt_2
        or o.tran_postsc_2 <> n.tran_postsc_2
        or o.unbond_cargo_inco_flg <> n.unbond_cargo_inco_flg
        or o.decl_ps_name <> n.decl_ps_name
        or o.decl_ps_tel_num <> n.decl_ps_tel_num
        or o.decl_dt <> n.decl_dt
        or o.bus_id <> n.bus_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_comnt -- 变更原因说明
    ,decl_num -- 申报号码
    ,recver_permt_cty_rg_cd -- 收款人常驻国家和地区代码
    ,pay_type_cd -- 付款类型代码
    ,tran_id_1 -- 交易编号1
    ,tran_amt_1 -- 交易金额1
    ,tran_postsc_1 -- 交易附言1
    ,tran_id_2 -- 交易编号2
    ,tran_amt_2 -- 交易金额2
    ,tran_postsc_2 -- 交易附言2
    ,unbond_cargo_inco_flg -- 保税货物项下收入标志
    ,decl_ps_name -- 申报人名称
    ,decl_ps_tel_num -- 申报人电话号码
    ,decl_dt -- 申报日期
    ,bus_id -- 业务编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_comnt -- 变更原因说明
    ,decl_num -- 申报号码
    ,recver_permt_cty_rg_cd -- 收款人常驻国家和地区代码
    ,pay_type_cd -- 付款类型代码
    ,tran_id_1 -- 交易编号1
    ,tran_amt_1 -- 交易金额1
    ,tran_postsc_1 -- 交易附言1
    ,tran_id_2 -- 交易编号2
    ,tran_amt_2 -- 交易金额2
    ,tran_postsc_2 -- 交易附言2
    ,unbond_cargo_inco_flg -- 保税货物项下收入标志
    ,decl_ps_name -- 申报人名称
    ,decl_ps_tel_num -- 申报人电话号码
    ,decl_dt -- 申报日期
    ,bus_id -- 业务编号
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
    ,o.decl_id -- 申报编号
    ,o.temp_decl_flow_id -- 临时申报流水编号
    ,o.init_enty_id -- 原始实体编号
    ,o.oper_type_cd -- 操作类型代码
    ,o.modif_rs_comnt -- 变更原因说明
    ,o.decl_num -- 申报号码
    ,o.recver_permt_cty_rg_cd -- 收款人常驻国家和地区代码
    ,o.pay_type_cd -- 付款类型代码
    ,o.tran_id_1 -- 交易编号1
    ,o.tran_amt_1 -- 交易金额1
    ,o.tran_postsc_1 -- 交易附言1
    ,o.tran_id_2 -- 交易编号2
    ,o.tran_amt_2 -- 交易金额2
    ,o.tran_postsc_2 -- 交易附言2
    ,o.unbond_cargo_inco_flg -- 保税货物项下收入标志
    ,o.decl_ps_name -- 申报人名称
    ,o.decl_ps_tel_num -- 申报人电话号码
    ,o.decl_dt -- 申报日期
    ,o.bus_id -- 业务编号
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
from ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_bk o
    left join ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_cl d
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
--truncate table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h;
--alter table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_forgn_pay_acpt_decl_info_h') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_cl;
alter table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_forgn_pay_acpt_decl_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_forgn_pay_acpt_decl_info_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_forgn_pay_acpt_decl_info_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
