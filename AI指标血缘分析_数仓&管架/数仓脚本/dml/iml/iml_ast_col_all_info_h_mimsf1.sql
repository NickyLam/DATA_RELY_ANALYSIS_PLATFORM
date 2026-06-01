/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_all_info_h_mimsf1
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
alter table ${iml_schema}.ast_col_all_info_h add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mimsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_all_info_h_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_all_info_h partition for ('mimsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_col_all_info_h_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_all_info_h_mimsf1_op purge;
drop table ${iml_schema}.ast_col_all_info_h_mimsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_all_info_h_mimsf1_tm nologging
compress ${option_switch} for query high
as select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,all_cust_id -- 所有人客户编号
    ,col_all_type_cd -- 押品所有人类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pmo_obg_brwer_rela_cd -- 抵质押品权利人与借款人关系代码
    ,col_belong_ps_trdpty_flg -- 押品权属人为第三方标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_all_info_h partition for ('mimsf1')
where 0=1
;

create table ${iml_schema}.ast_col_all_info_h_mimsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_all_info_h partition for ('mimsf1') where 0=1;

create table ${iml_schema}.ast_col_all_info_h_mimsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_all_info_h partition for ('mimsf1') where 0=1;

-- 3.1 get new data into table
-- mims_si_ownerinfo-
insert into ${iml_schema}.ast_col_all_info_h_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,all_cust_id -- 所有人客户编号
    ,col_all_type_cd -- 押品所有人类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pmo_obg_brwer_rela_cd -- 抵质押品权利人与借款人关系代码
    ,col_belong_ps_trdpty_flg	-- 押品权属人为第三方标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 序号
    ,NVL(TRIM(P2.CORECUSTID),NVL(P1.OWNER,' ')) -- 所有人客户编号
    ,nvl(TRIM(P1.OWNERTYPE),'00') -- 押品所有人类型代码
    ,decode(trim(P1.CARDTYPE),'','0000','null','0000',P1.CARDTYPE) -- 证件类型代码
    ,P1.CARDID -- 证件号码
    ,NVL(TRIM(P1.RELATN),'00') -- 抵质押品权利人与借款人关系代码
    ,NVL(TRIM(P1.OWNERTRDPTYIND),'-') -- 押品权属人为第三方标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_ownerinfo' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_ownerinfo p1
    left join ${iol_schema}.mims_ci_custinfo p2 on P1.OWNER = P2.CUSTID
and P2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P2.end_dt > to_date('${batch_date}','yyyymmdd')

where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_all_info_h_mimsf1_tm 
  	                                group by 
  	                                        asset_id
  	                                        ,lp_id
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
        into ${iml_schema}.ast_col_all_info_h_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,all_cust_id -- 所有人客户编号
    ,col_all_type_cd -- 押品所有人类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pmo_obg_brwer_rela_cd -- 抵质押品权利人与借款人关系代码
    ,col_belong_ps_trdpty_flg	-- 押品权属人为第三方标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_all_info_h_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,all_cust_id -- 所有人客户编号
    ,col_all_type_cd -- 押品所有人类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pmo_obg_brwer_rela_cd -- 抵质押品权利人与借款人关系代码
    ,col_belong_ps_trdpty_flg	-- 押品权属人为第三方标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.all_cust_id, o.all_cust_id) as all_cust_id -- 所有人客户编号
    ,nvl(n.col_all_type_cd, o.col_all_type_cd) as col_all_type_cd -- 押品所有人类型代码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.pmo_obg_brwer_rela_cd, o.pmo_obg_brwer_rela_cd) as pmo_obg_brwer_rela_cd -- 抵质押品权利人与借款人关系代码
    ,nvl(n.col_belong_ps_trdpty_flg, o.col_belong_ps_trdpty_flg) as col_belong_ps_trdpty_flg -- 押品权属人为第三方标志
    ,case when
            n.asset_id is null
            and n.lp_id is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_all_info_h_mimsf1_tm n
    full join (select * from ${iml_schema}.ast_col_all_info_h_mimsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
where (
        o.asset_id is null
        and o.lp_id is null
        and o.seq_num is null
    )
    or (
        n.asset_id is null
        and n.lp_id is null
        and n.seq_num is null
    )
    or (
        o.all_cust_id <> n.all_cust_id
        or o.col_all_type_cd <> n.col_all_type_cd
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.pmo_obg_brwer_rela_cd <> n.pmo_obg_brwer_rela_cd
         or o.col_belong_ps_trdpty_flg <> n.col_belong_ps_trdpty_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_all_info_h_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,all_cust_id -- 所有人客户编号
    ,col_all_type_cd -- 押品所有人类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pmo_obg_brwer_rela_cd -- 抵质押品权利人与借款人关系代码
    ,col_belong_ps_trdpty_flg -- 押品权属人为第三方标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_all_info_h_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,all_cust_id -- 所有人客户编号
    ,col_all_type_cd -- 押品所有人类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,pmo_obg_brwer_rela_cd -- 抵质押品权利人与借款人关系代码
    ,col_belong_ps_trdpty_flg -- 押品权属人为第三方标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.asset_id -- 资产编号
    ,o.lp_id -- 法人编号
    ,o.seq_num -- 序号
    ,o.all_cust_id -- 所有人客户编号
    ,o.col_all_type_cd -- 押品所有人类型代码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.pmo_obg_brwer_rela_cd -- 抵质押品权利人与借款人关系代码
    ,o.col_belong_ps_trdpty_flg -- 押品权属人为第三方标志
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
from ${iml_schema}.ast_col_all_info_h_mimsf1_bk o
    left join ${iml_schema}.ast_col_all_info_h_mimsf1_op n
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_col_all_info_h_mimsf1_cl d
        on
            o.asset_id = d.asset_id
            and o.lp_id = d.lp_id
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_col_all_info_h;
--alter table ${iml_schema}.ast_col_all_info_h truncate partition for ('mimsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ast_col_all_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mimsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ast_col_all_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ast_col_all_info_h modify partition p_mimsf1 
add subpartition p_mimsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ast_col_all_info_h exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_all_info_h_mimsf1_cl;
alter table ${iml_schema}.ast_col_all_info_h exchange subpartition p_mimsf1_20991231 with table ${iml_schema}.ast_col_all_info_h_mimsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_all_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_all_info_h_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_all_info_h_mimsf1_op purge;
drop table ${iml_schema}.ast_col_all_info_h_mimsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_col_all_info_h_mimsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_all_info_h', partname => 'p_mimsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
