/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_col_guar_cont_info_mimsf1
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
alter table ${iml_schema}.agt_col_guar_cont_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mimsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_col_guar_cont_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_col_guar_cont_info partition for ('mimsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_col_guar_cont_info_mimsf1_tm purge;
drop table ${iml_schema}.agt_col_guar_cont_info_mimsf1_op purge;
drop table ${iml_schema}.agt_col_guar_cont_info_mimsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_col_guar_cont_info_mimsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_amt -- 担保金额
    ,guar_amt_convt_cny -- 担保金额_折人民币
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guartor_id -- 担保人编号
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_rg_num -- 担保人地区号
    ,strip_line_cd -- 条线代码
    ,cont_type_cd -- 合同类型代码
    ,setup_dt -- 建立日期
    ,setup_ps_id -- 建立人编号
    ,guar_curr_cd -- 担保币种代码
    ,guartor_rating -- 担保人评级
    ,data_src_cd -- 数据来源代码
    ,effect_flg -- 生效标志
    ,exp_day -- 到期日
    ,exp_status_cd -- 到期状态代码
    ,higt_pm_cont_flg -- 最高抵质押合同标志
    ,mender_id -- 修改人编号
    ,modif_dt -- 修改日期
    ,begin_day -- 起始日
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_col_guar_cont_info partition for ('mimsf1')
where 0=1
;

create table ${iml_schema}.agt_col_guar_cont_info_mimsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_col_guar_cont_info partition for ('mimsf1') where 0=1;

create table ${iml_schema}.agt_col_guar_cont_info_mimsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_col_guar_cont_info partition for ('mimsf1') where 0=1;

-- 3.1 get new data into table
-- mims_cc_asscontract-
insert into ${iml_schema}.agt_col_guar_cont_info_mimsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_amt -- 担保金额
    ,guar_amt_convt_cny -- 担保金额_折人民币
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guartor_id -- 担保人编号
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_rg_num -- 担保人地区号
    ,strip_line_cd -- 条线代码
    ,cont_type_cd -- 合同类型代码
    ,setup_dt -- 建立日期
    ,setup_ps_id -- 建立人编号
    ,guar_curr_cd -- 担保币种代码
    ,guartor_rating -- 担保人评级
    ,data_src_cd -- 数据来源代码
    ,effect_flg -- 生效标志
    ,exp_day -- 到期日
    ,exp_status_cd -- 到期状态代码
    ,higt_pm_cont_flg -- 最高抵质押合同标志
    ,mender_id -- 修改人编号
    ,modif_dt -- 修改日期
    ,begin_day -- 起始日
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '231030'||p1.ASSCONTNO -- 协议编号
    ,'9999' -- 法人编号
    ,p1.ASSAMT -- 担保金额
    ,p1.ASSAMTRMB -- 担保金额_折人民币
    ,p1.ASSCONTNO -- 担保合同编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.ASSCONTTYPE END -- 担保合同类型代码
    ,p1.ASSCUSTID -- 担保人编号
    ,NVL(TRIM(p1.ASSCUSTTYPE),'0') -- 担保人类型代码
    ,p1.ASSREGIONCODE -- 担保人地区号
    ,NVL(TRIM(P1.BARSIGN),'-') -- 条线代码
    ,NVL(TRIM(p1.CONTYPE),'0') -- 合同类型代码
    ,${iml_schema}.dateformat_min(P1.CREATEDATE) -- 建立日期
    ,p1.CREATER -- 建立人编号
    ,nvl(trim(p1.CURRENCY),'CNY') -- 担保币种代码
    ,p1.CUSTLEVEL -- 担保人评级
    ,nvl(TRIM(P1.DATASOURCEFLAG),'-') -- 数据来源代码
    ,p1.EFFECTEDSTATE -- 生效标志
    ,${iml_schema}.dateformat_max(p1.ENDDATE) -- 到期日
    ,NVL(TRIM(p1.ENDSTATE),'-') -- 到期状态代码
    ,p1.ISHIGHESTBONDEDCONTRACT -- 最高抵质押合同标志
    ,p1.MODIFIER -- 修改人编号
    ,${iml_schema}.dateformat_min(p1.MODIFYDATE) -- 修改日期
    ,${iml_schema}.dateformat_min(P1.STARTDATE) -- 起始日
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_cc_asscontract' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_cc_asscontract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ASSCONTTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MIMS'
        AND R1.SRC_TAB_EN_NAME= 'MIMS_CC_ASSCONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'ASSCONTTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_COL_GUAR_CONT_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'GUAR_CONT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_col_guar_cont_info_mimsf1_tm 
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
        into ${iml_schema}.agt_col_guar_cont_info_mimsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_amt -- 担保金额
    ,guar_amt_convt_cny -- 担保金额_折人民币
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guartor_id -- 担保人编号
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_rg_num -- 担保人地区号
    ,strip_line_cd -- 条线代码
    ,cont_type_cd -- 合同类型代码
    ,setup_dt -- 建立日期
    ,setup_ps_id -- 建立人编号
    ,guar_curr_cd -- 担保币种代码
    ,guartor_rating -- 担保人评级
    ,data_src_cd -- 数据来源代码
    ,effect_flg -- 生效标志
    ,exp_day -- 到期日
    ,exp_status_cd -- 到期状态代码
    ,higt_pm_cont_flg -- 最高抵质押合同标志
    ,mender_id -- 修改人编号
    ,modif_dt -- 修改日期
    ,begin_day -- 起始日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_col_guar_cont_info_mimsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_amt -- 担保金额
    ,guar_amt_convt_cny -- 担保金额_折人民币
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guartor_id -- 担保人编号
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_rg_num -- 担保人地区号
    ,strip_line_cd -- 条线代码
    ,cont_type_cd -- 合同类型代码
    ,setup_dt -- 建立日期
    ,setup_ps_id -- 建立人编号
    ,guar_curr_cd -- 担保币种代码
    ,guartor_rating -- 担保人评级
    ,data_src_cd -- 数据来源代码
    ,effect_flg -- 生效标志
    ,exp_day -- 到期日
    ,exp_status_cd -- 到期状态代码
    ,higt_pm_cont_flg -- 最高抵质押合同标志
    ,mender_id -- 修改人编号
    ,modif_dt -- 修改日期
    ,begin_day -- 起始日
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
    ,nvl(n.guar_amt, o.guar_amt) as guar_amt -- 担保金额
    ,nvl(n.guar_amt_convt_cny, o.guar_amt_convt_cny) as guar_amt_convt_cny -- 担保金额_折人民币
    ,nvl(n.guar_cont_id, o.guar_cont_id) as guar_cont_id -- 担保合同编号
    ,nvl(n.guar_cont_type_cd, o.guar_cont_type_cd) as guar_cont_type_cd -- 担保合同类型代码
    ,nvl(n.guartor_id, o.guartor_id) as guartor_id -- 担保人编号
    ,nvl(n.guartor_type_cd, o.guartor_type_cd) as guartor_type_cd -- 担保人类型代码
    ,nvl(n.guartor_rg_num, o.guartor_rg_num) as guartor_rg_num -- 担保人地区号
    ,nvl(n.strip_line_cd, o.strip_line_cd) as strip_line_cd -- 条线代码
    ,nvl(n.cont_type_cd, o.cont_type_cd) as cont_type_cd -- 合同类型代码
    ,nvl(n.setup_dt, o.setup_dt) as setup_dt -- 建立日期
    ,nvl(n.setup_ps_id, o.setup_ps_id) as setup_ps_id -- 建立人编号
    ,nvl(n.guar_curr_cd, o.guar_curr_cd) as guar_curr_cd -- 担保币种代码
    ,nvl(n.guartor_rating, o.guartor_rating) as guartor_rating -- 担保人评级
    ,nvl(n.data_src_cd, o.data_src_cd) as data_src_cd -- 数据来源代码
    ,nvl(n.effect_flg, o.effect_flg) as effect_flg -- 生效标志
    ,nvl(n.exp_day, o.exp_day) as exp_day -- 到期日
    ,nvl(n.exp_status_cd, o.exp_status_cd) as exp_status_cd -- 到期状态代码
    ,nvl(n.higt_pm_cont_flg, o.higt_pm_cont_flg) as higt_pm_cont_flg -- 最高抵质押合同标志
    ,nvl(n.mender_id, o.mender_id) as mender_id -- 修改人编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 修改日期
    ,nvl(n.begin_day, o.begin_day) as begin_day -- 起始日
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
from ${iml_schema}.agt_col_guar_cont_info_mimsf1_tm n
    full join (select * from ${iml_schema}.agt_col_guar_cont_info_mimsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.guar_amt <> n.guar_amt
        or o.guar_amt_convt_cny <> n.guar_amt_convt_cny
        or o.guar_cont_id <> n.guar_cont_id
        or o.guar_cont_type_cd <> n.guar_cont_type_cd
        or o.guartor_id <> n.guartor_id
        or o.guartor_type_cd <> n.guartor_type_cd
        or o.guartor_rg_num <> n.guartor_rg_num
        or o.strip_line_cd <> n.strip_line_cd
        or o.cont_type_cd <> n.cont_type_cd
        or o.setup_dt <> n.setup_dt
        or o.setup_ps_id <> n.setup_ps_id
        or o.guar_curr_cd <> n.guar_curr_cd
        or o.guartor_rating <> n.guartor_rating
        or o.data_src_cd <> n.data_src_cd
        or o.effect_flg <> n.effect_flg
        or o.exp_day <> n.exp_day
        or o.exp_status_cd <> n.exp_status_cd
        or o.higt_pm_cont_flg <> n.higt_pm_cont_flg
        or o.mender_id <> n.mender_id
        or o.modif_dt <> n.modif_dt
        or o.begin_day <> n.begin_day
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_col_guar_cont_info_mimsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_amt -- 担保金额
    ,guar_amt_convt_cny -- 担保金额_折人民币
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guartor_id -- 担保人编号
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_rg_num -- 担保人地区号
    ,strip_line_cd -- 条线代码
    ,cont_type_cd -- 合同类型代码
    ,setup_dt -- 建立日期
    ,setup_ps_id -- 建立人编号
    ,guar_curr_cd -- 担保币种代码
    ,guartor_rating -- 担保人评级
    ,data_src_cd -- 数据来源代码
    ,effect_flg -- 生效标志
    ,exp_day -- 到期日
    ,exp_status_cd -- 到期状态代码
    ,higt_pm_cont_flg -- 最高抵质押合同标志
    ,mender_id -- 修改人编号
    ,modif_dt -- 修改日期
    ,begin_day -- 起始日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_col_guar_cont_info_mimsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_amt -- 担保金额
    ,guar_amt_convt_cny -- 担保金额_折人民币
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guartor_id -- 担保人编号
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_rg_num -- 担保人地区号
    ,strip_line_cd -- 条线代码
    ,cont_type_cd -- 合同类型代码
    ,setup_dt -- 建立日期
    ,setup_ps_id -- 建立人编号
    ,guar_curr_cd -- 担保币种代码
    ,guartor_rating -- 担保人评级
    ,data_src_cd -- 数据来源代码
    ,effect_flg -- 生效标志
    ,exp_day -- 到期日
    ,exp_status_cd -- 到期状态代码
    ,higt_pm_cont_flg -- 最高抵质押合同标志
    ,mender_id -- 修改人编号
    ,modif_dt -- 修改日期
    ,begin_day -- 起始日
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
    ,o.guar_amt -- 担保金额
    ,o.guar_amt_convt_cny -- 担保金额_折人民币
    ,o.guar_cont_id -- 担保合同编号
    ,o.guar_cont_type_cd -- 担保合同类型代码
    ,o.guartor_id -- 担保人编号
    ,o.guartor_type_cd -- 担保人类型代码
    ,o.guartor_rg_num -- 担保人地区号
    ,o.strip_line_cd -- 条线代码
    ,o.cont_type_cd -- 合同类型代码
    ,o.setup_dt -- 建立日期
    ,o.setup_ps_id -- 建立人编号
    ,o.guar_curr_cd -- 担保币种代码
    ,o.guartor_rating -- 担保人评级
    ,o.data_src_cd -- 数据来源代码
    ,o.effect_flg -- 生效标志
    ,o.exp_day -- 到期日
    ,o.exp_status_cd -- 到期状态代码
    ,o.higt_pm_cont_flg -- 最高抵质押合同标志
    ,o.mender_id -- 修改人编号
    ,o.modif_dt -- 修改日期
    ,o.begin_day -- 起始日
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
from ${iml_schema}.agt_col_guar_cont_info_mimsf1_bk o
    left join ${iml_schema}.agt_col_guar_cont_info_mimsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_col_guar_cont_info_mimsf1_cl d
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
--truncate table ${iml_schema}.agt_col_guar_cont_info;
--alter table ${iml_schema}.agt_col_guar_cont_info truncate partition for ('mimsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_col_guar_cont_info') 
               and substr(subpartition_name,1,8)=upper('p_mimsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_col_guar_cont_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_col_guar_cont_info modify partition p_mimsf1 
add subpartition p_mimsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_col_guar_cont_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.agt_col_guar_cont_info_mimsf1_cl;
alter table ${iml_schema}.agt_col_guar_cont_info exchange subpartition p_mimsf1_20991231 with table ${iml_schema}.agt_col_guar_cont_info_mimsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_col_guar_cont_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_col_guar_cont_info_mimsf1_tm purge;
drop table ${iml_schema}.agt_col_guar_cont_info_mimsf1_op purge;
drop table ${iml_schema}.agt_col_guar_cont_info_mimsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_col_guar_cont_info_mimsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_col_guar_cont_info', partname => 'p_mimsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
