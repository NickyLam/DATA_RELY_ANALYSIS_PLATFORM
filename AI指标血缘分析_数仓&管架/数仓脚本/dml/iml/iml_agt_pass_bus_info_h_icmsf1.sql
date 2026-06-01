/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_pass_bus_info_h_icmsf1
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
alter table ${iml_schema}.agt_pass_bus_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_pass_bus_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_pass_bus_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_pass_bus_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_pass_bus_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_pass_bus_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_pass_bus_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pass_bus_id -- 通道业务编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,mger_id -- 管理人编号
    ,trustee_id -- 托管人编号
    ,layered_stru_flg -- 分层结构标志
    ,mgmt_form_cd -- 管理形式代码
    ,espec_aim_vector_type_cd -- 特殊目的载体类型代码
    ,coll_tot_amt -- 募集总金额
    ,nv_item_flg -- 净值项标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,espec_aim_vector_recd_num -- 特殊目的载体备案号
    ,prod_name -- 产品名称
    ,pass_fee_rat -- 通道费率
    ,have_ext_rating_flg -- 有外部评级标志
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_pass_bus_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_pass_bus_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_pass_bus_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_pass_bus_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_pass_bus_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_channelandtrade_info-1
insert into ${iml_schema}.agt_pass_bus_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pass_bus_id -- 通道业务编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,mger_id -- 管理人编号
    ,trustee_id -- 托管人编号
    ,layered_stru_flg -- 分层结构标志
    ,mgmt_form_cd -- 管理形式代码
    ,espec_aim_vector_type_cd -- 特殊目的载体类型代码
    ,coll_tot_amt -- 募集总金额
    ,nv_item_flg -- 净值项标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,espec_aim_vector_recd_num -- 特殊目的载体备案号
    ,prod_name -- 产品名称
    ,pass_fee_rat -- 通道费率
    ,have_ext_rating_flg -- 有外部评级标志
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '231034'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 通道业务编号
    ,P1.CHANNELID -- 通道方编号
    ,P1.CHANNELNAME -- 通道方名称
    ,P1.MANAGERID -- 管理人编号
    ,P1.TRUSTEEID -- 托管人编号
    ,CASE WHEN P1.ISNETVALUE='1' THEN '1' WHEN P1.ISNETVALUE='2' THEN '0' ELSE '-' END -- 分层结构标志
    ,NVL(TRIM(P1.CONTROLTYPE),'-') -- 管理形式代码
    ,P1.CARRIER -- 特殊目的载体类型代码
    ,P1.RAISESUM -- 募集总金额
    ,CASE WHEN P1.ISNETVALUE='1' THEN '1' WHEN P1.ISNETVALUE='2' THEN '0' ELSE '-' END -- 净值项标志
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,${iml_schema}.DATEFORMAT_MIN(TRIM(P1.INPUTDATE)) -- 登记日期
    ,P1.CASENUMBER -- 特殊目的载体备案号
    ,P1.PRODUCTNAME -- 产品名称
    ,P1.COSTRATE -- 通道费率
    ,nvl(trim(P1.HASRATE),'-') -- 有外部评级标志
    ,${iml_schema}.dateformat_max2(P1.UPDATEDATE) -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_channelandtrade_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_channelandtrade_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_pass_bus_info_h_icmsf1_tm 
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
        into ${iml_schema}.agt_pass_bus_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pass_bus_id -- 通道业务编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,mger_id -- 管理人编号
    ,trustee_id -- 托管人编号
    ,layered_stru_flg -- 分层结构标志
    ,mgmt_form_cd -- 管理形式代码
    ,espec_aim_vector_type_cd -- 特殊目的载体类型代码
    ,coll_tot_amt -- 募集总金额
    ,nv_item_flg -- 净值项标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,espec_aim_vector_recd_num -- 特殊目的载体备案号
    ,prod_name -- 产品名称
    ,pass_fee_rat -- 通道费率
    ,have_ext_rating_flg -- 有外部评级标志
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_pass_bus_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pass_bus_id -- 通道业务编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,mger_id -- 管理人编号
    ,trustee_id -- 托管人编号
    ,layered_stru_flg -- 分层结构标志
    ,mgmt_form_cd -- 管理形式代码
    ,espec_aim_vector_type_cd -- 特殊目的载体类型代码
    ,coll_tot_amt -- 募集总金额
    ,nv_item_flg -- 净值项标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,espec_aim_vector_recd_num -- 特殊目的载体备案号
    ,prod_name -- 产品名称
    ,pass_fee_rat -- 通道费率
    ,have_ext_rating_flg -- 有外部评级标志
    ,final_update_dt -- 最后更新日期
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
    ,nvl(n.pass_bus_id, o.pass_bus_id) as pass_bus_id -- 通道业务编号
    ,nvl(n.passer_id, o.passer_id) as passer_id -- 通道方编号
    ,nvl(n.passer_name, o.passer_name) as passer_name -- 通道方名称
    ,nvl(n.mger_id, o.mger_id) as mger_id -- 管理人编号
    ,nvl(n.trustee_id, o.trustee_id) as trustee_id -- 托管人编号
    ,nvl(n.layered_stru_flg, o.layered_stru_flg) as layered_stru_flg -- 分层结构标志
    ,nvl(n.mgmt_form_cd, o.mgmt_form_cd) as mgmt_form_cd -- 管理形式代码
    ,nvl(n.espec_aim_vector_type_cd, o.espec_aim_vector_type_cd) as espec_aim_vector_type_cd -- 特殊目的载体类型代码
    ,nvl(n.coll_tot_amt, o.coll_tot_amt) as coll_tot_amt -- 募集总金额
    ,nvl(n.nv_item_flg, o.nv_item_flg) as nv_item_flg -- 净值项标志
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.espec_aim_vector_recd_num, o.espec_aim_vector_recd_num) as espec_aim_vector_recd_num -- 特殊目的载体备案号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.pass_fee_rat, o.pass_fee_rat) as pass_fee_rat -- 通道费率
    ,nvl(n.have_ext_rating_flg, o.have_ext_rating_flg) as have_ext_rating_flg -- 有外部评级标志
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_pass_bus_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_pass_bus_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.pass_bus_id <> n.pass_bus_id
        or o.passer_id <> n.passer_id
        or o.passer_name <> n.passer_name
        or o.mger_id <> n.mger_id
        or o.trustee_id <> n.trustee_id
        or o.layered_stru_flg <> n.layered_stru_flg
        or o.mgmt_form_cd <> n.mgmt_form_cd
        or o.espec_aim_vector_type_cd <> n.espec_aim_vector_type_cd
        or o.coll_tot_amt <> n.coll_tot_amt
        or o.nv_item_flg <> n.nv_item_flg
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.espec_aim_vector_recd_num <> n.espec_aim_vector_recd_num
        or o.prod_name <> n.prod_name
        or o.pass_fee_rat <> n.pass_fee_rat
        or o.have_ext_rating_flg <> n.have_ext_rating_flg
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_pass_bus_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pass_bus_id -- 通道业务编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,mger_id -- 管理人编号
    ,trustee_id -- 托管人编号
    ,layered_stru_flg -- 分层结构标志
    ,mgmt_form_cd -- 管理形式代码
    ,espec_aim_vector_type_cd -- 特殊目的载体类型代码
    ,coll_tot_amt -- 募集总金额
    ,nv_item_flg -- 净值项标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,espec_aim_vector_recd_num -- 特殊目的载体备案号
    ,prod_name -- 产品名称
    ,pass_fee_rat -- 通道费率
    ,have_ext_rating_flg -- 有外部评级标志
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_pass_bus_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pass_bus_id -- 通道业务编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,mger_id -- 管理人编号
    ,trustee_id -- 托管人编号
    ,layered_stru_flg -- 分层结构标志
    ,mgmt_form_cd -- 管理形式代码
    ,espec_aim_vector_type_cd -- 特殊目的载体类型代码
    ,coll_tot_amt -- 募集总金额
    ,nv_item_flg -- 净值项标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,espec_aim_vector_recd_num -- 特殊目的载体备案号
    ,prod_name -- 产品名称
    ,pass_fee_rat -- 通道费率
    ,have_ext_rating_flg -- 有外部评级标志
    ,final_update_dt -- 最后更新日期
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
    ,o.pass_bus_id -- 通道业务编号
    ,o.passer_id -- 通道方编号
    ,o.passer_name -- 通道方名称
    ,o.mger_id -- 管理人编号
    ,o.trustee_id -- 托管人编号
    ,o.layered_stru_flg -- 分层结构标志
    ,o.mgmt_form_cd -- 管理形式代码
    ,o.espec_aim_vector_type_cd -- 特殊目的载体类型代码
    ,o.coll_tot_amt -- 募集总金额
    ,o.nv_item_flg -- 净值项标志
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.espec_aim_vector_recd_num -- 特殊目的载体备案号
    ,o.prod_name -- 产品名称
    ,o.pass_fee_rat -- 通道费率
    ,o.have_ext_rating_flg -- 有外部评级标志
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_pass_bus_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_pass_bus_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_pass_bus_info_h_icmsf1_cl d
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
--truncate table ${iml_schema}.agt_pass_bus_info_h;
--alter table ${iml_schema}.agt_pass_bus_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_pass_bus_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_pass_bus_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_pass_bus_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_pass_bus_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_pass_bus_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_pass_bus_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_pass_bus_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_pass_bus_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_pass_bus_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_pass_bus_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_pass_bus_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_pass_bus_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_pass_bus_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
