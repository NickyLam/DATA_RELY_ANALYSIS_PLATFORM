/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_tax_item_info_h_tglsf1
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
alter table ${iml_schema}.fin_tax_item_info_h add partition p_tglsf1 values ('tglsf1')(
        subpartition p_tglsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_tglsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.fin_tax_item_info_h_tglsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_tax_item_info_h partition for ('tglsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.fin_tax_item_info_h_tglsf1_tm purge;
drop table ${iml_schema}.fin_tax_item_info_h_tglsf1_op purge;
drop table ${iml_schema}.fin_tax_item_info_h_tglsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_tax_item_info_h_tglsf1_tm nologging
compress ${option_switch} for query high
as select
    tax_item_id -- 税目编号
    ,lp_id -- 法人编号
    ,tax_item_name -- 税目名称
    ,tax_rat -- 税率
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tax_item_status_cd -- 税目状态代码
    ,remark -- 备注
    ,dedu_idf_cd -- 可抵扣标识代码
    ,taxable_idf_cd -- 应税标识代码
    ,tax_way_cd -- 计税方式代码
    ,open_invoice_type_cd -- 开票类型代码
    ,item_type_cd -- 进销项类型代码
    ,tax_cls_id -- 税收分类编号
    ,free_tax_id -- 免税编号
    ,merchd_serv_name -- 商品服务名称
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_tax_item_info_h partition for ('tglsf1')
where 0=1
;

create table ${iml_schema}.fin_tax_item_info_h_tglsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_tax_item_info_h partition for ('tglsf1') where 0=1;

create table ${iml_schema}.fin_tax_item_info_h_tglsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_tax_item_info_h partition for ('tglsf1') where 0=1;

-- 3.1 get new data into table
-- tgls_com_txtp-1
insert into ${iml_schema}.fin_tax_item_info_h_tglsf1_tm(
    tax_item_id -- 税目编号
    ,lp_id -- 法人编号
    ,tax_item_name -- 税目名称
    ,tax_rat -- 税率
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tax_item_status_cd -- 税目状态代码
    ,remark -- 备注
    ,dedu_idf_cd -- 可抵扣标识代码
    ,taxable_idf_cd -- 应税标识代码
    ,tax_way_cd -- 计税方式代码
    ,open_invoice_type_cd -- 开票类型代码
    ,item_type_cd -- 进销项类型代码
    ,tax_cls_id -- 税收分类编号
    ,free_tax_id -- 免税编号
    ,merchd_serv_name -- 商品服务名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.TYPECD -- 税目编号
    ,'9999' -- 法人编号
    ,P1.TYPENA -- 税目名称
    ,P1.VATXRT -- 税率
    ,${iml_schema}.dateformat_min(P1.FROMDT) -- 生效日期
    ,${iml_schema}.dateformat_max2(P1.ENDDDT) -- 失效日期
    ,P1.STATUS -- 税目状态代码
    ,P1.SMRYTX -- 备注
    ,P1.DEDUTG -- 可抵扣标识代码
    ,P1.EXEPTG -- 应税标识代码
    ,decode(trim(P1.CATXTP),'','-','N','0','S','1',P1.CATXTP) -- 计税方式代码
    ,decode(P1.MAKETP,'CM','0','SP','1','NO','2','NV','3',nvl(trim(P1.MAKETP),'-')) -- 开票类型代码
    ,P1.VATXTP -- 进销项类型代码
    ,P1.GDSVCD -- 税收分类编号
    ,P1.DUTYCD -- 免税编号
    ,P1.PRODUCTSENA -- 商品服务名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_com_txtp' -- 源表名称
    ,'tglsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_com_txtp p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.fin_tax_item_info_h_tglsf1_tm 
  	                                group by 
  	                                        tax_item_id
  	                                        ,lp_id
  	                                        ,effect_dt
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
        into ${iml_schema}.fin_tax_item_info_h_tglsf1_cl(
            tax_item_id -- 税目编号
    ,lp_id -- 法人编号
    ,tax_item_name -- 税目名称
    ,tax_rat -- 税率
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tax_item_status_cd -- 税目状态代码
    ,remark -- 备注
    ,dedu_idf_cd -- 可抵扣标识代码
    ,taxable_idf_cd -- 应税标识代码
    ,tax_way_cd -- 计税方式代码
    ,open_invoice_type_cd -- 开票类型代码
    ,item_type_cd -- 进销项类型代码
    ,tax_cls_id -- 税收分类编号
    ,free_tax_id -- 免税编号
    ,merchd_serv_name -- 商品服务名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_tax_item_info_h_tglsf1_op(
            tax_item_id -- 税目编号
    ,lp_id -- 法人编号
    ,tax_item_name -- 税目名称
    ,tax_rat -- 税率
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tax_item_status_cd -- 税目状态代码
    ,remark -- 备注
    ,dedu_idf_cd -- 可抵扣标识代码
    ,taxable_idf_cd -- 应税标识代码
    ,tax_way_cd -- 计税方式代码
    ,open_invoice_type_cd -- 开票类型代码
    ,item_type_cd -- 进销项类型代码
    ,tax_cls_id -- 税收分类编号
    ,free_tax_id -- 免税编号
    ,merchd_serv_name -- 商品服务名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tax_item_id, o.tax_item_id) as tax_item_id -- 税目编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tax_item_name, o.tax_item_name) as tax_item_name -- 税目名称
    ,nvl(n.tax_rat, o.tax_rat) as tax_rat -- 税率
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.tax_item_status_cd, o.tax_item_status_cd) as tax_item_status_cd -- 税目状态代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.dedu_idf_cd, o.dedu_idf_cd) as dedu_idf_cd -- 可抵扣标识代码
    ,nvl(n.taxable_idf_cd, o.taxable_idf_cd) as taxable_idf_cd -- 应税标识代码
    ,nvl(n.tax_way_cd, o.tax_way_cd) as tax_way_cd -- 计税方式代码
    ,nvl(n.open_invoice_type_cd, o.open_invoice_type_cd) as open_invoice_type_cd -- 开票类型代码
    ,nvl(n.item_type_cd, o.item_type_cd) as item_type_cd -- 进销项类型代码
    ,nvl(n.tax_cls_id, o.tax_cls_id) as tax_cls_id -- 税收分类编号
    ,nvl(n.free_tax_id, o.free_tax_id) as free_tax_id -- 免税编号
    ,nvl(n.merchd_serv_name, o.merchd_serv_name) as merchd_serv_name -- 商品服务名称
    ,case when
            n.tax_item_id is null
            and n.lp_id is null
            and n.effect_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tax_item_id is null
            and n.lp_id is null
            and n.effect_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tax_item_id is null
            and n.lp_id is null
            and n.effect_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_tax_item_info_h_tglsf1_tm n
    full join (select * from ${iml_schema}.fin_tax_item_info_h_tglsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.tax_item_id = n.tax_item_id
            and o.lp_id = n.lp_id
            and o.effect_dt = n.effect_dt
where (
        o.tax_item_id is null
        and o.lp_id is null
        and o.effect_dt is null
    )
    or (
        n.tax_item_id is null
        and n.lp_id is null
        and n.effect_dt is null
    )
    or (
        o.tax_item_name <> n.tax_item_name
        or o.tax_rat <> n.tax_rat
        or o.invalid_dt <> n.invalid_dt
        or o.tax_item_status_cd <> n.tax_item_status_cd
        or o.remark <> n.remark
        or o.dedu_idf_cd <> n.dedu_idf_cd
        or o.taxable_idf_cd <> n.taxable_idf_cd
        or o.tax_way_cd <> n.tax_way_cd
        or o.open_invoice_type_cd <> n.open_invoice_type_cd
        or o.item_type_cd <> n.item_type_cd
        or o.tax_cls_id <> n.tax_cls_id
        or o.free_tax_id <> n.free_tax_id
        or o.merchd_serv_name <> n.merchd_serv_name
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.fin_tax_item_info_h_tglsf1_cl(
            tax_item_id -- 税目编号
    ,lp_id -- 法人编号
    ,tax_item_name -- 税目名称
    ,tax_rat -- 税率
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tax_item_status_cd -- 税目状态代码
    ,remark -- 备注
    ,dedu_idf_cd -- 可抵扣标识代码
    ,taxable_idf_cd -- 应税标识代码
    ,tax_way_cd -- 计税方式代码
    ,open_invoice_type_cd -- 开票类型代码
    ,item_type_cd -- 进销项类型代码
    ,tax_cls_id -- 税收分类编号
    ,free_tax_id -- 免税编号
    ,merchd_serv_name -- 商品服务名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_tax_item_info_h_tglsf1_op(
            tax_item_id -- 税目编号
    ,lp_id -- 法人编号
    ,tax_item_name -- 税目名称
    ,tax_rat -- 税率
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tax_item_status_cd -- 税目状态代码
    ,remark -- 备注
    ,dedu_idf_cd -- 可抵扣标识代码
    ,taxable_idf_cd -- 应税标识代码
    ,tax_way_cd -- 计税方式代码
    ,open_invoice_type_cd -- 开票类型代码
    ,item_type_cd -- 进销项类型代码
    ,tax_cls_id -- 税收分类编号
    ,free_tax_id -- 免税编号
    ,merchd_serv_name -- 商品服务名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tax_item_id -- 税目编号
    ,o.lp_id -- 法人编号
    ,o.tax_item_name -- 税目名称
    ,o.tax_rat -- 税率
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.tax_item_status_cd -- 税目状态代码
    ,o.remark -- 备注
    ,o.dedu_idf_cd -- 可抵扣标识代码
    ,o.taxable_idf_cd -- 应税标识代码
    ,o.tax_way_cd -- 计税方式代码
    ,o.open_invoice_type_cd -- 开票类型代码
    ,o.item_type_cd -- 进销项类型代码
    ,o.tax_cls_id -- 税收分类编号
    ,o.free_tax_id -- 免税编号
    ,o.merchd_serv_name -- 商品服务名称
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
from ${iml_schema}.fin_tax_item_info_h_tglsf1_bk o
    left join ${iml_schema}.fin_tax_item_info_h_tglsf1_op n
        on
            o.tax_item_id = n.tax_item_id
            and o.lp_id = n.lp_id
            and o.effect_dt = n.effect_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.fin_tax_item_info_h_tglsf1_cl d
        on
            o.tax_item_id = d.tax_item_id
            and o.lp_id = d.lp_id
            and o.effect_dt = d.effect_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.fin_tax_item_info_h;
--alter table ${iml_schema}.fin_tax_item_info_h truncate partition for ('tglsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('fin_tax_item_info_h') 
               and substr(subpartition_name,1,8)=upper('p_tglsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.fin_tax_item_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.fin_tax_item_info_h modify partition p_tglsf1 
add subpartition p_tglsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.fin_tax_item_info_h exchange subpartition p_tglsf1_${batch_date} with table ${iml_schema}.fin_tax_item_info_h_tglsf1_cl;
alter table ${iml_schema}.fin_tax_item_info_h exchange subpartition p_tglsf1_20991231 with table ${iml_schema}.fin_tax_item_info_h_tglsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_tax_item_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.fin_tax_item_info_h_tglsf1_tm purge;
drop table ${iml_schema}.fin_tax_item_info_h_tglsf1_op purge;
drop table ${iml_schema}.fin_tax_item_info_h_tglsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.fin_tax_item_info_h_tglsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_tax_item_info_h', partname => 'p_tglsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
