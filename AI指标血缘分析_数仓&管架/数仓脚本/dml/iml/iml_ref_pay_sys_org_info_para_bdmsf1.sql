/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_pay_sys_org_info_para_bdmsf1
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
alter table ${iml_schema}.ref_pay_sys_org_info_para add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_pay_sys_org_info_para partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_tm purge;
drop table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_op purge;
drop table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    pay_sys_org_info_id -- 支付系统机构信息编号
    ,lp_id -- 法人编号
    ,prtcpt_org_bank_no -- 参与机构行号
    ,prtcpt_org_cate_cd -- 参与机构类别代码
    ,bank_type_cd -- 行别代码
    ,belong_dir_bk_num -- 所属直参行号
    ,belong_lp_id -- 所属法人编号
    ,super_prtcpt_org_id -- 上级参与机构编号
    ,udtake_bank_no -- 承接行行号
    ,durdt_bank_no -- 管辖人行行号
    ,belong_pay_sys_cd -- 所属支付系统代码
    ,city_cd -- 所在城市代码
    ,prtcpt_org_cn_name -- 参与机构中文名称
    ,tel_num_or_cable_addr -- 电话号码或电挂
    ,pbc_bigamt_bus_sys_flg -- 加入人行大额业务系统标志
    ,effect_type_cd -- 生效类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_pay_sys_org_info_para partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_pay_sys_org_info_para partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_pay_sys_org_info_para partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_htes_ptcpt_info-
