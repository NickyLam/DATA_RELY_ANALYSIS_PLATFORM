/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_inpwn_prod_mgmt_info_h_famsf1
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
alter table ${iml_schema}.prd_inpwn_prod_mgmt_info_h add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_famsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_inpwn_prod_mgmt_info_h partition for ('famsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_tm purge;
drop table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_op purge;
drop table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_tm nologging
compress ${option_switch} for query high
as select
    prod_pk -- 产品主键
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,pmo_type_descb -- 抵质押物类型描述
    ,pmo_acct_num -- 抵质押物账号
    ,pmo_evltion_amt -- 抵质押物估值金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,evltion_dt -- 估值日期
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_inpwn_prod_mgmt_info_h partition for ('famsf1')
where 0=1
;

create table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_inpwn_prod_mgmt_info_h partition for ('famsf1') where 0=1;

create table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_inpwn_prod_mgmt_info_h partition for ('famsf1') where 0=1;

-- 3.1 get new data into table
-- fams_fin_product_pledge-
insert into ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_tm(
    prod_pk -- 产品主键
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,pmo_type_descb -- 抵质押物类型描述
    ,pmo_acct_num -- 抵质押物账号
    ,pmo_evltion_amt -- 抵质押物估值金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,evltion_dt -- 估值日期
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 产品主键
    ,'9999' -- 法人编号
    ,P1.FINPROD_ID -- 金融产品编号
    ,P1.PLEDGE_TYPE -- 抵质押物类型描述
    ,P1.PLEDGE_ID -- 抵质押物账号
    ,P1.PLEDGE_AMT -- 抵质押物估值金额
    ,P1.VDATE -- 起息日期
    ,P1.MDATE -- 到期日期
    ,P1.VAL_DATE -- 估值日期
    ,P1.CREATE_TIME -- 创建时间
    ,P1.UPDATE_TIME -- 更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_fin_product_pledge' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_product_pledge p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_tm 
  	                                group by 
  	                                        prod_pk
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
        into ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_cl(
            prod_pk -- 产品主键
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,pmo_type_descb -- 抵质押物类型描述
    ,pmo_acct_num -- 抵质押物账号
    ,pmo_evltion_amt -- 抵质押物估值金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,evltion_dt -- 估值日期
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_op(
            prod_pk -- 产品主键
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,pmo_type_descb -- 抵质押物类型描述
    ,pmo_acct_num -- 抵质押物账号
    ,pmo_evltion_amt -- 抵质押物估值金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,evltion_dt -- 估值日期
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_pk, o.prod_pk) as prod_pk -- 产品主键
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.fin_prod_id, o.fin_prod_id) as fin_prod_id -- 金融产品编号
    ,nvl(n.pmo_type_descb, o.pmo_type_descb) as pmo_type_descb -- 抵质押物类型描述
    ,nvl(n.pmo_acct_num, o.pmo_acct_num) as pmo_acct_num -- 抵质押物账号
    ,nvl(n.pmo_evltion_amt, o.pmo_evltion_amt) as pmo_evltion_amt -- 抵质押物估值金额
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.evltion_dt, o.evltion_dt) as evltion_dt -- 估值日期
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,case when
            n.prod_pk is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_pk is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_pk is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_tm n
    full join (select * from ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_pk = n.prod_pk
            and o.lp_id = n.lp_id
where (
        o.prod_pk is null
        and o.lp_id is null
    )
    or (
        n.prod_pk is null
        and n.lp_id is null
    )
    or (
        o.fin_prod_id <> n.fin_prod_id
        or o.pmo_type_descb <> n.pmo_type_descb
        or o.pmo_acct_num <> n.pmo_acct_num
        or o.pmo_evltion_amt <> n.pmo_evltion_amt
        or o.value_dt <> n.value_dt
        or o.exp_dt <> n.exp_dt
        or o.evltion_dt <> n.evltion_dt
        or o.create_tm <> n.create_tm
        or o.update_tm <> n.update_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_cl(
            prod_pk -- 产品主键
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,pmo_type_descb -- 抵质押物类型描述
    ,pmo_acct_num -- 抵质押物账号
    ,pmo_evltion_amt -- 抵质押物估值金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,evltion_dt -- 估值日期
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_op(
            prod_pk -- 产品主键
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,pmo_type_descb -- 抵质押物类型描述
    ,pmo_acct_num -- 抵质押物账号
    ,pmo_evltion_amt -- 抵质押物估值金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,evltion_dt -- 估值日期
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_pk -- 产品主键
    ,o.lp_id -- 法人编号
    ,o.fin_prod_id -- 金融产品编号
    ,o.pmo_type_descb -- 抵质押物类型描述
    ,o.pmo_acct_num -- 抵质押物账号
    ,o.pmo_evltion_amt -- 抵质押物估值金额
    ,o.value_dt -- 起息日期
    ,o.exp_dt -- 到期日期
    ,o.evltion_dt -- 估值日期
    ,o.create_tm -- 创建时间
    ,o.update_tm -- 更新时间
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
from ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_bk o
    left join ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_op n
        on
            o.prod_pk = n.prod_pk
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_cl d
        on
            o.prod_pk = d.prod_pk
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_inpwn_prod_mgmt_info_h;
--alter table ${iml_schema}.prd_inpwn_prod_mgmt_info_h truncate partition for ('famsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_inpwn_prod_mgmt_info_h') 
               and substr(subpartition_name,1,8)=upper('p_famsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_inpwn_prod_mgmt_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_inpwn_prod_mgmt_info_h modify partition p_famsf1 
add subpartition p_famsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_inpwn_prod_mgmt_info_h exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_cl;
alter table ${iml_schema}.prd_inpwn_prod_mgmt_info_h exchange subpartition p_famsf1_20991231 with table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_inpwn_prod_mgmt_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_tm purge;
drop table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_op purge;
drop table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_inpwn_prod_mgmt_info_h_famsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_inpwn_prod_mgmt_info_h', partname => 'p_famsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
