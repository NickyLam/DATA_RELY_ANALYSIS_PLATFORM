/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_chn_dir_termn_info_h_mrmsf1
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
alter table ${iml_schema}.chn_dir_termn_info_h add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_dir_termn_info_h partition for ('mrmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_op purge;
drop table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    chn_id -- 直联终端编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,termn_id -- 终端编号
    ,termnl_id -- 终端机身编号
    ,mercht_id -- 商户编号
    ,mercht_seq_num -- 商户序号
    ,termn_type_cd -- 终端类型代码
    ,termn_usage_cd -- 终端用途代码
    ,remark -- 备注
    ,iss_dt -- 出单日期
    ,install_dt -- 安装日期
    ,oper_type_cd -- 操作类型代码
    ,termn_install_addr -- 终端安装地址
    ,termn_name -- 终端名称
    ,inst_tel -- 装机电话
    ,termn_status_cd -- 终端状态代码
    ,status_cd -- 状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_dir_termn_info_h partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_dir_termn_info_h partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_dir_termn_info_h partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_direct_term_inf-
insert into ${iml_schema}.chn_dir_termn_info_h_mrmsf1_tm(
    chn_id -- 直联终端编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,termn_id -- 终端编号
    ,termnl_id -- 终端机身编号
    ,mercht_id -- 商户编号
    ,mercht_seq_num -- 商户序号
    ,termn_type_cd -- 终端类型代码
    ,termn_usage_cd -- 终端用途代码
    ,remark -- 备注
    ,iss_dt -- 出单日期
    ,install_dt -- 安装日期
    ,oper_type_cd -- 操作类型代码
    ,termn_install_addr -- 终端安装地址
    ,termn_name -- 终端名称
    ,inst_tel -- 装机电话
    ,termn_status_cd -- 终端状态代码
    ,status_cd -- 状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '103002'||p1.id -- 直联终端编号
    ,p1.id -- 序号
    ,'9999' -- 法人编号
    ,p1.term_cd -- 终端编号
    ,p1.term_sn -- 终端机身编号
    ,p1.mcht_no -- 商户编号
    ,p1.mchtserial -- 商户序号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.term_type end -- 终端类型代码
    ,p1.use -- 终端用途代码
    ,p1.comments -- 备注
    ,${iml_schema}.DATEFORMAT_MAX(p1.order_dt) -- 出单日期
    ,${iml_schema}.DATEFORMAT_MAX(p1.install_dt) -- 安装日期
    ,p1.dealwith -- 操作类型代码
    ,p1.term_area -- 终端安装地址
    ,p1.term_nm -- 终端名称
    ,p1.term_tel -- 装机电话
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||p1.term_sta end -- 终端状态代码
    ,p1.status -- 状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_direct_term_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_direct_term_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.term_type = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_DIRECT_TERM_INF'
        AND R1.SRC_FIELD_EN_NAME= 'term_type'
        AND R1.TARGET_TAB_EN_NAME= 'CHN_DIR_TERMN_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TERMN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.term_sta = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MRMS'
        AND R2.SRC_TAB_EN_NAME= 'MRMS_TBL_DIRECT_TERM_INF'
        AND R2.SRC_FIELD_EN_NAME= 'term_sta'
        AND R2.TARGET_TAB_EN_NAME= 'CHN_DIR_TERMN_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TERMN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.chn_dir_termn_info_h_mrmsf1_tm 
  	                                group by 
  	                                        chn_id
  	                                        ,seq_num
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
        into ${iml_schema}.chn_dir_termn_info_h_mrmsf1_cl(
            chn_id -- 直联终端编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,termn_id -- 终端编号
    ,termnl_id -- 终端机身编号
    ,mercht_id -- 商户编号
    ,mercht_seq_num -- 商户序号
    ,termn_type_cd -- 终端类型代码
    ,termn_usage_cd -- 终端用途代码
    ,remark -- 备注
    ,iss_dt -- 出单日期
    ,install_dt -- 安装日期
    ,oper_type_cd -- 操作类型代码
    ,termn_install_addr -- 终端安装地址
    ,termn_name -- 终端名称
    ,inst_tel -- 装机电话
    ,termn_status_cd -- 终端状态代码
    ,status_cd -- 状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.chn_dir_termn_info_h_mrmsf1_op(
            chn_id -- 直联终端编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,termn_id -- 终端编号
    ,termnl_id -- 终端机身编号
    ,mercht_id -- 商户编号
    ,mercht_seq_num -- 商户序号
    ,termn_type_cd -- 终端类型代码
    ,termn_usage_cd -- 终端用途代码
    ,remark -- 备注
    ,iss_dt -- 出单日期
    ,install_dt -- 安装日期
    ,oper_type_cd -- 操作类型代码
    ,termn_install_addr -- 终端安装地址
    ,termn_name -- 终端名称
    ,inst_tel -- 装机电话
    ,termn_status_cd -- 终端状态代码
    ,status_cd -- 状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.chn_id, o.chn_id) as chn_id -- 直联终端编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.termn_id, o.termn_id) as termn_id -- 终端编号
    ,nvl(n.termnl_id, o.termnl_id) as termnl_id -- 终端机身编号
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.mercht_seq_num, o.mercht_seq_num) as mercht_seq_num -- 商户序号
    ,nvl(n.termn_type_cd, o.termn_type_cd) as termn_type_cd -- 终端类型代码
    ,nvl(n.termn_usage_cd, o.termn_usage_cd) as termn_usage_cd -- 终端用途代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.iss_dt, o.iss_dt) as iss_dt -- 出单日期
    ,nvl(n.install_dt, o.install_dt) as install_dt -- 安装日期
    ,nvl(n.oper_type_cd, o.oper_type_cd) as oper_type_cd -- 操作类型代码
    ,nvl(n.termn_install_addr, o.termn_install_addr) as termn_install_addr -- 终端安装地址
    ,nvl(n.termn_name, o.termn_name) as termn_name -- 终端名称
    ,nvl(n.inst_tel, o.inst_tel) as inst_tel -- 装机电话
    ,nvl(n.termn_status_cd, o.termn_status_cd) as termn_status_cd -- 终端状态代码
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,case when
            n.chn_id is null
            and n.seq_num is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.chn_id is null
            and n.seq_num is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.chn_id is null
            and n.seq_num is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_dir_termn_info_h_mrmsf1_tm n
    full join (select * from ${iml_schema}.chn_dir_termn_info_h_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.chn_id = n.chn_id
            and o.seq_num = n.seq_num
            and o.lp_id = n.lp_id
where (
        o.chn_id is null
        and o.seq_num is null
        and o.lp_id is null
    )
    or (
        n.chn_id is null
        and n.seq_num is null
        and n.lp_id is null
    )
    or (
        o.termn_id <> n.termn_id
        or o.termnl_id <> n.termnl_id
        or o.mercht_id <> n.mercht_id
        or o.mercht_seq_num <> n.mercht_seq_num
        or o.termn_type_cd <> n.termn_type_cd
        or o.termn_usage_cd <> n.termn_usage_cd
        or o.remark <> n.remark
        or o.iss_dt <> n.iss_dt
        or o.install_dt <> n.install_dt
        or o.oper_type_cd <> n.oper_type_cd
        or o.termn_install_addr <> n.termn_install_addr
        or o.termn_name <> n.termn_name
        or o.inst_tel <> n.inst_tel
        or o.termn_status_cd <> n.termn_status_cd
        or o.status_cd <> n.status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.chn_dir_termn_info_h_mrmsf1_cl(
            chn_id -- 直联终端编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,termn_id -- 终端编号
    ,termnl_id -- 终端机身编号
    ,mercht_id -- 商户编号
    ,mercht_seq_num -- 商户序号
    ,termn_type_cd -- 终端类型代码
    ,termn_usage_cd -- 终端用途代码
    ,remark -- 备注
    ,iss_dt -- 出单日期
    ,install_dt -- 安装日期
    ,oper_type_cd -- 操作类型代码
    ,termn_install_addr -- 终端安装地址
    ,termn_name -- 终端名称
    ,inst_tel -- 装机电话
    ,termn_status_cd -- 终端状态代码
    ,status_cd -- 状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.chn_dir_termn_info_h_mrmsf1_op(
            chn_id -- 直联终端编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,termn_id -- 终端编号
    ,termnl_id -- 终端机身编号
    ,mercht_id -- 商户编号
    ,mercht_seq_num -- 商户序号
    ,termn_type_cd -- 终端类型代码
    ,termn_usage_cd -- 终端用途代码
    ,remark -- 备注
    ,iss_dt -- 出单日期
    ,install_dt -- 安装日期
    ,oper_type_cd -- 操作类型代码
    ,termn_install_addr -- 终端安装地址
    ,termn_name -- 终端名称
    ,inst_tel -- 装机电话
    ,termn_status_cd -- 终端状态代码
    ,status_cd -- 状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.chn_id -- 直联终端编号
    ,o.seq_num -- 序号
    ,o.lp_id -- 法人编号
    ,o.termn_id -- 终端编号
    ,o.termnl_id -- 终端机身编号
    ,o.mercht_id -- 商户编号
    ,o.mercht_seq_num -- 商户序号
    ,o.termn_type_cd -- 终端类型代码
    ,o.termn_usage_cd -- 终端用途代码
    ,o.remark -- 备注
    ,o.iss_dt -- 出单日期
    ,o.install_dt -- 安装日期
    ,o.oper_type_cd -- 操作类型代码
    ,o.termn_install_addr -- 终端安装地址
    ,o.termn_name -- 终端名称
    ,o.inst_tel -- 装机电话
    ,o.termn_status_cd -- 终端状态代码
    ,o.status_cd -- 状态代码
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
from ${iml_schema}.chn_dir_termn_info_h_mrmsf1_bk o
    left join ${iml_schema}.chn_dir_termn_info_h_mrmsf1_op n
        on
            o.chn_id = n.chn_id
            and o.seq_num = n.seq_num
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.chn_dir_termn_info_h_mrmsf1_cl d
        on
            o.chn_id = d.chn_id
            and o.seq_num = d.seq_num
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.chn_dir_termn_info_h;
--alter table ${iml_schema}.chn_dir_termn_info_h truncate partition for ('mrmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('chn_dir_termn_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.chn_dir_termn_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.chn_dir_termn_info_h modify partition p_mrmsf1 
add subpartition p_mrmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.chn_dir_termn_info_h exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_cl;
alter table ${iml_schema}.chn_dir_termn_info_h exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.chn_dir_termn_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_op purge;
drop table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.chn_dir_termn_info_h_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'chn_dir_termn_info_h', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