insert into ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_tm(
    pay_sys_org_info_id -- 支付系统机构信息编号
    ,lp_id -- 法人编号
    ,prtcpt_org_bank_no -- 参与机构行号
    ,prtcpt_org_cate_cd -- 参与机构类别代码
    ,bank_type_cd -- 行别代码
    ,belong_dir_bk_num -- 所属直参行号
    ,belong_lp_id -- 所属法人编号
    ,super_prtcpt_org_id -- 上级参与机构编号
    ,udtake_bank_no -- 承接行行号
    ,durdt_bank_no -- 管辖人行行号
    ,belong_pay_sys_cd -- 所属支付系统代码
    ,city_cd -- 所在城市代码
    ,prtcpt_org_cn_name -- 参与机构中文名称
    ,tel_num_or_cable_addr -- 电话号码或电挂
    ,pbc_bigamt_bus_sys_flg -- 加入人行大额业务系统标志
    ,effect_type_cd -- 生效类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 支付系统机构信息编号
    ,'9999' -- 法人编号
    ,P1.BANK_NO -- 参与机构行号
    ,NVL(TRIM(P1.ACTOR_TYPE),'00') -- 参与机构类别代码
    ,P1.BANK_OTHER_CODE -- 行别代码
    ,P1.BELONG_BANK_NO -- 所属直参行号
    ,P1.BELONG_LEGAL_NO -- 所属法人编号
    ,P1.UP_ACTOR_NO -- 上级参与机构编号
    ,P1.RECEPT_BANK_NO -- 承接行行号
    ,P1.CATE_PEOPLE_CODE -- 管辖人行行号
    ,P1.CCPC_CODE -- 所属支付系统代码
    ,P1.CITY_CODE -- 所在城市代码
    ,P1.BANK_NAME -- 参与机构中文名称
    ,P1.TEL_PHONE -- 电话号码或电挂
    ,NVL(TRIM(P1.JION_FLAG),'-'） -- 加入人行大额业务系统标志
    ,NVL(TRIM(P1.EFFECT_TYPE),'-') -- 生效类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.EFFECT_DATE) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.EXPIRE_DATE) -- 失效日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_htes_ptcpt_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_htes_ptcpt_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_tm 
  	                                group by 
  	                                        pay_sys_org_info_id
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
        into ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_cl(
            pay_sys_org_info_id -- 支付系统机构信息编号
    ,lp_id -- 法人编号
    ,prtcpt_org_bank_no -- 参与机构行号
    ,prtcpt_org_cate_cd -- 参与机构类别代码
    ,bank_type_cd -- 行别代码
    ,belong_dir_bk_num -- 所属直参行号
    ,belong_lp_id -- 所属法人编号
    ,super_prtcpt_org_id -- 上级参与机构编号
    ,udtake_bank_no -- 承接行行号
    ,durdt_bank_no -- 管辖人行行号
    ,belong_pay_sys_cd -- 所属支付系统代码
    ,city_cd -- 所在城市代码
    ,prtcpt_org_cn_name -- 参与机构中文名称
    ,tel_num_or_cable_addr -- 电话号码或电挂
    ,pbc_bigamt_bus_sys_flg -- 加入人行大额业务系统标志
    ,effect_type_cd -- 生效类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_op(
            pay_sys_org_info_id -- 支付系统机构信息编号
    ,lp_id -- 法人编号
    ,prtcpt_org_bank_no -- 参与机构行号
    ,prtcpt_org_cate_cd -- 参与机构类别代码
    ,bank_type_cd -- 行别代码
    ,belong_dir_bk_num -- 所属直参行号
    ,belong_lp_id -- 所属法人编号
    ,super_prtcpt_org_id -- 上级参与机构编号
    ,udtake_bank_no -- 承接行行号
    ,durdt_bank_no -- 管辖人行行号
    ,belong_pay_sys_cd -- 所属支付系统代码
    ,city_cd -- 所在城市代码
    ,prtcpt_org_cn_name -- 参与机构中文名称
    ,tel_num_or_cable_addr -- 电话号码或电挂
    ,pbc_bigamt_bus_sys_flg -- 加入人行大额业务系统标志
    ,effect_type_cd -- 生效类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pay_sys_org_info_id, o.pay_sys_org_info_id) as pay_sys_org_info_id -- 支付系统机构信息编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prtcpt_org_bank_no, o.prtcpt_org_bank_no) as prtcpt_org_bank_no -- 参与机构行号
    ,nvl(n.prtcpt_org_cate_cd, o.prtcpt_org_cate_cd) as prtcpt_org_cate_cd -- 参与机构类别代码
    ,nvl(n.bank_type_cd, o.bank_type_cd) as bank_type_cd -- 行别代码
    ,nvl(n.belong_dir_bk_num, o.belong_dir_bk_num) as belong_dir_bk_num -- 所属直参行号
    ,nvl(n.belong_lp_id, o.belong_lp_id) as belong_lp_id -- 所属法人编号
    ,nvl(n.super_prtcpt_org_id, o.super_prtcpt_org_id) as super_prtcpt_org_id -- 上级参与机构编号
    ,nvl(n.udtake_bank_no, o.udtake_bank_no) as udtake_bank_no -- 承接行行号
    ,nvl(n.durdt_bank_no, o.durdt_bank_no) as durdt_bank_no -- 管辖人行行号
    ,nvl(n.belong_pay_sys_cd, o.belong_pay_sys_cd) as belong_pay_sys_cd -- 所属支付系统代码
    ,nvl(n.city_cd, o.city_cd) as city_cd -- 所在城市代码
    ,nvl(n.prtcpt_org_cn_name, o.prtcpt_org_cn_name) as prtcpt_org_cn_name -- 参与机构中文名称
    ,nvl(n.tel_num_or_cable_addr, o.tel_num_or_cable_addr) as tel_num_or_cable_addr -- 电话号码或电挂
    ,nvl(n.pbc_bigamt_bus_sys_flg, o.pbc_bigamt_bus_sys_flg) as pbc_bigamt_bus_sys_flg -- 加入人行大额业务系统标志
    ,nvl(n.effect_type_cd, o.effect_type_cd) as effect_type_cd -- 生效类型代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,case when
            n.pay_sys_org_info_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pay_sys_org_info_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pay_sys_org_info_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_tm n
    full join (select * from ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.pay_sys_org_info_id = n.pay_sys_org_info_id
            and o.lp_id = n.lp_id
where (
        o.pay_sys_org_info_id is null
        and o.lp_id is null
    )
    or (
        n.pay_sys_org_info_id is null
        and n.lp_id is null
    )
    or (
        o.prtcpt_org_bank_no <> n.prtcpt_org_bank_no
        or o.prtcpt_org_cate_cd <> n.prtcpt_org_cate_cd
        or o.bank_type_cd <> n.bank_type_cd
        or o.belong_dir_bk_num <> n.belong_dir_bk_num
        or o.belong_lp_id <> n.belong_lp_id
        or o.super_prtcpt_org_id <> n.super_prtcpt_org_id
        or o.udtake_bank_no <> n.udtake_bank_no
        or o.durdt_bank_no <> n.durdt_bank_no
        or o.belong_pay_sys_cd <> n.belong_pay_sys_cd
        or o.city_cd <> n.city_cd
        or o.prtcpt_org_cn_name <> n.prtcpt_org_cn_name
        or o.tel_num_or_cable_addr <> n.tel_num_or_cable_addr
        or o.pbc_bigamt_bus_sys_flg <> n.pbc_bigamt_bus_sys_flg
        or o.effect_type_cd <> n.effect_type_cd
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_cl(
            pay_sys_org_info_id -- 支付系统机构信息编号
    ,lp_id -- 法人编号
    ,prtcpt_org_bank_no -- 参与机构行号
    ,prtcpt_org_cate_cd -- 参与机构类别代码
    ,bank_type_cd -- 行别代码
    ,belong_dir_bk_num -- 所属直参行号
    ,belong_lp_id -- 所属法人编号
    ,super_prtcpt_org_id -- 上级参与机构编号
    ,udtake_bank_no -- 承接行行号
    ,durdt_bank_no -- 管辖人行行号
    ,belong_pay_sys_cd -- 所属支付系统代码
    ,city_cd -- 所在城市代码
    ,prtcpt_org_cn_name -- 参与机构中文名称
    ,tel_num_or_cable_addr -- 电话号码或电挂
    ,pbc_bigamt_bus_sys_flg -- 加入人行大额业务系统标志
    ,effect_type_cd -- 生效类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_op(
            pay_sys_org_info_id -- 支付系统机构信息编号
    ,lp_id -- 法人编号
    ,prtcpt_org_bank_no -- 参与机构行号
    ,prtcpt_org_cate_cd -- 参与机构类别代码
    ,bank_type_cd -- 行别代码
    ,belong_dir_bk_num -- 所属直参行号
    ,belong_lp_id -- 所属法人编号
    ,super_prtcpt_org_id -- 上级参与机构编号
    ,udtake_bank_no -- 承接行行号
    ,durdt_bank_no -- 管辖人行行号
    ,belong_pay_sys_cd -- 所属支付系统代码
    ,city_cd -- 所在城市代码
    ,prtcpt_org_cn_name -- 参与机构中文名称
    ,tel_num_or_cable_addr -- 电话号码或电挂
    ,pbc_bigamt_bus_sys_flg -- 加入人行大额业务系统标志
    ,effect_type_cd -- 生效类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pay_sys_org_info_id -- 支付系统机构信息编号
    ,o.lp_id -- 法人编号
    ,o.prtcpt_org_bank_no -- 参与机构行号
    ,o.prtcpt_org_cate_cd -- 参与机构类别代码
    ,o.bank_type_cd -- 行别代码
    ,o.belong_dir_bk_num -- 所属直参行号
    ,o.belong_lp_id -- 所属法人编号
    ,o.super_prtcpt_org_id -- 上级参与机构编号
    ,o.udtake_bank_no -- 承接行行号
    ,o.durdt_bank_no -- 管辖人行行号
    ,o.belong_pay_sys_cd -- 所属支付系统代码
    ,o.city_cd -- 所在城市代码
    ,o.prtcpt_org_cn_name -- 参与机构中文名称
    ,o.tel_num_or_cable_addr -- 电话号码或电挂
    ,o.pbc_bigamt_bus_sys_flg -- 加入人行大额业务系统标志
    ,o.effect_type_cd -- 生效类型代码
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
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
from ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_bk o
    left join ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_op n
        on
            o.pay_sys_org_info_id = n.pay_sys_org_info_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_cl d
        on
            o.pay_sys_org_info_id = d.pay_sys_org_info_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_pay_sys_org_info_para;
--alter table ${iml_schema}.ref_pay_sys_org_info_para truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_pay_sys_org_info_para') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_pay_sys_org_info_para drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_pay_sys_org_info_para modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_pay_sys_org_info_para exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_cl;
alter table ${iml_schema}.ref_pay_sys_org_info_para exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_pay_sys_org_info_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_tm purge;
drop table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_op purge;
drop table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_pay_sys_org_info_para_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_pay_sys_org_info_para', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
