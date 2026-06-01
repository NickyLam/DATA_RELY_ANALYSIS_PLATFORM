/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_tel_info_h_ctmsf2
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
alter table ${iml_schema}.pty_tel_info_h add partition p_ctmsf2 values ('ctmsf2')(
        subpartition p_ctmsf2_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ctmsf2_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_tel_info_h_ctmsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_tel_info_h partition for ('ctmsf2')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_tel_info_h_ctmsf2_tm purge;
drop table ${iml_schema}.pty_tel_info_h_ctmsf2_op purge;
drop table ${iml_schema}.pty_tel_info_h_ctmsf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_tel_info_h_ctmsf2_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,tel_type_cd -- 电话类型代码
    ,seq_num -- 序号
    ,tel_num -- 电话号码
    ,main_tel_num_flg -- 主电话号码标志
    ,dd_area_cd -- 长途区号
    ,ext_num -- 分机号码
    ,tel_char_cd -- 电话性质代码
    ,real_name_cert_que_rest -- 实名认证查询结果
    ,latest_chn_cd -- 最新渠道代码
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_tel_info_h partition for ('ctmsf2')
where 0=1
;

create table ${iml_schema}.pty_tel_info_h_ctmsf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_tel_info_h partition for ('ctmsf2') where 0=1;

create table ${iml_schema}.pty_tel_info_h_ctmsf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_tel_info_h partition for ('ctmsf2') where 0=1;

-- 3.1 get new data into table
-- ctms_v_rms_cptys-1
insert into ${iml_schema}.pty_tel_info_h_ctmsf2_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,tel_type_cd -- 电话类型代码
    ,seq_num -- 序号
    ,tel_num -- 电话号码
    ,main_tel_num_flg -- 主电话号码标志
    ,dd_area_cd -- 长途区号
    ,ext_num -- 分机号码
    ,tel_char_cd -- 电话性质代码
    ,real_name_cert_que_rest -- 实名认证查询结果
    ,latest_chn_cd -- 最新渠道代码
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101005'||P1.ENTYID -- 当事人编号
    ,'9999' -- 法人编号
    ,'CTMS' -- 源系统代码
    ,'01' -- 电话类型代码
    ,'1' -- 序号
    ,P1.TELEPHONE -- 电话号码
    ,'1' -- 主电话号码标志
    ,' ' -- 长途区号
    ,' ' -- 分机号码
    ,'-' -- 电话性质代码
    ,' ' -- 实名认证查询结果
    ,'0000' -- 最新渠道代码
    ,${iml_schema}.timeformat_max(NULL) -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_rms_cptys' -- 源表名称
    ,'ctmsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_rms_cptys p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ctms_v_rms_cptys-2
insert into ${iml_schema}.pty_tel_info_h_ctmsf2_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,tel_type_cd -- 电话类型代码
    ,seq_num -- 序号
    ,tel_num -- 电话号码
    ,main_tel_num_flg -- 主电话号码标志
    ,dd_area_cd -- 长途区号
    ,ext_num -- 分机号码
    ,tel_char_cd -- 电话性质代码
    ,real_name_cert_que_rest -- 实名认证查询结果
    ,latest_chn_cd -- 最新渠道代码
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101005'||P1.ENTYID -- 当事人编号
    ,'9999' -- 法人编号
    ,'CTMS' -- 源系统代码
    ,'04' -- 电话类型代码
    ,'1' -- 序号
    ,P1.FAX -- 电话号码
    ,'1' -- 主电话号码标志
    ,' ' -- 长途区号
    ,' ' -- 分机号码
    ,'-' -- 电话性质代码
    ,' ' -- 实名认证查询结果
    ,'0000' -- 最新渠道代码
    ,${iml_schema}.timeformat_max(NULL) -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_rms_cptys' -- 源表名称
    ,'ctmsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_rms_cptys p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_tel_info_h_ctmsf2_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,src_sys_cd
  	                                        ,tel_type_cd
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_tel_info_h_ctmsf2_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,tel_type_cd -- 电话类型代码
    ,seq_num -- 序号
    ,tel_num -- 电话号码
    ,main_tel_num_flg -- 主电话号码标志
    ,dd_area_cd -- 长途区号
    ,ext_num -- 分机号码
    ,tel_char_cd -- 电话性质代码
    ,real_name_cert_que_rest -- 实名认证查询结果
    ,latest_chn_cd -- 最新渠道代码
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_tel_info_h_ctmsf2_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,tel_type_cd -- 电话类型代码
    ,seq_num -- 序号
    ,tel_num -- 电话号码
    ,main_tel_num_flg -- 主电话号码标志
    ,dd_area_cd -- 长途区号
    ,ext_num -- 分机号码
    ,tel_char_cd -- 电话性质代码
    ,real_name_cert_que_rest -- 实名认证查询结果
    ,latest_chn_cd -- 最新渠道代码
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.src_sys_cd, o.src_sys_cd) as src_sys_cd -- 源系统代码
    ,nvl(n.tel_type_cd, o.tel_type_cd) as tel_type_cd -- 电话类型代码
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.main_tel_num_flg, o.main_tel_num_flg) as main_tel_num_flg -- 主电话号码标志
    ,nvl(n.dd_area_cd, o.dd_area_cd) as dd_area_cd -- 长途区号
    ,nvl(n.ext_num, o.ext_num) as ext_num -- 分机号码
    ,nvl(n.tel_char_cd, o.tel_char_cd) as tel_char_cd -- 电话性质代码
    ,nvl(n.real_name_cert_que_rest, o.real_name_cert_que_rest) as real_name_cert_que_rest  -- 实名认证查询结果
    ,nvl(n.latest_chn_cd, o.latest_chn_cd) as latest_chn_cd -- 最新渠道代码
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.src_sys_cd is null
            and n.tel_type_cd is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.src_sys_cd is null
            and n.tel_type_cd is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.src_sys_cd is null
            and n.tel_type_cd is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_tel_info_h_ctmsf2_tm n
    full join (select * from ${iml_schema}.pty_tel_info_h_ctmsf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.src_sys_cd = n.src_sys_cd
            and o.tel_type_cd = n.tel_type_cd
            and o.seq_num = n.seq_num
where (
        o.party_id is null
        and o.lp_id is null
        and o.src_sys_cd is null
        and o.tel_type_cd is null
        and o.seq_num is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.src_sys_cd is null
        and n.tel_type_cd is null
        and n.seq_num is null
    )
    or (
        o.tel_num <> n.tel_num
        or o.main_tel_num_flg <> n.main_tel_num_flg
        or o.dd_area_cd <> n.dd_area_cd
        or o.ext_num <> n.ext_num
        or o.tel_char_cd <> n.tel_char_cd
        or o.real_name_cert_que_rest <> n.real_name_cert_que_rest 
        or o.latest_chn_cd <> n.latest_chn_cd
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_tel_info_h_ctmsf2_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,tel_type_cd -- 电话类型代码
    ,seq_num -- 序号
    ,tel_num -- 电话号码
    ,main_tel_num_flg -- 主电话号码标志
    ,dd_area_cd -- 长途区号
    ,ext_num -- 分机号码
    ,tel_char_cd -- 电话性质代码
    ,real_name_cert_que_rest -- 实名认证查询结果
    ,latest_chn_cd -- 最新渠道代码
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_tel_info_h_ctmsf2_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,tel_type_cd -- 电话类型代码
    ,seq_num -- 序号
    ,tel_num -- 电话号码
    ,main_tel_num_flg -- 主电话号码标志
    ,dd_area_cd -- 长途区号
    ,ext_num -- 分机号码
    ,tel_char_cd -- 电话性质代码
    ,real_name_cert_que_rest -- 实名认证查询结果
    ,latest_chn_cd -- 最新渠道代码
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.src_sys_cd -- 源系统代码
    ,o.tel_type_cd -- 电话类型代码
    ,o.seq_num -- 序号
    ,o.tel_num -- 电话号码
    ,o.main_tel_num_flg -- 主电话号码标志
    ,o.dd_area_cd -- 长途区号
    ,o.ext_num -- 分机号码
    ,o.tel_char_cd -- 电话性质代码
    ,o.real_name_cert_que_rest -- 实名认证查询结果
    ,o.latest_chn_cd -- 最新渠道代码
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
from ${iml_schema}.pty_tel_info_h_ctmsf2_bk o
    left join ${iml_schema}.pty_tel_info_h_ctmsf2_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.src_sys_cd = n.src_sys_cd
            and o.tel_type_cd = n.tel_type_cd
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_tel_info_h_ctmsf2_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.src_sys_cd = d.src_sys_cd
            and o.tel_type_cd = d.tel_type_cd
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_tel_info_h;
--alter table ${iml_schema}.pty_tel_info_h truncate partition for ('ctmsf2') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_tel_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ctmsf2')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_tel_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_tel_info_h modify partition p_ctmsf2 
add subpartition p_ctmsf2_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_tel_info_h exchange subpartition p_ctmsf2_${batch_date} with table ${iml_schema}.pty_tel_info_h_ctmsf2_cl;
alter table ${iml_schema}.pty_tel_info_h exchange subpartition p_ctmsf2_20991231 with table ${iml_schema}.pty_tel_info_h_ctmsf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_tel_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_tel_info_h_ctmsf2_tm purge;
drop table ${iml_schema}.pty_tel_info_h_ctmsf2_op purge;
drop table ${iml_schema}.pty_tel_info_h_ctmsf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_tel_info_h_ctmsf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_tel_info_h', partname => 'p_ctmsf2_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
