/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cont_guar_cont_rela_h_icmsf1
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
alter table ${iml_schema}.agt_cont_guar_cont_rela_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cont_guar_cont_rela_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_op purge;
drop table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,guar_cont_id -- 担保合同编号
    ,guar_type_cd -- 担保类型代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,src_sys_cd -- 来源系统代码
    ,strip_line_cd -- 条线代码
    ,pri_contr_type_cd -- 主合同类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cont_guar_cont_rela_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cont_guar_cont_rela_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cont_guar_cont_rela_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_cc_asscontcorres
insert into ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,guar_cont_id -- 担保合同编号
    ,guar_type_cd -- 担保类型代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,src_sys_cd -- 来源系统代码
    ,strip_line_cd -- 条线代码
    ,pri_contr_type_cd -- 主合同类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    CASE WHEN trim(P1.DATASOURCEFLAG) = '2' AND trim(P1.CONTNO) IS NOT NULL THEN '222102'||trim(P1.CONTNO)
     WHEN trim(P1.DATASOURCEFLAG) = '3' AND trim(P1.CONTNO) IS NOT NULL and  trim(P1.CONTYPE) = '1' THEN '222303'||trim(P1.CONTNO)
     WHEN trim(P1.DATASOURCEFLAG) = '3' AND trim(P1.CONTNO) IS NOT NULL  THEN '222301'||trim(P1.CONTNO)
     WHEN trim(P1.DATASOURCEFLAG) IN ('5','6') AND trim(P1.CONTNO) IS NOT NULL THEN '231020'||trim(P1.CONTNO)
     ELSE trim(P1.CONTNO)
END -- 协议编号
    ,'9999' -- 法人编号
    ,trim(P1.CONTNO) -- 合同编号
    ,trim(P1.ASSCONTNO) -- 担保合同编号
    ,nvl(trim(P1.ASSCONTTYPE),'-') -- 担保类型代码
    ,P1.USEASSAMT -- 担保金额
    ,nvl(trim(P1.USEASSCURRENCY),'CNY') -- 担保币种代码
    ,nvl(trim(P1.DATASOURCEFLAG),'-') -- 来源系统代码
    ,nvl(trim(P1.BARSIGN),'-') -- 条线代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL 
     THEN R2.TARGET_CD_VAL 
     ELSE '0'END -- 主合同类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_cc_asscontcorres' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_cc_asscontcorres p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CONTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_CC_ASSCONTCORRES'
        AND R2.SRC_FIELD_EN_NAME= 'CONTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_CONT_GUAR_CONT_RELA_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PRI_CONTR_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,cont_id
  	                                        ,guar_cont_id
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
        into ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,guar_cont_id -- 担保合同编号
    ,guar_type_cd -- 担保类型代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,src_sys_cd -- 来源系统代码
    ,strip_line_cd -- 条线代码
    ,pri_contr_type_cd -- 主合同类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,guar_cont_id -- 担保合同编号
    ,guar_type_cd -- 担保类型代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,src_sys_cd -- 来源系统代码
    ,strip_line_cd -- 条线代码
    ,pri_contr_type_cd -- 主合同类型代码
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
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.guar_cont_id, o.guar_cont_id) as guar_cont_id -- 担保合同编号
    ,nvl(n.guar_type_cd, o.guar_type_cd) as guar_type_cd -- 担保类型代码
    ,nvl(n.guar_amt, o.guar_amt) as guar_amt -- 担保金额
    ,nvl(n.guar_curr_cd, o.guar_curr_cd) as guar_curr_cd -- 担保币种代码
    ,nvl(n.src_sys_cd, o.src_sys_cd) as src_sys_cd -- 来源系统代码
    ,nvl(n.strip_line_cd, o.strip_line_cd) as strip_line_cd -- 条线代码
    ,nvl(n.pri_contr_type_cd, o.pri_contr_type_cd) as pri_contr_type_cd -- 主合同类型代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cont_id is null
            and n.guar_cont_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cont_id is null
            and n.guar_cont_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cont_id is null
            and n.guar_cont_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cont_id = n.cont_id
            and o.guar_cont_id = n.guar_cont_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.cont_id is null
        and o.guar_cont_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.cont_id is null
        and n.guar_cont_id is null
    )
    or (
        o.guar_type_cd <> n.guar_type_cd
        or o.guar_amt <> n.guar_amt
        or o.guar_curr_cd <> n.guar_curr_cd
        or o.src_sys_cd <> n.src_sys_cd
        or o.strip_line_cd <> n.strip_line_cd
        or o.pri_contr_type_cd <> n.pri_contr_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,guar_cont_id -- 担保合同编号
    ,guar_type_cd -- 担保类型代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,src_sys_cd -- 来源系统代码
    ,strip_line_cd -- 条线代码
    ,pri_contr_type_cd -- 主合同类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,guar_cont_id -- 担保合同编号
    ,guar_type_cd -- 担保类型代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,src_sys_cd -- 来源系统代码
    ,strip_line_cd -- 条线代码
    ,pri_contr_type_cd -- 主合同类型代码
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
    ,o.cont_id -- 合同编号
    ,o.guar_cont_id -- 担保合同编号
    ,o.guar_type_cd -- 担保类型代码
    ,o.guar_amt -- 担保金额
    ,o.guar_curr_cd -- 担保币种代码
    ,o.src_sys_cd -- 来源系统代码
    ,o.strip_line_cd -- 条线代码
    ,o.pri_contr_type_cd -- 主合同类型代码
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
from ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_bk o
    left join ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cont_id = n.cont_id
            and o.guar_cont_id = n.guar_cont_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.cont_id = d.cont_id
            and o.guar_cont_id = d.guar_cont_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cont_guar_cont_rela_h;
--alter table ${iml_schema}.agt_cont_guar_cont_rela_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_cont_guar_cont_rela_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_cont_guar_cont_rela_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_cont_guar_cont_rela_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_cont_guar_cont_rela_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_cl;
alter table ${iml_schema}.agt_cont_guar_cont_rela_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cont_guar_cont_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_op purge;
drop table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cont_guar_cont_rela_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cont_guar_cont_rela_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
