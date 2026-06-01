/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_chn_termn_equip_basic_info_h_atmsf1
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
alter table ${iml_schema}.chn_termn_equip_basic_info_h add partition p_atmsf1 values ('atmsf1')(
        subpartition p_atmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_atmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_termn_equip_basic_info_h partition for ('atmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_tm purge;
drop table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_op purge;
drop table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_tm nologging
compress ${option_switch} for query high
as select
    equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,chn_id -- 直联终端编号
    ,term_id -- 终端编号
    ,termn_id -- 设备IP
    ,belong_org_id -- 所属机构编号
    ,in_bank_flg -- 在行标志
    ,equip_type_cd -- 设备类型代码
    ,equip_type_name -- 设备类型名称
    ,equip_model -- 设备型号
    ,equip_status_cd -- 设备状态代码
    ,equip_matnce_id -- 设备维护商编号
    ,equip_install_dt -- 设备安装日期
    ,cash_flg -- 现金标志
    ,install_way_cd -- 安装方式代码
    ,dist_cd -- 行政区划代码
    ,equip_ser_num -- 设备序列号
    ,equip_addr -- 设备地址
    ,termn_status_cd -- 终端状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_termn_equip_basic_info_h partition for ('atmsf1')
where 0=1
;

create table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_termn_equip_basic_info_h partition for ('atmsf1') where 0=1;

create table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_termn_equip_basic_info_h partition for ('atmsf1') where 0=1;

-- 3.1 get new data into table
-- atms_dev_base_info-
insert into ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_tm(
    equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,chn_id -- 直联终端编号
    ,term_id -- 终端编号
    ,termn_id -- 设备IP
    ,belong_org_id -- 所属机构编号
    ,in_bank_flg -- 在行标志
    ,equip_type_cd -- 设备类型代码
    ,equip_type_name -- 设备类型名称
    ,equip_model -- 设备型号
    ,equip_status_cd -- 设备状态代码
    ,equip_matnce_id -- 设备维护商编号
    ,equip_install_dt -- 设备安装日期
    ,cash_flg -- 现金标志
    ,install_way_cd -- 安装方式代码
    ,dist_cd -- 行政区划代码
    ,equip_ser_num -- 设备序列号
    ,equip_addr -- 设备地址
    ,termn_status_cd -- 终端状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.NO -- 设备编号
    ,'9999' -- 法人编号
    ,P1.NO -- 直联终端编号
    ,P1.TERMINAL_NO -- 终端编号
    ,P1.IP -- 设备IP
    ,P1.ORG_NO -- 所属机构编号
    ,CASE WHEN TO_CHAR(P1.AWAY_FLAG)='1' THEN '1' WHEN TO_CHAR(P1.AWAY_FLAG)='2' THEN '0' ELSE TO_CHAR(P1.AWAY_FLAG) END -- 在行标志
    ,TO_CHAR(P1.DEV_CATALOG) -- 设备类型代码
    ,P2.ENNAME -- 设备类型名称
    ,TO_CHAR(P1.DEV_TYPE) -- 设备型号
    ,NVL(TRIM(TO_CHAR(P1.STATUS)),'-') -- 设备状态代码
    ,TO_CHAR(P1.DEV_SERVICE) -- 设备维护商编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.INSTALL_DATE) -- 设备安装日期
    ,CASE WHEN TO_CHAR(P1.CASH_TYPE)='1' THEN '1' WHEN TO_CHAR(P1.CASH_TYPE)='2' THEN '0' ELSE TO_CHAR(P1.CASH_TYPE) END -- 现金标志
    ,NVL(TRIM(TO_CHAR(P1.SETUP_TYPE)),'-') -- 安装方式代码
    ,nvl(trim(P1.COUNTRY_NO),'000000') -- 行政区划代码
    ,P1.SERIAL -- 设备序列号
    ,P1.ADDRESS -- 设备地址
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TERMINAL_STATUS end -- 终端状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'atms_dev_base_info' -- 源表名称
    ,'atmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.atms_dev_base_info p1
    left join ${iol_schema}.atms_dev_catalog_table p2 on P1.DEV_CATALOG=P2.NO AND   P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TERMINAL_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ATMS'
        AND R1.SRC_TAB_EN_NAME= 'ATMS_DEV_BASE_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'TERMINAL_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'CHN_TERMN_EQUIP_BASIC_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TERMN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_tm 
  	                                group by 
  	                                        equip_id
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
        into ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_cl(
            equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,chn_id -- 直联终端编号
    ,term_id -- 终端编号
    ,termn_id -- 设备IP
    ,belong_org_id -- 所属机构编号
    ,in_bank_flg -- 在行标志
    ,equip_type_cd -- 设备类型代码
    ,equip_type_name -- 设备类型名称
    ,equip_model -- 设备型号
    ,equip_status_cd -- 设备状态代码
    ,equip_matnce_id -- 设备维护商编号
    ,equip_install_dt -- 设备安装日期
    ,cash_flg -- 现金标志
    ,install_way_cd -- 安装方式代码
    ,dist_cd -- 行政区划代码
    ,equip_ser_num -- 设备序列号
    ,equip_addr -- 设备地址
    ,termn_status_cd -- 终端状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_op(
            equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,chn_id -- 直联终端编号
    ,term_id -- 终端编号
    ,termn_id -- 设备IP
    ,belong_org_id -- 所属机构编号
    ,in_bank_flg -- 在行标志
    ,equip_type_cd -- 设备类型代码
    ,equip_type_name -- 设备类型名称
    ,equip_model -- 设备型号
    ,equip_status_cd -- 设备状态代码
    ,equip_matnce_id -- 设备维护商编号
    ,equip_install_dt -- 设备安装日期
    ,cash_flg -- 现金标志
    ,install_way_cd -- 安装方式代码
    ,dist_cd -- 行政区划代码
    ,equip_ser_num -- 设备序列号
    ,equip_addr -- 设备地址
    ,termn_status_cd -- 终端状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.equip_id, o.equip_id) as equip_id -- 设备编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 直联终端编号
    ,nvl(n.term_id, o.term_id) as term_id -- 终端编号
    ,nvl(n.termn_id, o.termn_id) as termn_id -- 设备IP
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.in_bank_flg, o.in_bank_flg) as in_bank_flg -- 在行标志
    ,nvl(n.equip_type_cd, o.equip_type_cd) as equip_type_cd -- 设备类型代码
    ,nvl(n.equip_type_name, o.equip_type_name) as equip_type_name -- 设备类型名称
    ,nvl(n.equip_model, o.equip_model) as equip_model -- 设备型号
    ,nvl(n.equip_status_cd, o.equip_status_cd) as equip_status_cd -- 设备状态代码
    ,nvl(n.equip_matnce_id, o.equip_matnce_id) as equip_matnce_id -- 设备维护商编号
    ,nvl(n.equip_install_dt, o.equip_install_dt) as equip_install_dt -- 设备安装日期
    ,nvl(n.cash_flg, o.cash_flg) as cash_flg -- 现金标志
    ,nvl(n.install_way_cd, o.install_way_cd) as install_way_cd -- 安装方式代码
    ,nvl(n.dist_cd, o.dist_cd) as dist_cd -- 行政区划代码
    ,nvl(n.equip_ser_num, o.equip_ser_num) as equip_ser_num -- 设备序列号
    ,nvl(n.equip_addr, o.equip_addr) as equip_addr -- 设备地址
    ,nvl(n.termn_status_cd, o.termn_status_cd) as termn_status_cd -- 终端状态代码
    ,case when
            n.equip_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.equip_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.equip_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_tm n
    full join (select * from ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.equip_id = n.equip_id
            and o.lp_id = n.lp_id
where (
        o.equip_id is null
        and o.lp_id is null
    )
    or (
        n.equip_id is null
        and n.lp_id is null
    )
    or (
        o.chn_id <> n.chn_id
        or o.term_id <> n.term_id
        or o.termn_id <> n.termn_id
        or o.belong_org_id <> n.belong_org_id
        or o.in_bank_flg <> n.in_bank_flg
        or o.equip_type_cd <> n.equip_type_cd
        or o.equip_type_name <> n.equip_type_name
        or o.equip_model <> n.equip_model
        or o.equip_status_cd <> n.equip_status_cd
        or o.equip_matnce_id <> n.equip_matnce_id
        or o.equip_install_dt <> n.equip_install_dt
        or o.cash_flg <> n.cash_flg
        or o.install_way_cd <> n.install_way_cd
        or o.dist_cd <> n.dist_cd
        or o.equip_ser_num <> n.equip_ser_num
        or o.equip_addr <> n.equip_addr
        or o.termn_status_cd <> n.termn_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_cl(
            equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,chn_id -- 直联终端编号
    ,term_id -- 终端编号
    ,termn_id -- 设备IP
    ,belong_org_id -- 所属机构编号
    ,in_bank_flg -- 在行标志
    ,equip_type_cd -- 设备类型代码
    ,equip_type_name -- 设备类型名称
    ,equip_model -- 设备型号
    ,equip_status_cd -- 设备状态代码
    ,equip_matnce_id -- 设备维护商编号
    ,equip_install_dt -- 设备安装日期
    ,cash_flg -- 现金标志
    ,install_way_cd -- 安装方式代码
    ,dist_cd -- 行政区划代码
    ,equip_ser_num -- 设备序列号
    ,equip_addr -- 设备地址
    ,termn_status_cd -- 终端状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_op(
            equip_id -- 设备编号
    ,lp_id -- 法人编号
    ,chn_id -- 直联终端编号
    ,term_id -- 终端编号
    ,termn_id -- 设备IP
    ,belong_org_id -- 所属机构编号
    ,in_bank_flg -- 在行标志
    ,equip_type_cd -- 设备类型代码
    ,equip_type_name -- 设备类型名称
    ,equip_model -- 设备型号
    ,equip_status_cd -- 设备状态代码
    ,equip_matnce_id -- 设备维护商编号
    ,equip_install_dt -- 设备安装日期
    ,cash_flg -- 现金标志
    ,install_way_cd -- 安装方式代码
    ,dist_cd -- 行政区划代码
    ,equip_ser_num -- 设备序列号
    ,equip_addr -- 设备地址
    ,termn_status_cd -- 终端状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.equip_id -- 设备编号
    ,o.lp_id -- 法人编号
    ,o.chn_id -- 直联终端编号
    ,o.term_id -- 终端编号
    ,o.termn_id -- 设备IP
    ,o.belong_org_id -- 所属机构编号
    ,o.in_bank_flg -- 在行标志
    ,o.equip_type_cd -- 设备类型代码
    ,o.equip_type_name -- 设备类型名称
    ,o.equip_model -- 设备型号
    ,o.equip_status_cd -- 设备状态代码
    ,o.equip_matnce_id -- 设备维护商编号
    ,o.equip_install_dt -- 设备安装日期
    ,o.cash_flg -- 现金标志
    ,o.install_way_cd -- 安装方式代码
    ,o.dist_cd -- 行政区划代码
    ,o.equip_ser_num -- 设备序列号
    ,o.equip_addr -- 设备地址
    ,o.termn_status_cd -- 终端状态代码
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
from ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_bk o
    left join ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_op n
        on
            o.equip_id = n.equip_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_cl d
        on
            o.equip_id = d.equip_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.chn_termn_equip_basic_info_h;
--alter table ${iml_schema}.chn_termn_equip_basic_info_h truncate partition for ('atmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('chn_termn_equip_basic_info_h') 
               and substr(subpartition_name,1,8)=upper('p_atmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.chn_termn_equip_basic_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.chn_termn_equip_basic_info_h modify partition p_atmsf1 
add subpartition p_atmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.chn_termn_equip_basic_info_h exchange subpartition p_atmsf1_${batch_date} with table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_cl;
alter table ${iml_schema}.chn_termn_equip_basic_info_h exchange subpartition p_atmsf1_20991231 with table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.chn_termn_equip_basic_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_tm purge;
drop table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_op purge;
drop table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.chn_termn_equip_basic_info_h_atmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'chn_termn_equip_basic_info_h', partname => 'p_atmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
